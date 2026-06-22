# AI-103 — kompletní learning materiály (offline knowledge base)

Textový obsah celého kurzu **AI-103T00: Develop AI apps and agents on Azure** stažený z Microsoft Learn,
seřazený přesně v pořadí průchodu kurzem. Slouží jako znalostní báze pro přípravu na certifikaci
*Azure AI Apps and Agents Developer Associate*.

- **1 soubor = 1 modul** — všechny výkladové unity spojené v pořadí kurzu (`## ` = jedna unit).
- Obrázky (diagramy/screenshoty) jsou v `resources/` každé path; odkazy v MD míří lokálně.
- **Laby** jsou připojené jako git submoduly v kořenovém [`../labs/`](../labs/) (instrukce + `Labfiles/` s C#/Python kódem). Každý modul má na konci odkaz `## Exercise / Lab`.
- **Vynecháno:** knowledge-check / module assessment kvízy, videa, achievement badge.
- **Zdroj:** `learn.microsoft.com` (en-us, `?accept=text/markdown`) + GitHub `MicrosoftLearning/*`. Staženo **16. 6. 2026**.

> Pro inicializaci labů po klonování repa: `git submodule update --init --recursive`

---

## Path 1 — Develop generative AI apps in Azure
1. [Plan and prepare to develop AI solutions on Azure](01-generative-ai-apps/01-prepare-azure-ai-development.md)
2. [Select, deploy, and evaluate Microsoft Foundry models](01-generative-ai-apps/02-model-catalog-evaluate.md)
3. [Develop a generative AI chat app with Microsoft Foundry](01-generative-ai-apps/03-foundry-sdk.md)
4. [Develop generative AI apps that use tools](01-generative-ai-apps/04-use-generative-ai-tools.md)
5. [Optimize generative AI model performance](01-generative-ai-apps/05-optimize-generative-ai-model-performance.md)
6. [Implement a responsible generative AI solution](01-generative-ai-apps/06-responsible-ai-studio.md)

→ Laby: [`labs/mslearn-ai-studio`](../labs/mslearn-ai-studio)

## Path 2 — Develop AI agents on Azure
1. [Develop AI agents with Microsoft Foundry and Visual Studio Code](02-ai-agents/01-develop-ai-agents-azure-vs-code.md)
2. [Integrate custom tools into your agent](02-ai-agents/02-build-agent-with-custom-tools.md)
3. [Integrate MCP Tools with Azure AI Agents](02-ai-agents/03-connect-agent-to-mcp-tools.md)
4. [Build knowledge-enhanced AI agents with Foundry IQ](02-ai-agents/04-introduction-foundry-iq.md)
5. [Integrate your agent with Microsoft 365](02-ai-agents/05-integrate-foundry-agent-with-m365.md)
6. [Build agent-driven workflows using Microsoft Foundry](02-ai-agents/06-build-agent-workflows-microsoft-foundry.md)
7. [Develop an AI agent with Microsoft Agent Framework](02-ai-agents/07-develop-ai-agent-with-semantic-kernel.md)
8. [Orchestrate a multi-agent solution using the Microsoft Agent Framework](02-ai-agents/08-orchestrate-semantic-kernel-multi-agent-solution.md)
9. [Discover Azure AI Agents with A2A](02-ai-agents/09-discover-agents-with-a2a.md)

→ Laby: [`labs/mslearn-ai-agents`](../labs/mslearn-ai-agents)

## Path 3 — Develop natural language solutions in Azure
1. [Analyze text with Azure Language in Foundry Tools](03-natural-language/01-analyze-text-ai-language.md)
2. [Develop a text analysis agent with the Azure Language MCP server](03-natural-language/02-develop-text-analysis-agent-language-mcp.md)
3. [Develop a speech-capable generative AI application](03-natural-language/03-develop-generative-ai-audio-apps.md)
4. [Create speech-enabled apps with Azure Speech](03-natural-language/04-create-speech-enabled-apps.md)
5. [Develop a speech agent with the Azure Speech MCP server](03-natural-language/05-develop-speech-agent-speech-mcp.md)
6. [Develop an Azure Speech Voice Live Agent in Microsoft Foundry](03-natural-language/06-develop-voice-live-agent.md)
7. [Translate text and speech with Microsoft Foundry Tools](03-natural-language/07-translate-text-speech.md)

→ Laby: [`labs/mslearn-ai-language`](../labs/mslearn-ai-language)

## Path 4 — Extract insights from visual data on Azure
1. [Develop a vision-enabled generative AI application](04-visual-data-insights/01-develop-generative-ai-vision-apps.md)
2. [Generate images with AI](04-visual-data-insights/02-generate-images-azure-openai.md)
3. [Generate videos with Microsoft Foundry](04-visual-data-insights/03-generate-video-with-foundry.md)
4. [Analyze images with Content Understanding](04-visual-data-insights/04-analyze-images-with-content-understanding.md)
5. [Create a multimodal analysis solution with Azure Content Understanding](04-visual-data-insights/05-analyze-content-ai.md)
6. [Create an Azure Content Understanding client application](04-visual-data-insights/06-analyze-content-ai-api.md)
7. [Extract data with Azure Document Intelligence](04-visual-data-insights/07-extract-data-with-document-intelligence.md)
8. [Create a knowledge mining solution with Azure AI Search](04-visual-data-insights/08-ai-knowldge-mining.md)

→ Laby: [`labs/mslearn-ai-vision`](../labs/mslearn-ai-vision) (moduly 1–4), [`labs/mslearn-ai-information-extraction`](../labs/mslearn-ai-information-extraction) (moduly 5–8)

---

## Mapa labů (modul → repo / soubor)

| Path | Lab repo | Exercises |
|---|---|---|
| 1 | `mslearn-ai-studio` | 01-Explore-ai-studio, 02-model-catalog-evaluation, 03-foundry-sdk, 04a-use-own-data, 04b-finetune-model, 06-Explore-content-filters |
| 2 | `mslearn-ai-agents` | 01-build-agent-portal-and-vscode, 02-agent-custom-tools, 03-mcp-integration, 04-integrate-agent-with-foundry-iq, 05a-m365-teams-integration, 05b-work-iq-integration, 06-build-workflow-ms-foundry, 07-agent-framework, 08-agent-framework-multi-agents, 09-multi-remote-agents-with-a2a |
| 3 | `mslearn-ai-language` | 01-analyze-text, 02-language-agent, 03-gen-ai-speech, 04-azure-speech, 05-azure-speech-mcp, 06-voice-live-agent, 07-translation |
| 4 | `mslearn-ai-vision` | 01-gen-ai-vision, 02-generate-image, 03-generate-video, 04-content-understanding |
| 4 | `mslearn-ai-information-extraction` | 01-content-understanding, 02-content-understanding-api, 03-document-intelligence, 04-knowledge-mining |
