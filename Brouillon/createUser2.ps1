class User {
    [string]$prenom
    [string]$nom 
    [string]$cn
    [string]$login 
    [string]$pswd 
    [string]$groupe
    [bool]$enabled
    [bool]$exist
    [string]$path
    [string]$log


    User([string]$prenom, [string]$nom, [string]$pswd,[string]$groupe, [string]$path, [string]$log){
        $this.prenom = $prenom
        $this.nom = $nom
        $this.cn = "$($this.prenom) $($this.nom)"
        $this.login = $($this.prenom.Substring(0,1)+$this.nom).ToLower()
        $this.pswd = $pswd
        $this.groupe = $groupe
        $this.path = $path
        $this.log = $log

        #Verifie si un user a deja le meme login
        $index = 1
        while (Get-ADUser -Filter {SamAccountName -eq $this.login}) {
            $this.login = $this.login+$index
            $this.cn = $this.cn+$index
            $index++
        }
    }

    [void]addLog([string]$message){
        $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$date - $message" | Out-File -FilePath $this.log  -Append -Encoding utf8
    }

    [void]createOU(){
        $ou = Read-Host "Entrez le nom de l'OU"
        $pathOU = Read-Host "Entrez le chemin de l'OU"

        if(Get-ADOrganizationalUnit -Filter {Name -eq $ou}){
            Write-Host "L'OU existe deja"
        }else{
            try {
                New-ADOrganizationalUnit -Name $ou -Path $pathOU -ErrorAction Stop
                $this.addLog("INFO: l'OU $ou a ete cree avec succes") 
            }
            catch {
                $this.addLog("ERROR: l'OU $ou n'a pas pu etre cree, veuillez rentrez un chemin valide ") 
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
                    New-ADUser -GivenName $this.prenom -Surname $this.nom -Name $this.cn -SamAccountName $this.login -path $this.path -AccountPassword (ConvertTo-SecureString $this.pswd -AsPlainText -Force) -ErrorAction Stop
                    $this.addLog("INFO: l'utilisateur $($this.login) a ete cree avec succes")
                }catch{
                    $this.addLog("ERROR: l'utilisateur $($this.login) n'a pas pu etre cree $($_.Exception.Message)") 
                }      
            }else{
                $this.addLog("ERROR: l'OU n'existe pas, l'utilisateur n'a pas ete cree. Entrez le chemin d'un OU existant") 
            }
        } else{
            $this.addLog("EEROR: l'utilisateur $($this.login) est deja existant") 
        }
    }

    [void]removeUser(){
        try{
            Remove-ADUser -Identity $this.login -Confirm:$false -ErrorAction Stop
            $this.addLog("INFO: l'utilisateur ete supprime avec succes") 
        }catch{
            $this.addLog("ERROR: l'utilisateur $($this.login) n'a pas ete trouve, la suppression ne s'est pas effectuee") 
        }
    }

    [void]enabledUser(){
        $this.enabled = $true
        try{
            Set-ADUser -Identity $this.prenom -Enabled $true -ErrorAction Stop
        }catch{
            $this.addLog("ERROR: l'utilisateur $($this.login) n'a pas ete trouve")
        }
    }

    [void]disabledUser(){
        $this.enabled = $false
        try{
            Set-ADUser -Identity $this.prenom -Enabled $false -ErrorAction Stop
        }catch{
            $this.addLog("ERROR: l'utilisateur $($this.login) n'a pas ete trouve") 
        }
    }

    [void]addGroupUser(){
        if(-not (Get-ADGroupMember -Identity $this.groupe | Where-Object {$_.SamAccountName -eq $this.login})){
            if(Get-ADGroup -Filter {name -eq $this.groupe}){
                try{
                    Add-ADGroupMember -Identity $this.groupe -Members $this.login
                    $this.addLog("INFO: Utilisateur $($this.login) a ete ajoute avec succes dans le groupe $($this.groupe)")
                }catch{
                    $this.addLog("ERROR: l'utilisateur $($this.login) n'a pas pu etre ajoute au groupe") 
                }
            }else{
                $this.addLog("ERROR: le groupe $($this.groupe) n'existe pas") 
            }
        }else{
            $this.addLog("ERROR: l'utilisateur $($this.login) fait deja partie du groupe $($this.groupe)") 
        }
    }
}

$file = Import-Csv "C:\Shares\Scripts_powershell\users.csv" -Delimiter ";"
$logfile = "C:\Shares\Scripts_powershell\logCreateUser.txt"

foreach($u in $file){
    $prenom = $u.prenom
    $nom = $u.nom
    $pswd = $u.mdp
    $groupe = $u.groupe
    $path = $u.path

    $user = [User]::new($prenom,$nom,$pswd,$groupe,$path,$logfile)
    $user.createUser()
    $user.addGroupUser()
}


