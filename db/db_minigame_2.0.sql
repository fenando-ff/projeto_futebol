CREATE DATABASE  IF NOT EXISTS `db_minigame` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_minigame`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: db_minigame
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
-- Table structure for table `historico_titulos`
--

DROP TABLE IF EXISTS `historico_titulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_titulos` (
  `id_historico` int NOT NULL AUTO_INCREMENT,
  `titulo_id` int NOT NULL,
  `participante_id` int NOT NULL,
  `ativo` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_historico`),
  KEY `fk_historico_titulos_titulos1_idx` (`titulo_id`),
  KEY `fk_historico_titulos_participantes1_idx` (`participante_id`),
  CONSTRAINT `fk_historico_titulos_participantes1` FOREIGN KEY (`participante_id`) REFERENCES `participantes` (`id_participante`),
  CONSTRAINT `fk_historico_titulos_titulos1` FOREIGN KEY (`titulo_id`) REFERENCES `titulos` (`id_titulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historico_titulos`
--

LOCK TABLES `historico_titulos` WRITE;
/*!40000 ALTER TABLE `historico_titulos` DISABLE KEYS */;
/*!40000 ALTER TABLE `historico_titulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participantes`
--

DROP TABLE IF EXISTS `participantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participantes` (
  `id_participante` int NOT NULL AUTO_INCREMENT,
  `nome_participante` varchar(45) NOT NULL,
  `tempo` time DEFAULT NULL,
  `pontuacao` int DEFAULT NULL,
  `senha` varchar(255) NOT NULL,
  PRIMARY KEY (`id_participante`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participantes`
--

LOCK TABLES `participantes` WRITE;
/*!40000 ALTER TABLE `participantes` DISABLE KEYS */;
INSERT INTO `participantes` VALUES (1,'João Silva','00:00:14',NULL,''),(2,'Maria Santos','00:00:23',NULL,''),(3,'Pedro Oliveira','00:00:45',NULL,''),(4,'Ana Costa','00:00:15',NULL,''),(5,'Carlos Souza',NULL,NULL,''),(6,'Lucia Fernandez',NULL,NULL,''),(7,'Marcos Pereira',NULL,NULL,''),(8,'Julia Lima',NULL,NULL,''),(9,'Rafael Almeida',NULL,NULL,''),(10,'Fernanda Carvalho',NULL,NULL,''),(14,'Felipe Freitas',NULL,90,''),(15,'pedro','00:00:03',0,''),(16,'daniel','00:00:03',0,''),(17,'danicreu',NULL,40,''),(25,'Pedro_raposa',NULL,0,''),(26,'Pedro_Fenix',NULL,0,''),(27,'Daniel_canguru',NULL,0,''),(28,'Carol_jacare',NULL,0,'pbkdf2_sha256$1000000$A7RAvZFIzHdzwDwlwH47CR$VSAN3dkczJl2gpjtARogRf1YkxPWrWg8QDLWLD0J9Y4='),(29,'Fernando_Corvo','00:00:51',70,'pbkdf2_sha256$1000000$HOwyn0t5tIqgD7v1l6D9R5$ppMeUWB0+OWQpv46rWFk+NSZXswaoAmZOR8GyC8SYcs='),(30,'Daniel242_Capivara','00:00:18',70,'pbkdf2_sha256$1000000$WGPRYampMravKIjbU6Pjhz$oVuuasMRvBJzBirf/u0ILYTRV1QFUajNkhR2WYmigWE='),(31,'Nayane_Mocurento','00:00:36',50,'pbkdf2_sha256$1000000$stQGatBdTIx7m8OkGBxJ5o$XFDbMjqWn/uX1QmIE0oJcGQXFpJ7heaYEOjowBxqbbA='),(32,'Lucas_Mocurento','00:00:17',40,'pbkdf2_sha256$1000000$hzvez6KGrKMHAJU5VlT1vL$DF7AihVFJM85UUDGlkBucUwV8e9QFtgaHW/5VzfD5Vc='),(33,'Gabriel_Serpente','00:00:15',50,'pbkdf2_sha256$1000000$FCe7I1qJl06Wmy9IqUVzqN$kX/wJbajXjmYSiWI5fFWryrZmA41Q1DZR62GZNDI8WU=');
/*!40000 ALTER TABLE `participantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progresso_fases`
--

DROP TABLE IF EXISTS `progresso_fases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progresso_fases` (
  `participante_id` int NOT NULL,
  `fase2_liberada` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`participante_id`),
  CONSTRAINT `fk_progresso_fases_participantes` FOREIGN KEY (`participante_id`) REFERENCES `participantes` (`id_participante`) ON DELETE CASCADE
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
-- Table structure for table `respostas`
--

DROP TABLE IF EXISTS `respostas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respostas` (
  `participante_id` int NOT NULL,
  `questao_id` int NOT NULL,
  `alternativa_id` int NOT NULL,
  `combo_max` int NULL,
  PRIMARY KEY (`participante_id`,`questao_id`),
  KEY `fk_participantes_has_questoes_questoes1_idx` (`questao_id`),
  KEY `fk_participantes_has_questoes_participantes1_idx` (`participante_id`),
  KEY `fk_participantes_questoes_alternativas1_idx` (`alternativa_id`),
  CONSTRAINT `fk_participantes_has_questoes_participantes1` FOREIGN KEY (`participante_id`) REFERENCES `participantes` (`id_participante`),
  CONSTRAINT `fk_participantes_has_questoes_questoes1` FOREIGN KEY (`questao_id`) REFERENCES `questoes` (`id_questao`),
  CONSTRAINT `fk_participantes_questoes_alternativas1` FOREIGN KEY (`alternativa_id`) REFERENCES `alternativas` (`id_alternativa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respostas`
--

LOCK TABLES `respostas` WRITE;
/*!40000 ALTER TABLE `respostas` DISABLE KEYS */;
INSERT INTO `respostas` VALUES 
(9,1,1,NULL),(1,1,2,NULL),(2,1,2,NULL),(3,1,2,NULL),(4,1,2,NULL),(5,1,2,NULL),(6,1,2,NULL),(7,1,2,NULL),(8,1,2,NULL),(10,1,2,NULL),(14,1,2,NULL),(17,1,2,NULL),(30,1,2,NULL),(32,1,2,NULL),(33,1,2,NULL),(31,1,3,NULL),(29,1,4,NULL),
(10,2,5,NULL),(8,2,6,NULL),(9,2,6,NULL),(17,2,6,NULL),(32,2,6,NULL),(33,2,6,NULL),(1,2,7,NULL),(2,2,7,NULL),(3,2,7,NULL),(4,2,7,NULL),(5,2,7,NULL),(6,2,7,NULL),(7,2,7,NULL),(14,2,7,NULL),(29,2,7,NULL),(31,2,7,NULL),(30,2,8,NULL),
(8,3,9,NULL),(9,3,9,NULL),(10,3,9,NULL),(17,3,9,NULL),(31,3,9,NULL),(1,3,10,NULL),(2,3,10,NULL),(3,3,10,NULL),(4,3,10,NULL),(5,3,10,NULL),(6,3,10,NULL),(7,3,10,NULL),(14,3,10,NULL),(29,3,10,NULL),(30,3,10,NULL),(32,3,11,NULL),(33,3,11,NULL),
(1,4,13,NULL),(2,4,13,NULL),(3,4,13,NULL),(4,4,13,NULL),(5,4,13,NULL),(6,4,13,NULL),(7,4,13,NULL),(14,4,13,NULL),(17,4,13,NULL),(29,4,13,NULL),(30,4,13,NULL),(32,4,13,NULL),(33,4,13,NULL),(8,4,14,NULL),(9,4,15,NULL),(31,4,15,NULL),(10,4,16,NULL),
(9,5,17,NULL),(30,5,17,NULL),(32,5,17,NULL),(8,5,18,NULL),(10,5,18,NULL),(14,5,18,NULL),(29,5,18,NULL),(1,5,19,NULL),(2,5,19,NULL),(3,5,19,NULL),(4,5,19,NULL),(5,5,19,NULL),(6,5,19,NULL),(17,5,19,NULL),(31,5,19,NULL),(33,5,19,NULL),(7,5,20,NULL),
(8,6,21,NULL),(10,6,21,NULL),(17,6,21,NULL),(32,6,21,NULL),(1,6,22,NULL),(2,6,22,NULL),(3,6,22,NULL),(4,6,22,NULL),(5,6,22,NULL),(14,6,22,NULL),(29,6,22,NULL),(30,6,22,NULL),(33,6,22,NULL),(6,6,23,NULL),(7,6,23,NULL),(31,6,23,NULL),(9,6,24,NULL),
(1,7,25,NULL),(2,7,25,NULL),(3,7,25,NULL),(4,7,25,NULL),(14,7,25,NULL),(29,7,25,NULL),(30,7,25,NULL),(31,7,25,NULL),(5,7,26,NULL),(6,7,26,NULL),(7,7,26,NULL),(33,7,26,NULL),(8,7,27,NULL),(10,7,27,NULL),(17,7,27,NULL),(32,7,27,NULL),(9,7,28,NULL),
(8,8,29,NULL),(9,8,30,NULL),(10,8,30,NULL),(17,8,30,NULL),(29,8,30,NULL),(1,8,31,NULL),(2,8,31,NULL),(3,8,31,NULL),(14,8,31,NULL),(30,8,31,NULL),(31,8,31,NULL),(32,8,31,NULL),(33,8,31,NULL),(4,8,32,NULL),(5,8,32,NULL),(6,8,32,NULL),(7,8,32,NULL),
(8,9,33,NULL),(30,9,33,NULL),(33,9,33,NULL),(1,9,34,NULL),(2,9,34,NULL),(14,9,34,NULL),(29,9,34,NULL),(31,9,34,NULL),(32,9,34,NULL),(3,9,35,NULL),(4,9,35,NULL),(5,9,35,NULL),(6,9,35,NULL),(7,9,35,NULL),(9,9,36,NULL),(10,9,36,NULL),(17,9,36,NULL),
(1,10,37,NULL),(14,10,37,NULL),(17,10,37,NULL),(29,10,37,NULL),(30,10,37,NULL),(2,10,38,NULL),(3,10,38,NULL),(4,10,38,NULL),(5,10,38,NULL),(6,10,38,NULL),(7,10,38,NULL),(33,10,38,NULL),(8,10,39,NULL),(31,10,39,NULL),(32,10,39,NULL),(9,10,40,NULL),(10,10,40,NULL);
/*!40000 ALTER TABLE `respostas` ENABLE KEYS */;
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

-- Dump completed on 2026-05-11 17:37:06
