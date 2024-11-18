function Show-Menu {
    Clear-Host
    Write-Host "============================="
    Write-Host "       MENÚ DE OPCIONES      "
    Write-Host "============================="
    Write-Host "1. Mostrar procesos"
    Write-Host "2. Detener un proceso"
    Write-Host "3. Esperar un proceso"
    Write-Host "4. Iniciar Notepad"
    Write-Host "5. Abrir PowerShell como administrador"
    Write-Host "6. Salir"
    Write-Host "============================="
}

function Show-Processes {
    Get-Process | Format-Table -AutoSize
    Read-Host "Presiona Enter para volver al menú"
}

function Stop-ProcessByName {
    $processName = Read-Host "Introduce el nombre del proceso que deseas detener (sin .exe)"
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue

    if ($process) {
        Stop-Process -Name $processName -Force
        while (Get-Process -Name $processName -ErrorAction SilentlyContinue) {
            Start-Sleep -Seconds 1
        }
        Write-Host "$processName ha sido detenido."
    } else {
        Write-Host "El proceso $processName no se está ejecutando."
    }
    Read-Host "Presiona Enter para volver al menú"
}

function Wait-ForProcess {
    $processNameToWait = Read-Host "Introduce el nombre del proceso que deseas esperar (sin .exe)"
    $waitTime = Read-Host "Introduce el tiempo en segundos que deseas esperar"

    $processToWait = Get-Process -Name $processNameToWait -ErrorAction SilentlyContinue

    if ($processToWait) {
        Start-Sleep -Seconds $waitTime
        if (Get-Process -Name $processNameToWait -ErrorAction SilentlyContinue) {
            Write-Host "El proceso $processNameToWait sigue en ejecución después de $waitTime segundos."
        } else {
            Write-Host "El proceso $processNameToWait se ha detenido."
        }
    } else {
        Write-Host "El proceso $processNameToWait no se está ejecutando."
    }
    Read-Host "Presiona Enter para volver al menú"
}

function Start-Notepad {
    $notepadProcess = Start-Process notepad -PassThru
    Start-Sleep -Seconds 1 # Esperar un segundo para asegurarse de que Notepad se inicie

    # Maximizar la ventana de Notepad
    $hwnd = (Get-Process -Id $notepadProcess.Id).MainWindowHandle
    $signature = @"
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(int hWnd, int nCmdShow);
"@
    $type = Add-Type -MemberDefinition $signature -Name Win32ShowWindow -Namespace Win32Functions -PassThru
    $type::ShowWindow($hwnd, 3) # 3 = SW_MAXIMIZE

    # Esperar hasta que se cierre Notepad
    $notepadProcess.WaitForExit()
    Write-Host "Notepad ha sido cerrado."
    Read-Host "Presiona Enter para volver al menú"
}

function Open-PowerShellAsAdmin {
    Start-Process powershell -Verb runAs
    Write-Host "PowerShell se ha abierto como administrador."
    Read-Host "Presiona Enter para volver al menú"
}

do {
    Show-Menu
    $choice = Read-Host "Selecciona una opción (1-6)"

    switch ($choice) {
        '1' { Show-Processes }
        '2' { Stop-ProcessByName }
        '3' { Wait-ForProcess }
        '4' { Start-Notepad }
        '5' { Open-PowerShellAsAdmin }
        '6' { Write-Host "Saliendo..."; exit }
        default { Write-Host "Opción no válida. Inténtalo de nuevo." }
    }
} while ($true)
