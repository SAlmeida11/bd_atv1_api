-- PostgreSQL script generated from MySQL script

-- Disable triggers and constraints
SET session_replication_role = replica;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS "mydb";
SET search_path TO "mydb";

CREATE DOMAIN numeros AS VARCHAR(15)
    CHECK (VALUE ~ '^\+?[1-9]\d{1,14}$');

CREATE DOMAIN number_cpf AS VARCHAR(11)
    CHECK (VALUE ~ '^[0-9]{11}$');


CREATE DOMAIN number_cnpj AS VARCHAR(14)
    CHECK (VALUE ~ '^[0-9]{14}$');

-- -----------------------------------------------------
-- Table "mydb"."banco"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "banco" (
  "CNPJ" number_cnpj PRIMARY KEY,
  "email" VARCHAR(50) NOT NULL,
  "ceo" VARCHAR(45) NOT NULL,
  "data_fundacao" DATE NOT NULL,
  "numero" CHAR(3) NOT NULL,
  "cep" VARCHAR(9) NOT NULL,
  "numero_funcionarios" INT DEFAULT 0,
  "complemento" VARCHAR(45) DEFAULT '-' 
);

-- -----------------------------------------------------
-- Table "mydb"."Funcionario"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "Funcionario" (
  "CPF" number_cpf PRIMARY KEY,
  "tipo_funcionario" VARCHAR(30) NOT NULL,
  "salario" DOUBLE PRECISION NOT NULL,
  "data_nascimento" DATE NOT NULL,
  "primeiro_nome" VARCHAR(45) NOT NULL,
  "segundo_nome" VARCHAR(45) NOT NULL,
  "email" VARCHAR(50)[] NOT NULL,
  "telefone" numeros[] NOT NULL
);

