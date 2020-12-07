#!/bin/bash
#Sistemas Operativos 2020/2021
#Todos os direitos reservados
#7/12/2020
#João Bernardo Tavares Farias, nº98679
#Artur Correia Romão, nº98470


start=0
end=$(date +%s)
string=""
procView=""
user="*"
o=0
r=0
valida=()
reverse=()

while getopts ":mtdwrs:e:c:p:u:" option; do
    case $option in
    s)
        startDate=$OPTARG
        start=$(date -d "$startDate" +%s);
    ;;
    e)
        endDate=$OPTARG
        end=$(date -d "$endDate" +%s);
    ;;
    c)
        string=$OPTARG
    ;;
    u)
        user=$OPTARG
    ;;
    p)
        procView=$OPTARG
    ;;
    m)
        o=4
        valida+=("m")
    ;;
    t)
        o=5
        valida+=("t")
    ;;
    d)
        o=8
        valida+=("d")
    ;;
    w)
        o=9
        valida+=("w")
    ;;
    r)
        r=1
        reverse+=("r")
    ;;
    \?)
        echo "ERROR: Wrong option"
        exit 1
    ;;
    esac
done

shift $((OPTIND -1))

##VALIDAÇÕES

if ((${#valida[@]}>=2)); then
    echo "ERROR: Invalid order mode"
    exit 1
fi

if ((${#reverse[@]}>=2)); then
    echo "ERROR: Invalid order mode"
    exit 1
fi

segundos=${@: -1}
if (($segundos<=0)); then
    echo "ERROR: Invalid arguments number"
    exit 1
fi

if [[ -n $procView ]] && [[ $procView -lt 1 ]]; then
    echo "ERROR: Invalid number of proccess to show"
    exit 1
fi


if (($start>$end)); then
    echo "ERROR: Final data must be greater than inicial data"
    exit 1
fi


#####verificar os pids que obedecem às seguintes condições
i=0
cd /proc
for proc in $(ls | grep -E '^[0-9]+$')
do
if [ -e "/proc/$proc" ] && [ -d "/proc/$proc" ]; then
    cd /proc/$proc
    comm=$(cat comm)
    userP=$(ls -ld | awk '{print $3}')
    if [[ $userP == $user ]] && [[ $comm =~ $string ]]; then
        data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
        dataSeg=$(date -d "$data" +%s)
        if (($start<$dataSeg)) && (($end>$dataSeg)); then
            if [ "$(grep -c "VmRSS" status)" -ge 1 ] && [ -r io ]; then 
                pid[i]=$(cat status | grep ^Pid | grep -o -E '[0-9]+')
                i=$((i+1))
            fi
        fi
    fi
fi
done

###GUARDAR OS VALORES DE rcharInicial e de wcharInicial num array
pidS=($(printf "%s\n" "${pid[@]}" | sort -u))

i=0
for pid in ${pidS[@]}
do
if [ -e "/proc/$pid" ] && [ -d "/proc/$pid" ]; then
    cd /proc/$pid
    rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
    wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
    i=$((i+1))
fi
done

procI=$i

sleep $segundos

##SEGUNDA LEITURA
i=0
for pid in ${pidS[@]}
do
if [ -e "/proc/$pid" ] && [ -d "/proc/$pid" ]; then
    cd /proc/$pid
    comm=$(cat comm)
    user=$(ls -ld | awk '{print $3}')
    data=$(ls -ld | awk '{print $6 " " $7 " " $8}')
    PID=$(cat status | grep ^Pid | grep -o -E '[0-9]+')
    if [ "$(grep -c "VmRSS" status)" -ge 1 ]; then   
        VmSize=$(cat status | grep VmSize | grep -o -E '[0-9]+')
        VmRSS=$(cat status | grep VmRSS | grep -o -E '[0-9]+')
    fi
    rchar_Final=$(cat io | grep rchar | grep -o -E '[0-9]+')
    wchar_Final=$(cat io | grep wchar | grep -o -E '[0-9]+')
    Readb=$(($rchar_Final-${rchar_Inicial[i]}))
    Writeb=$(($wchar_Final-${wchar_Inicial[i]}))
    wchar_Taxa=$(bc <<< "scale = 2; (${wchar_Final}-${wchar_Inicial[i]})/${segundos}")
    rchar_Taxa=$(bc <<< "scale = 2; (${rchar_Final}-${rchar_Inicial[i]})/${segundos}")
    array[i]="$comm $user $PID $VmSize $VmRSS $Readb $Writeb $rchar_Taxa $wchar_Taxa $data"
    i=$((i+1))
fi
done
procF=$i


######PRINT
if ((${#array[@]}==0)); then
    echo "WARNING: No process found"
    exit 0
fi

if [[ -n $procView ]]; then
    if ((${#array[@]}<$procView)); then
        echo "WARNING: número de processos a mostrar alterado"
        procView=${#array[@]}
    fi
else
    procView=${#array[@]}
fi


#t=${array[@]:1}


if (($procI==$procF)); then
    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
    if (($o==4)) && (($r==0)); then
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4rn | head -n $procView
    elif (($o==5)) && (($r==0)); then
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5rn | head -n $procView
    elif (($o==8)) && (($r==0)); then
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8rn | head -n $procView
    elif (($o==9)) && (($r==0)); then
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9rn | head -n $procView
    elif (($o==4)) && (($r==1)); then
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k4n | head -n $procView
    elif (($o==5)) && (($r==1)); then
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k5n | head -n $procView
    elif (($o==8)) && (($r==1)); then
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k8n | head -n $procView
    elif (($o==9)) && (($r==1)); then
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | sort -k9n | head -n $procView
    else
        printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]} | head -n $procView
    fi 
fi