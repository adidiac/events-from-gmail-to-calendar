#!/bin/bash

create_local_email() {
  
    data=$(head -n 3 Email.txt | tail -n 1 | egrep -o  "[0-9]{0,2} [a-zA-Z]{3} [0-4]{4}")
    ora=$(head -n 3 Email.txt | tail -n 1 | egrep -o " [0-9]{2}:[0-9]{2}:[0-9]{2} " | sed 's\ \*\g')
    Titlu=$(head -n 2 Email.txt |  tail -n 1 | egrep -o "^.+<" | sed 's/<//g')
    Email_Expeditor=$(head -n 2 Email.txt |  tail -n 1 | egrep -o  "<.+>" | sed 's/[<>]//g')
    Subiect=$(head -n 4 Email.txt |  tail -n 1)

    sed '2,4d' Email.txt > Email_.txt
    mv Email_.txt Email.txt

    sed -i "2i Data:$data" Email.txt
    sed -i "2i Ora:$ora" Email.txt
    sed -i "2i Expeditor:$Email_Expeditor" Email.txt
    sed -i "2i Titlu:$Titlu" Email.txt
    sed -i "2i Subiect:$Subiect" Email.txt

    echo ""$path" "$data"-"$ora"-"$Titlu"" >> /home/ciprian/Desktop/Cale.txt

    mkdir -p "$path/$(echo $data | sed 's/ /-/g')/$Email_Expeditor/" >> /home/ciprian/Desktop/Cale.txt log.txt
    mv -v Email.txt "$path/"$(echo "$data"| sed 's/ /-/g')"/$Email_Expeditor/"$(echo ""$Titlu"-"$ora".txt" | sed 's/ /-/g')"" >> log.txt
    
    unset data
    unset ora
    unset Titlu
    unset Email_Expeditor
    unset Subiect

}

create_local_emails() {

    clear 
    notify-send "Creere fisiere locale ..............."
    echo "Creere fisiere locale ..............."

    python3 gmail_api.py

    grep "\S" Mail-uri.txt > Mail.txt 
    
    path=$(head -n 1 "$LOGNAME".cfg | grep -o "/.*$")
    echo $LOGNAME >> /home/ciprian/Desktop/Cale.txt
    input="Mail.txt"
    while IFS= read -r line
    do

    if [ "$(echo $line | egrep "*new email*")" != ""  ]
    then
    create_local_email
    else
    echo $line >> Email.txt 
    fi
    done < "$input"

    find $path/ -type f > Index.txt

    clear
    echo "Fisierele locale au fost create"
    python3 search.py
    python3 calendar_api.py


    numar=$(cat Numar_eventuri.txt)
    rm Numar_eventuri.txt
    notify-send "Numar eventuri : "$numar""
    read -s -n1 -p "" a
}


create_local_emails 