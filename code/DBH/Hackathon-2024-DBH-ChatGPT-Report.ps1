
# Define the OpenAI API key (replace with your own key)
#$env:OpenAIKey = 'sk-HackMe'

function New-RVTools-Prompt {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Prompt,
        [Parameter(Mandatory=$true)]
        [string]$CsvFile
    )

    # Convert CSV file to JSON data
    $data = (Import-CSV -Path $CsvFile) | ConvertTo-Json

    # Send prompt to ChatGPT and save results to a global variable
    $global:results = Invoke-AIPrompt -Prompt $Prompt -Data $data -Model 'gpt-4o'
}

function New-RVTools-Report {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Prompt,
        [Parameter(Mandatory=$true)]
        [string]$HtmlFile
    )

    # Send prompt to ChatGPT using the saved JSON data and generate an HTML report
    $reportResults = Invoke-AIPrompt -Prompt $Prompt -Data $Global:results -Model 'gpt-4o'

    # Save the HTML report to a file
    Set-Content -Path $HtmlFile -Value $reportResults
}

# Start a new prompt for clustering hosts by cluster name
$prompt = @"
Act as a RVTools SME
- Group Host together by Cluster Name
- Within each cluster, is the host CPU and Memory the same?
- Show the results with Host Cluster, true or false if consistent
- Return data as JSON
- No explanation
- No Fence Blocks
"@

$CsvFile = "/Users/hdale/RVTools/RVTools_tabvHost.csv"
New-RVTools-Prompt -Prompt $prompt -CsvFile $CsvFile

# Generate an HTML report for the clustering prompt
$prompt = @"
Act as a html SME
- Use JSON data to create a html report
- Make all text 12px
- Header to be 'Cluster Host Info' and 14px
- Header color to be grey
- Make table columns sortable
- If the table column Consistent equal 'true', make the text green; otherwise, red
- No explanation
- No Fence Blocks
"@

$HtmlFile = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Report-ClusterCPUMEM.html"
New-RVTools-Report -Prompt $prompt -HtmlFile $HtmlFile

# Open the HTML report in the default browser
Invoke-Item $HtmlFile

# Start a new prompt for VMs with high CPU usage
$prompt = @"
Act as a VMware SME
- Use included JSON data
- Show VM Name, CPU, and Memory
- The CPUs data is numeric; CPUs Value must be greater than 4
- Return data as JSON
- No explanation
- No Fence Blocks
"@

$CsvFile = "/Users/hdale/RVTools/RVTools_tabvInfo.csv"
New-RVTools-Prompt -Prompt $prompt -CsvFile $CsvFile

# Generate an HTML report for the VMs with high CPU usage prompt
$prompt = @"
Use JSON data. Create a html report
- Make all text 12px
- Header to be 'VMs with CPU Count Greater than 4' and 14px
- Header color to be grey
- Make table columns sortable
- If the column CPUs equal '12', make the text red; if it equals '8', make the text orange
- No explanation
- No Fence Blocks
"@

$HtmlFile = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Report-CPU4.html"
New-RVTools-Report -Prompt $prompt -HtmlFile $HtmlFile

# Open the HTML report in the default browser
Invoke-Item $HtmlFile
