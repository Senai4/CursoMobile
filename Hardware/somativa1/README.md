## Documentação do Projeto
App de Registro de Ponto com Geolocalização e Biometria Este projeto foi desenvolvido para a Avaliação Somativa em Flutter, com o objetivo de colocar na prática os conhecimentos sobre desenvolvimento mobile, integração com o Firebase e uso de APIs externas (como geolocalização e biometria) em um cenário real de controle de ponto.

## Funcionalidades Implementadas

Autenticação: Login com Email e Senha

Validação de Localização: Verifica automaticamente se o usuário está dentro do limite de 100 metros.

Registro de Ponto: Salva dados, horas e coordenadas exatas do ponto batido.

Integração com Firebase: Usado tanto para autenticação quanto para armazenar os registros.

Como Rodar o Aplicativo (Instalação e Uso)
Pré-requisitos Antes de rodar o projeto, é preciso ter instalado:

Flutter SDK (versão compatível informada no pubspec.yaml).

IDE (Visual Studio Code ou Android Studio).

Um dispositivo físico ou emulador configurado.

## Configuração do Ambiente:

flutter pub get Configuração do Firebase:

Crie um projeto no Console do Firebase.

Autenticação Habilite (E-mail/Senha).

Habilite o Firestore para o banco de dados.

Adicione seu aplicativo Android e/ou iOS ao projeto Firebase.


## Configuração de Geolocalização:

Garanta que as permissões de localização estejam configuradas nos arquivos manifestos (Android: AndroidManifest.xml).

## Detalhes Técnicos e Design Tecnologias Utilizadas:

Flutter & Dart – Linguagem e framework principal.

Firebase Auth – Autenticação de usuários.

Cloud Firestore – Armazenamento de dados dos registros.

geolocalizador – Para capturar localização e calcular a distância (100m).

local_auth – Para autenticação biométrica.

Decisões de Design (UI/UX)
O foco foi criar uma interface simples e funcional, fácil de entender e usar.

Estrutura: Código dividido em Models, Views e Controllers (MVC), o que facilita a manutenção e leitura.

## Desafios Encontrados e Soluções:

## Permissões de Localização: Resolvido usando a função de solicitação do pacote geolocalizador e configurando corretamente os manifestos.

## Conectar com o firebase corretamente

## Cálcular a Distância (100m)