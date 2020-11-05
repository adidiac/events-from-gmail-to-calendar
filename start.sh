#!/bin/bash

function printare_meniu()      {
    clear
    echo "Alegeti una din obtouni :"
    echo "1) Creaza fisierele locale"
    echo "2) Schimba path-ul emailurilor"
    echo "3) Schimba timer-ul emailurilor"
    echo "4) Arata indexul emailurilor"
    echo "5) Arata emailurile ........"
    echo "6) Vezi eventuri"
    echo "9) exit "
    gestionare_meniu
    }

function gestionare_meniu()     {

read -s -n1 -p "" nr

case $nr in 
1) create_local ;;
2) schimba_calea ;;
3) bash crontab.sh ;; 
4) index ;;
5) bash sortare.sh ;;
6) eventuri ;;
9) exit ;;
*) printare_meniu; 
esac
}

function create_local(){
    bash create_local.sh
    printare_meniu
}

function schimba_calea()   {
    clear
    head -n 1 $USER.cfg 
    echo -n "Inroduceti noua cale: "
    read path
    
    input="$USER.cfg"
    while IFS= read -r line
    do

    if [ "$(echo $line | egrep "Path:")" != ""  ]
    then
    echo "Parh:$path" >> ""$USER"_.cfg"
    else
    echo $line >> ""$USER"_.cfg"
    fi
    done < "$input"

    rm "$USER.cfg"
    mv ""$USER"_.cfg" "$USER.cfg"

    printare_meniu
}


function genereare_config()     {

if test -f "$USER.cfg"; then
    printare_meniu
else
    pip3 install --upgrade google-api-python-client google-auth-httplib2 google-auth-oauthlib > Error
    rm Error
    echo "Path:/home/$USER/Desktop/Emails" >> "$USER.cfg"
    echo "Timer:ora" >> "$USER.cfg"
    echo "Numar_eventuri:0" >> "$USER.cfg"
    python3 Start_Gmail_API.py "$USER.cfg"
    python3 Start_Calendar_API.py
    python3 Start_Sending_API.py
    printare_meniu
fi

}

function index()    {

    path=$(head -n 1 "$USER".cfg | grep -o "/.*$")
    clear
    find $path/ -type f > Index.txt
    cat "Index.txt"
    
    read -n1 -p "" a

    printare_meniu
}

function eventuri() {

    input="Lista_Eventuri.txt"
    
    cat "Lista_Eventuri.txt"

    declare -i nr
    echo -n "Numar event dorit:"    
    read nr 

    if [ "$nr" -eq 0 ]
    then
    printare_meniu
    else

    path_2=$(cat "Lista_Eventuri.txt" | egrep "^"$nr" " | egrep -o " .* " | sed 's/ //g') 
    adresa=$(echo "$path_2" | egrep -o "[0-9]{4}/.*@.*/" | egrep -o "/.*/")
    adresa="${adresa:1}"
    adresa="${adresa::-1}"

    printare_meniu_event

    fi
}


function printare_meniu_event() {
    clear
    echo "Selectati Raspunsul:"
    echo "1) Am sa ajung"
    echo "2) Nu o sa ajung"
    gestionare_meniu_event
}


function gestionare_meniu_event {
    
read  nr
my_email=$(tail -n 1 ""$USER".cfg")
case $nr in 
1) python3 sending_email.py  "$adresa" "$my_email" "$nr";;
2) python3 sending_email.py  "$adresa" "$my_email" "$nr" ;;
9) printare_meniu ;;
*) printare_meniu_event; 
esac
printare_meniu
}

genereare_config

