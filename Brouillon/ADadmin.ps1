class ADadmin {
    [object[]]$file
    [string]$ouCreationPath
    [string]$groupPath
    
    ADadmin([object[]]$file, [string]$ouCreationPath, [string]$groupPath) {
        if (-not (Test-Path $file )) {
            throw "Le chemin n'existe pas" 
        }
        elseif (-not (Get-ADOrganizationalUnit -Identity $ouCreationPath -ErrorAction SilentlyContinue)) {
            throw "Le chemin de creation de l'OU n'existe pas"
        }
        $this.file = Import-Csv $file
        $this.ouCreationPath = $ouCreationPath
        $this.groupPath = $groupPath
    }

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
        }
        catch {
            Write-Host "L'utilisateur $prenom $nom n'a pas pu etre cree"
        }
    }

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
            Write-Host "$login a bien ete ajoute au groupe $service " -ForegroundColor Green
        }
        else {
            throw "Le groupe $service n'a pas ete trouve" 
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

    [void] supprimerTousLesGroups(){
        foreach($u in $this.file){
            $this.supprimerGroup($u.Service)
        }
    }

    [void] supprimerToutesLesOU(){
        foreach($u in $this.file){
            $this.supprimerOu($u.Service)
        }
    }

    [void] creationPlusieursUsers() {
        foreach ($u in $this.file) {
            $this.creationOU($u.Service)
            $ouPath = Get-ADOrganizationalUnit -Filter "Name -eq '$($u.Service)'"
            $this.creationGroup($u.Service)
            $this.creationUser($u.Prenom, $u.Nom, $u.Login, $u.Password, $u.Service, $ouPath)
        }
    }
}

#Execution du programme
$filePath = ".\test.csv" #read-host "Entrez le chemin du fichier csv qui contient les données des users"
$ouCreationPath = "OU=OU,OU=LAB,DC=lab,DC=local"  #read-host "Entrez le chemin où seront crée les OU correpondant au services"
$groupPath = "OU=Group,OU=Lab,DC=lab,DC=local" #read-host "Entrez le chemin où seront crée les groupes correspondant au services"
$srvADDS = [ADadmin]::new($filePath, $ouCreationPath, $groupPath)
$srvADDS.creationPlusieursUsers()
#$srvADDS.supprimerTousLesGroups()
#$srvADDS.supprimerToutesLesOU()