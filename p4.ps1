function Show-Menu {
    Clear-Host
    Write-Host "========================="
    Write-Host "    Menú de Opciones"
    Write-Host "========================="
    Write-Host "1. Listar puertos UDP abiertos"
    Write-Host "2. Deshabilitar adaptador de red"
    Write-Host "3. Ver bytes enviados y recibidos por la interfaz Wi-Fi"
    Write-Host "4. Obtener dirección IP del adaptador Wi-Fi"
    Write-Host "5. Ver tabla de enrutamiento de IPv4"
    Write-Host "6. Apagar otra máquina"
    Write-Host "7. Crear una barra de progreso"
    Write-Host "8. Salir"
    Write-Host "========================="
}

function List-UDPPorts {
    Get-NetUDPEndpoint | Select-Object -Property LocalAddress, LocalPort, State
}

function Disable-NetworkAdapter {
    $adapterName = Read-Host "Ingrese el nombre del adaptador de red a deshabilitar"
    Disable-NetAdapter -Name $adapterName -Confirm:$false
}

function Show-NetworkStatistics {
    $adapterName = Read-Host "Ingrese el nombre del adaptador Wi-Fi"
    Get-NetAdapterStatistics -Name $adapterName
}

function Get-WifiIPAddress {
    $adapterName = Read-Host "Ingrese el nombre del adaptador Wi-Fi"
    Get-NetIPAddress -InterfaceAlias $adapterName
}

function Show-RoutingTable {
    Get-NetRoute -AddressFamily IPv4
}

function Shutdown-RemoteComputer {
    $computerName = Read-Host "Ingrese el nombre o IP de la máquina a apagar"
    $credential = Get-Credential
    Stop-Computer -ComputerName $computerName -Credential $credential -Force
}

function Show-ProgressBar {
    $seconds = 60
    1..$seconds | ForEach-Object { 
        $percent = $_ * 100 / $seconds
        Write-Progress -Activity "Break" -Status "$($seconds - $_) seconds remaining..." -PercentComplete $percent
        Start-Sleep -Seconds 1
    }
}

do {
    Show-Menu
    $choice = Read-Host "Seleccione una opción (1-8)"
    
    switch ($choice) {
        '1' { List-UDPPorts }
        '2' { Disable-NetworkAdapter }
        '3' { Show-NetworkStatistics }
        '4' { Get-WifiIPAddress }
        '5' { Show-RoutingTable }
        '6' { Shutdown-RemoteComputer }
        '7' { Show-ProgressBar }
        '8' { Write-Host "Saliendo..."; exit }
        default { Write-Host "Opción no válida. Por favor, seleccione una opción entre 1 y 8." }
    }

    Read-Host "Presione Enter para continuar..."
} while ($true)
