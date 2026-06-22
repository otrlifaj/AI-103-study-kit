# Tahák: Python pro C# vývojáře — Azure AI SDK (AI-103)

> **K čemu to je:** u zkoušky čteš snippety v **Pythonu**, laby píšeš v **C#**. Tady máš obojí vedle sebe
> pro 5 klíčových operací: **auth → klient → chat completion → deployment → embeddings/RAG → tool/function calling**.
> Plus dole rychlý „Python syntax pro C# oko".
>
> **Caveat (čti):** SDK pro Foundry se rychle vyvíjí — *názvy balíčků/tříd/metod se mezi verzemi mění*.
> Proto je tahák postavený na **stabilní vrstvě Azure OpenAI klienta** (`AzureOpenAIClient` / `openai.AzureOpenAI`),
> kterou většina exam snippetů používá, a navíc ukazuje vstupní bod přes **Foundry projekt** (`AIProjectClient`).
> Konkrétní `api-version` a názvy metod si u ostrého labu ověř proti aktuálnímu SDK.

---

## 0. Mapování balíčků (NuGet ↔ pip)

| Účel | C# / NuGet | Python / pip |
|---|---|---|
| Identita (keyless) | `Azure.Identity` | `azure-identity` |
| Foundry projekt | `Azure.AI.Projects` | `azure-ai-projects` |
| Azure OpenAI klient | `Azure.AI.OpenAI` (+ `OpenAI`) | `openai` |
| Agent Service | `Azure.AI.Agents.Persistent` | `azure-ai-agents` *(nebo přes `azure-ai-projects`)* |
| (starší inference) | `Azure.AI.Inference` ⚠️ deprecating | `azure-ai-inference` ⚠️ deprecating |
| AI Search (RAG) | `Azure.Search.Documents` | `azure-search-documents` |

> ⚠️ Trend 2025/26: odklon od `azure-ai-inference` (`ChatCompletionsClient`/`EmbeddingsClient`) směrem k **OpenAI klientovi**.
> Pořád ale můžeš v exam materiálech narazit na `ChatCompletionsClient` — viz pozn. u sekce 2.

**Tvoje prostředí** (z [azure-config.md](../azure-config.md), vyplní `/setup`):
- Account/OpenAI endpoint: `https://<foundry-resource>.cognitiveservices.azure.com/` (funguje i alias `…openai.azure.com/`)
- Foundry project endpoint: `https://<foundry-resource>.services.ai.azure.com/api/projects/<project-name>`
- Deployment: `<chat-deployment>` (např. `gpt-4o`)

---

## 1. Auth (keyless) + vytvoření klienta

**Princip:** `DefaultAzureCredential` vezme token z `az login` (lokálně) / managed identity (v Azure). Žádný klíč.
Token scope pro data-plane: `https://cognitiveservices.azure.com/.default`.

### A) Přímo Azure OpenAI klient (nejčastější v snippetech)

**C#**
```csharp
using Azure.AI.OpenAI;
using Azure.Identity;

var endpoint = new Uri("https://<foundry-resource>.cognitiveservices.azure.com/");
var azureClient = new AzureOpenAIClient(endpoint, new DefaultAzureCredential());
```

**Python**
```python
from openai import AzureOpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

token_provider = get_bearer_token_provider(
    DefaultAzureCredential(), "https://cognitiveservices.azure.com/.default"
)
client = AzureOpenAI(
    azure_endpoint="https://<foundry-resource>.cognitiveservices.azure.com/",
    azure_ad_token_provider=token_provider,   # keyless; jinak api_key=...
    api_version="2024-10-21",
)
```
> 🐍 **C# pohled:** `get_bearer_token_provider(...)` vrací *funkci* (delegát), kterou klient volá pro čerstvý token.
> V C# to `AzureOpenAIClient` řeší interně, tady to předáváš explicitně.

### B) Přes Foundry projekt (`AIProjectClient`) — „project-first" cesta

**C#**
```csharp
using Azure.AI.Projects;
using Azure.Identity;

var projectEndpoint = new Uri("https://<foundry-resource>.services.ai.azure.com/api/projects/<project-name>");
var project = new AIProjectClient(projectEndpoint, new DefaultAzureCredential());
// z projektu si vytáhneš OpenAI klienta (přesný název metody závisí na verzi SDK)
```

**Python**
```python
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential

project = AIProjectClient(
    endpoint="https://<foundry-resource>.services.ai.azure.com/api/projects/<project-name>",
    credential=DefaultAzureCredential(),
)
client = project.get_openai_client(api_version="2024-10-21")  # vrátí AzureOpenAI klienta
```
> **Kdy A vs. B:** A = znáš endpoint + deployment, jdeš rovnou na model. B = chceš pracovat s *projektem*
> (connections, agents, indexy, evaluace) — Foundry „obal" kolem účtu. Exam scénáře u nového Foundry tlačí B.

