# Generate videos with Microsoft Foundry

## Learning objectives

After completing this module, you'll be able to:

- Deploy a video-generating AI model in Microsoft Foundry.
- Test a video-based prompt in the chat playground.
- Use the Azure OpenAI SDK to generate and remix videos in Python.

## Prerequisites

Before starting this module, you should have:

- Experience with deploying generative AI models in Microsoft Foundry.
- Programming experience.

---

## Introduction

Generative AI has expanded beyond text and images to video creation. With Sora 2 in Microsoft Foundry, you can generate realistic and imaginative video scenes from text prompts, reference images, or by remixing existing videos.

In this module, you'll learn how to deploy Sora 2, write effective prompts for video generation, and build a Python application that creates videos programmatically using the OpenAI SDK.

> **Note:** The text content contains greater detail than any video presentation, so refer to it as supplemental material as needed.

---

## Deploy a video generating model

To generate videos from text prompts, you need to deploy a video generation model. **Sora 2** is an AI model from OpenAI that creates realistic and imaginative video scenes from text instructions, input images, or existing videos. Sora 2 is available in Microsoft Foundry and provides an all-in-one creative platform with superior video quality and intuitive controls.

### Prerequisites

Before deploying a Sora 2 model, ensure you have:

- An Azure subscription
- Access to the Microsoft Foundry portal
- A Foundry project where you have permissions to deploy models

### Deploy the Sora 2 model

To deploy a Sora 2 video generation model in Microsoft Foundry:

