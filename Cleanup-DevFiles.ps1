# Cleanup-DevFiles.ps1

# Define the target drive
$Drive = "E:\"

# Define folders to remove
$FoldersToRemove = @(
    "node_modules",
    "build",
    "dist" # Add other folders if needed
)

# Define file extensions to remove (programmatically created files)
$FileExtensionsToRemove = @(
    ".tmp",
    ".log",
    ".bak" # Add other file extensions if needed
)

# Define global caches to clean (add more if required)
$GlobalCaches = @(
    "npm",
    "pip",
    "gradle", # If you use Gradle
    "yarn" # If you use Yarn
)

# Function to clean global caches
function Clean-GlobalCache {
    param($CacheType)

    switch ($CacheType) {
        "npm" {
            Write-Host "Cleaning npm cache..."
            npm cache clean --force
        }
        "pip" {
            Write-Host "Cleaning pip cache..."
            pip cache purge
        }
        "gradle" {
            Write-Host "Cleaning Gradle cache..."
            # Adjust this path based on your Gradle setup
            $GradleCachePath = "$env:USERPROFILE\.gradle\caches"
            if (Test-Path $GradleCachePath) {
                Remove-Item -Path $GradleCachePath -Recurse -Force
            }
        }
        "yarn" {
            Write-Host "Cleaning Yarn cache..."
            yarn cache clean --all
        }
        # Add more cache cleaning commands for other tools as needed
        default {
            Write-Host "Unknown cache type: $CacheType"
        }
    }
}

Write-Host "Starting cleanup process on drive $Drive..."

# Remove specified folders
foreach ($folder in $FoldersToRemove) {
    Write-Host "Searching for '$folder' folders in $Drive..."
    Get-ChildItem -Path $Drive -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $folder } | ForEach-Object {
        Write-Host "Removing folder: $($_.FullName)"
        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Remove specified file extensions (excluding system directories like Windows and Program Files)
Write-Host "Searching for files with specified extensions in $Drive..."
Get-ChildItem -Path $Drive -Recurse -Include $FileExtensionsToRemove -File -ErrorAction SilentlyContinue | Where-Object {
    $_.DirectoryName -notlike "*\Windows\*" -and $_.DirectoryName -notlike "*\Program Files*"
} | ForEach-Object {
    Write-Host "Removing file: $($_.FullName)"
    Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
}

# Clean global caches
foreach ($cache in $GlobalCaches) {
    Clean-GlobalCache -CacheType $cache
}

Write-Host "Cleanup process completed."

# (Optional) Log the cleanup process to a file
# Start-Transcript -Path "C:\CleanupLog.txt" -Append
# ... (add cleanup commands here)
# Stop-Transcript
