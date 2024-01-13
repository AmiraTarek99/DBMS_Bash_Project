#! /bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "********************************"
echo "..Here You Can Delete Databases.."
echo "********************************"
echo "These are databases: "
ls ./databases/

 read -p "please enter the database name: " dbname
 flag=0
  while [ $flag -eq 0 ];do
 
  if [[ -z $dbname || $dbname == *" "* ]]
  then
  echo "you must enter the database name"
  read -p "please enter the database name or type 'q' to return back: " dbname

  elif [[ -d ./databases/$dbname ]]
  then
  rm -r ./databases/$dbname
  echo "This database has benn deleted successfully"

  flag=1
  elif [[ $dbname == 'q' ]]
  then
    ./DBMainMenu.sh

  else
    echo "this database name is not exist"
    read -p "please enter the database name or type 'q' to return back: " dbname
  fi
  done
  
  . ./DBMainMenu.sh