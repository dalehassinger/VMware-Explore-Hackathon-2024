from pandasai import SmartDataframe
from pandasai.llm.local_llm import LocalLLM
ollama_llm = LocalLLM(api_base="http://localhost:11434/v1", model="llama3") df = SmartDataframe("/Users/dalehassinger/Documents/GitHub/PS-TAM-Lab/RVTools/RVTools_export_all_2024-06-28_04.55.40/RVTools_tabvInfo.csv", config={"llm": ollama_llm})