---

## 2. Chat completion (system + user, temperature)

**C#**
```csharp
using OpenAI.Chat;

ChatClient chat = azureClient.GetChatClient("gpt-4o");   // "gpt-4o" = NÁZEV DEPLOYMENTU, ne modelu

ChatCompletion completion = chat.CompleteChat(
    new ChatMessage[]
    {
        new SystemChatMessage("Jsi stručný asistent pro AI-103."),
        new UserChatMessage("Vyjmenuj domény zkoušky."),
    },
    new ChatCompletionOptions { Temperature = 0.3f });

Console.WriteLine(completion.Content[0].Text);
```

**Python**
```python
resp = client.chat.completions.create(
    model="gpt-4o",                       # = název DEPLOYMENTU
    messages=[
        {"role": "system", "content": "Jsi stručný asistent pro AI-103."},
        {"role": "user",   "content": "Vyjmenuj domény zkoušky."},
    ],
    temperature=0.3,
)
print(resp.choices[0].message.content)
```
> 🐍 **Mapování:** C# `SystemChatMessage/UserChatMessage` ↔ Python `{"role": "...", "content": "..."}` dict.
> C# `completion.Content[0].Text` ↔ Python `resp.choices[0].message.content`.
>
> **Gotcha:** `model=` / `GetChatClient(...)` bere **název deploymentu**, ne `gpt-4o` jako model family.
> (Často se deployment jmenuje stejně jako model, např. `gpt-4o` — ale je to volba při nasazení.)
>
> ⚠️ **Starší inference SDK** (můžeš vidět v materiálech): C# `ChatCompletionsClient.Complete(...)`,
> Python `ChatCompletionsClient.complete(...)` z `azure-ai-inference`, zprávy jako
> `SystemMessage(...)/UserMessage(...)`. Funkčně totéž, jiná třída.

---

## 3. Deployment modelu (jazykově neutrální — az CLI)

Nasazení modelu se NEdělá z chat SDK; je to **management operace** (az CLI / portál / ARM/Bicep):

```bash
az cognitiveservices account deployment create \
  --name <foundry-resource> --resource-group <resource-group> \
  --deployment-name gpt-4o \
  --model-name gpt-4o --model-version 2024-11-20 --model-format OpenAI \
  --sku-name GlobalStandard --sku-capacity 50
```
> **Pro zkoušku:** rozliš **deployment name** (volíš ty, používá se v kódu) vs. **model name+version** (z katalogu).
> SKU: `Standard` (regionální) vs. `GlobalStandard` (globální kapacita) vs. `DataZoneStandard` (datová zóna).

---

## 4. Embeddings + RAG

### 4a. Embeddings (potřeba pro vektorové hledání)

**C#**
```csharp
using OpenAI.Embeddings;

EmbeddingClient emb = azureClient.GetEmbeddingClient("text-embedding-3-small");
OpenAIEmbedding e = emb.GenerateEmbedding("Text k zavektorování.");
ReadOnlyMemory<float> vector = e.ToFloats();
```

**Python**
```python
e = client.embeddings.create(
    model="text-embedding-3-small",
    input="Text k zavektorování.",
)
vector = e.data[0].embedding          # list[float]
```
> ⚠️ Embeddings model musí být **nasazený zvlášť** — před RAG labem nasaď `text-embedding-3-small` (viz `/provision-ahead`).

### 4b. RAG — tvar řešení (konceptuálně)

Dvě cesty, obě zkouškové:
1. **Vlastní retrieval:** embeddings → vektorové hledání (Azure AI Search / lokální index) → top-k chunky
   vložíš do `system`/`user` zprávy jako kontext → model odpovídá *grounded* + cituje.
2. **„On Your Data" / AI Search data source:** modelu předáš referenci na **Azure AI Search index**
   a grounding/citace řeší služba za tebe (přes `data_sources` rozšíření chat requestu).

```text
[dotaz] → embed → search index → relevantní pasáže
        → "Odpověz JEN z těchto zdrojů: <pasáže>" → chat completion → odpověď + citace
```
> **Rozhodovací pravidlo:** potřebuješ vlastní chunking/skóre → cesta 1. Chceš to rychle a integrovaně,
> data už jsou v AI Search → cesta 2. Vždy řeš: index, embeddings model, citace, „answer only from sources".

---

## 5. Tool / function calling

**Vzor:** definuješ tool (JSON schema) → model vrátí `tool_call` s argumenty → **ty** spustíš funkci →
výsledek pošleš zpět jako `tool` zprávu → druhý call vrátí finální odpověď.

