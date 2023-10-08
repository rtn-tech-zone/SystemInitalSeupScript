# Function to check if a program is installed and print its version
function CheckInstalled($programName, $versionCommand) {
    $installed = Get-Command -Name $programName -ErrorAction SilentlyContinue
    if ($installed) {
        #Write-Host "$programName is already installed. Version:"
        #Invoke-Expression -Command $versionCommand
        $version = Invoke-Expression -Command $versionCommand
        Write-Host "$programName is already installed. Version: $version"
        return $true
    }
    return $false
}

# Function to prompt for installation confirmation
function Prompt-InstallationConfirmation {
    $response = Read-Host "Do you want to proceed with the installation? (Y/N)"
    if ($response -eq "Y" -or $response -eq "y") {
        return $true
    } else {
        return $false
    }
}

function Download-FileWithProgressOld {
    param (
        [string]$Url,
        [string]$LocalFilePath
    )

    # Download the file and show download progress
    $webRequest = Invoke-WebRequest -Uri $Url -OutFile $LocalFilePath -PassThru

    # Get the total file size
    $totalSize = $webRequest.Headers['Content-Length']

    # Initialize variables for download progress
    $downloadedSize = 0
    $lastProgress = 0

    # Define a callback function for displaying progress
    $progressCallback = {
        param (
            [long]$downloadedSize,
            [long]$totalSize
        )
        
        $percentage = ($downloadedSize / $totalSize) * 100
        
        # Display progress only if there's a significant change
        if ($percentage -gt $lastProgress + 5) {
            #Write-Progress -PercentComplete $percentage -Status "Downloading" -CurrentOperation "Download Progress" #Activity and StatusDescription parameters missing so below line added
            #Write-Progress -PercentComplete $percentage -Status "Downloading" -CurrentOperation "Download Progress" -Activity "Downloading" -StatusDescription "Download Progress"
            #above line gave error
            #Write-Progress -PercentComplete $percentage -Status "Downloading"
            Write-Progress -PercentComplete $percentage -Status $Activity
            $lastProgress = $percentage
        }
    }

    # Monitor download progress
    $webRequest.Content | ForEach-Object {
        $downloadedSize += [System.Text.Encoding]::UTF8.GetBytes($_).Length
        $progressCallback.Invoke($downloadedSize, $totalSize)
    }

    # Complete the progress bar
    Write-Progress -PercentComplete 100 -Status "Download Complete" -Completed
}

# Example usage:
#$downloadUrl = "https://example.com/yourfile.zip"
#$localFilePath = "C:\path\to\your\downloaded\file.zip"
#Download-FileWithProgress -Url $downloadUrl -LocalFilePath $localFilePath

function Download-FileWithProgress {
    param (
        [string]$Url,
        [string]$LocalFilePath
    )

    # Download the file and show download progress
    $webRequest = Invoke-WebRequest -Uri $Url -OutFile $LocalFilePath -PassThru

    # Get the total file size
    #$totalSize = $webRequest.Headers['Content-Length']
    $totalSizeBytes = [double]$webRequest.Headers['Content-Length']
    $totalSizeGB = $totalSizeBytes / 1073741824
    Write-Host "Total Size = $totalSizeGB GB"

    # Initialize variables for download progress
    $downloadedSize = 0

    # Monitor download progress
    $webRequest.Content | ForEach-Object {
        $downloadedSize += [System.Text.Encoding]::UTF8.GetBytes($_).Length
        #$percentage = ($downloadedSize / $totalSize) * 100
        $percentage = [Math]::Round(($downloadedSize / $totalSizeBytes) * 100, 2)

        # Display progress
        # Write-Host "Downloaded: $percentage%"

        # You can also use Write-Progress here if it works in your environment
        # Write-Progress -PercentComplete $percentage -Status "Downloading"

        # Clear the current line and print the progress on the same line
        #Write-Host -NoNewline -ForegroundColor Cyan "Downloaded: $percentage%`r"
        #Write-Host -NoNewline -ForegroundColor Cyan "Downloaded: $($percentage.ToString("F2"))%`r"

        # Set cursor position to overwrite the current line
        #[Console]::SetCursorPosition(0, [Console]::CursorTop)
        #Write-Host -ForegroundColor Cyan "Downloaded: $($percentage)%"
        # Move cursor to the beginning of the line
        #[Console]::SetCursorPosition(0, [Console]::CursorTop)

        # Create a progress message
        #$progressMessage = "Downloaded: $($percentage)%"
        # Create a progress message with total size in GB
        $progressMessage = "Downloaded: $($percentage)% ($totalSizeGB GB)"

        # Clear the current line and print the progress on the same line
        Write-Progress -Activity "Downloading" -Status $progressMessage -PercentComplete $percentage
    }

    # Display download complete
    Write-Host "Download Complete"
}

