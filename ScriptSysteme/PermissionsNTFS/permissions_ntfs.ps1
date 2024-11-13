# Stock les chemins des repertoires
$pathUser1datas = "U:\User1datas";
$pathUser2datas = "U:\User2datas";
$pathCommudatas = "U:\Commundatas";
$pathProcessdatas = "U:\Processdatas";

# Retire les permissions prétablis
icacls $pathUser1datas /reset;
icacls $pathUser2datas /reset;
icacls $pathCommudatas /reset;
icacls $pathProcessdatas /reset;

# Ajout les permissions sur User1datas
icacls $pathUser1datas /grant "User1:(OI)(CI)F" /T;
icacls $pathUser1datas /grant "Administrateurs:(OI)(CI)F" /T;
icacls $pathUser1datas /deny "Utilisateurs:(OI)(CI)F" /T;

# Ajout des permissions sur User2datas
icacls $pathUser2datas /grant "User2:(OI)(CI)F" /T;
icacls $pathUser2datas /grant "Administrateurs:(OI)(CI)F" /T;
icacls $pathUser2datas /deny "Utilisateurs:(OI)(CI)F" /T;

# Ajout des permissions sur Commundatas
icacls $pathCommudatas /grant "Utilisateurs:(OI)(CI)F" /T;

# Ajout des permissions sur Processdatas
icacls $pathProcessdatas /grant "User1:(OI)(CI)R" /T;
icacls $pathProcessdatas /grant "User2:(OI)(CI)R" /T;
icacls $pathProcessdatas /grant "User2:(OI)(CI)R" /T;
icacls $pathProcessdatas /deny "Utilisateurs:(OI)(CI)W" /T;

# Afficher les permissions 
icacls $pathUser1datas
icacls $pathUser2datas
icacls $pathCommudatas
icacls $pathProcessdatas