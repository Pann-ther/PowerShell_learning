$Path = $env:TEMP

$fichiers = Get-ChildItem $Path -File -Filter "*.tmp"

if ($fichiers.Count -eq 0) {
    Write-Host "Aucun fichier .tmp n'a été trouvé dans le dossier temporaire"
    exit
}

Write-host "$($fichiers.Count) seront supprimés. Voulez vous continuez? (O/N)"

$rep = Read-Host "Votre Choix"

if ($rep.ToUpper() -eq "O") {
    Write-Host "Suppression confirmée"
    foreach ($fichier in $fichiers) {
        Remove-Item $fichier.FullName -Force -Recurse -ErrorAction Ignore
    }
    if ($fichiers.Count -ne 0) {
        Write-Host "$($fichiers.Count) processus sont en cours et n'ont pas été supprimé"
    }
    Write-Host "Suppression terminée"
} else {
    Write-Host "Suppresion annulée"
}

