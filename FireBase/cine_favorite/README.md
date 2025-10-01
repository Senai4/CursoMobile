# CineFavorite - Formativa

Construindo um aplicativo do Zero - O CineFavorite permitirá criar uma conta e buscar filmes em uma api e montar uma galeria pessoal de filmes favoritos, com capas e notas.

## Objetivos

- Integrar o Aplicativo a uam API
- Criar uma conta pessoal no FireBase
- Armazenar informações para Cada usuários das preferencias solicitadas
- consultar informações de Filmes (Capas, Título)

## Levantamentos de Requisitos

- Funcionais

- Não Funcionais

## Diagramas

1. ### Diagrama de Classe

   Diagrama de que demonstra as entidades da aplicação

   - usuário (user) : classe criada pelo FireBase

     - email
     - senha
     - id
     - create()
     - login()
     - logout()

   - Filme (Movie) : Classe modelada pelo dev
     - number id:
     - String titulo:
     - String PosterPath
     - boolean favorito
     - double Nota
     - adicionar()
     - update()
     - remover()
     - listarFavoritos()

```mermaid

classDiagram
    class User{
        +String uid
        +String email
        +String password
        +createUser()
        +login()
        +logout()
    }

    class Movie{
        +String id
        +String title
        +String posterPath
        +Boolean Favorite
        +double Rating
        +addFavorite()
        +removeFavorite()
        +updateRating()
        +read()
    }

    User "1"--"1+" Movie : "selecionar"

```

2. ### Diagrama de Uso

Ações que os Atores Fazem

- Usuário:
  - Registrar
  - Login
  - Logout
  - Buscar Filmes na API
  - Adicionar aos Favorito
  - Dar Nota ao Filme
  - Remover dos Favoritos

```mermaid

graph TD
  subgraph "Ações"
    uc1([Registrar])
    uc2([Login])
    uc3([LogOut])
    uc4([Search Movie])
    uc5([Favorite Movie])
    uc6([Rating Movie])
    uc7([Remove Favorite Movie])
  end

  user([Usuário])

  user --> uc1
  user --> uc2
  user --> uc3
  user --> uc4
  user --> uc5
  user --> uc6
  user --> uc7

  uc1 --> uc2
  uc2 --> uc4
  uc2 --> uc5
  uc2 --> uc6
  uc2 --> uc7

```

3. ### Diagrama de Fluxo
Determian o Caminho que um ator percorre para realizar uma ação

- Ação de Login

```mermaid

A[Ínicio] --> B{Tela de login}
B --> C[Inserir email e senha]
C --> D{Validar as Credenciais do Usuário}
D --> SIM --> E[Tela de Favoritos]
D --> NÃO --> F[Mensagem de Erro] --> B

```



## Prototipagem

- Colocar o Link do Figma

## Codificação
