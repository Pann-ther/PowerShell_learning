class User {
    [string]$prenom
    [string]$nom 
    [string]$login 
    [string]$pswd 
    [string]$groupe
    [bool]$enabled
    [bool]$exist
    [string]$path


    User([string]$prenom, [string]$nom, [string]$pswd,[string]$groupe, [string]$path){
        $this.prenom = $prenom
        $this.nom = $nom
        $this.login = $this.prenom.Substring(0,1)+$this.nom
        $this.pswd = $pswd
        $this.groupe = $groupe
        $this.path = $path
    }

    [void]createOU(){
        $ou = Read-Host "Entrez le nom de l'OU"
        $pathOU = Read-Host "Entrez le chemin de l'OU"

        if(Get-ADOrganizationalUnit -Filter {Name -eq $ou}){
            Write-Host "L'OU existe deja"
        }else{
            try {
                New-ADOrganizationalUnit -Name $ou -Path $pathOU -ErrorAction Stop
                Write-Host "L'OU $ou a ete cree avec succes"
            }
            catch {
                Write-Host "L'OU n'a pas pu etre cree, veuillez rentrez un chemin valide "
            }
        }
    }

    [void]userExists(){
        try{
            Get-ADUser -Identity $this.login -ErrorAction Stop
            $this.exist = $true
        }catch{
            $this.exist = $false
        }
    }

    [void]createUser(){
        $this.userExists()
        if(-not $this.exist){
            if(Get-ADOrganizationalUnit -Filter {distinguishedName -eq $this.path}){
                try{
                    New-ADUser -GivenName $this.prenom -Name $this.nom -SamAccountName $this.login -path $this.path -AccountPassword (ConvertTo-SecureString $this.pswd -AsPlainText -Force) -ErrorAction Stop
                    Write-Host "L'utilisateur a ete cree avec succes"
                }catch{
                    Write-Host "L'utilisateur"
                }      
            }else{
                Write-Host "L'OU n'existe pas, l'utilisateur n'a pas ete cree. Entrez le chemin d'un OU existant"
            }
        } else{
            Write-Host "L'utilisateur est deja existant"
        }
    }

    [void]removeUser(){
        try{
            Remove-ADUser -Identity $this.login -Confirm:$false -ErrorAction Stop
            Write-Host "L'utilisateur ete supprime avec succes"
        }catch{
            Write-Host "L'utilisateur n'a pas ete trouve, la suppression ne s'est pas effectuee"
        }
    }

    [void]enabledUser(){
        $this.enabled = $true
        try{
            Set-ADUser -Identity $this.prenom -Enabled $true -ErrorAction Stop
        }catch{
            Write-Host "L'utilisateur n'a pas ete trouve"
        }
    }

    [void]disabledUser(){
        $this.enabled = $false
        try{
            Set-ADUser -Identity $this.prenom -Enabled $false -ErrorAction Stop
        }catch{
            Write-Host "L'utilisateur n'a pas ete trouve"
        }
    }

    [void]addGroupUser(){
        if(-not (Get-ADGroupMember -Identity $this.groupe | Where-Object {$_.SamAccountName -eq $this.login})){
            if(Get-ADGroup -Filter {name -eq $this.groupe}){
                try{
                    Add-ADGroupMember -Identity $this.groupe -Members $this.login
                    Write-Host "Utilisateur $($this.login) a ete ajoute avec succes dans le groupe $($this.groupe)"
                }catch{
                    Write-Host "L'utilisateur n'a pas pu etre ajoute au groupe"
                }
            }else{
                Write-Host "Ce groupe n'existe pas"
            }
        }else{
            Write-Host "L'utilisateur fait deja partie de ce groupe"
        }
    }
}

$file = Import-Csv "C:\Shares\Scripts_powershell\users.csv" -Delimiter ";"

foreach($u in $file){
    $prenom = $u.prenom
    $nom = $u.nom
    $pswd = $u.mdp
    $groupe = $u.groupe
    $path = $u.path
    $user = [User]::new($prenom,$nom,$pswd,$groupe,$path)
    $user.createUser()
    $user.addGroupUser()
    Get-ADGroupMember -Identity Techniciens
}

#$user1.createUser()
#$user1.addGroupUser()
#$user1.removeUser()


#OU=G3,DC=lab,DC=lan
#CN=Techniciens,DC=lab,DC=lan
