#!/bin/bash
#Sistemas Operativos 2020/2021
#Todos os direitos reservados 
#João Bernardo Tavares Farias, nº98679
#Artur Correia Romão, nº98470
header=(COMM"\t\t"USER"\t\t"PID"\t\t"MEM"\t\t"RSS"\t\t"READB"\t\t"WRITEB"\t\t"RATER"\t\t"RATEW"\t\t"DATE)
#echo -e ${header[@]}


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
                cat comm | grep $string
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
        echo $segundos
        cd /proc
        
        
        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$i" ]; then
            cd /proc/$i
            cat comm
            cat status | grep VmSize
            cat status | grep VmRSS
            if [ -r io ]; then
                cat io | grep rchar
                cat io | grep wchar
            fi
            echo -e "\n"
        fi
        done
        
        sleep $segundos
        cd ..
        
        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$i" ]; then
            cd /proc/$i
            cat comm
            cat status | grep VmSize
            cat status | grep VmRSS
            if [ -r io ]; then
                cat io | grep rchar
                cat io | grep wchar
            fi
            echo -e "\n"
        fi
        done
    ;;
esac