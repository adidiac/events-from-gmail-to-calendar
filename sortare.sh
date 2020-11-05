#!/bin/bash

function printare_meniu()      {
    clear
    echo "Alegeti una din obtouni :"
    echo "1) Dintr-o data"
    echo "2) De la o adresa de email"
    echo "3) Dintr-o categorie"
    echo "9) exit "
    gestionare_meniu
    }



function vizualizare_categorii()    {
    clear
    echo "Exemplu : UNREAD, UPDATES, INBOX"
    echo -n "Categorie:"
    read categorie

    input="Index.txt"
    while IFS= read -r line
    do
    if [ "$(head -n 1 "$line" | egrep -n "$categorie")" != ""  ]
    then
        echo "$line"
    fi
    done < "$input"

    echo "*Final*"
    read -n1 -p "" a
    printare_meniu

}

function vizualizare_email()    {
    clear

    echo "Exemplu : contact@bestjobs.eu"
    echo -n "Email:"
    read email

    input="Index.txt"
    while IFS= read -r line
    do
    if [ "$(head -n 4 "$line" | tail -n 1 | egrep -n "$email")" != ""  ]
    then
        echo "$line"
    fi
    done < "$input"

    echo "*Final*"
    read -n1 -p "" a
    printare_meniu
}

function vizualizare_data() {
    clear
    echo "Exemplu : 20-Oct-2020"
    echo -n "Scrieti data in format dd-mm-yyyy:"
    read data

    path=$(head -n 1 "$USER".cfg | grep -o "/.*$")


    if test -d ""$path"/"$data"/"; then
    find "$path"/"$data"/ -type f
    else
    echo "Nu exista emailuri din ziua respectiva" 
    fi

    read -n1 -p "" a
    printare_meniu
}

function gestionare_meniu()     {

read -s -n1 -p "" nr
case $nr in 
1) vizualizare_data ;;
2) vizualizare_email ;;
3) vizualizare_categorii ;;
9) bash start.sh ;;
*) printare_meniu; 
esac
}


printare_meniu