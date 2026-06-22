# Analyze images with Content Understanding

## Learning objectives

After completing this module, you'll be able to:

- Deploy a content-understanding AI model in Microsoft Foundry.
- Test an image-based prompt in the chat playground.
- Use the Azure OpenAI SDK to analyze images in Python.

## Prerequisites

Before starting this module, you should have:

- Experience with deploying generative AI models in Microsoft Foundry.
- Programming experience.

---

## Introduction

Images, documents, and other unstructured content often contain valuable information that's hard to extract automatically. Azure Content Understanding solves this problem by using generative AI to analyze content and return structured data.

With Content Understanding, you define a schema describing the data you want, and the service extracts it from your images and documents. The output is ready to use in automation workflows, analytics, and search applications.

In this module, you'll learn how to analyze images with Content Understanding using both prebuilt and custom analyzers.

> **Note:** Different people like to learn in different ways. The text content below contains greater detail than the video presentations.

---

## What is Content Understanding?

Azure Content Understanding is a Foundry Tool that uses generative AI to process and extract insights from many types of content, including documents, images, videos, and audio. It transforms unstructured data into structured, actionable output that you can integrate into automation and analytical workflows.

### Why use Content Understanding?

Content Understanding accelerates time to value by enabling straight-through processing of unstructured data. Key benefits include:

- **Simplified workflows**: Standardizes extraction and classification of content from various content types into a unified process
- **Easy field extraction**: Define a schema to extract, classify, or generate field values without complex prompt engineering
- **Enhanced accuracy**: Uses multiple AI models to analyze and cross-validate information simultaneously
- **Confidence scores and grounding**: Ensures accuracy of extracted values while minimizing the cost of human review
- **Content classification**: Categorize document types to streamline processing and route content to appropriate analyzers

### Content Understanding components

The Content Understanding framework processes unstructured content through multiple stages:

| Component | Description |
| --- | --- |
| **Inputs** | Source content including documents, images, video, and audio |
| **Analyzer** | Defines how content is processed, including extraction settings and field schema |
| **Content extraction** | Transforms unstructured input into normalized text and metadata using OCR, speech transcription, and layout detection |
| **Field extraction** | Generates structured key-value pairs based on your defined schema |
| **Confidence scores** | Provides reliability estimates from 0 to 1 for each extracted field value |
| **Grounding** | Identifies specific regions in content where each value was extracted |
| **Structured output** | Final result as Markdown for search scenarios or JSON for automation workflows |

### Analyzers

Analyzers are the core component that defines how your content is processed. Content Understanding offers two types:

- **Prebuilt analyzers**: Ready-to-use analyzers designed for common scenarios like invoice processing, receipt extraction, and call center analytics
- **Custom analyzers**: Tailored analyzers you create with your own field schema for specific business needs

When you create an analyzer, you configure:

- The base analyzer type (document, image, audio, or video)
- The AI models to use for processing
- The field schema that defines what data to extract
- Options like confidence scoring and content segmentation

### Use cases

Content Understanding supports many business scenarios:

| Use case | Description |
| --- | --- |
| **Intelligent document processing** | Convert unstructured documents into structured data for invoice processing, contract analysis, and claims management |
| **Search and RAG** | Ingest multimodal content into search indexes with figure descriptions and layout analysis |
| **Agentic applications** | Transform messy file inputs into predictable, standardized inputs for AI agents |
| **Analytics and reporting** | Extract field outputs to gain insights and make informed decisions |

### Content restrictions

Content Understanding includes built-in Responsible AI protections. The service integrates Azure AI Content Safety to detect and prevent harmful content. When processing content, be aware of these guidelines:

- Content is filtered for harmful material including violence, hate speech, and exploitation
- Face description capabilities can identify facial attributes in video and image content
- Biometric data processing requires appropriate notice and consent from data subjects

With Content Understanding, you can build solutions that extract meaningful insights from diverse content types while maintaining data quality and compliance.

---

## Analyze images with Content Understanding

Content Understanding can analyze images to extract structured data, identify visual elements, and generate descriptions. You can use prebuilt analyzers for common scenarios or create custom analyzers tailored to your specific needs.

### Supported image formats

Content Understanding supports the following image input types:

| Format | Description |
| --- | --- |
| **JPEG** | Standard photographic images |
| **PNG** | Images with transparency support |
| **BMP** | Bitmap images |
| **TIFF** | High-quality scanned documents |
| **HEIF** | High-efficiency image format |
| **PDF** | Single or multi-page documents with embedded images |

### Prebuilt image analyzers

Content Understanding includes prebuilt analyzers optimized for common image analysis scenarios:

- **prebuilt-image**: General-purpose image analysis with content extraction and figure description
- **prebuilt-receipt**: Extract vendor names, items, totals, and dates from receipt images
- **prebuilt-invoice**: Extract invoice details including line items, amounts, and vendor information
- **prebuilt-idDocument**: Extract information from identity documents like driver's licenses and passports

