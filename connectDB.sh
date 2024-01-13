#! /bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "********************************"
echo "..Here You Can Connect to Databases.."
echo "********************************"
echo "These are databases: "
ls ./databases/

 flag=0
export dbname
  read -p "please enter the database name or type 'q' to return back: " dbname
  while [ $flag -eq 0 ]
  do
  if [[ $dbname == 'q' ]]
  then
    ./DBMainMenu.sh

  elif [[ -z $dbname ]]
  then
  echo "you must enter the database name to connect"
  read -p "please enter the database name or type 'q' to return back: " dbname

  elif [[ -d ./databases/$dbname ]]
  then
  flag=1
  . ./TablesMainMenu.sh
  cd ./databases/$dbname 
  else

    echo "this database name not exists"
    read -p "please enter the database name or type 'q' to return back: " dbname  
fi
done
cd ./Bash-Project-DBMS
./Bash-Project-DBMS/DBMainMenu.sh


