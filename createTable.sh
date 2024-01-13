#! /bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "********************************"
echo "..Here You Can Create Tables.."
echo "********************************"

flag=0
pkFlag=0
function checkColumnName {

    local columnflag=0

    while [ $columnflag -eq 0 ];do

     if [[ $columnname == *['!''?'@\#\$%^\&*()-+\.\/';']* ]]
    then
    echo "column name can not contain any special character"
    read -p "please enter a valid column name: " columnname
    
    elif [[ $columnname == *" "* ]] 
    then
    echo "column name can not contain spaces"
    read -p "please enter a valid column name: " columnname
    elif [[ $columnname =~ ^[0-9] ]]  
    then
    echo "column name can not begin with numbers"
    read -p "please enter a valid column name: " columnname
    
    else
    columnflag=1
    fi
done

}
function checkColumnExist {
      existflag=0
       while [ $existflag -eq 0 ];do
        exist= $( grep "$columnname" ./databases/$dbname/$tablename-metadata 2>> /dev/null) 
        echo $exit
         if [ -z "$exist" ]
         then
         existflag=1  
         else 
         echo "this column already exsits"
         read -p "Enter the column name: " columnname
         checkColumnName "$columnname" 
         fi
        done
}
read -p "please enter the table name: " tablename

while [ $flag -eq 0 ];do
   
    if [[ $tablename == *['!''?'@\#\$%^\&*()-+\.\/';']* ]]
    then
    echo "table name can not contain any special character"
    read -p "please enter a valid table name: " tablename
    
    elif [[ $tablename == *" "* ]] 
    then
    echo "table name can not contain spaces"
    read -p "please enter a valid table name: " tablename
    
    elif [[ -z $tablename ]]
    then
    echo "table name can not be empty"
    read -p "please enter a valid table name: " tablename

    elif [[ -f  ./databases/$dbname/$tablename ]]
    then
    echo "this name already exists"
    read -p "please enter a valid table name: " tablename

    elif [[ $tablename =~ ^[0-9] ]]  
    then
    echo "table name can not begin with numbers"
    read -p "please enter a valid table name: " tablename
    
    else
    flag=1
    fi
    done

    touch ./databases/$dbname/$tablename
    echo "The data file is created for this table"
    #. ./TablesMainMenu.sh

    numflag=0
while [ $numflag -eq 0 ];do
    read -p "Enter the number of columns in this table: " columns
    if [[ $columns =~ ^[0-9]+$ ]]; then
      for (( i = 1; i <= $columns; i++ )); do
         read -p "Enter the column name: " columnname 

      checkColumnExist "$columnname" 
        
      checkColumnName "$columnname" 
      echo -n $columnname":" >> ./databases/$dbname/$tablename-metadata
      datatypeflag=0
      read -p "Choose column's datatype String(s) Number(n): (s/n) " datatype
        while [ $datatypeflag -eq 0 ]; do
      
          if [[ "$datatype" == "n" ]]; then
             datatype="int";  echo -n $datatype":"  >> ./databases/$dbname/$tablename-metadata
             datatypeflag=1
        
            elif [[ "$datatype" == "s" ]]; then
             datatype="str";  echo -n $datatype":"  >> ./databases/$dbname/$tablename-metadata
             datatypeflag=1
            else
             echo "Wrong Choice"
             read -p "Choose column's datatype String(s) Number(n): (s/n) " datatype
        
            fi
        done

      if [[ $pkFlag -eq 0 ]]; then
            while [ true ]; do
                read -p "Is it Primary-Key (PK): (y/n)" pk
                case "$pk" in
                    "y" | "Y" ) 
                    pk="yes"
                    echo  $pk  >> ./databases/$dbname/$tablename-metadata
                    pkFlag=1;
                    break;;
                    "n" | "N" ) 
                    pk="no"
                    echo  $pk  >> ./databases/$dbname/$tablename-metadata
                    break;;
                    * ) echo "Invalid option $REPLY";;
                esac
            done
        else
         pk="no"
         echo  $pk  >> ./databases/$dbname/$tablename-metadata
        fi
    
    done
      numflag=1
      else
       echo "It is not a number "
       read -p "Enter the number of columns in this table: " columns

     fi

done 
 . ./TablesMainMenu.sh
