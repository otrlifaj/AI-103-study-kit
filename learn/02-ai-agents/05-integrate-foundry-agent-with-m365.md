# Integrate your agent with Microsoft 365

**Module:** integrate-foundry-agent-with-m365
**Source:** https://learn.microsoft.com/en-us/training/modules/integrate-foundry-agent-with-m365/

## Learning objectives

By the end of this module, you'll be able to:

- Explain the options for publishing Foundry agents to Microsoft 365
- Publish an agent from the Foundry portal to Teams and Microsoft 365 Copilot
- Use Work IQ to access Microsoft 365 data in your agents
- Test and troubleshoot agents integrated with Microsoft 365

## Prerequisites

- Familiarity with Azure and the Azure portal
- Experience building agents in Microsoft Foundry (recommended: [Develop AI agents with Microsoft Foundry and Visual Studio Code](https://learn.microsoft.com/en-us/training/modules/develop-ai-agents-azure-vs-code/) module)
- A Microsoft 365 subscription with access to Teams

---

## Introduction

Imagine you've built an AI agent in Microsoft Foundry that helps your team answer questions about company policies and procedures. The agent works great in the Foundry playground, but your users spend most of their day in Microsoft Teams. They want to interact with the agent directly in Teams chat, or even through Microsoft 365 Copilot, without switching to a separate application. How do you bridge this gap?

Microsoft Foundry provides built-in capabilities to publish your agents directly to Microsoft Teams and Microsoft 365 Copilot. This integration allows users to interact with your custom AI agents in the same tools they already use for collaboration and productivity. Whether you need a support agent that answers IT questions, a knowledge assistant that helps onboard new employees, or a specialized advisor for your business domain, you can make these agents available where your users work.

In this module, you learn how to publish Microsoft Foundry agents to Microsoft 365. You explore the publishing workflow from the Foundry portal, understand when you might need advanced integration options, and discover how to use Work IQ to give your agents access to Microsoft 365 data like emails, meetings, and documents.

---

## Understand Foundry agent publishing options

When you build an agent in Microsoft Foundry, it runs within the Foundry Agent Service infrastructure. Publishing promotes your agent from a development asset into a managed Azure resource with a dedicated endpoint, independent identity, and governance capabilities.

### Understanding agent applications

When you publish an agent, Microsoft Foundry creates an **Agent Application** resource with:

- **Dedicated invocation URL**: A stable endpoint that remains consistent as you update agent versions
- **Agent identity**: A distinct Microsoft Entra identity separate from your development project
- **User data isolation**: Inputs and interactions from one user aren't available to other users

The Agent Application acts as a routing layer. When you publish a new agent version, traffic automatically routes to the updated deployment without changing the public endpoint.

### Publishing to Microsoft 365

The primary focus of this module is Microsoft 365 integration, which enables your agent to appear within Teams and Copilot. Publishing to Microsoft 365:

- Creates an Azure Bot Service resource that routes messages between Microsoft 365 and your agent
- Generates a Microsoft 365 publishing package for distribution
- Registers a Microsoft Entra ID application for authentication
- Makes your agent discoverable in the Teams agent store

#### Direct publishing from Foundry portal

The most straightforward approach is publishing directly from the Foundry portal. The publishing wizard:

1. Creates an Azure Bot Service resource in your subscription
2. Registers a Microsoft Entra ID application
3. Generates a Microsoft 365 publishing package
4. Prepares your agent for distribution

This approach is ideal when you want to deploy quickly or keep your agent logic entirely within Foundry.

#### Microsoft 365 Agents Toolkit

For complex scenarios, you can use the Microsoft 365 Agents Toolkit to create a proxy application that connects to your Foundry agent. Consider this approach when you need custom single sign-on (SSO), advanced middleware logic, or multi-environment deployment pipelines. The Agents Toolkit is covered later in this module as an optional advanced topic.

#### Publish scopes

When publishing to Microsoft 365, you choose between two distribution scopes:

| Scope | Description | Best for |
| --- | --- | --- |
| **Shared** | Available immediately without admin approval. Appears under **Your agents** in Teams. | Personal testing, small team pilots |
| **Organization** | Available to everyone in your tenant under **Built by your org**. Requires admin approval. | Production deployments |

### Other publishing channels

While this module focuses on Microsoft 365, Foundry agents can also publish to:

- **Web application preview**: Browser-based interface for demos and stakeholder testing
- **Stable API endpoint**: REST API for embedding in custom applications
- **Azure Bot Service channels**: Slack, Telegram, Twilio (SMS), Facebook, and others

These options are useful when you need to reach users outside Microsoft 365 or embed your agent in custom applications.

### Agent identity and permissions

When you publish an agent, the system creates a distinct agent identity. This matters because:

- The agent authenticates to Azure resources using its own identity
- Development-time permissions on your project identity don't transfer automatically
- Tools that access Azure services need permissions reconfigured after publishing

If your agent uses tools that connect to services like Azure AI Search, grant the published agent's identity appropriate permissions.

### Prerequisites for publishing

Before publishing an agent to Microsoft 365, ensure you have:

- **Azure AI Project Manager** role on your Foundry project
- **Azure AI User** role on the agent application scope
- An Azure subscription where you can create Azure Bot Service resources
- Permissions to register applications in Microsoft Entra ID
- A Microsoft 365 tenant that allows custom apps and bots

---

## Publish an agent from Foundry portal to Teams

Publishing an agent from the Microsoft Foundry portal to Microsoft Teams and Microsoft 365 Copilot is a straightforward process. The portal guides you through creating an agent application, provisioning the required Azure resources, and generating a publishing package for distribution.

### Before you begin

Before starting the publishing process, complete these preparation steps:

#### Test your agent thoroughly

Use the Foundry playground to verify your agent behaves as expected. Test various user inputs, confirm any configured tools work correctly, and check that responses are appropriate for your use case. Issues are easier to fix before publishing than after.

#### Verify your permissions

Confirm you have the required role assignments:

- **Azure AI Project Manager** role on your Foundry project to publish agents
- **Azure AI User** role to invoke or chat with published agents
- Permissions to create resources in your Azure subscription
- Permissions to register applications in Microsoft Entra ID

#### Register the Bot Service provider

The publishing process creates an Azure Bot Service resource. Ensure the **Microsoft.BotService** provider is registered in your Azure subscription. You can check this in the Azure portal under your subscription's **Resource providers** section.

#### Prepare metadata

Gather the following information before starting:

- A display name for your agent (appears in the Teams agent store)
- A brief description of what your agent does
- Small (32x32 pixels) and large (192x192 pixels) icons in PNG format
- Your organization's name and contact details
- URLs for your privacy policy and terms of use

> **Warning:** Don't include secrets, API keys, or sensitive information in any metadata fields. These fields are visible to users who discover your agent.

### Publish your agent

Follow these steps to publish your agent from the Foundry portal:

#### Step 1: Select your agent version

1. Open the [Microsoft Foundry portal](https://ai.azure.com) and navigate to your project.
2. Select the agent you want to publish from your agent list.
3. Review the agent configuration to confirm it's ready for publishing.

#### Step 2: Start the publishing process

1. Select **Publish** to open the publishing dialog.
2. Select **Publish** again, then choose **Publish to Teams and Microsoft 365 Copilot**.
3. The Microsoft 365 publishing configuration window opens.

#### Step 3: Configure Azure Bot Service

1. The portal automatically generates an application ID and tenant ID. Note these values for troubleshooting.
2. In the **Azure Bot Service** dropdown, select **Create an Azure Bot Service** to provision a new bot resource.
3. Wait for the portal to create the Bot Service resource in your subscription.

#### Step 4: Complete the metadata

Fill in the required fields:

| Field | Description |
| --- | --- |
| **Name** | Display name for your agent in the Teams store |
| **Description** | Brief explanation of what your agent does |
| **Icons** | Upload small and large PNG icons |
| **Publisher information** | Your organization name and contact details |
| **Privacy policy** | URL to your organization's privacy policy |
| **Terms of use** | URL to your terms of service |

#### Step 5: Choose your publish scope

Select the distribution scope for your agent:

- **Shared scope**: Agent appears under "Your agents" in the store. Available immediately. Best for testing and small teams.
- **Organization scope**: Agent appears under "Built by your org" in the store. Requires admin approval. Best for production deployments.

#### Step 6: Prepare and optionally download the package

1. Select **Prepare Agent** to start packaging your agent.
2. Wait for the packaging process to complete (typically 1-2 minutes).
3. When ready, you can either:
    - **Download the package** to test locally before distribution
    - **Continue the in-product publishing flow** for direct distribution

### Test the publishing package in Teams

If you downloaded the package, test it in Teams before broad distribution:

1. Open Microsoft Teams.
2. Navigate to **Apps** > **Manage your apps** > **Upload an app**.
3. Select **Upload a custom app** and choose the downloaded `.zip` file.
4. Teams installs the app and shows it in your apps list.
5. Open the agent and send a test message.

Verify the following:

- [ ] The agent responds to messages
- [ ] Response content is accurate and appropriate
- [ ] Response times are acceptable
- [ ] Any configured tools work correctly

### Request admin approval for organization scope

If you published with organization scope, an administrator must approve your agent before it's available organization-wide:

1. Direct your Microsoft 365 administrator to the [Microsoft 365 admin center](https://admin.cloud.microsoft).
2. Navigate to **Agents** > **All** > **Requested**.
3. Find your agent in the list of pending requests.
4. The administrator selects **Approve request and activate**.

Once approved, the agent appears in the **Built by your org** section of the Teams agent store for all users in your tenant. App policies in your organization control which users can access the agent.

### Reassign permissions after publishing

When you publish an agent, the system creates a distinct agent identity. If your agent uses tools that access Azure resources, you need to grant permissions to this new identity:

1. In the Foundry portal, go to your published agent and note the agent application's identity information.
2. In the Azure portal, navigate to the resources your agent accesses (for example, Azure AI Search, storage accounts, or Cosmos DB).
3. Assign the appropriate RBAC roles to the published agent identity.

Without this step, tools that worked during development might fail after publishing because the new agent identity lacks the required permissions.

### Update a published agent

When you make changes to your agent in Foundry, you need to republish to update the version available in Teams:

1. Make your changes in the Foundry portal.
2. Test the changes in the Foundry playground.
3. Repeat the publishing process to create a new package.
4. For shared scope, upload the new package to Teams.
5. For organization scope, the update might require re-approval depending on your organization's policies.

Users interacting with your agent receive the updated version once the new package is deployed.

---

## Advanced - Use Microsoft 365 Agents Toolkit

For most scenarios, publishing directly from the Foundry portal is the simplest path to get your agents into Microsoft Teams and Microsoft 365 Copilot. However, some complex enterprise scenarios require additional control over the integration layer. The Microsoft 365 Agents Toolkit provides an alternative approach for these situations.

> **Note:** This unit covers an advanced topic. If you're getting started with Foundry agent integration, you can skip this unit and return later if you encounter scenarios that require the Agents Toolkit approach.

### When to consider the Agents Toolkit

The Microsoft 365 Agents Toolkit is a suite of development tools available as extensions for Visual Studio Code and Visual Studio. Consider using it when your agent requires custom single sign-on (SSO) configuration beyond the default Entra ID setup, or when you need to add middleware logic for custom processing, logging, or transformation between Teams and your Foundry agent.

The toolkit is also valuable for organizations that require multi-environment deployment with separate development, staging, and production configurations. It provides advanced debugging capabilities with detailed tracing beyond what the Foundry portal offers, and integrates with CI/CD pipelines through GitHub Actions or Azure DevOps.

### How the Agents Toolkit approach works

Instead of publishing directly from Foundry, you create a proxy application using the Agents Toolkit that sits between Microsoft 365 and your Foundry agent:

```
Teams/Copilot → Proxy App (Agents Toolkit) → Foundry Agent
```

This proxy application receives messages from Teams or Copilot through Azure Bot Service, processes them through any custom middleware you've configured, forwards the request to your Foundry agent, and returns the response through the same path. The proxy approach gives you control over every step of the message flow, but adds complexity to your deployment.

### Getting started with the Agents Toolkit

If you determine the Agents Toolkit is right for your scenario, here's an overview of the setup process.

Start by installing the Microsoft 365 Agents Toolkit extension from the Visual Studio Code marketplace. Once installed, open the extension panel and select **Create a New Agent/App**, then choose **Custom Engine Agent** as the project type. The wizard guides you through configuration options including your AI model source.

The project template creates scaffolding for a standalone agent. To connect to an existing Foundry agent, configure the project to call your Foundry agent's endpoint, set up authentication using the agent's credentials, and implement any middleware logic you need.

The Agents Toolkit includes the **Microsoft 365 Agents Playground**, a local testing environment that simulates Teams. Run your project in debug mode to open the playground in your browser, where you can send test messages to verify the connection works correctly. Once testing is complete, use the toolkit to provision Azure resources, deploy your proxy application, and register it in Teams.

### Comparison summary

| Aspect | Direct Foundry publishing | Agents Toolkit proxy |
| --- | --- | --- |
| Setup time | Minutes | Hours to days |
| Code required | None | Proxy application |
| Customization | Limited | Extensive |
| Debugging | Foundry portal | Full IDE debugging |
| Best for | Standard deployments | Complex enterprise needs |

### Learn more

- [Microsoft 365 Agents Toolkit documentation](https://learn.microsoft.com/en-us/microsoftteams/platform/toolkit/overview-agents-toolkit)
- [Create custom engine agents with the Agents Toolkit](https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/create-new-toolkit-project-vsc)
- [Microsoft 365 Agents SDK overview](https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/agents-sdk-overview)

The direct publishing approach covered in the previous unit handles the majority of integration scenarios. Reserve the Agents Toolkit for situations where you've identified specific requirements it addresses.

---

## Access Microsoft 365 data with Work IQ

When building agents that help users with workplace tasks, access to organizational data can dramatically improve the agent's usefulness. Microsoft Work IQ provides a way to connect AI agents to Microsoft 365 data, including emails, meetings, documents, Teams messages, and people information.

### What is Work IQ?

Microsoft Work IQ is a command-line interface (CLI) and server that connects AI assistants to your Microsoft 365 Copilot data. It enables agents to query workplace information using natural language, providing rich context that helps agents give more relevant and accurate responses.

With Work IQ, your agents can answer questions like:

- "What did my manager say about the project deadline?"
- "Find my recent documents about Q4 planning"
- "Summarize today's messages in the Engineering channel"
- "Who is working on Project Alpha?"

Work IQ accesses data across multiple Microsoft 365 services:

| Data type | Example capabilities |
| --- | --- |
| **Emails** | Search messages, find communications from specific people |
| **Meetings** | Check calendar, retrieve meeting notes and decisions |
| **Documents** | Find files in SharePoint and OneDrive, search content |
| **Teams messages** | Summarize channel discussions, find specific conversations |
| **People** | Identify team members, find collaborators on projects |

### Understanding MCP servers

Work IQ is built on the **Model Context Protocol (MCP)**, an open protocol that enables AI assistants to connect to external data sources and tools. Understanding MCP helps explain how Work IQ functions.

An MCP server exposes capabilities that AI agents can use. These capabilities might include:

- **Tools**: Actions the agent can take, like searching for documents or sending messages
- **Resources**: Data sources the agent can query
- **Prompts**: Predefined templates for common queries

When you configure an MCP server for your agent, the agent discovers what tools and resources are available and can use them to fulfill user requests. Work IQ acts as an MCP server specifically designed for Microsoft 365 data.

### How Work IQ operates

Work IQ runs in two modes:

#### CLI mode

In CLI mode, you run queries directly from your terminal:

```bash
workiq ask -q "What requirements did Sarah share about the authentication feature?"
```

This mode is useful for quick queries during development or for scripts that need to retrieve workplace information.

#### MCP server mode

In MCP server mode, Work IQ integrates with AI assistants like GitHub Copilot in Visual Studio Code. Your AI assistant can automatically access workplace context when relevant to your work.

For example, if you're implementing a feature that was discussed in a recent meeting, your AI assistant can access that meeting context to provide more relevant suggestions.

### Installing Work IQ

You can install Work IQ in several ways depending on your preferred workflow.

#### Install using npm

```bash
# Global installation
npm install -g @microsoft/workiq

# Or run directly without installation
npx -y @microsoft/workiq mcp
```

#### Install using GitHub Copilot CLI

If you use GitHub Copilot CLI, you can install Work IQ as a plugin:

1. Open GitHub Copilot CLI by running `copilot`.
2. Add the plugins marketplace (one-time setup): `/plugin marketplace add github/copilot-plugins`
3. Install Work IQ: `/plugin install workiq@copilot-plugins`
4. Restart Copilot CLI and start querying your Microsoft 365 data.

#### Configure for Visual Studio Code

You can add Work IQ as an MCP server through the VS Code settings. Add the following to your MCP configuration:

```json
{
  "workiq": {
    "command": "npx",
    "args": [
      "-y",
      "@microsoft/workiq",
      "mcp"
    ],
    "tools": [
      "*"
    ]
  }
}
```

Before first use, accept the End User License Agreement:

```bash
workiq accept-eula
```

### Prerequisites for Work IQ

To use Work IQ, you need:

- Node.js installed on your machine (if using the CLI locally)
- A Microsoft 365 subscription with a Copilot license
- Administrative consent for the Work IQ application in your Microsoft Entra tenant

> **Important:** Work IQ requires administrative consent because it accesses organization-wide Microsoft 365 data. If you're not a tenant administrator, contact your IT department to request access.

### Security and data access

Work IQ inherits the security model of Microsoft 365 Copilot:

- **Permission-based access**: Work IQ can only access data you already have permission to view
- **No data storage**: Work IQ doesn't store your Microsoft 365 data; it retrieves information on-demand
- **Enterprise security**: All data access follows your organization's security policies
- **Admin visibility**: Administrators can monitor and control Work IQ usage

When you query Work IQ, it accesses data through Microsoft Graph with your authenticated identity. This means:

- You can't access documents you don't have permission to view
- Queries are auditable by your organization
- Data protection policies apply to Work IQ queries

### Using Work IQ with agent development

Work IQ helps you understand the context your users work in during agent development. You can interact with Work IQ through either the CLI or the MCP server, depending on your workflow.

#### CLI approach

The CLI is useful for quick, ad-hoc queries during development. Run the `workiq ask` command directly from your terminal:

```bash
# Find project context
workiq ask -q "What were the key decisions in last week's architecture review meeting?"

# Understand requirements from documents
workiq ask -q "Summarize the requirements in the user portal spec document"

# Check team communications
workiq ask -q "What has the engineering team discussed about the API changes?"
```

The CLI approach works well for scripts, one-off queries, or when you need quick answers without opening an IDE.

#### MCP server approach

When Work IQ runs as an MCP server, your AI assistant can access the same Microsoft 365 data automatically. Instead of running CLI commands, you interact naturally with your AI assistant, which calls Work IQ tools behind the scenes.

For example, in VS Code with GitHub Copilot configured to use Work IQ:

- Ask Copilot: "What requirements did Sarah share about the authentication feature?"
- Copilot uses Work IQ's MCP tools to query your Microsoft 365 data
- You receive the answer in the chat without running any commands

The MCP approach integrates workplace context seamlessly into your development workflow. Your AI assistant decides when to query Work IQ based on your questions, making the experience feel natural rather than requiring explicit commands.

Both approaches access the same underlying data with the same permissions. Choose the CLI for scripting and quick terminal queries, or the MCP server for integrated AI assistant experiences.

> **Note:** Work IQ is currently in preview. Features and APIs may change as the product evolves.

---

## Test and iterate your integrated agent

After publishing your agent using the steps in the previous units, ongoing testing and monitoring help ensure your agent performs reliably for users. This unit focuses on post-deployment testing strategies, troubleshooting common issues, and monitoring your agent over time.

### Testing beyond the Foundry playground

The Foundry playground is valuable for development testing, but it doesn't simulate the full published experience. After publishing, test your agent in Microsoft Teams to verify:

- The Teams user interface renders responses correctly
- Authentication flows work as expected
- Response times are acceptable in production
- The published agent identity has necessary permissions

#### Testing with multiple users

Have colleagues test your agent to discover issues you might miss. Different users phrase questions differently, and fresh perspectives identify confusing responses. Testing across different Teams clients (desktop, web, mobile) can also reveal platform-specific issues.

### Common troubleshooting scenarios

When issues arise, these common scenarios and resolutions can help:

#### Agent doesn't respond in Teams

**Possible causes:**

- Azure Bot Service isn't running
- Bot Service configuration is incorrect
- Network issues between Teams and your agent

**Resolution:**

1. Verify the Bot Service resource exists in the Azure portal.
2. Check Bot Service logs for errors.
3. Confirm the agent is published and the package was uploaded correctly.

#### Tools work in Foundry but fail in Teams

**Possible cause:** The published agent identity doesn't have the required permissions.

**Resolution:**

1. Find the published agent's identity in the Foundry portal.
2. In the Azure portal, locate the resources your tools access.
3. Assign appropriate RBAC roles to the published agent identity.

#### Users can't find the agent

**Possible causes:**

- Wrong publish scope selected
- Admin approval pending (for organization scope)
- Tenant policies block custom apps

**Resolution:**

- For shared scope: Share the direct link with users.
- For organization scope: Verify admin approval in the Microsoft 365 admin center.
- Check tenant settings for custom app permissions.

#### Slow response times

**Possible causes:**

- Complex agent instructions requiring extended processing
- Tools that query large data sets
- Network latency

**Resolution:**

- Simplify agent instructions where possible.
- Optimize tool configurations.
- Test from different network locations to isolate network issues.

### Monitoring published agents

After deployment, ongoing monitoring helps identify issues before users report them:

#### Check Foundry metrics

The Foundry portal provides metrics for published agents:

- Request volume and patterns
- Response times
- Error rates
- Tool invocation statistics

Review these metrics regularly to spot trends that indicate problems.

#### Review Application Insights

If you've configured Application Insights integration, you can:

- Trace individual conversations
- Analyze error patterns
- Measure end-to-end latency
- Set up alerts for anomalies

#### Gather user feedback

Establish channels for users to report issues:

- Create a Teams channel or email address for agent feedback
- Periodically review feedback to identify common problems
- Use feedback to prioritize agent improvements

### Iterating on your agent

When testing reveals issues or you receive user feedback, update your agent in the Foundry portal and republish following the same process covered in the publishing unit. For organization scope deployments, check your tenant's policies to determine if updates require re-approval.

> **Tip:** Keep a testing checklist specific to your agent. Document the key scenarios you test before each release to ensure consistent quality.

---

## Summary

In this module, you learned how to publish Microsoft Foundry agents to Microsoft Teams and Microsoft 365 Copilot, making your AI assistants available where users already work.

You explored the direct publishing workflow from the Foundry portal, which automatically provisions Azure Bot Service and creates the necessary Microsoft Entra ID registrations. You also learned about the Microsoft 365 Agents Toolkit as an alternative for complex enterprise scenarios.

The module covered publish scopes (shared for testing, organization for broad distribution), agent identity considerations for RBAC permissions, and how Work IQ connects agents to Microsoft 365 data through the Model Context Protocol (MCP).

### Learn more

- [Publish agents to Microsoft 365 Copilot and Microsoft Teams](https://learn.microsoft.com/en-us/azure/ai-foundry/agents/how-to/publish-copilot)
- [Microsoft Work IQ documentation](https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/workiq-overview)
- [Microsoft 365 Agents Toolkit overview](https://learn.microsoft.com/en-us/microsoftteams/platform/toolkit/overview-agents-toolkit)
- [Agent identity concepts in Microsoft Foundry](https://learn.microsoft.com/en-us/azure/ai-foundry/agents/concepts/agent-identity)

---

## Exercise / Lab

Hands-on lab (primary): [05a-m365-teams-integration.md](../../../labs/mslearn-ai-agents/Instructions/Exercises/05a-m365-teams-integration.md)

Hands-on lab (optional - Work IQ): [05b-work-iq-integration.md](../../../labs/mslearn-ai-agents/Instructions/Exercises/05b-work-iq-integration.md)
