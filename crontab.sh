

function set_crontab()  {
    
    touch mycron
    touch mycron_
    crontab -l > mycron

    if [ "$(head -n 1 mycron | egrep -o "no crontab")" =  "" ]
    then

        input="mycron"
        while IFS= read -r line
        do

        if [ "$(echo "$line" | egrep -o "create_local.sh")" != "" ]
        then
        continue
        else
        echo "$line"
        echo "$line" >> mycron_ 
        fi
        done < "$input"
 
        if [[ "$1" != "none" ]]
        then
        echo "$1 cd .$(pwd | egrep -o  "/Desktop.*"); bash create_local.sh"  >> mycron_ 
        fi
    else
        echo "$1 env USER=$LOGNAME cd .$(pwd | egrep -o  "/Desktop.*") ;bash create_local.sh"  >> mycron_ 
    fi

    crontab mycron_

    rm mycron_
    rm mycron
}

function schimba_config()  {
        
    input="$USER.cfg"
    while IFS= read -r line
    do

    if [ "$(echo $line | egrep "Timer:")" != ""  ]
    then
        if [[ $1 = "* * * * *" ]] ; then
        echo "Timer:minut" >> ""$USER"_.cfg"
        elif [[ $1 = "0 * * * *" ]] ; then
        echo "Timer:ora" >> ""$USER"_.cfg"
        elif [[ $1 = "0 8 * * *" ]] ;then
        echo "Timer:zi" >> $USER"_.cfg"
        else 
        echo "Timer:none" >> $USER"_.cfg"
        fi

    else
    echo $line >> ""$USER"_.cfg"
    fi
    done < "$input"

    rm "$USER.cfg"
    mv ""$USER"_.cfg" "$USER.cfg"

    printare_meniu

}


function printare_meniu()   {
    clear

    head -n 2 $USER.cfg | tail -n 1
    echo ""

    echo "Alegeti una din obtouni :"
    echo "1) In fiecare minut"
    echo "2) o data pe ora"
    echo "3) o data pe zi"
    echo "4) niciodata"
    echo "9) exit "
    gestionare_meniu
}


function gestionare_meniu   {

    read -s -n1 -p "" nr
    case $nr in 
    1)  set_crontab "* * * * *"  
        schimba_config "* * * * *"
        ;;
    2)  set_crontab "0 * * * *"  
        schimba_config "0 * * * *" 
        ;;
    3)  set_crontab "0 8 * * *" 
        schimba_config "0 8 * * *" 
        ;;
    4)  set_crontab "none" 
        schimba_config "none"
        ;;
    9)  bash start.sh ;;
    *) printare_meniu; 
    esac
}

printare_meniu