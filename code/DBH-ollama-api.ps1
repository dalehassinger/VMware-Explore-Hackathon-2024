
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
