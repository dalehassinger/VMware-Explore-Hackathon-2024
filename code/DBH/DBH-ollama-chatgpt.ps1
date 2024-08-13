# Define the path to the CSV file
$csvFilePath = "/Users/dalehassinger/Documents/GitHub/PS-TAM-Lab/RVTools/RVTools_export_all_2024-06-28_04.55.40/RVTools_tabvInfo.csv"

# Import the CSV data
$csvData = Import-Csv -Path $csvFilePath

# Convert the CSV data to JSON
$jsonData = $csvData | ConvertTo-Json

# Optionally, save the JSON to a file
#$jsonFilePath = "path\to\your\file.json"
#$jsonData | Set-Content -Path $jsonFilePath

# Output the JSON data to the console (optional)
$jsonData

# --------------------

$question = "Based on the following data, Show me the VM names where Powerstate equal to poweredOff"

# Set request body
$requestBody = @{
    model = "llama3.1";
    prompt = "$question";
    data = $jsonData;
    stream = $false;
}

      
# Set headers
$headers = @{'Content-Type'='application/json'}
$Body = ($requestBody | ConvertTo-Json)
    
# Send the request
$request = Invoke-WebRequest -Uri 'http://localhost:11434/api/generate' -Method Post -Headers $headers -Body $Body
$response =$request.Content | ConvertFrom-Json

# Print response to console
Write-Host $response.response





# ------ Below here works

$question = "What is PowerCLI"

# Set request body
$requestBody = @{
    model = "llama3";
    prompt = "$question";
    stream = $false;
}

      
# Set headers
$headers = @{'Content-Type'='application/json'}
$Body = ($requestBody | ConvertTo-Json)
    
# Send the request
$request = Invoke-WebRequest -Uri 'http://localhost:11434/api/generate' -Method Post -Headers $headers -Body $Body
$response =$request.Content | ConvertFrom-Json

# Print response to console
Write-Host $response.response




# ----- Test

# Define the API endpoint and your API key
$apiUrl = "http://localhost:11434/api/generate"
$apiKey = "your_api_key_here"

# Define the population data (this would typically come from your SQL database)
$populationData = @"
[
    {
        "City": "New York",
        "Population": 8419000,
        "Year": 2023
    },
    {
        "City": "Los Angeles",
        "Population": 3980000,
        "Year": 2023
    },
    {
        "City": "Chicago",
        "Population": 2716000,
        "Year": 2023
    }
]
"@

# Define the body of the request, including the prompt and the data
$body = @{
    prompt = "Analyze the population growth trends based on the following data."
    data = $populationData
    model = "llama3"
} | ConvertTo-Json

# Send the request to Ollama using Invoke-RestMethod
$response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers @{ "Authorization" = "Bearer $apiKey" } -Body $body -ContentType "application/json"

# Display the response
$response







# ---------------------------- chatgpt example

# Example CSV data
$csvData = @"
City,Population
New York,8336817
Los Angeles,3979576
Chicago,2693976
Houston,2320268
Phoenix,1680992
"@

# Create the API request body
$apiBody = @{
    model = "gpt-4"
    prompt = "Analyze the following population data in CSV format:`n`n$csvData`n`nIdentify any significant trends or patterns."
    temperature = 0.7
    max_tokens = 150
    top_p = 1
    frequency_penalty = 0
    presence_penalty = 0
}

# Convert to JSON
$jsonBody = $apiBody | ConvertTo-Json -Depth 5
$jsonBody

# Send the API request
$response = Invoke-RestMethod -Uri "https://api.openai.com/v1/chat/completions" -Method Post -Body $jsonBody -ContentType "application/json" -Headers @{Authorization = "Bearer sk-"}

# Display the response
$response.choices.text



# ------------------ Simple ChatGPT example


# Set your OpenAI API key
$ApiKey = "Hack-ME"

# Define the prompt
$prompt = "Why is the sky blue?"

# Define the API request payload
$body = @{
    model = "gpt-4"  # or "gpt-4" if available and desired
    prompt = $prompt
    max_tokens = 150  # Adjust based on the desired length of the answer
} | ConvertTo-Json

# Make the API request
$response = Invoke-RestMethod -Uri "https://api.openai.com/v1/chat/completions" `
                              -Method Post `
                              -Headers @{ "Authorization" = "Bearer $apiKey" } `
                              -ContentType "application/json" `
                              -Body $body

# Extract and display the response
$answer = $response.choices[0].text.Trim()
Write-Output "Answer: $answer"



# ------------ ollama doing open ai

# Set your OpenAI API key (replace with your own key)
$ApiKey = "Hack-ME"

# Set the prompt to ask "Why is the sky blue"
$prompt = "Why is the sky blue?"

# Make the API request using the OpenAI Completions endpoint
$url = "https://api.openai.com/v1/completions"
$params = @{
    "prompt" = $prompt;
    "max_tokens" = 1000;
    "temperature" = 0.5;
}

$headers = @{
    "Authorization" = "Bearer $apiKey";
    "Content-Type" = "application/json";
}

$response = Invoke-WebRequest -Uri $url -Method Post -Body ($params | ConvertTo-Json) -Headers $headers

# Parse the response JSON and print the answer
$responseJson = $response.Content -Replace '\n', ''
$answer = ($responseJson | ConvertFrom-Json).choices[0].text
Write-Host "The answer is: $answer"







# ---------

# Define API key and endpoint
$ApiKey = "Hack-ME"
$ApiEndpoint = "http://localhost:11434/api/generate"

$AiSystemMessage = "Act as a VMware PowerCLI SME"

# Function to send a message to ChatGPT
function Invoke-ChatGPT ($message) {
    # List of Hashtables that will hold the system message and user message.
    $message =  "Create a Script to connect to vCnter"
    [System.Collections.Generic.List[Hashtable]]$messages = @()

    # Sets the initial system message
    $messages.Add(@{"role" = "system"; "content" = $AiSystemMessage}) | Out-Null

    # Add the user input
    $messages.Add(@{"role"="user"; "content"=$message})

    # Set the request headers
    $headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer $ApiKey"
    }   

    # Set the request body
    $requestBody = @{
        "model" = "llama3"
        "messages" = $messages
        "max_tokens" = 2000 # Max amount of tokens the AI will respond with
        "temperature" = 0.5 # lower is more coherent and conservative, higher is more creative and diverse.
    }

    # Send the request
    $response = Invoke-RestMethod -Method POST -Uri $ApiEndpoint -Headers $headers -Body (ConvertTo-Json $requestBody)
    $response

    # Return the message content
    return $response.choices[0].message.content
}

# Get user input
$userInput = "Create a Script to connect to vCnter"

# Query ChatGPT
$AiResponse = Invoke-ChatGPT $UserInput

# Show response
write-output $AiResponse
