#!/bin/bash
#Sistemas Operativos 2020/2021
#Todos os direitos reservados 
#7/12/2020
#João Bernardo Tavares Farias, nº986799
#Artur Correia Romão, nº98470


case $# in
    0) 
        echo "Número de argumentos inválido"
    ;;
    3)
        while getopts "cu" options; do
            case $options in 
            c)
                segundos=$3
                if (( $segundos == 0 )); then
                    echo "O número de segundos dedve ser maior que 0"
                    exit 1
                fi
                
                string=$2
                cd /proc
                i=0;
                for i in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$i" ]; then
                    cd /proc/$i
                    if [ "$(grep -c ^$2 comm)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[$i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[$i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                        fi
                        i=$((i+1))
                    fi
                fi
                done
                sleep $segundos
                cd ..
                i=0
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                for i in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$i" ]; then
                        cd /proc/$i
                        if [ "$(grep -c ^$2 comm)" -ge 1 ]; then
                            comm=$(cat comm)
                            user=$(ls -ld | awk '{print $3}')
                            data=$(ls -ld | awk '{print $6 " " $7 " " $8}')
                            PID=$(cat status | grep ^Pid | grep -o -E '[0-9]+')
                            
                            if [ "$(grep -c "VmRSS" status)" -ge 1 ]; then   
                                VmSize=$(cat status | grep VmSize | grep -o -E '[0-9]+')
                                VmRSS=$(cat status | grep VmRSS | grep -o -E '[0-9]+')
                            fi
                            if [ -r io ]; then
                                rchar_Final=$(cat io | grep rchar | grep -o -E '[0-9]+')
                                wchar_Final=$(cat io | grep wchar | grep -o -E '[0-9]+')
                                Readb=$(($rchar_Final-${rchar_Inicial[$i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[$i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[$i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[$i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' $comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data
                            fi
                        fi  
                    fi
                done
            ;;
            
            u) 
                segundos=$3
                if (( $segundos == 0 )); then
                    echo "O número de segundos dedve ser maior que 0"
                    exit 1
                fi
                user=$2
                cd /proc
                i=0;
                for i in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$i" ]; then
                    cd /proc/$i
                    if [ "$(ls -ld | grep -c $2)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[$i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[$i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                        fi
                        i=$((i+1))
                    fi
                fi
                done
                sleep $segundos
                cd ..
                i=0
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                for i in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$i" ]; then
                        cd /proc/$i
                        if [ "$(ls -ld | grep -c $2)" -ge 1 ]; then
                            comm=$(cat comm)
                            user=$(ls -ld | awk '{print $3}')
                            data=$(ls -ld | awk '{print $6 " " $7 " " $8}')
                            PID=$(cat status | grep ^Pid | grep -o -E '[0-9]+')
                            
                            if [ "$(grep -c "VmRSS" status)" -ge 1 ]; then   
                                VmSize=$(cat status | grep VmSize | grep -o -E '[0-9]+')
                                VmRSS=$(cat status | grep VmRSS | grep -o -E '[0-9]+')
                            else 
                                VmSize="---"
                                VmRSS="---"
                            fi
                            if [ -r io ]; then
                                rchar_Final=$(cat io | grep rchar | grep -o -E '[0-9]+')
                                wchar_Final=$(cat io | grep wchar | grep -o -E '[0-9]+')
                                Readb=$(($rchar_Final-${rchar_Inicial[$i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[$i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[$i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[$i]})/${segundos}")
                                i=$((i+1))
                            else
                                rchar_Final="---" 
                                wchar_Final="---" 
                                Readb="---"
                                Writeb="---"
                                wchar_Taxa="---"
                                rchar_Taxa="---"
                            fi
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' $comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data
                            
                        fi  
                    fi
                done
            ;;
            esac
        done
    
    ;;

    4)
        while getopts "se" options; do
            case $options in
            s|e) 
                echo $# $1 $2 $3 $4
                ;;
            u)  echo "Estou no u"
                ;;
            esac
        done

    ;;

    5)
    
        while getopts "se" options; do
            case $options in
            s|e) 
                segundos=$5
                start=$(date -d "$2" +%s);
                end=$(date -d "$4" +%s);
                if ((start > end)) ; then
                    echo "A data final tem que ser posterior à data inicial!"
                    exit 1
                fi
                cd /proc
                for i in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$i" ]; then
                    cd /proc/$i
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$i | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                   
                    #LC_TIME=EN_us.UTF-8;
                    #data =$(date -d "$data" +%s)
                    
                    #if [ ... ]; then
                        #if [ -r io ]; then
                          #  rchar_Inicial[$i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                         #   wchar_Inicial[$i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                        #fi
                        #i=$((i+1))
                    #fi
                fi
                done
                

                ;;
            u)  echo "Estou no S"
                ;;
            esac
        done
    ;;

    7)
        echo "Estou no 7"
    ;;
    
    
    *)
        segundos=$1
        if (( $segundos == 0 )); then
            echo "O número de segundos dedve ser maior que 0"
            exit 1
        fi
        cd /proc
        
        i=0;
        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$i" ]; then
            cd /proc/$i
            if [ -r io ]; then
                rchar_Inicial[$i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                wchar_Inicial[$i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
            fi
            i=$((i+1))
        fi
        done
        sleep $segundos
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
        cd ..
        i=0
        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$i" ]; then
            cd /proc/$i
            comm=$(cat comm)
            user=$(ls -ld | awk '{print $3}')
            data=$(ls -ld | awk '{print $6 " " $7 " " $8}')
            PID=$(cat status | grep ^Pid | grep -o -E '[0-9]+')
            
            if [ "$(grep -c "VmRSS" status)" -ge 1 ]; then   
                VmSize=$(cat status | grep VmSize | grep -o -E '[0-9]+')
                VmRSS=$(cat status | grep VmRSS | grep -o -E '[0-9]+')
            fi
            if [ -r io ]; then
                rchar_Final=$(cat io | grep rchar | grep -o -E '[0-9]+')
                wchar_Final=$(cat io | grep wchar | grep -o -E '[0-9]+')
                Readb=$(($rchar_Final-${rchar_Inicial[$i]}))
                Writeb=$(($wchar_Final-${wchar_Inicial[$i]}))
                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[$i]})/${segundos}")
                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[$i]})/${segundos}")
                i=$((i+1))
            fi
            if [ -r io ]; then
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' $comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data
            fi  
        fi
        done
    ;;
esac