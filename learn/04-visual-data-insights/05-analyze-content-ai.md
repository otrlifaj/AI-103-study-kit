# Create a multimodal analysis solution with Azure Content Understanding

**Module slug:** `analyze-content-ai`
**MS Learn:** https://learn.microsoft.com/en-us/training/modules/analyze-content-ai/

## Learning objectives

After completing this module, you will be able to:

- Describe capabilities of Azure Content Understanding.
- Use Azure Content Understanding to build a content analyzer.
- Consume a Content Understanding analyzer by using the API.

## Prerequisites

Before starting this module, you should:

- Be familiar with Azure services and the Azure portal.
- Have some familiarity with APIs.

---

## Introduction

Organizations today rely on information that is often locked up in content assets such as documents, images, videos, and audio recordings. Extracting information from this content can be challenging, laborious, and time-consuming, and organizations often need to build solutions based on multiple technologies for content analysis depending on the formats being used.

Azure Content Understanding is a multimodal service that simplifies the creation of AI-powered analyzers that can extract information from content in practically any format.

![Diagram of Azure Content Understanding extracting information from documents, audio files, videos, and images.](resources/analyze-content-ai-content-understanding.png)

In this module, you'll explore the capabilities of Azure Content Understanding, and learn how to use it to build custom analyzers.

> **Note:** Different people like to learn in different ways. The MS Learn module offers a video-based format in addition to the text content below. The text contains greater detail than the videos.

---

## What is Azure Content Understanding?

Azure Content Understanding is a generative AI service that you can use to extract insights and data from multiple kinds of content. With Content Understanding, you can quickly build applications that analyze complex data and generate outputs that can be used to automate and optimize processes.

Content Understanding is available through Microsoft Foundry. To use it, you need to provision a Microsoft Foundry resource in your Azure subscription. You can develop and manage a Content Understanding solution:

- In the Microsoft Foundry portal
- In Content Understanding Studio
- By using the Content Understanding API

### Multimodal content analysis

Content Understanding can extract information from common kinds of content, enabling you to use a single service with a straightforward and consistent development process to build multimodal content analysis solutions.

#### Documents and forms

You can use Content Understanding to analyze documents and forms and retrieve specific field values. For example, you could extract key data values from an invoice to automate payment processing.

![Screenshot of an invoice being analyzed by Content Understanding.](resources/analyze-content-ai-document-analysis.png)

#### Images

You can analyze images to infer information from visuals such as charts, identify physical defects in products or other items, detect the presence of specific objects or people, or determine other information visually.

![Screenshot of an image being analyzed by Content Understanding.](resources/analyze-content-ai-image-analysis.png)

#### Audio

Analysis of audio enables you to automate tasks like summarizing conference calls, determining sentiment of recorded customer conversations, or extracting key data from telephone messages.

![Screenshot of an audio file being analyzed by Content Understanding.](resources/analyze-content-ai-audio-analysis.png)

#### Video

Video accounts for a large volume of the data captured today, and you can use Content Understanding to analyze and extract insights from video to support many scenarios. For example, to extract key points from video conference recordings, to summarize presentations, or to detect the presence of specific activity in security footage.

![Screenshot of a video file being analyzed by Content Understanding.](resources/analyze-content-ai-video-analysis.png)

---

## Create a Content Understanding analyzer

Content Understanding solutions are based on the creation of an *analyzer*; which is trained to extract specific information from a particular type of content based on a *schema* that you define.

The high-level process for creating a Content Understanding solution includes the following steps:

![Diagram of a sample document being used to create a schema for an analyzer that is consumed by a client application.](resources/analyze-content-ai-analyzer.png)

1. Create a Foundry resource.
2. Define a Content Understanding schema for the information to be extracted. This can be based on a content sample and an analyzer template.
3. Build an analyzer based on the completed schema.
4. Use the analyzer to extract or generate fields from new content.

Numerous analyzer templates are provided to help you develop an appropriate analyzer for your needs quickly. Additionally, because of the generative AI capabilities of Content Understanding, you can use minimal training data to define a schema by example. In many cases, the service accurately identifies the data values in the sample content that map to the schema elements automatically, though you can also explicitly label fields in content such as documents to improve the performance of your analyzer.

### Creating an analyzer with Content Understanding Studio

While you can develop a complete Content Understanding solution through the API or a language specific SDK, Content Understanding Studio provides a visual interface to create a project, define a Content Understanding schema, and build and test an analyzer.

