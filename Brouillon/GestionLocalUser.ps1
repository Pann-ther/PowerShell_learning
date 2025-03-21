class LocalUser {
    [string]$nomUtilisateur
    [string]$groupe
    [boolean]$existe

    LocalUser([string]$nomUtilisateur) {
        $this.nomUtilisateur = $nomUtilisateur
    }

    [void]creer() {
        try {
            New-LocalUser -Name $this.nomUtilisateur -ErrorAction Stop
            Write-Host "L'utilisateur a ete cree" -ForegroundColor Blue
        }
        catch {
            Write-Host "L'utilisateur existe déja" -ForegroundColor Red
        }
        
    }

    [void]supprimer() {
        try {
            Remove-LocalUser -Name $this.nomUtilisateur -ErrorAction Stop
            Write-Host "L'utilisateur a ete supprime" -ForegroundColor Blue
        }
        catch {
            Write-Host "L'utilisateur n'existe pas" -ForegroundColor Red
        }
        

    }

    [void]verifierExistance() {
        try {
            Get-LocalUser -Name $this.nomUtilisateur -ErrorAction Stop
            Write-Host "L'utilisateur $($this.nomUtilisateur) existe déja" -ForegroundColor DarkBlue
            $this.existe = $true
        }
        catch {
            Write-Host "L'utilisateur $($this.nomUtilisateur) n'existe pas" -ForegroundColor DarkRed
            $this.existe = $false
        }
    }
}


$user1 = [LocalUser]::new("guest")

$user1.verifierExistance()
if ($user1.existe -ne $true) {
    $user1.creer()
}
else {
    $user1.supprimer()
}

