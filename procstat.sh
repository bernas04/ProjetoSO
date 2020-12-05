#!/bin/bash
#Sistemas Operativos 2020/2021
#Todos os direitos reservados
#7/12/2020
#João Bernardo Tavares Farias, nº98679
#Artur Correia Romão, nº98470


case $# in
    #Completamente feito
    1)
        segundos=$1
        if (( $segundos <= 0 )); then
            echo "O número de segundos dedve ser maior que 0"
            exit 1
        fi
        cd /proc
        
        i=0
        for proc in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$proc" ]; then
            cd /proc/$proc
            if [ -r io ]; then
                rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                i=$((i+1))
            fi
        fi
        done
        processosInicial=$i
        sleep $segundos
        cd ..
        i=0
        x=0
        for proc in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$proc" ]; then
            cd /proc/$proc
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
                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                i=$((i+1))
            fi
            if [ -r io ]; then
                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                x=$((x+1))
            fi  
        fi
        done
        processosFinal=$i
        if (($processosInicial == $processosFinal)); then
            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k1n
        else
            echo "Erro na leitura dos processos! Por favor tente novamente."
        fi
        
    ;;
    2)
        segundos=$2
        if (($segundos<=0)); then
            echo "Número de segundos deve ser maior que 0"
            exit 1
        fi
        cd /proc
        
        i=0
        for proc in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$proc" ]; then
            cd /proc/$proc
            if [ -r io ]; then
                rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                i=$((i+1))
            fi
        fi
        done
        processosInicial=$i
        sleep $segundos

        cd ..
        i=0
        x=0
        for proc in $(ls | grep -E '^[0-9]+$')
        do
        if [ -d "/proc/$proc" ]; then
            cd /proc/$proc
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
                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                i=$((i+1))
                fi
                if [ -r io ]; then
                    array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                    x=$((x+1))
                fi  
            fi
        done
        processosFinal=$i
        while getopts ":mtdw" options; do
            case $options in
                m)
                if (($processosFinal==$processosInicial)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4n
                else
                    echo "Erro na leitura! Por favor tente novamente"
                fi
                ;;
                t)
                if (($processosFinal==$processosInicial)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5n
                else
                    echo "Erro na leitura! Por favor tente novamente"
                fi
                ;;
                d)
                if (($processosFinal==$processosInicial)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8n
                else
                    echo "Erro na leitura! Por favor tente novamente"
                fi
                ;;
                w)
                if (($processosFinal==$processosInicial)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9n
                else
                    echo "Erro na leitura! Por favor tente novamente"
                fi
                ;;
                \?)
                    echo "Opção inválida"
                ;;
            esac
        done
    ;;
    3)
        while getopts ":c:u:mdtwrp:" options; do
            case $options in 
            p)
                numeroProcessos=$OPTARG
                segundos=$3
                if (($segundos<=0)); then
                    echo "Número de segundos deve ser maior que 0"
                    exit 1
                fi
                cd /proc
        
                i=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ -r io ]; then
                        rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                        wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                        i=$((i+1))
                    fi
                fi
                done
                sleep $segundos
                processosInicial=$i
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
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
                        Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                        Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                        wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                        rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                        i=$((i+1))
                    fi
                    if [ -r io ]; then
                        array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                        x=$((x+1))
                    fi  
                fi
                done
                processosFinal=$i
                n=0
                if (($processosFinal==$processosInicial));then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    while (($n<$numeroProcessos)); do
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[n]}
                        n=$((n+1))
                    done
                else    
                    echo "Erro de leitura! Por favor tente novamente"
                fi
            ;;
            m|t|d|w|r)
                    segundos=$3
                    if (($segundos<=0)); then
                        echo "Número de segundos deve ser maior que 0"
                        exit 1
                    fi
                    cd /proc
        
                    i=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                    done
                    sleep $segundos
                    processosInicial=$i
                    cd ..
                    i=0
                    x=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
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
                            Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                            Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                            wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                            rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                            i=$((i+1))
                        fi
                        if [ -r io ]; then
                            array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                            x=$((x+1))
                        fi  
                    fi
                    done
                    processosFinal=$i
                    case $1 in 
                    -m)
                        if (($processosFinal==$processosInicial));then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk4
                        else    
                            echo "Erro de leitura! Por favor tente novamente"
                        fi
                        exit 0
                    ;;
                    -t)
                        if (($processosFinal==$processosInicial));then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk5
                        else    
                            echo "Erro de leitura! Por favor tente novamente"
                        fi
                        exit 0
                    ;;
                    -d)
                        if (($processosFinal==$processosInicial));then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk8
                        else    
                            echo "Erro de leitura! Por favor tente novamente"
                        fi
                        exit 0
                    ;;
                    -w)
                    if (($processosFinal==$processosInicial));then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk9
                        else    
                            echo "Erro de leitura! Por favor tente novamente"
                        fi
                        exit 0
                    ;;
                    *)
                        echo "Modo incorreto de ordenação"
                        exit 1
                    ;;
                    esac
            ;;
            c)
                segundos=$3
                if (($segundos<=0)); then
                    echo "O número de segundos dedve ser maior que 0"
                    exit 1
                fi
                
                string=$OPTARG
                cd /proc
                i=0;
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ "$(grep -c ^$string comm)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi
                        fi  
                    fi
                done
                processosFinal=$i
                if (($processosInicial==$processosFinal)) && ((${#array[@]} != 0)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k1n
                else
                    echo "Não foi possível obter os processos começados com $string"
                fi
            ;;
            
            u) 
                segundos=$3
                if (($segundos <= 0)); then
                    echo "O número de segundos dedve ser maior que 0"
                    exit 1
                fi
                user=$OPTARG
                cd /proc
                i=0;
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi
                        fi  
                    fi
                done
                processosFinal=$i
                if ((${#array[@]} != 0)) && (($processosInicial==$processosFinal)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k1n
                else
                    echo "Utilizador sem processos associados ou erro na leitura. Por favor tente novamente"
                fi

            ;;
            \?) 
                echo "Opção inválida"
                ;;
            esac
        done
    
    ;;
    4) 
        
        while getopts ":mtdwc:p:u:" option; do 
            case $option in
                p) 
                    numeroProcessos=$OPTARG
                    if (($numeroProcessos<=0)); then
                        echo "Número incorreto de processos"
                    fi
                ;;
                c)
                    string=$OPTARG
                ;;
                m)
                    o="4"
                ;;
                t)
                    o="5"
                ;;
                d)
                    o="8"
                ;;
                w)
                    o="9"
                ;;
                u)
                    user=$OPTARG
                ;;
                \?)
                    echo "Opção inválida"
                    exit 1
                ;;
            esac
        done
        segundos=$4
        if (($segundos<=0)); then
            echo "Número de segundos deve ser maior que 0"
            exit 1
        fi
        
        if [[ -n $user ]]; then
                cd /proc
                i=0;
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi
                        fi  
                    fi
                done
                processosFinal=$i
            if (($processosInicial==$processosFinal)) && ((${#array[@]}!=0)); then
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                if (($o=="4")); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4n
                elif (($o=="5")); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5n
                elif (($o=="8")); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8n
                elif (($o=="9")); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9n
                else
                    echo "Modo incorreto de ordenação"
                fi
            else
                echo "Utilizador sem processos associados"
            fi
            exit 0   
        fi     
        
        
        
        
        if [[ -n $string ]]; then
            cd /proc
            i=0;
            for proc in $(ls | grep -E '^[0-9]+$')
            do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                        if [ "$(grep -c ^$string comm)" -ge 1 ]; then
                            if [ -r io ]; then
                                rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                                wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                                i=$((i+1))
                            fi
                        fi
                fi
            done
            processosInicial=$i
            sleep $segundos
            cd ..
            i=0
            x=0
            for proc in $(ls | grep -E '^[0-9]+$')
            do
            if [ -d "/proc/$proc" ]; then
                cd /proc/$proc
                if [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                        Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                        Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                        wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                        rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                        i=$((i+1))
                    fi
                    if [ -r io ]; then
                        array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                        x=$((x+1))
                    fi
                fi  
            fi
        done
        processosFinal=$i
        if (($processosInicial==$processosFinal)); then
            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
            if (($o=="4")); then
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4n
            elif (($o=="5")); then
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5n
            elif (($o=="8")); then
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8n
            elif (($o=="9")); then
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9n
            else
                echo "Modo incorreto de ordenação"
            fi
            exit 0
        fi 
        fi
        
        
        if [[ -n $numeroProcessos ]]; then
                cd /proc
        
                i=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ -r io ]; then
                        rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                        wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                        i=$((i+1))
                    fi
                fi
                done
                sleep $segundos
                processosInicial=$i
                    cd ..
                    i=0
                    x=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
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
                            Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                            Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                            wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                            rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                            i=$((i+1))
                        fi
                        if [ -r io ]; then
                            array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                            x=$((x+1))
                        fi  
                    fi
                    done
                    if (($numeroProcessos>${#array[@]})); then
                        numeroProcessos=${#array[@]}
                        echo "Número de processos alterado"
                    fi
                    processosFinal=$i
                    if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        for ((t=0;t<$numeroProcessos;t++))
                        do
                        a[t]=${array[t]}
                        done
                        if (($o=="4")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]} | sort -k4n
                        elif (($o=="5")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]} | sort -k5n
                        elif (($o=="8")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]} | sort -k8n
                        elif (($o=="9")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]} | sort -k9n
                        else 
                            echo "Modo incorreto de ordenação"
                        fi
                    fi
        fi

    ;;
    5) 
        segundos=$5
        if (($segundos<=0)); then
            echo "Número incorreto de segundos"
        fi
        
        while getopts ":s:e:twdmrc:u:p:" options; do
            case $options in
            u)
                user=$OPTARG
            ;;
            p)
                numeroProcessos=$OPTARG
            ;;
            c)
                string=$OPTARG
            ;;
            s) 
                startDate=$OPTARG
            ;;
            e)
                endDate=$OPTARG
            ;;
            m)
                o="4"
            ;;
            r)
                r="r"
            ;;
            t)
                o="5"
            ;;
            d)
                o="8"
            ;;
            w)
                o="9"
            ;;
            \?)
                echo "Opção inválida"
            ;;
            esac
        done
        
        if [[ -n $startDate ]] && [[ -n $endDate ]]; then
                start=$(date -d "$startDate" +%s);
                end=$(date -d "$endDate" +%s);
                i=0
                cd /proc
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
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
                            Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                            Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                            wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                            rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                            i=$((i+1))
                        fi
                        if [ -r io ]; then
                            array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                            x=$((x+1))
                        fi  
                    fi
                fi
                done
                processosFinal=$i
                if (($processosFinal==$processosInicial)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k1n
                    exit 0
                else
                    echo "Erro na leitura! Por favor tente novamente"
                fi
        
        elif [[ -n $string ]] && [[ -z $numeroProcessos ]] && [[ -n $o ]]; then
            cd /proc
            i=0
            for proc in $(ls | grep -E '^[0-9]+$')
            do
            if [ -d "/proc/$proc" ]; then
                cd /proc/$proc
                if [ "$(grep -c ^$string comm)" -ge 1 ]; then
                    if [ -r io ]; then
                        rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                        wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                        i=$((i+1))
                    fi
                fi
            fi
            done
            processosInicial=$i
                    sleep $segundos
                    cd ..
                    i=0
                    x=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                        if [ -d "/proc/$proc" ]; then
                            cd /proc/$proc
                            if [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                                    Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                    Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                    wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                    rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                    i=$((i+1))
                                fi
                                if [ -r io ]; then
                                    array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                    x=$((x+1))
                                fi
                            fi  
                        fi
                    done
                    processosFinal=$i
                    if (($processosInicial!=$processosFinal)); then
                        echo "Erro a ler os processos. Por favor tente novamente"
                        exit 1
                    fi
                    if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        if (($o=="4")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk4
                        elif (($o=="5")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk5
                        elif (($o=="8")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk8
                        elif (($o=="9")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk9
                        else 
                            echo "Modo incorreto de ordenação"
                        fi
                        exit 0
                    fi
            

        
        elif [[ -n $string ]] && [[ -n $numeroProcessos ]]; then
                    cd /proc
                    i=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(grep -c ^$string comm)" -ge 1 ]; then
                            if [ -r io ]; then
                                rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                                wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                                i=$((i+1))
                            fi
                        fi
                    fi
                    done
                    processosInicial=$i
                    sleep $segundos
                    cd ..
                    i=0
                    x=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                        if [ -d "/proc/$proc" ]; then
                            cd /proc/$proc
                            if [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                                    Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                    Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                    wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                    rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                    i=$((i+1))
                                fi
                                if [ -r io ]; then
                                    array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                    x=$((x+1))
                                fi
                            fi  
                        fi
                    done
                    processosFinal=$i
                    if (($processosInicial!=$processosFinal)); then
                        echo "Erro a ler os processos. Por favor tente novamente"
                        exit 1
                    fi
                    n=0
                    if (($numeroProcessos>${#array[@]})); then
                        echo "Número de processos a visualizar alterado"
                        numeroProcessos=${#array[@]}
                    fi
                    if (($processosFinal==$processosInicial)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    while (($n<$numeroProcessos)); do
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[n]}
                        n=$((n+1))
                    done
                    exit 0
                    fi
            
            
        elif [[ -n $user ]] && [[ -n $numeroProcessos ]]; then
                
                segundos=$5
                if (($segundos <= 0)); then
                    echo "O número de segundos deve ser maior que 0"
                    exit 1
                fi
                cd /proc
                i=0;
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi
                        fi  
                    fi
                done
                processosFinal=$i
                n=0
                if ((${#array[@]} != 0)) && (($processosInicial==$processosFinal)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    while (($n<$numeroProcessos)); do
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[n]} | sort -k1n
                        n=$((n+1))
                    done
                else
                    echo "Utilizador sem processos associados ou erro na leitura. Por favor tente novamente"
                fi
        elif [[ -n $user ]] && [[ -n $o ]] && [[ -n $r ]]; then
                cd /proc
                i=0;
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi
                        fi  
                    fi
                done
                processosFinal=$i
            if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                if (($o=="4")); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk4
                elif (($o=="5")); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk5
                elif (($o=="8")); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk8
                elif (($o=="9")); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk9
                else 
                    echo "Modo incorreto de ordenação"
                fi
                exit 0
            fi
        elif [[ -n $user ]] && [[ -n $string ]]; then
                cd /proc
                i=0;
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ "$(ls -ld | grep -c $user)" -ge 1 ] && [ "$(grep -c ^$string comm)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ] && [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi
                        fi  
                    fi
                done
                processosFinal=$i
                if (($processosInicial==$processosFinal)) && ((${#array[@]} != 0)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]}
                fi
        fi

    ;;   
    6)
        while getopts ":s:e:mtdwu:c:p:" options; do
        case $options in
        u)
            user=$OPTARG
        ;;
        c)
            string=$OPTARG
        ;;
        p)
            numeroProcessos=$OPTARG
        ;;
        s)
            startDate=$OPTARG
        ;;
        e)
            endDate=$OPTARG
        ;;
        m)
            o="4"
        ;;
        t)
            o="5"
        ;;
        d)
            o="8"
        ;;
        w)
            o="9"
        ;;
        esac
        done
        segundos=$6
        if (( $segundos <= 0 )); then
            echo "O número de segundos dedve ser maior que 0"
            exit 1
        fi

        if [[ -n $startDate ]] && [[ -n $endDate ]] && [[ -n $o ]]; then
            start=$(date -d "$startDate" +%s);
         end=$(date -d "$endDate" +%s);

                if ((start > end)) ; then
                    echo "A data final tem que ser posterior à data inicial!"
                    exit 1
                fi
                    cd /proc
                    i=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                        dataSeg=$(date -d "$data" +%s)
                        
                        if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                            if [ -r io ]; then
                                rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                                wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                                i=$((i+1))
                            fi
                        fi
                    fi
                    done
                    processosInicial=$i
                    sleep $segundos
                    cd ..
                    i=0
                    x=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                        dataSeg=$(date -d "$data" +%s)
                        if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi  
                    fi
                    fi
                    done
                    processosFinal=$i
                    if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        if (($o=="4")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4n
                        elif (($o=="5")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5n
                        elif (($o=="8")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8n
                        elif (($o=="9")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9n
                        else 
                            echo "Modo incorreto de ordenação"
                        fi
                        exit 0
                    fi
        elif [[ -n $user ]] && [[ -n $string ]] && [[ -n $o ]]; then
                cd /proc
                i=0;
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ "$(ls -ld | grep -c $user)" -ge 1 ] && [ "$(grep -c ^$string comm)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ] && [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi
                        fi  
                    fi
                done
                processosFinal=$i
                if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        if (($o=="4")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4n
                        elif (($o=="5")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5n
                        elif (($o=="8")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8n
                        elif (($o=="9")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9n
                        else 
                            echo "Modo incorreto de ordenação"
                        fi
                        exit 0
                fi
        fi
            

    ;;
    7)
        while getopts ":mtdwrc:p:s:e:u:" options; do
            
            case $options in
                u)
                    user=$OPTARG
                ;;
                s)
                    startDate=$OPTARG   
                ;;    
                p)
                    numeroProcessos=$OPTARG
                    if (($numeroProcessos<=0)); then
                        echo "Número incorreto de processos"
                    fi
                ;;
                c)
                    string=$OPTARG  
                ;;
                e)
                    endDate=$OPTARG
                ;;
                m)
                    o="4"
                ;;
                t)
                    o="5"
                ;;
                d)
                    o="8"
                ;;
                w)
                    o="9"
                ;;
                r)
                    r="1"
                ;;
                \?)
                    echo "Opção inválida"
                ;;
            esac
        done
        segundos=$7
        if (($segundos <= 0)); then 
            echo "Número de segundos incorreto"
            exit 1
        fi
        echo $user $string $numeroProcessos
        if [[ -n $startDate ]] && [[ -n $endDate ]] && [[ -n $string ]]; then
            start=$(date -d "$startDate" +%s);
            end=$(date -d "$endDate" +%s);
            i=0
            cd /proc
            for proc in $(ls | grep -E '^[0-9]+$')
            do
            if [ -d "/proc/$proc" ]; then
                cd /proc/$proc
                data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                dataSeg=$(date -d "$data" +%s)
                if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                    if [ "$(grep -c ^$string comm)" -ge 1 ] && [ -r io ]; then
                        rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                        wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                        i=$((i+1))
                    fi
                fi
            fi
            done
            processosInicial=$i
            sleep $segundos
            cd ..
            i=0
            x=0
            for proc in $(ls | grep -E '^[0-9]+$')
            do
            if [ -d "/proc/$proc" ]; then
                cd /proc/$proc
                data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                dataSeg=$(date -d "$data" +%s)
                if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                    if [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                            Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                            Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                            wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                            rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                            i=$((i+1))
                        fi
                        if [ -r io ]; then
                            array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                            x=$((x+1))
                        fi 
                    fi
                fi
                processosFinal=$i
            fi
            done
            if (($processosInicial==$processosFinal)); then
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]}
            fi
            exit 0
    
        
        elif [[ -n $startDate ]] && [[ -n $endDate ]] && [[ -n $numeroProcessos ]]; then
                start=$(date -d "$startDate" +%s);
                end=$(date -d "$endDate" +%s);
                i=0
                cd /proc
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
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
                            Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                            Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                            wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                            rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                            i=$((i+1))
                        fi
                        if [ -r io ]; then
                            array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                            x=$((x+1))
                        fi  
                    fi
                fi
                done
            processosFinal=$i
            if (($processosInicial==$processosFinal)); then
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                for ((t=0;t<$numeroProcessos;t++))
                do
                a[t]=${array[t]}
                done
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]}
                exit 0
            fi
        
        elif [[ -n $startDate ]] && [[ -n $endDate ]] && [[ -n $o ]]; then
                start=$(date -d "$startDate" +%s);
                end=$(date -d "$endDate" +%s);
                i=0
                cd /proc
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
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
                            Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                            Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                            wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                            rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                            i=$((i+1))
                        fi
                        if [ -r io ]; then
                            array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                            x=$((x+1))
                        fi  
                    fi
                fi
                done
            processosFinal=$i
            if (($processosFinal!=$processosInicial)); then
                echo "Erro de leitura!"
                exit 1
            fi
            if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        if (($o=="4")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk4
                        elif (($o=="5")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk5
                        elif (($o=="8")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk8
                        elif (($o=="9")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -rnk9
                        else 
                            echo "Modo incorreto de ordenação"
                        fi
                        exit 0
                    fi


            
        
        elif [[ -n $string ]] && [[ -n $numeroProcessos ]] && [[ -z $user ]]; then
                    cd /proc
                    i=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(grep -c ^$string comm)" -ge 1 ]; then
                            if [ -r io ]; then
                                rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                                wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                                i=$((i+1))
                            fi
                        fi
                    fi
                    done
                    processosInicial=$i
                    sleep $segundos
                    cd ..
                    i=0
                    x=0
                    for proc in $(ls | grep -E '^[0-9]+$')
                    do
                        if [ -d "/proc/$proc" ]; then
                            cd /proc/$proc
                            if [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                                    Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                    Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                    wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                    rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                    i=$((i+1))
                                fi
                                if [ -r io ]; then
                                    array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                    x=$((x+1))
                                fi
                            fi  
                        fi
                    done
                    processosFinal=$i
                    if (($numeroProcessos>${#array[@]})); then
                        numeroProcessos=${#array[@]}
                        echo "Numero de processos a visualizar alterado"
                    fi
                    if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        for ((t=0;t<$numeroProcessos;t++))
                        do
                        a[t]=${array[t]}
                        done
                        if (($o=="4")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]} | sort -rnk4
                        elif (($o=="5")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]} | sort -rnk5
                        elif (($o=="8")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]} | sort -rnk8
                        elif (($o=="9")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]} | sort -rnk9
                        else 
                            echo "Modo incorreto de ordenação"
                        fi
                        exit 0
                    fi
            
        
        
        elif [[ -n $user ]] && [[ -n $startDate ]] && [[ -n $endDate ]]; then
                start=$(date -d "$startDate" +%s);
                end=$(date -d "$endDate" +%s);
                i=0
                cd /proc
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ] && [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi 
                        fi
                    fi
                    processosFinal=$i
                fi
                done
                if (($processosInicial==$processosFinal)); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]}
                else
                    echo "Utilizador sem processos associados"
                fi
                exit 0

            
        elif [[ -n $user ]] && [[ -n $string ]] && [[ -n $numeroProcessos ]]; then
                cd /proc
                i=0;
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    if [ "$(ls -ld | grep -c $user)" -ge 1 ] && [ "$(grep -c ^$string comm)" -ge 1 ]; then
                        if [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                    if [ -d "/proc/$proc" ]; then
                        cd /proc/$proc
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ] && [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi
                        fi  
                    fi
                done
                processosFinal=$i
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                for ((t=0;t<$numeroProcessos;t++))
                do
                a[t]=${array[t]}
                done
                printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${a[@]}        
                exit 0

        fi

    
    ;;    
    8)
        while getopts ":mtdwrc:p:s:e:u:" options; do
            
            case $options in
                u)
                    user=$OPTARG
                ;;
                s)
                    startDate=$OPTARG   
                ;;    
                p)
                    numeroProcessos=$OPTARG
                    if (($numeroProcessos<=0)); then
                        echo "Número incorreto de processos"
                    fi
                ;;
                c)
                    string=$OPTARG  
                ;;
                e)
                    endDate=$OPTARG
                ;;
                m)
                    o="4"
                ;;
                t)
                    o="5"
                ;;
                d)
                    o="8"
                ;;
                w)
                    o="9"
                ;;
                r)
                    r="1"
                ;;
                \?)
                    echo "Opção inválida"
                ;;
            esac
        done
        segundos=$8
        if (($segundos <= 0)); then 
            echo "Número de segundos incorreto"
            exit 1
        fi
        if [[ -n $startDate ]] && [[ -n $endDate ]] && [[ -n $string ]] && [[ -n $o ]]; then
            start=$(date -d "$startDate" +%s);
            end=$(date -d "$endDate" +%s);
            i=0
            cd /proc
            for proc in $(ls | grep -E '^[0-9]+$')
            do
            if [ -d "/proc/$proc" ]; then
                cd /proc/$proc
                data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                dataSeg=$(date -d "$data" +%s)
                if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                    if [ "$(grep -c ^$string comm)" -ge 1 ] && [ -r io ]; then
                        rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                        wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                        i=$((i+1))
                    fi
                fi
            fi
            done
            processosInicial=$i
            sleep $segundos
            cd ..
            i=0
            x=0
            for proc in $(ls | grep -E '^[0-9]+$')
            do
            if [ -d "/proc/$proc" ]; then
                cd /proc/$proc
                data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                dataSeg=$(date -d "$data" +%s)
                if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                    if [ "$(grep -c ^$string comm)" -ge 1 ]; then
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
                            Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                            Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                            wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                            rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                            i=$((i+1))
                        fi
                        if [ -r io ]; then
                            array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                            x=$((x+1))
                        fi 
                    fi
                fi
                processosFinal=$i
            fi
            done
            if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        if (($o=="4")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4n
                        elif (($o=="5")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5n
                        elif (($o=="8")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8n
                        elif (($o=="9")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9n
                        else 
                            echo "Modo incorreto de ordenação"
                        fi
                        exit 0
                    fi
            
            
            
            
            
        elif [[ -n $user ]] && [[ -n $startDate ]] && [[ -n $endDate ]] && [[ -n $o ]]; then
                start=$(date -d "$startDate" +%s);
                end=$(date -d "$endDate" +%s);
                i=0
                cd /proc
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ] && [ -r io ]; then
                            rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
                            wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
                            i=$((i+1))
                        fi
                    fi
                fi
                done
                processosInicial=$i
                sleep $segundos
                cd ..
                i=0
                x=0
                for proc in $(ls | grep -E '^[0-9]+$')
                do
                if [ -d "/proc/$proc" ]; then
                    cd /proc/$proc
                    data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
                    dataSeg=$(date -d "$data" +%s)
                    if (($dataSeg>=$start)) && (($dataSeg<=$end)); then
                        if [ "$(ls -ld | grep -c $user)" -ge 1 ]; then
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
                                Readb=$(($rchar_Final-${rchar_Inicial[i]}))
                                Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
                                wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
                                rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
                                i=$((i+1))
                            fi
                            if [ -r io ]; then
                                array[x]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
                                x=$((x+1))
                            fi 
                        fi
                    fi
                    processosFinal=$i
                fi
                done
                if (($o=="4")) || (($o=="5")) || (($o=="8")) || (($o=="9")); then
                        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
                        if (($o=="4")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4n
                        elif (($o=="5")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5n
                        elif (($o=="8")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8n
                        elif (($o=="9")); then
                            printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9n
                        else 
                            echo "Modo incorreto de ordenação"
                        fi
                        exit 0
                fi

                fi
        
    ;;
    *)
        echo "Número de argumentos inválido!"
    ;;
esac