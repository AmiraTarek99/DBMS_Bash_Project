#! /bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "********************************"
echo "..Here You Can Insert Into Tables.."
echo "********************************"

function checkIfRedundantData {
  numColumns=$(wc -l  < ./databases/$dbname/$tablename)
  echo $numColumns
  if [[ $numColumns > 0 ]]
   then
    for ((i=1; i<=numColumns; i++))
     do
        columndata=$(awk -v i="$i" number="$2" 'BEGIN {FS = ":"} NR == i {print $number}' ./databases/$dbname/$tablename)
         if [[ $columndata == $1 ]]
         then
          echo "true"
         else
         echo "false"

         fi
     done

   fi

}
tableflag=0
read -p "please enter the table name: " tablename
while [ $tableflag -eq 0 ]
do
  if [[ -z $tablename ]]
     then
      echo "you must enter the table name to insert data into it"
     read -p "please enter the table name: " tablename

    elif [[ -f ./databases/$dbname/$tablename ]]
     then
   
     num_records=$(wc -l < ./databases/$dbname/$tablename-metadata)
      #echo $num_records
      for ((i=1; i<=num_records; i++))
          do
   
         columnname=$(awk -v i="$i" 'BEGIN {FS = ":"} NR == i {print $1}' ./databases/$dbname/$tablename-metadata)
         #echo columnname= $columnname
         columnnumber=$(awk -v i="$i" 'BEGIN {FS = ":"} NR == i {print NR}' ./databases/$dbname/$tablename-metadata)
         #echo columnnumber= $columnnumber
         columnpknum=$(awk -v i="$i" -F ":" ' {if($3=="yes") print NR}' ./databases/$dbname/$tablename-metadata)
         #echo columnpknum= $columnpknum
         read -p "please enter the data of the $columnname column " data
         #check the datatype of the input data 
         datatypeflag=0
           while [ $datatypeflag -eq 0 ]
             do
    
             columndatatype=$(awk -v i="$i" 'BEGIN {FS = ":"} NR == i {print $2}' ./databases/$dbname/$tablename-metadata)
             #echo $columndatatype
             if [[ "$columndatatype" == "int" ]]
                 then
                    if [[ $data =~ ^[0-9]+$ ]]
                     then
                     isnumber=0
                     datatypeflag=1
                    else
                     isnumber=1
                     echo "please enter only numbers"
                     read -p "please enter valid data of the $columnname column: " data
                      echo  "-----------------------------------------------------------"
                    fi
                   # echo isnumber= $isnumber
                elif [[ "$columndatatype" == "str" ]] 
                  then
                        if [[ $data =~ ^[a-zA-Z]+$ ]]
                         then
                         isstring=0
                         #echo -n $data":"  >> ./databases/$dbname/$tablename
                         datatypeflag=1
                        else
                         isstring=1
                         echo "please enter only characters"
                         read -p "please enter valid data of the $columnname column: " data 
                          echo  "-----------------------------------------------------------"
                        fi
                        #echo isstring= $isstring
                fi
            done
    
         #check the primary key of the input data
         columnpk=$(awk -v i="$i" 'BEGIN {FS = ":"} NR == i {print $3}' ./databases/$dbname/$tablename-metadata)
         #echo $columnpk
         pkFlag=0
            while [ $pkFlag -eq 0 ]
             do
                if [[ $columnpk == "yes" ]] 
                 then
                    
                    #result=$(checkIfRedundantData "$REPLY" "$columnnumber")
                    if [[ -z $data ]]
                     then 
                     echo "This column is the primary key you must insert value"
                     read -p "please enter valid data of the $columnname column: " data
                     break
                    fi
                    
                    #echo $result
                 declare -i numColumns
                 numColumns=$(wc -l  <  ./databases/$dbname/$tablename)
                    
                    if [[ $numColumns -gt 0 ]]
                        then
                        #echo numColumns= $numColumns 
                        finalflag=0
                        found=0
                          columndata=()
                           columndata=$(awk -v number="$columnnumber" 'BEGIN {FS = ":"} {print $number }'  ./databases/$dbname/$tablename )
                           #echo columnid= $columndata
                           for item in ${columndata[@]}
                               do
                                found=0
                                if [[ "$item" == "$data" ]]
                                 then
                                  found=1
                                  break
                                fi
                            done 
                            if [[ $found -eq 1 ]]
                                then
                                 echo "This column is the primary key and it is a redundant data"
                                 read -p "please enter a uniqe data of the $columnname column: " data
                                 echo  "-----------------------------------------------------------"
                            else
                              if [[ "$isnumber" == "0" || "$isstring" == "0" ]]
                                 then
                                 echo -n $data":"  >>  ./databases/$dbname/$tablename
                                 pkFlag=1
                                fi
                            fi 

                       
                    else
                     echo "insert data"
                     echo -n $data":"  >> ./databases/$dbname/$tablename
                     pkFlag=1

                    fi 
                                    
                else
                 #echo insert data
                 echo -n $data":"  >> ./databases/$dbname/$tablename
                 pkFlag=1
                fi
            done

         
        done
        echo  >> ./databases/$dbname/$tablename
     tableflag=1

    else

     echo "This table name not exists"
     read -p "please enter an existing table name: " tablename  
    fi

done

. ./TablesMainMenu.sh