class User {
    [int]$age
    [string]$prenom
    [string]$nom

    # Constructeur
    User([int]$age, [string]$prenom, [string]$nom) {
        $this.age = $age
        $this.prenom = $prenom
        $this.nom = $nom
    }

    # Affiche les propriétés de l'objet
    [string]toString() {
        return "Nom: $($this.nom), Prenom: $($this.prenom), Age: $($this.age)"
    }
}

# Fonction pour creer un utilisateur et l'ajouter a un tableau
function createUser {
    param (
        [int]$age,
        [string]$prenom,
        [string]$nom,
        [array]$tab
    )
    $user = [User]::new($age, $prenom, $nom)
    return $tab += $user
}
# Affiche les propriétés des objets du tableau
function displayUsers {
    param (
        [array]$tab
    )

    foreach ($user in $tab) {
        Write-Host $user.ToString()
    }
}

# Cherche si un utilisateur existe dans le tableau
function findUser {
    param (
        [string]$nom,
        [array]$tab
    )

    
    foreach ($user in $tab) {
        if ($user.prenom -eq $nom) {
            Write-Host "$nom est present dans la liste"
            return
        }
    }

    Write-Host "$nom n'a pas ete trouve dans le tableau d'utilisateur"
}

# Initialisation du tableau
$users = @()

$users = createUser -age 50 -prenom "Luc" -nom "Shen" -tab $users
$users = createUser -age 22 -prenom "Thomas" -nom "Tran" -tab $users
$users = createUser -age 25 -prenom "Kevin" -nom "Leroy" -tab $users
$users = createUser -age 30 -prenom "Quentin" -nom "Lau" -tab $users

displayUsers $users

findUser -nom "Luc" -tab $users

