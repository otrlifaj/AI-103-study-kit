# Develop generative AI apps that use tools

**Module:** `use-generative-ai-tools`
**Source:** https://learn.microsoft.com/en-us/training/modules/use-generative-ai-tools/

## Learning objectives

After completing this module, you'll be able to:

- Describe the capabilities of generative AI tools.
- Use the `code_interpreter` tool to run code and analyze data.
- Use the `web_search` tool to retrieve real-time information from the internet.
- Use the `file_search` tool to access and analyze files.
- Use the `function` tool to run custom code.

## Prerequisites

Before starting this module, you should:

- Be familiar with Microsoft Foundry and generative AI models.
- Have some programming experience.

---

## Introduction

Generative AI models are powerful at understanding and generating text, but they operate within a knowledge boundary. They can only reason about information in their training data. By integrating **tools** into your generative AI interactions, you unlock capabilities far beyond what the model alone can do.

> **Note**
> The use of *tools* in generative AI model prompts shouldn't be confused with *[Foundry Tools](https://learn.microsoft.com/en-us/azure/ai-services/reference/sdk-package-resources)*; which are Azure AI APIs that you can use in your applications and agents.

### Why tools matter

Tools bridge the gap between AI reasoning and real-world actions. They enable your generative AI applications to:

- **Access real-time information**: Fetch current data, weather, stock prices, or API responses that weren't in the model's training data
- **Take actions**: perform tasks like sending emails, creating database records, or triggering workflows based on AI decisions
- **Ground responses in facts**: Retrieve specific, authoritative information to reduce incorrect information and improve accuracy
- **Extend functionality**: Connect to your existing systems, databases, and business logic seamlessly
- **Build intelligent workflows**: Chain multiple operations together so AI coordinates complex, multi-step processes

Without tools, generative AI works in isolation. With tools, it becomes an intelligent assistant that can observe, reason, and act on the world around it.

In this module, we'll focus on specifying tools in prompts that a client application submits to a model. In this kind of solution, the tool configuration is managed by the client application - essentially creating a custom generative AI powered assistant within the application logic itself. Learning how to use tools on-demand with a generative AI model is a useful first step in learning how to build *agentic AI* solutions, in which the model, instructions, and tools are encapsulated and persisted in a named *agent*.

