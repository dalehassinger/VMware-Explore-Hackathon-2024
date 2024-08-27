$env:OpenAIKey = 'sk-TA2H'

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


# Function to prompt against RVTools Data and Generate Report
function Get-RVTools-Report {

    param(
        [parameter(mandatory = $true)]
        [string]$importCSV,
        [parameter(mandatory = $true)]
        [string]$ReportPath,
        [parameter(mandatory = $true)]
        [string]$prompt

    ) # End param

    # --- Create the Hosts Agent
    $RVToolsData = $importCSV
    $tools = Register-Tool $RVToolsData
    $agent = New-Agent -Tools $tools -ShowToolCalls

    $htmlReport = $agent | Get-AgentResponse $prompt
    #$htmlReport
    
    # Define the path to the Report HTML file
    Set-Content -Path $ReportPath -Value $htmlReport
    
    Invoke-Item $ReportPath

} # End Function



Clear-Host

# ----- [ New Prompt | Hosts | Cluster ] -----

$prompt = @"
Group hosts by cluster
- Do all hosts within the cluster have the same cpu and memory?
- make table header a light grey background with bold text
- Name the report "vCenter Cluster | Host CPU/Memory"
- make every other row in the table color #90EE90 
- Use Tahoma font for all html text
- Return results as a html file
- No expanation
- No code fence
"@

# Define Function Parameters
$importCSV  = "Get-RVToolsData-Hosts"
$ReportPath = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Agent-rpt-Cluster-CPU-MEM.html"

# Run the Function | Generate the Report
Get-RVTools-Report -importCSV $importCSV -ReportPath $ReportPath -prompt $prompt



Clear-Host

# ----- [ New Prompt | Hosts | Core Count ] -----

$prompt = @"
Show me the core count for every host.
- Show a Total core count at bottom line of table
- make table header a light grey background with bold text
- Name the report "VCF Total Host Core Counts"
- make every other row in the table color #90EE90
- Use Tahoma font for all html text
- Return results as a html file
- No expanation
- No code fence
"@

# Define Function Parameters
$importCSV  = "Get-RVToolsData-Hosts"
$ReportPath = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Agent-rpt-Core-Count.html"

# Run the Function | Generate the Report
Get-RVTools-Report -importCSV $importCSV -ReportPath $ReportPath -prompt $prompt



Clear-Host

# ----- [ New Prompt | Health | CDROM ] -----

# --- Create the Health Agent ---
$tools = Register-Tool Get-RVToolsData-Health
$agent = New-Agent -Tools $tools -ShowToolCalls

$prompt = @"
Show me the VM Names where message shows CDROM connected.
- Include the Name and Message in the Table
- make table header a light grey background with Bold text, 12px
- Report Header "VMs with CDROM Connected"
- make every other row in the table color #90EE90
- Use Tahoma font for all html text and size 10px
- make the columns sortable
- Return results as a html file
- No expanation
- No code fence
"@

# Define Function Parameters
$importCSV  = "Get-RVToolsData-Health"
$ReportPath = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Agent-rpt-CDRom.html"

# Run the Function | Generate the Report
Get-RVTools-Report -importCSV $importCSV -ReportPath $ReportPath -prompt $prompt



Clear-Host

# ----- [ New Prompt | Health | Zombie ] -----

$prompt = @"
Show me the Names where message shows Zombie vmdk file.
- Include the Name and Message in the Table
- make table header a light grey background with Bold text, 12px
- Report Header "Zombie Files"
- make every other row in the table color #90EE90
- Use Tahoma font for all html text and size 10px
- make the columns sortable
- Return results as a html file
- No expanation
- No code fence
"@


# Define Function Parameters
$importCSV  = "Get-RVToolsData-Health"
$ReportPath = "/Users/hdale/github/PS-TAM-Lab/Hackathon-Agent-rpt-Zombie-files.html"

# Run the Function | Generate the Report
Get-RVTools-Report -importCSV $importCSV -ReportPath $ReportPath -prompt $prompt
