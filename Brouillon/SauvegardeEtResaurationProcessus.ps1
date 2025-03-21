class SauvegardeProcessus {
    [string]$fichierSauvegarde

    SauvegardeProcessus([string]$fichierSauvegarde) {
        $this.fichierSauvegarde = $fichierSauvegarde
    }

    [void]sauvegarder() {
        Get-Process | Select-Object -Property Name, CPU, Id | Export-Csv -Path $this.fichierSauvegarde -NoTypeInformation
        Write-Host "Les processus ont bien ete sauvegardes" -ForegroundColor Blue
    }

    [void]restaurer() {
        if (Test-Path $this.fichierSauvegarde) {
            $process = Import-Csv -Path $this.fichierSauvegarde 
            Write-Host "Voila la liste des processus sauvegardes" -ForegroundColor Green
            foreach ($p in $process) {
                Write-Host "Nom: $($p.Name) | CPU: $($p.CPU) | ID: $($p.Id)"
            }
        } else {
            Write-Host "Le fichier de sauvegarde n'existe pas" -ForegroundColor Red
        }
       
    }
}

$sauvegarde = [SauvegardeProcessus]::new("C:\processus_backup.csv")
$sauvegarde.sauvegarder()
$sauvegarde.restaurer()