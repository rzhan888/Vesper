"""
title: Python Interpreter
author: Vesper Team
author_url: https://github.com/rzhan888/Vesper
version: 0.1.0
requirements: pandas, matplotlib, numpy
"""

import sys
import io
import contextlib
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import base64

class Tools:
    def __init__(self):
        pass

    def run_python_code(self, code: str) -> str:
        """
        Execute arbitrary Python code in a sandboxed environment and return the output (stdout) or error.
        Use this tool when you need to perform calculations, data analysis, or manipulate strings/lists beyond simple text generation.
        You have access to pandas, numpy, and matplotlib.
        
        Example:
        code = "print(1 + 1)"
        
        :param code: The python code to execute.
        :return: String containing stdout or error message.
        """
        # Create string buffers for stdout and stderr
        s_out = io.StringIO()
        s_err = io.StringIO()
        
        # Capture stdout and stderr
        try:
            with contextlib.redirect_stdout(s_out), contextlib.redirect_stderr(s_err):
                # Clear any existing plots
                plt.clf()
                
                # Using a restricted scope
                exec_scope = {
                    "pd": pd,
                    "np": np,
                    "plt": plt,
                    "print": print
                }
                exec(code, exec_scope)
                
                # Check if a plot was created using plt.gcf() (Get Current Figure)
                # We check if there are any axes on the current figure
                if plt.get_fignums():
                    # Save plot to buffer
                    buf = io.BytesIO()
                    plt.savefig(buf, format='png')
                    buf.seek(0)
                    
                    # Encode to base64
                    img_str = base64.b64encode(buf.read()).decode('utf-8')
                    
                    # Create markdown image
                    plot_markdown = f"\n![Plot](data:image/png;base64,{img_str})"
                    print(plot_markdown)
                    
                    # Clean up
                    plt.clf()
            
            output = s_out.getvalue()
            error = s_err.getvalue()
            
            if error:
                return f"Output:\n{output}\n\nErrors:\n{error}"
            return output if output else "[No Output]"

        except Exception as e:
            return f"Runtime Error: {e}"
