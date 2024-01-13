#! /bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

dbflag=0
while [ $dbflag -eq 0 ]
do
    if [[ -d  ./databases ]] 
     then
     dbflag=1
    else
     mkdir ./databases
    fi
done

echo "*************************************"
echo "Welcome to Our DataBase Main Menu :)"
echo "*************************************"
PS3='Please enter your choice: '

options=("Show Databases" "Connect Database" "Create New Database" "Delete Database" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Show Databases") 
        . ./showDBs.sh
        ;;
        "Connect Database") 
        . ./connectDB.sh
        ;;
        "Create New Database")
        . ./createDB.sh 
        ;;
        "Delete Database") 
        . ./deleteDB.sh
        ;;
        "Quit") exit
        ;;
        *) echo "Invalid option $REPLY"
        ;;
    esac
done
