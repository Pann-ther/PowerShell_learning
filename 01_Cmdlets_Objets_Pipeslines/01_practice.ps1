<#Exercice 1 : Utiliser des Cmdlets de base
Objectif : Utiliser une cmdlet de base pour obtenir des informations sur les processus en cours.
Crée une commande pour afficher tous les processus en cours d'exécution.#>
Get-Process


<#Exercice 2 : Filtrer les résultats
Objectif : Apprendre à filtrer les résultats d'une cmdlet.
Crée une commande pour afficher uniquement les processus dont le nom contient "chrome".#>
Get-Process | Where-Object {$_.name -eq 'chrome'}



<#Exercice 3 : Manipuler des Objets
Objectif : Sélectionner des propriétés spécifiques d'objets.
Crée une commande pour obtenir la liste des services, mais qui affiche uniquement le nom et l'état de chaque service.#>
Get-service| Select-Object -Property name, status


<#Exercice 4 : Utiliser des Pipelines
Objectif : Enchaîner des cmdlets pour traiter les données.
Crée une commande pour obtenir la liste des processus, puis trie ces processus par utilisation de la mémoire (WorkingSet) dans l'ordre décroissant. Sélectionne ensuite les 5 processus qui consomment le plus de mémoire.#>
Get-Process | Sort-Object -Property WorkingSet -Descending | Select-Object -First 5


<#Exercice 5 : Exporter les résultats
Objectif : Exporter les résultats d'une cmdlet vers un fichier.
Crée une commande pour obtenir la liste des services en cours d'exécution et exporte cette liste dans un fichier texte, par exemple "C:\temp\services.txt".#>
Get-Service | Where-Object {$_.status -eq 'Running'} | Out-File -FilePath "C:\Users\chebb\Documents\service.txt"


<#Exercice 6 : Utiliser Format-Table
Objectif : Formater la sortie d'une cmdlet.
Crée une commande pour afficher les ID et les noms des processus sous forme de tableau.#>
Get-Process | Format-Table -Property id, name