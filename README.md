# media-organizer

Organize your photos and videos by date taken.

## Features

- Organize by date
- Independent directory
- Copy without delete

## Example

```text
./Unorganized
|-IMG_01.jpg  <-Date: 2020/01/01 12:00
|-IMG_02.jpg  <-Date: 2020/02/02 09:00
|-IMG_03.jpg  <-Date: 2020/02/02 18:00
|-VID_01.mp4  <-Date: 2020/01/01 12:00
|-VID_02.mp4  <-Date: 2020/03/03 06:00
```

After organized

```text
./Unorganized
|-Organized
|         |-2020.01.01
|         |          |-IMG_01.jpg
|         |          |-VID_01.mp4
|         |-2020.02.02
|         |          |-IMG_02.jpg
|         |          |-IMG_03.jpg
|         |-2020.03.03
|         |          |-VID_01.mp4
|
|-original files...
```

## Usage

Run
> `MediaOrganizer_Start.ps1`

*If you encounter ExecutionPolicy problem, please see:

<https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies#powershell-execution-policies>

## How it works

Get extra metadata by
`Folder.GetDetailsOf`

<https://docs.microsoft.com/en-us/windows/win32/shell/folder-getdetailsof>

```powershell
$ShellFolder    # Folder object
$ShellFile      # FolderItem object

# Photo: DateTaken
$ShellFolder.GetDetailsOf($ShellFile, 12)   # Key of DateTaken

# Video: MediaCreated
$ShellFolder.GetDetailsOf($ShellFile, 208)  # Key of MediaCreated
```

## Functions

`Start-Organize` [path_to_folder]

```powershell
Start-Organize ".\Unorganized"
```

`Show-Metadata` [path_to_folder|path_to_file]

```powershell
Show-Metadata ".\Unorganized"
Show-Metadata ".\Unorganized\IMG_01.jpg"
```
