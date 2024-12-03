# Agenda Flutter

Este projeto é uma aplicação de agenda desenvolvida em Flutter com o objetivo de gerenciar contatos. Ele permite adicionar, editar, excluir e listar contatos, além de buscar endereços automaticamente através de CEPs utilizando a API ViaCEP e importar contatos diretamente do telefone.

## Apresentação

O vídeo de apresentação pode ser acessado no link abaixo:

[🎥 Assistir à Apresentação](https://1drv.ms/v/s!AoDftrmwEnz7idpfnmJ0N42wxDaN2Q?e=6KSVha)

## 🚀 Funcionalidades Principais

### 📋 Gerenciamento de Contatos
- **Adicionar novos contatos** com informações como:
    - Nome
    - Telefone
    - CEP
    - Endereço (preenchido automaticamente via CEP)
    - Cidade
    - Estado
    - Número
- **Listar todos os contatos** cadastrados.
- **Editar informações** de um contato existente.
- **Excluir contatos** da lista.

### 🌐 Integração com API
- **Consulta de endereços por CEP** utilizando a API **ViaCEP**.
    - Preenchimento automático de endereço, cidade e estado após inserir um CEP válido.

### 📱 Integração Nativa com Contatos do Telefone
- **Importar contatos diretamente do dispositivo**.
    - Sincronização com a lista de contatos nativa do telefone.
    - Adição facilitada de contatos já existentes no telefone à lista do aplicativo.

### 🧪 Testes Automatizados
- **Testes Unitários** para validar a lógica do controlador de contatos.
- **Testes de Integração** para verificar o fluxo completo de adicionar um contato através do formulário.
- **Testes de Integração Nativa** para validar a importação de contatos do dispositivo.

### 🛠️ Tecnologias Utilizadas
- **Flutter** para desenvolvimento do aplicativo.
- **GetX** para gerenciamento de estado e navegação.
- **Sqflite** para persistência de dados local (SQLite).
- **API ViaCEP** para consulta de endereços.
- **Flutter Contacts** para integração com os contatos do dispositivo.