> **Tip:** Only certain prebuilt models are available for use directly in the Microsoft Foundry portal. For custom analyzer creation and testing, use **[Content Understanding Studio](https://ai.azure.com/contentunderstanding)**.

#### Creating a Content Understanding project

In Content Understanding Studio, you can create a new project that is associated with a Microsoft Foundry resource. Creating a project provisions the Azure resources needed to support your Content Understanding solution, including storage and a key vault resource to store sensitive details like credentials and keys.

![Screenshot of the Create new project user interface in Content Understanding Studio.](resources/analyze-content-ai-new-project.png)

> **Note:** Content Understanding schemas can only be created in Azure locations where the service is supported. For more information, see [Content Understanding region and language support](https://learn.microsoft.com/en-us/azure/ai-services/content-understanding/language-region-support).

#### Defining a schema

After creating a project, the first step in building an analyzer is to define a schema for the content the analyzer will process, and the information it will extract. Content Understanding Studio provides a schema editor interface in which you can upload a file (document, image, audio, or video) on which the schema should be based. You can then apply an appropriate schema template and define the specific fields you want the analyzer to identify.

![Screenshot of the Define schema user interface in Content Understanding Studio.](resources/analyze-content-ai-slide-schema.png)

> **Note:** The templates and field types available in a schema depend on the content type of the file on which the schema is based. Some content types support additional optional functionality, such as extracting barcodes and formulae from text in documents. For more information about using Content Understanding with different content types, see:
>
> - [Content Understanding document solutions](https://learn.microsoft.com/en-us/azure/ai-services/content-understanding/document/overview)
> - [Content Understanding image solutions](https://learn.microsoft.com/en-us/azure/ai-services/content-understanding/image/overview)
> - [Content Understanding audio solutions](https://learn.microsoft.com/en-us/azure/ai-services/content-understanding/audio/overview)
> - [Content Understanding video solutions](https://learn.microsoft.com/en-us/azure/ai-services/content-understanding/video/overview)

#### Testing

You can test the analyzer schema at any time during the development process by running analysis on the sample file used to define the schema or other uploaded files. The test results include the extracted field values and the JSON format output returned by the analyzer to client applications.

![Screenshot of analysis test results in Content Understanding Studio.](resources/analyze-content-ai-slide-analysis.png)

#### Building an analyzer

When you're satisfied with the performance of your schema, you can build your analyzer. Building an analyzer makes it accessible to client applications through the endpoint for the Microsoft Foundry resource associated with your project.

After building your analyzer, you can continue to test it in Content Understanding Studio, and refine the schema to create new named versions with different capabilities.

---

## Use the Content Understanding API

The Content Understanding API provides a programmatic interface that you can use to create, manage, and consume analyzers.

To use the API, your client application submits HTTP calls to the Content Understanding endpoint for your Microsoft Foundry resource, passing one of the authorization keys in the header. You can obtain the endpoint and keys in the Azure portal or in the Microsoft Foundry portal. You can also use the Microsoft Foundry API to connect to the project programmatically with your Entra ID.

### Using the API to analyze content

One of the most common uses of the API is to submit content to an existing analyzer that you have previously built, and retrieve the results of analysis. The analysis request returns an operation ID value that represents an asynchronous task. Your client application must then use another request to pass the operation ID back to the endpoint and retrieve the operation status — potentially polling multiple times until the operation is complete and the results are returned in JSON format.

For example, to analyze a document, a client application might submit a POST request to the `analyze` function containing the following JSON body:

```json
POST {endpoint}/contentunderstanding/analyzers/{analyzer}:analyze?api-version=2025-11-01
{
  "inputs": [
    {
      "url": "https://host.com/doc.pdf"
    }
  ]
}
```

> **Note:** You can specify a URL for the content file location as shown here. To submit binary file data directly, use the `analyzeBinary` operation instead.

Assuming the request is authenticated and initiated successfully, the response will be similar to this example:

```http
Operation-Id: 1234abcd-1234-abcd-1234-abcd1234abcd
Operation-Location: {endpoint}/contentunderstanding/analyzerResults/1234abcd-1234-abcd-1234-abcd1234abcd?api-version=2025-11-01
{
  "id": "1234abcd-1234-abcd-1234-abcd1234abcd",
  "status": "NotStarted"
}
```

Your client application must then use the operation ID that has been returned to check the status of the operation until it has succeeded (or failed) by submitting a GET request to the `analyzerResults` endpoint:

```http
GET {endpoint}/contentunderstanding/analyzerResults/1234abcd-1234-abcd-1234-abcd1234abcd?api-version=2025-11-01
```

When the operation has completed successfully, the response contains a JSON payload representing the results of the analysis. The specific results depend on the content and schema.

> **Note:** For more information about the Content Understanding API, see the [reference documentation](https://learn.microsoft.com/en-us/rest/api/contentunderstanding/operation-groups).

---

## Summary

Azure Content Understanding is a multimodal AI service that enables you to extract information from many different kinds of content. In this module, you learned how to use Content Understanding Studio to create a Content Understanding project and build an analyzer.

> **Note:** For more information about Azure Content Understanding, see [Azure Content Understanding documentation](https://learn.microsoft.com/en-us/azure/ai-services/content-understanding/).

---

## Exercise / Lab

Hands-on lab: [01-content-understanding.md](../../../labs/mslearn-ai-information-extraction/Instructions/Exercises/01-content-understanding.md)

> **Source:** [Exercise - Extract information from multimodal content](https://microsoftlearning.github.io/mslearn-ai-information-extraction/Instructions/Exercises/01-content-understanding.html)
