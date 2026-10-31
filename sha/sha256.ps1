$ApkPath = "apk\calculoca.apk"

if (-not (Test-Path $ApkPath)) {
    Write-Error "El archivo especificado no existe en la ruta: $ApkPath"
    exit
}

Write-Host "`n--- INFORMACIÓN DEL ARCHIVO APK ---" -ForegroundColor Cyan
Write-Host "Archivo: $ApkPath"

# 1. Calcular el SHA-256 del archivo (Integridad)
Write-Host "`n Hash SHA-256 del archivo completo (Checksum):" -ForegroundColor Yellow
$FileHash = Get-FileHash -Path $ApkPath -Algorithm SHA256
Write-Host $FileHash.Hash

# 2. Intentar obtener el SHA de la firma con keytool (si Java está instalado)
Write-Host "`n Intentando obtener huellas de firma del certificado..." -ForegroundColor Yellow
if (Get-Command keytool -ErrorAction SilentlyContinue) {
    keytool -printcert -jarfile $ApkPath | Where-Object { $_ -match "SHA1:" -or $_ -match "SHA256:" }
} else {
    Write-Warning "La herramienta 'keytool' no está disponible en el sistema. Asegúrate de tener instalado Java (JDK) si necesitas ver las huellas del certificado de firma."
}
Write-Host ""
