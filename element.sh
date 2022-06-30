#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"


element=$1

elementDoNotExist() {
  echo "I could not find that element in the database."
}


elementNameExist() {
  atomicNumber=$nameCheck
  elementExist
}

elementExist() {
  elementNumber=$atomicNumber
  elementName=$($PSQL "SELECT name FROM elements WHERE atomic_number=$elementNumber")
  elementSymbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$elementNumber")
  elementType=$($PSQL "SELECT type FROM properties FULL JOIN types USING(type_id) WHERE atomic_number=$elementNumber")
  elementMass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$elementNumber")
  elementMeltingPoint=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$elementNumber")
  elementBoilingPoint=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$elementNumber")

  echo "The element with atomic number $elementNumber is $elementName ($elementSymbol). It's a $elementType, with a mass of $elementMass amu. $elementName has a melting point of $elementMeltingPoint celsius and a boiling point of $elementBoilingPoint celsius."
}


#element=$1

#get input parameter when running the srcipt
  if [[ -z $1 ]]; then
    echo "Please provide an element as an argument."
  else
    #check if input is a number
    if [[ $element =~ ^[0-9]+$ ]]; then
      #if input is a number
      #check if atomic_number exists
      atomicNumber=$($PSQL "SELECT atomic_number from elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number='$element'")
      if [[ -z $atomicNumber ]]; then
        #atomic number does not exist
        elementDoNotExist
      else
        #atomic number exists
        elementExist
      fi
    else
      #input is not a number
      #check if input name is an element
      nameCheck=$($PSQL "SELECT atomic_number FROM elements WHERE name='$element' OR symbol='$element'")
      if [[ -z $nameCheck ]]; then
        #input is not an element
        elementDoNotExist
      else
        #if input is an element
        elementNameExist
      fi
    fi
  fi
