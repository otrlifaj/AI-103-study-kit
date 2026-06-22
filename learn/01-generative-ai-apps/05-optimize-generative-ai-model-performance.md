# Optimize generative AI model performance with Microsoft Foundry

**Module:** `optimize-generative-ai-model-performance`
**Source:** <https://learn.microsoft.com/en-us/training/modules/optimize-generative-ai-model-performance/>

## Learning objectives

By the end of this module, you'll be able to:

- Apply prompt engineering techniques including system messages, few-shot learning, and model parameters to optimize model output.
- Understand when and how to ground a language model using Retrieval Augmented Generation (RAG).
- Identify when fine-tuning a model improves behavioral consistency.
- Compare optimization strategies and determine when to combine them.

## Prerequisites

Before starting this module, you should be familiar with fundamental AI concepts and services in Azure.

---

## Introduction

Language models are powerful tools for building generative AI applications, but a base model on its own might not meet all of your requirements. The quality, accuracy, and consistency of the responses a model generates depend on how you configure and augment it.

Imagine you're a developer working for a travel agency. You're building a chat application to help customers with their travel-related questions. The base model gives decent responses, but your team has specific needs: the responses should follow the company's tone of voice, include accurate information about your hotel catalog, and maintain a consistent format across interactions. How do you get the model to perform at this level?

There are several complementary strategies you can use to optimize a generative AI model's performance. These strategies range from quick, low-cost adjustments to more involved techniques that require additional time and resources.

