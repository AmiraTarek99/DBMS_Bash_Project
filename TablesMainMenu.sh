#!/bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "*************************************"
echo "Welcome to Our Tables Main Menu :)"
echo "*************************************"

PS3='Please enter your choice: '
options=("Create Table" "List Table" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update Table" "Go back to database main menu" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create Table")
            . ./createTable.sh
        ;;
        "List Table")
            . ./ListTable.sh
        ;;
        "Drop Table")
            . ./DropTable.sh
        ;;
        "Insert into Table")
            . ./insertTable.sh
        ;;
	    "Select from Table")
	        . ./selectFromTable.sh
	    ;;
        "Delete from Table")
	        . ./DeleteFromTable.sh
	    ;;
	    "Update Table")
            . ./UpdateTable.sh
	    ;;
        "Go back to database main menu")
        ./DBMainMenu.sh
        ;;
        "Quit") exit
        ;;
        *) echo "Invalid option $REPLY"
        ;;
    esac
done