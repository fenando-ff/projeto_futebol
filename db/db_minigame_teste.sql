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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
-- Table structure for table `participantes`
--

DROP TABLE IF EXISTS `participantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participantes` (
  `id_participante` int NOT NULL AUTO_INCREMENT,
  `nome_participante` varchar(45) NOT NULL,
  `tempo` time DEFAULT NULL,
  PRIMARY KEY (`id_participante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participantes`
--

LOCK TABLES `participantes` WRITE;
/*!40000 ALTER TABLE `participantes` DISABLE KEYS */;
INSERT INTO `participantes` VALUES (1,'João Silva',NULL),(2,'Maria Santos',NULL),(3,'Pedro Oliveira',NULL),(4,'Ana Costa',NULL),(5,'Carlos Souza',NULL),(6,'Lucia Fernandez',NULL),(7,'Marcos Pereira',NULL),(8,'Julia Lima',NULL),(9,'Rafael Almeida',NULL),(10,'Fernanda Carvalho',NULL);
/*!40000 ALTER TABLE `participantes` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
INSERT INTO `respostas` VALUES (9,1,1),(1,1,2),(2,1,2),(3,1,2),(4,1,2),(5,1,2),(6,1,2),(7,1,2),(8,1,2),(10,1,2),(10,2,5),(8,2,6),(9,2,6),(1,2,7),(2,2,7),(3,2,7),(4,2,7),(5,2,7),(6,2,7),(7,2,7),(8,3,9),(9,3,9),(10,3,9),(1,3,10),(2,3,10),(3,3,10),(4,3,10),(5,3,10),(6,3,10),(7,3,10),(1,4,13),(2,4,13),(3,4,13),(4,4,13),(5,4,13),(6,4,13),(7,4,13),(8,4,14),(9,4,15),(10,4,16),(9,5,17),(8,5,18),(10,5,18),(1,5,19),(2,5,19),(3,5,19),(4,5,19),(5,5,19),(6,5,19),(7,5,20),(8,6,21),(10,6,21),(1,6,22),(2,6,22),(3,6,22),(4,6,22),(5,6,22),(6,6,23),(7,6,23),(9,6,24),(1,7,25),(2,7,25),(3,7,25),(4,7,25),(5,7,26),(6,7,26),(7,7,26),(8,7,27),(10,7,27),(9,7,28),(8,8,29),(9,8,30),(10,8,30),(1,8,31),(2,8,31),(3,8,31),(4,8,32),(5,8,32),(6,8,32),(7,8,32),(8,9,33),(1,9,34),(2,9,34),(3,9,35),(4,9,35),(5,9,35),(6,9,35),(7,9,35),(9,9,36),(10,9,36),(1,10,37),(2,10,38),(3,10,38),(4,10,38),(5,10,38),(6,10,38),(7,10,38),(8,10,39),(9,10,40),(10,10,40);
/*!40000 ALTER TABLE `respostas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-29 16:57:25