**C#**
```csharp
using OpenAI.Chat;
using System.Text.Json;

ChatTool weatherTool = ChatTool.CreateFunctionTool(
    functionName: "get_weather",
    functionDescription: "Vrátí počasí pro lokalitu",
    functionParameters: BinaryData.FromString("""
    {"type":"object",
     "properties":{"location":{"type":"string","description":"Město"}},
     "required":["location"]}
    """));

var messages = new List<ChatMessage> { new UserChatMessage("Jaké je počasí v Praze?") };
var options = new ChatCompletionOptions { Tools = { weatherTool } };

ChatCompletion completion = chat.CompleteChat(messages, options);

if (completion.FinishReason == ChatFinishReason.ToolCalls)
{
    foreach (ChatToolCall call in completion.ToolCalls)
    {
        string args = call.FunctionArguments.ToString();           // JSON s argumenty
        string result = GetWeather(/* parse args */);              // tvoje funkce
        messages.Add(new AssistantChatMessage(completion));        // zapiš požadavek modelu
        messages.Add(new ToolChatMessage(call.Id, result));        // a výsledek
    }
    ChatCompletion final = chat.CompleteChat(messages, options);
    Console.WriteLine(final.Content[0].Text);
}
```

**Python**
```python
import json

tools = [{
    "type": "function",
    "function": {
        "name": "get_weather",
        "description": "Vrátí počasí pro lokalitu",
        "parameters": {
            "type": "object",
            "properties": {"location": {"type": "string", "description": "Město"}},
            "required": ["location"],
        },
    },
}]

messages = [{"role": "user", "content": "Jaké je počasí v Praze?"}]
resp = client.chat.completions.create(model="gpt-4o", messages=messages, tools=tools)

msg = resp.choices[0].message
if msg.tool_calls:
    for call in msg.tool_calls:
        args = json.loads(call.function.arguments)
        result = get_weather(**args)                 # tvoje funkce
        messages.append(msg)                         # požadavek modelu
        messages.append({                            # výsledek toolu
            "role": "tool",
            "tool_call_id": call.id,
            "content": result,
        })
    final = client.chat.completions.create(model="gpt-4o", messages=messages)
    print(final.choices[0].message.content)
```
> 🐍 **Mapování:** C# `ChatTool.CreateFunctionTool(...)` ↔ Python tool dict. C# `completion.ToolCalls[i].FunctionArguments`
> ↔ Python `msg.tool_calls[i].function.arguments` (JSON string → `json.loads`). C# `ToolChatMessage(id, result)`
> ↔ Python `{"role":"tool","tool_call_id":id,"content":result}`.
>
> **Agent Service varianta (pro Path 2):** místo ručního loop-u definuješ funkci jako tool agenta
> (C# `FunctionToolDefinition` + `PersistentAgentsClient`; Python `FunctionTool` + agents) a běh/threads řídí služba.
> Princip „model navrhne volání → ty vykonáš → vrátíš výsledek" je stejný.

---

## Python syntax pro C# oko (rychlý překladač)

| Koncept | C# | Python |
|---|---|---|
| Bloky | `{ }` | **odsazení** (4 mezery), za hlavičkou `:` |
| Pojmenování | `PascalCase` / `camelCase` | `snake_case` |
| null / pravda | `null` / `true` / `false` | `None` / `True` / `False` |
| Proměnná | `var x = 5;` | `x = 5` (bez typu, bez `;`) |
| String interpolace | `$"Ahoj {name}"` | `f"Ahoj {name}"` |
| Seznam | `new List<int>{1,2}` | `[1, 2]` |
| Dict / objekt | `new Dictionary<,>` / DTO | `{"key": "val"}` (přímo JSON-like) |
| Pojmenované argumenty | `Foo(name: x)` | `foo(name=x)` |
| Async | `await FooAsync()` | `await foo()` (v `async def`) |
| Using/Dispose | `using var c = ...;` | `with client as c:` |
| Null-coalescing | `x ?? y` | `x or y` (pozor: jiná sémantika u 0/""/[]) |
| Komentář | `//` | `#` |
| Import | `using Azure.Identity;` | `from azure.identity import DefaultAzureCredential` |

> **Tři nejčastější chytáky při čtení:** (1) **odsazení = struktura** (ne `{}`); (2) **`self`** je první parametr
> metod tříd (≈ `this`, ale píše se explicitně); (3) **`dict`/`list` literály** jsou přímo to, co v C# řešíš
> přes objekty/kolekce — proto Python AI snippety vypadají „kratší".

---

## Odkazy
- Azure OpenAI klient (.NET): NuGet `Azure.AI.OpenAI` · (Python) `openai` + `AzureOpenAI`
- Foundry projekt SDK: `Azure.AI.Projects` / `azure-ai-projects`
- DefaultAzureCredential: `Azure.Identity` / `azure-identity`
- Function calling: learn.microsoft.com → Foundry/Azure OpenAI „function calling"
- ⚠️ Vždy ověř aktuální `api-version` a názvy metod proti docs (SDK se mění).
