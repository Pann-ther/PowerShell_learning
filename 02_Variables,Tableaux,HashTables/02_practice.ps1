<#Exercice 1 : Afficher des Informations sur le Système
Objectif : Créer une variable pour stocker des informations sur le système d'exploitation et afficher ces informations.#>
Write-Output "Exercice 1"

$InfoOS = Get-ComputerInfo
Write-Output $InfoOS

<#Exercice 2 : Obtenir la Liste des Services
Objectif : Stocker la liste des services en cours d'exécution dans une variable et afficher uniquement les noms de ces services.#>
Write-Output "Exercice 2"

$NameService = Get-Service | Select-Object -Property Name
Write-Output $NameService

<#Exercice 3 : Manipuler un Tableau d'Utilisateurs
Objectif : Créer un tableau contenant les noms des utilisateurs de ton système et afficher chaque nom.#>
Write-Output "Exercice 3"

$NameUser = Get-LocalUser 

$NbUser = $NameUser.Count
Write-Output "Nombre d'utilisateurs locaux : $NbUser"

$Users = @()

$Users += $NameUser[0].Name
$Users += $NameUser[1].Name
$Users += $NameUser[2].Name
$Users += $NameUser[3].Name
$Users += $NameUser[4].Name
$Users += $NameUser[5].Name

Write-Output $Users `n`


<#Exercice 4 : Filtrer les Processus
Objectif : Créer une variable pour stocker les processus en cours et filtrer cette liste pour n'afficher que ceux qui consomment plus d'une certaine quantité de CPU.#>
Write-Output "Exercice 4"

$ConsoProcess = Get-Process | Where-Object {$_.CPU -gt 500}
Write-Output $ConsoProcess

<#Exercice 5 : Créer une Hashtable pour les Propriétés d'un Fichier
Objectif : Créer une hashtable pour stocker les propriétés d'un fichier spécifique (par exemple, nom, taille, date de création) et afficher ces propriétés.#>
Write-Output "Exercice 5"

$fichier = @{
    nom = "OfficeSetup"
    Type = "Application"
    Taille = "7600Ko"
}

Write-Output $fichier

<#Exercice 6 : Exporter des Informations Systèmes
Objectif : Stocker les informations sur l'espace disque disponible dans une variable et les exporter dans un fichier texte.#>
$EspaceLibre = Get-PSDrive -Name C

$EspaceLibre | Out-File  -FilePath "C:\Users\chebb\Documents\EspaceLibre.txt" 


<#Exercice 7 : Utiliser des Cmdlets pour Gérer les Fichiers
Objectif : Créer une variable pour stocker la liste des fichiers d'un répertoire spécifique, puis renommer un fichier dans ce répertoire.#>
$ListeRepertoire = Get-ChildItem -Path "C:\Users\chebb\Documents\Exercice 7"

Rename-Item -Path $ListeRepertoire[0].FullName -NewName "HashTable.txt"
