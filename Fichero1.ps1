function Show-Menu {
    Clear-Host
    Write-Host "============================"
    Write-Host "  Menú de Active Directory  "
    Write-Host "============================"
    Write-Host "1. Mostrar versión de PowerShell"
    Write-Host "2. Obtener información sobre el bosque de AD DS"
    Write-Host "3. Obtener información sobre el dominio de AD DS"
    Write-Host "4. Obtener información sobre el usuario 'jioller'"
    Write-Host "5. Dar de alta un nuevo usuario"
    Write-Host "6. Salir"
    Write-Host "============================"
}

function Get-PowerShellVersion {
    $version = Get-Host
    Write-Host "Versión de PowerShell:" $version.Version
    Pause
}

function Get-ADForestInfo {
    $forestInfo = Get-ADForest
    Write-Host "Información del bosque de AD DS:"
    $forestInfo | Format-List
    Pause
}

function Get-ADDomainInfo {
    $domainInfo = Get-ADDomain
    Write-Host "Información del dominio de AD DS:"
    $domainInfo | Format-List
    Pause
}

function Get-ADUser Info {
    Write-Host "El comando Get-ADUser  'jioller' se usa para obtener información sobre el usuario 'jioller' en Active Directory."
    Pause
}

function Create-NewUser  {
    # Cambia estos valores según sea necesario
    $nombre = Read-Host "Introduce el nombre del nuevo usuario"
    $apellido = Read-Host "Introduce el apellido del nuevo usuario"
    $nombreCompleto = "$nombre $apellido"
    $usuarioPrincipalName = "$nombre@2asir.rcm"
    $password = ConvertTo-SecureString (Read-Host "Introduce la contraseña del nuevo usuario" -AsSecureString) -AsPlainText -Force

    # Crear el nuevo usuario
    New-ADUser  -Name $nombreCompleto `
               -GivenName $nombre `
               -Surname $apellido `
               -SamAccountName $nombre `
               -User PrincipalName $usuarioPrincipalName `
               -AccountPassword $password `
               -Enabled $true

    Write-Host "Usuario '$nombreCompleto' creado exitosamente."
    Pause
}

# Bucle del menú
do {
    Show-Menu
    $opcion = Read-Host "Selecciona una opción"

    switch ($opcion) {
        1 { Get-PowerShellVersion }
        2 { Get-ADForestInfo }
        3 { Get-ADDomainInfo }
        4 { Get-ADUser Info }
        5 { Create-NewUser  }
        6 { Write-Host "Saliendo..."; break }
        default { Write-Host "Opción no válida. Intenta de nuevo." }
    }
} while ($true)