-- -----------------------------------------------------
-- Table "mydb"."Gerente"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "Gerente" (
  "COD_GERENCIA" VARCHAR(9) PRIMARY KEY,
  "CPF_funcionario" number_cpf NOT NULL,
  CONSTRAINT "fk_cpf_funcionario" FOREIGN KEY ("CPF_funcionario") REFERENCES "Funcionario" ("CPF") ON DELETE CASCADE ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table "mydb"."agencia"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "agencia" (
  "NUMERO" VARCHAR(16) PRIMARY KEY,
  "cep" VARCHAR(9) NOT NULL,
  "email" VARCHAR(255)[] NOT NULL,
  "telefone" numeros[] NOT NULL,
  "CNPJ" number_cnpj UNIQUE NOT NULL,
  "Numero_rua" VARCHAR(45) NOT NULL,
  "Complemento" VARCHAR(45) NOT NULL,
  "CNPJ_banco" number_cnpj NOT NULL,
  "COD_GERENCIA" VARCHAR(11) NOT NULL,
  CONSTRAINT "fk_agencia_banco" FOREIGN KEY ("CNPJ_banco") REFERENCES "banco" ("CNPJ") 
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_agencia_gerente" FOREIGN KEY ("COD_GERENCIA") REFERENCES "Gerente" ("COD_GERENCIA")
  ON DELETE CASCADE ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table "mydb"."relatorio"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "relatorio" (
  "tipo" INT NOT NULL,
  "data_criacao" DATE NOT NULL,
  "data_periodo_inicio" DATE NOT NULL,
  "data_periodo_fim" DATE NOT NULL,
  "status" VARCHAR(15) NOT NULL,
  "documento_path" VARCHAR(45) NOT NULL,
  "descricao" VARCHAR(255) DEFAULT '',
  "COD_GERENCIA" VARCHAR(11) NOT NULL,
  "NUMERO_agencia" VARCHAR(16) NOT NULL,
  CONSTRAINT "fk_relatorio_Gerente" FOREIGN KEY ("COD_GERENCIA") REFERENCES "Gerente" ("COD_GERENCIA"),
  CONSTRAINT "fk_relatorio_agencia" FOREIGN KEY ("NUMERO_agencia") REFERENCES "agencia" ("NUMERO")
);

-- -----------------------------------------------------
-- Table "mydb"."cliente"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "cliente" (
  "ID_CLIENTE" SERIAL PRIMARY KEY,
  "email" VARCHAR(50) NOT NULL
);

-- -----------------------------------------------------
-- Table "mydb"."Conta"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "Conta" (
  "NUMERO" VARCHAR(16) PRIMARY KEY,
  "Status" BOOLEAN NOT NULL,
  "data_abertura" DATE NOT NULL,
  "Conjunta" BOOLEAN NOT NULL,
  "senha" VARCHAR(45) NOT NULL,
  "COD_GERENCIA" VARCHAR(11) NOT NULL,
  "saldo" DOUBLE PRECISION check("saldo" >= 0) DEFAULT 0.0,
  "Taxa" DOUBLE PRECISION check("Taxa" >= 0) DEFAULT 0.0,
  "Numero_agencia" VARCHAR(16) NOT NULL,
  "ID_Cliente" INT NOT NULL,
  CONSTRAINT "fk_Conta_agencia" FOREIGN KEY ("Numero_agencia") REFERENCES "agencia" ("NUMERO") ON UPDATE CASCADE,
  CONSTRAINT "fk_Conta_cliente" FOREIGN KEY ("ID_Cliente") REFERENCES "cliente" ("ID_CLIENTE") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_Conta_Gerente" FOREIGN KEY ("COD_GERENCIA") REFERENCES "Gerente" ("COD_GERENCIA") ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table "mydb"."pj_cliente"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "pj_cliente" (
  "CNPJ" number_cnpj PRIMARY KEY,
  "capital_social" DOUBLE PRECISION NOT NULL,
  "razao_social" VARCHAR(45) NOT NULL,
  "ID_CLIENTE" INT NOT NULL,
  CONSTRAINT "fk_pj_cliente_cliente" FOREIGN KEY ("ID_CLIENTE") REFERENCES "cliente" ("ID_CLIENTE")
);

-- -----------------------------------------------------
-- Table "mydb"."pf_cliente"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "pf_cliente" (
  "CPF" number_cpf PRIMARY KEY,
  "primeiro_nome" VARCHAR(45) NOT NULL,
  "sobrenome" VARCHAR(45) NOT NULL,
  "ID_CLIENTE" INT NOT NULL,
  CONSTRAINT "fk_pf_cliente_cliente" FOREIGN KEY ("ID_CLIENTE") REFERENCES "cliente" ("ID_CLIENTE")
);

-- -----------------------------------------------------
-- Table "mydb"."Telefone"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "Telefone" (
  "TELEFONE" numeros NOT NULL,
  "ID_CLIENTE" INT NOT NULL,
  PRIMARY KEY ("TELEFONE", "ID_CLIENTE"),
  CONSTRAINT "fk_Telefone_cliente" FOREIGN KEY ("ID_CLIENTE") REFERENCES "cliente" ("ID_CLIENTE")
);

-- -----------------------------------------------------
-- Table "mydb"."Transferencia"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "Transferencia" (
  "NUM_TRANSACAO" VARCHAR(45) PRIMARY KEY,
  "origem" VARCHAR(16) NOT NULL,
  "destino" VARCHAR(16) NOT NULL,
  "data_hora" TIMESTAMP NOT NULL,
  "status" BOOLEAN NOT NULL,
  "Tipo_Transferencia" VARCHAR(45) DEFAULT NULL,
  "NUMERO_conta" VARCHAR(45) NOT NULL,
  CONSTRAINT "fk_Transferencia_Conta" FOREIGN KEY ("NUMERO_conta") REFERENCES "Conta" ("NUMERO")
);

-- -----------------------------------------------------
-- Table "mydb"."Pix"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "Pix" (
  "NUM_TRANSACAO" VARCHAR(45) PRIMARY KEY,
  "endereco" INT NOT NULL,
  "origem" VARCHAR(16) NOT NULL,
  "destino" VARCHAR(16) NOT NULL,
  "data_hora" TIMESTAMP NOT NULL,
  "status" BOOLEAN NOT NULL,
  "Recibo" VARCHAR(45) DEFAULT NULL,
  "NUMERO_Conta" VARCHAR(45) NOT NULL,
  "Pix_NUM_TRANSACAO" VARCHAR(45) NOT NULL,
  CONSTRAINT "fk_Pix_Conta" FOREIGN KEY ("NUMERO_Conta") REFERENCES "Conta" ("NUMERO")
);

-- -----------------------------------------------------
-- Table "mydb"."pagamento"
-- -----------------------------------------------------

--pg = pagamento
CREATE DOMAIN metodo_pg AS VARCHAR(15)
    CHECK (VALUE IN ('boleto', 'qrcode', 'link de pg')); 

CREATE TABLE IF NOT EXISTS "pagamento" (
  "NUM_TRANSACAO" VARCHAR(45) PRIMARY KEY,
  "endereco" INT NOT NULL,
  "origem" VARCHAR(45) NOT NULL,
  "destino" VARCHAR(45) NOT NULL,
  "data_hora" TIMESTAMP NOT NULL,
  "status" BOOLEAN NOT NULL,
  "metodo_pagamento" metodo_pg NOT NULL,
  "NUMERO_conta" VARCHAR(45) NOT NULL,
  CONSTRAINT "fk_pagamento_Conta" FOREIGN KEY ("NUMERO_conta") REFERENCES "Conta" ("NUMERO")
);

-- -----------------------------------------------------
-- Table "mydb"."credito_cartao"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "credito_cartao" (
  "NUMERO" CHAR(16) PRIMARY KEY,
  "taxa_juros" FLOAT check("taxa_juros" >= 0) NOT NULL,
  "num_parcelas" INT check("num_parcelas" >= 1) NOT NULL,
  "limite" DOUBLE PRECISION check("limite" >= 0) NOT NULL,
  "bandeira" VARCHAR(15) NOT NULL,
  "data_emissao" DATE NOT NULL,
  "data_validade" DATE NOT NULL,
  "status" BOOLEAN NOT NULL,
  "cod_seguranca" CHAR(3) NOT NULL,
  "NUMERO_conta" VARCHAR(16) NOT NULL,
  CONSTRAINT "fk_credito_cartao_Conta" FOREIGN KEY ("NUMERO_conta") REFERENCES "Conta" ("NUMERO") ON DELETE CASCADE ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table "mydb"."debito_cartao"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "debito_cartao" (
  "NUMERO" CHAR(16) PRIMARY KEY,
  "bandeira" VARCHAR(15) NOT NULL,
  "data_emissao" DATE NOT NULL,
  "data_validade" DATE NOT NULL,
  "status" BOOLEAN NOT NULL,
  "cod_seguranca" INT NOT NULL,
  "saldo" DOUBLE PRECISION check("saldo" >= 0)NOT NULL,
  "NUMERO_conta" VARCHAR(16) NOT NULL,
  CONSTRAINT "fk_debito_cartao_Conta" FOREIGN KEY ("NUMERO_conta") REFERENCES "Conta" ("NUMERO") ON DELETE CASCADE ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table "mydb"."Bloqueio"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "Bloqueio" (
  "Status" BOOLEAN NOT NULL,
  "Data" DATE NOT NULL,
  "NUMERO" VARCHAR(16) NOT NULL,
  "ID_CLIENTE" INT NOT NULL,
  "COD_GERENCIA" VARCHAR(11) DEFAULT NULL,
  CONSTRAINT "fk_Bloqueio_Gerente" FOREIGN KEY ("COD_GERENCIA") REFERENCES "Gerente" ("COD_GERENCIA"),
  CONSTRAINT "fk_Bloqueio_Conta" FOREIGN KEY ("NUMERO") REFERENCES "Conta" ("NUMERO"), 
  CONSTRAINT "fk_Bloqueio_cliente" FOREIGN KEY ("ID_CLIENTE") REFERENCES "cliente" ("ID_CLIENTE")
);


-- -----------------------------------------------------
-- Enable triggers and constraints
SET session_replication_role = DEFAULT;


CREATE TABLE "agencia_possui_funcionario" (
    "status" BOOLEAN NOT NULL,
    "NUMERO_ag" VARCHAR(16) NOT NULL,
    "CPF_fun" number_cpf NOT NULL,
    CONSTRAINT "fk_numero_agencia" FOREIGN KEY ("NUMERO_ag") REFERENCES "agencia" ("NUMERO") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "fk_cpf_funcionario" FOREIGN KEY ("CPF_fun") REFERENCES "Funcionario" ("CPF") ON DELETE CASCADE ON UPDATE CASCADE
);

