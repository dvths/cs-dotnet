#!/bin/env bash

## DESCRIÇÃO DO PROGRAMA

# Author: Tiago Henrique 

# Este script tem o objetivo de automatizar a criação de projetos básicos para aqueles
# que fazem uso da CLI do .NET.

# ------------------------------------RECURSOS-------------------------------------------------------
source $HOME/.local/bin/spinner.sh

# ------------------------------------VARIÁVEIS-------------------------------------------------------
vesrsion='0.1.0'
project_dir="$1"

C=$(tput sgr0)
E=$(tput setaf 1)
# S=$(tput setaf 2)
I=$(tput setaf 3)

# ------------------------------------FUNÇÕES-------------------------------------------------------
Help() {
	printf '%s\n' "Uso: 

  $I cs <ProjectName> <option> $C

  $I Ex: cs MyProject --console -> Criará um modelo console e xunit em um diretório MyProject.$C
       
Opções:
$I -h | --help      Imprime esta mensagem de Ajuda. $C
$I -v | --version   Imprime a versão do script.$C
$I -c | --console   Cria um novo aplicativo de console com projetos de testes unitários.$C
$I -a | --api       Cria estrutura para construção de uma webapi no padrão SOLID/DDD.$C"
}

create_api_project() {
	api="${project_dir}.Api"
	domain="${project_dir}.Domain"
	contracts="${project_dir}.Contracts"
	application="${project_dir}.Application"
	infrastructure="${project_dir}.Infrastructure"

	dotnet new sln -o "$project_dir" >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$project_dir"
		exit 1
	}
	cd "$project_dir" || {
		printf '%s\n' "$E Não foi possível acessar o diretório.$C" >&2
		exit $?
	}
	dotnet new webapi -o "$api" >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$api"
		exit 1
	}
	dotnet new classlib -o "$contracts" >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$contracts"
		exit 1
	}
	dotnet new classlib -o "$infrastructure" >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$infrastructure"
		exit 1
	}
	dotnet new classlib -o "$application" >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$application"
		exit 1
	}
	dotnet new classlib -o "$domain" >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$domain"
		exit 1
	}
	# Adiciona todos os componentes à solução
	dotnet sln add **/*.csproj >/dev/null

	# Adiciona as referências necessárias entre cada componente
	dotnet add "$api" reference "$contracts" "$application" > /dev/null
	dotnet add "$infrastructure" reference "$application" > /dev/null
	dotnet add "$application" reference "$domain" > /dev/null
	dotnet add "$api" reference "$infrastructure" > /dev/null
}

create_console_project() {
    console_app="${project_dir}.ConsoleApp"
	test_dir="${project_dir}.ConsoleApp.Test"

	mkdir "$project_dir" || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		Help
		exit 1
	}
	cd "$project_dir" || {
		printf '%s\n' "$E Não foi possível acessar o diretório.$C" >&2
		exit 1
	}
	dotnet new sln >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$project_dir"
		exit 1
	}
	mkdir src || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		Help
		exit 1
	}
	cd src || {
		printf '%s\n' "$E Não foi possível acessar o diretório.$C" >&2
		exit 1
	}
	dotnet new console -o "$console_app" >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$project_dir"
		exit 1
	}

	dotnet new xunit -o "$test_dir" >/dev/null || {
		printf '%s\n' "$E Não foi possível criar seu modelo.$C" >&2
		rm -rf "$test_dir"
		exit 1
	}

	dotnet add "$test_dir" reference "$console_app" > /dev/null

    cd ..

	dotnet sln add ./src/**/*.csproj >/dev/null
}
# ------------------------------------PROGRAMA-------------------------------------------------------
if [[ -z $1 ]]; then
	printf '%s\n' "$E É necessário informar um nome para o projeto. $C" >&2
	Help
	exit 1
fi

while [ -n "$1" ]; do

	if [[ $1 = "-h" || $1 = "--help" ]]; then
		Help
		exit
	elif [[ $1 = "-v" || $1 = "--version" ]]; then
		printf '%s\n' "$vesrsion"
		exit
	fi

	case "$2" in
	-c | --console)
		start_spinner 'Criando projeto ...'
		create_console_project "$@"
		stop_spinner $?
		shift
		;;
	-a | --api)
		start_spinner 'Criando projeto ...'
		create_api_project "$@"
		stop_spinner $?
		shift
		;;
	*)
		printf '%s\n' "$E $1 Não é uma opção.$C" >&2
		Help
		exit
		;;
	esac
	shift
done

unset project_dir
unset I
unset C
unset E
unset vesrsion
