"""
title: Web Search
author: Vesper Team
author_url: https://github.com/rzhan888/Vesper
version: 0.1.0
requirements: duckduckgo-search
"""

from duckduckgo_search import DDGS
import json

class Tools:
    def __init__(self):
        pass

    def search_web(self, query: str) -> str:
        """
        Search the web for the given query and return the top results.
        :param query: The search query.
        :return: A string containing the search results (title, link, snippet).
        """
        try:
            results = list(DDGS().text(query, max_results=5))
            return json.dumps(results, indent=2)
        except Exception as e:
            return f"Error searching web: {e}"
