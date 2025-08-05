-- Cria o banco de dados 'clinica_db' caso não exista
CREATE DATABASE IF NOT EXISTS clinica_db;

-- Seleciona o banco de dados para uso
use clinica_db;

--criacao das tabelas
CREATE TABLE enderecos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(255) NOT NULL,        -- Rua, Avenida, etc.
    numero VARCHAR(20),                      -- Pode ter "S/N", letras, etc.
    complemento VARCHAR(100),                -- Apto, bloco, sala, etc.
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(20) NOT NULL,
    pais VARCHAR(100) DEFAULT 'Brasil',      -- Permite internacionalização
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP  --acho um pouco desnecessario o DATETIME ele so vai informar a hora e dia que vc fez mais sei la tu que sabe
);

CREATE TABLE telefones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entidade_id INT NOT NULL,
    tipo ENUM('celular', 'fixo', 'comercial', 'whatsapp', 'outro') DEFAULT 'celular',
    numero VARCHAR(20) NOT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
);


CREATE TABLE IF NOT EXISTS clinica(
    id INT PRIMARY KEY AUTO_INCREMENT, 
    nome VARCHAR(250) NOT NULL,
    cnpj BIGINT(14),
    email VARCHAR(250) NOT NULL,
    endereco_id INT,
    telefone_id INT,
    FOREIGN KEY (endereco_id) REFERENCES enderecos(id),
    FOREIGN KEY (telefone_id) REFERENCES telefones(id)
);

CREATE TABLE IF NOT EXISTS candidatos_emprego (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf BIGINT NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    cargo_pretendido VARCHAR(100),
    curriculo_path VARCHAR(250), -- caminho do arquivo
    data_envio DATE DEFAULT CURRENT_DATE,
    status_candidatura VARCHAR(50) DEFAULT 'Em análise',
    telefone_id INT,
    FOREIGN KEY (telefone_id) REFERENCES telefones(id)
);

CREATE TABLE IF NOT EXISTS beneficio(
    id INT PRIMARY KEY AUTO_INCREMENT,
    valor DOUBLE,
    descricao VARCHAR(250) NOT NULL,
    nome VARCHAR(250) NOT NULL
);

CREATE TABLE IF NOT EXISTS departamento(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(250) NOT NULL,
    registro_proficional VARCHAR(250) NOT NULL,
    especialidade VARCHAR(250) NOT NULL
);

CREATE TABLE IF NOT EXISTS cargo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_cargo VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL,
    descricao VARCHAR(255),
    salario_base DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS funcionario_beneficiario(
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(250) NOT NULL,
    id_beneficiario INT,
    FOREIGN KEY (id_beneficiario) REFERENCES beneficio(id)
);

CREATE TABLE IF NOT EXISTS funcionario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(250) NOT NULL,
    estado_civil VARCHAR(50) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    sexo CHAR(1) NOT NULL,
    data_nascimento DATE NOT NULL,
    data_admissao DATE NOT NULL,
    email VARCHAR(150),
    salario DECIMAL(10,2),
    status ENUM('Ativo', 'Inativo') DEFAULT 'Ativo',
    id_departamento INT,
    id_cargo INT,
    endereco_id INT,
    telefone_id INT,
    FOREIGN KEY (telefone_id) REFERENCES telefones(id),
    FOREIGN KEY (endereco_id) REFERENCES enderecos(id),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id),
    FOREIGN KEY (id_cargo) REFERENCES cargo(id)
);

CREATE TABLE IF NOT EXISTS dependente(
    id INT PRIMARY KEY AUTO_INCREMENT,
    grau_parentesco VARCHAR(250) NOT NULL,
    data_nascimento INT,
    id_funcionario INT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS folha_pagamento(
    id INT PRIMARY KEY AUTO_INCREMENT,
    adicionais DOUBLE,
    descontos DOUBLE,
    salario_bruto DOUBLE,
    salario_liquido DOUBLE,
    data_pagamento DATETIME,
    id_funcionario INT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS advertencia(
    id INT PRIMARY KEY AUTO_INCREMENT,
    motivo VARCHAR(250) NOT NULL,
    tipo VARCHAR(250) NOT NULL,
    hora DATETIME,
    id_funcionario INT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS escala(
    carga_semanal INT,
    horario_entrada DATE,
    horario_saida DATE,
    turno VARCHAR(250) NOT NULL,
    descricao VARCHAR(250) NOT NULL,
    id_funcionario INT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS unidade(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(250) NOT NULL,
    id_clinica INT,
    FOREIGN KEY (id_clinica) REFERENCES clinica(id)
);


CREATE TABLE IF NOT EXISTS administrador(
    id INT PRIMARY KEY AUTO_INCREMENT,
    relatorio VARCHAR(250) NOT NULL,
    id_funcionario INT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS permissao_sistema(
    id INT PRIMARY KEY AUTO_INCREMENT,
    permissao VARCHAR(250) NOT NULL,
    id_funcionario INT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS relatorio_unidade(
    id INT PRIMARY KEY AUTO_INCREMENT,
    relatorio VARCHAR(250) NOT NULL,
    faturamento DOUBLE NOT NULL,
    id_unidade INT,
    FOREIGN KEY (id_unidade) REFERENCES unidade(id)
);

CREATE TABLE IF NOT EXISTS log_clinica(
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(250) NOT NULL,
    data_hora DATETIME,
    id_adm INT,
    FOREIGN KEY (id_adm) REFERENCES administrador(id)
);

CREATE TABLE IF NOT EXISTS gestao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    relatorio VARCHAR(250) NOT NULL,
    id_gestor INT,
    FOREIGN KEY (id_gestor) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS treinamento(
    id INT PRIMARY KEY AUTO_INCREMENT,
    carga_horaria DATETIME,
    nome_treinamento VARCHAR(250) NOT NULL,
    funcao VARCHAR(250) NOT NULL
);

CREATE TABLE IF NOT EXISTS funcionario_treinamento(
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_realizacao DATETIME,
    id_funcionario INT,
    id_treinamento INT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id),
    FOREIGN KEY (id_treinamento) REFERENCES treinamento(id)
);

CREATE TABLE IF NOT EXISTS funcionario_pj(
  id INT PRIMARY KEY AUTO_INCREMENT,
  relatorio VARCHAR(250) NOT NULL,
  funcao VARCHAR(250) NOT NULL,
  nome VARCHAR(250) NOT NULL,
  cnpj BIGINT(14),
  email VARCHAR(250) UNIQUE,
  telefone_id INT,
  FOREIGN KEY (telefone_id) REFERENCES telefones(id)
);

CREATE TABLE IF NOT EXISTS historico_salarial (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_recebido DATE NOT NULL,
    falta_pagar DECIMAL(10,2) DEFAULT 0.00,
    salario_total DECIMAL(10,2) NOT NULL,
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS observacao_medica (
    id INT PRIMARY KEY AUTO_INCREMENT,
    observacao VARCHAR(250) NOT NULL,
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

CREATE TABLE IF NOT EXISTS ferias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_comeco DATE NOT NULL,
    data_fim DATE NOT NULL,
    periodo_inicio DATE,
    periodo_fim DATE,
    status ENUM('Agendada', 'Em Andamento', 'Concluída') DEFAULT 'Agendada',
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);