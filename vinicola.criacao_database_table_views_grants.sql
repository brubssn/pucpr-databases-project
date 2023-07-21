-- Atividade Somativa 02 - Banco de Dados
-- Aluna: Bruna Batista Bassani

-- Deleta a database e o usuário para criar uma nova em ambiente de testes - apenas utilizada durante a criação e inserção base
drop database if exists vinicola;
drop user if exists sommelier@"localhost";

-- Cria a database
create database vinicola;

-- Cria o usuário Sommelier
create user sommelier@"localhost" with max_queries_per_hour 40;

-- Criação da tabela de regiões
CREATE TABLE vinicola.regiao (
    codRegiao BIGINT NOT NULL AUTO_INCREMENT,
    nomeRegiao VARCHAR(100) NOT NULL,
    descricaoRegiao TEXT,
    PRIMARY KEY(codRegiao)
);

-- Inserção de dados sobre as regiões
insert into vinicola.regiao(nomeRegiao, descricaoRegiao)
	 values ('Valle Central', 'Valle Central, Chile'),
            ('Bordeaux', 'Bordeaux, França'),
            ('Toscana', 'Toscana, Itália'),
            ('Mendoza', 'Mendoza, Argentina'),
            ('Marlborough', 'Marlborough, Nova Zelândia');

-- Criação da tabela de vinícolas
CREATE TABLE vinicola.vinicola (
    codVinicola BIGINT NOT NULL AUTO_INCREMENT,
    nomeVinicola VARCHAR(100) NOT NULL,
    descricaoVinicula TEXT,
    foneVinicola VARCHAR(15),
    emailVinicola VARCHAR(15),
    codRegiao BIGINT,
    PRIMARY KEY(codVinicola),
    FOREIGN KEY(codRegiao) references vinicola.regiao(codRegiao)
);

-- Inserção de dados sobre as vinícolas
-- Informo que, como o tamanho especificado para o campo emailVinicola é muito pequeno, optei por deixar os campos nulos
insert into vinicola.vinicola(nomeVinicola, descricaoVinicula, foneVinicola, emailVinicola, codRegiao)
	 values -- Valle Central
            ('Viña del Triunfo', 'Vinhedos localizados no Valle Central, Villa Alegre.', null, null, 1),
            -- Bordeaux
            ('Cru Classé (Médoc/Graves)', 'Vinhedos próprios localizados na denominação de Pauillac, com baixos rendimentos.', null, null, 2),
            ('Deuxième Vin', 'Vinhedos localizados no sul da denominação de Pauillac, com produção de uvas sadias e muito concentradas.', '+330556731550', null, 2),
            -- Toscana
            ('Piccini', 'Vinhedo localizado no coração do Chianti Classico no sul de Florenze.', '+39057754011', null, 3),
            ('Castellare Di Castellina', 'Vinhedos com vinhas de 20 anos de idade localizados na região de Castellina, Chianti.', '+390577742903', null, 3),
            -- Mendoza
            ('La Posta (Laura Catena)', 'Uvas provenientes de vinhedos localizados na região de Tupungato, Vale do Uco. 1000mts de Altitude.', null, null, 4),
            ('Luca (Laura Catena)', 'Vinhedos Ugarteche, Altamira, Vista Flores, com vinhas de 53 anos de idade, plantadas em altitude elevada na região de Mendoza.', null, null, 4),
            -- Marlborough
            ('Oyster Bay', 'Localizados nos vales de Wairau e Awatere.', null, null, 5);

-- Criação da tabela de vinhos
CREATE TABLE vinicola.vinho (
    codVinho BIGINT NOT NULL AUTO_INCREMENT,
    nomeVinho VARCHAR(50) NOT NULL,
    tipoVinho VARCHAR(30) NOT NULL,
    anoVinho INT NOT NULL,
    descricaoVinho TEXT,
    codVinicola BIGINT,
    PRIMARY KEY(codVinho),
    FOREIGN KEY(codVinicola) references vinicola.vinicola(codVinicola)
);