# Example usage:
#$downloadUrl = "https://example.com/yourfile.zip"
#$localFilePath = "C:\path\to\your\downloaded\file.zip"
#Download-FileWithProgress -Url $downloadUrl -LocalFilePath $localFilePath




# Define variables for download URLs
$openJdkUrl = "https://download.java.net/java/GA/jdk20/634c77d3d5b6470db33db1e6e81b0e51/1/GPL/openjdk-20_windows-x64_bin.zip"
$intelliJUrl = "https://download.jetbrains.com/idea/ideaIC-2021.3.3.exe"
$mavenUrl = "https://archive.apache.org/dist/maven/maven-3/3.5.1/binaries/apache-maven-3.5.1-bin.zip"
$notepadPlusPlusUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.1/npp.8.1.Installer.x64.exe"
$postmanUrl = "https://dl.pstmn.io/download/latest/win64"
$nosqlBoosterUrl = "https://nosqlbooster.com/s3/download/releasesv7/nosqlbooster4mongo-7.4.0.exe"
$postgresqlUrl = "https://www.postgresql.org/ftp/pgadmin/pgadmin4/v6.0/windows/pgadmin4-6.0-x64.exe"
$squirrelDbUrl = "https://www.squirrelsql.org/files/3.12/squirrel-sql-3.12-standard.zip"
$mysqlWorkbenchUrl = "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.28-winx64.msi"
$vsCodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
$nodejsUrl = "https://nodejs.org/dist/v16.13.1/node-v16.13.1-x64.msi"


# Define installation paths
$installDir = "C:\Users\sandi\Tools"
$intelliJDir = "$installDir\IntelliJ"
$mavenDir = "$installDir\Maven"
$notepadPlusPlusDir = "$installDir\NotepadPlusPlus"
$postmanDir = "$installDir\Postman"
$nosqlBoosterDir = "$installDir\NoSQLBooster"
$postgresqlDir = "$installDir\Postgresql"
$squirrelDbDir = "$installDir\SQuirreLSQL"
$mysqlWorkbenchDir = "$installDir\MySQLWorkbench"
$vsCodeDir = "$installDir\VSCode"
$projectDir = "$installDir\Workspace"

# Check if the directory exists before attempting to create it
if (-not (Test-Path -Path $installDir -PathType Container)) {
    New-Item -ItemType Directory -Path $installDir
}

# Check if Node.js is installed
if (!(CheckInstalled "node" "node -v")) {
    # Prompt for installation confirmation
    $installNode = Prompt-InstallationConfirmation
    if ($installNode) {
        # Install Node.js and npm
        Download-FileWithProgress -Url $nodejsUrl -LocalFilePath "$installDir\node-installer.msi"
        # Invoke-WebRequest -Uri $nodejsUrl -OutFile "$installDir\node-installer.msi" #alternate of this line see above
        Start-Process -Wait -FilePath "msiexec.exe" -ArgumentList "/i $installDir\node-installer.msi /qn"
    }
}

# Check if Git is installed
if (!(CheckInstalled "git" "git --version")) {
    # Prompt for installation confirmation
    $installGit = Prompt-InstallationConfirmation
    if ($installGit) {
        # Install Git and ask for credentials
        Start-Process -Wait -FilePath "git.exe" -ArgumentList "config --global credential.helper cache"
        Start-Process -Wait -FilePath "git.exe" -ArgumentList "config --global credential.helper 'cache --timeout=3600'"
        Write-Host "Please enter your Git credentials for the first-time setup."
        Start-Process -Wait -FilePath "git.exe" -ArgumentList "clone https://github.com/rtn-tech-zone/JavaScriptAndCypressLearning.git '$projectDir'"
    }
}

# Clone a Bitbucket project and add the Cypress setup (replace with your repository URL)
if (!(Test-Path $projectDir)) {
    # Prompt for installation confirmation
    $installCypressProject = Prompt-InstallationConfirmation
    if ($installCypressProject) {
        git clone https://github.com/rtn-tech-zone/JavaScriptAndCypressLearning.git "$projectDir"
        # Install Cypress using npm
        # cd $projectDir
        # npm install cypress --save-dev
        # Optionally, run Cypress to ensure it's properly installed
        # npx cypress open
    }
}

# Download and install OpenJDK 20
if (!(CheckInstalled "java" "java -version")) {
    # Prompt for installation confirmation
    $installOpenJDK = Prompt-InstallationConfirmation
    if ($installOpenJDK) {
        # Download and install OpenJDK 20
        Download-FileWithProgress -Url $openJdkUrl -LocalFilePath "$installDir\openjdk-20.zip"
        #Invoke-WebRequest -Uri $openJdkUrl -OutFile "$installDir\openjdk-20.zip"
        Expand-Archive -Path "$installDir\openjdk-20.zip" -DestinationPath "$installDir\OpenJDK-20"
        [System.Environment]::SetEnvironmentVariable("JAVA_HOME", "$installDir\OpenJDK-20", [System.EnvironmentVariableTarget]::Machine)
        $env:Path = "$env:Path;$installDir\OpenJDK-20\bin"
    }
}

