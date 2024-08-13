
# Define API key and endpoint
$ApiKey = "sk-ox"
$ApiEndpoint = "https://api.openai.com/v1/chat/completions"

$AiSystemMessage = "Act as a VMware PowerCLI SME"

# Function to send a message to ChatGPT
function Invoke-ChatGPT ($message) {
    # List of Hashtables that will hold the system message and user message.
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
        "model" = "gpt-4"
        "messages" = $messages
        "max_tokens" = 2000 # Max amount of tokens the AI will respond with
        "temperature" = 0.5 # lower is more coherent and conservative, higher is more creative and diverse.
    }

    # Send the request
    $response = Invoke-RestMethod -Method POST -Uri $ApiEndpoint -Headers $headers -Body (ConvertTo-Json $requestBody)

    # Return the message content
    return $response.choices[0].message.content
}

# Get user input
$userInput = "Create a Script to connect to vCnter"

# Query ChatGPT
$AiResponse = Invoke-ChatGPT $UserInput

# Show response
write-output $AiResponse
