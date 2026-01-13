"""
title: Deep Research
author: Vesper Team
author_url: https://github.com/rzhan888/Vesper
version: 0.1.0
requirements: duckduckgo-search, beautifulsoup4, requests
"""

import requests
from bs4 import BeautifulSoup
from duckduckgo_search import DDGS
import json

class Tools:
    def __init__(self):
        pass

    def deep_research(self, query: str) -> str:
        """
        Perform deep research on a topic by searching the web, visiting the top links, and extracting their content.
        Use this tool when users ask for a "deep dive" or "comprehensive research" on a topic.
        :param query: The research topic or specific question.
        :return: A compilation of content from the top search results.
        """
        try:
            # 1. Search
            print(f"Searching for: {query}")
            results = list(DDGS().text(query, max_results=3))
            
            research_data = []
            
            # 2. Scrape content
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
            
            for result in results:
                url = result['href']
                title = result['title']
                print(f"Visiting: {url}")
                
                try:
                    response = requests.get(url, headers=headers, timeout=10)
                    if response.status_code == 200:
                        soup = BeautifulSoup(response.content, 'html.parser')
                        
                        # Remove script and style elements
                        for script in soup(["script", "style"]):
                            script.decompose()
                            
                        text = soup.get_text(separator=' ', strip=True)
                        
                        # Simple truncation to avoid context limit issues (adjust as needed)
                        # ~4000 characters is roughly 1000 tokens
                        text_snippet = text[:4000] 
                        
                        research_data.append({
                            "title": title,
                            "url": url,
                            "content": text_snippet
                        })
                    else:
                        research_data.append({
                            "title": title,
                            "url": url,
                            "error": f"Status code {response.status_code}"
                        })
                except Exception as e:
                    research_data.append({
                        "title": title,
                        "url": url,
                        "error": str(e)
                    })
            
            return json.dumps(research_data, indent=2)
            
        except Exception as e:
            return f"Error executing deep research: {e}"
