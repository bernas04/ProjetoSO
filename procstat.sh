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
        
        cd /proc
        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ $opcao=="-c" ];then
            if [ -d "/proc/$i" ]; then
                cd /proc/$i
                cat comm | grep $string               #$(cat comm | grep $string)
            fi
        fi
        done

        sleep $segundos
        cd ..

        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ $opcao=="-c" ];then
            if [ -d "/proc/$i" ]; then
                cd /proc/$i
                cat comm | grep $string
                cat status | grep VmSize
                cat status | grep VmRSS
                if [ -r io ]; then
                    cat io | grep rchar
                    cat io | grep wchar
                fi
                echo -e "\n"
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
        #echo $segundos
        cd /proc
        
        
        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$i" ]; then
            cd /proc/$i
            if [ -r io ]; then
                rchar_Inicial=$(cat io | grep rchar | grep -o -E '[0-9]+')
                wchar_Inicial=$(cat io | grep wchar | grep -o -E '[0-9]+')
            fi
        fi
        done
        
        sleep $segundos
        printf '%-30s %-10s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
        cd ..
        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$i" ]; then
            cd /proc/$i
            comm=$(cat comm)
            user=$(ls -ld | awk '{print $3}')
            data=$(ls -ld | awk '{print $6 " " $7 " " $8}')
            VmSize=$(cat status | grep VmSize | grep -o -E '[0-9]+')
            VmRSS=$(cat status | grep VmRSS | grep -o -E '[0-9]+')
            PID=$(cat status | grep ^Pid | grep -o -E '[0-9]+')
            if [ -r io ]; then
                rchar_Final=$(cat io | grep rchar | grep -o -E '[0-9]+')
                wchar_Final=$(cat io | grep wchar | grep -o -E '[0-9]+')
                Readb=$[ $rchar_Final-$rchar_Inicial ]
                Writeb=$[ $wchar_Final-$wchar_Inicial ]
                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial})/${segundos}")
                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial})/${segundos}")
            else
                Readb="---"
                Writeb="---"
                wchar_Taxa="---"
                rchar_Taxa="---"

            fi
            
            printf '%-30s %-10s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' $comm $user $PID cona cona $Readb $Writeb $rchar_Taxa $wchar_Taxa $data
            
        fi
        done

        

    ;;
esac