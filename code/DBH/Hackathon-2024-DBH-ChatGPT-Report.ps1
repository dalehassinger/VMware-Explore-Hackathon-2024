
$env:OpenAIKey = 'sk-HackMe'

function New-RVTools-Prompt {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Prompt,

        [Parameter(Mandatory=$true)]
        [string]$CsvFile
    ) # End Parameter

    # Convert csv to json
    $data = (Import-Csv $CsvFile) | ConvertTo-Json

    # Send Prompt to ChatGPT and save results to global variable
    $global:results = Invoke-AIPrompt -Prompt $Prompt -Data $data -Model 'gpt-4o'

} # End Function





function New-RVTools-Report {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Prompt,

        [Parameter(Mandatory=$true)]
        [string]$htmlFile
    ) # End Parameter

    $data = (Import-Csv $CsvFile) | ConvertTo-Json #Import-Csv -Path $CsvFile | ConvertTo-Json

    $reportResults = Invoke-AIPrompt -Prompt $Prompt -Data $Global:results -Model 'gpt-4o'

    Set-Content -Path $htmlFile -Value $reportResults

} # End Function


# ----- [ Start a New Prompt ] -----

# ----- [ Cluster Prompt ] -----
$prompt = @"
Group Host together by Cluster Name
- Within each cluster, is the host CPU and Memory the same?
- Show the results with Host Cluster, true or false if consistent
- return data as json
- No explanation
- No Fence Blocks
"@

$global:results = ""
$CsvFile = "/Users/hdale/RVTools/RVTools_tabvHost.csv"
New-RVTools-Prompt -Prompt $prompt -CsvFile $CsvFile

#$global:results

# --- Cluster Report ---
$prompt = @"
Use json data. Create a html report
- make all the text 12px
- header to be 'Cluster Host Info' and 14px
- header color to be grey
- make the columns sortable
- if the table column Consistent equal 'true' make the text green and all other vales red
- No explanation
- No Fence Blocks
"@

$htmlFile = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Report-ClusterCPUMEM.html"
New-RVTools-Report -Prompt $prompt -htmlFile $htmlFile

# Open Report in Default Browser
Invoke-Item $htmlFile



# ----- [ Start a New Prompt ] -----

# ----- [ VM High CPU ] -----
$prompt = @"
Show VM Name, CPU and Memory
- CPUs Value must be greater than 4
- return data as json
- No explanation
- No Fence Blocks
"@

$global:results = ""
$CsvFile = "/Users/hdale/RVTools/RVTools_tabvInfo.csv"
New-RVTools-Prompt -Prompt $prompt -CsvFile $CsvFile

$global:results

# --- Cluster Report ---
$prompt = @"
Use json data. Create a html report
- make all the text 12px
- header to be 'VMs with CPU Count Greater than 4' and 14px
- header color to be grey
- make the columns sortable
- if the column CPUs equal '12' make the text red, '8' make the text orange
- No explanation
- No Fence Blocks
"@

$htmlFile = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Report-CPU4.html"
New-RVTools-Report -Prompt $prompt -htmlFile $htmlFile

# Open Report in Default Browser
Invoke-Item $htmlFile
