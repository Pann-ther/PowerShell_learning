# Exercice 1 : Contrôle de l'Espace Disque
# Objectif : Vérifier l'espace disque disponible sur un lecteur et afficher un avertissement si l'espace libre est inférieur à un seuil.
Write-Output "Exercice 1" 

$EspaceDisque = Get-PSDrive -Name C | Select-Object -ExpandProperty Free
$EspaceDisque = [math]::round($EspaceDisque / 1GB)

if ($EspaceDisque -lt 900) {
    Write-Output "Attention votre espace de stockage est inferieur à 900GB : $EspaceDisque GB" 
}
Write-Output "`n"


# Exercice 2 : Parcourir les Processus
# Objectif : Créer une variable pour stocker les processus en cours et utiliser une boucle pour afficher uniquement ceux qui consomment plus d'une certaine quantité de mémoire.
Write-Output "Exercice 2"

$Processus = Get-Process 

foreach ($Process in $Processus) {
    if ($Process.WorkingSet -gt 100MB) {
        Write-Output ($Process | Select-Object -Property Name, @{Name= "WorkingSet (MB)"; Expression={[math]::round($_.WorkingSet/1MB)}}) 
    }
}
Write-Output "`n"

# Exercice 3 : Vérifier les Utilisateurs dans un Tableau
# Objectif : Créer un tableau contenant des noms d'utilisateurs. Utiliser une boucle pour vérifier si ces utilisateurs sont actuellement connectés.

$TabUtilisateurs = Get-LocalUser | Select-Object -Property Name, Enabled

foreach ($Utilisateur in $Utilisateurs) {
   if ($Utilisateur.Enabled -eq 'True') {
     Write-Output $Utilisateur 
   }
}
Write-Output "`n"


# Exercice 4 : Vérifier l'État des Services
# Objectif : Créer un tableau de services importants. Utiliser une boucle pour vérifier l'état de chaque service et afficher un message indiquant s'il est démarré ou arrêté.
Write-Output "Exercice 4"

$TabServices = Get-Service | Select-Object -First 30
foreach ($Service in $TabServices) {
   if($Service.Status -eq 'Running'){
    Write-Output "$($Service.Name) est démarré"
   }
   else {
    Write-Output "$($Service.Name) est arrété" 
   }
}
Write-Output "`n"

# Exercice 5 : Boucle sur les Fichiers d'un Répertoire
# Objectif : Parcourir les fichiers d'un répertoire spécifique, et pour chaque fichier de type texte, afficher un message indiquant sa taille.
Write-Output "Exercice 5"

$TailleFichiers = Get-ChildItem -Path "C:\Users\chebb\Documents"

foreach ($Fichier in $TailleFichiers) {
    $Type = $Fichier.Extension
    if ($Type -eq ".txt") {
        $Format = [math]::Round($Fichier.Length / 1KB, 2)
        Write-Output "$($Fichier.Name) a une taille de $($Format) KB"
    }
}
Write-Output "`n"



# Exercice 6 : Analyser les Événements du Journal Système
# Objectif : Créer une variable contenant les événements d'erreur récents du journal système. Utiliser une boucle pour analyser ces événements et afficher un avertissement pour ceux qui sont critiques.
Write-Output "Exercice 6"

$ErrorSystem = Get-WinEvent -LogName System | Select-Object -First 100

$EventCrit = $false

foreach ($Error in $ErrorSystem) {
    if ($Error.LevelDisplayName -eq "Critique") {
        Write-Output "L'evenement $($Error.ProviderNamer) a été détecté comme critique dans le journal systeme"
        $EventCrit = $true
    }
}

if ($EventCrit -eq $false) {
    Write-Output "Aucun événement critique trouvé dans le journal système"
}
Write-Output "`n"




