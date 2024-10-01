/**
	author: 
	Pedro Henrique Santana Ribeiro RA: 3149865
	Nicollas Lirussi RA: 3151149

	date: 30/09/2024
**/

-- Tabelas 
CREATE TABLE tb_inquilino (
	id_inq INT PRIMARY KEY,
	inq_nome VARCHAR (50) NOT NULL,
	inq_cpf VARCHAR (11) NOT NULL,
	inq_valor_aluguel DECIMAL NOT NULL,
	inq_email VARCHAR (50) NOT NULL,
	inq_telefone VARCHAR (11) NOT NULL,
	inq_data_nascimento DATE NOT NULL
);

CREATE TABLE tb_imovel(
	id_imo INT PRIMARY KEY,
    id_pro INT NOT NULL,
    imo_endereco VARCHAR (60) NOT NULL,
    imo_tipo VARCHAR (20) NOT NULL,
    imo_valor_aluguel DECIMAL NOT NULL,
    imo_descricao VARCHAR (200) NOT NULL,
	FOREIGN KEY (id_pro) REFERENCES tb_proprietario (id_pro)
);

CREATE TABLE tb_proprietario (
	id_pro INT PRIMARY KEY,
    pro_nome VARCHAR (50) NOT NULL,
    pro_cpf VARCHAR (11) NOT NULL,
    pro_telefone VARCHAR (11) NOT NULL,
    pro_data_nascimento DATE NOT NULL,
    pro_email VARCHAR (50) NOT NULL
);

CREATE TABLE tb_contrato (
	id_con INT PRIMARY KEY,
	id_pro INT NOT NULL,
    id_inq INT NOT NULL,
	id_imo INT NOT NULL,
	con_data_inicio DATE NOT NULL,
	con_data_fim DATE NOT NULL,
	con_valor DECIMAL NOT NULL,
    FOREIGN KEY (id_pro) REFERENCES tb_proprietario (id_pro),
    FOREIGN KEY (id_inq) REFERENCES tb_inquilino (id_inq),
    FOREIGN KEY (id_imo) REFERENCES tb_imovel (id_imo)
);

CREATE TABLE tb_pagamento (
	id_pag INT PRIMARY KEY UNIQUE,
    id_con INT NOT NULL,
    pag_data_pagamento DATE NOT NULL,
    pag_valor_pago DECIMAL NOT NULL,
    pag_status VARCHAR (50),
    FOREIGN KEY (id_con) REFERENCES tb_contrato (id_con)
);

-- Inserts

INSERT INTO tb_proprietario (id_pro, pro_nome, pro_cpf, pro_telefone, pro_data_nascimento, pro_email)
VALUES
(1, 'Carlos Silva', '12345678901', '11999999999', '1980-05-15', 'carlos.silva@gmail.com'),
(2, 'Maria Oliveira', '98765432100', '11988888888', '1975-10-22', 'maria.oliveira@gmail.com');
INSERT INTO tb_inquilino (id_inq, inq_nome, inq_cpf, inq_valor_aluguel, inq_email, inq_telefone, inq_data_nascimento)
VALUES

(1, 'João Souza', '11122233344', 1500.00, 'joao.souza@gmail.com', '11977777777', '1990-06-30'),
(2, 'Ana Pereira', '55566677788', 2500.00, 'ana.pereira@gmail.com', '11966666666', '1985-12-15');
INSERT INTO tb_contrato (id_con, id_pro, id_inq, id_imo, con_data_inicio, con_data_fim, con_valor)
VALUES
(1, 1, 1, 1, '2023-01-01', '2024-01-01', 1500.00),
(2, 2, 2, 2, '2023-06-01', '2024-06-01', 2500.00);

INSERT INTO tb_contrato (id_con, id_pro, id_inq, id_imo, con_data_inicio, con_data_fim, con_valor)
VALUES
(1, 1, 1, 1, '2023-01-01', '2024-01-01', 1500.00),
(2, 2, 2, 2, '2023-06-01', '2024-06-01', 2500.00);

INSERT INTO tb_pagamento (id_pag, id_con, pag_data_pagamento, pag_valor_pago, pag_status)
VALUES
(1, 1, '2023-02-01', 1500.00, 'Pago'),
(2, 2, '2023-07-01', 2500.00, 'Pendente');

INSERT INTO tb_imovel (id_imo, id_pro, imo_endereco, imo_tipo, imo_valor_aluguel, imo_descricao)
VALUES
(1, 1, 'Rua A, 123', 'Apartamento', 1500.00, 'Apartamento de 2 quartos no centro.'),
(2, 2, 'Rua B, 456', 'Casa', 2500.00, 'Casa espaçosa com quintal.');


--Buscando imóveis que são do tipo 'Apartamento'
SELECT imo_endereco, imo_tipo 
FROM tb_imovel
WHERE imo_tipo = 'Apartamento';

--Buscando proprietários que possuem imóveis
-- e ordenando por ordem alfabética
SELECT 
pro.pro_nome AS nome, pro.pro_telefone AS telefone, 
imo.imo_tipo AS tipo_imovel, imo.imo_endereco AS endereco
FROM tb_imovel AS imo
INNER JOIN tb_proprietario AS pro 
ON pro.id_pro = imo.id_pro
ORDER BY nome ASC;

-- Buscando contratos que possuem valor inferior 
-- a R$2000,00
SELECT 
id_con AS contrato, 
con_valor AS valor_contrato 
FROM tb_contrato
WHERE con_valor < 2000.00;

--Buscando inquilinos por CPF
SELECT 
inq_nome AS nome,
inq_cpf AS cpf 
FROM tb_inquilino
WHERE inq_cpf = '11122233344';

--Trazendo a quantidade de contratos e a média dos valores
SELECT 
COUNT(id_con) quantidade_contratos,
AVG(con_valor) media_contratos
FROM tb_contrato;

--Trazendo inquilinos que possuem pagamentos pendentes
SELECT 
con.id_con,
inq.inq_nome AS nome,
inq.inq_cpf AS cpf,
pag.pag_data_pagamento AS data_pagamento,
pag.pag_status AS status
FROM tb_pagamento AS pag
INNER JOIN tb_contrato AS con ON con.id_con = pag.id_con
INNER JOIN tb_inquilino AS inq ON con.id_inq = inq.id_inq
WHERE pag.pag_status = 'Pendente';


