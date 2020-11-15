#!/bin/bash
#Sistemas Operativos 2020/2021
#Todos os direitos reservados 
#João Bernardo Tavares Farias, nº98679
#Artur Correia Romão, n...



case $# in
    0) 
        echo "Número de argumentos inválido"
    ;;
    2)
        echo "Estou no 2"
       
            
            
        cd /proc
        for i in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$i" ]; then
            cd /proc/$i
            cat comm
            cat status | grep VmSize
            cat status | grep VmRSS
            #chmod 755 io
            if [ -r io ]; then
                cat io | grep rchar
                cat io | grep wchar
            else 
                continue
            fi
            echo -e "\n"

        else
            continue
        fi
        done
    ;;

    3)
        echo "Estou no 3"

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
        echo "Estou no default"
    ;;
esac