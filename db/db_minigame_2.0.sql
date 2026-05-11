-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema db_minigame
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema db_minigame
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_minigame` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `db_minigame` ;

-- -----------------------------------------------------
-- Table `db_minigame`.`questoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_minigame`.`questoes` (
  `id_questao` INT NOT NULL AUTO_INCREMENT,
  `pergunta` TEXT NOT NULL,
  PRIMARY KEY (`id_questao`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_minigame`.`alternativas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_minigame`.`alternativas` (
  `id_alternativa` INT NOT NULL AUTO_INCREMENT,
  `opcao_resposta` VARCHAR(500) NOT NULL,
  `resposta_correta` TINYINT NOT NULL,
  `ponto` INT NOT NULL,
  `questao_id` INT NOT NULL,
  PRIMARY KEY (`id_alternativa`),
  INDEX `fk_alternativas_questoes_idx` (`questao_id` ASC) VISIBLE,
  CONSTRAINT `fk_alternativas_questoes`
    FOREIGN KEY (`questao_id`)
    REFERENCES `db_minigame`.`questoes` (`id_questao`))
ENGINE = InnoDB
AUTO_INCREMENT = 41
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_minigame`.`participantes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_minigame`.`participantes` (
  `id_participante` INT NOT NULL AUTO_INCREMENT,
  `nome_participante` VARCHAR(45) NOT NULL,
  `tempo` TIME NULL DEFAULT NULL,
  `pontuacao` INT NULL DEFAULT NULL,
  `senha` VARCHAR(255) NOT NULL,
  `ultimo_login_em` DATE NOT NULL,
  `hora_ultimo_login_em` TIME NOT NULL,
  PRIMARY KEY (`id_participante`))
ENGINE = InnoDB
AUTO_INCREMENT = 32
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_minigame`.`respostas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_minigame`.`respostas` (
  `participante_id` INT NOT NULL,
  `questao_id` INT NOT NULL,
  `alternativa_id` INT NOT NULL,
  PRIMARY KEY (`participante_id`, `questao_id`),
  INDEX `fk_participantes_has_questoes_questoes1_idx` (`questao_id` ASC) VISIBLE,
  INDEX `fk_participantes_has_questoes_participantes1_idx` (`participante_id` ASC) VISIBLE,
  INDEX `fk_participantes_questoes_alternativas1_idx` (`alternativa_id` ASC) VISIBLE,
  CONSTRAINT `fk_participantes_has_questoes_participantes1`
    FOREIGN KEY (`participante_id`)
    REFERENCES `db_minigame`.`participantes` (`id_participante`),
  CONSTRAINT `fk_participantes_has_questoes_questoes1`
    FOREIGN KEY (`questao_id`)
    REFERENCES `db_minigame`.`questoes` (`id_questao`),
  CONSTRAINT `fk_participantes_questoes_alternativas1`
    FOREIGN KEY (`alternativa_id`)
    REFERENCES `db_minigame`.`alternativas` (`id_alternativa`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `db_minigame`.`titulos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_minigame`.`titulos` (
  `id_titulo` INT NOT NULL AUTO_INCREMENT,
  `nome_titulo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_titulo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_minigame`.`historico_titulos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_minigame`.`historico_titulos` (
  `id_historico` INT NOT NULL AUTO_INCREMENT,
  `titulo_id` INT NOT NULL,
  `participante_id` INT NOT NULL,
  `ativo` TINYINT NULL,
  PRIMARY KEY (`id_historico`),
  INDEX `fk_historico_titulos_titulos1_idx` (`titulo_id` ASC) VISIBLE,
  INDEX `fk_historico_titulos_participantes1_idx` (`participante_id` ASC) VISIBLE,
  CONSTRAINT `fk_historico_titulos_titulos1`
    FOREIGN KEY (`titulo_id`)
    REFERENCES `db_minigame`.`titulos` (`id_titulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historico_titulos_participantes1`
    FOREIGN KEY (`participante_id`)
    REFERENCES `db_minigame`.`participantes` (`id_participante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `db_minigame` ;

-- -----------------------------------------------------
-- procedure ranking_participantes
-- -----------------------------------------------------

DELIMITER $$
USE `db_minigame`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ranking_participantes`()
BEGIN
    SELECT 
        p.nome_participante, 
        p.tempo, 
        SUM(a.resposta_correta) AS acertos, 
        SUM(q.ponto) AS total 
    FROM participantes p
    INNER JOIN respostas r ON p.id_participante = r.participante_id
    INNER JOIN alternativas a ON r.alternativa_id = a.id_alternativa
    INNER JOIN questoes q ON r.questao_id = q.id_questao
    GROUP BY p.nome_participante, p.tempo
    ORDER BY acertos DESC;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
