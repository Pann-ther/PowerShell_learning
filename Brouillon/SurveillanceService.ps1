class ServiceWindows {
    [string]$nom 
    [string]$status

    ServiceWindows([string]$nom){
        $this.nom = $nom
        $this.status = (Get-Service -Name $this.nom).Status
    }

    [void]start(){
            Start-Service $this.nom
    }

    [void]stop(){
        Stop-Service $this.nom
    }

    [string]verifierStatus(){
        return "$($this.nom) is $($this.status)"
    }
}

$service1 = [ServiceWindows]::new("Spooler")

$service1.verifierStatus()