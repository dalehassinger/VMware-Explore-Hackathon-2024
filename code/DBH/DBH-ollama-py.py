import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv('/Users/dalehassinger/Documents/GitHub/PS-TAM-Lab/RVTools/RVTools_export_all_2024-06-28_04.55.40/RVTools_tabvInfo.csv')

# Display the first few rows to verify the data
print(df.head())



import requests

# Define the API endpoint
url = "http://localhost:11434/api/generate"  # Replace with the actual API endpoint

# Create a function to ask a question using data from the CSV
def ask_ollama(question):
    # Replace 'your-api-key' with your actual API key
    headers = {
        'Content-Type': 'application/json'
    }
    
    # Set up the JSON payload
    payload = {
        "model": "llama3",  # Replace with the specific model you're using
        "prompt": question
    }
    
    # Make the API request
    response = requests.post(url, json=payload, headers=headers)
    
    # Check for successful response
    if response.status_code == 200:
        return response.json()['response']  # Adjust based on actual response format
    else:
        return f"Error: {response.status_code} - {response.text}"

# Example usage with data from the CSV
for index, row in df.iterrows():
    question = f"Can you provide more details about {row['Name']}?"
    response = ask_ollama(question)
    print(f"Response for {row['Name']}: {response}")