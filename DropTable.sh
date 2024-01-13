#!/bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "********************************"
echo "..Here You Can Drop Tables.."
echo "********************************"

# Define a function to display the menu options
display_menu () {
  echo "Please choose one of the following options:"
  echo "1) Drop a table from the database"
  echo "2) Back to the menu"
}

# Define a function to drop a table from the database
drop_table () {
  # Check if the databases folder exists
  if [[ ! -d ./databases/ ]]; then
    echo "The databases folder does not exist."
    return
  fi

  # Check if there are any databases
  if [[ -z ./databases/$dbname ]]; then
    echo "There are no databases in the folder."
    return
  fi

  while true; do
    # Check if the database name is valid
    if [[ ! -d ./databases/$dbname ]]; then
      echo "Invalid database name. Please try again."
    else
      break
    fi
  done  

  # Check if there are any tables
  if [[ -z ./databases/$dbname/$tablename ]]; then
    echo "There are no tables in the database."
    return
  fi
  # Display the list of tables and ask the user to choose one
  echo "The tables in the database are:"
  ls ./databases/$dbname/$tablename
  # Loop until the user enters a valid table name or 'q' to go back
  while true; do
    read -p "Enter the name of the table you want to drop or 'q' to go back: " tbl_name
    # Check if the user wants to go back
    if [[ "$tbl_name" = "q" || "$tbl_name" = "Q" ]]; then
      return
    fi  
    # Check if the table name is valid
    if [[ ! -f ./databases/$dbname/$tbl_name ]]; then
      echo "Invalid table name. Please try again."
    else
      break
    fi  
  done  
  # Ask for confirmation before dropping the table
  read -p "Are you sure you want to delete the table $tbl_name? (y/n) " confirm
  # Check if the user confirmed
  if [[ "$confirm" = "y" || "$confirm" = "Y" ]]; then
    # Drop the table from the database by deleting the file
    rm  ./databases/$dbname/$tbl_name
    rm  ./databases/$dbname/$tbl_name-metadata

    echo "The table $tbl_name has been deleted from the database."
  else
    echo "The table $tbl_name has not been deleted from the database."
  fi  
}

# Display the menu and loop until the user goes back to the main menu
while true; do  
  display_menu  
  read -p "Enter your choice: " choice  
  case $choice in  
    1) drop_table ;;  
    2) bash ./TablesMainMenu.sh ;;  
    *) echo "Invalid choice." ;;  
  esac  
done  

