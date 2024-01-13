#! /bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

function selectmenu {
echo   "********* Select Menu **********"  
PS3='Please enter your choice: '
options=("select all columns" "select specific columns" "select a specific row" "return to table menu")
select opt in "${options[@]}"
do
    case $opt in
    "select all columns")
        selectAll $tablename
        selectmenu
        ;;
        "select specific columns")
         selectColumn $tablename
         selectmenu
        ;;
        "select a specific row")
         selectByColumn $tablename
         selectmenu
        ;;
        "return to table menu")
        . ./TablesMainMenu.sh
        ;;
        *) echo "Invalid option $REPLY"
        ;;
    esac
done

}
function selectAll {

 echo  "--------------------Display table------------------------"
 awk -F: 'BEGIN {OFS="\t";} {print $0}' ./databases/$dbname/$tablename
 echo  "-----------------------------------------------------------"


}

function selectColumn {

  displayColumnNames
  read -p "please enter the column number you want to select " colnum
  colflag=0
  while [ $colflag -eq 0 ]
   do
     if [[ $colnum =~ ^[0-9]+$ ]]
         then
         echo  "--------------------Display column-------------------------"
         awk -v col="$colnum" 'BEGIN {FS = ":"} {print $col}' ./databases/$dbname/$tablename
         echo  "-----------------------------------------------------------"
         colflag=1
         else
         echo please enter only numbers
         read -p "please enter valid column number " colnum

        fi
   done
}
function selectByColumn {

displayColumnNames
read -p "please enter the column number " mycol
numflag=0
while [ $numflag -eq 0 ]
   do
     if [[ $mycol =~ ^[0-9]+$ ]]
         then

read -p "please enter the value of the column you want to select " value
echo 
PS3='Please enter the operator number: '
options=("==" ">" "<" ">=" "<=" "return to select menu")
echo "*********** The operators menu *************"

select opt in "${options[@]}"
do
    case $opt in
    "==")
        echo "------------Display needed row ------------"
        awk -v mycol="$mycol" -v value="$value" 'BEGIN {FS = ":"} { if( $mycol == value ) print  $0;}' ./databases/$dbname/$tablename
        echo  "----------------------------------------------------------"
        selectmenu
        ;;
        "<")
         echo "------------Display needed row ------------"
awk -v mycol="$mycol" -v value="$value" 'BEGIN {FS = ":"} { if( $mycol < value ) print $0;}' ./databases/$dbname/$tablename
echo  "----------------------------------------------------------"
         selectmenu
        ;;
        ">")
         echo "------------Display needed row ------------"
awk -v mycol="$mycol" -v value="$value" 'BEGIN {FS = ":"} { if( $mycol > value ) print $0;}' ./databases/$dbname/$tablename
echo  "----------------------------------------------------------"
         selectmenu
        ;;
        "<=")
         echo "------------Display needed row ------------" 
awk -v mycol="$mycol" -v value="$value" 'BEGIN {FS = ":"} { if( $mycol <= value ) print $0;}' ./databases/$dbname/$tablename
echo  "----------------------------------------------------------"
         selectmenu
        ;;
        ">=")
         cho "------------Display needed row ------------" 
awk -v mycol="$mycol" -v value="$value" 'BEGIN {FS = ":"} { if( $mycol >= value ) print $0;}' ./databases/$dbname/$tablename
echo  "----------------------------------------------------------"
         selectmenu
        ;;
        "return to select menu")
        selectmenu
        ;;
        *) echo "Invalid option $REPLY"
        ;;
    esac
done
numflag=1
else
     echo please enter only numbers
     read -p "please enter valid column number " mycol

 fi
done

}
function displayColumnNames {

    echo  "----------------Display column names----------------------"
    awk 'BEGIN {FS = ":"} { print NR"- "$1}' ./databases/$dbname/$tablename-metadata
    echo  "-----------------------------------------------------------"

}




tableflag=0
read -p "please enter the table name " tablename
while [ $tableflag -eq 0 ]
do
    if [[ -z $tablename ]]
     then
      echo you must enter the table name to insert data into it
     read -p "please enter the table name " tablename

    elif [[ -f ./databases/$dbname/$tablename ]]
     then
     selectmenu $tablename
     tableflag=1

    else
      echo This table name is not exist
      read -p "please enter a valid table name " tablename
    fi
done   