class ADadmin {
    [object[]]$file
    [string]$ouCreationPath
    [string]$groupPath
    
    ADadmin([object[]]$file,[string]$ouCreationPath, [string]$groupPath) {
        if (-not (Test-Path $file )) {
            throw "Le chemin n'existe pas" 
        }
        elseif (-not (Get-ADOrganizationalUnit -Identity $ouCreationPath -ErrorAction SilentlyContinue)) {
            throw "Le chemin de création de l'OU n'existe pas"
        }
        $this.file = Import-Csv $file
        $this.ouCreationPath = $ouCreationPath
        Write-Host $this.ouCreationPath
        $this.groupPath = $groupPath
        Write-Host "Ok constructeur"

        # === DEBUG ===
        foreach ($ligne in $this.file) {
            Write-Host "Prénom : $($ligne.Login)"
        }
    }

    [void] creationUser([string]$prenom, [string]$nom, [string]$login, [string]$password, [string]$service,[string]$ouPath) {
        $user = Get-ADUser -Filter { Name -eq $login }
        if (-not ($user)) {
            New-ADUser -Name $login -SamAccountName $login -GivenName $prenom -Surname $nom -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -Path $ouPath
            Write-Host "L'utilisateur `$prenom` `$nom` a été crée" -ForegroundColor Green
            $this.ajoutGroupUser($login,$service)
        }
        else {
            throw "L'utilisateur `$prenom` `$nom` n'a pas pu etre crée"
        }
    }

    [void] creationOU([string]$service) {
        $ou = Get-ADOrganizationalUnit -Identity "$this.ouCreationPath"
        if (-not($ou)) {
            New-ADOrganizationalUnit -Name $service -Path $this.ouCreationPath
            Write-Host "ok"
        }else{
            Write-Host "pas ok"
        }
    }

    [void] supprimerOu([string]$service) {
        $ou = Get-ADOrganizationalUnit -Identity $this.ouCreationPath -ErrorAction SilentlyContinue
        if ($ou) {
            Remove-ADOrganizationalUnit -Identity $service -Confirm:$false
            Write-Host "L'OU `$service` a bien été suppprimé" -ForegroundColor Green
        } else {
            throw "L'OU `$service` n'a pas été trouvé"

        }
    }

    [void] creationGroup([string]$service) {
        try {
            $group = Get-ADGroup -Identity $service 
        }
        catch {
            New-ADGroup -Name $service -GroupScope Global -GroupCategory Distribution -Path $this.groupPath
        }
    }

    [void] ajoutGroupUser([string]$login, [string]$service) {
        $group = Get-ADGroup -Identity $service -ErrorAction SilentlyContinue
        if ($group) {
            Add-ADGroupMember -Identity $service -Members $login 
            Write-Host "`$login` a bien été ajouté au groupe `$service` "
        }
        else {
            throw "Le groupe `$service` n'a pas été trouvé"
        }
        
    }

    [void] supprimerGroup([string]$service) {
        $group = Get-ADGroup -Filter { Name -eq $service } -ErrorAction SilentlyContinue
        if ($group) {
            Remove-ADGroup -Identity $service -Confirm $true
            Write-Host("Le groupe `$service` a bien été suppprimé") -ForegroundColor Green
        }
        else {
            throw "Le groupe `$service` n'a pas été trouvé"
        }
    }

    [void] creationPlusieursUsers() {
        foreach ($u in $this.file) {
            Write-Host "Traitement de l'utilisateur : $($u.Prenom) $($u.Nom) - Service : $($u.Service)"
            Write-Host "$($u.Service)"
            $this.creationOU($u.Service)
            $ouPath = Get-ADOrganizationalUnit -Filter * 
            Write-Host "$ouPath"
            $this.creationGroup($u.Service)
            $this.creationUser($u.Prenom, $u.Nom, $u.Login, $u.Password, $u.Service, $ouPath)
        }
    }
}

#Execution du programme
$filePath =  "C:\Users\Administrateur\csv\LabCorp_SA.csv" #read-host "Entrez le chemin du fichier csv qui contient les données des users"
$ouCreationPath = "OU=UO,OU=Lab,DC=lab,DC=local"  #read-host "Entrez le chemin où seront crée les OU correpondant au services"
$groupPath = "OU=Group,OU=Lab,DC=lab,DC=local" #read-host "Entrez le chemin où seront crée les groupes correspondant au services"
$srvADDS = [ADadmin]::new($filePath,$ouCreationPath,$groupPath)
$srvADDS.creationPlusieursUsers()