### Define a field schema for images

To extract specific information from images, define a field schema that describes the data you want. Each field can use one of three extraction methods:

| Method | Description | Example |
| --- | --- | --- |
| **extract** | Pull values directly as they appear in the image | Extract text from a label or sign |
| **classify** | Categorize content from predefined options | Classify image as "damaged" or "undamaged" |
| **generate** | Create values based on image analysis | Generate a description of the scene |

Here's an example schema for analyzing product images:

```json
{
  "description": "Product image analyzer",
  "baseAnalyzerId": "prebuilt-image",
  "fieldSchema": {
    "fields": {
      "ProductName": {
        "type": "string",
        "method": "extract",
        "description": "Name of the product visible in the image"
      },
      "Condition": {
        "type": "string",
        "method": "classify",
        "description": "Condition of the product",
        "enum": ["new", "used", "damaged"]
      },
      "Description": {
        "type": "string",
        "method": "generate",
        "description": "Brief description of what the image shows"
      }
    }
  }
}
```

### Analyze an image

To analyze an image using Content Understanding, you can use the Python SDK, which you can install using `pip` like this:

```bash
pip install azure-ai-contentunderstanding
```

To submit a request to the analyze endpoint with your analyzer ID and the image URL or file, you can use code similar to this example:

```python
from azure.ai.contentunderstanding import ContentUnderstandingClient
from azure.ai.contentunderstanding.models import AnalysisInput, AnalysisResult
from azure.core.credentials import AzureKeyCredential # for key-based authentication
from azure.identity import DefaultAzureCredential # for Entra ID authentication

# Get a client
credential = AzureKeyCredential(key)
client = ContentUnderstandingClient(endpoint={FOUNDRY_ENDPOINT},
                                    credential={KEY_OR_IDENTITY},
                                    api_version="2025-11-01")

# Analyze an image file
with open("my_image.png", "rb") as f:
            file_bytes = f.read()

try:
    poller = client.begin_analyze(
        analyzer_id={ANALYSER_ID},
        inputs=[AnalysisInput(data=file_bytes)],
    )
    # Get results asynchronously from poller
    result: AnalysisResult = poller.result()

    # Display results
    result_str = json.dumps(result.as_dict(), indent=2)
    print (result_str)

except Exception as ex:
    print(f"[Unexpected Error]: {ex}")
    sys.exit(1)
```

When analysis completes, the results include the extracted content:

- **markdown**: A text representation of the image content, useful for search and RAG scenarios
- **fields**: Extracted field values matching your schema, each with a confidence score
- **source**: Grounding information showing where in the image each value was found

Example response for a product image:

```json
{
  "contents": [
    {
      "markdown": "Product label showing 'Contoso Widget Pro' with serial number...",
      "fields": {
        "ProductName": {
          "type": "string",
          "valueString": "Contoso Widget Pro",
          "confidence": 0.95,
          "source": "D(1,100,50,300,50,300,80,100,80)"
        },
        "Condition": {
          "type": "string",
          "valueString": "new",
          "confidence": 0.89
        },
        "Description": {
          "type": "string",
          "valueString": "A silver electronic device in retail packaging with product label visible"
        }
      }
    }
  ]
}
```

### Use confidence scores

Each extracted field includes a confidence score from 0 to 1:

- **High confidence (0.9+)**: Value can be trusted for automated processing
- **Medium confidence (0.7-0.9)**: Consider human review for critical applications
- **Low confidence (<0.7)**: Recommend manual verification

Use confidence scores to build automation workflows that route low-confidence extractions to human reviewers while processing high-confidence results automatically.

### Tips for better image analysis

- **Image quality matters**: Higher resolution images produce more accurate extractions
- **Lighting and contrast**: Ensure text and visual elements are clearly visible
- **Single focus**: Images with one clear subject yield better results than cluttered scenes
- **Consistent orientation**: Upright images are processed more reliably than rotated ones

Content Understanding's image analysis capabilities enable you to transform visual content into structured, actionable data for document processing, inventory management, quality inspection, and many other business scenarios.

---

## Summary

In this module, you learned how to analyze images using Azure Content Understanding in Microsoft Foundry.

You explored how to:

- Understand the components of Content Understanding, including analyzers, field extraction, and confidence scores
- Use prebuilt analyzers for common scenarios like receipts, invoices, and identity documents
- Define field schemas with extract, classify, and generate methods
- Analyze images using the Content Understanding API

Content Understanding transforms unstructured visual content into structured, actionable data. By defining a schema and using prebuilt or custom analyzers, you can automate image analysis for document processing, inventory management, quality inspection, and other business scenarios.

> For more information about Content Understanding, see [What is Azure Content Understanding?](https://learn.microsoft.com/en-us/azure/ai-services/content-understanding/overview) in the Azure AI documentation.

---

## Exercise / Lab

Hands-on lab: [04-content-understanding.md](../../../labs/mslearn-ai-vision/Instructions/Exercises/04-content-understanding.md)
