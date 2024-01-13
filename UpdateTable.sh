#!/bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

function checkColumnName {

    local columnflag=0

    while [ $columnflag -eq 0 ];do

     if [[ $1 == *['!''?'@\#\$%^\&*()-+\.\/';']* ]]
    then
    echo "column name can not contain any special character"
    read -p "please enter a valid column name: " columnname
    
    elif [[ $1 == *" "* ]] 
    then
    echo "column name can not contain spaces"
    read -p "please enter a valid column name: " columnname
    elif [[ $1 =~ ^[0-9] ]]  
    then
    echo "column name can not begin with numbers"
    read -p "please enter a valid column name: " columnname
    
    else
    columnflag=1
    fi
done

}

echo "********************************"
echo "..Here You Can Update Tables.."
echo "********************************"
echo "Tables in the $dbname database:"
ls ./databases/$dbname/

update_choice=0
# Get the user's choice of whether to update the data or metadata or return back.
while [[ $update_choice != "q" ]]; do
# Ask the user if they want to update the table data or metadata
echo "Do you want to update a specific record (r) or the metadata (m) of the table? (r/m): or type 'q' to return back.."
read update_choice
# Check if the user input is one of these data, metadata, or q
if [[ $update_choice != "r" && $update_choice != "m" && $update_choice != "q" ]]; then
echo "Sorry, Invalid choice. Please enter 'r', 'm', or 'q'."
continue
fi

while true; do
# Update table data
# Ask the user which table they want to update
echo "Which table do you want to update?"
ls ./databases/$dbname/
echo "============================"
read tablename

# Check if the table_choice variable is empty
if [[ -z $tablename ]]; then
  echo "Please enter a table name."
  continue
fi

# Check if the table_choice variable is a valid table name
if [[ ! -f ./databases/$dbname/$tablename ]]; then
  echo "The table $tablename does not exist."

  # Ask the user to try again or type 'q' to return back
  read -p "Do you want to try again (y/q)? " choice

  # If the user chooses to try again, loop back to the beginning of the while loop
  if [[ $choice == "y" ]]; then
    continue
  # If the user chooses to return back, exit the script
  elif [[ $choice == "q" ]]; then
    exit 0
  fi
  else
    # Table exists, break out of the inner while loop
  break
  fi
done

  # If the user chooses to update the data, get the record and column they want to update.
  if [[ $update_choice == "r" ]]; then
  # Get the PK column name from the metadata file
  pk_column=$(sed -n '1p' ./databases/$dbname/$tablename-metadata | cut -d ':' -f 2)
  # Ask the user which record they want to update? (specify by PK)
  echo "Which record do you want to update? (specify by pk)"
  read pk_choice

  # Ask the user which column they want to update
  echo "Which column do you want to update? (specify by column number)"
  read col_choice
  # Check if the col_choice is a number
    if [[ ! $col_choice -ge 1 && $col_choice -le $(wc -l < ./databases/$dbname/$tablename) ]]; then
       echo "The column number $col_choice is invalid."
       continue
    fi

    # Ask the user for the new data
    echo "What is the new data you want to enter?"
    read new_data

    # Replace the old data with the new data
    sed -i "/^$pk_choice:/s/[^:]*\(:\|$\)/$new_data\1/$col_choice" ./databases/$dbname/$tablename
    echo "the data has been successfully updated :)"
  
# If the user chooses to update the metadata..
elif [[ $update_choice == "m" ]]; then
    # Update table metadata
    # Ask the user if they want to change the PK, change a datatype, or add a new column
    echo "Do you want to change the PK, change a datatype, or add a new column? (pk/dt/col)"
    read metadata_choice

# Check if the metadata change is valid
if [[ $metadata_choice != "pk" && $metadata_choice != "dt" && $metadata_choice != "col" ]]; then
  echo "Sorry, Invalid choice. Please enter 'pk', 'dt', or 'col'."
  continue
fi

# Check if the metadata choice is "pk"
if [[ $metadata_choice == "pk" ]]; then
    # Get the current PK name
    current_pk_name=$(awk -F ':' '$3 == "yes" {print $1}' "./databases/$dbname/$tablename-metadata")

    # Display the current PK to the user
    echo "The current primary key of this table is: $current_pk_name"

    # Ask the user if they want to change the PK
    echo "Do you want to change the primary key? (y/n)"
    read change_pk_choice

    # Check if the user wants to change the PK
    if [[ $change_pk_choice == "y" ]]; then
        # Display the column names to the user
        column_names=$(cut -d ':' -f 1 "./databases/$dbname/$tablename-metadata")
        echo "The available columns are: $column_names"

        # Ask the user for the new PK column
        echo "Please enter the name of the column you want to set as the new primary key:"
        read new_pk_column

        # Check if the new PK column is valid
        if ! echo "$column_names" | grep -q -w "$new_pk_column"; then
            echo "Invalid column name. Please enter a valid column name."
            exit 1
        fi

        # Update the PK column in the metadata file
        sed -i "s/^$current_pk_name:int:yes/$current_pk_name:int:no/" "./databases/$dbname/$tablename-metadata"
        sed -i "s/^$new_pk_column:int:no/$new_pk_column:int:yes/" "./databases/$dbname/$tablename-metadata"
        echo "The primary key has been successfully updated. The new primary key column is: $new_pk_column"
    else
        echo "No changes were made to the primary key."
    fi
fi

# Change the datatype
if [[ $metadata_choice == "dt" ]]; then
# Read the column names from the metadata file
column_names=$(cut -d ':' -f 1 "./databases/$dbname/$tablename-metadata")

# Display the available columns to the user
echo "These are the columns of the table: "
echo "$column_names"
echo "Which column do you want to change the datatype of?"
read col_choice

# Check if the column name is valid
if ! echo "$column_names" | grep -q -w "$col_choice"; then
    echo "Invalid column name. Please enter a valid column name."
    exit 1
fi

# Get the current datatype of the column
current_datatype=$(grep -w "^$col_choice:" "./databases/$dbname/$tablename-metadata" | cut -d ':' -f 2)

# Ask the user for the new datatype
# echo "The current datatype of column $col_choice is $current_datatype"
echo "What datatype do you want to change it to? (Enter 'int' or 'str')"
read new_datatype

# Check if the input is valid
while [[ $new_datatype != "int" && $new_datatype != "str" ]]; do
    echo "Invalid datatype. Please enter either 'int' or 'str'."
    read new_datatype
done

# Update the datatype in the metadata file
awk -v col="$col_choice" -v new_datatype="$new_datatype" 'BEGIN{FS=OFS=":"} $1 == col {$2 = new_datatype} 1' "./databases/$dbname/$tablename-metadata" > "./databases/$dbname/$tablename-metadata.tmp"
mv "./databases/$dbname/$tablename-metadata.tmp" "./databases/$dbname/$tablename-metadata"

echo "The datatype of column $col_choice has been successfully updated to $new_datatype."
fi

# Add a new column
if [[ $metadata_choice == "col" ]]; then
# Ask the user to enter the new column's data type
read -p "Please enter the new column's name: " newname
checkColumnName $newname 
echo -n $newname":"  >>  ./databases/$dbname/$tablename-metadata

echo "Please enter the new column's data type (int or str):"
read new_data_type

# Check that the new data type is either int or string
if [[ $new_data_type != "int" && $new_data_type != "str" ]]; then
  echo "Sorry, The new data type must be either int or string."
  exit 1
fi

# Add the new data type to the end of the metadata file
echo -n $new_data_type":"  >> ./databases/$dbname/$tablename-metadata
echo  "no"  >> ./databases/$dbname/$tablename-metadata

# Inform the user that the tablename-metadata file has been updated successfully
echo "A new column has been created successfully in the $tablename."
fi
else
  echo "Invalid choice. Please enter 'data', 'metadata', or 'q' to return back."
fi
done