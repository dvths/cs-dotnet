# CS-DOTNET

## Descrição:

Este script foi pensado para me auxiliar na criação de projetos .NET. Tenho estudado em um Arch Linux e ter que utilizar a CLI do .NET muitas vezes é desconfortável. Por isso, este script tem o objetivo de automatizar a criação de projetos básicos e evitar escrever longas linhas de comando ou muitas referências aos componentes dos projetos. 

Nesta primeira versão ele cria dois tipos de projetos (os que eu tenho estudado no momento): 

1. Um modelo de console juntamente com um modelo de testes unitários xUnit e referencia o arquivo .csproj do projeto.

2. Também cria a estrutura de um projeto WebAPI seguindo padrão Clean Architecture se encarregando de adicionar os componentes ao arquivo sln e referenciar corretamente cada componente. 

## Uso

- Clone o repositório
- Adicione o diretório ao `PATH` do sistema
- Execute:

```bash
cs <MeuPojeto> <opção> 

```

As opções de uso são: 
```bash

 -h | --help      Imprime a mensagem de Ajuda.
 -v | --version   Imprime a versão do script.
 -c | --console   Cria um novo aplicativo de console com projetos de testes unitários.
 -a | --api       Cria estrutura para construção de uma webapi no padrão SOLID/DDD .

```
Esse comando irá criar um diretório `MeuPojeto` com as seguintes estruturas:  

```bash
cs MeuProjeto --console

Criando projeto ...                                            [DONE]

$ tree -L 1 MeuProjeto

MeuProjeto
├── MeuProjeto
└── MeuProjeto.Test

2 directories, 0 files
```

```bash

$ cs MeuProjeto --api

Criando projeto ...                                            [DONE]

$ tree -L 1 MeuProjeto

MeuProjeto
├── MeuProjeto.Api
├── MeuProjeto.Application
├── MeuProjeto.Contracts
├── MeuProjeto.Domain
├── MeuProjeto.Infrastructure
└── MeuProjeto.sln

5 directories, 1 file
```

Conforme a necessidade irei refinando o script para torná-lo cada vez mais útil para os estudos de quem está começando.