![Diagram showing the various strategies to optimize the model's performance, from prompt engineering to RAG and fine-tuning.](resources/optimize-generative-ai-model-performance-model-optimization.png)

Throughout this module, you explore each of these strategies and learn when and how to apply them individually or in combination.

> **Note:** Different people learn in different ways. The source module offers both video and text formats. The text contains greater detail than the videos.

---

## Optimize model output with prompt engineering

The most accessible way to optimize a model's performance is through **prompt engineering**. Prompt engineering is the process of designing and refining prompts to improve the quality, accuracy, and relevance of the responses a language model generates. It requires no additional infrastructure or training data, and you can start experimenting immediately.

### Understand prompt components

When you interact with a language model, the quality of your question directly influences the quality of the response. A well-constructed prompt helps the model understand what you need and generate a more useful answer.

Prompts for chat completion models typically include the following components:

- **System message**: Instructions that define the model's behavior, role, and constraints.
- **User message**: The question or input from the user.
- **Assistant message**: Previous model responses, used in multi-turn conversations.
- **Examples**: Sample input/output pairs that demonstrate the expected response format.

How you structure and combine these components determines how effectively the model responds.

### Design effective system messages

A **system message** is a set of instructions you provide to the model to guide its responses. System messages typically appear first in the conversation and act as the highest-level set of instructions. You use them to:

- Define the assistant's role and boundaries.
- Set the tone and communication style.
- Specify output formats, such as JSON or bullet points.
- Add safety and quality constraints for your scenario.

A system message can be as simple as:

```text
You are a helpful AI assistant.
```

Or it can include detailed rules and formatting requirements. For example, the travel agency's chat application could use:

```text
You are a friendly travel advisor for Margie's Travel.
Answer only questions related to travel, hotels, and trip planning.
Use a warm, conversational tone.
If you don't have enough information to answer, ask a clarifying question.
Format hotel recommendations as a bulleted list with the hotel name, location, and price range.
```

> **Important:** A system message influences the model but doesn't guarantee compliance. You should test and iterate on your system messages, and layer them with other mitigations like content filtering and evaluation.

When designing a system message, follow this checklist:

1. **Start with the assistant's role**: State the role and the expected outcome for a typical request.
2. **Define boundaries**: List the topics, actions, and content types the assistant should avoid.
3. **Specify the output format**: If you need a specific format, state it plainly and keep it consistent.
4. **Add a "when unsure" policy**: Tell the model what to do when the user's request is ambiguous, out of scope, or when the model lacks information.

### Apply prompt patterns

Effective prompts use patterns that help the model produce better responses. Here are some common patterns you can use:

#### Persona pattern

Instruct the model to take on a specific perspective or role. For example, asking the model to respond as a seasoned marketing professional produces different results than using no persona at all.

| - | No persona | With persona |
| --- | --- | --- |
| **System message** | *None* | You're a seasoned marketing professional writing for technical customers. |
| **User prompt** | Write a one-sentence description of a CRM product. | Write a one-sentence description of a CRM product. |
| **Response** | A CRM product is a software tool designed to manage a company's interactions with customers. | Experience seamless customer relationship management with our CRM, designed to streamline operations and drive sales growth with robust analytics. |

#### Format template pattern

Provide a template or structure in your prompt to get output in a specific format. For example, if you need a structured response about a hotel:

```text
Format the result to show:
- Hotel name
- Location
- Star rating
- Price range per night
```

This pattern ensures consistent, organized responses that are easy to parse in your application.

#### Chain-of-thought pattern

Ask the model to explain its reasoning step by step. This technique, called **chain of thought**, reduces the chance of inaccurate results and makes it easier to verify the model's logic.

For example, instead of asking "Which hotel is best for a family of four?", you can prompt:

```text
Which hotel is best for a family of four? Take a step-by-step approach: 
consider room size, amenities for children, location, and price.
```

A related technique is to **break the task down** into explicit sub-steps *before* the model responds, rather than asking it to reason through everything at once. For example, you might first ask the model to extract key facts from a passage, and then in a follow-up prompt ask it to answer a question based on those facts. Decomposing the work this way reduces errors on complex, multi-part tasks.

> **Note:** Chain-of-thought prompting is a technique for non-reasoning models. Reasoning models like o-series models handle step-by-step logic internally.

#### Few-shot learning pattern

Provide one or more examples of the desired input and output to help the model identify the pattern you want. This technique is called **few-shot learning** (or **one-shot** for a single example). When no examples are provided, it's called **zero-shot** learning.

For example, to classify customer inquiries:

```text
Classify the following customer messages:

Message: "I need to change my flight to Rome"
Category: Booking change

Message: "What's the weather like in Bali in March?"
Category: Travel information

Message: "Can I get a refund for my cancelled tour?"
Category:
```

The model learns the classification pattern from the examples and correctly completes the last entry.

#### Use clear syntax and delimiters

When your prompt includes multiple sections — such as instructions, source text, and examples — use delimiters like `---`, Markdown headings, or XML tags to separate them. Clear boundaries help the model distinguish instructions from content and reduce the chance of misinterpretation.

> **Tip:** Models can be susceptible to **recency bias**, meaning text near the end of a prompt can have more influence than text at the beginning. If the model isn't following your instructions consistently, try repeating the key instruction at the end of the prompt.

### Configure model parameters

Beyond the text of your prompts, you can adjust model parameters that control how the model generates responses:

- **Temperature**: Controls the randomness of the output. A higher value (for example, 0.7) produces more creative and varied responses, while a lower value (for example, 0.2) produces more focused and deterministic responses. Use lower values for factual tasks and higher values for creative ones.
- **Top\_p**: Also controls randomness, but in a different way. It limits the model to a subset of the most probable next tokens. For example, a `top_p` of 0.9 means the model considers only the top 90% of probable tokens.

> **Tip:** The general recommendation is to adjust either temperature or top\_p, not both at the same time.

For the travel agency scenario, you might use a low temperature (0.2) when answering factual questions about hotel amenities, but a higher temperature (0.7) when generating creative travel itinerary suggestions.

### When prompt engineering is enough

Prompt engineering is the right starting point for any model optimization effort. It's effective when you need to:

- Guide the model's tone, format, and behavior.
- Provide specific instructions for a task.
- Quickly iterate on results without infrastructure changes.
- Keep costs low, as no additional training or data storage is required.

However, prompt engineering has limits. If the model doesn't have access to the information it needs (like your company's hotel catalog), or if it consistently fails to maintain a specific behavior despite detailed instructions, you need to consider additional strategies.

---

## Ground your model with Retrieval Augmented Generation

Prompt engineering helps guide how a model responds, but it can't give the model knowledge it doesn't already have. Language models are trained on large datasets, but that training data has a cutoff date and doesn't include your organization's private information. When a model lacks relevant context, it might generate responses that sound plausible but are factually incorrect.

To address this challenge, you can **ground** the model by providing it with relevant, factual data to base its responses on. **Retrieval Augmented Generation (RAG)** is the most common technique for grounding a language model.

### Understand grounding

When you use a language model without grounding, the only information it has comes from its training data. The result might be grammatically correct and logically structured, but it can be inaccurate or include fabricated details. For example, asking "Which hotels do you offer in Paris?" without grounding data might return fictional hotel names.

