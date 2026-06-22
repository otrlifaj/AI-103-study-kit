# Azure prostředí — config (TEMPLATE)

> Tohle je **šablona**. Skill `/setup` z ní vytvoří reálný `azure-config.md` a vyplní ho
> tvými hodnotami (ten je v `.gitignore`, takže se necommituje). Pokud chceš, můžeš
> `azure-config.md` vyplnit i ručně — zkopíruj tento soubor na `azure-config.md` a doplň.
>
> **Skilly** `next-module`, `scaffold-lab`, `provision-ahead` čtou Azure kontext odtud.

## Předpoklady
- Azure subscription s přístupem k **Azure AI Foundry** (kind `AIServices`, project-based).
- Na subscription/resource role **Owner** nebo aspoň **Azure AI Developer** +
  **Cognitive Services OpenAI User** (keyless data-plane přístup).
- `az login` hotový (DefaultAzureCredential bere token odtud).

## Hodnoty (vyplní `/setup`)

| Komponenta | Hodnota |
|---|---|
| Subscription ID | `<subscription-id>` |
| Tenant | `<tenant>` |
| Resource group | `<resource-group>` |
| Region | `<region>` (např. `swedencentral` — ověř kvóty modelů) |
| Foundry resource | `<foundry-resource>` (kind `AIServices`, projectMgmt=true) |
| Foundry projekt | `<project-name>` |
| **Project endpoint** | `https://<foundry-resource>.services.ai.azure.com/api/projects/<project-name>` |
| Account/OpenAI endpoint | `https://<foundry-resource>.cognitiveservices.azure.com/` |
| Chat model deployment(s) | `<chat-deployment>` (např. `gpt-4o` nebo `gpt-4.1`) |
| Embeddings deployment | `<embeddings-deployment>` (např. `text-embedding-3-small`) — pro RAG laby |
| Auth | **keyless** přes `az login` (`DefaultAzureCredential`) |

## Poznámky
- **Region:** drž všechny zdroje (Foundry, AI Search, Storage) ve stejném regionu kvůli
  kolokaci a kvótám modelů. Před nasazením modelu ověř kvótu v daném regionu.
- **Keyless:** v `.env` labů dávej jen **endpointy + názvy deploymentů**, nikdy klíče.
- Standalone služby (AI Search, Document Intelligence, Speech) přibývají postupně, jak
  na ně laby dojde — nasazuje je `/provision-ahead`. Jejich endpointy si sem doplň, až vzniknou.
