
# Function to ask Ollama
function ask-ollama {
    
    # Code to run when the function is called
    param (
      [Parameter(Mandatory=$true)]
      $question
    )
  
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

    # Copy response to clipboard
    Set-Clipboard -Value $response.response
    
} # End Function

# ----- Example Questions -----
ask-ollama -question "What is PowerCLI"

ask-ollama -question "Create a PowerShell script to connect to a vCenter, Get a list of all VMs with a Snap"

ask-ollama -question "Create a Salt State file to stop and disable a service with a name of Spooler"

ask-ollama -question "Show me how to copy a powershell variable value to the clipboard"



# -------------------------------------

# Load CSV data into an array of custom objects
$csvData = Import-Csv -Path "/Users/dalehassinger/Documents/GitHub/PS-TAM-Lab/RVTools/RVTools_export_all_2024-06-28_04.55.40/RVTools_tabvInfo.csv"
$csvData

# Define the API URL and headers
$apiUrl = "http://localhost:11434/api/generate"
$headers = @{'Content-Type'='application/json'}

# Convert the entire CSV content to a single string or a structured format
$csvContent = $csvData | ConvertTo-Json
$csvContent

# Define the question based on the CSV content
$question = "Based on the following CSV data, what insights can you provide?"
$payload = @{
    "question" = $question
    "data"     = $csvContent
} | ConvertTo-Json

# Send the API request
try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $payload
    
    # Output the response
    Write-Output "Question: $question"
    Write-Output "Response: $($response.answer)"
} catch {
    Write-Output "Failed to get a response."
    Write-Output $_.Exception.Message
}


# -----------------------------------------------------------



$apiUrl = "http://localhost:11434/api/generate"

# Load the CSV file
$csvFilePath = "/Users/dalehassinger/Documents/GitHub/PS-TAM-Lab/RVTools/RVTools_export_all_2024-06-28_04.55.40/RVTools_tabvInfo.csv"

$data = Import-Csv -Path $csvFilePath
$dataSummary = $data | Select-Object VM, Powerstate | Out-String #| Out-String

#$dataSummary = $data | Out-String
<#
$dataSummary
#>

$question = "Show me the Powered Off VMs"
#"Show me the VMs with more than 16 GB Memory",
#"Show me the VMs with more than 4 CPU"

$headers = @{'Content-Type'='application/json'}


# Set request body
$requestBody = @{
    model = "llama3";
    prompt = "$question";
    stream = $false;
} | ConvertTo-Json
$requestBody



$requestBody = @{
    model = "llama3"
    stream = $false;
    prompt = @(
        @{ role = "system"; content = "You are a data analyst." }
        @{ role = "user"; content = "Here is some data:" }
        @{ role = "user"; content = $dataSummary }
        @{ role = "user"; content = $question }
    )
} | ConvertTo-Json -Depth 3
$requestBody

# Make the API request
$response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $requestBody -ContentType "application/json"
$response.response

# Output the question and response
Write-Output "Question: $question"
Write-Output "Response: $($response.choices[0].message.content)"
Write-Output "---------------------------------------------"





# ------------------------


$requestBody = @{
    model = "llama3";
    prompt = "Act as a PowerShell SME";
    stream = $false;
}
$requestBody
$requestBody | ConvertTo-Json
$requestBody

$headers = @{'Content-Type'='application/json'}
$invokeBody = ($requestBody | ConvertTo-Json)
  
$request =Invoke-WebRequest -Uri 'http://localhost:11434/api/generate' -Method Post -Headers $headers -Body $invokeBody
$response =$request.Content | ConvertFrom-Json
$response.response

$response
