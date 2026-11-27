SET NAMES utf8mb4;

DROP DATABASE IF EXISTS sindicd;

CREATE DATABASE sindicd
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE sindicd;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    nome_completo VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    tipo_perfil ENUM('trabalhador', 'administrador', 'assessor') NOT NULL,
    status_cadastro ENUM('ativo', 'pendente', 'inativo') NOT NULL,
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE carteirinhas (
     id_carteirinha INT AUTO_INCREMENT PRIMARY KEY,
     id_usuario INT NOT NULL,
     codigo_qrcode VARCHAR(255) NOT NULL UNIQUE,
     status_regularidade ENUM('regular', 'irregular', 'suspenso') NOT NULL,
     data_emissao DATE NOT NULL,
     data_validade DATE NOT NULL,

     FOREIGN KEY(id_usuario)
          REFERENCES usuarios(id_usuario)
          ON DELETE CASCADE
);

CREATE TABLE postos_combustivel (
     id_posto INT AUTO_INCREMENT PRIMARY KEY,
     nome_fantasia VARCHAR(150) NOT NULL,
     razao_social VARCHAR(150) NOT NULL,
     cnpj VARCHAR(14) NOT NULL UNIQUE,
     cidade VARCHAR(100) NOT NULL
);

CREATE TABLE documentos (
     id_documento INT AUTO_INCREMENT PRIMARY KEY,
     id_usuario INT NOT NULL,
     tipo_documento ENUM(
          'holerite', 
          'cartao_ponto', 
          'outros')
          NOT NULL,
     caminho_arquivo VARCHAR(255),
     data_envio DATE,

     /* 
     recomenda-se inativar usuários em vez de excluí-los,
     preservando o histórico documental.
     */

     FOREIGN KEY (id_usuario)
          REFERENCES usuarios(id_usuario)
          ON DELETE CASCADE
);

CREATE TABLE informativos (
     id_info INT AUTO_INCREMENT PRIMARY KEY,
     titulo VARCHAR(150) NOT NULL,
     conteudo TEXT NOT NULL,
     data_envio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE engajamento_informativos (
     id_engajamento INT AUTO_INCREMENT PRIMARY KEY,
     id_info INT NOT NULL,
     id_usuario INT NOT NULL,
     visualizado BOOLEAN NOT NULL DEFAULT FALSE,
     data_visualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

     FOREIGN KEY(id_info)
          REFERENCES informativos(id_info)
          ON DELETE CASCADE,

     FOREIGN KEY(id_usuario)
          REFERENCES usuarios(id_usuario)  
          ON DELETE CASCADE     
);

CREATE TABLE vinculos_trabalhistas (
     id_vinculo INT AUTO_INCREMENT PRIMARY KEY,
     id_usuario INT NOT NULL,
     id_posto INT NOT NULL,
     cargo VARCHAR(100) NOT NULL,
     data_admissao DATE NOT NULL,
     data_rescisao DATE,
     atual BOOLEAN NOT NULL DEFAULT TRUE,

     FOREIGN KEY(id_usuario)
            REFERENCES usuarios(id_usuario)
            ON DELETE CASCADE,

     FOREIGN KEY(id_posto)
          REFERENCES postos_combustivel(id_posto)
          ON DELETE CASCADE   
               
);