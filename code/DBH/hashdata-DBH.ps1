# Script to de-indentfy the data to be sent to ChatGPT
# After the results are returned from ChatGPT the Values will be unhashed.
# Used at VMware Explore Hackathon 2024
# Created by: Amos Clerizier

# Define paths to input/output files
$inputCSVPath      = "/Users/hdale/RVTools/RVTools_tabvInfo.csv"
$outputCSVPath     = "/Users/hdale/RVTools/hash_output.csv"
$hashReferencePath = "/Users/hdale/RVTools/hash_reference.json"
$outputUnHashed    = "/Users/hdale/RVTools/hash_output_unhashed.csv"

# Define the columns to hash
$columnsToHash = @("VM", "DNS Name") # Specify the columns to hasholumns to hash
$uniqueIdentifierColumn = "VM"  # Assuming 'VM' is a unique identifier for each row

# Load the CSV file
$data = Import-Csv $inputCSVPath

# Initialize the hash reference dictionary
$hashReference = @{}

# Function to hash data using MD5
function Get-Hash-Value {
    param (
        [string]$value
    )
    $hash = [System.Security.Cryptography.MD5]::Create()
    $hashBytes = $hash.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($value))
    return [BitConverter]::ToString($hashBytes).Replace("-", "")
}

# Hash the specified columns and store reference
foreach ($row in $data) {
    $uniqueId = $row.$uniqueIdentifierColumn
    $vmHash = Get-Hash-Value -value $uniqueId  # Hash the VM value to use as the key

    if (-not $hashReference.ContainsKey($vmHash)) {
        $hashReference[$vmHash] = @{}
    }

    foreach ($column in $columnsToHash) {
        $originalValue = $row.$column
        $hashedValue = Get-Hash-Value -value $originalValue
        $row.$column = $hashedValue
        $hashReference[$vmHash][$hashedValue] = $originalValue
    }
}

# Convert the hash reference to a JSON string and save it
$hashReference | ConvertTo-Json -Depth 10 | Set-Content -Path $hashReferencePath

# Export the hashed data to a new CSV file
$data | Export-Csv -Path $outputCSVPath -NoTypeInformation

# Function to unhash data
function Set-Data-Unhashed {
    param (
        [string]$hashedCsvPath,
        [string]$outputUnhashedCsvPath,
        [string]$hashReferenceJsonPath,
        [string]$uniqueIdentifierColumn
    )

    # Load the hashed CSV file
    $hashedData = Import-Csv $hashedCsvPath

    # Load the hash reference from the JSON file
    $hashReference = Get-Content -Path $hashReferenceJsonPath -Raw | ConvertFrom-Json

    # Unhash the specified columns
    foreach ($row in $hashedData) {
        $uniqueId = $row.$uniqueIdentifierColumn
 
        # Check if the VM hash exists as a key in the hash reference
        if ($hashReference.PSObject.Properties.Name -contains $uniqueId) {
            $currentRowHashReference = $hashReference.$uniqueId
            write-host $hashReference.$uniqueId

            foreach ($column in $columnsToHash) {
                $hashedValue = $row.$column

                # Replace the hashed value with the original value if it exists
                if ($currentRowHashReference.PSObject.Properties.Name -contains $hashedValue) {
                    $row.$column = $currentRowHashReference.$hashedValue
                }
            }
        }
    }

    # Export the unhashed data to a new CSV file
    $hashedData | Export-Csv -Path $outputUnhashedCsvPath -NoTypeInformation
}

# Example usage of Set-Data-Unhashed function
Set-Data-Unhashed -hashedCsvPath $outputCSVPath -outputUnhashedCsvPath $outputUnHashed -hashReferenceJsonPath $hashReferencePath -uniqueIdentifierColumn "VM"
