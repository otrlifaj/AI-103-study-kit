# Develop a generative AI chat app with Microsoft Foundry

**Module:** `foundry-sdk` | [MS Learn](https://learn.microsoft.com/en-us/training/modules/foundry-sdk/)

## Learning objectives

After completing this module, you will be able to:

- Describe the process for creating a generative AI chat application with Microsoft Foundry.
- Use the Chat playground to explore models and generate code samples.
- Choose an endpoint, authentication method, and client SDK for your app development.
- Use the Responses API to generate AI responses in applications.
- Use the ChatCompletions API to generate AI responses in applications.

## Prerequisites

Before starting this module, you should:

- Be familiar with Azure services and the Azure portal.
- Be familiar with generative AI concepts and use cases.
- Have experience with Python or another programming language.

---

## Introduction

Developers creating AI solutions with Microsoft Foundry need to work with a combination of services and software frameworks. When developing a generative AI chat application, you can choose from a range of options to write the code needed to build effective AI apps on Azure.

In this module, you'll learn how to choose the appropriate endpoint, SDK, authentication, and chat API options to build a generative AI chat application.

Note

We recognize that different people like to learn in different ways. You can choose to complete this module in video-based format or you can read the content as text and images. The text contains greater detail than the videos, so in some cases you might want to refer to it as supplemental material to the video presentation.

Caution

Some Microsoft Foundry features are currently in preview. Details described in this module are subject to change.

---

## Explore with the model playground

Before you write code to build a generative AI chat application, it's helpful to explore what your project can do through the Foundry portal. The portal provides interactive tools for testing models and generating code samples that you can use as starting points for your applications.

[![Screenshot of the Model playground in Microsoft Foundry portal.](resources/foundry-sdk-foundry-playground.png)](resources/foundry-sdk-foundry-playground.png)

### Exploring with the Model playground

The **Model playground** in the Foundry portal provides an interactive environment for testing models before you write any code. You can access it by selecting **Model playground** from the left navigation.

The playground lets you:

- Send prompts to deployed models and see responses in real time
- Adjust settings like temperature and max tokens
- Add system messages to customize model behavior
- Experiment with different models and configurations

This no-code environment helps you understand how models respond to different inputs and settings, making it easier to design your application.

### Generating code samples

One of the most useful features of the Model playground is the **Code** button in the chat pane. At any point during your experimentation, you can select this button to see code samples to reproduce a chat session in your app.

The generated code samples include choices for:

- **API** - Using Responses API, or another API like ChatCompletions
- **Language** - Select your preferred programming language
- **SDK** - Choose which SDK you want to see a sample of

These samples are pre-populated with your project endpoint, model deployment name, and current settings. They provide a ready-to-use starting point for building your application.

You can copy this code directly into your development environment and modify it to fit your needs.

### From playground to code

The typical workflow for building an AI application with Microsoft Foundry looks like this:

1. **Explore in the playground** - Test prompts, adjust settings, and find what works
2. **Generate code samples** - Use the **Code** tab to get SDK samples
3. **Develop your application** - Take the generated code and customize it for your specific needs
4. **Iterate and refine** - Return to the playground to test new ideas, then update your code

This approach lets you quickly prototype and validate your ideas before investing time in development.

In the next unit, you'll learn about the available endpoints and SDKs you can use to develop a client application.

---

## Choose an endpoint and SDK

Microsoft Foundry provides flexibility for developing generative AI chat applications. Before you start development, it's important to understand the options that are available, and how to decide which of them to use. Some considerations for developing an application include:

- **Endpoints**: Microsoft Foundry projects provide two endpoints that you can use to connect to and consume project assets, such as model deployments, from client applications. Each project has both a *Project endpoint* and an *Azure OpenAI endpoint*.
- **Client SDK**: Depending on the endpoint you select, you can choose to use the *Microsoft Foundry SDK* or the *OpenAI SDK* to develop a generative AI chat application. Both SDKs support an OpenAI API compatible client object that can submit prompts to models, but there are some differences in the specific functionality available in each SDK.
- **Authentication**: Depending on the endpoint and SDK you choose to use, there are multiple ways a client application can be authenticated by Foundry in order to be granted access to assets. In general, production applications should use *Microsoft Entra ID* authentication, which requires the application to be running in the context of a specific identity; but in some scenarios you can also use *key-based* or *token-based* authentication.
- **Chat API**: The OpenAI client API supports two chat APIs: *ChatCompletions* and *Responses*. While the *Responses* API is recommended for most new development projects, the *ChatCompletions* API is well-established and compatible across many generative AI models and platforms.

Let's start by considering the available endpoints, client SDKs, and authentication methods - we'll explore the Responses and ChatCompletions APIs later.

### Using the Foundry SDK with the project endpoint

The Microsoft Foundry SDK provides programmatic access to resources in your projects through a REST API and language-specific client libraries; including:

- [Azure AI Projects for Python](https://pypi.org/project/azure-ai-projects?azure-portal=true)
- [Azure AI Projects for Microsoft .NET](https://www.nuget.org/packages/Azure.AI.Projects?azure-portal=true)
- [Azure AI Projects for JavaScript](https://www.npmjs.com/package/@azure/ai-projects?azure-portal=true)

Note

This module uses Python code examples for common tasks. You can refer to the language-specific SDK documentation for equivalent code in your preferred language. Each SDK is developed and maintained independently, so some functionality may be at different stages of implementation.

#### Installing the SDK

To use the Azure AI Projects library in Python, install the **azure-ai-projects** package from PyPI along with supporting packages:

```bash
pip install azure-ai-projects azure-identity openai
```

Note

When using the Foundry SDK to develop a chat application, you also need to import the OpenAI SDK package - the chat client functionality in the Foundry SDK is derived from the OpenAI SDK.

#### Connecting to the project endpoint

Each Foundry project has a unique endpoint that you can find on the project's **Overview** page in the Foundry portal at [https://ai.azure.com](https://ai.azure.com?azure-portal=true).

The project endpoint follows this format:

```
https://{resource-name}.services.ai.azure.com/api/projects/<project-name>
```

Use this endpoint to create an **AIProjectClient** object:

```python
from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient

project_endpoint = "https://{resource-name}.services.ai.azure.com/api/projects/<project-name>"
project_client = AIProjectClient(
    credential=DefaultAzureCredential(),
    endpoint=project_endpoint
)
```

Note

The code uses default Azure credentials to authenticate. To enable this authentication, you need to install the **azure-identity** package (shown in the installation command earlier).

Tip

To access the project successfully, the code must run in an authenticated Azure session. For example, you can use the Azure CLI `az login` command to sign in before running the code.

The project client (`AIProjectClient`) provides access to Foundry-native operations that don't have OpenAI equivalents. Use the project client to:

- Retrieve resource connections
- Access project configuration
- Enable tracing
- Manage datasets and indexes

#### Creating a chat client

To chat with a model in your Foundry project, you need an OpenAI-compatible client object. You can use the **get\_openai\_client()** method of the project client to get one, like this:

```python
openai_client = project_client.get_openai_client(api_version="2024-10-21")
```

You can then use this chat client object to submit prompts to models and return responses.

### Using the OpenAI SDK with the Azure OpenAI endpoint

The OpenAI SDK is the official client library for calling the OpenAI API. It handles HTTP requests, authentication, retries, and response parsing. The SDK works with OpenAI-hosted models, Azure OpenAI deployments, and Foundry models using the same patterns.

#### Installing the SDK

To use the OpenAI library in Python, install the **openai** package from PyPI along with supporting packages:

```bash
pip install openai azure-identity
```

Note

The *azure-identity* package is required if you intend to use token-based authentication to connect to the endpoint using Microsoft Entra ID credentials.

#### Connecting to the Azure OpenAI endpoint

Each Foundry project includes an Azure OpenAI endpoint that you can find on the project's **Overview** page in the Foundry portal at [https://ai.azure.com](https://ai.azure.com?azure-portal=true).

The Azure OpenAI endpoint follows this format:

```
https://{resource-name}.openai.azure.com/openai/v1
```

Create an OpenAI client with your endpoint and Azure credentials:

```python
from openai import OpenAI
from azure.identity import DefaultAzureCredential, get_bearer_token_provider

token_provider = get_bearer_token_provider(
    DefaultAzureCredential(), "https://ai.azure.com/.default"
)

openai_client = OpenAI(  
  base_url = "https://{resource-name}.openai.azure.com/openai/v1/",  
  api_key=token_provider,
)
```

In addition to Microsoft Entra ID (recommended), you can authenticate using an API key or environment variables.

**API key authentication:**

```python
import os
from openai import OpenAI

openai_client = OpenAI(
    api_key=os.getenv("AZURE_OPENAI_API_KEY"),
    base_url="https://{resource-name}.openai.azure.com/openai/v1/"
)
```

Important

Use API keys with caution. Store them securely in Azure Key Vault and never include them directly in your code.

**Environment variables:**

If you set `OPENAI_BASE_URL` and `OPENAI_API_KEY` environment variables, the client uses them automatically:

```python
from openai import OpenAI

openai_client = OpenAI()  # Uses environment variables
```

Regardless of how you choose to authenticate, the **OpenAI** client handles model inference operations. Use it for:

- Generating responses with the Responses API
- Chat completions and image generation
- Accessing Foundry direct models (non-Azure OpenAI models)

**Using an *AzureOpenAI* client object**

You should generally use the **OpenAI** client object to chat with models through the Azure OpenAI v1 endpoint. However, you also have the option to create an **AzureOpenAI** client object if you need to use functionality from a specific version of the Azure OpenAI API. To create an **AzureOpenAI** client object, you must specify the API version and the Azure endpoint, like this:

```python
import os
from openai import AzureOpenAI

openai_client = AzureOpenAI(
    azure_endpoint = "https://{resource-name}.openai.azure.com"
    api_key=os.getenv("AZURE_OPENAI_KEY"),  
    api_version="2024-10-21",
)
```

### Choosing between the Foundry SDK and OpenAI SDK

Microsoft Foundry supports two approaches for building AI applications. Each serves different purposes, and understanding when to use each one helps you build the right solution.

#### When to use the Foundry SDK

Use the Foundry SDK when your application needs Foundry-specific capabilities:

- **Foundry Agent Service** for building and managing AI agents
- **Tool invocation and approval** workflows
- **Cloud evaluations** for testing and validating AI responses
- **Tracing and observability** for monitoring application behavior
- **Foundry direct models** (non-Azure OpenAI models available through the model catalog)
- **Project metadata, connections, and governance** features

Microsoft recommends the Foundry SDK when building apps with agents, evaluations, or Foundry-specific features.

#### When to use the OpenAI SDK

Use the OpenAI SDK when you need maximum compatibility with the OpenAI API:

- **Full OpenAI API compatibility** for existing code and tooling
- **Portability** between OpenAI and Azure OpenAI deployments
- **Chat Completions, Responses, and Images** APIs
- **Minimal dependency** on Foundry-specific concepts

The OpenAI SDK is ideal for model inference workloads where you want existing OpenAI code to work with minimal changes. However, this approach doesn't provide Foundry-specific features like agents or evaluations.

Microsoft Foundry gives you flexibility in how you build AI applications. Use the Foundry SDK with `AIProjectClient` when you need project-level features like agents, evaluations, tracing, and connections. Use the OpenAI SDK when you need straightforward model inference with maximum OpenAI compatibility. Both SDKs work with your Foundry project endpoint, so you can combine them as needed in your applications. You can also use both SDKs together in the same application—the Foundry SDK for project features and the OpenAI SDK for model inference.

---

## Generate responses with the Responses API

The OpenAI *Responses* API brings together capabilities from two previously separate APIs (*ChatCompletions* and *Assistants*) in a unified experience. It provides stateful, multi-turn response generation, making it ideal for conversational AI applications. You can access the Responses API through an OpenAI-compatible client using either the Foundry SDK or the OpenAI SDK.

### Understanding the Responses API

The *Responses* API offers several advantages over traditional chat completions:

- **Stateful conversations**: Maintains conversation context across multiple turns
- **Unified experience**: Combines chat completions and Assistants API patterns
- **Foundry direct models**: Works with models hosted directly in Microsoft Foundry, not just Azure OpenAI models
- **Simple integration**: Access through the OpenAI-compatible client

Note

The *Responses* API is the recommended approach for generating AI responses in Microsoft Foundry applications. It replaces the older *ChatCompletions* API for most scenarios.

### Generating a simple response

With an OpenAI-compatible client, you can generate responses using the **responses.create()** method:

```python
# Generate a response using the OpenAI-compatible client
response = openai_client.responses.create(
    model="gpt-4.1",  # Your model deployment name
    input="What is Microsoft Foundry?"
)

# Display the response
print(response.output_text)
```

The **input** parameter accepts a text string containing your prompt. The model generates a response based on this input.

### Understanding response structure

A response object contains several useful properties:

- **output\_text**: The generated text response
- **id**: Unique identifier for this response
- **status**: Response status (for example, "completed")
- **usage**: Token usage information (input, output, and total tokens)
- **model**: The model used to generate the response

You can access these properties to handle responses effectively:

```python
response = openai_client.responses.create(
    model="gpt-4.1",
    input="Explain machine learning in simple terms."
)

print(f"Response: {response.output_text}")
print(f"Response ID: {response.id}")
print(f"Tokens used: {response.usage.total_tokens}")
print(f"Status: {response.status}")
```

#### Adding instructions

In addition to the user *input*, you can provide *instructions* (often referred to as a *system prompt*) to guide the model's behavior:

```python
response = client.responses.create(
    model="gpt-4.1",
    instructions="You are a helpful AI assistant that answers questions clearly and concisely.",
    input="Explain neural networks."
)

print(response.output_text)
```

### Controlling response generation

You can control response generation with additional parameters:

```python
response = openai_client.responses.create(
    model="gpt-4.1",
    instructions="You are a helpful AI assistant that answers questions clearly and concisely.",
    input="Write a creative story about AI.",
    temperature=0.8,  # Higher temperature for more creativity
    max_output_tokens=200  # Limit response length
)

print(response.output_text)
```

- **temperature**: Controls randomness (0.0-2.0). Higher values make output more creative and varied
- **max\_output\_tokens**: Limits the maximum number of tokens in the response
- **top\_p**: Alternative to temperature for controlling randomness

### Working with Foundry direct models

When using the FoundrySDK or AzureOpenAI client to connect to a *project* endpoint, the Responses API works with both Azure OpenAI models and Foundry direct models (such as Microsoft Phi, DeepSeek, or other models hosted directly in Microsoft Foundry):

```python
# Using a Foundry direct model
response = openai_client.responses.create(
    model="microsoft-phi-4",  # Example Foundry direct model
    instructions="You are a helpful AI assistant that answers questions clearly and concisely.",
    input="What are the benefits of small language models?"
)

print(response.output_text)
```

### Creating conversational experiences

For more complex conversational scenarios, you can provide system instructions and build multi-turn conversations:

```python
# First turn in the conversation
response1 = openai_client.responses.create(
    model="gpt-4.1",
    instructions="You are a helpful AI assistant that explains technology concepts clearly.",
    input="What is machine learning?"
)

print("Assistant:", response1.output_text)

# Continue the conversation
response2 = openai_client.responses.create(
    model="gpt-4.1",
    instructions="You are a helpful AI assistant that explains technology concepts clearly.",
    input="Can you give me an example?",
    previous_response_id=response1.id
)

print("Assistant:", response2.output_text)
```

In reality, the implementation is likely to be constructed as a loop in which a user can interactively enter messages based on each response received from the model:

```python
# Track responses
last_response_id = None

# Loop until the user wants to quit
print("Assistant: Enter a prompt (or type 'quit' to exit)")
while True:
    input_text = input('\nYou: ')
    if input_text.lower() == "quit":
        print("Assistant: Goodbye!")
        break

    # Get a response
    response = openai_client.responses.create(
                model=model_name,
                instructions="You are a helpful AI assistant that explains technology concepts clearly.",
                input=input_text,
                previous_response_id=last_response_id
    )
    assistant_text = response.output_text
    print("\nAssistant:", assistant_text)
    last_response_id = response.id 
```

The output from this example looks similar to this:

```text
Assistant: Enter a prompt (or type 'quit' to exit)

You: What is machine learning?

Assistant: Machine learning is a type of artificial intelligence (AI) that enables computers to learn from data and improve their performance over time without being explicitly programmed. It involves training algorithms on large datasets to recognize patterns, make predictions, or take actions based on those patterns. This allows machines to become more accurate and efficient in their tasks as they are exposed to more data.

You: Can you give me an example?

Assistant: Certainly! Let's look at a simple example of supervised learning—predicting house prices based on features like size, location, and number of rooms.
Imagine you want to build a machine learning model that can predict the price of a house based on various factors.
...
    { the example provided in the model response may be extensive}
...

You: quit

Assistant: Goodbye!
```

As the user enters new input in each turn, the data sent to the model includes the *Instructions* system message, the *input* from the user, and the *previous* response received from the model. In this way, the new input is grounded in the context provided by the response the model generated for the previous input.

#### Alternative: Manual conversation chaining

You can manage conversations manually by building the message history yourself. This approach gives you more control over what context is included:

```python
try:
    # Start with initial message
    conversation_history = [
        {
            "type": "message",
            "role": "user",
            "content": "What is machine learning?"
        }
    ]

    # First response
    response1 = openai_client.responses.create(
        model="gpt-4.1",
        input=conversation_history
    )

    print("Assistant:", response1.output_text)

    # Add assistant response to history
    conversation_history += response1.output

    # Add new user message
    conversation_history.append({
        "type": "message",
        "role": "user", 
        "content": "Can you give me an example?"
    })

    # Second response with full history
    response2 = openai_client.responses.create(
        model="gpt-4.1",
        input=conversation_history
    )

    print("Assistant:", response2.output_text)

except Exception as ex:
    print(f"Error: {ex}")
```

This manual approach is useful when you need to:

- Customize which messages are included in context
- Implement conversation pruning to manage token limits
- Store and restore conversation history from a database

#### Retrieving specific previous responses

The Responses API maintains response history, allowing you to retrieve previous responses:

```python
try:   

    # Retrieve a previous response
    response_id = "resp_67cb61fa3a448190bcf2c42d96f0d1a8"  # Example ID
    previous_response = openai_client.responses.retrieve(response_id)

    print(f"Previous response: {previous_response.output_text}")

except Exception as ex:
    print(f"Error: {ex}")
```

#### Context window considerations

The **previous\_response\_id** parameter links responses together, maintaining conversation context across multiple API calls.

It's important to note that keeping conversation history can increase token usage. For a single run, the active context window can include:

- System instructions (instructions, safety rules)
- Your current prompt
- Conversation history (previous user + assistant messages)
- Tool schemas (functions, OpenAPI specs, MCP tools, etc.)
- Tool outputs (search results, code interpreter output, files)
- Retrieved memory or documents (from memory stores, RAG, file search)

All of these are concatenated, tokenized, and sent to the model together on every request. The SDK helps you manage state, but it doesn't automatically make token usage cheaper.

### Creating responsive chat apps

Responses from a model can take some time to generate depending on factors like the specific model being used, the context window size, and the size of the prompt. User's may become frustrated if the app appears to "freeze" while waiting for a response, so it's important to consider app responsiveness in your implementation.

#### Streaming responses

For long responses, you can use streaming to receive output incrementally - so the user sees partially complete responses as output becomes available:

```python
stream = openai_client.responses.create(
    model="gpt-4.1",
    input="Write a short story about a robot learning to paint.",
    stream=True
)

for event in stream:
    print(event, end="", flush=True)
```

If you're tracking conversation history when streaming, you can get the response ID when the stream ends, like this:

```python
stream = openai_client.responses.create(
    model="gpt-4.1",
    input="Write a short story about a robot learning to paint.",
    stream=True
)
for event in stream:
                if event.type == "response.output_text.delta":
                    print(event.delta, end="")
                elif event.type == "response.completed":
                    response_id = event.response.id
```

#### Async usage

For high-performance applications, you can use an asynchronous client that allows you to make non-blocking API calls. Asynchronous usage is ideal for long-running requests or when you want to handle multiple requests concurrently without blocking your application. To use it, import `AsyncOpenAI` instead of `OpenAI` and use `await` with each API call:

```python
import asyncio
from openai import AsyncOpenAI

client = AsyncOpenAI(
    base_url="https://<resource-name>.openai.azure.com/openai/v1/",
    api_key=token_provider,
)

async def main():
    response = await client.responses.create(
        model="gpt-4.1",
        input="Explain quantum computing briefly."
    )
    print(response.output_text)

asyncio.run(main())
```

Async streaming works the same way:

```python
async def stream_response():
    stream = await client.responses.create(
        model="gpt-4.1",
        input="Write a haiku about coding.",
        stream=True
    )

    async for event in stream:
        print(event, end="", flush=True)

asyncio.run(stream_response())
```

By using the *Responses* API through the Microsoft Foundry SDK, you can build sophisticated conversational AI applications that maintain context, support multiple model types, and provide a responsive user experience.

---

## Generate responses with the ChatCompletions API

The OpenAI *ChatCompletions* API is commonly used across generative AI models and platforms. Although the *Responses* API is recommended for new project development, it's likely that you'll encounter scenarios where the *ChatCompletions* API is useful for code maintenance or cross-platform compatibility.

### Submitting a prompt

The *ChatCompletions* API uses collections of *message* objects in JSON format to encapsulate prompts:

```python
completion = openai_client.chat.completions.create(
    model="gpt-4o",  # Your model deployment name
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "When was Microsoft founded?"}
    ]
)

print(completion.choices[0].message.content)
```

### Retaining conversational context

Unlike the *Responses* API, the *ChatCompletions* API doesn't provide a stateful response tracking feature. To retain conversational context, you must write code to manually track previous prompts and responses.

```python
# Initial messages
conversation_messages=[
    {
        "role": "system",
        "content": "You are a helpful AI assistant that answers questions and provides information."
    }
]

# Add the first user message
conversation_messages.append(
    {"role": "user",
    "content": "When was Microsoft founded?"}
)

# Get a completion
completion = openai_client.chat.completions.create(
    model="gpt-4o",
    messages=conversation_messages
)
assistant_message = completion.choices[0].message.content
print("Assistant:", assistant_text)

# Append the response to the conversation
conversation_messages.append(
    {"role": "assistant", "content": assistant_text}
)

# Add the next user message
conversation_messages.append(
    {"role": "user",
    "content": "Who founded it?"}
)

# Get a completion
completion = openai_client.chat.completions.create(
    model="gpt-4o",
    messages=conversation_messages
)
assistant_message = completion.choices[0].message.content
print("Assistant:", assistant_text)

# and so on...
```

In a real application, the conversation is likely to be implemented in a loop; like this:

```python
# Initial messages
conversation_messages=[
    {
        "role": "system",
        "content": "You are a helpful AI assistant that answers questions and provides information."
    }
]

# Loop until the user wants to quit
print("Assistant: Enter a prompt (or type 'quit' to exit)")
while True:
    input_text = input('\nYou: ')
    if input_text.lower() == "quit":
        print("Assistant: Goodbye!")
        break

    # Add the user message
    conversation_messages.append(
        {"role": "user",
        "content": input_text}
    )

    # Get a completion
    completion = openai_client.chat.completions.create(
        model="gpt-4o",
        messages=conversation_messages
    )
    assistant_message = completion.choices[0].message.content
    print("\nAssistant:", assistant_message)

    # Append the response to the conversation
    conversation_messages.append(
        {"role": "assistant", "content": assistant_message}
    )
```

The output from this example looks similar to this:

```text
Assistant: Enter a prompt (or type 'quit' to exit)

You: When was Microsoft founded?

Assistant: Microsoft was founded on April 4, 1975 in Albuquerque, New Mexico, USA.

You: Who founded it?

Assistant: Microsoft was founded by Bill Gates and Paul Allen.

You: quit

Assistant: Goodbye!
```

Each new user prompt and completion is added to the conversation, and the entire conversation history is submitted in each turn.

While not as fully featured as the *Responses* API, the *ChatCompletions* API is well established in the generative AI model ecosystem, so it's useful to be familiar with it.

---

## Summary

Microsoft Foundry provides two SDKs for building AI applications. The Foundry SDK gives you access to project-level features like agents, evaluations, tracing, and connections. The OpenAI SDK provides model inference with full OpenAI API compatibility.

### Key takeaways

In this module, you learned how to:

- **Use the Foundry SDK** with the Foundry project endpoint to access project configuration, connections, tracing, and datasets
- **Use the OpenAI SDK** with the Foundry project and Azure OpenAI endpoints for model inferencing
- **Generate responses** with the *Responses* and *ChatCompletions* APIs and manage conversations

### Further reading

For more information about the topics discussed in this module, see the following resources:

- [Microsoft Foundry SDK overview](/en-us/azure/ai-foundry/how-to/develop/sdk-overview)
- [Responses API documentation](/en-us/azure/ai-foundry/openai/how-to/responses)
- [Microsoft Foundry Discord](https://aka.ms/azureaifoundry/discord)
- [Microsoft Foundry Developer Forum](https://aka.ms/azureaifoundry/forum)

---

## Exercise / Lab

Hands-on lab: [03-foundry-sdk.md](../../../labs/mslearn-ai-studio/Instructions/Exercises/03-foundry-sdk.md)

*Lab source: [microsoftlearning/mslearn-ai-studio](https://microsoftlearning.github.io/mslearn-ai-studio/Instructions/Exercises/03-foundry-sdk.html)*

