# Linux-Scripts
Scripts to use in Linux to automate some system functions.

## UserCreationAndGroups.sh
Script takes a csv file with users and groups. It creates the users and adds them to the already existing groups.
### Expected CSV Format
username, groups
alice, "sudo,developers"
bob,"developers"
charlie,"docker,qa"
