-- Deleta a database para criar uma nova em ambiente de testes - apenas utilizada durante a criação e inserção base
drop database if exists lanchonete;

-- Cria a database
create database lanchonete;

-- Criação da tabela de produtos do cardápio
CREATE TABLE lanchonete.produto_cardapio (
    codProduto INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    preco DECIMAL(6,2) NOT NULL,
    descricao VARCHAR(200),
    PRIMARY KEY (codProduto)
);

-- Inserção dos sanduíches na tabela de produtos do cardápio
insert into lanchonete.produto_cardapio(nome, preco, descricao)
	 values ('Sanduíche Simples', '21.90', 'Pão, hambúrguer artesanal, alface, tomate, maionese da casa e queijo mussarela.'),
	 	    ('Sanduíche Bacon', '25.90', 'Pão, hambúrguer artesanal, alface, tomate, bacon, maionese da casa e queijo mussarela.'),
	 	    ('Sanduíche Cheddar', '28.90', 'Pão, hambúrguer artesanal, alface, tomate, bacon, maionese da casa, cheddar e queijo mussarela.'),
	 	    ('Sanduíche Barbecue', '24.90', 'Pão, hambúrguer artesanal, alface, tomate, bacon, barbecue e queijo mussarela.'),
		    ('Sanduíche Chicken Crispy', '24.90', 'Pão, hambúrguer de frango crocante, alface, tomate, maionese da casa e queijo gouda.');

-- Criação da tabela de informações dos clientes
create table lanchonete.pessoa_cliente(
	codCliente int not null auto_increment,
    nome varchar(90) not null,
    telefone varchar(16) not null,
    endereco varchar(200) not null,
    logradouro varchar(100) not null,
    bairro varchar(50) not null,
    cidade varchar(50) not null,
    observacaoEndereco varchar(100),
    primary key(codCliente)
);

-- Inserção de informações sobre os clientes (cadastro)
insert into lanchonete.pessoa_cliente(nome, telefone, endereco, logradouro, bairro, cidade)
     values ('Leandro Thiago Peixoto', '41989311401', 'Rua Clodomiro Avelleda, 267, Campina do Siqueira, Curitiba', 'Rua Clodomiro Avelleda, 267', 'Campina do Siqueira', 'Curitiba'),
			('Jorge Marcos Barbosa', '41992100967', 'Rua Franciso Bronholo, 965, Tatuquara, Curitiba', 'Rua Franciso Bronholo, 965', 'Tatuquara', 'Curitiba'),
            ('Isabelly Sandra Caldeira', '41991953594', 'Jardinete Felipe Nievola, 559, Cabral, Curitiba', 'Jardinete Felipe Nievola, 559', 'Cabral', 'Curitiba'),
            ('Priscila Jaqueline Antonella da Costa', '41984782373', 'Rua Pedro Viriato de Souza, 325, Vista Alegre, Curitiba', 'Rua Pedro Viriato de Souza, 325', 'Vista Alegre', 'Curitiba');

-- Criação da tabela dos entregadores
create table lanchonete.pessoa_entregador(
	codEntregador int not null auto_increment,
    nome varchar(45) not null,
    telefone varchar(16) not null,
    primary key(codEntregador)
);

-- Inserção das informações sobre os entregadores cadastrados
insert into lanchonete.pessoa_entregador(nome, telefone)
	 values ('Arthur Carlos Eduardo Manoel Silva', '41989844761'),
	 	    ('Benjamin Heitor Diogo Peixoto', '41981175400'),
            ('Anthony Jorge Viana', '41989122119');

-- Criaçõ da tabela que informa as descrições das constantes de status de entrega
create table lanchonete.status_entrega(
	codStatus int,
    descricaoStatus varchar(45) not null,
    primary key(codStatus)
);

-- Inserção dos três tipos de status de entrega (tabela apenas de informação)
insert into lanchonete.status_entrega(codStatus, descricaoStatus)
 	 values (0, 'Em Preparação'),
            (1, 'Em Entrega'),
            (2, 'Entregue');

