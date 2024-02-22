#Osconfig - Simple Script
#run this 
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection /t REG_DWORD /v AllowTelemetry /d 00000003 /f
 
#run this to authenticate - change user to your v- and password, seperate with space
net use Z: \\scfs\users\dayanc\OSConfig_Test_Collateral /user:v-zkigen ************ 
#change directory to C and create directory on C:\
cd C:\
mkdir OSConfig_Test_Collateral
cd OSConfig_Test_Collateral
mkdir DomainController
mkdir MemberServer
#copy
robocopy \\scfs\users\dayanc\OSConfig_Test_Collateral\DomainController C:\OSConfig_Test_Collateral\DomainController
robocopy \\scfs\users\dayanc\OSConfig_Test_Collateral\MemberServer C:\OSConfig_Test_Collateral\MemberServer
 
# Check is the files were copied using dir or ls
dir C:\OSConfig_Test_Collateral\MemberServer
ls C:\OSConfig_Test_Collateral\DomainController
#Set Execution Policy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
 
#Start here for Security Baseline DC Scenario
 
reg import C:\OSConfig_Test_Collateral\DomainController\PMWS2025DCBaseline.reg
reg import C:\OSConfig_Test_Collateral\DomainController\WinDCWS2025DCBaseline.reg
 
 
Get-Content C:\OSConfig_Test_Collateral\DomainController\WS2025DomainControllerSecurityBaseline_OsConfigurationDoc.json -raw | Set-OSConfigurationDocument
Get-OsConfigurationDocument -Id PS-0C04CD36-73C6-4183-B95E-014CD0752F00 | Get-OsConfigurationDocumentResult
 
#Copy result json blob into any JSON Formatter (such as the online one at https://jsonformatter.org/json-parser)
#Search for "Failed"
 
#For Security Baseline MS Scenario
 
reg import C:\OSConfig_Test_Collateral\MemberServer\PMWS2025MSBaseline.reg
reg import C:\OSConfig_Test_Collateral\MemberServer\WinDCWS2025MSBaseline.reg
 
Get-Content C:\OSConfig_Test_Collateral\MemberServer\WS2025MemberServerSecurityBaseline_OsConfigurationDoc.json -raw | Set-OSConfigurationDocument
Get-OsConfigurationDocument -Id PS-F255DD21-C720-46B4-907E-E69B09AEDD51 | Get-OsConfigurationDocumentResult
 
#Copy result json blob into any JSON Formatter (such as the online one at https://jsonformatter.org/json-parser)
#Search for "Failed"
 
#this is now done for both DC and MS Scenarios and also check for more info and steps the original doc before doing.
Install-Module SpeculationControl
 
# Save the current execution policy so it can be reset
$SaveExecutionPolicy = Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope Currentuser
Import-Module SpeculationControl
Get-SpeculationControlSettings
# Reset the execution policy to the original state
Set-ExecutionPolicy $SaveExecutionPolicy -Scope Currentuser