> **Tip**
> You can learn more about how to use the Microsoft Foundry Agents SDK to create agents with persisted configurations in [Develop AI agents on Azure](https://learn.microsoft.com/en-us/training/paths/develop-ai-agents-azure/).

---

## What are tools?

Microsoft Foundry Models includes models that are capable of using tools to find information or perform tasks. You can use tool support in models by specifying which tools you want the model to use in prompts submitted through the OpenAI *Responses* API.

![Diagram of an application configuring a model to use tools.](resources/use-generative-ai-tools-tools.png)

When you develop a generative AI application using Microsoft Foundry, you can search Foundry Models for a model with tool calling capabilities and deploy it. Then, you can develop client applications that use the OpenAI Responses API to submit prompts to the deployed model, specifying the tools that the model can use.

> **Note**
> By default, the *model* chooses when to use a tool (and which one), based on the prompt. You can configure tool selection rules and use the *Instructions* (system prompt) parameter to guide this choice.

Some of the commonly used tools available in the *Responses* API, include:

- **code\_interpreter**: A Python environment in which the model can generate and run code.
- **web\_search**: A tool that enables the model to find general information on the Internet, which allows it to base responses on more current data than it was trained on.
- **file\_search**: A tool that enables the model to search specific files that you upload to a dedicated vector search index - enabling it to ground responses in specific knowledge.
- **function**: A tool that enables the model to call custom functions in your application code.

> **Tip**
> These represent only *some* of the available tools; and development of tools for agentic AI solutions is a growing area. To learn more about tools supported in the OpenAI Response API, see the [OpenAI developer guide](https://developers.openai.com/api/docs/guides/tools).

### Specifying tools in the *Responses* API

You can specify one or more tools in a call to the `responses.create()` method when generating a response from a model. The following Python pseudocode example indicates where the list of callable tools is specified:

```python
from openai import OpenAI

client = OpenAI(
    base_url={openai_endpoint},
    api_key={auth_key_or_token}
)

response = client.responses.create(
    model={model_deployment},
    instructions="You are a helpful AI assistant.",
    input="Find me some information about vintage computers.",
    # Specify available tools as a JSON list
    tools=[
        { 
            # A tool definition
            "type": "{tool_type}",
            "{tool-specific-setting}": "{value}",
                ...
        },
        { 
            # Another tool definition
            "type": "{another_tool_type}",
            "{tool-specific-setting}": "{value}",
                ...
        }
    ]
)
print(response.output_text)
```

> **Tip**
> To learn more about using the *Responses* API to submit a prompt to a model in Microsoft Foundry, see the [Develop a generative AI chat app with Microsoft Foundry](https://learn.microsoft.com/en-us/training/modules/foundry-sdk) module.

---

## Use the code\_interpreter tool

The *code\_interpreter* tool provides your model with a Python runtime in which it can generate and run Python code.

### What is the code\_interpreter tool?

The code\_interpreter tool enables generative AI models to write and run Python code dynamically during a conversation. Rather than just discussing code or algorithms, the model can test its logic, process data, and return actual results from code. This transforms the model from a thinker into a doer.

Key features include:

- **Dynamic Python Execution**: The model writes and runs Python code in a sandboxed environment
- **File Handling**: Upload, process, and download files (CSV, JSON, images, and so on)
- **Data Analysis**: Perform calculations, statistical analysis, and data transformations on the fly
- **Real-time Feedback**: The model sees code execution results and can iterate or fix errors
- **Complex Problem Solving**: Tackle math problems, simulations, and logic puzzles through executable code

### Common use cases

| Use Case | Example |
| --- | --- |
| **Data Analysis** | Parse a CSV file and generate summary statistics |
| **Math & Physics** | Solve differential equations or simulate physics scenarios |
| **File Conversion** | Convert between data formats (JSON ↔ CSV, and so on) |
| **Prototyping** | Test algorithms and ideas before formal implementation |

### A simple example

Here's how to use code\_interpreter with the OpenAI Responses API:

```python
from openai import OpenAI

client = OpenAI(
    base_url={openai_endpoint},
    api_key={auth_key_or_token}
)

# Get response using the code_interpreter tool
response = client.responses.create(
    model={model_deployment},
    instructions="You are an AI assistant that provides information. Use the python tool to run code for math problems.",
    input="What is the square root of 16?",
    tools=[{"type": "code_interpreter",
            "container": {"type": "auto"}}]
)
print(response.output_text)
```

The output from this code is similar to this:

```
The square root of 16 is 4.
```

More importantly, inspecting the details of the **response** object returned by the model reveals that the result was calculated and returned to the model using dynamically generated Python code like this:

```python
import math

# Calculate the square root of 16
square_root = math.sqrt(16)
square_root
```

### How the code\_interpreter tool works

The general process for using the code\_interpreter tool is:

1. **You send a request**: Include code\_interpreter in your tools array.
2. **Model analyzes the task**: The model determines if code execution is needed.
3. **Model generates code**: The model writes Python code to accomplish the task.
4. **Code runs**: The code runs in a sandboxed environment with access to common libraries (for example, *pandas*, *numpy*, and *math*).
5. **Results returned**: The model receives the output and incorporates it into its response.

### Best practices

- **Be specific**: Describe the data format and expected output clearly. Many models internally use the name *python tool* to identify the code\_interpreter tool - so use this language in your instructions.
- **Provide context**: Include relevant domain knowledge in your prompts
- **Validate results**: Always review AI-generated code for correctness before using in production
- **Monitor costs**: Code execution adds tokens; complex operations may use more resources
- **Leverage libraries**: Common packages like pandas, numpy, and matplotlib are pre-installed
- **Error handling**: The model can see errors and will attempt to fix them automatically

### Limitations to know about

- Executions run in a **sandboxed environment** with no external network access
- Some libraries may not be available; let the model know if a standard library fails
- **Timeout limits** apply to long-running operations
- Code runs with **memory constraints**—massive datasets may need streaming or chunking

---

## Use the web\_search tool

The *web\_search* tool enables your model to retrieve fresh information from the web while generating a response.

### What is the web\_search tool?

The web\_search tool gives a generative AI model access to current, external information at runtime. Instead of relying only on training data, the model can issue a search query, review relevant sources, and produce an answer grounded in up-to-date content.

This is especially useful when facts may change frequently, such as pricing, product releases, policy updates, or current events.

Key features include:

- **Live information retrieval** - Get recent information not available in static model training data
- **Source-grounded responses** - Build answers from retrieved web content
- **Reduced hallucination risk** - Improve reliability by checking external sources
- **Automatic query generation** - The model decides when and how to search based on user intent
- **Seamless user experience** - Search and response generation happen in one flow

### Common use cases

| Use Case | Example |
| --- | --- |
| **Current Events** | Summarize key updates on a breaking technology announcement |
| **Market Research** | Compare recent product features or pricing across vendors |
| **Policy Monitoring** | Check whether regulations or guidance have changed |
| **Fact Verification** | Validate claims against reputable public sources |

### A simple example

Here's a minimal example using the OpenAI Responses API with web search enabled:

```python
from openai import OpenAI

client = OpenAI(
    base_url={openai_endpoint},
    api_key={auth_key_or_token}
)

# Get response using the web_search tool
response = client.responses.create(
    model={model_deployment},
    instructions="You are an AI assistant. Use web search when current information is required.",
    input="What are three major announcements from Microsoft Build this week?",
    tools=[{"type": "web_search"}]
)

print(response.output_text)
```

The output will vary based on current web results, but it should include a concise answer grounded in recent sources.

### How the web\_search tool works

The general process for using the web\_search tool is:

1. **You send a request** - Include a web search tool in the tools array.
2. **Model evaluates the question** - It decides whether fresh web data is needed.
3. **Search is performed** - The model issues one or more search queries.
4. **Results are reviewed** - Relevant pages are selected and summarized.
5. **Response is generated** - The model combines search findings into the final answer.

### Best practices

- **Ask time-aware questions clearly** - Include words like "latest", "current", or date ranges when needed
- **Set expectations for sources** - Prompt for reputable or official sources when accuracy matters
- **Request concise outputs** - Ask for short summaries with key points to reduce noise
- **Verify critical facts** - For high-stakes scenarios, independently validate important claims
- **Track usage and latency** - Web retrieval can increase response time and token usage

### Limitations to know about

- Results depend on what is publicly available and indexable at query time
- Source quality can vary, so output may still require human review
- Retrieved content may change over time, so repeated runs can produce different answers
- Some environments may apply regional, policy, or network restrictions to web access

Used well, web\_search helps your model move from static knowledge to timely, source-aware answers that are more useful in real-world workflows.

---

## Use the file\_search tool

The *file\_search* tool lets your model retrieve relevant information from your own uploaded documents during a response.

### What is the file\_search tool?

The file\_search tool helps a model answer questions using private or domain-specific files, such as policy documents, manuals, contracts, and internal knowledge bases. Instead of relying only on general training data, the model can search indexed file content and return grounded answers.

This is especially useful when you need accurate responses from trusted internal documents.

Key features include:

- **Document-grounded answers** - Responses are based on your uploaded files
- **Semantic retrieval** - Finds relevant passages by meaning, not only exact keyword matches
- **Vector store integration** - Search across one or more indexed document collections
- **Citations and transparency** - Include matched results for debugging and traceability
- **Better enterprise relevance** - Use organization-specific knowledge in model outputs

### Common use cases

| Use Case | Example |
| --- | --- |
| **Policy Q&A** | Answer employee questions from HR policy PDFs |
| **Support Assistants** | Retrieve product steps from internal troubleshooting guides |
| **Legal Review** | Locate specific clauses across contract documents |
| **Knowledge Discovery** | Summarize answers from technical documentation sets |

### A simple example

Here's an example using the OpenAI Responses API with file\_search enabled:

```python
from openai import OpenAI

client = OpenAI(
    base_url={openai_endpoint},
    api_key={auth_key_or_token}
)

# Create vector store and upload a file
vector_store = client.vector_stores.create(name="policy-docs")
client.vector_stores.files.upload_and_poll(
    vector_store_id=vector_store.id,
    file=open("expenses_policy.pdf", "rb")
)

# Get response using the file_search tool
response = client.responses.create(
    model=model_deployment,
    instructions="You are an AI assistant that provides information from HR policy documents.",
    input="What's the maximum amount I can claim for a taxi ride?",
    tools=[{
        "type": "file_search",
        "vector_store_ids": [vector_store.id]
    }],
    include=["file_search_call.results"]
)
print(response.output_text)
```

In this flow, the model searches the indexed policy file and uses the retrieved passages to produce a grounded answer.

### How the file\_search tool works

The general process for using the file\_search tool is:

1. **You prepare files** - Upload documents to a vector store.
2. **You send a request** - Include file\_search in the tools array with vector store IDs.
3. **Model performs retrieval** - It searches indexed chunks for relevant content.
4. **Results are injected** - Matching passages are provided to the model.
5. **Response is generated** - The model answers using retrieved document context.

### Best practices

- **Use high-quality source files** - Clean, current documents improve retrieval accuracy
- **Write focused prompts** - Ask specific questions to reduce ambiguous matches
- **Scope vector stores carefully** - Separate domains (HR, legal, finance) when helpful
- **Include retrieval results in development** - Use response includes for troubleshooting
- **Review answers for critical workflows** - Keep human validation in high-stakes scenarios

### Limitations to know about

- Answer quality depends on document quality, coverage, and chunk relevance
- Very large or mixed-domain stores can return less focused context
- Updated source files may require re-indexing before new content is searchable
- Retrieval improves grounding but doesn't replace human review for sensitive decisions

Used well, file\_search turns a general-purpose model into a domain-aware assistant that can answer from the documents your team actually uses.

> **Note**
> The file\_search tool is a great way to ground a model in a specific set of documents or data files. However, for enterprise-scale agents that need to access large quantities of data in multiple data stores, you should consider using the *Foundry IQ* knowledge store solution with a Microsoft Foundry agent. To learn more, see [Build knowledge-enhanced AI agents with Foundry IQ](https://learn.microsoft.com/en-us/training/modules/introduction-foundry-iq).

---

## Use the function tool

The *function* tool allows your model to call developer-defined functions to retrieve data or trigger actions during a response.

### What is the function tool?

The function tool (function calling) lets a model decide when to call named tools you expose in your application. The model doesn't run your business logic directly. Instead, it returns a structured function call, your code runs the function, and then you pass the function output back to the model.

This pattern is ideal for connecting model reasoning to real-world systems like APIs, databases, business workflows, and utility functions.

Key features include:

- **Structured tool calls** - The model emits explicit function-call requests
- **Developer-controlled execution** - Your application decides how and where functions run
- **Reliable integration pattern** - Call APIs, internal services, or helper utilities safely
- **Multi-turn orchestration** - Return tool output and let the model continue reasoning
- **Grounded responses** - Answers can include live, system-generated data

### Common use cases

| Use Case | Example |
| --- | --- |
| **System Integration** | Call an internal API for account or order details |
| **Task Automation** | Trigger workflows like ticket creation or notifications |
| **Data Lookup** | Query business rules or reference tables before answering |

### A simple example

Here's an example that exposes a `get_time` function and lets the model call it when needed:

```python
import time
from openai import OpenAI

# Function to get the current time
def get_time():
    return f"The time is {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())}"

# Main function
def main():
    client = OpenAI(
        base_url={openai_endpoint},
        api_key={auth_key_or_token}
    )

    function_tools = [
        {
            "type": "function",
            "name": "get_time",
            "description": "Get the current time"
        }
    ]

    # Initialize messages with a system prompt
    messages = [
        {"role": "developer", "content": "You are an AI assistant that provides information."},
    ]

    # Loop until the user types 'quit'
    while True:
        prompt = input("\nEnter a prompt (or type 'quit' to exit)\n")
        if prompt.lower() == "quit":
            break

        # Append the user prompt to the messages
        messages.append({"role": "user", "content": prompt})

        # Get initial response
        response = client.responses.create(
            model=model_deployment,
            input=messages,
            tools=function_tools
        )

        # Append model output to the messages
        messages += response.output

        # Was there a function call?
        for item in response.output:
            if item.type == "function_call" and item.name == "get_time":
                current_time = get_time()
                messages.append({
                    "type": "function_call_output",
                    "call_id": item.call_id,
                    "output": current_time
                })

                # Get a follow up response using the tool output
                response = client.responses.create(
                    model=model_deployment,
                    instructions="Answer only with the tool output.",
                    input=messages,
                    tools=function_tools
                )

        print(response.output_text)

# Run the main function when the script starts
if __name__ == '__main__':
    main()
```

In this flow, the model decides when to call `get_time`, your code runs the function, and the model then returns a grounded final answer. Since the user can enter any prompt, the model must determine when it needs to call the function. If it does, the response to the prompt will include a function call, that the application code must implement before submitting a new prompt with the output from the function for the model to process.

The output might look something like this:

```
Enter a prompt (or type 'quit' to exit)
Hello

Hello! How can I help you today?

Enter a prompt (or type 'quit' to exit)
What time is it?

The time is 2026-03-19 17:17:41.

Enter a prompt (or type 'quit' to exit)
```

The first user prompt ("Hello") didn't require the use of the function tool, so the model responded normally. The second prompt ("What time is it?") triggered the model to select the `get_time` function, which it indicated in its response. The application code then ran the function and returned the results to the model, which then sent a second response with the results from the function.

> **Tip**
> This example uses a single function with no parameters. You can configure the tool to use multiple functions, with or without parameters. For more information about specifying function details, see the [OpenAI developers guide](https://developers.openai.com/api/docs/guides/function-calling).

### How the function tool works

The general process for using the function tool is:

1. **You define tools** - Provide one or more function definitions in the tools array.
2. **Model evaluates the prompt** - It determines whether a function call is needed.
3. **Model emits a function call** - The response includes the function name and call metadata.
4. **Your app runs logic** - Run the matching function in your code.
5. **You return function output** - Send a `function_call_output` item with the result.
6. **Model completes the answer** - It incorporates tool results into the final response.

### Best practices

- **Keep tools focused** - Small, single-purpose functions are easier to control and test
- **Validate function inputs** - Never trust tool arguments blindly in production systems
- **Handle errors safely** - Return clear error outputs the model can reason about
- **Log tool usage** - Track calls, latency, and failure rates for debugging and governance
- **Limit sensitive operations** - Require explicit authorization for high-impact actions

### Limitations to know about

- The model requests function calls, but your application must run them
- Incorrect or unexpected tool arguments can occur and should be validated
- Tool latency can increase end-to-end response time
- Function calling improves reliability, but final outputs still need review for critical decisions

Used well, the function tool turns a model from a text generator into an orchestrator that can interact with real systems in a controlled, auditable way.

---

## Summary

In this module, you learned how tool calling extends a generative AI model from text-only reasoning to practical, grounded action.

You explored how to configure tools in OpenAI Responses API requests and how each tool adds a different capability:

- The **code\_interpreter** tool lets the model generate and run Python code for calculations, data analysis, and iterative problem solving.
- The **web\_search** tool enables retrieval of current external information so responses can include timely, source-grounded content.
- The **file\_search** tool helps the model answer questions from your own indexed documents and knowledge files.
- The **function** tool allows your application to run custom business logic and return results back to the model.

Across all tools, the same core implementation pattern applies: define the tool in your request, let the model decide when to use it, return tool output when required, and validate responses for correctness and safety.

As a next step, you can combine these techniques to build more capable assistants and evolve toward full agentic solutions with persisted instructions, tools, and orchestration.

### Further reading

To learn more about using tools with models, see the following resources:

- [OpenAI developer guide: Tools](https://developers.openai.com/api/docs/guides/tools)
- [OpenAI developers Guide: Function calling](https://developers.openai.com/api/docs/guides/function-calling)

---

## Exercise / Lab

Hands-on lab: [04a-use-own-data.md](../../../labs/mslearn-ai-studio/Instructions/Exercises/04a-use-own-data.md)
