#Afficher un msg en console
Write-Host "Bonjour"

#Demander un nom et un prenom
$nom = Read-Host "Entrez votre nom"
$prenom = Read-Host "Entrez votre prenom"

Write-Host "Bonjour $nom $prenom"

#Additionner 2 nombres

$a = [int](Read-Host "Entrez le premier nombre")
$b = [int](Read-Host "Entrez le deuxieme nombre")
$somme = $a+$b

Write-Host "La somme de $a + $b est $somme"

#Verifier si un nombre est pair ou impair

$nombre = [int](Read-Host "Entrez un nombre entier")

if ($nombre % 2 -eq 0) {
    Write-Host "$nombre est pair"
} else {
    Write-Host "$nombre est impair"
}

#Verifier si un user est majeur
$age = Read-Host "Entrez votre age"

if ($age -gt 18) {
    Write-Host "Vous etes majeur"
} else {
    Write-Host "Vous etes mineur"
}

#Comparaison de deux nombres
$a = [int](Read-Host "Entrez le premier nombre")
$b = [int](Read-Host "Entrez le deuxieme nombre")

if ($a -gt $b) {
    Write-Host "$a est plus grand que $b"
} elseif ($a -lt $b) {
    Write-Host "$a est plus petit que $b"
} else {
    Write-Host "$a est egal à $b"
}
