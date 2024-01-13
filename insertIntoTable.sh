#! /bin/bash
function getcolDatatype {

columndatatype=$(awk -v i="$1" 'BEGIN {FS = ":"} NR == i {print $2}' ./databases/$dbname/$tablename-metadata)
 echo $columndatatype
}


function checkIfInt {

    if [[ $1 =~ ^[0-9]+$ ]]
     then
        isnumber=0  #true
        
    else
     isnumber=1  #false
     
    fi
    echo $isnumber

}


function checkIfString {
  
       if [[ $1 =~ ^[a-zA-Z]+$ ]]
        then
         isstring=0  #true
        else
         isstring=1  #false
        fi
      echo isstring= $isstring
  

}

function getpkcol {
num_records=$(wc -l < ./databases/$dbname/$tablename-metadata)
echo $num_records
for((i=1; i<=num_records; i++))
do
 #columnpkname=$(awk -v i="$i" -F ":" ' {if($3=="yes") print $1}' ./databases/$dbname/$tablename-metadata)
 columnpknum=$(awk -v i="$i" -F ":" ' {if($3=="yes") print NR}' ./databases/$dbname/$tablename-metadata)
done
echo $columnpknum
}

function checkIfpk {

    if [[ -z $1 ]]
      then
      echo you must enter the table name to insert data into it
      read -p "please enter the data of the $columnname column  " data
    else
       columndata=$(awk -v number="$columnpknum" 'BEGIN {FS = ":"} {print $number }'  ./out)
        echo $columndata
        found=0
        for item in $columndata
          do
            if [[ $item == $data ]]
             then
             found=1      #true                        
            else
             found=0     #false
            fi
        done 
        if [[ $found -eq 1 ]]
          then
          echo This column is the primary key and it is a redundant data
          read -p "please enter a uniqe data of the $columnname column " data
         found=0
        else
          key=0
        fi

    fi
 }


function displayColumnNames {

    echo  "----------------Display $1 table column names----------------------"
    awk 'BEGIN {FS = ":"} { print NR"- "$1}' ./databases/$dbname/$tablename-metadata
    echo  "-------------------------------------------------------------------"

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
     displayColumnNames $tablename
     #read -p "please enter the column number to insert value into " colnum
     num_records=$(wc -l < ./databases/$dbname/$tablename-metadata)
       for ((i=1; i<=num_records; i++))
       do
          columnname=$(awk -v i="$i" 'BEGIN {FS = ":"} NR == i {print $1}' ./databases/$dbname/$tablename-metadata)
         read -p "please enter the data of the $columnname column  " data
         
         datatypeflag=0
         pkFlag=0
          while [ $datatypeflag -eq  0 ]
              do
              result=$(getcolDatatype $i)
              #echo $result 
             if [[ "$result" == *int* ]]
                 then
                 intresult=$(checkIfInt $data)
                 #echo $intresult
                    if [[ $intresult -eq  0 ]]
                     then
                      integer=0   #true
                      #echo -n $data":"  >>  ./databases/$dbname/$tablename
                     datatypeflag=1
                    else
                     echo please enter only numbers
                     read -p "please enter valid data of the $columnname column  : " data 
                    fi
             
                elif [[ "$result" == *str* ]]
                 then
                 striresult=$(checkIfString $data)
                   if [[ $striresult -eq 0 ]]
                     then
                      string=0   #true
                      #echo -n $data":"  >>  ./databases/$dbname/$tablename
                      datatypeflag=1
                    else
                     echo please enter only caharacters
                     read -p "please enter valid data of the $columnname column  : " data 
                    fi
             
                fi
            done
            pkresult=$(getpkcol $data)
            if [[ "$i" == "$pkresult" ]]
             then
               while [ $pkflag -eq  0 ]
                  do
                    checkIfpk $data
                    if [[ $key -eq 0 && ( $string || $integer ) -eq 0]]
                     then
                     
                     else


                     fi

                done

            fi    



        done
        echo  >> ./databases/$dbname/$tablename



     tableflag=1
    else
     echo this table name is not exist
     read -p "please enter a valid table name " tablename
    fi
done

. ./TablesMainMenu.sh