# Linux-Scripts
Scripts to use in Linux to automate some system functions.

## UserCreationAndGroups.sh
Script takes a csv file with users and groups. It creates the users and adds them to the already existing groups.
### Expected CSV Format
username, groups
alice, "sudo,developers"
bob,"developers"
charlie,"docker,qa"

## GetUserGroups.sh
Script takese a list of names and outputs their corresponding group memberships to a csv.
### Expected Input
alice
bob
charlie
### How To Run It
`./GetUserGroups.sh users.txt user_groups.csv`

## UninstallApps.sh
Script does the following:
- Reads a list of packages/apps from a file.
- Detects whether each item is installed.
- Uninstalls it using the correct package manager for the detected Linux distribution.
### Example package list
firefox
vlc
htop
docker

## InstalledApps.sh
- Detects the Linux distribution.
- Finds all installed packages.
- Outputs the results to a csv file.
    - CSV file has two columns: Package, Version.