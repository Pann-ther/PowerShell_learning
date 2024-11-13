# Parametres de declanchement pour exécuter la tache chaque lundi a 17h
$Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 17:00 ;

# Action qui execute Microsoft Defender pour un scan
$Action = New-ScheduledTaskAction -Execute "MpCmdRun.exe" -Argument "-Scan -ScanType 2";

# Creation de la tache "Scan antivirus hebdomadaire"
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Scan antivirus hebdomadaire" -RunLevel Highest -Force;