# Agent & Deep Research Setup

To enable Agent Mode and Deep Research capabilities in Vesper, you need to import the custom Python tools provided in `assets/tools`.

## Prerequisites

The Open WebUI environment is pre-configured to support Python tools. The provided tools require the following packages:

- `duckduckgo-search`
- `beautifulsoup4`
- `requests`

_Note: Open WebUI automatically attempts to install packages listed in the tool's `requirements` metadata when you import them._

## Installation Steps

1. **Log in** to your Open WebUI instance as an Admin.
2. Navigate to **Workspace** -> **Tools**.
3. Click the **"+" (Import Tools)** or **Create Tool** button.
4. **Web Search Tool**:
   - Open standard file `assets/tools/web_search.py`.
   - Copy the entire content.
   - Paste it into the "Tools" editor in Open WebUI.
   - Click **Save**.
5. **Deep Research Tool**:
   - Open `assets/tools/deep_research.py`.
   - Copy the content.
   - Create another new tool and paste the content.
   - Click **Save**.

## 3. Python Interpreter (Code Execution)

- Open `assets/tools/python_interpreter.py`.
- Copy the content.
- Create a new tool in Open WebUI named **"Python Code Interpreter"**.
- Paste the content and click **Save**.

## 4. Creating the "Vesper Agent" Persona

To get the "ChatGPT Agent Mode" experience (autonomy + tools), you must create a specific Model entry.

1. Go to **Workspace** -> **Models**.
2. Click **Create Model**.
3. **Base Model**: Choose a strong reasoning model (e.g., GPT-4o, Llama 3.1 70B, or Claude 3.5 Sonnet).
4. **Name**: `Vesper Agent`.
5. **System Prompt**: Copy the content from `assets/agent_system_prompt.txt`.
6. **Tools**: Enable ALL the tools you created:
   - Web Search
   - Deep Research
   - Python Interpreter
7. **Capabilities**: Enable "Code Interpreter" (native) if available in your Open WebUI version, but our custom tool acts as a fallback.
8. Click **Save & Update**.

## Using Agent Mode

Select **Vesper Agent** from the model dropdown.

- **Ask complex questions**: "Research the stock performance of Apple vs Microsoft over the last 5 years and plot a trend line."
- The agent will:
  1. Search for the data (Web Search).
  2. Write python code to calculate the trends (Python Interpreter).
  3. Give you the final answer.
