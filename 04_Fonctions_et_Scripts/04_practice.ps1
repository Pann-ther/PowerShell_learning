function CalculMoyenne {
    param(
        [int]$a,
        [int]$b,
        [int]$c
    )

    [math]::round(($a+$b+$c)/3 , 2)
}

function AfficherMoyenne{
    param(
        [int]$a,
        [int]$b,
        [int]$c,
        [int]$moyenne
    )

    write-output "La moyenne de la serie($a,$b,$c) est $moyenne"
    
}
#Creation des series 
$series = @(
    @(10,15,6),
    @(12,17,4),
    @(18,4,10),
    @(20,2,10),
    @(13,15,18)
)

#Script calcule de moyenne 
foreach ($serie in $series) {
    $Moyenne = CalculMoyenne -a $serie[0] -b $serie[1] -c $serie[2]
    AfficherMoyenne -a $serie[0] -b $serie[1] -c $serie[2] -moyenne $Moyenne
}



