# Media-Organizer
# https://github.com/jayeeeeee/media-organizer

# Usage:
#   Start-Organize "[path_to_folder]"
function Start-Organize($Folderpath) {
    $folderPath = (Resolve-Path $Folderpath).Path   # Fullpath.
    $shell = New-Object -COMObject Shell.Application
    $shellFolder = $shell.Namespace($folderPath)

    # Create empty folder as root of organized directory.
    $rootFolderName = "Organized"
    $rootFolderPath = New-Item -Path $folderPath -Name $rootFolderName -ItemType Directory -Force

    # Traversal all files in folder that ready to be Organized.
    $counter = 0
    $shellFolder.Items() | ForEach-Object {
        if (!$_.IsFolder -and !$_.IsLink) {
            $_.Name # Print filename.
            $shellFile = $shellFolder.ParseName($_.Name)
    
            # Get file's created date as new subfolder name under root of organized directory: 
            # From "Taken Date", "Media Created" orderly.
            # If subfolder not exist, create new one, then copy file into it.
            $folderName = Get-OrganizedSubfolderName -Shellfolder $shellfolder -Shellfile $shellFile
            $destFolderPath = New-Item -Path $rootFolderPath -Name $folderName -ItemType Directory -Force
            Copy-Item $_.Path -Destination $destFolderPath

            $counter++
        }
    }
    "---TOTAL: {0}---" -f $counter  # Print total files been organized.
}

# Print all non-empty metadatas by GetDetailsOf() from file or folder.
# Usage:
#   Show-FileMetadata "[path_to_folder|path_to_file]"
function Show-Metadata($Path) {
    $Path = (Resolve-Path $Path).Path   # Fullpath.
    $shell = New-Object -COMObject Shell.Application
    $folder = Split-Path $Path
    $file = Split-Path $Path -Leaf
    $shellFolder = $shell.Namespace($folder)
    $shellFile = $shellFolder.ParseName($file)

    # GetDetailsOf(FolderItem, Integer)
    0..[int16]::MaxValue | Where-Object { $shellFolder.GetDetailsOf($shellFile, $_) } | Foreach-Object { 
        '{0} - {1} : {2}' -f $_, 
        $shellFolder.GetDetailsOf($null, $_), 
        $shellFolder.GetDetailsOf($shellFile, $_)
    }
}

function Get-OrganizedSubfolderName($ShellFolder, $ShellFile) {
    $date = Get-DateMediaCreated -ShellFolder $ShellFolder -ShellFile $ShellFile
    if (![string]::IsNullOrEmpty($date)) {
        return Get-FormatDate -Date $date
    }
    
    $date = Get-DateTaken -ShellFolder $ShellFolder -ShellFile $ShellFile
    if (![string]::IsNullOrEmpty($date)) {
        return Get-FormatDate -Date $date
    }
}

function Get-DateMediaCreated($ShellFolder, $ShellFile) {
    return Get-DetailsOfDate -ShellFolder $ShellFolder -ShellFile $ShellFile -Key 208  # Key of Media Created
}

function Get-DateTaken($ShellFolder, $ShellFile) {
    return Get-DetailsOfDate -ShellFolder $ShellFolder -ShellFile $ShellFile -Key 12   # Key of Date Taken
}

function Get-DetailsOfDate($ShellFolder, $ShellFile, $Key) {
    $date = $ShellFolder.GetDetailsOf($ShellFile, $Key)
    return ($date -replace [char]8206) -replace [char]8207  # Fix date format parsing error.
}

# Date format.
$ClassifiedFolderNameFormat = "yyyy.MM.dd"
function Get-FormatDate($Date) {
    return [datetime]::ParseExact($Date, "g", $null).ToString($ClassifiedFolderNameFormat)
}