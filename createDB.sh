#! /bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "********************************"
echo "..Here You Can Create Databases.."
echo "********************************"

export dbname
read -p "please enter the database name: " dbname
flag=0
#./checkname.sh $dbname
while [ $flag -eq 0 ];do

    if [[ $dbname == 'q' ]]
    then
    ./DBMainMenu.sh
   
    elif [[ $dbname == *['!''?'@\#\$%^\&*()-+\.\/';']* ]]
    then
    echo "database name can not contain any special character"
    read -p "please enter a valid database name or type 'q' to return back: " dbname
    
    elif [[ $dbname == *" "* ]] 
    then
    echo "database name can not contain spaces"
    read -p "please enter a valid database name or type 'q' to return back: " dbname
    
    elif [[ -z $dbname ]]
    then
    echo "database name can not be empty"
    read -p "please enter a valid database name or type 'q' to return back: " dbname

    elif [[ -d ./databases/$dbname ]]
    then
    echo "this name already exists"
    read -p "please enter a valid database name or type 'q' to return back: " dbname

    elif [[ $dbname =~ ^[0-9] ]]  
    then
    echo "database name can not begin with numbers"
    read -p "please enter a valid database name or type 'q' to return back: " dbname
       
    else
    flag=1
    mkdir ./databases/$dbname
    echo "This database has been created successfully.."
    fi

done  

. ./DBMainMenu.sh