![Diagram showing an ungrounded model returning an uncontextualized response based only on training data.](resources/optimize-generative-ai-model-performance-ungrounded.png)

When you **ground** a prompt, you provide relevant data from a trusted source along with the user's question. The model then generates a response based on that data, producing more accurate and contextually relevant answers.

Consider the difference:

- **Ungrounded**: The model relies only on its training data and might invent hotel names or details.
- **Grounded**: The model receives your actual hotel catalog data as context and responds with real hotel names, prices, and availability.

![Diagram comparing an ungrounded model returning generic responses versus a grounded model returning data-backed responses.](resources/optimize-generative-ai-model-performance-grounded.png)

Grounding improves the factual accuracy of responses by connecting the model to information that is specific, current, and relevant to the user's needs.

### How RAG works

RAG is a pattern that retrieves relevant information from a data source and includes it in the prompt before the model generates a response. The process follows three steps:

![Diagram showing the three-step RAG pattern: retrieve grounding data, augment the prompt with that data, and generate a grounded response.](resources/optimize-generative-ai-model-performance-rag-pattern.png)

1. **Retrieve**: Search a data source for information that is relevant to the user's question.
2. **Augment**: Add the retrieved information to the prompt as context.
3. **Generate**: Send the augmented prompt to the language model to generate a grounded response.

By retrieving context from a specified data source, you ensure that the model uses relevant, up-to-date information instead of relying solely on its training data.

### Create embeddings for search

A critical component of RAG is the ability to efficiently find the most relevant information in your data source. This is where **embeddings** and **vector search** come in.

An **embedding** is a mathematical representation of text as a vector — a list of floating-point numbers that captures the meaning of words, sentences, or documents. You create embeddings by sending your content to an embedding model, such as an Azure OpenAI embedding model available in Microsoft Foundry.

For example, imagine two documents:

- *"The children played joyfully in the park."*
- *"Kids happily ran around the playground."*

These sentences use different words but have similar meanings. When you create embeddings for each, their vectors are close together in multidimensional space, reflecting their semantic similarity.

![Diagram showing text keywords plotted as vectors in multidimensional space, with the distance between vectors representing semantic similarity.](resources/optimize-generative-ai-model-performance-vector-embeddings.jpg)

**Cosine similarity** measures how close two vectors are by calculating the angle between them. A value near 1 means the vectors are very similar. This mathematical approach enables you to find relevant documents even when the exact words don't match.

### Use Azure AI Search for retrieval

**Azure AI Search** provides the retrieval component for RAG solutions in Microsoft Foundry. It allows you to bring your own data, create a searchable index, and query it to retrieve relevant information.

![Diagram showing an Azure AI Search index being queried to retrieve grounding data for a user question.](resources/optimize-generative-ai-model-performance-index.png)

To use Azure AI Search with RAG, you:

1. **Add your data** to Microsoft Foundry from sources like Azure Blob Storage, Azure Data Lake Storage Gen2, or Microsoft OneLake. You can also upload files directly.
2. **Create an index** using an embedding model to generate vector representations of your content. The index is stored in Azure AI Search.
3. **Query the index** when a user asks a question. The system converts the question to an embedding, searches for the most similar content, and returns the relevant results.

Azure AI Search supports several search techniques:

- **Keyword search**: Matches exact terms in the query to text in the index.
- **Semantic search**: Uses semantic models to match the meaning of the query rather than exact keywords.
- **Vector search**: Uses embeddings to find semantically similar content.
- **Hybrid search**: Combines keyword, semantic, and vector search for the most accurate results. Hybrid search is recommended for generative AI applications.

### Implement RAG with the Azure AI Foundry SDK

After you create an Azure AI Search index, you can connect it to a model through your Microsoft Foundry project. The `azure-ai-projects` SDK lets you get an authenticated OpenAI client and use the Responses API to generate grounded answers.

The following Python code shows a basic implementation:

```python
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential

project = AIProjectClient(
    endpoint=os.environ["PROJECT_ENDPOINT"],
    credential=DefaultAzureCredential(),
)

client = project.get_openai_client()

response = client.responses.create(
    model="gpt-4o",
    input=[
        {"role": "system", "content": "You are a helpful travel advisor. "
         "Use the following hotel data to answer: " + retrieved_context},
        {"role": "user", "content": "Which hotels do you offer in Paris?"},
    ],
)

print(response.output_text)
```

In this example, `retrieved_context` represents the documents returned from your Azure AI Search index. By injecting those results into the system message, the model's response is grounded in your actual data rather than its general training knowledge.