# Download and install IntelliJ IDEA Community 2021.3.3
if (!(CheckInstalled "idea64" "idea64.exe -version")) {
    # Prompt for installation confirmation
    $installIntelliJ = Prompt-InstallationConfirmation
    if ($installIntelliJ) {
        # Download and install IntelliJ IDEA Community 2021.3.3
        Download-FileWithProgress -Url $intelliJUrl -LocalFilePath "$installDir\intellij-installer.exe"
        #Invoke-WebRequest -Uri $intelliJUrl -OutFile "$installDir\intellij-installer.exe"
        Start-Process -Wait -FilePath "$installDir\intellij-installer.exe" -ArgumentList "/S /D=$intelliJDir"
        # Add Java SDK and Lombok plugin configuration here
    }
}

# Download and install Maven 3.5.1
if (!(CheckInstalled "mvn" "mvn --version")) {
    # Prompt for installation confirmation
    $installMaven = Prompt-InstallationConfirmation
    if ($installMaven) {
        # Download and install Maven 3.5.1
        Download-FileWithProgress -Url $mavenUrl -LocalFilePath "$installDir\maven.zip"
        #Invoke-WebRequest -Uri $mavenUrl -OutFile "$installDir\maven.zip"
        Expand-Archive -Path "$installDir\maven.zip" -DestinationPath "$installDir\Maven-3.5.1"
        [System.Environment]::SetEnvironmentVariable("MAVEN_HOME", "$installDir\Maven-3.5.1", [System.EnvironmentVariableTarget]::Machine)
        $env:Path = "$env:Path;$installDir\Maven-3.5.1\bin"
    }
}





# Download and install Notepad++ and add plugins
# Check if Notepad++ is installed
if (!(CheckInstalled "notepad++" "notepad++ --version")) {
    # Prompt for installation confirmation
    $installNotepadPlusPlus = Prompt-InstallationConfirmation
    if ($installNotepadPlusPlus) {
        # Download and install Notepad++
        Download-FileWithProgress -Url $notepadPlusPlusUrl -LocalFilePath "$installDir\npp-installer.exe"
        #Invoke-WebRequest -Uri $notepadPlusPlusUrl -OutFile "$installDir\npp-installer.exe"
        Start-Process -Wait -FilePath "$installDir\npp-installer.exe" -ArgumentList "/S"
        $notepadPlusPlusPluginDir = "$env:APPDATA\Notepad++\plugins"
        Write-Host "Copying Notepad++ plugins..."
        Copy-Item -Path "PluginFiles\JsonViewer.dll" -Destination $notepadPlusPlusPluginDir
        Copy-Item -Path "PluginFiles\ComparePlugin.dll" -Destination $notepadPlusPlusPluginDir
        Copy-Item -Path "PluginFiles\NppHTMLTag.dll" -Destination $notepadPlusPlusPluginDir
    }
}



# Check if MySQL Workbench is installed
if (!(Test-Path "$mysqlWorkbenchDir\MySQLWorkbench.exe")) {
    # Prompt for installation confirmation
    $installMySQLWorkbench = Prompt-InstallationConfirmation
    if ($installMySQLWorkbench) {
        # Download and install MySQL Workbench
        Download-FileWithProgress -Url $mysqlWorkbenchUrl -LocalFilePath "$installDir\mysql-workbench-installer.msi"
        #Invoke-WebRequest -Uri $mysqlWorkbenchUrl -OutFile "$installDir\mysql-workbench-installer.msi"
        Start-Process -Wait -FilePath "msiexec.exe" -ArgumentList "/i $installDir\mysql-workbench-installer.msi /qn"
    }
}



# Check if Visual Studio Code is installed
if (!(Test-Path "$vsCodeDir\Code.exe")) {
    # Prompt for installation confirmation
    $installVSCode = Prompt-InstallationConfirmation
    if ($installVSCode) {
        # Download and install Visual Studio Code
        Download-FileWithProgress -Url $vsCodeUrl -LocalFilePath "$installDir\vscode-installer.exe"
        #Invoke-WebRequest -Uri $vsCodeUrl -OutFile "$installDir\vscode-installer.exe"
        Start-Process -Wait -FilePath "$installDir\vscode-installer.exe" -ArgumentList "--silent --user-data-dir=$vsCodeDir"
    }
}

# Install JavaScript (ESLint) and Git plugins for Visual Studio Code
if (Test-Path "$vsCodeDir\Code.exe") {
    # Install JavaScript (ESLint) extension
    Start-Process -Wait -FilePath "$vsCodeDir\Code.exe" -ArgumentList "--install-extension dbaeumer.vscode-eslint"

    # Install GitLens extension
    Start-Process -Wait -FilePath "$vsCodeDir\Code.exe" -ArgumentList "--install-extension eamodio.gitlens"
}

