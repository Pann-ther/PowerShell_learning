class ADadmin {
    [object[]]$file
    [string]$ouCreationPath
    [string]$ouGroupPath
    
    ADadmin([object[]]$file, [string]$ouCreationPath, [string]$ouGroupPath) {
        if (-not (Test-Path $file )) {}
        if (-not (Get-ADOrganizationalUnit -Identity $ouCreationPath )) {}
        if (-not (Get-ADOrganizationalUnit -Identity $ouGroupPath )) {}
        $this.file = Import-Csv $file
        $this.ouCreationPath = $ouCreationPath
        $this.ouGroupPath = $ouGroupPath
    }


    # Gestion du programme
    # Validation des chemins
    [bool] validationPathCsv($pathCsv) {
        if ((Test-Path $pathCsv) -and ([System.IO.Path]::GetExtension($pathCsv) -eq ".csv")) {
            return $true
        }
        else {
            return $false
        }
    }

    [bool] validationPathCreationOU($pathCreationOU) {
        $path = Get-ADOrganizationalUnit -Identity $pathCreationOU -ErrorAction SilentlyContinue
        if ($path) {
            return $true
        }
        else {
            return $false
        }
    }

    [bool] validationPathCreationGroupe($pathCreationGroupe) {
        $path = Get-ADGroup -Identity $pathCreationGroupe -ErrorAction SilentlyContinue
        if ($path) {
            return $true
        }
        else {
            return $false
        }
    }

    # Affichage des menus
    [int] menuConfigurationChemins() {
        Write-Host "-------Configuration des chemins-------"
        Write-Host "1. Chemin du fichier csv"
        Write-Host "2. Chemin de creation des OU"
        Write-Host "3. Chemin de creation des Groupes"
        Write-Host "4. Retour au menu d'action"
        $choix = [int](Read-Host "Votre choix")
        return $choix
    }
    
    [int] menuAction() {
        Write-Host "-------Action-------"
        Write-Host "1. Creation automatique de l'arborescence"
        Write-Host "2. Supprimer la arborescence"
        Write-Host "3. Configuration des chemins"
        Write-Host "4. Quitter le programme"
        $choix = [int](Read-Host "Votre choix")
        return $choix
    }

    # Traitement des choix utlisateurs
    [void] choixConfigurtion() {
        while ($true) {
            $choix = $this.menuConfigurationChemins()
            Start-Sleep -Seconds 1
            Clear-Host
            switch ($choix) {
                1 {
                    while ($true) {
                        $path = Read-Host "Entrez le chemin du fichier CSV"
                        if ($this.validationPathCsv($path)) {
                            $this.file = Import-Csv $path
                            Write-Host "Le chemin est valide"
                            break
                        }
                        else {
                            Write-Host "Le chemin du fichier n'est pas valide ou le fichier n'est pas un .csv" -ForegroundColor Red
                        }
                    }
                    Start-Sleep -Seconds 1
                    Clear-Host
                }
                2 {
                    while ($true) {
                        $path = Read-Host "Entrez le chemin de l'OU pour la creation des OU"
                        if ($this.validationPathCreationOU($path)) {
                            $this.ouCreationPath = $path
                            Write-Host "Le chemin est valide"
                            break
                        }
                        else {
                            Write-Host "Le chemin de l'OU n'est pas valide" -ForegroundColor Red
                        }
                    }
                    Start-Sleep -Seconds 1
                    Clear-Host
                }
                3 {
                    while ($true) {
                        $path = Read-Host "Entrez le chemin de l'OU pour la creation des OU"
                        if ($this.validationPathCreationGroupe($path)) {
                            $this.ouGroupPath = $path
                            Write-Host "Le chemin est valide"
                            break
                        }
                        else {
                            Write-Host "Le chemin de l'OU n'est pas valide" -ForegroundColor Red
                        }
                    }
                    Start-Sleep -Seconds 1
                    Clear-Host
                }
                4 {
                    $this.choixAction()
                }
                Default {
                    Write-Host "Faites un choix valide: un entier entre 1 à 4"  -ForegroundColor Red
                    Start-Sleep -Seconds 2
                    Clear-Host
                }
            }
        }
    }

    [void] choixAction() {
        while ($true) {
            $choix = $this.menuAction()
            Start-Sleep -Seconds 1
            Clear-Host
            switch ($choix) {
                1 {
                    $this.creationArborescence()
                    Start-Sleep -Seconds 1
                    Clear-Host
                }
                2 {
                    $this.suppressionArborescence() 
                    Start-Sleep -Seconds 1
                    Clear-Host
                }
                3 {
                    $this.choixConfigurtion() 
                    Start-Sleep -Seconds 1
                    Clear-Host
                }
                4 {
                    Write-Host "Vous allez quittez le programme"
                    Start-Sleep -Seconds 1
                    Clear-Host
                    exit 
                }
                Default {
                    Write-Host "Faites un choix valide: un entier entre 1 à 4"  -ForegroundColor Red
                    Start-Sleep -Seconds 2
                    Clear-Host
                }
            }
        }
    }

    # Gestion des Users
    [void] creationUser([string]$prenom, [string]$nom, [string]$login, [string]$password, [string]$service, [string]$ouCreationPath) {
        $user = Get-ADUser -Filter { Name -eq $login }
        try {
            if (-not ($user)) {
                New-ADUser `
                    -Name $login `
                    -SamAccountName $login `
                    -GivenName $prenom `
                    -Surname $nom `
                    -UserPrincipalName "$($login)@labcorp.local" `
                    -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
                    -Enabled $true `
                    -Path $ouCreationPath 
                Write-Host "L'utilisateur $prenom $nom a ete cree" -ForegroundColor Green
                Write-Host "L'utilisateur $prenom $nom a bien ete ajoute a l'OU $service" -ForegroundColor Green
                $this.ajoutGroupUser($login, $service)
            }
            else {
                Write-Host "L'utilisateur $prenom $nom est deja existant" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "L'utilisateur $prenom $nom n'a pas pu etre cree"
        }
    }

    [void] ajoutGroupUser([string]$login, [string]$service) {
        $group = Get-ADGroup -Identity $service -ErrorAction SilentlyContinue
        if ($group) {
            Add-ADGroupMember -Identity $service -Members $login 
            Write-Host "$login a bien ete ajoute au groupe $service " -ForegroundColor Green
        }
        else {
            throw "Le groupe $service n'a pas ete trouve" 
        }
    }

    [void] creationArborescence() {
        foreach ($u in $this.file) {
            $this.creationOU($u.Service)
            $ouPath = Get-ADOrganizationalUnit -Filter "Name -eq '$($u.Service)'"
            $this.creationGroup($u.Service)
            $this.creationUser($u.Prenom, $u.Nom, $u.Login, $u.Password, $u.Service, $ouPath)
        }
    }

    [void] suppressionArborescence() {
        $this.supprimerTousLesGroups()
        $this.supprimerToutesLesOU()
    }

    # Gestion des OU
    [void] creationOU([string]$service) {
        $ou = Get-ADOrganizationalUnit -Filter "Name -eq '$($service)'" -ErrorAction SilentlyContinue
        if (-not($ou)) {
            New-ADOrganizationalUnit -Name $service -ProtectedFromAccidentalDeletion $false -Path $this.ouCreationPath
        }
    }

    [void] supprimerOu([string]$service) {
        $ou = Get-ADOrganizationalUnit -Filter "Name -eq '$($service)'" -ErrorAction SilentlyContinue
        if ($ou) {
            Remove-ADOrganizationalUnit -Identity $ou -Recursive -Confirm:$false
            Write-Host "L'OU $service a bien ete supprime" -ForegroundColor Green
        }
        else {
            Write-Host "L'OU $service n'a pas ete trouve" -ForegroundColor Yellow
        }
    }

    [void] supprimerToutesLesOU() {
        foreach ($u in $this.file) {
            $this.supprimerOu($u.Service)
        }
    }

    # Gestion des Groups
    [void] creationGroup([string]$service) {
        try {
            $group = Get-ADGroup -Identity $service 
        }
        catch {
            New-ADGroup -Name $service -GroupScope Global -GroupCategory Distribution -Path $this.ouGroupPath
        }
    }

    [void] supprimerGroup([string]$service) {
        $group = Get-ADGroup -Filter { Name -eq $service } -ErrorAction SilentlyContinue
        if ($group) {
            Remove-ADGroup -Identity $service -Confirm:$false
            Write-Host("Le groupe $service a bien ete supprime") -ForegroundColor Green
        }
        else {
            Write-Host "Le groupe $service n'a pas ete trouve" -ForegroundColor Yellow
        }
    }

    [void] supprimerTousLesGroups() {
        foreach ($u in $this.file) {
            $this.supprimerGroup($u.Service)
        }
    }
}

#Execution du programme
do{
    try{
        $filePath = read-host "Entrez le chemin du fichier csv qui contient les donnees des users"
        $ouCreationPath = read-host "Entrez le chemin ou seront cree les OU correpondant au services"
        $ouGroupPath = read-host "Entrez le chemin ou seront cree les groupes correspondant au services"
        $srvADDS = [ADadmin]::new($filePath, $ouCreationPath, $ouGroupPath)
        Write-Host "Les chemins sont valides" -ForegroundColor Green
    } catch {
        Write-Host "Chemins invalides" -ForegroundColor Red
    }
} while ($srvADDS -eq $null)
Start-Sleep -Seconds 1
Clear-Host
$srvADDS.choixAction() 