### When to use RAG

RAG is most effective when:

- **The model needs domain-specific knowledge**: Your organization has private data that the model wasn't trained on, like a product catalog, policy documents, or internal knowledge base.
- **Information changes frequently**: Your data is updated regularly, such as inventory, pricing, or news. RAG retrieves current data at query time without retraining.
- **Factual accuracy is critical**: You need responses grounded in real data rather than the model's general knowledge.
- **The base model's training data has a cutoff**: Events or information that occurred after the model's training cutoff date need to be accessible.

For the travel agency scenario, RAG allows customers to ask questions about specific hotels, destinations, and booking policies, all grounded in the agency's actual catalog data.

> **Tip:** If you're building agents that need grounded knowledge without managing your own search infrastructure, consider **Foundry IQ** — a managed knowledge store that simplifies grounding for AI agents.

---

## Fine-tune a model for consistent behavior

Prompt engineering helps you guide the model's behavior, and RAG helps you ground responses in factual data. But sometimes the model still doesn't produce responses with the consistent style, tone, or format you need. When you notice that the model ignores or inconsistently follows your instructions—even with detailed system messages and few-shot examples—it might be time to **fine-tune** the model.

**Fine-tuning** is the process of taking a pretrained language model and further training it on a smaller, task-specific dataset. This adjusts the model's internal weights so that it produces responses that are consistent with the patterns in your training data.

### Understand fine-tuning

Foundation models like GPT-4o are trained on vast amounts of general data. Fine-tuning builds on that foundation by training the model with additional examples that reflect your specific requirements. Think of it as specializing a generalist: the model retains its broad language capabilities but learns to respond in the particular way your training data demonstrates.

Fine-tuning uses **LoRA (Low-Rank Adaptation)**, a technique that approximates weight changes with a lower-rank representation. Instead of retraining all of the model's parameters, LoRA updates only a smaller subset of important parameters. This makes training faster and more cost-effective while maintaining model quality.

The key benefit of fine-tuning over training a model from scratch is efficiency. You need less time, fewer computing resources, and significantly less data to customize a model's behavior.

### Know when to fine-tune

Fine-tuning is suited for scenarios where prompt engineering alone doesn't achieve the consistency you need. Common use cases include:

- **Consistent style and tone**: Your organization has a specific brand voice, and the model needs to follow it reliably across all interactions. For example, the travel agency wants every response to use a warm, encouraging tone with short paragraphs.
- **Specific output formats**: You need the model to reliably produce structured output, like JSON responses following a defined schema, and few-shot examples alone aren't sufficient.
- **Reducing prompt length**: Long system messages with many examples consume tokens and increase latency. Fine-tuning embeds those patterns into the model, reducing the prompt size needed for each request.
- **Distillation**: You want to transfer the capabilities of a large, expensive model to a smaller, more efficient one. For example, you can collect outputs from a high-performing model and use them to fine-tune a smaller model that achieves similar quality at lower cost and latency.
- **Enhancing tool usage**: When your application uses tool calling, fine-tuning with tool examples can improve the accuracy of tool selection and parameter generation.

> **Important:** Fine-tuning is an advanced capability. Always start by evaluating the baseline performance of a standard model against your requirements before considering fine-tuning. Without a baseline, it's hard to detect whether fine-tuning improved or degraded the model's performance.

### Explore types of fine-tuning

Microsoft Foundry offers several fine-tuning techniques:

- **Supervised fine-tuning (SFT)**: Train the model on a labeled dataset of prompt-and-response pairs. The model learns to produce outputs that match the patterns in your training data. This technique works best when there are clear, well-defined ways to approach a task.
- **Reinforcement fine-tuning (RFT)**: Optimize the model's behavior through iterative feedback, using a grader to reward better responses incrementally. RFT works well for complex or dynamic tasks where there are many possible solutions and you want to improve the model's reasoning quality.
- **Direct Preference Optimization (DPO)**: Align the model based on human preferences by providing preferred and non-preferred response pairs. DPO is computationally lighter than traditional reinforcement learning approaches while being equally effective at alignment.

You can also combine techniques. For example, first use supervised fine-tuning to create a customized model, then use DPO to further align the responses to your specific preferences.

### Prepare training data

Fine-tuning requires a dataset of high-quality examples in JSONL (JSON Lines) format. For chat completion models, each example consists of a conversation with system, user, and assistant messages:

```json
{"messages": [{"role": "system", "content": "You are a friendly travel advisor for Margie's Travel."}, {"role": "user", "content": "What's a good beach destination in Europe?"}, {"role": "assistant", "content": "For a beautiful European beach experience, consider the Algarve in southern Portugal! It offers stunning golden cliffs, warm waters, and charming coastal towns. The best time to visit is from May through September."}]}
{"messages": [{"role": "system", "content": "You are a friendly travel advisor for Margie's Travel."}, {"role": "user", "content": "I need a budget hotel in Tokyo."}, {"role": "assistant", "content": "Here are some great budget-friendly options in Tokyo:\n\n- **Sakura Hotel Jimbocho** - Central location, from $45/night\n- **Khaosan World Asakusa** - Near Senso-ji temple, from $35/night\n- **Imano Tokyo Ginza Hostel** - Modern design, from $40/night\n\nAll three options are close to public transit, making it easy to explore the city."}]}
```

When preparing your training data:

- Include a consistent system message across examples.
- Use high-quality, representative examples that cover the range of scenarios you expect.
- Aim for at least hundreds of examples; more is generally better.
- Ensure the assistant responses reflect exactly the style, format, and tone you want.

> **Note:** Including a system message in your training data is important. Leaving it blank tends to produce lower-accuracy models. Use the same system message when you deploy your fine-tuned model for inference.

### Consider the challenges

Fine-tuning introduces costs and complexity that you should evaluate before committing:

- **Training costs**: Fine-tuning has upfront costs for training and ongoing hourly costs for hosting the custom model.
- **Data quality requirements**: Poor-quality or unrepresentative training data leads to overfitting, underfitting, or bias.
- **Maintenance**: Fine-tuned models may need to be retrained when data changes or when updated base models are released.
- **Experimentation**: Finding the right combination of hyperparameters (epochs, batch size, learning rate) requires testing and iteration.
- **Model drift**: Specializing too narrowly can make the model less effective at general language tasks outside the fine-tuned domain.

For the travel agency, fine-tuning means every response consistently matches the company's brand voice and formatting guidelines—even without extensive system messages. But the team needs to weigh this benefit against the cost of preparing training data and maintaining the fine-tuned model over time.

---

## Compare and combine optimization strategies

Now that you've explored prompt engineering, RAG, and fine-tuning individually, let's look at how they relate to each other. These strategies aren't mutually exclusive; they're complementary methods that you can combine to meet different optimization goals.

### Understand the optimization spectrum

The three optimization strategies address different dimensions of model performance:

