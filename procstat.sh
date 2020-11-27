#!/bin/bash
#Sistemas Operativos 2020/2021
#Todos os direitos reservados 
#João Bernardo Tavares Farias, nº98679
#Artur Correia Romão, nº98470


case $# in
    0) 
        echo "Número de argumentos inválido"
    ;;
    2)
        echo "Michel"
    ;;

    3)
        segundos=$3
        string=$2
        modo=$1
        
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
            if [ "$(grep -c ^$2 comm)" -ge 1 ]; then
                if [ -r io ]; then
                    rchar_Inicial[$i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                    wchar_Inicial[$i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                fi
                i=$((i+1))
            fi
        fi
        done
        echo $rchar_Inicial
        echo $wchar_Inicial
        sleep $segundos
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
        cd ..
        i=0
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
                    Readb=0
                    Writeb=0
                    wchar_Taxa=0
                    rchar_Taxa=0
                fi
                if [[ $Readb != 0  ]] || [[ $Writeb != 0 ]] || [[ $wchar_Taxa != 0 ]] || [[ $rchar_Taxa != 0 ]]; then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' $comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data
                fi
            fi  
        fi
        done
    ;;

    4)
        echo "Estou no 4"
    ;;

    5)
        echo "Estou no 5"
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
        echo $rchar_Inicial
        echo $wchar_Inicial
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