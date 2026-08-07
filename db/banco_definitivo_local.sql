CREATE DATABASE  IF NOT EXISTS `projeto_futebol_definitivo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `projeto_futebol_definitivo`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: projeto_futebol_definitivo
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts_perfil`
--

DROP TABLE IF EXISTS `accounts_perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts_perfil` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sexo` varchar(10) DEFAULT NULL,
  `cpf` varchar(14) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cpf` (`cpf`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_perfil`
--

LOCK TABLES `accounts_perfil` WRITE;
/*!40000 ALTER TABLE `accounts_perfil` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alternativas`
--

DROP TABLE IF EXISTS `alternativas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alternativas` (
  `id_alternativa` int NOT NULL AUTO_INCREMENT,
  `opcao_resposta` varchar(500) NOT NULL,
  `resposta_correta` tinyint NOT NULL,
  `ponto` int NOT NULL,
  `questao_id` int NOT NULL,
  PRIMARY KEY (`id_alternativa`),
  KEY `fk_alternativas_questoes_idx` (`questao_id`),
  CONSTRAINT `fk_alternativas_questoes` FOREIGN KEY (`questao_id`) REFERENCES `questoes` (`id_questao`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alternativas`
--

LOCK TABLES `alternativas` WRITE;
/*!40000 ALTER TABLE `alternativas` DISABLE KEYS */;
INSERT INTO `alternativas` VALUES (1,'Coritiba',0,0,1),(2,'Palmeiras',1,10,1),(3,'Goiás',0,0,1),(4,'Guarani',0,0,1),(5,'Mineirão',0,0,2),(6,'Beira-Rio',0,0,2),(7,'Maracanã',1,10,2),(8,'Neo Química Arena',0,0,2),(9,'Bahia',0,0,3),(10,'Grêmio',1,10,3),(11,'São Paulo',0,0,3),(12,'Fluminense',0,0,3),(13,'Santos',1,10,4),(14,'Corinthians',0,0,4),(15,'Botafogo',0,0,4),(16,'Vitória',0,0,4),(17,'Flamengo',0,0,5),(18,'Cruzeiro',0,0,5),(19,'Palmeiras',1,10,5),(20,'Vasco',0,0,5),(21,'Curitiba',0,0,6),(22,'Porto Alegre',1,10,6),(23,'Florianópolis',0,0,6),(24,'Belo Horizonte',0,0,6),(25,'Fluminense',1,10,7),(26,'Botafogo',0,0,7),(27,'Bragantino',0,0,7),(28,'Athletico-PR',0,0,7),(29,'Cruzeiro',0,0,8),(30,'América-MG',0,0,8),(31,'Atlético-MG',1,10,8),(32,'Cuiabá',0,0,8),(33,'Tubarão',0,0,9),(34,'Leão',1,10,9),(35,'Raposa',0,0,9),(36,'Galo',0,0,9),(37,'São Paulo',1,10,10),(38,'Juventude',0,0,10),(39,'Criciúma',0,0,10),(40,'Corinthians',0,0,10);
/*!40000 ALTER TABLE `alternativas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_group_id_b120cbf9` (`group_id`),
  KEY `auth_group_permissions_permission_id_84c5c92e` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  KEY `auth_permission_content_type_id_2f476e4b` (`content_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add categoria cliente',7,'add_categoriacliente'),(26,'Can change categoria cliente',7,'change_categoriacliente'),(27,'Can delete categoria cliente',7,'delete_categoriacliente'),(28,'Can view categoria cliente',7,'view_categoriacliente'),(29,'Can add categoria produtos',8,'add_categoriaprodutos'),(30,'Can change categoria produtos',8,'change_categoriaprodutos'),(31,'Can delete categoria produtos',8,'delete_categoriaprodutos'),(32,'Can view categoria produtos',8,'view_categoriaprodutos'),(33,'Can add clientes',9,'add_clientes'),(34,'Can change clientes',9,'change_clientes'),(35,'Can delete clientes',9,'delete_clientes'),(36,'Can view clientes',9,'view_clientes'),(37,'Can add compra',10,'add_compra'),(38,'Can change compra',10,'change_compra'),(39,'Can delete compra',10,'delete_compra'),(40,'Can view compra',10,'view_compra'),(41,'Can add endereco cliente',11,'add_enderecocliente'),(42,'Can change endereco cliente',11,'change_enderecocliente'),(43,'Can delete endereco cliente',11,'delete_enderecocliente'),(44,'Can view endereco cliente',11,'view_enderecocliente'),(45,'Can add endereco funcionarios',12,'add_enderecofuncionarios'),(46,'Can change endereco funcionarios',12,'change_enderecofuncionarios'),(47,'Can delete endereco funcionarios',12,'delete_enderecofuncionarios'),(48,'Can view endereco funcionarios',12,'view_enderecofuncionarios'),(49,'Can add funcionarios',13,'add_funcionarios'),(50,'Can change funcionarios',13,'change_funcionarios'),(51,'Can delete funcionarios',13,'delete_funcionarios'),(52,'Can view funcionarios',13,'view_funcionarios'),(53,'Can add pedido',14,'add_pedido'),(54,'Can change pedido',14,'change_pedido'),(55,'Can delete pedido',14,'delete_pedido'),(56,'Can view pedido',14,'view_pedido'),(57,'Can add produtos',15,'add_produtos'),(58,'Can change produtos',15,'change_produtos'),(59,'Can delete produtos',15,'delete_produtos'),(60,'Can view produtos',15,'view_produtos'),(61,'Can add setor funcionarios',16,'add_setorfuncionarios'),(62,'Can change setor funcionarios',16,'change_setorfuncionarios'),(63,'Can delete setor funcionarios',16,'delete_setorfuncionarios'),(64,'Can view setor funcionarios',16,'view_setorfuncionarios'),(65,'Can add perfil',17,'add_perfil'),(66,'Can change perfil',17,'change_perfil'),(67,'Can delete perfil',17,'delete_perfil'),(68,'Can view perfil',17,'view_perfil'),(69,'Can add recuperacao senha',18,'add_recuperacaosenha'),(70,'Can change recuperacao senha',18,'change_recuperacaosenha'),(71,'Can delete recuperacao senha',18,'delete_recuperacaosenha'),(72,'Can view recuperacao senha',18,'view_recuperacaosenha'),(73,'Can add imagem produto',19,'add_imagemproduto'),(74,'Can change imagem produto',19,'change_imagemproduto'),(75,'Can delete imagem produto',19,'delete_imagemproduto'),(76,'Can view imagem produto',19,'view_imagemproduto'),(77,'Can add jogos',20,'add_jogos'),(78,'Can change jogos',20,'change_jogos'),(79,'Can delete jogos',20,'delete_jogos'),(80,'Can view jogos',20,'view_jogos'),(81,'Can add times',21,'add_times'),(82,'Can change times',21,'change_times'),(83,'Can delete times',21,'delete_times'),(84,'Can view times',21,'view_times'),(85,'Can add accounts perfil',22,'add_accountsperfil'),(86,'Can change accounts perfil',22,'change_accountsperfil'),(87,'Can delete accounts perfil',22,'delete_accountsperfil'),(88,'Can view accounts perfil',22,'view_accountsperfil'),(89,'Can add alternativas',23,'add_alternativas'),(90,'Can change alternativas',23,'change_alternativas'),(91,'Can delete alternativas',23,'delete_alternativas'),(92,'Can view alternativas',23,'view_alternativas'),(93,'Can add auth group',24,'add_authgroup'),(94,'Can change auth group',24,'change_authgroup'),(95,'Can delete auth group',24,'delete_authgroup'),(96,'Can view auth group',24,'view_authgroup'),(97,'Can add auth group permissions',25,'add_authgrouppermissions'),(98,'Can change auth group permissions',25,'change_authgrouppermissions'),(99,'Can delete auth group permissions',25,'delete_authgrouppermissions'),(100,'Can view auth group permissions',25,'view_authgrouppermissions'),(101,'Can add auth permission',26,'add_authpermission'),(102,'Can change auth permission',26,'change_authpermission'),(103,'Can delete auth permission',26,'delete_authpermission'),(104,'Can view auth permission',26,'view_authpermission'),(105,'Can add auth user',27,'add_authuser'),(106,'Can change auth user',27,'change_authuser'),(107,'Can delete auth user',27,'delete_authuser'),(108,'Can view auth user',27,'view_authuser'),(109,'Can add auth user groups',28,'add_authusergroups'),(110,'Can change auth user groups',28,'change_authusergroups'),(111,'Can delete auth user groups',28,'delete_authusergroups'),(112,'Can view auth user groups',28,'view_authusergroups'),(113,'Can add auth user user permissions',29,'add_authuseruserpermissions'),(114,'Can change auth user user permissions',29,'change_authuseruserpermissions'),(115,'Can delete auth user user permissions',29,'delete_authuseruserpermissions'),(116,'Can view auth user user permissions',29,'view_authuseruserpermissions'),(117,'Can add django admin log',30,'add_djangoadminlog'),(118,'Can change django admin log',30,'change_djangoadminlog'),(119,'Can delete django admin log',30,'delete_djangoadminlog'),(120,'Can view django admin log',30,'view_djangoadminlog'),(121,'Can add django content type',31,'add_djangocontenttype'),(122,'Can change django content type',31,'change_djangocontenttype'),(123,'Can delete django content type',31,'delete_djangocontenttype'),(124,'Can view django content type',31,'view_djangocontenttype'),(125,'Can add django migrations',32,'add_djangomigrations'),(126,'Can change django migrations',32,'change_djangomigrations'),(127,'Can delete django migrations',32,'delete_djangomigrations'),(128,'Can view django migrations',32,'view_djangomigrations'),(129,'Can add django session',33,'add_djangosession'),(130,'Can change django session',33,'change_djangosession'),(131,'Can delete django session',33,'delete_djangosession'),(132,'Can view django session',33,'view_djangosession'),(133,'Can add historico titulos',34,'add_historicotitulos'),(134,'Can change historico titulos',34,'change_historicotitulos'),(135,'Can delete historico titulos',34,'delete_historicotitulos'),(136,'Can view historico titulos',34,'view_historicotitulos'),(137,'Can add progresso fases',35,'add_progressofases'),(138,'Can change progresso fases',35,'change_progressofases'),(139,'Can delete progresso fases',35,'delete_progressofases'),(140,'Can view progresso fases',35,'view_progressofases'),(141,'Can add questoes',36,'add_questoes'),(142,'Can change questoes',36,'change_questoes'),(143,'Can delete questoes',36,'delete_questoes'),(144,'Can view questoes',36,'view_questoes'),(145,'Can add respostas',37,'add_respostas'),(146,'Can change respostas',37,'change_respostas'),(147,'Can delete respostas',37,'delete_respostas'),(148,'Can view respostas',37,'view_respostas'),(149,'Can add titulos',38,'add_titulos'),(150,'Can change titulos',38,'change_titulos'),(151,'Can delete titulos',38,'delete_titulos'),(152,'Can view titulos',38,'view_titulos');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$XrzSwf46GU0btn8fCV9HPl$TKXsFu21ZgFecgLNZfUjP8Cfdgv3v54FP86x58oRzlw=','2026-08-04 18:13:58.219651',1,'fernando','','','',1,1,'2025-09-11 19:21:04.582791');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_user_id_6a12ed8b` (`user_id`),
  KEY `auth_user_groups_group_id_97559544` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_user_id_a95ead1b` (`user_id`),
  KEY `auth_user_user_permissions_permission_id_1fbb5f2c` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria_cliente`
--

DROP TABLE IF EXISTS `categoria_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria_cliente` (
  `id_CATEGORIA_CLIENTE` int NOT NULL AUTO_INCREMENT,
  `nome_CATEGORIA_CLIENTES` varchar(45) NOT NULL,
  `descricao_categ_cli` mediumtext NOT NULL,
  `preco_categ` float(5,2) NOT NULL,
  PRIMARY KEY (`id_CATEGORIA_CLIENTE`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria_cliente`
--

LOCK TABLES `categoria_cliente` WRITE;
/*!40000 ALTER TABLE `categoria_cliente` DISABLE KEYS */;
INSERT INTO `categoria_cliente` VALUES (2,'socio drakos - diamante','O plano Sócio Drakos – Diamante é anual, com apenas 350 vagas disponíveis. Oferece acesso livre aos jogos*, app oficial Drakos, desconto de 10% em produtos oficiais e plano adicional para dependentes. Os sócios têm ainda carteirinha digital personalizada, central de atendimento exclusiva, e participam de ações especiais e vantagens do Clube Parceiro Drakos.',300.00),(3,'socio drakos - ouro','O plano Sócio Drakos – Ouro é anual e limitado a 2.000 vagas. Garante acesso livre aos jogos da temporada*, uso do app oficial Drakos, carteirinha digital personalizada, e um plano adicional para dependentes. Os sócios também desfrutam de 10% de desconto em produtos oficiais, atendimento exclusivo, além de vantagens no Clube Parceiro Drakos e participação em ações especiais com o elenco.',200.00),(4,'socio drakos - prata','O plano Sócio Drakos – Prata é anual e limitado a 2.000 vagas. Garante acesso livre aos jogos da temporada*, uso do app oficial Drakos, carteirinha digital personalizada, e um plano adicional para dependentes. Os sócios também desfrutam de 5% de desconto em produtos oficiais, atendimento exclusivo e de vantagens no Clube Parceiro Drakos.',100.00),(5,'nao socio','Não contratante',0.00);
/*!40000 ALTER TABLE `categoria_cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria_produtos`
--

DROP TABLE IF EXISTS `categoria_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria_produtos` (
  `id_CATEGORIA_PRODUTOS` int NOT NULL AUTO_INCREMENT,
  `nome_CATEGORIA_PRODUTOS` varchar(45) NOT NULL,
  PRIMARY KEY (`id_CATEGORIA_PRODUTOS`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria_produtos`
--

LOCK TABLES `categoria_produtos` WRITE;
/*!40000 ALTER TABLE `categoria_produtos` DISABLE KEYS */;
INSERT INTO `categoria_produtos` VALUES (1,'Acessórios'),(2,'Camisas FC'),(3,'Calçados'),(4,'Shorts'),(5,'Meias'),(10,'Ingressos');
/*!40000 ALTER TABLE `categoria_produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_CLIENTES` int NOT NULL AUTO_INCREMENT,
  `nome_CLIENTES` varchar(45) NOT NULL,
  `sobrenome_CLIENTES` varchar(45) NOT NULL,
  `email_CLIENTES` varchar(50) NOT NULL,
  `telefone_CLIENTES` varchar(15) NOT NULL,
  `sexo_CLIENTES` varchar(20) NOT NULL,
  `status_CLIENTES` tinyint NOT NULL,
  `cpf_CLIENTES` varchar(14) NOT NULL,
  `senha_CLIENTES` varchar(255) NOT NULL,
  `CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE` int NOT NULL,
  `url_foto_CLIENTES` varchar(255) DEFAULT NULL,
  `score_rank` int DEFAULT '0',
  `total_acertos` int DEFAULT '0',
  `total_questoes` int DEFAULT '0',
  `precisao` float DEFAULT '0',
  `tempo` time DEFAULT '00:00:00',
  `criado_em` datetime DEFAULT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_CLIENTES`),
  KEY `fk_CLIENTES_CATEGORIA_CLIENTE1_idx` (`CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE`),
  CONSTRAINT `fk_CLIENTES_CATEGORIA_CLIENTE1` FOREIGN KEY (`CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE`) REFERENCES `categoria_cliente` (`id_CATEGORIA_CLIENTE`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (136,'Fernando','Freitas','fernandofreitassud2016@gmail.com','(61) 98498-9494','Masculino',1,'24698198984','pbkdf2_sha256$1000000$E85FpjwNCoXErUXzDaVBZ7$22TndwuNhpBq43okrgNk5ccArQFM0rsaq+39WbzKFCg=',4,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/perfis/foto_4df9c96e4d2c4845ab54604467f0aef7.webp',NULL,NULL,NULL,NULL,NULL,'2025-07-19 15:20:19','2026-08-03 19:35:37'),(137,'pedro','daniel','deucerto12@gmail.com','(52) 31231-3123','Masculino',0,'39248193819','pbkdf2_sha256$1000000$OfIuQr6Qiig1aCD53BmA5u$oymwgMBqw0aU8K9UI8LJiGyHeyuXvcoTbVGX1vhyYF8=',5,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/perfis/foto_4316a6bfce4a4586bbb60ed9a428f8f8.webp',NULL,NULL,NULL,NULL,NULL,'2026-04-14 15:20:19','2026-07-27 17:24:44'),(138,'Daniela','Daniela','cadastro123@gmail.com','etsetssdf','Masculino',1,'324.242.423-42','pbkdf2_sha256$1000000$uiirjYrgfKOUJKvPPHs4gl$zQ69p3zHKxM5qZp6YIcIylCfH/KJLZDQKWT5tegd9pA=',2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/perfis/e9598ede2b5941aab23cc4ceaa205b87.jpg',NULL,NULL,NULL,NULL,NULL,'2026-05-18 15:20:19','2026-08-03 19:28:24'),(140,'pedro','daniel','pedro123@gmail.com','(94) 94811-6919','Masculino',0,'546.454.515-16','pbkdf2_sha256$1000000$naltgqaNFsrpTRi14Ab8yZ$EvazU+i+oxFbGkzG3hIU9YY3p+pTC/iZCGZKg/pyi10=',3,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-20 15:20:19','2026-07-27 15:29:21'),(141,'Rafael','Santos','rafaelchris639@gmail.com','(91) 94578-5623','Masculino',1,'456.456.456-56','$argon2id$v=19$m=65536,t=3,p=4$8JgnvC8QO0CdYagUiMCDuQ$mKWQXOi6Y05dxjCunhOI4xBXTEwW2+UXmyhAcbMgLaE',4,NULL,0,0,0,0,'00:00:00','2026-07-14 15:20:19','2026-08-06 14:02:18'),(144,'Judas','Escariotes','judas@gmail.com','(19) 19871-8799','Masculino',0,'65589828494','pbkdf2_sha256$1000000$c308Q61kp6kXp85gBBhW2V$lkLrfdI3VhiDO+LSKwFjI2eSPWbniin9ZxnkIC4nRbo=',4,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-16 17:53:53','2026-07-27 15:29:33'),(145,'Pedro','Abigaiol','daniel123@gmail.com','(64) 84646-1613','Masculino',0,'155.445.646-48','pbkdf2_sha256$1000000$kZv1QwrOhUirPWiYsb4REg$SlVxmB5ezRqTztX3YAVHdHULEoEI/+0MtRjuu3s30Dc=',5,'file:///var/mobile/Containers/Data/Application/E69BD026-3DF4-4AEC-AF72-02CD5AB4F1B4/Library/Caches/ExponentExperienceData/@anonymous/Drakos-app-51cf3e06-ec88-4afa-ba93-e39afe45ed80/ImagePicker/161027F5-FD55-46A0-A8BC-92254ED8E755.jpg',NULL,NULL,NULL,NULL,NULL,'2026-07-16 18:38:58','2026-07-27 17:24:52'),(146,'José','Avila','avila@gmail.com','(91) 65491-5919','Masculino',1,'14918716516','pbkdf2_sha256$1000000$Bpz6Cw61f1zMrXkuXutGcB$YdmC6jILoCllLSyJxdojRHnjzrfzSNYhRJI/c6ZhW9w=',4,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/perfis/foto_d6ec0b15abf6443ead0aa1eb04b918b4.webp',NULL,NULL,NULL,NULL,NULL,'2026-07-16 19:48:49','2026-07-23 19:05:36'),(147,'daniel','eduardo','clara123@gmail.com','(91) 91346-4846','Masculino',1,'454.343.484-64','pbkdf2_sha256$1000000$fVPutvkhy3gbu5ZXuF3Tdd$q427iKCXutd9yMYJsAcV2w7KIWb3UPNcJVobyv8N6aw=',5,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-16 19:57:49','2026-07-16 19:57:49'),(148,'Maria','Madalena','madalena123@gmail.com','(84) 64846-4846','Masculino',1,'846.494.648-56','pbkdf2_sha256$1000000$nycKHj9Kq7AarBZl54fs2G$TfdVDz5dkB0FMsjLUossQcBHrD44kBfwCDhXh+UPg74=',5,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-16 20:14:01','2026-07-16 20:14:01'),(149,'Lucas','Abreu','lucasabr001@gmail.com','(91) 98509-1498','Masculino',1,'010.064.803-93','pbkdf2_sha256$1000000$KtJW9e9A0XkAWOV5RMg3GH$3t43t1sXP3rC1QHWwISgL2q2ombTKbHsu61fdt/ceIk=',4,'file:///var/mobile/Containers/Data/Application/E69BD026-3DF4-4AEC-AF72-02CD5AB4F1B4/Library/Caches/ExponentExperienceData/@anonymous/Drakos-app-51cf3e06-ec88-4afa-ba93-e39afe45ed80/ImagePicker/883A7BF5-223C-41F5-8A52-EC338CB8F7A2.jpg',NULL,NULL,NULL,NULL,NULL,'2026-07-27 17:57:18','2026-08-06 14:02:08'),(150,'Fernando','Torres','fernando2828@gmail.com','(46) 46646-4846','Masculino',1,'646.464.646-16','pbkdf2_sha256$1000000$E7JsFFBVndbxT5G9IQYqgc$D4bYNorOPhiXYk85ofZKWRJklZGCiuKKHTD9hNjpQxw=',5,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-27 18:57:24','2026-07-27 18:57:24'),(151,'teste','da silva','teste@gmail.com','(91) 98471-1434','Masculino',1,'54654651651','pbkdf2_sha256$1000000$4aJMjJsusvsEVQubRsISNT$ujIu3tr3v5baY0TN3fRAuDjGBfJQ20cmPJNmCb+u8b0=',3,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/perfis/foto_a30b829b2d04434492a798c72edbe14d.webp',NULL,NULL,NULL,NULL,NULL,'2026-07-29 20:34:32','2026-08-03 18:14:43'),(152,'jose','rovert','teste@gmai.com','(91) 98471-1434','Masculino',1,'12312314232','pbkdf2_sha256$1000000$vTi1hslEo32l1HmkaTRcsD$2xmcKprLKHeNaMgfabPSbFgNNZ/S3DCd0xVi2v/hNNA=',5,NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-03 19:31:31','2026-08-03 19:31:31'),(153,'Pedro','Daniel','danicc223@icloud.com','(84) 86946-9433','Masculino',1,'522.151.346-46','pbkdf2_sha256$1000000$KLAQtYXfwPwjZzRG0vpo5D$nooyvv5SsOlmP2Ekj+0MNoCdMCeC37n4HllPx64EbPw=',2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/perfis/4792d1582c2d4dce8e1af03c20981f47.jpg',NULL,NULL,NULL,NULL,NULL,'2026-08-04 18:39:22','2026-08-04 18:47:53');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compra`
--

DROP TABLE IF EXISTS `compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compra` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `PRODUTOS_id_PRODUTOS` int NOT NULL,
  `PEDIDO_id_PEDIDO` int NOT NULL,
  `quantidade_PEDIDO` int NOT NULL,
  `valor_compra` decimal(10,0) NOT NULL,
  `tamanho` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id_compra`),
  KEY `fk_PRODUTOS_has_PEDIDO_PEDIDO1_idx` (`PEDIDO_id_PEDIDO`),
  KEY `fk_PRODUTOS_has_PEDIDO_PRODUTOS1_idx` (`PRODUTOS_id_PRODUTOS`),
  CONSTRAINT `fk_PRODUTOS_has_PEDIDO_PEDIDO1` FOREIGN KEY (`PEDIDO_id_PEDIDO`) REFERENCES `pedido` (`id_PEDIDO`),
  CONSTRAINT `fk_PRODUTOS_has_PEDIDO_PRODUTOS1` FOREIGN KEY (`PRODUTOS_id_PRODUTOS`) REFERENCES `produtos` (`id_PRODUTOS`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compra`
--

LOCK TABLES `compra` WRITE;
/*!40000 ALTER TABLE `compra` DISABLE KEYS */;
INSERT INTO `compra` VALUES (28,42,21,1,300,NULL),(29,49,21,1,100,NULL),(30,53,22,1,60,NULL),(31,53,23,1,60,NULL),(32,52,24,1,100,NULL),(33,53,25,2,120,NULL),(34,53,26,1,60,NULL),(35,61,27,1,260,NULL),(36,62,27,1,290,NULL),(37,52,27,1,100,NULL),(38,44,28,1,100,NULL),(39,47,28,1,350,NULL),(40,57,28,1,46,NULL),(41,52,29,1,100,NULL),(42,49,31,1,100,NULL),(43,42,32,1,300,'GG'),(44,44,33,1,100,NULL),(45,42,33,1,300,'GG'),(46,47,33,1,350,NULL),(47,49,33,1,100,NULL),(48,42,34,1,300,'P'),(49,44,35,1,100,NULL),(50,47,36,1,350,NULL),(51,63,37,1,320,'M'),(52,42,37,1,300,'M'),(53,44,38,1,100,NULL),(54,45,39,1,249,NULL),(55,47,39,1,95,NULL),(56,57,39,1,46,NULL),(57,61,39,1,260,'P'),(58,42,39,2,600,'GG'),(59,54,40,1,175,NULL),(60,65,41,2,550,'P'),(61,62,42,1,290,'M'),(62,45,43,1,150,NULL),(63,42,44,1,300,'P'),(64,65,44,1,275,'G'),(65,42,45,1,300,'P'),(66,45,45,1,150,NULL),(67,45,46,1,150,NULL),(68,58,46,1,35,NULL);
/*!40000 ALTER TABLE `compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=319 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (195,'2026-06-26 18:34:58.912129','20','Pedido 20 - Drakos (24698198984)',3,'',14,1),(196,'2026-06-26 18:34:58.912162','19','Pedido 19 - Drakos (24698198984)',3,'',14,1),(197,'2026-06-26 18:34:58.912178','18','Pedido 18 - Drakos (24698198984)',3,'',14,1),(198,'2026-06-26 18:34:58.912191','17','Pedido 17 - Drakos (24698198984)',3,'',14,1),(199,'2026-06-26 18:34:58.912202','16','Pedido 16 - Drakos (24698198984)',3,'',14,1),(200,'2026-06-26 18:34:58.912213','15','Pedido 15 - Drakos (24698198984)',3,'',14,1),(201,'2026-06-26 18:34:58.912225','14','Pedido 14 - Drakos (24698198984)',3,'',14,1),(202,'2026-06-26 18:34:58.912236','13','Pedido 13 - Drakos (24698198984)',3,'',14,1),(203,'2026-06-26 18:34:58.912248','12','Pedido 12 - Drakos (24698198984)',3,'',14,1),(204,'2026-06-26 18:34:58.912259','11','Pedido 11 - Drakos (24698198984)',3,'',14,1),(205,'2026-06-26 18:34:58.912271','10','Pedido 10 - Drakos (24698198984)',3,'',14,1),(206,'2026-06-26 18:34:58.912282','9','Pedido 9 - Drakos (24698198984)',3,'',14,1),(207,'2026-06-26 18:34:58.912294','8','Pedido 8 - Drakos (24698198984)',3,'',14,1),(208,'2026-06-26 18:35:10.851750','27','Compra 27',3,'',10,1),(209,'2026-06-26 18:35:10.851796','26','Compra 26',3,'',10,1),(210,'2026-06-26 18:35:10.851831','25','Compra 25',3,'',10,1),(211,'2026-06-26 18:35:10.851861','24','Compra 24',3,'',10,1),(212,'2026-06-26 18:35:10.851876','23','Compra 23',3,'',10,1),(213,'2026-06-26 18:35:10.851893','22','Compra 22',3,'',10,1),(214,'2026-06-26 18:35:10.851910','21','Compra 21',3,'',10,1),(215,'2026-06-26 18:35:10.851927','20','Compra 20',3,'',10,1),(216,'2026-06-26 18:35:10.851944','19','Compra 19',3,'',10,1),(217,'2026-06-26 18:35:10.851958','18','Compra 18',3,'',10,1),(218,'2026-06-26 18:35:10.851973','17','Compra 17',3,'',10,1),(219,'2026-06-26 18:35:10.851987','16','Compra 16',3,'',10,1),(220,'2026-06-26 18:35:10.852002','15','Compra 15',3,'',10,1),(221,'2026-06-26 18:35:10.852022','14','Compra 14',3,'',10,1),(222,'2026-06-26 18:35:17.228315','20','Pedido 20 - Drakos (24698198984)',3,'',14,1),(223,'2026-06-26 18:35:17.228352','19','Pedido 19 - Drakos (24698198984)',3,'',14,1),(224,'2026-06-26 18:35:17.228368','18','Pedido 18 - Drakos (24698198984)',3,'',14,1),(225,'2026-06-26 18:35:17.228383','17','Pedido 17 - Drakos (24698198984)',3,'',14,1),(226,'2026-06-26 18:35:17.228394','16','Pedido 16 - Drakos (24698198984)',3,'',14,1),(227,'2026-06-26 18:35:17.228405','15','Pedido 15 - Drakos (24698198984)',3,'',14,1),(228,'2026-06-26 18:35:17.228416','14','Pedido 14 - Drakos (24698198984)',3,'',14,1),(229,'2026-06-26 18:35:17.228427','13','Pedido 13 - Drakos (24698198984)',3,'',14,1),(230,'2026-06-26 18:35:17.228438','12','Pedido 12 - Drakos (24698198984)',3,'',14,1),(231,'2026-06-26 18:35:17.228448','11','Pedido 11 - Drakos (24698198984)',3,'',14,1),(232,'2026-06-26 18:35:17.228460','10','Pedido 10 - Drakos (24698198984)',3,'',14,1),(233,'2026-06-26 18:35:17.228473','9','Pedido 9 - Drakos (24698198984)',3,'',14,1),(234,'2026-06-26 18:35:17.228486','8','Pedido 8 - Drakos (24698198984)',3,'',14,1),(235,'2026-08-04 18:15:13.851034','58','Caneca Drakos FC - R$ 35.0',2,'[{\"changed\": {\"fields\": [\"Imagem produtos\"]}}]',15,1),(236,'2026-08-04 18:20:07.732942','52','Imagem 0 - Caneca Drakos FC',1,'[{\"added\": {}}]',19,1),(237,'2026-08-04 18:20:56.421197','53','Imagem 1 - Caneca Drakos FC',1,'[{\"added\": {}}]',19,1),(238,'2026-08-04 18:21:18.389357','54','Imagem 2 - Caneca Drakos FC',1,'[{\"added\": {}}]',19,1),(239,'2026-08-04 18:21:39.084850','58','Caneca Drakos FC - R$ 35.0',2,'[]',15,1),(240,'2026-08-04 18:25:31.752408','45','cachecol - R$ 248.99',2,'[{\"changed\": {\"fields\": [\"Imagem produtos\"]}}]',15,1),(241,'2026-08-04 18:25:51.662676','55','Imagem 0 - cachecol',1,'[{\"added\": {}}]',19,1),(242,'2026-08-04 18:28:55.062120','56','Imagem 1 - cachecol',1,'[{\"added\": {}}]',19,1),(243,'2026-08-04 18:29:12.424348','57','Imagem 2 - cachecol',1,'[{\"added\": {}}]',19,1),(244,'2026-08-04 18:29:25.965651','58','Imagem 3 - cachecol',1,'[{\"added\": {}}]',19,1),(245,'2026-08-04 18:30:01.569552','49','Imagem 3 - cachecol',3,'',19,1),(246,'2026-08-04 18:30:01.569576','48','Imagem 2 - cachecol',3,'',19,1),(247,'2026-08-04 18:30:01.569586','46','Imagem 1 - cachecol',3,'',19,1),(248,'2026-08-04 18:30:28.127543','57','Imagem 2 - cachecol',2,'[{\"changed\": {\"fields\": [\"Imagem imagem\"]}}]',19,1),(249,'2026-08-04 18:30:59.520403','58','Imagem 3 - cachecol',2,'[{\"changed\": {\"fields\": [\"Imagem imagem\"]}}]',19,1),(250,'2026-08-04 18:43:41.147025','47','Mascote - R$ 95.0',2,'[{\"changed\": {\"fields\": [\"Imagem produtos\"]}}]',15,1),(251,'2026-08-04 18:44:00.849013','59','Imagem 0 - Mascote',1,'[{\"added\": {}}]',19,1),(252,'2026-08-04 18:44:16.297744','60','Imagem 1 - Mascote',1,'[{\"added\": {}}]',19,1),(253,'2026-08-04 18:44:36.289166','61','Imagem 2 - Mascote',1,'[{\"added\": {}}]',19,1),(254,'2026-08-04 18:49:47.619979','62','Imagem 0 - Gorro',1,'[{\"added\": {}}]',19,1),(255,'2026-08-04 18:50:15.126326','63','Imagem 1 - Gorro',1,'[{\"added\": {}}]',19,1),(256,'2026-08-04 18:50:37.950273','64','Imagem 2 - Gorro',1,'[{\"added\": {}}]',19,1),(257,'2026-08-04 18:53:39.858132','64','Imagem 2 - Gorro',2,'[{\"changed\": {\"fields\": [\"Imagem imagem\"]}}]',19,1),(258,'2026-08-04 18:58:54.170877','57','Olhadeira Drakos - R$ 45.9',2,'[]',15,1),(259,'2026-08-04 18:59:11.615699','65','Imagem 0 - Olhadeira Drakos',1,'[{\"added\": {}}]',19,1),(260,'2026-08-04 18:59:24.985065','66','Imagem 1 - Olhadeira Drakos',1,'[{\"added\": {}}]',19,1),(261,'2026-08-04 19:00:25.724207','59','Chaveiro Metálico - R$ 15.0',2,'[{\"changed\": {\"fields\": [\"Imagem produtos\"]}}]',15,1),(262,'2026-08-04 19:00:41.477297','67','Imagem 0 - Chaveiro Metálico',1,'[{\"added\": {}}]',19,1),(263,'2026-08-04 19:00:53.995163','68','Imagem 1 - Chaveiro Metálico',1,'[{\"added\": {}}]',19,1),(264,'2026-08-04 19:01:28.697135','60','Capa de Telefone Premium - R$ 59.9',2,'[{\"changed\": {\"fields\": [\"Imagem produtos\"]}}]',15,1),(265,'2026-08-04 19:01:49.333168','69','Imagem 0 - Capa de Telefone Premium',1,'[{\"added\": {}}]',19,1),(266,'2026-08-04 19:02:13.713087','70','Imagem 1 - Capa de Telefone Premium',1,'[{\"added\": {}}]',19,1),(267,'2026-08-04 19:02:30.088787','71','Imagem 2 - Capa de Telefone Premium',1,'[{\"added\": {}}]',19,1),(268,'2026-08-04 19:03:35.070147','66','Casaco Black Drakos - R$ 349.9',2,'[]',15,1),(269,'2026-08-04 19:03:48.914956','72','Imagem 0 - Casaco Black Drakos',1,'[{\"added\": {}}]',19,1),(270,'2026-08-04 19:04:12.595095','73','Imagem 1 - Casaco Black Drakos',1,'[{\"added\": {}}]',19,1),(271,'2026-08-04 19:04:28.189711','74','Imagem 2 - Casaco Black Drakos',1,'[{\"added\": {}}]',19,1),(272,'2026-08-04 19:05:24.986787','74','Imagem 3 - Casaco Black Drakos',2,'[{\"changed\": {\"fields\": [\"Ordem imagem\"]}}]',19,1),(273,'2026-08-04 19:05:35.663984','75','Imagem 2 - Casaco Black Drakos',1,'[{\"added\": {}}]',19,1),(274,'2026-08-04 19:06:43.068344','65','Camisa Black Uniform - R$ 275.0',2,'[{\"changed\": {\"fields\": [\"Imagem produtos\"]}}]',15,1),(275,'2026-08-04 19:07:23.742735','65','Camisa Black Emirates - R$ 275.0',2,'[{\"changed\": {\"fields\": [\"Nome produtos\"]}}]',15,1),(276,'2026-08-04 19:07:47.634741','76','Imagem 0 - Camisa Black Emirates',1,'[{\"added\": {}}]',19,1),(277,'2026-08-04 19:08:09.173854','77','Imagem 1 - Camisa Black Emirates',1,'[{\"added\": {}}]',19,1),(278,'2026-08-04 19:08:22.817277','78','Imagem 2 - Camisa Black Emirates',1,'[{\"added\": {}}]',19,1),(279,'2026-08-04 19:08:34.751079','79','Imagem 3 - Camisa Black Emirates',1,'[{\"added\": {}}]',19,1),(280,'2026-08-04 19:11:01.268297','67','Camisa White Opel - R$ 279.9',2,'[{\"changed\": {\"fields\": [\"Nome produtos\"]}}]',15,1),(281,'2026-08-04 19:11:25.947667','80','Imagem 0 - Camisa White Opel',1,'[{\"added\": {}}]',19,1),(282,'2026-08-04 19:11:43.132975','81','Imagem 1 - Camisa White Opel',1,'[{\"added\": {}}]',19,1),(283,'2026-08-04 19:11:59.324866','82','Imagem 2 - Camisa White Opel',1,'[{\"added\": {}}]',19,1),(284,'2026-08-04 19:12:12.967054','83','Imagem 3 - Camisa White Opel',1,'[{\"added\": {}}]',19,1),(285,'2026-08-04 19:15:32.901162','68','Camisa Drakos White Red Emirates - R$ 259.9',2,'[{\"changed\": {\"fields\": [\"Nome produtos\", \"Imagem produtos\"]}}]',15,1),(286,'2026-08-04 19:15:59.574176','84','Imagem 0 - Camisa Drakos White Red Emirates',1,'[{\"added\": {}}]',19,1),(287,'2026-08-04 19:16:14.422065','85','Imagem 1 - Camisa Drakos White Red Emirates',1,'[{\"added\": {}}]',19,1),(288,'2026-08-04 19:16:30.782040','86','Imagem 2 - Camisa Drakos White Red Emirates',1,'[{\"added\": {}}]',19,1),(289,'2026-08-04 19:16:44.523971','87','Imagem 3 - Camisa Drakos White Red Emirates',1,'[{\"added\": {}}]',19,1),(290,'2026-08-04 19:18:19.013549','42','Camisa manga longa preta - R$ 300.0',2,'[]',15,1),(291,'2026-08-04 19:18:32.068509','88','Imagem 0 - Camisa manga longa preta',1,'[{\"added\": {}}]',19,1),(292,'2026-08-04 19:18:48.920702','89','Imagem 1 - Camisa manga longa preta',1,'[{\"added\": {}}]',19,1),(293,'2026-08-04 19:19:01.565036','90','Imagem 2 - Camisa manga longa preta',1,'[{\"added\": {}}]',19,1),(294,'2026-08-04 19:19:14.731839','91','Imagem 3 - Camisa manga longa preta',1,'[{\"added\": {}}]',19,1),(295,'2026-08-04 19:21:20.372054','69','Camisa White Version - R$ 265.0',2,'[{\"changed\": {\"fields\": [\"Nome produtos\", \"Imagem produtos\"]}}]',15,1),(296,'2026-08-04 19:21:54.631443','92','Imagem 0 - Camisa White Version',1,'[{\"added\": {}}]',19,1),(297,'2026-08-04 19:22:10.203521','93','Imagem 1 - Camisa White Version',1,'[{\"added\": {}}]',19,1),(298,'2026-08-04 19:22:27.682877','94','Imagem 2 - Camisa White Version',1,'[{\"added\": {}}]',19,1),(299,'2026-08-04 19:22:49.077976','95','Imagem 3 - Camisa White Version',1,'[{\"added\": {}}]',19,1),(300,'2026-08-04 19:24:11.231670','61','Camisa Drakos Slam Jam - R$ 259.9',2,'[{\"changed\": {\"fields\": [\"Nome produtos\"]}}]',15,1),(301,'2026-08-04 19:24:32.233565','96','Imagem 0 - Camisa Drakos Slam Jam',1,'[{\"added\": {}}]',19,1),(302,'2026-08-04 19:24:45.972265','97','Imagem 1 - Camisa Drakos Slam Jam',1,'[{\"added\": {}}]',19,1),(303,'2026-08-04 19:24:59.124313','98','Imagem 2 - Camisa Drakos Slam Jam',1,'[{\"added\": {}}]',19,1),(304,'2026-08-04 19:25:29.096991','61','Camisa Drakos Slam Jam - R$ 259.9',2,'[{\"changed\": {\"fields\": [\"Imagem produtos\"]}}]',15,1),(305,'2026-08-04 19:26:53.347023','62','Uniforme Classic - R$ 289.9',2,'[{\"changed\": {\"fields\": [\"Nome produtos\", \"Imagem produtos\"]}}]',15,1),(306,'2026-08-04 19:27:03.804516','99','Imagem 0 - Uniforme Classic',1,'[{\"added\": {}}]',19,1),(307,'2026-08-04 19:27:23.137645','100','Imagem 1 - Uniforme Classic',1,'[{\"added\": {}}]',19,1),(308,'2026-08-04 19:27:36.599294','101','Imagem 2 - Uniforme Classic',1,'[{\"added\": {}}]',19,1),(309,'2026-08-04 19:27:57.519853','102','Imagem 3 - Uniforme Classic',1,'[{\"added\": {}}]',19,1),(310,'2026-08-04 19:28:56.849893','64','Camisa Away White 25/26 - R$ 299.9',2,'[{\"changed\": {\"fields\": [\"Imagem produtos\"]}}]',15,1),(311,'2026-08-04 19:29:41.009225','103','Imagem 0 - Camisa Away White 25/26',1,'[{\"added\": {}}]',19,1),(312,'2026-08-04 19:29:53.144305','104','Imagem 1 - Camisa Away White 25/26',1,'[{\"added\": {}}]',19,1),(313,'2026-08-04 19:30:04.741065','105','Imagem 2 - Camisa Away White 25/26',1,'[{\"added\": {}}]',19,1),(314,'2026-08-04 19:35:27.724904','63','Camisa Drakos Emirates Fly - R$ 320.0',2,'[{\"changed\": {\"fields\": [\"Nome produtos\", \"Imagem produtos\"]}}]',15,1),(315,'2026-08-04 19:35:40.560059','106','Imagem 0 - Camisa Drakos Emirates Fly',1,'[{\"added\": {}}]',19,1),(316,'2026-08-04 19:35:56.108880','107','Imagem 1 - Camisa Drakos Emirates Fly',1,'[{\"added\": {}}]',19,1),(317,'2026-08-04 19:36:11.528600','108','Imagem 2 - Camisa Drakos Emirates Fly',1,'[{\"added\": {}}]',19,1),(318,'2026-08-04 19:36:29.840776','109','Imagem 3 - Camisa Drakos Emirates Fly',1,'[{\"added\": {}}]',19,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (17,'accounts','perfil'),(1,'admin','logentry'),(22,'app_futebol','accountsperfil'),(23,'app_futebol','alternativas'),(24,'app_futebol','authgroup'),(25,'app_futebol','authgrouppermissions'),(26,'app_futebol','authpermission'),(27,'app_futebol','authuser'),(28,'app_futebol','authusergroups'),(29,'app_futebol','authuseruserpermissions'),(7,'app_futebol','categoriacliente'),(8,'app_futebol','categoriaprodutos'),(9,'app_futebol','clientes'),(10,'app_futebol','compra'),(30,'app_futebol','djangoadminlog'),(31,'app_futebol','djangocontenttype'),(32,'app_futebol','djangomigrations'),(33,'app_futebol','djangosession'),(11,'app_futebol','enderecocliente'),(12,'app_futebol','enderecofuncionarios'),(13,'app_futebol','funcionarios'),(34,'app_futebol','historicotitulos'),(19,'app_futebol','imagemproduto'),(20,'app_futebol','jogos'),(14,'app_futebol','pedido'),(15,'app_futebol','produtos'),(35,'app_futebol','progressofases'),(36,'app_futebol','questoes'),(18,'app_futebol','recuperacaosenha'),(37,'app_futebol','respostas'),(16,'app_futebol','setorfuncionarios'),(21,'app_futebol','times'),(38,'app_futebol','titulos'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (25,'contenttypes','0001_initial','2026-06-23 18:03:34.985926'),(26,'auth','0001_initial','2026-06-23 18:03:34.988351'),(27,'accounts','0001_initial','2026-06-23 18:03:34.990242'),(28,'admin','0001_initial','2026-06-23 18:03:34.993660'),(29,'admin','0002_logentry_remove_auto_add','2026-06-23 18:03:34.997303'),(30,'admin','0003_logentry_add_action_flag_choices','2026-06-23 18:03:35.000145'),(31,'app_futebol','0001_initial','2026-06-23 18:03:35.001892'),(32,'app_futebol','0002_accountsperfil_alternativas_authgroup_and_more','2026-06-23 18:03:35.003550'),(33,'contenttypes','0002_remove_content_type_name','2026-06-23 18:03:35.006437'),(34,'auth','0002_alter_permission_name_max_length','2026-06-23 18:03:35.008228'),(35,'auth','0003_alter_user_email_max_length','2026-06-23 18:03:35.010190'),(36,'auth','0004_alter_user_username_opts','2026-06-23 18:03:35.013121'),(37,'auth','0005_alter_user_last_login_null','2026-06-23 18:03:35.014849'),(38,'auth','0006_require_contenttypes_0002','2026-06-23 18:03:35.016408'),(39,'auth','0007_alter_validators_add_error_messages','2026-06-23 18:03:35.018938'),(40,'auth','0008_alter_user_username_max_length','2026-06-23 18:03:35.020621'),(41,'auth','0009_alter_user_last_name_max_length','2026-06-23 18:03:35.022683'),(42,'auth','0010_alter_group_name_max_length','2026-06-23 18:03:35.025751'),(43,'auth','0011_update_proxy_permissions','2026-06-23 18:03:35.027669'),(44,'auth','0012_alter_user_first_name_max_length','2026-06-23 18:03:35.030510'),(45,'minigame','0001_initial','2026-06-23 18:03:35.032090'),(46,'minigame','0002_remove_progressofases_participante_and_more','2026-06-23 18:03:35.033696'),(47,'sessions','0001_initial','2026-06-23 18:03:35.036620'),(48,'app_futebol','0003_compra_tamanho','2026-07-27 18:01:51.265389'),(49,'app_futebol','0004_repair_compra_tamanho','2026-07-27 18:01:51.384270');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('23sy2puwur6ogkyf8bsodv9z8hm1k88l','.eJxVkEFuwyAQRa9isWqlxDaEYMiqqy57hQjD0KLagIC0iyh3L6RpQncz8-b_Gf0zUosFl-FoNTrgHdvcB86vgA7oFaKTTnv0IMnPEf5wBJtlaiis0i6FmJvQ_G6kkyYjZi_vFffKr40kwwLGu-r3xPBzJzgVfCuooM2SCqZwQpngWPCy0jDjsy_wI-eQDsMQTvOWEy4kmTBVmFI2zVzjvZooIRTEqIH0kfQavoYA0dg0VIcj1UYowYBqoiineznvKRur3IwSzNR_wxzK2bBI50sMyvprbuT_6BbNtel0lJ8-ddtOW7nK8mwbldMQQZXXz6j67KbCIBTtW01jg-JJPholU9PN0sboG-rXsMBafO_DywblevPDp6OSMdpSlVOXyw_btKNm:1wpXId:8XzxqaW1pAVIWovakp_W3FQTo4Bbxc4w_KOjJTkM78c','2026-08-13 20:24:15.677499'),('63gwv2wc4j5ntdkjm9ntdof23j5t8xvw','.eJxdkM1uwyAQhF_F4tRKiX_IxoacempufYUIw9Kg2oDAaQ9R3r2Qpgntjd1vZhbNmcjJoF3wYBTZdZt-dV9YNyPZkVcMVljlyINENwb8xQHNImJBcRZmSkTfjPpHEU-Ktl3_8p5xLd1cWBacUDub85767rniDDhbc-BQiKTXiVPoOes4S5KCabe4BI_L4uOuafxpXDPKuKBDB7ID6IeRqW4rB6AUkLcKaR1orfCz8Ri0iU1OOIDSXPIeQVEJDLZi3ELfZrtuBeqh_sLRp7N-EtalGqRx197o39WtmutQqSA-XKzWlTJiFumzZVVWYUCZvn4mOWczJIY-ed9yGysSTuIxSBGLaRQmBFdQN_sJ55R7X15WZMk3jy4epAjBpFc-BTQp9vvM_6_hcvkGw0WrLA:1wpXEZ:ltLN0AJhG7EVRR6IFdxnM1yFs7h5GnjLTLhYvdNFXf4','2026-08-13 20:20:03.510670'),('aeaxdy48mcm0hga96n744ul2vsiwu16i','.eJztV8FuozAU_BVkaW9JMAZj4Ljd7Z721tuqQi_GSdgCZsFUqqr8-xoCVQKERCjKpb2E-GH7PWbGY_sd7eJSySLmMuQyzQsoUfDnHeUiiiOJgncUR2HXcNwFikDBRwBhamLPJJi4hkUDaqGTDmFc1p3q10vsLTF9ajoFNl1iO8BY9y4VqEqnRGBwSONsJ9F-gWIlskMdOvuhLBS4bIHyQkaVauvSBdEFymQqwjZeT_QAfCe4TPTkcQpbkR6_3CmVl4Fp5tV66RHPB8Ish1uO47K1F1mUM4cQR_g4EmRVkFUkXs1uuAlclKWGSv-V679CyW8EWyZv84WqgKzMoRCZEqs82-oCOCix1SMgrKu19Jf9qyBTcQSR0O0FeoVEFmGVxQr0vDpE8QprVKq1kgqSNrBfnALhDYCg3hgQmeBg_CjgRZbG48N9AKEakDrvTeCw6SkadXv_rL8j2xZ16lojz92wDjGPHhAblzC9IGF8jYRxQO1ZEqZDCZMx5tK4BCOFbAtGIuvfvBAKbs8gbzJ1T02fY26qJAmb1OE6Af5yTOQoj-QKHnFP1k2gL2v3067vC5J2OhMYl7QzLWmbXSFpmwV0nivbX5I-L2lnAI47KukGnO91bcbPNC50MeUdkLGwecBDtDnngkFYz6ibwCVZUzbp1Pa0rIl_hayJH1jWLFmTLzM6s79OmpHt9VmzsYnZB2sWnWCNLW381HTSfM1hjY6YkTNk7ZcsCnkfymxTyer0NDSbrr7jNIGLdOFJulifLuIf0zW5yNiS-O0iw-4suqyhPdpn7bE9yHb-aDwmb3fwSN_szDHcJG_h5vyKu2bTIP1Ngww3DTpiPZ94R72gb5dM6ntwYyXesb7pBX17zXHfD4gzS994yCQbMvkbSi6VuI8hEXMt9f1M3uh-1qfsmh2k7bT_D0h7Wwc:1ws3zb:B3f7zgndmkVOON-gpJu-p82gv85-PdBs4NHEMN0peLg','2026-08-20 19:43:03.420629'),('bdln73i8xtnracvkgme69uci7uodgd3k','.eJxVkMFuwyAQRH_F4tRKiW3IxgafeuqxvxBhWFpUGxDY7SHKvxenaUKPO29mQHMmarLoFjxZTQZ66HZ3wfkZyUBeMTrptCcPkvwY8Q9HtItMBcVZ2ikTcwuaX0daNWtp9_K-4Vr5uYgsOKHxbut76uhzJTgIvhcgoDCpYDJn0AlOBc-Wghm_-Aw_liWkoWnCOu4540KynoKiAF0_ck2PqgfGAEWrkdWR1Rq_moDR2NRsDSfQRijRIWimgMNRjkfo2i1uWommr79xDPnZMEnn8wzK-utuh__SbZrrUekoP32q9pVfYzkiOo0RVf72mVw7-sww5NzbtsSOxFU-DiVTcY3SxugL6ucw4Zx77-Ll8gMST5k3:1whCFh:suyhNaYiqXHkd5VHAIg5BsEJVmGOzA8pFh0EOi76RNM','2026-07-21 20:18:45.936087'),('emc70y9qi3yveio56fvmwa924qj5xysg','.eJzVV0uP2zYQ_iuCgAIJYFskRVGiTsm26KVoUaDbUxoIFEnZbGRRoaT0sNj_3qFs78qP9TpGEuxebHFmOMP55uNj7kKn5dBqJ6SwhVFhTtNZKGujm16PYxyzR0Fj1zrMw1-1a0SjbPio6Wzp9E7ttOlFN9HqtTA1aKrtxGpj0Q2KIMzeLb16Ie16MqXXta5s4_29YfhtwDPKszmnnE6MZFuBnlDGM8wzMJnoKttbUK76vu3yKGqHcp6RjAuSYioxpSwtM4UTmVJCqOZIabJwZKH0lwjwqEwXeQ8FVRWXnGmqiKQZTUSZUIb89AoJXaWL_3TZQti2Fo0FGKTZ4Ej2RVtoxkGgnPhku2AeKCPWAhY7hapRGmoCS78LvZ_Y10O3MPcPj8YsdIN4HEjRTUalMM7Zidau21qvwe-D8H4W9j7mynaFFM4Z-PKhWAIWf3r1RAqjlel664y0hXfmoKr5h7uw1cqo7RKL3YDiWahELx4EIYojlEUEERZglsc83DMoTOeNvHqOsjmKb0ejHMXwnSME1l0v-gFChiKQYj2uCtZket1s1gHRN8sKc4YAcGfV0D9Ax5JZ6HEvtnLv6Gdw04ngphbyU_B3YyrrPOvMWiz1emp4FW-20yM5Rtn9_wQkR9EYsuidaLpWLNpmOZav10uAV2woA7l9HoAPRgmlRwp9EbV1xdDAbnEGEksStIBEu6HsbS_qreD-I2TQLJ3uOr_2Dx93E_eMZk_UjbCjuuEIpdu6JXlMz9QtnSN8OxqdrBtQz-nloJ8sW0yPypbEx2V77z4PphSNFEoEtVA2eH-yama9jG7Nb8Uv4w57E789CTRGB0jjY6TZAdDsBM6vO5M9irCzDEmeYQi5hCEkx_QahsQvAdcTexGTA2BHwXmOvL5c9liykT5JE_oMTfAlNMEAyTU0IcfQkkugvfnO2w-jQ2jRszR5fbns0wSdpUl8niYku4AmJLuSJvgl7MBvct-8tky-4r4hhwwhLELs8SA595Jkc8LGg4Tn9Kr75vgh-bJxfZohry2Tr2DIUa9xwJBzZ8gDQzK4kK_pNUh2BCw9cT5vew3otpYArPW_rdO9-AH9Bo2qoa6LMXRRTjsP6NL7i7qPE3WLD4__eHfQT8Hhx-DwY3D-Eo36Z0BI49qIAEgn66HU3wOaGogNHx0EFBDrZPLxt7rHD1lMd0aFGPpVMXTajQFD_xaayEooEbT-oFD_QtHsQlo4qEy58CaLrbZb_G6Vrm-2tnsOVqJbebdlSngWlylOtY4VSTOV4DhNZcpVBbBxLkvGOapKmaKyTECBYyYQjzVPcZWE9_8DyZzb2Q:1wrJeI:z8EISayOKlk1MI62pnk_zsHG1NQCNxYzSZLBTtUeycM','2026-08-18 18:13:58.223929'),('hjnjd1adewqg3y6j3cl8lnveodny005f','.eJzVl0tvozAQx78KsrTSrpQEvyCEW7u7pz1ub90KTbCXWuVV2_RS9buvyaNtgJA0alfNJRhnYDz_-XnMPKJbZWylVVolaVXUGgyKrx9RLYUSFYofkRLJ9oaTCRJg4XkCYebjyKeYhh4JY7ZAOwaJMq1R-_cUR1PMrlZGMWZuHGPsrI0F2ziXCLwUClXeVuhpgpSV5Xodzvt6WSgO8QTVuhKN3azLTQUTVFaFTDbz7Yu-u9cY8C5zSO-8n4XSYKVxnlQBmSxeW95aW5vY9-tmOY1otAA6JzwlnIfzZSRIkM45pVwusJB0pulMyAd_-7ifrtxsr18oJthftj4TufE5q8vM-U3dOHMCQ9KumLro7hsorRIgpLufoAfIK500pbKglQstCPDMhWqapa0s5JuJpxsXQplpaUy7-Oub7YM7RpM9maNhL3PEx_NN5oKY8ZHMzaeYXK2MBjMnS6tl1si9iWO8l7iA9RN3oe8btYQyBQFeDqLyLgbTporMv1K_kh8a7irzlX0bFJrgjtKkr3TYEToc0Pm8I9lBJBwlJDhACD2GEBoTfgoh7DPoOrAXCe0Iu5oYZ-T8YtmhZD27FxN-ABNyDCbESXIKJrQvLT1G2ssP3n4Ed6XFBzE5v1h2McGjmLBxTGh0BCY0OhET8hl24LucN-cWyRvOG9olhIY-Dl8Kydi3ZDil4aqQLGJ-0nnT_5T83LruJ-TcInkDIb1uo0PIWA15JiRyB_Ip3QaNesLygfq86TYKKDMnbNX-1lpa-A8NB_f_NnmerFwn69bDaihNDdptgKO6j4G8sW75Z9tC_1qcRV-cRV-c31CKPw3GkuQKPAddmjdL-RHS5A5sNzDOIThfg8Gz9zrHuxTztdHTP6XY9mI:1wsPCU:GyC0x83gUYcn8j7p7ONXzI-f4DiorSTgS7Zps_HzDBY','2026-08-21 18:21:46.712166'),('ku4z9dr5truqxqbuioxokumv7ph1fnwv','.eJzVl0tvozAQx78KsrTSrpQEvyCEW7u7pz1ub90KTbCXWuVV2_RS9buvyaNtgJA0alfNJRhnYDz_-XnMPKJbZWylVVolaVXUGgyKrx9RLYUSFYofkRLJ9oaTCRJg4XkCYebjyKeYhh4JY7ZAOwaJMq1R-_cUR1PMrlZGMWZuHGPsrI0F2ziXCLwUClXeVuhpgpSV5Xodzvt6WSgO8QTVuhKN3azLTQUTVFaFTDbz7Yu-u9cY8C5zSO-8n4XSYKVxnlQBmSxeW95aW5vY9-tmOY1otAA6JzwlnIfzZSRIkM45pVwusJB0pulMyAd_-7ifrtxsr18oJthftj4TufE5q8vM-U3dOHMCQ9KumLro7hsorRIgpLufoAfIK500pbKglQstCPDMhWqapa0s5JuJpxsXQplpaUy7-Oub7YM7RpM9maNhL3PEx_NN5oKY8ZHMzaeYXK2MBjMnS6tl1si9iWO8l7iA9RN3oe8btYQyBQFeDqLyLgbTporMv1K_kh8a7irzlX0bFJrgjtKkr3TYEToc0Pm8I9lBJBwlJDhACD2GEBoTfgoh7DPoOrAXCe0Iu5oYZ-T8YtmhZD27FxN-ABNyDCbESXIKJrQvLT1G2ssP3n4Ed6XFBzE5v1h2McGjmLBxTGh0BCY0OhET8hl24LucN-cWyRvOG9olhIY-Dl8Kydi3ZDil4aqQLGJ-0nnT_5T83LruJ-TcInkDIb1uo0PIWA15JiRyB_Ip3QaNesLygfq86TYKKDMnbNX-1lpa-A8NB_f_NnmerFwn69bDaihNDdptgKO6j4G8sW75Z9tC_1qcRV-cRV-c31CKPw3GkuQKPAddmjdL-RHS5A5sNzDOIThfg8Gz9zrHuxTztdHTP6XY9mI:1ws3rb:gNoMaHFVVDLuwv0gRrFiAgk4OrCbTqbdqv_KHC60z8U','2026-08-20 19:34:47.077164'),('qlvx2wod6yumhlkfk3p3qzk5psqgr4y0','.eJxdkMFuwyAQRH_F4tRKiW3Ixoaceuqx6h9EGJYGxTYISHuI8u-FNE3c3th9M7NozkSNFueEe6vJjm661X0xuwnJjrximOWsHXmQ6IaAvzigTTIuKE7SjpmYm9H8KOJJs5Z2Lx8F18pNC0vCEY2bS95TR58rwUHwtQABC5HyJnMGneBU8CxZMOOSy_CQko-7pvGnYc0ZF5L1FBQF6PqBa7pVPTAGKFqNrA6s1vjZeAzGxqYk7EEboUSHoJkCDls5bKFri920Ek1ff-Hg81k_ytnlGpR1197Y39WtmutQ6SCPLlbrSls5yfzZZVWzxoAqf_1MSs6mzwx99r6VNlYknORjUDIupkHaENyCusmPOOXc-_KyIqncPLi4VzIEm1_lFLCseC_4_5ZeLt8Zs6rr:1wpXCf:are8vjdEpmid6QLlTuqSoRO3NPZYkkuaOo-i1FP3YNY','2026-08-13 20:18:05.505635'),('si7k3p7ck8km2ygto2g23jza2710cz6r','.eJxVkE1ugzAQha8SsWqlBLAx2JNV1XbbXiHyzzihAYwMtIsod69No8ZZznxv3sybS3aQy3w6LBP6Q2uyfUaybdpTUp9xiMB8yeHocu2G2bcqj5L8Rqf8wxnsXm_aB4OTnE7RVnEKolKccMTKUC5MTSrONQdjOWEAWjUApVWal0rVAZCqkSVUCJzYOpjqrsVhxvXMwO6NwfUYVrx7eXZTIpyc8niDb92iEoS9bLsYap15OcYyROsTyYwdWjfE4aeGPG9AMBA7YMASkR5t4JQ1IAiIIEmYdbML8DTP47QvinFRO0EFSBriasJYw5UwpNacUcoQSoM09zQ3-F2M6G07FdHhwIwFDQ0yQzUTrJaqZk0Zx20p0fL8B9UY1o6dHFzIrFu3vqh6bN3-sBabv9ib3cYt3qVvGQx61OHsS7Z68MBwDHOf8RPbzC_yXmg5JZWSrfcuoa4fO-yD73_zev0FAzLHxA:1wfik4:dOjQJAL5pdgVg3RcYcRL4W3zp1b4UcRPy0Q_zUY2ie4','2026-07-17 18:36:00.818459');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `endereco_cliente`
--

DROP TABLE IF EXISTS `endereco_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `endereco_cliente` (
  `id_ENDERECO_CLIENTE` int NOT NULL AUTO_INCREMENT,
  `cep_ENDERECO_CLIENTE` varchar(8) DEFAULT NULL,
  `complemento_ENDERECO_CLIENTE` varchar(45) DEFAULT NULL,
  `bairro_ENDERECO_CLIENTE` varchar(45) DEFAULT NULL,
  `casa_ENDERECO_CLIENTE` varchar(45) DEFAULT NULL,
  `rua_ENDERECO_CLIENTE` varchar(45) DEFAULT NULL,
  `cliente_id_cliente` int NOT NULL,
  PRIMARY KEY (`id_ENDERECO_CLIENTE`),
  UNIQUE KEY `cliente_id_cliente` (`cliente_id_cliente`),
  CONSTRAINT `fk_cliente_endereco` FOREIGN KEY (`cliente_id_cliente`) REFERENCES `clientes` (`id_CLIENTES`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco_cliente`
--

LOCK TABLES `endereco_cliente` WRITE;
/*!40000 ALTER TABLE `endereco_cliente` DISABLE KEYS */;
INSERT INTO `endereco_cliente` VALUES (37,'None','None','None','None','None',136),(38,NULL,NULL,NULL,NULL,NULL,137),(39,'None','None','None','None','None',146),(40,'66110-50','perto do teste da teste','testeiro','0','teste',151),(41,'sdfsdfsd','1231231233535','None','ssdfsdfsdf','',138);
/*!40000 ALTER TABLE `endereco_cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `endereco_funcionarios`
--

DROP TABLE IF EXISTS `endereco_funcionarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco_funcionarios`
--

LOCK TABLES `endereco_funcionarios` WRITE;
/*!40000 ALTER TABLE `endereco_funcionarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `endereco_funcionarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `funcionarios`
--

DROP TABLE IF EXISTS `funcionarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funcionarios` (
  `id_FUNCIONARIOS` int NOT NULL AUTO_INCREMENT,
  `nome_FUNCIONARIOS` varchar(45) NOT NULL,
  `telefone_FUNCIONARIOS` varchar(45) NOT NULL,
  `email_FUNCIONARIOS` varchar(45) NOT NULL,
  `sexo_FUNCIONARIOS` varchar(20) NOT NULL,
  `login_FUNCIONARIOS` varchar(45) NOT NULL,
  `senha_FUNCIONARIOS` varchar(255) NOT NULL,
  `SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS` int NOT NULL,
  `criado_em` datetime DEFAULT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_FUNCIONARIOS`),
  KEY `fk_FUNCIONARIOS_SETOR_FUNCIONARIOS1_idx` (`SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS`),
  CONSTRAINT `fk_FUNCIONARIOS_SETOR_FUNCIONARIOS1` FOREIGN KEY (`SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS`) REFERENCES `setor_funcionarios` (`id_SETOR_FUNCIONARIOS`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionarios`
--

LOCK TABLES `funcionarios` WRITE;
/*!40000 ALTER TABLE `funcionarios` DISABLE KEYS */;
INSERT INTO `funcionarios` VALUES (40,'Nayane','91980374085','cnayane462@gmail.com','feminino','Nayne','123456',2,NULL,NULL),(41,'Fernando','91555555555','fernando@gmail.com','masculino','Fernando','123456',3,NULL,NULL),(42,'Lucas','918787878787','lucas123@gmail.com','masculino','Lucas','123456',1,NULL,NULL),(43,'Felipe','9178451223','felipe@gmail.com','masculino','Felipe_vendas','$argon2id$v=19$m=65536,t=3,p=4$I+HzlwvVXgNmiyLN/wmGrw$aZHC4F9yEPeI3NaIl/L9Ett+E6X7J9wcXbe9qY6uCKc',3,NULL,NULL),(44,'','91980374085','mulldl22312@gmail.com','Feminino','mulldl22312@gmail.com','$argon2id$v=19$m=65536,t=3,p=4$ZooBblGGm/PJX5jxdmMUlQ$wtex6bIMSvouwDmb7Mmkbkc6cgV4TZka/QUtoYPK49A',1,'2026-08-07 16:33:48','2026-08-07 16:34:30');
/*!40000 ALTER TABLE `funcionarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historico_titulos`
--

DROP TABLE IF EXISTS `historico_titulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_titulos` (
  `id_historico` int NOT NULL AUTO_INCREMENT,
  `titulo_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `ativo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_historico`),
  KEY `fk_historico_titulos_titulos1_idx` (`titulo_id`),
  KEY `fk_historico_titulos_clientes_idx` (`cliente_id`),
  CONSTRAINT `fk_historico_titulos_clientes` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id_CLIENTES`),
  CONSTRAINT `fk_historico_titulos_titulos1` FOREIGN KEY (`titulo_id`) REFERENCES `titulos` (`id_titulo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historico_titulos`
--

LOCK TABLES `historico_titulos` WRITE;
/*!40000 ALTER TABLE `historico_titulos` DISABLE KEYS */;
/*!40000 ALTER TABLE `historico_titulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagem_produto`
--

DROP TABLE IF EXISTS `imagem_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imagem_produto` (
  `id_IMAGEM_PRODUTO` int NOT NULL AUTO_INCREMENT,
  `imagem_IMAGEM` varchar(255) NOT NULL,
  `ordem_IMAGEM` int NOT NULL,
  `PRODUTOS_id_PRODUTOS` int NOT NULL,
  PRIMARY KEY (`id_IMAGEM_PRODUTO`),
  KEY `imagem_produto_PRODUTOS_id_PRODUTOS_97d47262` (`PRODUTOS_id_PRODUTOS`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagem_produto`
--

LOCK TABLES `imagem_produto` WRITE;
/*!40000 ALTER TABLE `imagem_produto` DISABLE KEYS */;
INSERT INTO `imagem_produto` VALUES (51,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%201/cachecol_transparent%20(3).png',0,0),(52,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%205/caneca_transparente.png',0,58),(53,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%205/caneca_inclinado.png',1,58),(54,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%205/caneca_detalhe.png',2,58),(55,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%201/cachecol_transparente.png',0,45),(56,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%201/cachecol_frente.png',1,45),(57,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%201/cachecol_costa.png',2,45),(58,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%201/cachecol_detalhe.png',3,45),(59,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%202/boneco_transparente.png',0,47),(60,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%202/boneco_drakos_detalhe.png',1,47),(61,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%202/boneco_drakos_pes.png',2,47),(62,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%203/touca_transparent.png',0,44),(63,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%203/touca_Drakos_logo.png',1,44),(64,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%203/touca_Drakos_detalhe.png',2,44),(65,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%204/olhadeira_transparent.png',0,57),(66,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%204/olhadeira_costa.png',1,57),(67,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%206/chaveiro_transparente.png',0,59),(68,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%206/chaveiro_detalhe.png',1,59),(69,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%207/capa_transparente.png',0,60),(70,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%207/capa_detalhe_camera.png',1,60),(71,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%207/capa_detalhe.png',2,60),(72,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%201/casaco_transparent.png',0,66),(73,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%201/casaco_preto_costa.png',1,66),(74,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%201/casaco_preto_logo2.png',3,66),(75,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%201/casaco_preto_logo.png',2,66),(76,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%2010/black_emirates.png',0,65),(77,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%2010/black_emirates_costa.png',1,65),(78,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%2010/black_emirates_detalhe.jpg',2,65),(79,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%2010/black_emirates_logo.jpg',3,65),(80,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%202/Opel_transparent.png',0,67),(81,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%202/opel_costa%20(1).png',1,67),(82,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%202/opel_detalhe_gola.png',2,67),(83,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%202/opel_logo.png',3,67),(84,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%203/emirates_transparente.png',0,68),(85,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%203/emirates_costa.png',1,68),(86,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%203/emirates_mulher.png',2,68),(87,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%203/emirates_detalhe.webp',3,68),(88,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%204/full_manga_black_transparent.png',0,42),(89,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%204/full_black_costa.png',1,42),(90,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%204/full_black_detalhe.png',2,42),(91,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%204/full_black_logo.png',3,42),(92,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%205/white_version_frente.png',0,69),(93,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%205/white_version_costa.png',1,69),(94,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%205/white_version_dobrada.png',2,69),(95,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%205/white_version_costa_detalhe.png',3,69),(96,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%206/slam_jam_frente.png',0,61),(97,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%206/slam_jam_costa.png',1,61),(98,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%206/slam_jam_modelo.png',2,61),(99,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%207/preto_vermelho_frente.png',0,62),(100,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%207/preto_vermelho_costa.png',1,62),(101,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%207/preto_vermelho_homem.png',2,62),(102,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%207/preto_vermelho_mulher.png',3,62),(103,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%208/bwin_frente.png',0,64),(104,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%208/bwin_costa.png',1,64),(105,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%208/bwin_detalhe.png',2,64),(106,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%209/emirates_fly_frente.png',0,63),(107,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%209/emirates_fly_costa.png',1,63),(108,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%209/emirates_fly_dobrado.png',2,63),(109,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%209/emirates_fly_detalhe_costa.png',3,63);
/*!40000 ALTER TABLE `imagem_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jogos`
--

DROP TABLE IF EXISTS `jogos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jogos` (
  `id_jogos` int NOT NULL AUTO_INCREMENT,
  `dia_jogo` date NOT NULL,
  `hora_jogo` time NOT NULL,
  `local_jogo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `casa_fora` enum('casa','fora') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `times_id_times` int NOT NULL,
  PRIMARY KEY (`id_jogos`),
  KEY `fk_jogos_times1_idx` (`times_id_times`),
  CONSTRAINT `fk_jogos_times1` FOREIGN KEY (`times_id_times`) REFERENCES `times` (`id_times`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jogos`
--

LOCK TABLES `jogos` WRITE;
/*!40000 ALTER TABLE `jogos` DISABLE KEYS */;
INSERT INTO `jogos` VALUES (1,'2026-10-15','16:00:00','Estádio Drakos Arena','casa',1),(2,'2026-10-22','18:30:00','Maracanã','fora',2),(3,'2026-10-01','20:00:00','Estádio Drakos Arena','casa',3),(4,'2026-10-08','16:00:00','Morumbi','fora',4),(5,'2026-10-15','19:00:00','Estádio Drakos Arena','casa',6),(6,'2026-10-22','17:30:00','Arena do Grêmio','fora',6),(7,'2026-07-23','18:00:00','Maracana','fora',2),(8,'2026-07-22','21:30:00','neo quimica arena','fora',3),(9,'2026-08-11','20:30:00','Neo quimica arena','fora',4),(10,'2026-07-23','18:00:00','Morumbi','fora',6),(11,'2026-07-23','18:00:00','Morumbi','fora',6);
/*!40000 ALTER TABLE `jogos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `id_PEDIDO` int NOT NULL AUTO_INCREMENT,
  `data_PEDIDO` datetime NOT NULL,
  `status` enum('entregue','a caminho') NOT NULL,
  `CLIENTES_id_CLIENTES` int NOT NULL,
  `FUNCIONARIOS_id_FUNCIONARIOS` int DEFAULT NULL,
  PRIMARY KEY (`id_PEDIDO`),
  KEY `fk_PEDIDO_CLIENTES1_idx` (`CLIENTES_id_CLIENTES`),
  KEY `fk_PEDIDO_FUNCIONARIOS1_idx` (`FUNCIONARIOS_id_FUNCIONARIOS`),
  CONSTRAINT `fk_PEDIDO_CLIENTES1` FOREIGN KEY (`CLIENTES_id_CLIENTES`) REFERENCES `clientes` (`id_CLIENTES`),
  CONSTRAINT `fk_PEDIDO_FUNCIONARIOS1` FOREIGN KEY (`FUNCIONARIOS_id_FUNCIONARIOS`) REFERENCES `funcionarios` (`id_FUNCIONARIOS`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (21,'2026-06-26 18:38:33','a caminho',136,NULL),(22,'2026-06-26 18:39:44','entregue',136,NULL),(23,'2026-07-01 18:28:53','entregue',136,NULL),(24,'2026-07-01 18:31:53','entregue',136,NULL),(25,'2026-07-01 18:32:14','entregue',136,NULL),(26,'2026-07-01 18:34:03','entregue',136,NULL),(27,'2026-07-16 19:51:34','a caminho',146,NULL),(28,'2026-07-16 19:55:44','a caminho',146,NULL),(29,'2026-07-16 20:14:19','entregue',146,NULL),(31,'2026-07-27 18:02:28','a caminho',149,NULL),(32,'2026-07-27 18:39:19','a caminho',149,NULL),(33,'2026-07-27 18:41:04','a caminho',149,NULL),(34,'2026-07-27 18:58:04','a caminho',150,NULL),(35,'2026-07-27 20:28:21','a caminho',149,NULL),(36,'2026-07-28 18:59:24','a caminho',138,NULL),(37,'2026-07-29 18:29:06','a caminho',138,NULL),(38,'2026-07-30 18:15:00','a caminho',138,NULL),(39,'2026-07-31 18:48:41','a caminho',151,NULL),(40,'2026-07-31 19:44:29','entregue',151,NULL),(41,'2026-08-03 19:39:03','a caminho',136,NULL),(42,'2026-08-04 19:50:57','a caminho',153,NULL),(43,'2026-08-05 18:29:11','a caminho',138,NULL),(44,'2026-08-05 18:37:55','a caminho',138,NULL),(45,'2026-08-05 18:50:53','a caminho',138,NULL),(46,'2026-08-05 18:51:35','a caminho',138,NULL);
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (42,'Camisa manga longa preta',300,'Camisa chique de manga longa',98,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%204/full_manga_black_transparent.png',NULL),(44,'Gorro',150,'Gorro para esquentar o crânio do frio com o calor do seu time',17,1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%203/touca_transparent.png',NULL),(45,'Cachecol',150,'Se proteja do frio com amor pelo seu time',17,1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%201/cachecol_transparente.png',NULL),(47,'Mascote',95,'Divirta-se',30,1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%202/boneco_transparente.png',NULL),(49,'Sandália do clube',99.99,'Conforto e paixão',0,3,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/calcados/sandalia.png',NULL),(52,'Arquibancada lado B',100,'Drako X Palmeiras - 01/10/2026',49,10,'img/TiK_Drakos(3).png',3),(53,'Arquibancada lado A',60,'Drako X Palmeiras - 01/10/2026',139,10,'img/TiK_Drakos(3).png',3),(54,'Camarote Premium',175,'Drako x Palmeiras - 01/10/2026',7,10,'img/TiK_Drakos(3).png',3),(55,'Camarote',150,'Drako x Palmeiras - 01/10/2026',15,10,'img/TiK_Drakos(3).png',3),(57,'Olhadeira Drakos',45.9,'Olhadeira personalizada Drakos, material confortável e ajustável.',48,1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%204/olhadeira_transparent.png',NULL),(58,'Caneca Drakos FC',35,'Caneca de cerâmica de alta qualidade com escudo do clube.',99,1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%205/caneca_transparente.png',NULL),(59,'Chaveiro Metálico',15,'Chaveiro robusto com acabamento em aço escovado.',200,1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%206/chaveiro_transparente.png',NULL),(60,'Capa de Telefone Premium',59.9,'Capa protetora anti-impacto compatível com diversos modelos.',80,1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/acessorios/objeto%207/capa_transparente.png',NULL),(61,'Camisa Drakos Slam Jam',259.9,'Camisa esportiva com design listrado em branco e vermelho.',38,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%206/slam_jam_frente.png',NULL),(62,'Uniforme Classic',289.9,'Edição especial com grafismos modernos em tons de preto e vermelho.',28,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%207/preto_vermelho_frente.png',NULL),(63,'Camisa Drakos Emirates Fly',320,'Reedição histórica do uniforme utilizado na temporada de 2006.',14,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%209/emirates_fly_frente.png',NULL),(64,'Camisa Away White 25/26',299.9,'Uniforme reserva para a temporada 2025/2026 na cor branca.',55,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%208/bwin_frente.png',NULL),(65,'Camisa Black Emirates',275,'Uniforme alternativo preto com tecnologia de alta performance.',22,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%2010/black_emirates.png',NULL),(66,'Casaco Black Drakos',349.9,'Casaco esportivo oficial na cor preta, material térmico de alta qualidade.',20,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%201/casaco_transparent.png',NULL),(67,'Camisa White Opel',279.9,'Camisa branca listrada retrô com patrocínio clássico Opel.',15,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%202/Opel_transparent.png',NULL),(68,'Camisa Drakos White Red Emirates',259.9,'Camisa oficial branca com detalhes em vermelho, edição temporada.',40,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%203/emirates_transparente.png',NULL),(69,'Camisa White Version',265,'Versão alternativa branca com tecido tecnológico para maior ventilação.',35,2,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/produtos/camisas/camisa%205/white_version_frente.png',NULL);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progresso_fases`
--

DROP TABLE IF EXISTS `progresso_fases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progresso_fases` (
  `cliente_id` int NOT NULL,
  `fase2_liberada` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`cliente_id`),
  CONSTRAINT `fk_progresso_fases_clientes` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id_CLIENTES`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progresso_fases`
--

LOCK TABLES `progresso_fases` WRITE;
/*!40000 ALTER TABLE `progresso_fases` DISABLE KEYS */;
/*!40000 ALTER TABLE `progresso_fases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questoes`
--

DROP TABLE IF EXISTS `questoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questoes` (
  `id_questao` int NOT NULL AUTO_INCREMENT,
  `pergunta` text NOT NULL,
  PRIMARY KEY (`id_questao`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questoes`
--

LOCK TABLES `questoes` WRITE;
/*!40000 ALTER TABLE `questoes` DISABLE KEYS */;
INSERT INTO `questoes` VALUES (1,'Qual time é conhecido como \"Verdão\" e joga no Allianz Parque?'),(2,'Em qual estádio o Flamengo e o Fluminense costumam mandar seus jogos?'),(3,'Qual destes times é conhecido como \"Imortal Tricolor\"?'),(4,'Qual time paulista tem o apelido de \"Peixe\" e revelou o Pelé?'),(5,'Qual é o time que possui o maior número de títulos do Campeonato Brasileiro até 2024?'),(6,'O Sport Club Internacional pertence a qual cidade?'),(7,'Qual time é o atual campeão da Copa Libertadores da América (2023)?'),(8,'Qual time mineiro joga na Arena MRV?'),(9,'Qual é o mascote oficial do Fortaleza Esporte Clube?'),(10,'Qual time é conhecido como o \"Clube da Fé\" e joga no MorumBIS?');
/*!40000 ALTER TABLE `questoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recuperacao_senha`
--

DROP TABLE IF EXISTS `recuperacao_senha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recuperacao_senha` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(6) NOT NULL,
  `criado_em` datetime(6) NOT NULL,
  `cliente_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recuperacao_senha_cliente_id_892afddd` (`cliente_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recuperacao_senha`
--

LOCK TABLES `recuperacao_senha` WRITE;
/*!40000 ALTER TABLE `recuperacao_senha` DISABLE KEYS */;
INSERT INTO `recuperacao_senha` VALUES (38,'490732','2026-07-07 19:52:19.847251',137),(39,'469999','2026-07-07 20:15:22.568228',137);
/*!40000 ALTER TABLE `recuperacao_senha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respostas`
--

DROP TABLE IF EXISTS `respostas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respostas` (
  `cliente_id` int NOT NULL,
  `questao_id` int NOT NULL,
  `alternativa_id` int NOT NULL,
  `combo_max` int DEFAULT NULL,
  PRIMARY KEY (`cliente_id`,`questao_id`),
  KEY `fk_respostas_questoes1_idx` (`questao_id`),
  KEY `fk_respostas_clientes1_idx` (`cliente_id`),
  KEY `fk_respostas_alternativas1_idx` (`alternativa_id`),
  CONSTRAINT `fk_respostas_alternativas1` FOREIGN KEY (`alternativa_id`) REFERENCES `alternativas` (`id_alternativa`),
  CONSTRAINT `fk_respostas_clientes1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id_CLIENTES`),
  CONSTRAINT `fk_respostas_questoes1` FOREIGN KEY (`questao_id`) REFERENCES `questoes` (`id_questao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respostas`
--

LOCK TABLES `respostas` WRITE;
/*!40000 ALTER TABLE `respostas` DISABLE KEYS */;
/*!40000 ALTER TABLE `respostas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setor_funcionarios`
--

DROP TABLE IF EXISTS `setor_funcionarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setor_funcionarios` (
  `id_SETOR_FUNCIONARIOS` int NOT NULL AUTO_INCREMENT,
  `nome_SETOR_FUNCIONARIOS` varchar(45) NOT NULL,
  `descricao_setor` mediumtext NOT NULL,
  PRIMARY KEY (`id_SETOR_FUNCIONARIOS`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setor_funcionarios`
--

LOCK TABLES `setor_funcionarios` WRITE;
/*!40000 ALTER TABLE `setor_funcionarios` DISABLE KEYS */;
INSERT INTO `setor_funcionarios` VALUES (1,'Financeiro','Geração de relatórios e análise de lucros'),(2,'Administrativo','Gerencia contratos e conta de funcionários'),(3,'Comercial','Cuida das vendas e produtos'),(4,'TI','Funcionamaneto do sitema e segurança');
/*!40000 ALTER TABLE `setor_funcionarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `times`
--

DROP TABLE IF EXISTS `times`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `times` (
  `id_times` int NOT NULL AUTO_INCREMENT,
  `nome_time` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `url_brasao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_times`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `times`
--

LOCK TABLES `times` WRITE;
/*!40000 ALTER TABLE `times` DISABLE KEYS */;
INSERT INTO `times` VALUES (1,'Palmeiras','img/brasoes/palmeiras.png'),(2,'Flamengo','img/brasoes/escudo_flamengo.png'),(3,'Corinthians','img/brasoes/escudo_corinthians.png'),(4,'São Paulo',''),(5,'Santos',''),(6,'Grêmio','img/brasoes/gremio.png');
/*!40000 ALTER TABLE `times` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `titulos`
--

DROP TABLE IF EXISTS `titulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `titulos` (
  `id_titulo` int NOT NULL AUTO_INCREMENT,
  `nome_titulo` varchar(45) NOT NULL,
  PRIMARY KEY (`id_titulo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `titulos`
--

LOCK TABLES `titulos` WRITE;
/*!40000 ALTER TABLE `titulos` DISABLE KEYS */;
INSERT INTO `titulos` VALUES (1,'Pelé do Quiz'),(2,'Rei da Libertadores'),(3,'Artilheiro'),(4,'Craque da Série A'),(5,'Bragre da Série B');
/*!40000 ALTER TABLE `titulos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-07 17:29:17
