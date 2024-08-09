import pandas as pd
from pandasai import PandasAI
from pandasai.llm.openai import OpenAI

df = pd.read_csv("supermarket_sales.csv")