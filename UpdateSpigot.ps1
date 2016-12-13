$startDirectory = "C:\Bitnami\Updater"
cd $startDirectory

# Download latest version of BuildTools.jar
$uri = "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
$buildTools = "BuildTools.jar"
If (Test-Path $buildTools) {
    Remove-Item -Force $buildTools
}
# By default powershell uses TLS 1.0 the site security requires TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $uri -OutFile $buildTools

# Start Bash shell and run BuildTools.jar to download latest version of Spigot
If (Test-Path $buildTools) {
    $jarDirectory = "C:\Bitnami\multicraft-2.1.0-1\apps\multicraft\jar"
    Start-Process -Wait -NoNewWindow -FilePath "C:\Program Files\Git\bin\bash.exe" -ArgumentList '-c', '"cd /c/Bitnami/Updater && java -jar BuildTools.jar"'
}
Else {
    Exit
}

# If successfully built, copy new jar file to server jar directory
If(Test-Path spigot-*.jar) {
    $jarFile = Get-ChildItem -Name spigot-*.jar
    Copy-Item -Force $jarFile $jarDirectory\spigot.jar
}

# Cleanup
Remove-Item -Recurse -Force BuildData
Remove-Item -Recurse -Force Bukkit
Remove-Item -Recurse -Force CraftBukkit
Remove-Item -Recurse -Force Spigot
Remove-Item -Recurse -Force work
Remove-Item -Force *.jar