-- Criação da tabela dos pedidos
create table lanchonete.pedido(
	codPedido int not null auto_increment,
    codCliente int not null,
    dataEmissao datetime not null,
    codStatus int not null,
    codEntregador int not null,
    primary key(codPedido),
    foreign key(codCliente) references lanchonete.pessoa_cliente(codCliente),
    foreign key(codEntregador) references lanchonete.pessoa_entregador(codEntregador),
    foreign key(codStatus) references lanchonete.status_entrega(codStatus)
);

-- Criação de tabela para verificar informações sobre os pedidos
create table lanchonete.pedido_produto(
    codPedido int not null,
    codProduto int not null,
    quantidadeProduto int not null,
    observacaoPedido varchar(100),
    foreign key(codPedido) references lanchonete.pedido(codPedido),
    foreign key(codProduto) references lanchonete.produto_cardapio(codProduto)
);

-- Criação de view para ver informações sobre as entregas dos pedidos
create view lanchonete.v$pedido_entrega as
	select p.codPedido
		 , s.descricaoStatus as statusEntrega
		 , pc.nome as nomeCliente
		 , pc.telefone as telefoneCliente
		 , pc.endereco as enderecoCliente
		 , pe.nome as nomeEntregador
		 , pe.telefone as telefoneEntregador
	  from lanchonete.pedido p
	 inner join lanchonete.status_entrega s
		on s.codStatus = p.codStatus
	 inner join lanchonete.pessoa_cliente pc
		on pc.codCliente = p.codCliente
	 inner join lanchonete.pessoa_entregador pe
		on pe.codEntregador = p.codEntregador
	 where 1 = 1;

-- Criação de view para ver informações sobre os produtos dos pedidos
create view lanchonete.v$produto_entrega as
	select pp.codPedido
         , pc.codProduto
         , pc.nome as nomeProduto
         , pp.quantidadeProduto
         , pc.preco as precoUnitario
         , (pc.preco * pp.quantidadeProduto) as precoTotalProduto
         , pe.codEntregador
         , pe.nome as nomeEntregador
		 , s.codStatus
         , s.descricaoStatus as statusEntrega
	  from lanchonete.pedido_produto pp
	 inner join lanchonete.produto_cardapio pc
        on pc.codProduto = pp.codProduto
	 inner join lanchonete.pedido p
        on p.codPedido = pp.codPedido
	 inner join lanchonete.status_entrega s
		on s.codStatus = p.codStatus
	 inner join lanchonete.pessoa_entregador pe
		on pe.codEntregador = p.codEntregador
	 where 1 = 1;
     
-- Inserção de dados sobre cada pedido
insert into lanchonete.pedido(codCliente, dataEmissao, codStatus, codEntregador)
	 values (4, '2022-08-05 20:35:48', 2, 1),
		    (2, '2022-08-11 17:48:08', 2, 3),
            (1, '2022-08-21 14:45:37', 2, 2),
		    (4, '2022-08-24 18:30:00', 2, 1),
		    (1, sysdate(), 0, 2),
	 	    (2, sysdate(), 1, 3),
		    (3, sysdate(), 0, 2);

-- Inserção de dados sobre a quantidade e tipos de sanduíches em cada pedido
insert into lanchonete.pedido_produto(codPedido, codProduto, quantidadeProduto)
     values (1, 2, 2),
            (2, 1, 1),
            (2, 3, 1),
            (3, 5, 2),
            (3, 3, 1),
            (4, 4, 1),
            (5, 2, 2),
            (6, 4, 1),
            (6, 2, 1),
            (7, 3, 2),
            (7, 1, 1);
            
-- Montagem da Consulta para listar os pedidos em preparação (Utilizando select na tabela com join)
select p.*, s.descricaoStatus
  from lanchonete.pedido p
 inner join lanchonete.status_entrega s
    on s.codStatus = p.codStatus
 where p.codStatus = 0; -- em preparo
 
-- Montagem da Consulta para listar os pedidos em preparação (Utilizando select na view)
select pe.*
  from lanchonete.v$produto_entrega pe
 where pe.codStatus = 0;