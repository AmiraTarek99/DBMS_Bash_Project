#! /bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

ShowAllDBFun(){
if [[ -z $(ls -F ./databases | grep / ) ]]; then         
   echo " Sorry, there is no databse found !!"   
   echo " ***********************************"      
   
else
   ls ./databases/
   # echo -e "\n"                                                      
fi
}

ShowSpecificDBFun() {
    while true; do
        read -p "Please enter the name of the database you want to display or type 'q' to return back: " user_input
                
        if [[ -z $user_input || $user_input == *" "* ]]; then
            echo "database name can not be empty or contain spaces."
            read -p "Please enter the name of the database you want to display or type 'q' to return back: " user_input
        fi
        
        if [[ $user_input == "q" ]]; then
            echo "Exiting..."
            ./DBMainMenu.sh
        fi
        
        if [[ -d "databases/$user_input" ]]; then
            ls "databases/$user_input"
            break
        else
            echo "Sorry, the database '$user_input' was not found."
        fi
    done
}

echo "********************************"
echo "..Here You Can List Databases.."
echo "********************************"
options=("show all databases" "show specefic database")
    select opt in "${options[@]}"
    do
    case $opt in
        "show all databases")
            ShowAllDBFun
            ./DBMainMenu.sh
            ;;
        "show specefic database")
            ShowSpecificDBFun
            . ./DBMainMenu.sh
            ;;
        *) echo "invalid option $REPLY, please try again" 
           echo "1) list all databases"
           echo "2) list specefic database" ;;
    esac
    done