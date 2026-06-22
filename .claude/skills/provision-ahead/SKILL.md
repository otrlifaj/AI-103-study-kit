---
name: provision-ahead
description: Use when the user wants to pre-provision Azure resources for upcoming AI-103 labs so nothing blocks while studying. Triggers - "provision ahead", "nasaď zdroje", "provisioning", "připrav embeddings", "nasaď AI Search", "ať nečekám na provisioning". Diffs needed vs deployed and (after confirm) creates missing ones.
---

# provision-ahead

## Overview

Proaktivně připraví Azure zdroje pro **nadcházející** laby, ať při studiu nečekáš na provisioning (hlavně pomalé: AI Search, Document Intelligence). Přečte, co laby potřebují, porovná s tím, co je nasazené, a **po potvrzení** chybějící vytvoří.

⚠️ **Jediný skill, co zapisuje do Azure (stojí peníze).** Nikdy nic nevytváří bez explicitního potvrzení — vždy nejdřív ukáže plán + příkazy.

## Azure kontext (z [azure-config.md](../../../azure-config.md), vyplnil `/setup`)
Foundry resource · projekt · RG · subscription · region · keyless. Dosaď je do příkazů níž (`<foundry-resource>`, `<resource-group>`, `<region>`). Před nasazením modelu ověř kvótu v daném regionu (`az cognitiveservices usage list -l <region> -o table`).

## Workflow

### 1. Horizont
- Z argumentu (`provision-ahead 04a` / `provision-ahead den2`), jinak **nejbližší 1–2 studijní dny** z trackeru / den-po-dni rozpisu.

### 2. Co je potřeba
Read příslušné laby (`labs/.../Exercises/*.md`), agreguj zdroje (deployments + standalone služby). Časté:
| Lab / téma | Zdroj | Lead-time |
|---|---|---|
| RAG / own data / M05 | `text-embedding-3-small` deployment + **AI Search** | Search pomalý |
| Knowledge mining / M30 | **AI Search** + **Storage account** | pomalé |
| Document Intelligence / M29 | **Document Intelligence** (kind `FormRecognizer`) | středně |
| Speech / M20–22 | **Speech** (kind `SpeechServices`) | středně |
| image/video gen | image/video model deployment | rychlé |

### 3. Diff (máš vs. chybí)
```powershell
az cognitiveservices account deployment list --name <foundry-resource> --resource-group <resource-group> -o table
az search service list -g <resource-group> -o table
az cognitiveservices account list -g <resource-group> -o table   # Kind = FormRecognizer / SpeechServices
```

### 4. Ukaž plán + přesné příkazy (NEspouštěj)
Pro každý chybějící zdroj vypiš příkaz. Reference (uprav názvy/SKU dle potřeby):
```powershell
# embeddings deployment
az cognitiveservices account deployment create --name <foundry-resource> -g <resource-group> `
  --deployment-name text-embedding-3-small --model-name text-embedding-3-small `
  --model-version 1 --model-format OpenAI --sku-name GlobalStandard --sku-capacity 100

# Azure AI Search (jméno musí být globálně unikátní)
az search service create --name <prefix>-search-<suffix> -g <resource-group> --sku basic --location <region>

# Document Intelligence
az cognitiveservices account create --name <prefix>-docint -g <resource-group> `
  --kind FormRecognizer --sku S0 --location <region> --yes

# Speech
az cognitiveservices account create --name <prefix>-speech -g <resource-group> `
  --kind SpeechServices --sku S0 --location <region> --yes

# Storage (pro knowledge mining)
az storage account create --name <prefix>storage<suffix> -g <resource-group> --location <region> --sku Standard_LRS
```

### 5. Potvrzení → spuštění
- **Zeptej se** (AskUserQuestion / přímý dotaz), které zdroje opravdu vytvořit (každý něco stojí). Default: jen ty, co blokují nejbližší lab.
- Po souhlasu spusť odsouhlasené příkazy. Hlídej kvóty (ve zvoleném regionu). Report stav + odhad ETA (AI Search/DI běží i pár minut).
- Po dokončení připomeň, že `scaffold-lab` může endpoint nového zdroje vzít do `.env`.

## Common Mistakes
- **Vytvořit zdroj bez potvrzení** — vždy nejdřív plán a souhlas (cost!).
- **Provisionovat vše dopředu** — jen to, co potřebují nejbližší 1–2 dny; zbytek až bude třeba.
- **Zapomenout na region** — vše do stejného regionu (z `azure-config.md`) kvůli kvótám a kolokaci se Search/Storage.
- **Neunikátní jméno Search/Storage** — musí být globálně unikátní, přidej suffix.
