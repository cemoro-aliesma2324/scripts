function Show-Menu {
    Clear-Host
    Write-Host "========================="
    Write-Host "      Menú de Red       "
    Write-Host "========================="
    Write-Host "1. Mostrar propiedades básicas del adaptador de red"
    Write-Host "2. Mostrar configuración de la dirección IP (IPv4 e IPv6)"
    Write-Host "3. Ejecutar Get-NetIPConfiguration"
    Write-Host "4. Ejecutar Get-NetConnectionProfile"
    Write-Host "5. Mostrar ruta de paquetes"
    Write-Host "6. Mostrar información detallada de adaptadores"
    Write-Host "7. Ejecutar tracert a un destino"
    Write-Host "8. Comprobar estado de puertos abiertos"
    Write-Host "9. Ejecutar NSLOOKUP"
    Write-Host "10. Comprobar estado actual de la red"
    Write-Host "11. Mostrar rutas de paquetes"
    Write-Host "12. Obtener información detallada de adaptadores"
    Write-Host "13. Realizar test de puertos"
    Write-Host "14. Obtener dirección MAC y cambiarla"
    Write-Host "0. Salir"
}

function Show-NetworkProperties {
    Get-NetAdapter | Format-Table -Property Name, Status, LinkSpeed, MacAddress
}

function Show-IPConfiguration {
    Get-NetIPAddress | Format-Table -Property IPAddress, InterfaceAlias, AddressFamily
}

function Get-NetIPConfiguration {
    Get-NetIPConfiguration
}

function Get-NetConnectionProfile {
    Get-NetConnectionProfile
}

function Show-Route {
    $destination = Read-Host "Introduce la dirección o dominio para tracert"
    tracert $destination
}

function Show-AdapterDetails {
    Get-NetAdapter | Format-Table -Property Name, Status, LinkSpeed, VlanID
}

function Test-Port {
    $ports = 1..1024
    foreach ($port in $ports) {
        $tcpConnection = Test-NetConnection -ComputerName localhost -Port $port
        if ($tcpConnection.TcpTestSucceeded) {
            Write-Host "Puerto $port está abierto."
        }
    }
}

function NSLOOKUP {
    $domain = Read-Host "Introduce el dominio para realizar NSLOOKUP"
    nslookup $domain
}

function Get-NetTCPConnection {
    Get-NetTCPConnection
}

function Get-NetRoute {
    Get-NetRoute
}

function Get-MACAddress {
    Get-NetAdapter | Select-Object Name, MacAddress
}

function Change-MACAddress {
    $adapter = Get-NetAdapter | Select-Object -First 1
    $newMac = Read-Host "Introduce la nueva dirección MAC (formato XX-XX-XX-XX-XX-XX)"
    Set-NetAdapter -Name $adapter.Name -MacAddress $newMac
}

do {
    Show-Menu
    $choice = Read-Host "Selecciona una opción"
    
    switch ($choice) {
        '1' { Show-NetworkProperties }
        '2' { Show-IPConfiguration }
        '3' { Get-NetIPConfiguration }
        '4' { Get-NetConnectionProfile }
        '5' { Show-Route }
        '6' { Show-AdapterDetails }
        '7' { Show-Route }  # Modificado para permitir un destino
        '8' { Test-Port }
        '9' { NSLOOKUP }
        '10' { Get-NetTCPConnection }
        '11' { Get-NetRoute }
        '12' { Show-AdapterDetails }
        '13' { Test-Port }
        '14' { 
            Get-MACAddress
            Change-MACAddress 
        }
        '0' { Write-Host "Saliendo..."; break }
        default { Write-Host "Opción no válida, intenta de nuevo." }
    }
    
    Write-Host "Presiona cualquier tecla para continuar..."
    [void][System.Console]::ReadKey($true)
} while ($true)
