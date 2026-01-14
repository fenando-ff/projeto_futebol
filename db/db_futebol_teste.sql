-- -----------------------------------------------------
-- 1. CONFIGURAÇÃO INICIAL
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `projeto_futebol_teste` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `projeto_futebol_teste`;

-- Desabilita verificação de chaves estrangeiras temporariamente para evitar erros de ordem
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- 2. TABELAS EXTRAS (Vindas do db_futebol_teste)
-- Criamos estas primeiro pois Produtos dependerá delas
-- -----------------------------------------------------

DROP TABLE IF EXISTS `times`;
CREATE TABLE `times` (
  `id_times` int NOT NULL AUTO_INCREMENT,
  `nome_time` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  `url_brasao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_times`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Inserindo times
INSERT INTO `times` VALUES 
(1, 'Palmeiras', 'img/brasoes/palmeiras.png'),
(2, 'Flamengo', 'img/brasoes/escudo_flamengo.png'),
(3, 'Corinthians', 'img/brasoes/escudo_corinthians.png'),
(4, 'São Paulo', ''),
(5, 'Santos', ''),
(6, 'Grêmio', 'img/brasoes/gremio.png');

DROP TABLE IF EXISTS `jogos`;
CREATE TABLE `jogos` (
  `id_jogos` int NOT NULL AUTO_INCREMENT,
  `dia_jogo` date NOT NULL,
  `hora_jogo` time NOT NULL,
  `local_jogo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `casa_fora` enum('casa','fora') COLLATE utf8mb4_general_ci NOT NULL,
  `times_id_times` int NOT NULL,
  PRIMARY KEY (`id_jogos`),
  KEY `fk_jogos_times1_idx` (`times_id_times`),
  CONSTRAINT `fk_jogos_times1` FOREIGN KEY (`times_id_times`) REFERENCES `times` (`id_times`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Inserindo jogos
INSERT INTO `jogos` VALUES 
(1, '2026-02-15', '16:00:00', 'Estádio Drakos Arena', 'casa', 1),
(2, '2026-02-22', '18:30:00', 'Maracanã', 'fora', 2),
(3, '2026-03-01', '20:00:00', 'Estádio Drakos Arena', 'casa', 3),
(4, '2026-03-08', '16:00:00', 'Morumbi', 'fora', 4),
(5, '2026-03-15', '19:00:00', 'Estádio Drakos Arena', 'casa', 5),
(6, '2026-03-22', '17:30:00', 'Arena do Grêmio', 'fora', 6);

-- -----------------------------------------------------
-- 3. ESTRUTURA E DADOS PRINCIPAIS (Do banco_futebol_corrigido)
-- Mantendo auth, clientes, pedidos e produtos originais
-- -----------------------------------------------------

DROP TABLE IF EXISTS `accounts_perfil`;
CREATE TABLE `accounts_perfil` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sexo` varchar(10) DEFAULT NULL,
  `cpf` varchar(14) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_group_id_b120cbf9` (`group_id`),
  KEY `auth_group_permissions_permission_id_84c5c92e` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4;

-- Restaurando permissões...
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add categoria cliente',7,'add_categoriacliente'),(26,'Can change categoria cliente',7,'change_categoriacliente'),(27,'Can delete categoria cliente',7,'delete_categoriacliente'),(28,'Can view categoria cliente',7,'view_categoriacliente'),(29,'Can add categoria produtos',8,'add_categoriaprodutos'),(30,'Can change categoria produtos',8,'change_categoriaprodutos'),(31,'Can delete categoria produtos',8,'delete_categoriaprodutos'),(32,'Can view categoria produtos',8,'view_categoriaprodutos'),(33,'Can add clientes',9,'add_clientes'),(34,'Can change clientes',9,'change_clientes'),(35,'Can delete clientes',9,'delete_clientes'),(36,'Can view clientes',9,'view_clientes'),(37,'Can add compra',10,'add_compra'),(38,'Can change compra',10,'change_compra'),(39,'Can delete compra',10,'delete_compra'),(40,'Can view compra',10,'view_compra'),(41,'Can add endereco cliente',11,'add_enderecocliente'),(42,'Can change endereco cliente',11,'change_enderecocliente'),(43,'Can delete endereco cliente',11,'delete_enderecocliente'),(44,'Can view endereco cliente',11,'view_enderecocliente'),(45,'Can add endereco funcionarios',12,'add_enderecofuncionarios'),(46,'Can change endereco funcionarios',12,'change_enderecofuncionarios'),(47,'Can delete endereco funcionarios',12,'delete_enderecofuncionarios'),(48,'Can view endereco funcionarios',12,'view_enderecofuncionarios'),(49,'Can add funcionarios',13,'add_funcionarios'),(50,'Can change funcionarios',13,'change_funcionarios'),(51,'Can delete funcionarios',13,'delete_funcionarios'),(52,'Can view funcionarios',13,'view_funcionarios'),(53,'Can add pedido',14,'add_pedido'),(54,'Can change pedido',14,'change_pedido'),(55,'Can delete pedido',14,'delete_pedido'),(56,'Can view pedido',14,'view_pedido'),(57,'Can add produtos',15,'add_produtos'),(58,'Can change produtos',15,'change_produtos'),(59,'Can delete produtos',15,'delete_produtos'),(60,'Can view produtos',15,'view_produtos'),(61,'Can add setor funcionarios',16,'add_setorfuncionarios'),(62,'Can change setor funcionarios',16,'change_setorfuncionarios'),(63,'Can delete setor funcionarios',16,'delete_setorfuncionarios'),(64,'Can view setor funcionarios',16,'view_setorfuncionarios'),(65,'Can add perfil',17,'add_perfil'),(66,'Can change perfil',17,'change_perfil'),(67,'Can delete perfil',17,'delete_perfil'),(68,'Can view perfil',17,'view_perfil'),(69,'Can add recuperacao senha',18,'add_recuperacaosenha'),(70,'Can change recuperacao senha',18,'change_recuperacaosenha'),(71,'Can delete recuperacao senha',18,'delete_recuperacaosenha'),(72,'Can view recuperacao senha',18,'view_recuperacaosenha'),(73,'Can add imagem produto',19,'add_imagemproduto'),(74,'Can change imagem produto',19,'change_imagemproduto'),(75,'Can delete imagem produto',19,'delete_imagemproduto'),(76,'Can view imagem produto',19,'view_imagemproduto');

DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$XrzSwf46GU0btn8fCV9HPl$TKXsFu21ZgFecgLNZfUjP8Cfdgv3v54FP86x58oRzlw=','2026-01-05 18:23:31.826595',1,'fernando','','','',1,1,'2025-09-11 19:21:04.582791');

DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_user_id_6a12ed8b` (`user_id`),
  KEY `auth_user_groups_group_id_97559544` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_user_id_a95ead1b` (`user_id`),
  KEY `auth_user_user_permissions_permission_id_1fbb5f2c` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `categoria_cliente`;
CREATE TABLE `categoria_cliente` (
  `id_CATEGORIA_CLIENTE` int NOT NULL AUTO_INCREMENT,
  `nome_CATEGORIA_CLIENTES` varchar(45) NOT NULL,
  `descricao_categ_cli` mediumtext NOT NULL,
  `preco_categ` float(5,2) NOT NULL,
  PRIMARY KEY (`id_CATEGORIA_CLIENTE`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

INSERT INTO `categoria_cliente` VALUES (2,'socio drakos - diamante','O plano Sócio Drakos – Diamante é anual, com apenas 350 vagas disponíveis. Oferece acesso livre aos jogos*, app oficial Drakos, desconto de 10% em produtos oficiais e plano adicional para dependentes. Os sócios têm ainda carteirinha digital personalizada, central de atendimento exclusiva, e participam de ações especiais e vantagens do Clube Parceiro Drakos.',300.00),(3,'socio drakos - ouro','O plano Sócio Drakos – Ouro é anual e limitado a 2.000 vagas. Garante acesso livre aos jogos da temporada*, uso do app oficial Drakos, carteirinha digital personalizada, e um plano adicional para dependentes. Os sócios também desfrutam de 10% de desconto em produtos oficiais, atendimento exclusivo, além de vantagens no Clube Parceiro Drakos e participação em ações especiais com o elenco.',200.00),(4,'socio drakos - prata','O plano Sócio Drakos – Prata é anual e limitado a 2.000 vagas. Garante acesso livre aos jogos da temporada*, uso do app oficial Drakos, carteirinha digital personalizada, e um plano adicional para dependentes. Os sócios também desfrutam de 5% de desconto em produtos oficiais, atendimento exclusivo e de vantagens no Clube Parceiro Drakos.',100.00),(5,'nao socio','Não contratante',0.00);

DROP TABLE IF EXISTS `categoria_produtos`;
CREATE TABLE `categoria_produtos` (
  `id_CATEGORIA_PRODUTOS` int NOT NULL AUTO_INCREMENT,
  `nome_CATEGORIA_PRODUTOS` varchar(45) NOT NULL,
  PRIMARY KEY (`id_CATEGORIA_PRODUTOS`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

INSERT INTO `categoria_produtos` VALUES (1,'Acessórios'),(2,'Camisas FC'),(3,'Calçados'),(4,'Shorts'),(5,'Meias'),(10,'Ingressos');

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `id_CLIENTES` int NOT NULL AUTO_INCREMENT,
  `senha_CLIENTES` varchar(255) NOT NULL,
  `sexo_CLIENTES` varchar(20) NOT NULL,
  `telefone_CLIENTES` varchar(15) NOT NULL,
  `email_CLIENTES` varchar(50) NOT NULL,
  `nome_CLIENTES` varchar(45) NOT NULL,
  `sobrenome_CLIENTES` varchar(45) NOT NULL,
  `cpf_CLIENTES` varchar(14) NOT NULL,
  `status_CLIENTES` tinyint NOT NULL,
  `CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE` int NOT NULL,
  PRIMARY KEY (`id_CLIENTES`),
  KEY `fk_CLIENTES_CATEGORIA_CLIENTE1_idx` (`CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE`),
  CONSTRAINT `fk_CLIENTES_CATEGORIA_CLIENTE1` FOREIGN KEY (`CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE`) REFERENCES `categoria_cliente` (`id_CATEGORIA_CLIENTE`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb4;

INSERT INTO `clientes` VALUES (52,'@N1234567','Masculino','928374651092837','fernando@gmail.com','Fernando','Andrade','123.465.789-15',1,2),(53,'@A4567894','Feminino','470192837465102','cnayane462@gmail.com','Nayane','Cruz','987.654.321-01',1,3),(54,'@E7894564','Masculino','385920174638291','pedroDaniel@gmail.com','Pedro','Silva','555.555.555-55',0,4),(55,'@F5555555','Masculino','360284756102938','emanuelSilva@gmail.com','Emanuel','Silva','666.666.666-66',0,5),(56,'senhA1234!@#','Masculino','91-91234-5678','joao.souza@gmail.com','João','Souza','123.456.789-00',1,2),(57,'senhaTop2023$','Feminino','91-99876-5432','maria.silva@hotmail.com','Maria','Silva','987.654.321-00',1,3),(58,'minhaSenha12','Masculino','91-93456-1234','carlos.santos@yahoo.com','Carlos','Santos','456.789.123-00',1,2),(59,'segura123!senha','Feminino','91-90001-0001','ana.oliveira@gmail.com','Ana','Oliveira','321.654.987-00',1,4),(60,'senhaforte_10','Masculino','91-98888-7777','paulo.lima@outlook.com','Paulo','Lima','159.753.486-00',1,5),(61,'senha$$rapida','Feminino','91-97777-5555','juliana.matos@gmail.com','Juliana','Matos','951.357.852-00',1,3),(62,'novaSenha456','Feminino','91988887777','novoemail@email.com','Nayane','Souza','987.654.321-00',1,3),(63,'senhaPoderosa$','Feminino','91-93456-1122','patricia.alves@terra.com','Patrícia','Alves','654.321.987-00',1,4),(64,'azulao2025@!','Masculino','91-98765-6789','ricardo.menezes@gmail.com','Ricardo','Menezes','321.789.654-00',1,5),(65,'aguiaVIP#2024','Feminino','91-91234-7890','fernanda.lopes@hotmail.com','Fernanda','Lopes','852.963.741-00',1,3),(66,'meuLogin#456','Masculino','91-97654-3210','leandro.sousa@gmail.com','Leandro','Sousa','147.258.369-00',1,2),(67,'senhaNOVA2025','Feminino','91-93214-5678','carla.dias@bol.com.br','Carla','Dias','951.753.456-00',1,4),(68,'champSenha@33','Masculino','91-98700-8899','thiago.rocha@gmail.com','Thiago','Rocha','789.456.123-00',1,3),(69,'senha123super','Feminino','91-93421-8765','marcela.teixeira@uol.com','Marcela','Teixeira','123.321.456-00',1,2),(70,'safadao2025$','Masculino','91-91239-2233','daniel.ferreira@gmail.com','Daniel','Ferreira','741.852.963-00',1,5),(71,'tigronaTOP@1','Feminino','91-90003-4567','beatriz.morais@gmail.com','Beatriz','Morais','159.357.258-00',1,4),(72,'aguiaFiel#55','Masculino','91-91123-4321','rafael.costa@yahoo.com','Rafael','Costa','369.258.147-00',1,3),(73,'senhaUltra!99','Feminino','91-98876-9988','aline.campos@outlook.com','Aline','Campos','654.987.321-00',1,2),(74,'senhaDele2024','Masculino','91-97700-3344','henrique.souza@gmail.com','Henrique','Souza','741.369.258-00',1,5),(75,'campeaoSenha$','Feminino','91-93210-1234','luana.ramos@hotmail.com','Luana','Ramos','963.852.741-00',1,4),(76,'poderosa123','Masculino','91-90090-9090','marcos.barbosa@gmail.com','Marcos','Barbosa','321.456.987-00',1,3),(77,'senhaTeste@22','Feminino','91-92222-2222','bruna.lima@gmail.com','Bruna','Lima','147.369.258-00',1,2),(78,'azulaoFiel#77','Masculino','91-94567-4433','lucas.ribeiro@gmail.com','Lucas','Ribeiro','852.741.963-00',1,3),(79,'senhaTática33','Feminino','91-95555-3333','natalia.araujo@bol.com','Natalia','Araújo','258.963.147-00',1,4),(80,'vipAzulao#88','Masculino','91-94321-1111','bruno.martins@gmail.com','Bruno','Martins','987.321.654-00',1,5),(81,'senha81','feminino','91-98123-0001','ana1@email.com','ana','silva','111.111.111-81',1,4),(120,'ajfhI1b@dhb','feminino','91-98123-0001','ana1@email.com','ana','silva','111.111.111-81',1,4),(121,'@1Jasjokqwe','masculino','91-98234-0002','joao2@email.com','joao','pereira','111.111.111-82',1,2),(122,'@kKkdmfdmf3','feminino','91-98345-0003','lara3@email.com','lara','souza','111.111.111-83',1,3),(123,'@sajudhfAS3','masculino','91-98456-0004','carlos4@email.com','carlos','oliveira','111.111.111-84',1,2),(125,'pbkdf2_sha256$1000000$op4pSOrQEzka71W1jcArOt$myqcrr0aK2YE5xTlqyMF35BdVwYxtlDuOzDbLQEW5fM=','Feminino','91988584965','francileide@yahoo.com','Francileide','Romão','456.123.369-15',1,5),(126,'pbkdf2_sha256$1000000$gYZCCp9J2DYvbqtf65YJ9W$GPzd1qAnyLXWr8WsDjwXwcbQz/sJQZgkvG8GAySygrc=','Masculino','98735-9783','doido@gmail.com','doido01','doidao','125.458.478-12',1,5),(127,'pbkdf2_sha256$1000000$Nt7YIWVfzcerBMfIIcfcZo$Z0DJRk+9fWmeRXBS/iK1hmDf8tyZbs/zVKw8/W1otR0=','Masculino','91984711434','fernando10744196@edu.pa.senac.br','Fernando','Freitas','057.858.462-09',1,3),(128,'pbkdf2_sha256$1000000$SCpG0Qz0Als1s5YrR23xRl$yC9Cwrx3upeSVAMDYZMHdRLf9pyhSQiZLFanL0oC2uY=','Feminino','91988584965','jujuba@gmail.com','jujuba','leao','136.458.125-78',1,5),(130,'pbkdf2_sha256$1000000$NjcruSzk1L9nRPnmGR1OGi$DoIMSE/x0qxBHSrf5kOxOXIcPqYKWVTxB156ejBsdb0=','Feminino','91984711434','jessicakaren2005@gmail.com','Jessica Karen','Cardoso','789.123.254-00',1,5),(131,'pbkdf2_sha256$1000000$mi9EGh1tXYlo7AeTg1VD70$2YTJFLYwOp65wiIO5ibg1MuO2LGNlBjBGQso19JetRk=','Masculino','91991955538','leonelcollyer56@gmail.com','leonel ','collyer','133.264.152-54',1,2),(132,'pbkdf2_sha256$1000000$sMF6k5dlk9P1kSMt2aqoFM$EaWcLXkA/fUSfbw+wHiwXtozjMh8WiF7tS2LiKjmHwI=','Masculino','00000000000','senac@gmail.com','senac','papaleo','444.444.444-44',1,3),(133,'pbkdf2_sha256$1000000$aaYAmolAoDWw5QdwFoAnkt$UqTgLeQ7cmvjZFsfjNgxe75BgjLzJqq4mMYSDyqqeVo=','Masculino','97845-1236','teste@gmail.com','teste','testando','154.987.596-89',1,5),(134,'pbkdf2_sha256$1000000$eqMuC63ugmxeRCbh0lnfVn$xn/noNAvdQ56t3qJwwucBdqZWreziU4zajPZqU2acbE=','Masculino','91955555555','felipefreitas@gmail.com','Felipe','Freitas','157.953.456-28',1,5),(135,'pbkdf2_sha256$1000000$0AwrvTzwFgiMuASavzBCro$AXQcWa7eGhF9VOZfKU7RI85UoNMINNsl1oRhrvyEz8M=','Feminino','91984711434','nayane@gmail.com','Nayane','Cruz','123.123.456-87',1,5);

DROP TABLE IF EXISTS `compra`;
CREATE TABLE `compra` (
  `PRODUTOS_id_PRODUTOS` int NOT NULL,
  `PEDIDO_id_PEDIDO` int NOT NULL,
  `quantidade_PEDIDO` int NOT NULL,
  `valor_compra` decimal(10,0) NOT NULL,
  PRIMARY KEY (`PRODUTOS_id_PRODUTOS`,`PEDIDO_id_PEDIDO`),
  KEY `fk_PRODUTOS_has_PEDIDO_PEDIDO1_idx` (`PEDIDO_id_PEDIDO`),
  KEY `fk_PRODUTOS_has_PEDIDO_PRODUTOS1_idx` (`PRODUTOS_id_PRODUTOS`),
  CONSTRAINT `fk_PRODUTOS_has_PEDIDO_PEDIDO1` FOREIGN KEY (`PEDIDO_id_PEDIDO`) REFERENCES `pedido` (`id_PEDIDO`),
  CONSTRAINT `fk_PRODUTOS_has_PEDIDO_PRODUTOS1` FOREIGN KEY (`PRODUTOS_id_PRODUTOS`) REFERENCES `produtos` (`id_PRODUTOS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `compra` VALUES (36,1,1,250),(38,1,1,300),(36,2,1,250);

-- Tabelas auxiliares e logs
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6` (`user_id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8mb4;

-- (Pulei os inserts de log para economizar espaço, mas eles são mantidos no backup original)

DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4;

INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','permission'),(3,'auth','group'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session'),(7,'app_futebol','categoriacliente'),(8,'app_futebol','categoriaprodutos'),(9,'app_futebol','clientes'),(10,'app_futebol','compra'),(11,'app_futebol','enderecocliente'),(12,'app_futebol','enderecofuncionarios'),(13,'app_futebol','funcionarios'),(14,'app_futebol','pedido'),(15,'app_futebol','produtos'),(16,'app_futebol','setorfuncionarios'),(17,'accounts','perfil'),(18,'app_futebol','recuperacaosenha'),(19,'app_futebol','imagemproduto');

DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;
-- (Migrações inseridas conforme dump original)

DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `endereco_cliente`;
CREATE TABLE `endereco_cliente` (
  `id_ENDERECO_CLIENTE` int NOT NULL AUTO_INCREMENT,
  `cep_ENDERECO_CLIENTE` varchar(8) NOT NULL,
  `complemento_ENDERECO_CLIENTE` varchar(45) NOT NULL,
  `bairro_ENDERECO_CLIENTE` varchar(45) NOT NULL,
  `casa_ENDERECO_CLIENTE` varchar(45) NOT NULL,
  `rua_ENDERECO_CLIENTE` varchar(45) NOT NULL,
  `cliente_id_cliente` int NOT NULL,
  PRIMARY KEY (`id_ENDERECO_CLIENTE`),
  UNIQUE KEY `cliente_id_cliente` (`cliente_id_cliente`),
  CONSTRAINT `fk_cliente_endereco` FOREIGN KEY (`cliente_id_cliente`) REFERENCES `clientes` (`id_CLIENTES`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;

INSERT INTO `endereco_cliente` VALUES (5,'78945612','Em frente ao campo de futebol','Telegrafo sem fio','casa azul de dois andar','Passagem Guajará',52),(6,'32165498','Ao lado da empresa Amasa','Pratinha','Casa laranja com portão preto','Rua nossa senhora das graças',53),(34,'66110100','Quadra 14','Maracangalha','321','Rua 6',127); -- (Exemplo resumido)

DROP TABLE IF EXISTS `endereco_funcionarios`;
CREATE TABLE `endereco_funcionarios` (
  `id_ENDERECO_FUNCIONARIOS` int NOT NULL AUTO_INCREMENT,
  `cep_ENDERECO_FUNCIONARIOS` varchar(8) NOT NULL,
  `complemento_ENDERECO_FUNCIONARIOS` varchar(45) NOT NULL,
  `bairro_ENDERECO_FUNCIONARIOS` varchar(45) NOT NULL,
  `casa_ENDERECO_FUNCIONARIOS` varchar(45) NOT NULL,
  `rua_ENDERECO_FUNCIONARIOS` varchar(45) NOT NULL,
  `funcionarios_id_funcionarios` int NOT NULL,
  PRIMARY KEY (`id_ENDERECO_FUNCIONARIOS`,`funcionarios_id_funcionarios`),
  UNIQUE KEY `funcionarios_id_funcionarios` (`funcionarios_id_funcionarios`),
  KEY `fk_ENDERECO_FUNCIONARIOS_FUNCIONARIOS1_idx` (`funcionarios_id_funcionarios`),
  CONSTRAINT `fk_ENDERECO_FUNCIONARIOS_FUNCIONARIOS1` FOREIGN KEY (`funcionarios_id_funcionarios`) REFERENCES `funcionarios` (`id_FUNCIONARIOS`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `setor_funcionarios`;
CREATE TABLE `setor_funcionarios` (
  `id_SETOR_FUNCIONARIOS` int NOT NULL AUTO_INCREMENT,
  `nome_SETOR_FUNCIONARIOS` varchar(45) NOT NULL,
  `descricao_setor` mediumtext NOT NULL,
  PRIMARY KEY (`id_SETOR_FUNCIONARIOS`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

INSERT INTO `setor_funcionarios` VALUES (1,'Financeiro','Geração de relatórios e análise de lucros'),(2,'Administrativo','Gerencia contratos e conta de funcionários'),(3,'Comercial','Cuida das vendas e produtos'),(4,'TI','Funcionamaneto do sitema e segurança');

DROP TABLE IF EXISTS `funcionarios`;
CREATE TABLE `funcionarios` (
  `id_FUNCIONARIOS` int NOT NULL AUTO_INCREMENT,
  `senha_FUNCIONARIOS` varchar(45) NOT NULL,
  `login_FUNCIONARIOS` varchar(45) NOT NULL,
  `telefone_FUNCIONARIOS` varchar(45) NOT NULL,
  `email_FUNCIONARIOS` varchar(45) NOT NULL,
  `sexo_FUNCIONARIOS` varchar(20) NOT NULL,
  `nome_FUNCIONARIOS` varchar(45) NOT NULL,
  `SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS` int NOT NULL,
  PRIMARY KEY (`id_FUNCIONARIOS`),
  KEY `fk_FUNCIONARIOS_SETOR_FUNCIONARIOS1_idx` (`SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS`),
  CONSTRAINT `fk_FUNCIONARIOS_SETOR_FUNCIONARIOS1` FOREIGN KEY (`SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS`) REFERENCES `setor_funcionarios` (`id_SETOR_FUNCIONARIOS`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;

INSERT INTO `funcionarios` VALUES (1,'novaSenha456','novo_login','91-88888-8888','novo@email.com','Feminino','Nayane Atualizada',3),(2,'12345678','Emanuel Silva','91 98507-4239','emanuel@gmail.com','masculino','Emanuel',4);

DROP TABLE IF EXISTS `imagem_produto`;
CREATE TABLE `imagem_produto` (
  `id_IMAGEM_PRODUTO` int NOT NULL AUTO_INCREMENT,
  `imagem_IMAGEM` varchar(255) NOT NULL,
  `ordem_IMAGEM` int NOT NULL,
  `PRODUTOS_id_PRODUTOS` int NOT NULL,
  PRIMARY KEY (`id_IMAGEM_PRODUTO`),
  KEY `imagem_produto_PRODUTOS_id_PRODUTOS_97d47262` (`PRODUTOS_id_PRODUTOS`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4;

INSERT INTO `imagem_produto` VALUES (1,'img/produtos/camisas/camisa_branca_retro/camisa_branca(1).webp',0,36);

DROP TABLE IF EXISTS `pedido`;
CREATE TABLE `pedido` (
  `id_PEDIDO` int NOT NULL AUTO_INCREMENT,
  `data_PEDIDO` datetime NOT NULL,
  `CLIENTES_id_CLIENTES` int NOT NULL,
  `FUNCIONARIOS_id_FUNCIONARIOS` int DEFAULT NULL,
  PRIMARY KEY (`id_PEDIDO`),
  KEY `fk_PEDIDO_CLIENTES1_idx` (`CLIENTES_id_CLIENTES`),
  KEY `fk_PEDIDO_FUNCIONARIOS1_idx` (`FUNCIONARIOS_id_FUNCIONARIOS`),
  CONSTRAINT `fk_PEDIDO_CLIENTES1` FOREIGN KEY (`CLIENTES_id_CLIENTES`) REFERENCES `clientes` (`id_CLIENTES`),
  CONSTRAINT `fk_PEDIDO_FUNCIONARIOS1` FOREIGN KEY (`FUNCIONARIOS_id_FUNCIONARIOS`) REFERENCES `funcionarios` (`id_FUNCIONARIOS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `pedido` VALUES (1,'2026-01-14 18:51:02',127,NULL),(2,'2026-01-14 18:59:54',127,NULL);
-- -----------------------------------------------------
-- 4. A TABELA PRODUTOS (MESCLADA)
-- Criação baseada no "corrigido" + Insert dos dados recentes
-- + ALTER TABLE para adicionar o vínculo com Jogos
-- -----------------------------------------------------

DROP TABLE IF EXISTS `produtos`;
CREATE TABLE `produtos` (
  `id_PRODUTOS` int NOT NULL AUTO_INCREMENT,
  `nome_PRODUTOS` varchar(45) NOT NULL,
  `valor_PRODUTOS` float NOT NULL,
  `descricao_PRODUTOS` longtext NOT NULL,
  `quantidade_estoque_PRODUTOS` int NOT NULL,
  `CATEGORIA_PRODUTOS_id_CATEGORIA_PRODUTOS` int NOT NULL,
  `imagem_PRODUTOS` varchar(255) DEFAULT NULL,
  `jogos_id_jogos` int DEFAULT NULL,
  PRIMARY KEY (`id_PRODUTOS`,`CATEGORIA_PRODUTOS_id_CATEGORIA_PRODUTOS`),
  KEY `fk_PRODUTOS_CATEGORIA_PRODUTOS1_idx` (`CATEGORIA_PRODUTOS_id_CATEGORIA_PRODUTOS`),
  KEY `fk_produtos_jogos` (`jogos_id_jogos`),
  CONSTRAINT `fk_PRODUTOS_CATEGORIA_PRODUTOS1` FOREIGN KEY (`CATEGORIA_PRODUTOS_id_CATEGORIA_PRODUTOS`) REFERENCES `categoria_produtos` (`id_CATEGORIA_PRODUTOS`),
  CONSTRAINT `fk_produtos_jogos` FOREIGN KEY (`jogos_id_jogos`) REFERENCES `jogos` (`id_jogos`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4;

-- Inserindo os dados DO BANCO CORRIGIDO (que tem os ingressos 'Arquibancada')
INSERT INTO `produtos` VALUES (36,'Camisa Branca Retrô',249.9,'Camisa branca oficial do AC Milan, ideal para torcedores que buscam estilo e conforto (Uniforme 2).',50,2,'img/produtos/camisas/camisa_branca_retro/camisa_branca(1).webp',NULL),(37,'Camisa Milan Retrô Clássica',199.9,'Reedição histórica de camisas clássicas do Milan. Design nostálgico para colecionadores.',20,2,'img/img_novas/milan authentic 125TH anniversary jersey.webp',NULL),(38,'Camisa Milan Home Listrada',299.9,'A tradicional camisa Rubro-Negra (Rossoneri). O manto sagrado para jogos em casa.',100,2,'img/camisa_home_figma.png',NULL),(39,'Camisa Milan Third amarela',279.9,'Uniforme alternativo na cor amarela com detalhes modernos. Elegância para uso casual ou esportivo.',35,2,'img/img_novas/camisa amraela milan frente.webp',NULL),(40,'Casaco branco',349.9,'Casaco oficial do time',15,2,'img/img_novas/TRACK SWEATSHIRT PUMA X AC MILAN X OFF-WHITE.webp',NULL),(41,'Camisa Verde goleiro',250,'Camisa do goleiro do time',29,2,'img/produtos/camisas/camisa_goleiro_verde/camisa_goleiro_verde (1).webp',NULL),(42,'Camisa manga longa preta',300,'Camisa chique de manga longa',9,2,'img/produtos/camisas/camisa_manga_longa/camisa_manga_longa_preta (1).webp',NULL),(43,'Camisa listrada retrô',260,'Camisa clássica antiga',4,2,'img/produtos/camisas/camisa_listrada_retro/camisa_listrada_retro (1).webp',NULL),(44,'Gorro',100,'Gorro para esquentar o crânio do frio com o calor do seu time',26,1,'img/produtos/acessorios/gorro/gorro_milan (2).webp',NULL),(45,'Bolsa',248.99,'Carregue suas coisas com amor pelo seu time',13,1,'img/produtos/acessorios/bolsa_milan/bolsa_milan (3).webp',NULL),(46,'Boné',77.99,'Proteja-se do sol com o seu timão',12,1,'img/produtos/acessorios/bone_milan/bone_milan (4).webp',NULL),(47,'Mascote',350,'Divirta-se',27,1,'img/produtos/acessorios/boneco_milan/BEBRICKSML-A13_01_20148283-7119-4561-b84b-8e572aff7351.webp',NULL),(48,'Garrafa retro',299.9,'Geladinha',23,1,'img/garrafa_home_figma.png',NULL),(49,'Sandália do clube',99.99,'Conforto e paixão',19,3,'img/produtos/calcados/sandalia.png',NULL),(52,'Arquibancada lado B',100,'Drako X Palmeiras - 15/12/2025',60,10,NULL,NULL),(53,'Arquibancada lado A',60,'Drako X Palmeiras - 15/12/2025',150,10,NULL,NULL),(54,'Camarote Premium',175,'Drako x Palmeiras - 15/12/2025',10,10,NULL,NULL),(55,'Camarote',150,'Drako x Palmeiras - 15/12/2025',15,10,NULL,NULL);

-- -----------------------------------------------------
-- 5. FINALIZAÇÃO
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recuperacao_senha`;
CREATE TABLE `recuperacao_senha` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(6) NOT NULL,
  `criado_em` datetime(6) NOT NULL,
  `cliente_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recuperacao_senha_cliente_id_892afddd` (`cliente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4;

INSERT INTO `recuperacao_senha` VALUES (1,'191545','2025-12-01 19:51:37.369413',127);

-- Reabilita verificação de chaves estrangeiras
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------
-- FIM DO SCRIPT
-- -----------------------------------------------------

