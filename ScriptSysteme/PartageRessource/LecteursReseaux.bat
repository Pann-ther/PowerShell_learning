@echo off

rem acces au repertoire Ressources par la lettre Y pour tous
net use Y: \\W2K22Bretagne\Ressources

rem acces au repertoire Armée par la lettre W uniqument pour Arthur
if "%USERNAME%"=="Arthur" goto :Arthur
:Arthur
net use W: \\W2K22\Bretagne\Armée
goto :end

rem acces au repertoire Justice par la lettre X uniqument pour Léodagan
if "%USERNAME%"=="Léodagan" goto :Léodagan
:Léodagan
net use X: \\W2K22\Bretagne\Justice
goto :end

echo on
:end
