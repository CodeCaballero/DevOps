param (
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Enter the provider namespace")]
    [string]$Provider
)

try {
    Write-Host "Initiating registration for: $Provider..." -ForegroundColor Yellow
    Register-AzResourceProvider -ProviderNamespace $Provider -ErrorAction Stop

    do {
        $registration = Get-AzResourceProvider -ProviderNamespace $Provider
        $state = $registration.RegistrationState
        
        if ($state -eq "Registering") {
            Write-Host "Current State: [$state]... retrying in 15 seconds." -ForegroundColor Gray
            Start-Sleep -Seconds 15
        }
        elseif ($state -eq "Registered") {
            Write-Host "Success: The provider $Provider is now registered." -ForegroundColor Green
        }
        else {
            Write-Host "Warning: Unexpected state detected: $state." -ForegroundColor Red
            break
        }
    } while ($state -ne "Registered")
}
catch {
    Write-Error "Failed to register provider $Provider. Ensure you have 'Contributor' or 'Owner' permissions."
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host "--- Process Completed ---" -ForegroundColor Cyan