![Diagram showing the various strategies to optimize the model's performance, from prompt engineering to RAG and fine-tuning.](resources/optimize-generative-ai-model-performance-model-optimization.png)

- **Optimize for context**: When the model lacks domain-specific knowledge and you want to maximize the accuracy of responses. RAG addresses this by retrieving relevant data from external sources.
- **Optimize the model**: When you want to improve the response format, style, or tone by maximizing the consistency of behavior. Fine-tuning addresses this by training the model on examples that demonstrate the desired output.

Prompt engineering is the foundation that supports both directions. You use prompt engineering to instruct the model how to behave and what to focus on, and then layer RAG or fine-tuning when prompt engineering alone isn't sufficient.

### Compare strategies

Each strategy has different trade-offs in terms of implementation time, complexity, cost, and what it does best:

| Strategy | Time to implement | Complexity | Cost | Best for |
| --- | --- | --- | --- | --- |
| **Prompt engineering** | Low | Low | Low (per-token only) | Guiding tone, format, and behavior; quick iteration; providing instructions and examples |
| **RAG** | Medium | Medium | Medium (search infrastructure + storage + per-token) | Factual accuracy, domain-specific knowledge, dynamic or frequently changing data |
| **Fine-tuning** | High | High | High (training compute + model hosting + per-token) | Behavioral consistency, style enforcement, reducing prompt length, model distillation |

#### Prompt engineering trade-offs

Prompt engineering is the quickest and least expensive optimization strategy. You can start immediately without any infrastructure changes. However, longer prompts consume more tokens per request, and the model might not always follow complex instructions consistently. Prompt engineering also can't give the model access to information it wasn't trained on.

#### RAG trade-offs

RAG provides the model with up-to-date, relevant data at query time, which significantly improves factual accuracy. However, it requires setting up a search service, creating and maintaining an index, and processing embeddings. The quality of RAG responses depends on the quality of your search index and how well your data is chunked and indexed.

#### Fine-tuning trade-offs

Fine-tuning produces the most consistent model behavior because the desired patterns are embedded in the model's weights. It can also reduce per-request costs by shortening prompts. However, fine-tuning has the highest upfront investment: you need to prepare training data, pay for training compute, and host the custom model. The fine-tuned model may also need to be retrained when the base model is updated or when your requirements change.

### Combine strategies for better results

The most effective generative AI applications often use multiple strategies together. Here are common combinations:

#### Prompt engineering + RAG

This is the most common combination. You use prompt engineering to define the model's behavior (through system messages and instructions) and RAG to provide the factual context needed for accurate responses. For example:

- The system message instructs the model to act as a travel advisor and format responses in a specific way.
- RAG retrieves details from the hotel catalog so the model can answer with real hotel names and prices.

This combination addresses both *how the model should act* and *what the model needs to know*.

#### Prompt engineering + fine-tuning

Use this combination when you need the model to consistently follow a specific style or format. The fine-tuned model handles the baseline behavior, and the system message provides additional per-conversation context. For example:

- The fine-tuned model is trained to always respond in the travel agency's brand voice.
- The system message adds session-specific instructions, such as giving priority to a seasonal promotion.

#### RAG + fine-tuning

Combine these strategies when you need both factual grounding and consistent behavior. The fine-tuned model ensures the response style is reliable, while RAG provides the current, domain-specific data. For example:

- The fine-tuned model produces responses in the agency's brand voice and structured format.
- RAG retrieves up-to-date hotel pricing and availability from the catalog.

#### All three strategies together

For the most demanding applications, you can use prompt engineering, RAG, and a fine-tuned model together. Each layer handles a different concern:

1. **Fine-tuning** ensures consistent style and format.
2. **RAG** provides accurate, up-to-date domain knowledge.
3. **Prompt engineering** adds conversation-specific instructions and guardrails.

### Apply a decision framework

When deciding which strategies to use, start simple and add complexity only when needed:

1. **Start with prompt engineering**: Test system messages, few-shot examples, and parameter tuning. Evaluate whether the results meet your requirements.
2. **Add RAG if accuracy matters**: If the model needs access to specific, current, or private data to answer correctly, implement RAG with Azure AI Search.
3. **Add fine-tuning if consistency matters**: If the model doesn't reliably maintain the desired style, tone, or format despite detailed prompts, fine-tune the model with representative examples.
4. **Combine as needed**: Layer strategies based on your application's specific requirements. Not every application needs all three.

This incremental approach helps you avoid unnecessary cost and complexity while ensuring you achieve the optimization level your application requires.

---

## Summary

In this module, you learned how to optimize generative AI model performance using complementary strategies in Microsoft Foundry.

You learned how to:

- Apply prompt engineering techniques including system messages, few-shot learning, and model parameters to optimize model output.
- Understand when and how to ground a language model using Retrieval Augmented Generation (RAG).
- Identify when fine-tuning a model improves behavioral consistency.
- Compare optimization strategies and determine when to combine them.

The key takeaway is that prompt engineering, RAG, and fine-tuning aren't competing approaches—they're complementary strategies that address different dimensions of model performance. Start with prompt engineering to guide the model's behavior, add RAG when factual accuracy requires domain-specific data, and consider fine-tuning when you need consistent style and format that prompt engineering alone can't reliably achieve.

For the travel agency scenario, the most effective solution might combine all three: a fine-tuned model that maintains the brand voice, RAG that grounds responses in the actual hotel catalog, and prompt engineering that adds conversation-specific instructions and safety guardrails.

### Further reading

- [Getting started with customizing a large language model (LLM)](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/customizing-llms)
- [Prompt engineering techniques](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/prompt-engineering)
- [System message design](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/advanced-prompt-engineering)
- [Retrieval Augmented Generation in Microsoft Foundry](https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/retrieval-augmented-generation)
- [Customize a model with fine-tuning](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/fine-tuning)
- [Microsoft Foundry fine-tuning considerations](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/fine-tuning-considerations)
- [Augment large language models with RAG or fine-tuning](https://learn.microsoft.com/en-us/azure/developer/ai/augment-llm-rag-fine-tuning)

---

## Exercise / Lab

Hands-on lab: [04b-finetune-model.md](../../../labs/mslearn-ai-studio/Instructions/Exercises/04b-finetune-model.md)
