## Documentação do Projeto
App de Registro de Ponto com Geolocalização e Biometria
Este documento descreve o projeto desenvolvido para a Avaliação Somativa em Flutter, focado em demonstrar habilidades de desenvolvimento mobile nativo, integração com Firebase e uso de APIs externas para simular um cenário de aplicação prática de controle de ponto.

## Objetivos da Avaliação
O projeto foi desenvolvido para:

Aplicar habilidades práticas no framework Flutter.

Implementar autenticação de usuários.

Utilizar APIs externas (Geolocalização e Biometria) para validação.

Gerenciar dados em tempo real utilizando Firebase.

Aplicar boas práticas de UI/UX e organização de código.

## Tema Escolhido: App de Registro de Ponto
Descrição
Um aplicativo móvel que permite ao funcionário registrar seu ponto de trabalho de forma segura e validada. O registro só é permitido se o usuário estiver em um raio de 100 metros do local de trabalho pré-definido.

Funcionalidades Implementadas
Autenticação Segura: Login via NIF/Email e Senha ou Reconhecimento Facial (Biometria).

Validação de Localização: Uso de Geolocalização para verificar se o funcionário está dentro da área permitida (raio de 100m).

Registro de Ponto: Armazenamento do ponto batido com Data, Hora e Coordenadas Geográficas exatas.

Integração com Firebase: Utilizado para Autenticação de usuários e Armazenamento dos registros de ponto.

## Como Rodar o Aplicativo (Instalação e Uso)
Pré-requisitos
Para rodar o projeto localmente, você precisará ter instalado:

Flutter SDK: Versão compatível (verificar o pubspec.yaml).

IDE: Visual Studio Code ou Android Studio.

Dispositivo/Emulador: Um dispositivo móvel ou emulador configurado.

Configuração do Ambiente
Clone o Repositório:

Bash

git clone [LINK_DO_SEU_REPOSITORIO]
cd [NOME_DA_PASTA_DO_PROJETO]
Instale as Dependências:

Bash

flutter pub get
Configuração do Firebase:

Crie um projeto no Console do Firebase.

Habilite Authentication (Email/Password).

Habilite Firestore para o banco de dados.

Adicione o seu aplicativo Android e/ou iOS ao projeto Firebase.

Baixe o arquivo de configuração:

Android: Cole o arquivo google-services.json na pasta android/app/.

iOS: Siga as instruções para adicionar o GoogleService-Info.plist.

Configuração de Geolocalização:

Garanta que as permissões de localização estejam configuradas nos arquivos manifestos (Android: AndroidManifest.xml, iOS: Info.plist).

Execução:

Bash

flutter run

## Detalhes Técnicos e Design
Tecnologias Principais
Flutter & Dart: Framework e linguagem principais.

Firebase Auth: Autenticação de usuários.

Cloud Firestore: Banco de dados para registros de ponto.

geolocator: API para geolocalização e cálculo de distância (100m).

local_auth: API para autenticação biométrica.

Decisões de Design (UI/UX)
O foco do projeto foi criar uma interface simples, porém altamente eficiente e funcional.

Filosofia: Priorizar a usabilidade. O fluxo de registro de ponto é direto, com o mínimo de cliques.

Identidade Visual: A cor Roxa foi escolhida para os detalhes e elementos de destaque, adicionando um toque pessoal ao design.

Estrutura de Código: O projeto segue o padrão [Mencione seu padrão, ex: Provider/Riverpod/BLoC] para garantir a clareza e facilitar a manutenção.

Desafios Encontrados e Soluções
Configuração de Permissões de Localização em runtime: Solucionado com o uso da função de solicitação de permissão do pacote geolocator e configuração de manifestos.

Garantir a precisão da Biometria: Solucionado com a implementação de um fallback (opção de login) para o NIF/Senha caso a biometria não esteja disponível ou falhe.

Cálculo de Distância (Raio de 100m): Solucionado com a utilização do método distanceBetween do geolocator (Fórmula de Haversine) para comparação precisa entre as localizações.