#!/bin/bash

# Author: Tiago Henrique 

# spinner.sh
#
# Exibe um 'spinner' enquanto executa longos comandos do Shell

# Não chame a função call_spinner diretamente.
# Use as funções {start,stop}_spinner

function _spinner() {
    # $1 start/stop
    #
    # on start: $2 exibe a mensagem 
    # on stop : $2 processo do status de saída
    #           $3 spinner function pid (fornecido a partir stop_spinner)

    local on_success="DONE"
    local on_fail="FAIL"
    local white="\e[1;37m"
    local green="\e[1;32m"
    local red="\e[1;31m"
    local nc="\e[0m"

    case $1 in
        start)
            # calcular a coluna onde o spinner e a msg de status serão exibidos
            let column=$(tput cols)-${#2}-8
            # exibi a mensagem e posiciona o cursor na coluna $column
            echo -ne ${2}
            printf "%${column}s"

            # start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}

            while :
            do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner não está funcionando..."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # Informa o usuário sobre sucesso ou falha
            echo -en "\b["
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
            ;;
        *)
            echo "Argumento inválido, tente {start/stop}"
            exit 1
            ;;
    esac
}

function start_spinner {
    # $1 : exibe a mensagem
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stop_spinner {
    # $1 : comando de status de saída
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}
