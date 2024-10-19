-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema comercio
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema comercio
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `comercio` DEFAULT CHARACTER SET utf8mb3 ;
USE `comercio` ;

-- -----------------------------------------------------
-- Table `comercio`.`lojas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `comercio`.`lojas` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Estoque` INT NOT NULL,
  `Funcionarios` INT NOT NULL,
  `Gastos` INT NOT NULL,
  `lucro` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `Nome_UNIQUE` (`Nome` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `comercio`.`funcionarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `comercio`.`funcionarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `cpf` VARCHAR(50) NOT NULL,
  `nascimento` DATE NOT NULL,
  `cargo` VARCHAR(45) NOT NULL,
  `salario` FLOAT NOT NULL,
  `data_contratacao` DATE NOT NULL,
  `loja_trabalho` VARCHAR(45) NOT NULL,
  `loja_trabalho_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `loja_nome_idx` (`loja_trabalho` ASC) VISIBLE,
  INDEX `loja_id_idx` (`loja_trabalho_id` ASC) VISIBLE,
  CONSTRAINT `loja_id`
    FOREIGN KEY (`loja_trabalho_id`)
    REFERENCES `comercio`.`lojas` (`ID`),
  CONSTRAINT `loja_nome`
    FOREIGN KEY (`loja_trabalho`)
    REFERENCES `comercio`.`lojas` (`Nome`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `comercio`.`produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `comercio`.`produtos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `loja` VARCHAR(45) NOT NULL,
  `categoria` VARCHAR(45) NOT NULL,
  `preco` FLOAT NOT NULL,
  `estoque` INT NOT NULL,
  `Produtos_custo` FLOAT NOT NULL,
  `loja_id` INT NOT NULL,
  `vendas` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `loja_idx` (`loja` ASC) VISIBLE,
  INDEX `id_loja_idx` (`loja_id` ASC) VISIBLE,
  CONSTRAINT `id_loja`
    FOREIGN KEY (`loja_id`)
    REFERENCES `comercio`.`lojas` (`ID`),
  CONSTRAINT `loja`
    FOREIGN KEY (`loja`)
    REFERENCES `comercio`.`lojas` (`Nome`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;

USE `comercio`;

DELIMITER $$
USE `comercio`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `comercio`.`after_insert_funcionarios`
AFTER INSERT ON `comercio`.`funcionarios`
FOR EACH ROW
BEGIN
    UPDATE lojas
    SET funcionarios = funcionarios + 1
    WHERE id = NEW.loja_trabalho_id;
END$$

USE `comercio`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `comercio`.`after_insert_produtos`
AFTER INSERT ON `comercio`.`produtos`
FOR EACH ROW
BEGIN
    UPDATE lojas
    SET estoque = estoque + NEW.estoque
    WHERE id = NEW.loja_id;
END$$

USE `comercio`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `comercio`.`after_insert_produtos_gastos`
AFTER INSERT ON `comercio`.`produtos`
FOR EACH ROW
BEGIN
    UPDATE lojas
    SET gastos = gastos + (NEW.produtos_custo * NEW.estoque)
    WHERE id = NEW.loja_id;
END$$

USE `comercio`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `comercio`.`after_insert_produtos_lucro`
AFTER INSERT ON `comercio`.`produtos`
FOR EACH ROW
BEGIN
    UPDATE lojas
    SET lucro = lucro + (NEW.preco * NEW.vendas)
    WHERE id = NEW.loja_id;
END$$

USE `comercio`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `comercio`.`after_update_produtos_lucro`
AFTER UPDATE ON `comercio`.`produtos`
FOR EACH ROW
BEGIN
    UPDATE lojas
    SET lucro = lucro - (OLD.preco * OLD.vendas)
    WHERE id = OLD.loja_id;

    
    UPDATE lojas
    SET lucro = lucro + (NEW.preco * NEW.vendas)
    WHERE id = NEW.loja_id;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