1. Go to the [Microsoft Foundry portal](https://ai.azure.com) and sign in with your credentials.
2. From the Foundry landing page, create or select a project.
3. Select **Build** from the navigation pane on the right.
4. Select **Models** from the left-hand menu to view the model catalog.
5. Use the search bar or filter options to find the **Sora-2** video generation model.
6. Select the **Sora-2** model then select **Deploy** and choose the appropriate deployment settings.

> **Tip:** To learn more about available models in Microsoft Foundry, see the [Model catalog and collections in Microsoft Foundry portal](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/model-catalog-overview) article in the Microsoft Foundry documentation.

### Sora 2 capabilities

Sora 2 offers several powerful capabilities for video generation:

| Feature | Description |
| --- | --- |
| **Text to video** | Generate videos from natural language text prompts |
| **Image to video** | Transform existing images into video content |
| **Video remix** | Make targeted adjustments to existing videos without regenerating from scratch |
| **Audio generation** | Supports audio generation in output videos |
| **Multiple resolutions** | Supports portrait (720×1280) and landscape (1280×720) formats |
| **Variable duration** | Generate videos of 4, 8, or 12 seconds |

Sora 2 enables you to create realistic and imaginative video content from text prompts, reference images, or by remixing existing videos. After deploying the model through the Foundry portal, you can use it to generate videos in various resolutions and durations. The model's versatility and ease of use make it a powerful tool for video creation, whether you're starting from scratch or enhancing existing media.

---

## Generate video from a prompt

Once your Sora 2 model is deployed, you can start generating videos. Video generation is an asynchronous process—you submit a request with your prompt and video settings, then retrieve the completed video when it's ready.

### Video generation parameters

Before crafting your prompt, understand the API parameters that control your video output:

| Parameter | Description | Supported values |
| --- | --- | --- |
| **prompt** | Natural language description of your video | Text string (required) |
| **model** | The model to use | `sora-2` or `sora-2-pro` |
| **size** | Output resolution | `1280x720` (landscape), `720x1280` (portrait) |
| **seconds** | Video duration | `4`, `8`, or `12` (default: 4) |
| **input\_reference** | Reference image for the first frame | JPEG, PNG, or WebP file |
| **remix\_video\_id** | ID of a previous video to remix | Video ID string |

> **Tip:** The model follows instructions more reliably in shorter clips. For best results, consider generating two 4-second clips and stitching them together rather than a single 8-second clip.

### Test video generation in the playground

After deploying the Sora 2 model, you can test it using the Video playground in Microsoft Foundry portal:

![Screenshot of the video playground.](resources/generate-video-with-foundry-video-playground.png)

1. Navigate to your deployed Sora 2 model in the Foundry portal.
2. Select the **Playground** tab to access the video generation interface.
3. Enter your prompt into the text box describing the video you want to generate.
4. Configure video settings such as resolution and duration.
5. Select **Generate** to start video creation.

Video generation typically takes 1 to 5 minutes depending on your settings. When the AI-generated video is ready, it appears on the page.

> **Note:** The content generation APIs include a content moderation filter. If Azure OpenAI recognizes your prompt as harmful content, it won't return a generated video. For more information, see [Content filtering](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter).

In the video playground, you can also view cURL code samples that are prefilled according to your settings. Select the **View code** button at the top of the playground to access sample code you can use in your applications.

### Writing effective prompts

Think of prompting like briefing a cinematographer. The more specific you are about what the shot should achieve, the more control and consistency you'll get. However, leaving some details open can lead to creative, unexpected results.

#### Prompt anatomy

A clear prompt describes a shot as if you were sketching it onto a storyboard:

- **Camera framing**: Specify the shot type (wide, medium, close-up) and angle
- **Subject description**: Anchor your subject with distinctive details
- **Action**: Describe movement in beats—small steps, gestures, or pauses
- **Lighting and palette**: Set the mood with lighting direction and color anchors
- **Style**: Establish the aesthetic early (for example, "1970s film" or "handheld documentary")

#### Weak vs. strong prompts

| Weak prompt | Strong prompt |
| --- | --- |
| "A beautiful street at night" | "Wet asphalt, zebra crosswalk, neon signs reflecting in puddles" |
| "Person moves quickly" | "Cyclist pedals three times, brakes, and stops at crosswalk" |
| "Cinematic look" | "Anamorphic 2.0x lens, shallow DOF, volumetric light" |

#### Example prompt

Here's an example of a well-structured prompt:

```text
In a 90s documentary-style interview, an old Swedish man sits in a study 
and says, "I still remember when I was young."
```

This prompt works because:

- "90s documentary" sets the style, so the model chooses appropriate camera, lighting, and color
- "old Swedish man sits in a study" describes subject and setting while allowing creative interpretation
- The dialogue gives the model specific words to sync with the character

### Using reference images

For more control over composition and style, use the `input_reference` parameter to provide a visual reference. The model uses the image as an anchor for the first frame, while your prompt defines what happens next.

Requirements for reference images:

- The image resolution must match the target video size (`1280x720` or `720x1280`)
- Supported formats: JPEG, PNG, WebP

### Remixing existing videos

The remix feature lets you modify specific aspects of an existing video while preserving its core elements—scene transitions, visual layout, and overall structure. This is useful for making targeted adjustments without regenerating from scratch.

To remix a video:

1. Generate a video and note its video ID from the completed job
2. Call the remix endpoint with the original video ID and an updated prompt
3. Describe only the changes you want—keep modifications focused

For best results:

- Limit changes to one clearly articulated adjustment
- Be specific about what to change: "same shot, switch to 85mm lens" or "same lighting, new palette: teal, sand, rust"
- Narrow, precise edits retain greater fidelity to the source material

### Tips for better results

- **Keep it simple**: Each shot should have one clear camera move and one clear subject action
- **Use beats for timing**: Instead of "actor walks across the room," try "actor takes four steps to the window, pauses, and pulls the curtain"
- **Be consistent**: Reuse phrasing for characters across shots to maintain continuity
- **Iterate**: Small changes to camera, lighting, or action can shift outcomes dramatically—treat each generation as a creative variation

Video generation with Sora 2 is a collaborative process. You provide direction, and the model delivers creative variations. Be prepared to experiment—sometimes the second or third generation is the best one.

---

## Generate video in Python

To build applications that generate videos programmatically, you can use the OpenAI Python SDK with your Sora 2 deployment in Microsoft Foundry. Video generation is an asynchronous process—you submit a job, poll for status, and download the result when it's ready.

### Generate a video

Video generation follows a three-step pattern: create the job, poll for completion, and download the result.

```python
import time

# Create the video generation job
video = client.videos.create(
    model="sora-2",
    prompt="A robot walks through a rainy city street at dusk, neon signs reflecting in puddles",
    size="1280x720",
    seconds="4",
)

print(f"Video creation started. ID: {video.id}")

# Poll for completion
while video.status not in ["completed", "failed", "cancelled"]:
    print(f"Status: {video.status}. Waiting...")
    time.sleep(20)
    video = client.videos.retrieve(video.id)

# Download when complete
if video.status == "completed":
    content = client.videos.download_content(video.id, variant="video")
    content.write_to_file("output.mp4")
    print("Video saved to output.mp4")
```

### Generate video from a reference image

To use an image as a starting frame, pass it to the `input_reference` parameter. The image resolution must match the target video size:

```python
video = client.videos.create(
    model="sora-2",
    prompt="The camera slowly pans across the landscape as clouds drift overhead",
    size="1280x720",
    seconds="4",
    input_reference=open("landscape.png", "rb"),
)
```

> **Note:** Reference images containing human faces are currently rejected. Use images of landscapes, objects, or animated characters instead.

### Remix an existing video

To modify an existing video while preserving its structure, use the remix method with the original video's ID:

```python
video = client.videos.remix(
    video_id="video_abc123",
    prompt="Change the color palette to warm sunset tones",
)
```

### Handle job states

Video jobs can return these status values:

| Status | Description |
| --- | --- |
| `queued` | Job is waiting to be processed |
| `in_progress` | Video is being generated |
| `completed` | Video is ready for download |
| `failed` | Generation failed (check error details) |
| `cancelled` | Job was canceled |

When a job fails, check `video.error` for details about what went wrong.

### Key considerations

- **Rate limits**: You can run up to two video creation jobs simultaneously
- **Job expiration**: Completed videos are available for download for 24 hours
- **Resolution requirements**: Reference images must match the target video resolution exactly
- **Content filtering**: Prompts are subject to content moderation; harmful content won't generate

---

## Summary

In this module, you learned how to generate videos using Sora 2 in Microsoft Foundry.

You explored how to:

- Deploy a Sora 2 video generation model in Microsoft Foundry
- Write effective prompts that describe camera framing, subject details, action, and lighting
- Use the Video playground to test video generation with different settings
- Generate videos from reference images and remix existing videos
- Build a Python application that creates videos programmatically using the OpenAI SDK

With Sora 2, you can create realistic and imaginative video content from text prompts, transform images into videos, and make targeted adjustments to existing videos. The asynchronous API pattern—submit a job, poll for status, download the result—enables you to integrate video generation into your applications.

> **Tip:** For more information about video generation with Sora 2, see [Video generation with Sora](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/video-generation) in the Azure OpenAI documentation.

---

## Exercise / Lab

Hands-on lab: [03-generate-video.md](../../../labs/mslearn-ai-vision/Instructions/Exercises/03-generate-video.md)
