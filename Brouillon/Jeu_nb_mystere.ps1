$nbMystere = Get-Random -Maximum 100
$compteur = 0
do {
    $compteur ++
    $nbJoueur = Read-Host "Devinez le nombre mystere compris entre 0 et 100"
    if ($nbJoueur -gt $nbMystere) {
        Write-Host "Trop haut! Essaie encore." -ForegroundColor Red
    } elseif ($nbJoueur -lt $nbMystere) {
        Write-Host "Trop bas! Essaie encore." -ForegroundColor Red
    } else {
        Write-Host "Bravo vous avez devinez, le nombre mystere est bien $nbMystere." -ForegroundColor Green
        Write-Host "Vous avez realise $compteur essais." -ForegroundColor Cyan
    }
} while ($nbJoueur -ne $nbMystere)


