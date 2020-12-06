function InitializeTempFolder() {
    <#
        .SYNOPSIS
            Creates the temp folder and the `debug.info` file.

        .DESCRIPTION
            The temp folder is where all work is done before the enriched mdx files are copied
            to the docusaurus sidebar folder. We use this approach to support future debugging
            as it will be near impossible to reason about bugs without looking at the PlatyPS
            generated source files, knowing which Powershell version was used etc.

        .NOTES
            Ideally, we should also log used module versions for Alt3, PlatyPS and Pester.
    #>
    param(
        [Parameter(Mandatory = $True)][string]$Path
    )

    GetCallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    # create the folder
    Write-Verbose "Initializing temp folder:"
    CreateOrCleanFolder -Path $Path

    # log the module parameters used for this run
    $ParameterList = (Get-Command -Name New-DocusaurusHelp).Parameters
    $parameterHash = [ordered]@{ }

    $ParameterList.Keys | ForEach-Object {
        $variable = (Get-Variable -Name $_ -ErrorAction SilentlyContinue)

        if ($null -eq $variable) { # Verbose, ErrorAction, etc.
            return
        }

        $parameterHash.Add($_, $variable.Value)
    }

    # create the hash with debug information
    $debugInfo = [ordered]@{
        ModuleParameters = $parameterHash
        PSVersionTable   = $PSVersionTable
    } | ConvertTo-Json

    # create the debug file
    Write-Verbose "=> preparing debug file"
    $debugFile = Join-Path -Path $Path -ChildPath "debug.json"
    $fileEncoding = New-Object System.Text.UTF8Encoding $False

    [System.IO.File]::WriteAllLines($debugFile, $debugInfo, $fileEncoding)
}
