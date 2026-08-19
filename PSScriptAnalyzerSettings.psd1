@{
    # Rules are run against every script in this repository by the Lint workflow.
    Severity = @('Error', 'Warning')

    ExcludeRules = @(

        # PSAvoidUsingWriteHost
        #
        # These are interactive administration scripts. An operator runs them at
        # a console and reads the coloured progress and summary output directly.
        # Write-Host is the correct cmdlet for that: since PowerShell 5.0 it
        # writes to the information stream, so nothing is lost and the output can
        # still be captured with 6>&1 when needed.
        #
        # Data that callers are meant to consume is returned as objects or
        # written to CSV, never through Write-Host. Get-SystemInfo.ps1 is the
        # clearest example: it emits a PSCustomObject so the result can be piped
        # and exported, while status messages stay on the information stream.
        'PSAvoidUsingWriteHost'
    )
}
