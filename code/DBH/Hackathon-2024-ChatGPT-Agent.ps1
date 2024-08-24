$env:OpenAIKey = 'sk-HackMe'

# Command to see where PS Modules are install on a MAC
#$env:PSModulePath -split ":"

#Import-Module PSAIAgent
#ipmo psai -force

Clear-Host

# ----- [ Use PSAIAgent PS Module ] -----

# ----- [ Functions to Get RVTools data ] -----

# Function to get RVTools Hosts Info
function Get-RVToolsData-Hosts {

    Import-Csv "/Users/hdale/RVTools/RVTools_tabvHost.csv" | ConvertTo-Json

} # End Function

# Function to get RVTools Hosts Info
function Get-RVToolsData-VMs {

    Import-Csv "/Users/hdale/RVTools/RVTools_tabvInfo.csv" | ConvertTo-Json

} # End Function

# Function to get RVTools Health Info
function Get-RVToolsData-Health {

    Import-Csv "/Users/hdale/RVTools/RVTools_tabvHealth.csv" | ConvertTo-Json

} # End Function



Clear-Host

# --- Create the Hosts Agent
$tools = Register-Tool Get-RVToolsData-Hosts
$agent = New-Agent -Tools $tools -ShowToolCalls

$prompt = @"
Group hosts by cluster
- Do all hosts within the cluster have the same cpu and memory?
- make table header a light grey background with bold text
- Name the report "vCenter Cluster | Host CPU/Memory"
- make every other row in the table a very light green
- Use Tahoma font for all html text
- Return results as a html file
- No expanation
- No code fence
"@

$htmlReport = $agent | get-agentResponse $prompt
#$htmlReport

# Define the path to the Report HTML file
$ReportPath = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Agent-rpt-Cluster-CPU-MEM.html"
Set-Content -Path $ReportPath -Value $htmlReport

Invoke-Item $ReportPath


# ----- New Prompt with same Agent

$prompt = @"
Show me the core count for every host.
- Show a Total core count at bottom line of table
- make table header a light grey background with bold text
- Name the report "VCF Total Host Core Counts"
- make every other row in the table a very light green
- Use Tahoma font for all html text
- Return results as a html file
- No expanation
- No code fence
"@

$htmlReport = $agent | get-agentResponse $prompt
#$htmlReport

# Define the path to the Report HTML file
$ReportPath = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Agent-rpt-Core-Count.html"
Set-Content -Path $ReportPath -Value $htmlReport

Invoke-Item $ReportPath


# --- Create the Health Agent ---
$tools = Register-Tool Get-RVToolsData-Health
$agent = New-Agent -Tools $tools -ShowToolCalls

$prompt = @"
Show me the VM Names where message shows CDROM connected.
- Include the Name and Message in the Table
- make table header a light grey background with Bold text, 12px
- Report Header "VMs with CDROM Connected"
- make every other row in the table a very light green
- Use Tahoma font for all html text and size 10px
- make the columns sortable
- Return results as a html file
- No expanation
- No code fence
"@

$htmlReport = $agent | get-agentResponse $prompt
#$htmlReport


# Define the path to the Report HTML file
$ReportPath = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Agent-rpt-CDRom.html"
Set-Content -Path $ReportPath -Value $htmlReport

Invoke-Item $ReportPath


# --- New prompt

$prompt = @"
Show me the Names where message shows Zombie vmdk file.
- Include the Name and Message in the Table
- make table header a light grey background with Bold text, 12px
- Report Header "Zombie Files"
- make every other row in the table a very light green
- Use Tahoma font for all html text and size 10px
- make the columns sortable
- Return results as a html file
- No expanation
- No code fence
"@

$htmlReport = $agent | get-agentResponse $prompt
#$htmlReport

# Define the path to the Report HTML file
$ReportPath = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Agent-rpt-Zombie-files.html"
Set-Content -Path $ReportPath -Value $htmlReport

Invoke-Item $ReportPath
