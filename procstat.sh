#!/bin/bash
#Sistemas Operativos 2020/2021
#Todos os direitos reservados
#7/12/2020
#João Bernardo Tavares Farias, nº98679
#Artur Correia Romão, nº98470


declare -a pid

start=0
end=$(date +%s)
string="**"
procView=""
user="*"

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
        string=$OPTARG*
    ;;
    u)
        user=$OPTARG
    ;;
    p)
        procView=$OPTARG
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
    esac
done
segundos=${@: -1}
if (($segundos<=0)); then
    echo "Número inválido de segundos"
    exit 1
fi


i=0
cd /proc
for proc in $(ls | grep -E '^[0-9]+$')
do
if [ -d "/proc/$proc" ]; then
    cd /proc/$proc
    comm=$(cat comm)
    userP=$(ls -ld | awk '{print $3}')
    if [[ $userP == $user ]] && [[ $comm == $string ]]; then
        data=$(LC_ALL=EN_us.utf8 ls -ld /proc/$proc | awk '{print $6 " " $7 " " $8}')
        dataSeg=$(date -d "$data" +%s)
        if (($start<$dataSeg)) && (($end>$dataSeg)); then
            if [ -r io ]; then 
                pid[i]=$(cat status | grep ^Pid | grep -o -E '[0-9]+')
                i=$((i+1))
            fi
        fi
    fi
fi
done

###GUARDAR OS VALORES DE rcharInicial e de wcharInicial num array
i=0
for pid in ${pid[@]}
do
echo $pid
cd /proc/$pid
rchar_Inicial[i]=$(cat io | grep rchar | grep -o -E '[0-9]+')
wchar_Inicial[i]=$(cat io | grep wchar | grep -o -E '[0-9]+')
i=$((i+1))
done
procI=$i
sleep $segundos

##SEGUNDA LEITURA
i=0
for pid in ${pid[@]}
do
echo $pid
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
done
procF=$i
if (($procI==$procF)); then
    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s\n' COMM USER PID MEM RSS READB WRITEB RATER RATEW DATE
    printf '%-35s %-16s %-10s %-10s %-10s %-15s %-15s %-15s %-20s %-1s %-1s %-1s\n' ${array[@]}
fi