-- Permite o acesso para o usuário Sommelier realizar consultas na tabela de vinhos
grant select on vinicola.vinho to sommelier@"localhost";

-- Inserção de dados sobre os vinhos
insert into vinicola.vinho(nomeVinho, tipoVinho, anoVinho, descricaoVinho, codVinicola)
	 values -- Viña del Triunfo - Valle Central
            ('Trofeo', 'Sauvignon Blanc', 2019, 'Branco, 100% Sauvignon Blanc', 1),
            ('Trofeo', 'Merlot', 2019, 'Tinto, 100% Merlot', 1),
            ('Apice', 'Chardonnay', 2019, 'Branco, 100% Chardonnay', 1),
            ('Apice', 'Carmenère', 2021, 'Tinto, 100% Carmenère', 1),
            -- Cru Classé (Médoc/Graves) - Bordeaux
            ('Chateau Haut Batailley', 'Blend', 2008, 'Tinto, 70% Cabernet Sauvignon, 25% Merlot, 3% Cabernet Franc e 2% Petit Verdot', 2),
            ('Château La Lagune', 'Blend', 2007, 'Tinto, 60% Cabernet Sauvignon, 25% Merlot e 15% Petit Verdot', 2),
            -- Deuxième Vin - Bordeaux
            ('Reserve de la Comtesse', 'Blend', 2007, 'Tinto, 61% Cabernet Sauvignon, 32% Merlot, 4% Cabernet Franc e 3% Petit Verdot', 3),
            ('Les Pagodes de Cos', 'Blend', 2002, 'Tinto, 55% Cabernet Sauvignon e 45% Merlot', 3),
            -- Piccini  - Toscana
            ('Sasso Al Poggio Rosso Toscana', 'Blend', 2017, 'Tinto, 60% Sangiovese, 20% Merlot e 20% Cabernet Sauvignon', 4),
            ('Brunello di Montalcino Villa al Cortile', 'Sangiovese', 2016, 'Tinto, 100% Sangiovese', 4),
            -- Castellare Di Castellina  - Toscana
            ('Chianti Classico Riserva', 'Blend', 2017, 'Tinto, 95% Sangiovese e 5% Canaiolo', 5),
            ('Coniale Toscana', 'Cabernet Sauvignon', 2015, 'Tinto, 100% Cabernet Sauvignon', 5),
            -- La Posta (Laura Catena)  - Mendoza
            ('La Posta Rosé Malbec', 'Rosé Malbec', 2021, 'Rosado, 100% Malbec', 6),
            ('La Posta Glorieta Pinot Noir', 'Pinot Noir', 2020, 'Tinto, 100% Pinot Noir', 6),
            -- Luca (Laura Catena)  - Mendoza
            ('Luca Syrah', 'Syrah', 2017, 'Tinto, 100% Syrah', 7),
            ('Luca Chardonnay', 'Chardonnay', 2019, 'Branco, 100% Chardonnay', 7),
            -- Oyster Bay  - Marlborough
            ('Oyster Bay Marlborough', 'Pinot Noir', 2016, 'Tinto, 100% Pinot Noir', 8);
            
-- Criação de view com consulta que lista o nome e ano dos  vinhos, incluindo o nome da vinícula e o nome da região que ela pertence
create view vinicola.v$vinho_vinicola as
	select uv.nomeVinho
		 , uv.anoVinho
		 , vn.nomeVinicola
		 , vr.nomeRegiao
	  from vinicola.vinho uv
	 inner join vinicola.vinicola vn
		on vn.codVinicola = uv.codVinicola
	 inner join vinicola.regiao vr
		on vr.codRegiao = vn.codRegiao
	 where 1 = 1;

-- Criação de view com consulta que lista apenas o código e o nome das vinícolas
create view vinicola.v$vinicola as
	select vn.codVinicola
		 , vn.nomeVinicola
	  from vinicola.vinicola vn
	 where 1 = 1;

-- Permite o acesso para o usuário Sommelier realizar consultas na view de vinícolas
grant select on vinicola.v$vinicola to sommelier@"localhost";
