CREATE DATABASE  IF NOT EXISTS `projeto_futebol_teste` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `projeto_futebol_teste`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: projeto_futebol_teste
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$XrzSwf46GU0btn8fCV9HPl$TKXsFu21ZgFecgLNZfUjP8Cfdgv3v54FP86x58oRzlw=','2026-05-11 19:51:30.532188',1,'fernando','','','',1,1,'2025-09-11 19:21:04.582791'),(2,'pbkdf2_sha256$1000000$QU6V6hIiN1IAtDyP1GoQZu$qcNJdiLuTK/fIHN9r0Zo191lZcqzqWnM+NUYl8R0z1Q=','2026-05-12 20:17:59.549588',1,'pedro','','','',1,1,'2026-05-12 20:17:20.935453');
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
  `CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE` int NOT NULL,
  PRIMARY KEY (`id_CLIENTES`),
  UNIQUE KEY `cpf_CLIENTES_UNIQUE` (`cpf_CLIENTES`),
  KEY `fk_CLIENTES_CATEGORIA_CLIENTE1_idx` (`CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE`),
  CONSTRAINT `fk_CLIENTES_CATEGORIA_CLIENTE1` FOREIGN KEY (`CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE`) REFERENCES `categoria_cliente` (`id_CATEGORIA_CLIENTE`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (52,'@N1234567','Masculino','928374651092837','fernando@gmail.com','Fernando','Andrade','123.465.789-15',1,2),(53,'@A4567894','Feminino','470192837465102','cnayane462@gmail.com','Nayane','Cruz','987.654.321-01',1,3),(54,'@E7894564','Masculino','385920174638291','pedroDaniel@gmail.com','Pedro','Silva','555.555.555-55',0,4),(55,'@F5555555','Masculino','360284756102938','emanuelSilva@gmail.com','Emanuel','Silva','666.666.666-66',0,5),(56,'senhA1234!@#','Masculino','91-91234-5678','joao.souza@gmail.com','João','Souza','123.456.789-00',1,2),(57,'senhaTop2023$','Feminino','91-99876-5432','maria.silva@hotmail.com','Maria','Silva','987.654.321-99',1,3),(58,'minhaSenha12','Masculino','91-93456-1234','carlos.santos@yahoo.com','Carlos','Santos','456.789.123-00',1,2),(59,'segura123!senha','Feminino','91-90001-0001','ana.oliveira@gmail.com','Ana','Oliveira','321.654.987-00',1,4),(60,'senhaforte_10','Masculino','91-98888-7777','paulo.lima@outlook.com','Paulo','Lima','159.753.486-00',1,5),(61,'senha$$rapida','Feminino','91-97777-5555','juliana.matos@gmail.com','Juliana','Matos','951.357.852-00',1,3),(62,'novaSenha456','Feminino','91988887777','novoemail@email.com','Nayane','Souza','987.654.321-00',1,3),(63,'senhaPoderosa$','Feminino','91-93456-1122','patricia.alves@terra.com','Patrícia','Alves','654.321.987-00',1,4),(64,'azulao2025@!','Masculino','91-98765-6789','ricardo.menezes@gmail.com','Ricardo','Menezes','321.789.654-00',1,5),(65,'aguiaVIP#2024','Feminino','91-91234-7890','fernanda.lopes@hotmail.com','Fernanda','Lopes','852.963.741-00',1,3),(66,'meuLogin#456','Masculino','91-97654-3210','leandro.sousa@gmail.com','Leandro','Sousa','147.258.369-00',1,2),(67,'senhaNOVA2025','Feminino','91-93214-5678','carla.dias@bol.com.br','Carla','Dias','951.753.456-00',1,4),(68,'champSenha@33','Masculino','91-98700-8899','thiago.rocha@gmail.com','Thiago','Rocha','789.456.123-00',1,3),(69,'senha123super','Feminino','91-93421-8765','marcela.teixeira@uol.com','Marcela','Teixeira','123.321.456-00',1,2),(70,'safadao2025$','Masculino','91-91239-2233','daniel.ferreira@gmail.com','Daniel','Ferreira','741.852.963-00',1,5),(71,'tigronaTOP@1','Feminino','91-90003-4567','beatriz.morais@gmail.com','Beatriz','Morais','159.357.258-00',1,4),(72,'aguiaFiel#55','Masculino','91-91123-4321','rafael.costa@yahoo.com','Rafael','Costa','369.258.147-00',1,3),(73,'senhaUltra!99','Feminino','91-98876-9988','aline.campos@outlook.com','Aline','Campos','654.987.321-00',1,2),(74,'senhaDele2024','Masculino','91-97700-3344','henrique.souza@gmail.com','Henrique','Souza','741.369.258-00',1,5),(75,'campeaoSenha$','Feminino','91-93210-1234','luana.ramos@hotmail.com','Luana','Ramos','963.852.741-00',1,4),(76,'poderosa123','Masculino','91-90090-9090','marcos.barbosa@gmail.com','Marcos','Barbosa','321.456.987-00',1,3),(77,'senhaTeste@22','Feminino','91-92222-2222','bruna.lima@gmail.com','Bruna','Lima','147.369.258-00',1,2),(78,'azulaoFiel#77','Masculino','91-94567-4433','lucas.ribeiro@gmail.com','Lucas','Ribeiro','852.741.963-00',1,3),(79,'senhaTática33','Feminino','91-95555-3333','natalia.araujo@bol.com','Natalia','Araújo','258.963.147-00',1,4),(80,'vipAzulao#88','Masculino','91-94321-1111','bruno.martins@gmail.com','Bruno','Martins','987.321.654-00',1,5),(81,'senha81','feminino','91-98123-0001','ana1@email.com','ana','silva','111.111.111-81',1,4),(121,'@1Jasjokqwe','masculino','91-98234-0002','joao2@email.com','joao','pereira','111.111.111-82',1,2),(122,'@kKkdmfdmf3','feminino','91-98345-0003','lara3@email.com','lara','souza','111.111.111-83',1,3),(123,'@sajudhfAS3','masculino','91-98456-0004','carlos4@email.com','carlos','oliveira','111.111.111-84',1,2),(125,'pbkdf2_sha256$1000000$op4pSOrQEzka71W1jcArOt$myqcrr0aK2YE5xTlqyMF35BdVwYxtlDuOzDbLQEW5fM=','Feminino','91988584965','francileide@yahoo.com','Francileide','Romão','456.123.369-15',1,5),(126,'pbkdf2_sha256$1000000$gYZCCp9J2DYvbqtf65YJ9W$GPzd1qAnyLXWr8WsDjwXwcbQz/sJQZgkvG8GAySygrc=','Masculino','98735-9783','doido@gmail.com','doido01','doidao','125.458.478-12',1,5),(127,'pbkdf2_sha256$1000000$CvVFTj6sSM41vXwE5AWOcp$IH/5MkEcuCJdd3/QkLw0kqP6aQBsG3Boj5iTdKrAS0E=','Masculino','91984711434','fernando10744196@edu.pa.senac.br','Fernando','Freitas','057.858.462-09',1,3),(128,'pbkdf2_sha256$1000000$SCpG0Qz0Als1s5YrR23xRl$yC9Cwrx3upeSVAMDYZMHdRLf9pyhSQiZLFanL0oC2uY=','Feminino','91988584965','jujuba@gmail.com','jujuba','leao','136.458.125-78',1,5),(130,'pbkdf2_sha256$1000000$NjcruSzk1L9nRPnmGR1OGi$DoIMSE/x0qxBHSrf5kOxOXIcPqYKWVTxB156ejBsdb0=','Feminino','91984711434','jessicakaren2005@gmail.com','Jessica Karen','Cardoso','789.123.254-00',1,5),(131,'pbkdf2_sha256$1000000$mi9EGh1tXYlo7AeTg1VD70$2YTJFLYwOp65wiIO5ibg1MuO2LGNlBjBGQso19JetRk=','Masculino','91991955538','leonelcollyer56@gmail.com','leonel ','collyer','133.264.152-54',1,2),(132,'pbkdf2_sha256$1000000$sMF6k5dlk9P1kSMt2aqoFM$EaWcLXkA/fUSfbw+wHiwXtozjMh8WiF7tS2LiKjmHwI=','Masculino','00000000000','senac@gmail.com','senac','papaleo','444.444.444-44',1,3),(133,'pbkdf2_sha256$1000000$aaYAmolAoDWw5QdwFoAnkt$UqTgLeQ7cmvjZFsfjNgxe75BgjLzJqq4mMYSDyqqeVo=','Masculino','97845-1236','teste@gmail.com','teste','testando','154.987.596-89',1,5),(134,'pbkdf2_sha256$1000000$eqMuC63ugmxeRCbh0lnfVn$xn/noNAvdQ56t3qJwwucBdqZWreziU4zajPZqU2acbE=','Masculino','91955555555','felipefreitas@gmail.com','Felipe','Freitas','157.953.456-28',1,5),(135,'pbkdf2_sha256$1000000$0AwrvTzwFgiMuASavzBCro$AXQcWa7eGhF9VOZfKU7RI85UoNMINNsl1oRhrvyEz8M=','Feminino','91984711434','nayane@gmail.com','Nayane','Cruz','123.123.456-87',1,5),(136,'pbkdf2_sha256$1000000$ifUVt3FvmzGXKWwit2tBCT$/XxqLGZAQk0e+/vf7c1/KRBZB2A6UR+exQ4xTOhCZLI=','Masculino','91982979833','chintalha131213@gmail.com','pedro','daniel','13131313131313',1,5),(137,'pbkdf2_sha256$1000000$9EK2gpGO9d90IMh1JeJ7qh$gbLLLLEg8jv+TxhgETuU/Au6f6E7HSjVI7fJ90MYz6s=','Masculino','91982979833','chadad@gmail.com','jyjgfjgjg','pedro','13123131313313',1,5),(138,'pbkdf2_sha256$1000000$1kkLiZ4bhX457UgLfvBA3z$c2+Fca78Fhhjk/e+whfTWutDRGjS8/BmVFkkV+OEMeY=','Masculino','91982979831','adawdawd@gmail.com','maria','elu','23444242424242',1,5),(139,'pbkdf2_sha256$1000000$ZgE0Q3WqN8CpexVsZcWIbK$JVnOVpUN9AOllDYy1tvOuCE2N6TGyAlC/RGj6polN1g=','Feminino','91982979833','l9ivi@gmail.com','livia','nay','98139149947982',1,5),(140,'pbkdf2_sha256$1000000$bnvAR1u210NOnhtPqxmjgT$QsqZi2APaIBKNdkBKtMIEYbdVnJXubDdSn7dlBPnlD4=','Feminino','91982979834','dhadhaj@gmail.com','may','lucia','16371263761736',1,5),(141,'pbkdf2_sha256$1000000$fOmD9wC0YsHERoFD9S7Tb1$cvXMXrOPshvccMQtHtQT+029c0Jls6opSOVaYi1FQ+o=','Masculino','9198297983377','ddwdaw@gmail.com','heyu','adawd','23122152343555',1,5),(142,'pbkdf2_sha256$1000000$1yCH6XvAZEIqSg93GlVegU$6cdtNFhSX8fr0qJmX9+4KHyX3VM1Zsi6ZwJLM60lP+k=','Masculino','','calebe@gmail.com','calebe','asafe','44533463453452',1,2),(143,'pbkdf2_sha256$1000000$rhVclJyI4LGMVkoffDqL79$TG4zzUfcPZJ0ZZtgQSplwL9yV4eTyS/o2jtJwjCpIiw=','Masculino','(31) 31231-2313','daniel@gmail.com','pedro','pedro','054.388.282-96',1,5),(144,'pbkdf2_sha256$1000000$VYHIbtbg2Dhl3jh2ePBMfd$6oSmIjP2GE+yUm3WonWpPtHLOutSZCn9NHulflQWCGw=','Masculino','(31) 31231-2398','dadawd@gmail.com','dadwadawd','pedro','054.388.282-94',1,5),(145,'pbkdf2_sha256$1000000$1KgxdW74rlArVhardZKUHm$iHUNcTeO+l3p8A13g+WD2SbTpqzfiP0JEw2yW/BZgxw=','Feminino','(13) 12313-1313','luisa@gmail.com','ana','luisa','183.918.391-83',1,5),(146,'pbkdf2_sha256$1000000$ZGe9tbBNNyw2573H6zPtGc$kMuD1Jv2bM7O8Q+IwN1XKLr8AQASwpiGJ20MNhe2I4o=','Masculino','(00) 00000-0000','lucas12@gmail.com','lucas','pereira','01006480295',1,5),(147,'pbkdf2_sha256$1000000$MdqckmeAhoR2JPmiErUleb$wELUCUqAiTt/27Vhb8NAt1o1FmMh53m+fTxss7vbS+0=','Masculino','(32) 42423-4242','chintalha1399@gmail.com','pedro','daniel','91390810938',1,3),(148,'pbkdf2_sha256$1000000$wEePrAGaj3OItFJ85Ag5bS$d0bnK5tKzq8ybeKM/TTjLEb79WVgpCz8r5glNhylEkA=','Masculino','(91) 98297-9833','chintalha1398@gmail.com','pedro','daniel','03509128230',1,5),(149,'pbkdf2_sha256$1000000$yeKnzhSXLJW5oiWZVJfBFB$Hq7xguvxiIJrFxaEVUow0OAQ+NrHYOgYGRvoe4JyYlE=','Masculino','(91) 98297-9833','chintalha1942@gmail.com','daniel','danicreu','34442342424',1,5),(150,'pbkdf2_sha256$1000000$6jE84gATjduoc3Jhrj5IPQ$M38KTfe60j1hAilNP4tva8dZC1XQkItyVZ3ThnB1M58=','Masculino','(32) 32434-2423','chintalha1939@gmail.com','pedro','danicreu','92394234242',1,5);
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
INSERT INTO `django_admin_log` VALUES (188,'2026-01-15 21:58:42.007721','5',' 15/01/2026 - Camisa Milan Home Listrada - Fernando',2,'[]',10,1),(189,'2026-03-11 20:49:37.163299','56','cahechol',1,'[{\"added\": {}}]',15,1),(190,'2026-03-11 20:51:10.399210','45','cachecol',2,'[{\"changed\": {\"fields\": [\"Nome produtos\", \"Imagem produtos\"]}}]',15,1),(191,'2026-03-11 20:53:57.935170','56','cahechol',3,'',15,1),(192,'2026-05-12 20:18:23.195162','40','Peido_Camelo',3,'',24,2),(193,'2026-05-12 20:18:36.288580','40','Peido_Camelo',3,'',24,2),(194,'2026-05-12 20:19:52.850275','14','Felipe Freitas',2,'[{\"changed\": {\"fields\": [\"Tempo\", \"Pontuacao\", \"Senha\"]}}]',24,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (17,'accounts','perfil'),(1,'admin','logentry'),(7,'app_futebol','categoriacliente'),(8,'app_futebol','categoriaprodutos'),(9,'app_futebol','clientes'),(10,'app_futebol','compra'),(11,'app_futebol','enderecocliente'),(12,'app_futebol','enderecofuncionarios'),(13,'app_futebol','funcionarios'),(19,'app_futebol','imagemproduto'),(21,'app_futebol','participantes'),(14,'app_futebol','pedido'),(15,'app_futebol','produtos'),(20,'app_futebol','questoes'),(18,'app_futebol','recuperacaosenha'),(16,'app_futebol','setorfuncionarios'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(23,'minigame','alternativas'),(25,'minigame','historicotitulos'),(24,'minigame','participantes'),(22,'minigame','questoes'),(6,'sessions','session');
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (25,'minigame','0001_initial','2026-05-05 20:30:28.670821');
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
INSERT INTO `django_session` VALUES ('0qp6fuwydqsgv0qt6s4qs1c2gvu3126c','.eJxVj8FygzAMRH-F8bnx2GAM5tTpobcc2h_ICFsUGrAZA6dM_r0yk7bkKL3d1erG7DigX_EyONbIvHr5W_gwIWvYO0YP3gX2T5bQRvzFEYcVlgPFCYaRSPcwSlEpJY1-RbfxGfiCHixv48Gy4ohd8CnPSFOrSkpVqIPAzh0xUVa8LmuudH4ShvA8gg9Uxw5h7188rx4V9yFzEa5hyU5Z2OLxGfQOI9rAmhvbMxQxnMmntZRCCkHiuAEtPjfIdLLCksYilzS0MEQKbNgZIljwXzD2kERhmkec6EaCHxtQgUwqdk_-GAffp5M0XWBb-8u2YNx_YCn0sGvBXqkjAfdN6YHb4Nc4tDxJ-IMu_Bwcjm8P7VNAD0tP7qquW9EJpSpwCDk4URhd1k6DsUWrEY3UpSmdMMZa7DqnoKsKaXIgk8SK3X8A9-6zWQ:1w0QS0:rcwv2EVeOrYjtWDgPTsaL6wsDxqUWYsbbM2jqbpiuu4','2026-03-25 20:46:40.328094'),('5fqc915vmyezcvr87gvxsuh0zws4ihos','.eJxVj9EKgzAMRX-l9GmDOdQKsz75J6Nr4yyLiVR9Ev99VWTTl8A9J4SbWVr0QCM8vZNVVjxuP0DcgaxkDy6w_OOBXwF25wx5wIOEzniMwraeRoOtyZTW9Xuld8vdYXMEhIZpvXJR-VUUeZGrZJ2HJds30et4JC2zVKsyuh4NcWxhPW-d1RntzbYgXDAfHkQieDr9AOQggGVZ0YQYuQnBUxvzvCxfaJJb_g:1w02Fm:UjeA2e4QB5xQ8O7v4-BKwEzp2eCCnDEPLv0hoQv0JB8','2026-03-24 18:56:26.759664'),('6lzijwlbo0yngdixdamkhd0gzapxptuq','.eJxVUTuP3CAQ_isWbXYtBvCzilKkuyJR-tUYxmdyXnCw3eS0_z2Dtaf4KsT3mg_mXdxw36bbvlK6eSd6AeJyxga0bxQy4X5jeI2ljWFLfiizpHyya_kSHc3fntpPAROuE7vH0VUtaqDWdhK0cc7K2joNozLgRi2lIm2srcfWjqCtqZhRAAobTY0eOdTOnsJGR01QzX8gxDvxiO-UAgYXT9I1Dok-6ER-w_XE0h39nLs9jSAbY6Crv5LbywXLlQLackgny0YzjTHkvA661jQARpuTwC4jc7JqyrZqS1Orq-yYXmYMketYH4_--jP0rHhcCpfwLa7FtYh7Oj-Gv5YS2Sj6d3FkGOZoYV9dA0iQksVpRwZ-7ljU2YprvmqVtzqgTxzYixdMaHmZOE-YRfG-zHTnGZn8sSMXKMCIB3fEtHnrF_z4d9VdxJ_d_735wHjWK6nqq6yuoH9B26u6r0wJyvDrv0jZH50spuTDdBSvDS_vIkx3HJXi4_H4B1ozyfE:1wNF1R:yyXUitEQllZxrHctoO9PxLf9UrW_PxTKMRgxw5Bb3V0','2026-05-27 19:13:33.641400'),('budtmiimdylbfjmzuk4msung747vgio7','.eJxVjLtywjAQRf9FLaBZrdi1pDI9Hb1HslZYCSMTP5pk-PdAhob2nHPvr7rFea1DvcW2Sl-zCpb36nurP31tDz6poBCQD0AHg2eEgC4gaeOIjNkBBAC1V33c1rHfFpn_PxS-sxSHL2lPkT9ju0x6mNo616SfiX7ZRZ-mLNePV_t2MMZlfKxN7OgIBdi5ZJmBC3onknxX2JbshS0Vz7FLA3K0uVhHnok6sVnIo7r_Ac4xSrk:1wMtiL:_o3P86QAsE4Iq8hZokO6JvjdvOvOUNNYF_AeqYT7SR8','2026-05-26 20:28:25.186181'),('mgj91rkhqd4mdtwexogf6oxtel6iodgh','eyJwYXJ0aWNpcGFudGVfaWQiOjM2fQ:1wMrb1:jXAer3_4vfN_8T9-mKdEnzyyUx17OcPcI2M_Q619zfY','2026-05-26 18:12:43.130457'),('u812j90xsp5frng23dq4matc6l094abb','.eJztVE2PmzAQ_SvIp1ZNiE2AAKeqlaoeuoeucmsrNMGGWAWbGrM9RPnvHVPI1ybdHCu1B4Rm5s3w5vnhHSlqKZQVueQkY8Fqdkgo3QiSkQ_CKFBck2Ol0xsjprIR0kJ3UhUNyBor5djI6CoMWRq_Fbz3W_A7oaDwN-akxYpalFq5eSlLk3DFWLgMTwBFW2KNRis_iRI_jIM5TbHc1qA00imkHvgvz1MjxSHwuIHvuvPmnu7N6TJCcWFEoUm2I8OMEGuixb44ZowyShFsesDEYw9e7Fqhc-EyYBhsQBocmJEHMFCAqqDeggPppq1Fg99wxc89IAGPhWQ_I1vZWW1koXMHMqhe9mVHWsElH2nkU4AbcbBwiAmLFpQtAhrEHkuzYEXOALnsHMiV55TNWbQeQFkQvKE0G1bpLNgev0iQmRFVLxwjaYUaWRjNe3tUI54RJ2M-5l3je2hkB947A6oA71FY87WntHTnJRuoRHMKlk21mMJFMXRO73wzTMgNTtDnuVfstf9TbFrH7UcPykoOHM-SzcgT1NrkvULXGYk8g4j6FNfqN1ZbqMfEfvZ8leTmKg8SXeN9xKL3Cc_GAIeby4w8t25SKasG_FZVd_Bc0gueQ-Iaz_QFnuutNNyDBoyob_PEB3-Ap4Pa2GAAG7xmGFIa5_67RU4uRXaJ_bcJOWaT5bTSNS8Hz7wcHr2cZFH6Zy-H6wGUReG_5uVLmY8OvyYze0Fmdo_MLKP_r4y_9Mq4tEP02yT7X1fIk5I:1vj1l6:pik0EEQTUcbVZ2sHb6nA75bzp-PdpLjUbUgkNOYMS8w','2026-02-05 20:58:28.214669'),('uftc82cil6h45ego1mw6nncci0ng3uug','.eJxVjDsOwjAQBe_iGll24t9S0ucM1tq7JgFkS_lUiLuTSCmgfTPz3iLito5xW3iOE4mr0OLyuyXMT64HoAfWe5O51XWekjwUedJFDo34dTvdv4MRl3GvfQhJFWWMR2LskFQPzgZyCLlPjhm0s2BJAeTMpZDB4nsNHe6RZi8-X-yGOEU:1vtX48:YnVzQDJt_DNITiG0tJM2IuyTlEm6ny3KNFk_yGxPxOg','2026-03-06 20:25:32.953592'),('vyugmom3xxp82gtiuxnpc5ow6v2bi5pc','eyJwYXJ0aWNpcGFudGVfaWQiOjMxLCJxdWl6X2luaWNpbyI6IjIwMjYtMDUtMTNUMTk6MTM6NTUuMzY2ODYwKzAwOjAwIn0:1wNF1n:-2zP_AtlyHWc4iRPbut1w03GK7GjY2EmFCwRWCtlNvE','2026-05-27 19:13:55.367309'),('vz79jjymmanydv2t8h1nc7b5yb8uolw5','.eJxVkL1uxCAQhF_For4gsMF_VZQiXYqkjaLTgpeYnA8ssKvTvXvWp0vilLvfzDDLhdnJY1jw6AfWy7I5_C5CPCPr2TOmAGGI7I_kaBL-4IR-gbyjeAY_EXF3oxSNUrKrH3FY-Qw8YwDLTdpZFpzQxbDldbJrVSOlqtROYGdHTOiGt7rlqi4fREd4niBEqmN9vPWv_q_uFW9DMSQ4xVw8FHFN-2MwDJjQRtZf2C1DEcOZfHUtpZBCkDitQIu3FYp6s0LexqqUNBjwiQJ79gIJLIRPmEbYRPE8T3imNzb4ugIVKKRi1wMbfV5i8jYeN1Gi3-vfPw7sCOsyHteM6XYM29J3OwP2RGUJDF_0TOQ2hiV5wzcJv9PMX-KA09Nd-y9ghDySG-gLhRUaNXYNWF1WUllnVaf1YNCpEqTrhJNCm9ZVZdlKsKbTpa2lcI017PoNvgu2nA:1vgVGM:f7iELq3_66NBzpDsdfssvdm_6e76Xye0GW-wiB5OsyE','2026-01-29 21:52:18.956546'),('xinkxpupnj1agqk16yc914ik0vtj5adp','.eJxVj0EKgzAQRa8iWbVQiyYpNVn1JiVNxhoaZyTqSrx7o0irm4H_3jD8mZgNHnCAp3dMl_J--QGkFphmHbhI7I97ekXYnDPoIewktMaHJGzjcTChMaVQ6vFe6NVSu9scIEBNuFw5CX7OJJdc5MvcLdmuTl6lI0VVFkpUyXXBIKUW1tPaWRzR1mwNmYvmQ32WZzQefgB0EMES0ziGkLiJ0WOT8sTkjWk-z1-Qql0X:1vyaS4:4974zmYmuALmJJ0tfPrjMj_tV5UhIWuPQUajc5BjBW8','2026-03-20 19:03:08.012461');
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
  `cep_ENDERECO_CLIENTE` varchar(8) NOT NULL,
  `complemento_ENDERECO_CLIENTE` varchar(45) NOT NULL,
  `bairro_ENDERECO_CLIENTE` varchar(45) NOT NULL,
  `casa_ENDERECO_CLIENTE` varchar(45) NOT NULL,
  `rua_ENDERECO_CLIENTE` varchar(45) NOT NULL,
  `cliente_id_cliente` int NOT NULL,
  PRIMARY KEY (`id_ENDERECO_CLIENTE`),
  UNIQUE KEY `cliente_id_cliente` (`cliente_id_cliente`),
  CONSTRAINT `fk_cliente_endereco` FOREIGN KEY (`cliente_id_cliente`) REFERENCES `clientes` (`id_CLIENTES`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco_cliente`
--

LOCK TABLES `endereco_cliente` WRITE;
/*!40000 ALTER TABLE `endereco_cliente` DISABLE KEYS */;
INSERT INTO `endereco_cliente` VALUES (5,'78945612','Em frente ao campo de futebol','Telegrafo sem fio','casa azul de dois andar','Passagem Guajará',52),(6,'32165498','Ao lado da empresa Amasa','Pratinha','Casa laranja com portão preto','Rua nossa senhora das graças',53),(34,'66110100','Quadra 14','Maracangalha','321','Rua 6',127),(37,'66650484','mercainho','sideral','24','siral',136),(38,'66650484','mercainho','sideral','24','siral',137),(39,'66650489','mercainho','sideral','24','siral',138),(40,'66650484','mercainho','sideral','24','siral',139),(41,'66650484','mercainho','sideral','24','siral',140),(42,'66650481','mercainho','sideral','24','siral',141),(43,'66650484','mercainho','sideral','24','siral',142),(44,'66650485','mercainho','sideral','24','siral',145),(45,'57475475','rua do assalto','sideral','72','merda',146);
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionarios`
--

LOCK TABLES `funcionarios` WRITE;
/*!40000 ALTER TABLE `funcionarios` DISABLE KEYS */;
INSERT INTO `funcionarios` VALUES (1,'novaSenha456','novo_login','91 88888-8888','novo@email.com','Feminino','Nayane Atualizada',3),(2,'12345678','Emanuel Silva','91 98507-4239','emanuel@gmail.com','masculino','Emanuel',4),(3,'123456','fernando','91 91597-6587','fernando@gmail.com','masculino','Fernando Freitas',2),(4,'123456','teste','99 99999-9999','teste@outlook.com','masculino','Teste Teste',2);
/*!40000 ALTER TABLE `funcionarios` ENABLE KEYS */;
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
INSERT INTO `jogos` VALUES (1,'2026-02-15','16:00:00','Estádio Drakos Arena','casa',1),(2,'2026-02-22','18:30:00','Maracanã','fora',2),(3,'2026-03-01','20:00:00','Estádio Drakos Arena','casa',3),(4,'2026-03-08','16:00:00','Morumbi','fora',4),(5,'2026-03-15','19:00:00','Estádio Drakos Arena','casa',5),(6,'2026-03-22','17:30:00','Arena do Grêmio','fora',6);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recuperacao_senha`
--

LOCK TABLES `recuperacao_senha` WRITE;
/*!40000 ALTER TABLE `recuperacao_senha` DISABLE KEYS */;
INSERT INTO `recuperacao_senha` VALUES (1,'191545','2025-12-01 19:51:37.369413',127),(38,'522540','2026-02-20 18:56:11.091699',127),(39,'193758','2026-02-20 18:57:08.864415',127),(40,'226470','2026-02-20 18:57:08.948611',127),(41,'196278','2026-02-20 18:57:47.108899',127),(42,'797133','2026-02-26 19:53:42.224485',142),(43,'452592','2026-03-04 17:57:54.597400',127),(44,'362018','2026-03-05 17:13:18.715029',143),(45,'991571','2026-05-04 18:49:11.946384',127),(46,'529817','2026-05-04 18:49:53.425448',127),(47,'664287','2026-05-04 18:53:59.354418',127),(48,'978124','2026-05-04 18:54:15.306445',127),(49,'403386','2026-05-04 18:55:11.876873',127),(50,'620568','2026-05-06 19:54:41.436137',53),(51,'341361','2026-05-06 19:54:50.140135',53),(52,'115344','2026-05-06 19:54:57.103605',53),(53,'675447','2026-05-06 19:54:58.778342',53),(54,'419494','2026-05-11 17:32:49.923645',53),(55,'710546','2026-05-11 17:32:50.729408',53),(56,'409488','2026-05-11 17:32:51.878745',53),(57,'802372','2026-05-11 17:32:52.049169',53),(58,'671007','2026-05-11 17:32:52.208524',53),(59,'864545','2026-05-11 17:32:52.353927',53),(60,'164581','2026-05-11 17:32:52.527600',53),(61,'273561','2026-05-11 17:32:52.683679',53),(62,'633996','2026-05-11 17:32:52.862331',53);
/*!40000 ALTER TABLE `recuperacao_senha` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-13 16:16:02
