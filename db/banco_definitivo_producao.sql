CREATE DATABASE  IF NOT EXISTS "projeto_futebol_definitivo" /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `projeto_futebol_definitivo`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: mysql-2c986886-futibou5t67.k.aivencloud.com    Database: projeto_futebol_definitivo
-- ------------------------------------------------------
-- Server version	8.0.45

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '2fd967a3-0871-11f1-99aa-b2ddb1ff5500:1-31,
32798cb9-ebf6-11f0-9f6b-4afd0fc79d7a:1-83,
573bbb6d-0384-11f1-b61e-9258c47ebf30:1-89,
65586d13-5eac-11f1-bfc6-3e3c25bf0fbe:1-423,
dcaa4ec7-efee-11f0-a8ab-d61b86fcd61b:1-473,
fb365816-11bd-11f1-bbb6-0a56e58875f3:1-2859';

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
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add categoria cliente',7,'add_categoriacliente'),(26,'Can change categoria cliente',7,'change_categoriacliente'),(27,'Can delete categoria cliente',7,'delete_categoriacliente'),(28,'Can view categoria cliente',7,'view_categoriacliente'),(29,'Can add categoria produtos',8,'add_categoriaprodutos'),(30,'Can change categoria produtos',8,'change_categoriaprodutos'),(31,'Can delete categoria produtos',8,'delete_categoriaprodutos'),(32,'Can view categoria produtos',8,'view_categoriaprodutos'),(33,'Can add clientes',9,'add_clientes'),(34,'Can change clientes',9,'change_clientes'),(35,'Can delete clientes',9,'delete_clientes'),(36,'Can view clientes',9,'view_clientes'),(37,'Can add compra',10,'add_compra'),(38,'Can change compra',10,'change_compra'),(39,'Can delete compra',10,'delete_compra'),(40,'Can view compra',10,'view_compra'),(41,'Can add endereco cliente',11,'add_enderecocliente'),(42,'Can change endereco cliente',11,'change_enderecocliente'),(43,'Can delete endereco cliente',11,'delete_enderecocliente'),(44,'Can view endereco cliente',11,'view_enderecocliente'),(45,'Can add endereco funcionarios',12,'add_enderecofuncionarios'),(46,'Can change endereco funcionarios',12,'change_enderecofuncionarios'),(47,'Can delete endereco funcionarios',12,'delete_enderecofuncionarios'),(48,'Can view endereco funcionarios',12,'view_enderecofuncionarios'),(49,'Can add funcionarios',13,'add_funcionarios'),(50,'Can change funcionarios',13,'change_funcionarios'),(51,'Can delete funcionarios',13,'delete_funcionarios'),(52,'Can view funcionarios',13,'view_funcionarios'),(53,'Can add pedido',14,'add_pedido'),(54,'Can change pedido',14,'change_pedido'),(55,'Can delete pedido',14,'delete_pedido'),(56,'Can view pedido',14,'view_pedido'),(57,'Can add produtos',15,'add_produtos'),(58,'Can change produtos',15,'change_produtos'),(59,'Can delete produtos',15,'delete_produtos'),(60,'Can view produtos',15,'view_produtos'),(61,'Can add setor funcionarios',16,'add_setorfuncionarios'),(62,'Can change setor funcionarios',16,'change_setorfuncionarios'),(63,'Can delete setor funcionarios',16,'delete_setorfuncionarios'),(64,'Can view setor funcionarios',16,'view_setorfuncionarios'),(65,'Can add perfil',17,'add_perfil'),(66,'Can change perfil',17,'change_perfil'),(67,'Can delete perfil',17,'delete_perfil'),(68,'Can view perfil',17,'view_perfil'),(69,'Can add recuperacao senha',18,'add_recuperacaosenha'),(70,'Can change recuperacao senha',18,'change_recuperacaosenha'),(71,'Can delete recuperacao senha',18,'delete_recuperacaosenha'),(72,'Can view recuperacao senha',18,'view_recuperacaosenha'),(73,'Can add imagem produto',19,'add_imagemproduto'),(74,'Can change imagem produto',19,'change_imagemproduto'),(75,'Can delete imagem produto',19,'delete_imagemproduto'),(76,'Can view imagem produto',19,'view_imagemproduto');
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
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$XrzSwf46GU0btn8fCV9HPl$TKXsFu21ZgFecgLNZfUjP8Cfdgv3v54FP86x58oRzlw=','2026-05-07 16:49:14.215365',1,'fernando','','','',1,1,'2025-09-11 19:21:04.582791');
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
  `senha_CLIENTES` varchar(255) NOT NULL,
  `sexo_CLIENTES` varchar(20) NOT NULL,
  `telefone_CLIENTES` varchar(15) NOT NULL,
  `email_CLIENTES` varchar(50) NOT NULL,
  `nome_CLIENTES` varchar(45) NOT NULL,
  `sobrenome_CLIENTES` varchar(45) NOT NULL,
  `cpf_CLIENTES` varchar(14) NOT NULL,
  `status_CLIENTES` tinyint NOT NULL,
  `url_foto_CLIENTES` varchar(255) DEFAULT NULL,
  `CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE` int NOT NULL,
  `score_rank` int DEFAULT '0',
  `total_acertos` int DEFAULT '0',
  `total_questoes` int DEFAULT '0',
  `precisao` float DEFAULT '0',
  `tempo` time DEFAULT '00:00:00',
  PRIMARY KEY (`id_CLIENTES`),
  KEY `fk_CLIENTES_CATEGORIA_CLIENTE1_idx` (`CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE`),
  CONSTRAINT `fk_CLIENTES_CATEGORIA_CLIENTE1` FOREIGN KEY (`CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE`) REFERENCES `categoria_cliente` (`id_CATEGORIA_CLIENTE`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (136,'pbkdf2_sha256$1000000$9Wn39EEDqVfyf5YG7BcAPB$qdshw5e5nab0o87rPd8syWPb72iT1GzaZ7s/ziG5lZI=','Masculino','(32) 32311-2313','djanjdn131@gmail.com','joao','Ferraira','63412313131',1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/perfis/foto_05d821b9eb1a438fbb58de4702798e50.webp',5,NULL,NULL,NULL,NULL,NULL),(137,'pbkdf2_sha256$1000000$evYJVlBXFbcm22DOOGi8x0$xrOj2UyZbHHrSfvOx+v1Qu0NdBNImWrqHbsMT1Tg3IY=','Masculino','(91) 98471-1434','fernandofreitassud2016@gmail.com','Fernando','Romão','00000000000',1,NULL,5,NULL,NULL,NULL,NULL,NULL),(138,'pbkdf2_sha256$1000000$bFqiqXuykE0iQwDcBEPNEb$EK7OF9SvOlwkBeJ0kVKZ73O2FEqORZqAqyk46Bbiv60=','Masculino','(76) 37267-3267','ndajwnj@gmail.com','Daniel','silva','48324243924',1,'https://pub-8289a2714c14467b8d15c74224e90de2.r2.dev/perfis/foto_2235b34beaa547a0a1a8a2b5dd2b2947.webp',5,NULL,NULL,NULL,NULL,NULL);
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
  PRIMARY KEY (`id_compra`),
  KEY `fk_PRODUTOS_has_PEDIDO_PEDIDO1_idx` (`PEDIDO_id_PEDIDO`),
  KEY `fk_PRODUTOS_has_PEDIDO_PRODUTOS1_idx` (`PRODUTOS_id_PRODUTOS`),
  CONSTRAINT `fk_PRODUTOS_has_PEDIDO_PEDIDO1` FOREIGN KEY (`PEDIDO_id_PEDIDO`) REFERENCES `pedido` (`id_PEDIDO`),
  CONSTRAINT `fk_PRODUTOS_has_PEDIDO_PRODUTOS1` FOREIGN KEY (`PRODUTOS_id_PRODUTOS`) REFERENCES `produtos` (`id_PRODUTOS`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compra`
--

LOCK TABLES `compra` WRITE;
/*!40000 ALTER TABLE `compra` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (17,'accounts','perfil'),(1,'admin','logentry'),(7,'app_futebol','categoriacliente'),(8,'app_futebol','categoriaprodutos'),(9,'app_futebol','clientes'),(10,'app_futebol','compra'),(11,'app_futebol','enderecocliente'),(12,'app_futebol','enderecofuncionarios'),(13,'app_futebol','funcionarios'),(19,'app_futebol','imagemproduto'),(14,'app_futebol','pedido'),(15,'app_futebol','produtos'),(18,'app_futebol','recuperacaosenha'),(16,'app_futebol','setorfuncionarios'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
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
INSERT INTO `django_session` VALUES ('64301d2mnrk5bxx2sybxxt2uzo2makhs','.eJxVkMFuwyAQRH8l4tRKiR0vONg-9dC_qKpogXVChMHCTnKI8u8FK2rdCxLzZhl2Hkw7S36mozWsq3iz_RV8GIh17BO9Jcf-9CmoSC84WXfDFaMBrUu6N3i5-8vHKd8LHYaVZyZHffB5_E0e3jdcwkHueDpWJj32iYuGgwDBWxAr1oc5JHie53HqynK8ql0DTYsgK6ErIQ5SNaaqtRQAgtq9ISgiFIZu5Uixt1OZXzgC8FpxoQixFhL3WGGDoGpjQEErZHEnNabY0aEPaWttw1JS_V96NeExbBZh3YY3FEmnzz5YnuRtYjQmt-QCGiEhmeMVk2BwM4Q4U57GKStLHQptjHlZHVGHlGrsUncYRkdDCsksJTs0YZPeMDGckD237GynOUSrwzF7I06s-_p-_gBdNJ6d:1wc5G6:ktXO6Y2_c6XxBzaRsVyfCiZBOinoUxiCFOASCiv9W14','2026-07-07 17:50:02.819261'),('n10kjqhxolokd3h6xufj3jtmfx554jz1','.eJxVjzFPwzAQhf9KdBNIAdlNSNtMTGwMsAKqrs65tWT7onMyVf3v2FVEgyfffe89vbuA8Y7iRAc3QK-bbf23iBwIengjiRgHhjtJfBRa8CeH71kpatYCCuh8hnbxWiE3YUrzsFG6ez0V_Gw4rCwTebIcS-TDXj9W-1271U-6bdqVyIw2c3V_K2Z5Yujj7H0No8fIuaZxfLvr5f9qqR6Rq9ti3TwOJGRy0gWKs9llRmNWd53WSpU2MmOZiwtT-TYbnYcjOpFshHcUNBhP6M9YRBxGTyHHF_gx4yBY6RauNZxdmlic4UMRCSbov36uv5SUg8c:1wbi1v:Ug_PNTDu3RmfNMiEWDv_vQGMGj6063BnqF8_6dbY_uQ','2026-07-06 17:01:51.038056');
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco_cliente`
--

LOCK TABLES `endereco_cliente` WRITE;
/*!40000 ALTER TABLE `endereco_cliente` DISABLE KEYS */;
INSERT INTO `endereco_cliente` VALUES (37,'','','','','',136),(38,'6611004','Quadra 14','Maracangalha','321','6',137),(39,'73428472','ao lado da droga','cracolandia','67','da morte',138);
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
  `senha_FUNCIONARIOS` varchar(255) NOT NULL,
  `login_FUNCIONARIOS` varchar(45) NOT NULL,
  `telefone_FUNCIONARIOS` varchar(45) NOT NULL,
  `email_FUNCIONARIOS` varchar(45) NOT NULL,
  `sexo_FUNCIONARIOS` varchar(20) NOT NULL,
  `nome_FUNCIONARIOS` varchar(45) NOT NULL,
  `SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS` int NOT NULL,
  PRIMARY KEY (`id_FUNCIONARIOS`),
  KEY `fk_FUNCIONARIOS_SETOR_FUNCIONARIOS1_idx` (`SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS`),
  CONSTRAINT `fk_FUNCIONARIOS_SETOR_FUNCIONARIOS1` FOREIGN KEY (`SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS`) REFERENCES `setor_funcionarios` (`id_SETOR_FUNCIONARIOS`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionarios`
--

LOCK TABLES `funcionarios` WRITE;
/*!40000 ALTER TABLE `funcionarios` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagem_produto`
--

LOCK TABLES `imagem_produto` WRITE;
/*!40000 ALTER TABLE `imagem_produto` DISABLE KEYS */;
INSERT INTO `imagem_produto` VALUES (1,'img/produtos/camisas/camisa_branca_retro/camisa_branca(1).webp',0,36);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jogos`
--

LOCK TABLES `jogos` WRITE;
/*!40000 ALTER TABLE `jogos` DISABLE KEYS */;
INSERT INTO `jogos` VALUES (1,'2026-02-15','16:00:00','Estádio Drakos Arena','casa',1),(2,'2026-02-22','18:30:00','Maracanã','fora',2),(3,'2026-03-01','20:00:00','Estádio Drakos Arena','casa',3),(4,'2026-03-08','16:00:00','Morumbi','fora',4),(5,'2026-03-15','19:00:00','Estádio Drakos Arena','casa',6),(6,'2026-03-22','17:30:00','Arena do Grêmio','fora',6);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (42,'Camisa manga longa preta',300,'Camisa chique de manga longa',7,2,'img/produtos/camisas/camisa 4/full_manga_black_transparent.png',NULL),(44,'Gorro',100,'Gorro para esquentar o crânio do frio com o calor do seu time',1,1,'img/produtos/acessorios/objeto 3/touca_transparent.png',NULL),(45,'cachecol',248.99,'Carregue suas coisas com amor pelo seu time',2,1,'img/produtos/acessorios/objeto 1/cachecol_transparent (3).png',NULL),(47,'Mascote',350,'Divirta-se',23,1,'img/produtos/acessorios/objeto 2/boneco_transparent (3).png',NULL),(49,'Sandália do clube',99.99,'Conforto e paixão',12,3,'img/produtos/calcados/sandalia.png',NULL),(52,'Arquibancada lado B',100,'Drako X Palmeiras - 15/12/2025',60,10,'img/TiK_Drakos(3).png',NULL),(53,'Arquibancada lado A',60,'Drako X Palmeiras - 15/12/2025',146,10,'img/TiK_Drakos(3).png',NULL),(54,'Camarote Premium',175,'Drako x Palmeiras - 15/12/2025',10,10,'img/TiK_Drakos(3).png',NULL),(55,'Camarote',150,'Drako x Palmeiras - 15/12/2025',15,10,'img/TiK_Drakos(3).png',NULL),(57,'Olhadeira Drakos',45.9,'Olhadeira personalizada Drakos, material confortável e ajustável.',50,1,'img/produtos/acessorios/objeto 4/olhadeira_transparent.png',NULL),(58,'Caneca Drakos FC',35,'Caneca de cerâmica de alta qualidade com escudo do clube.',100,1,'img/produtos/acessorios/objeto 5/caneca(3)transparente.png',NULL),(59,'Chaveiro Metálico',15,'Chaveiro robusto com acabamento em aço escovado.',200,1,'img/produtos/acessorios/objeto 6/chaveiro_transparent.png',NULL),(60,'Capa de Telefone Premium',59.9,'Capa protetora anti-impacto compatível com diversos modelos.',80,1,'img/produtos/acessorios/objeto 7/capa_transparent.png',NULL),(61,'Camisa Branca e Vermelha',259.9,'Camisa esportiva com design listrado em branco e vermelho.',40,2,'img/produtos/camisas/camisa 6/white_red (1).jpg',NULL),(62,'Camisa Preto e Vermelho',289.9,'Edição especial com grafismos modernos em tons de preto e vermelho.',30,2,'img/produtos/camisas/camisa 7/preto_vermelho.png',NULL),(63,'Camisa Drakos Retrô 2006',320,'Reedição histórica do uniforme utilizado na temporada de 2006.',15,2,'img/produtos/camisas/camisa 8/milan_r2006(2).png',NULL),(64,'Camisa Away White 25/26',299.9,'Uniforme reserva para a temporada 2025/2026 na cor branca.',55,2,'img/produtos/camisas/camisa 9/white_25.26(1).png',NULL),(65,'Camisa Black Uniform',275,'Uniforme alternativo preto com tecnologia de alta performance.',25,2,'img/produtos/camisas/camisa 10/Black_transpa.png',NULL),(66,'Casaco Black Drakos',349.9,'Casaco esportivo oficial na cor preta, material térmico de alta qualidade.',20,2,'img/produtos/camisas/camisa 1/casaco_transparent.png',NULL),(67,'Camisa Classic White',279.9,'Camisa branca listrada retrô com patrocínio clássico Opel.',15,2,'img/produtos/camisas/camisa 2/Opel_transparent.png',NULL),(68,'Camisa Drakos White Red',259.9,'Camisa oficial branca com detalhes em vermelho, edição temporada.',40,2,'img/produtos/camisas/camisa 3/Camisa_branco_red.png',NULL),(69,'Camisa White Version 2.0',265,'Versão alternativa branca com tecido tecnológico para maior ventilação.',35,2,'img/produtos/camisas/camisa 5/white_version (2).jpg',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recuperacao_senha`
--

LOCK TABLES `recuperacao_senha` WRITE;
/*!40000 ALTER TABLE `recuperacao_senha` DISABLE KEYS */;
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
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-23 15:14:29
