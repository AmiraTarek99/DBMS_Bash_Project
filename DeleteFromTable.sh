#!/bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "********************************"
echo "..Here You Can Delete From Tables.."
echo "********************************"

# Function to display the delete from table menu
display_menu() {
    echo "Delete From Table Menu"
    echo "1. Delete Table Data"
    echo "2. Delete Specific Row"
    echo "3. Back to Table Main Menu"
}

# Function to delete table data
delete_table_data() {
    # Display list of tables
    echo "List of Tables:"
    echo "***************"
    ls ./databases/$dbname
    echo "***************"
 
    while true; do 
        read -p "Enter the name of the table you want to delete data from or type 'q' to go back: " table_name
        
        if [[ "$table_name" == 'q' ]]; then 
            ./DeleteFromTable.sh 
        elif [[ ! -f ./databases/$dbname/$table_name ]]; then 
            echo "Invalid table name. Please enter a valid table name or type'q' to go back."
            continue 
        fi 
        
        break 
    done 
    
    # Check if table is empty
    if [[ ! -s ./databases/$dbname/$table_name ]]; then
        echo "Sorry, the table is empty and there is no data to be deleted."
        ./DeleteFromTable.sh
    fi
    
    # Display table data
    echo "Table Data:"
    echo "*****************"
    cat ./databases/$dbname/$table_name
    echo -e "\n"
    echo "*****************"
    dfalg=0
    while [ $dfalg -eq 0 ]; do
    read -p "Are you sure you want to delete all data from this table? (y/n): " confirm
    if [[ "$confirm" == 'y' || "$confirm" == 'Y' ]]; then
        # Delete table data
        > ./databases/$dbname/$table_name
        echo "Table data deleted successfully."
        dfalg=1
    elif [[ "$confirm" == 'n' || "$confirm" == 'N' ]]; then
        ./DeleteFromTable.sh
    else
        echo "Invalid confirmation. Please enter a valid table name or type'q' to go back."
    fi
    done
}

# Function to delete a specific row from a table
delete_specific_row() {
    # Display list of tables
    echo "List of Tables:"
    echo "****************"
    ls ./databases/$dbname
    echo "****************"
    
    while true; do 
        read -p "Enter the name of the table you want to delete a row from or 'q' to go back: " table_name
        
        if [[ "$table_name" == 'q' ]]; then 
            return 
        elif [[ ! -f ./databases/$dbname/$table_name ]]; then 
            echo "Invalid table name. Please enter a valid table name or 'q' to go back."
            continue 
        fi 
        break 
    done 
    
    # Check if table is empty
    if [[ ! -s ./databases/$dbname/$table_name ]]; then
        echo "Sorry, the table is empty and there is no data to be deleted."
        return
    fi
    
    # Display table data and column names
    #column_names=$(head -n 1  ./databases/$dbname/$table_name )
    echo "*****************"
    echo "Column Names: $column_names"
    echo "================="
    echo "Table Data:"
    echo "*****************"
    cat ./databases/$dbname/$table_name | nl -s '. '
    echo "*****************************"

    while true; do 
        read -p "Enter the number of the row you want to delete or 'q' to go back: " row_number
        
        if [[ "$row_number" == 'q' ]]; then 
            return 
        elif [[ ! "$row_number" =~ ^[0-9]+$ ]]; then 
            echo "Invalid input. Please enter a valid row number or 'q' to go back."
            continue 
        fi 
        
        row_count=$(cat ./databases/$dbname/$table_name | wc -l)
        
        if [[ "$row_number" -lt 1 || "$row_number" -gt "$row_count" ]]; then 
            echo "Invalid row number. Please enter a valid row number or 'q' to go back."
            continue 
        fi  
        break 
    done 
    drflag=0
    while [ $drflag -eq 0 ]; do
    read -p "Are you sure you want to delete this row? (y/n): " confirm
    
    if [[ "$confirm" == 'y' || "$confirm" == 'Y' ]]; then
        sed -i "$((row_number))d" ./databases/$dbname/$table_name 
        echo "Row deleted successfully."
        drflag=1
    elif [[ "$confirm" == 'n' || "$confirm" == 'N' ]]; then
        ./DeleteFromTable.sh
    else
        echo "Invalid confirmation. Please enter a valid table name or type'q' to go back."
    fi
    done
}

# Display the menu and loop until the user goes back to the main menu
while true; do  
  display_menu  
  read -p "Enter your choice: " choice  
  case $choice in  
    1) delete_table_data ;;
    2) delete_specific_row ;;
    3) . ./TablesMainMenu.sh ;;
    *) echo "Invalid choice. Please try again.";;  
  esac  
done

