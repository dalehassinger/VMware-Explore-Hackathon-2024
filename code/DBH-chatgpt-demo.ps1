# Set your API key (replace 'your-api-key' with your actual API key)
$apiKey = "sk-oxp2CIXukFiidtZpUt-HACKME-NxUq4GPAf0UwdoTA"
$apiUrl = "https://api.openai.com/v1/chat/completions"

# Load the CSV file
$csvFilePath = "/Users/dalehassinger/Documents/GitHub/PS-TAM-Lab/RVTools/RVTools_export_all_2024-06-28_04.55.40/RVTools_tabvInfo.csv"

$data = Import-Csv -Path $csvFilePath
$dataSummary = $data | Select-Object VM, Powerstate

# Convert data to a string summary (example: first few rows)
$dataSummary = $data | Select-Object -First 5 | Out-String

# Define a list of questions about the data
$questions = @(
    "Show me the Powered Off VMs",+
    "Show me the Linux VMs",
    "Show me the Windows VMs"
)

# Loop through each question and send it to the API
foreach ($question in $questions) {
    # Prepare the data for the API request
    $requestBody = @{
        model = "gpt-4"  # Specify the model you want to use
        messages = @(
            @{ role = "system"; content = "You are a data analyst." }
            @{ role = "user"; content = "Here is some data:" }
            @{ role = "user"; content = $dataSummary }
            @{ role = "user"; content = $question }
        )
    } | ConvertTo-Json
    
    # Make the API request
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers @{ "Authorization" = "Bearer $apiKey" } -Body $requestBody -ContentType "application/json"

    # Output the question and response
    Write-Output "Question: $question"
    Write-Output "Response: $($response.choices[0].message.content)"
    Write-Output "---------------------------------------------"
    Start-Sleep -Seconds 20
}

# ------

# Load the CSV file
$csvFilePath = "/Users/dalehassinger/Documents/GitHub/PS-TAM-Lab/RVTools/RVTools_export_all_2024-06-28_04.55.40/RVTools_tabvInfo.csv"

$data = Import-Csv -Path $csvFilePath
$dataSummary = $data | Select-Object VM, Powerstate | Out-String

#$dataSummary = $data | Out-String

$dataSummary

$question = "Show me the Powered Off VMs"
#"Show me the VMs with more than 16 GB Memory",
#"Show me the VMs with more than 4 CPU"


$requestBody = @{
    model = "gpt-4"  # Specify the model you want to use
    messages = @(
        @{ role = "system"; content = "You are a data analyst." }
        @{ role = "user"; content = "Here is some data:" }
        @{ role = "user"; content = $dataSummary }
        @{ role = "user"; content = $question }
    )
} | ConvertTo-Json

# Make the API request
$response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers @{ "Authorization" = "Bearer $apiKey" } -Body $requestBody -ContentType "application/json"

# Output the question and response
Write-Output "Question: $question"
Write-Output "Response: $($response.choices[0].message.content)"
Write-Output "---------------------------------------------"

