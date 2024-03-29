-- MySQL Script generated by MySQL Workbench
-- Mon Sep 23 22:16:44 2019
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`USER`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`USER` ;

CREATE TABLE IF NOT EXISTS `mydb`.`USER` (
  `USER_ID` INT NOT NULL COMMENT 'Primary key of user table',
  `FIRST_NAME` VARCHAR(50) NOT NULL COMMENT 'First name of user.',
  `LAST_NAME` VARCHAR(50) NOT NULL,
  `USER_NAME` VARCHAR(50) NOT NULL,
  `EMAIL` VARCHAR(50) NOT NULL,
  `PHONE` VARCHAR(20) NOT NULL,
  `PASSWORD` VARCHAR(50) NOT NULL,
  `SALT` VARCHAR(50) NOT NULL,
  `COUNTRY_CODE` VARCHAR(4) NOT NULL,
  `STATE` VARCHAR(50) NOT NULL,
  `CITY` VARCHAR(20) NOT NULL,
  `STREET_ADDRESS` VARCHAR(400) NULL,
  `CREATE_DATE` DATETIME NOT NULL,
  `LAST_MODIFIED_DATE` DATETIME NULL,
  `NOTIFICATION_ON` TINYINT NOT NULL COMMENT '0 - notification off, 1 - notification on',
  `STATUS` TINYINT NULL COMMENT '0 - suspended, 1 - normal',
  PRIMARY KEY (`USER_ID`))
ENGINE = InnoDB
COMMENT = 'Record user information.';

CREATE UNIQUE INDEX `USER_ID_UNIQUE` ON `mydb`.`USER` (`USER_ID` ASC);

CREATE UNIQUE INDEX `USER_NAME_UNIQUE` ON `mydb`.`USER` (`USER_NAME` ASC);

CREATE UNIQUE INDEX `EMAIL_UNIQUE` ON `mydb`.`USER` (`EMAIL` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`SUSPEND_HISTORY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`SUSPEND_HISTORY` ;

CREATE TABLE IF NOT EXISTS `mydb`.`SUSPEND_HISTORY` (
  `SUSPEND_ID` INT NOT NULL AUTO_INCREMENT,
  `USER_ID` INT NOT NULL,
  `SUSPEND_START_DATE` DATETIME NOT NULL,
  `SUSPEND_END_DATE` DATETIME NOT NULL,
  `SUSPEND_REASON` VARCHAR(200) NOT NULL,
  `REQUEST_DATE` DATETIME NOT NULL,
  PRIMARY KEY (`SUSPEND_ID`),
  CONSTRAINT `USER_ID`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Record user suspend history.';

CREATE INDEX `USER_ID_idx` ON `mydb`.`SUSPEND_HISTORY` (`USER_ID` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`SOCIAL_ACCOUNT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`SOCIAL_ACCOUNT` ;

CREATE TABLE IF NOT EXISTS `mydb`.`SOCIAL_ACCOUNT` (
  `USER_ID` INT NOT NULL,
  `SOCIAL_ACCOUNT_TYPE` INT NOT NULL COMMENT '0 - facebook account, 1 - twitter account',
  `SOCIAL_ACCOUNT` VARCHAR(50) NOT NULL,
  CONSTRAINT `USER_ID`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Record user\'s social account information.';

CREATE INDEX `USER_ID_idx` ON `mydb`.`SOCIAL_ACCOUNT` (`USER_ID` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`POST_CATEGORY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`POST_CATEGORY` ;

CREATE TABLE IF NOT EXISTS `mydb`.`POST_CATEGORY` (
  `CATEGORY_ID` INT NOT NULL,
  `CATEGORY_NAME` VARCHAR(50) NOT NULL,
  `CATEGORY_DESCRIPTION` VARCHAR(200) NULL,
  PRIMARY KEY (`CATEGORY_ID`))
ENGINE = InnoDB
COMMENT = 'Users can categorize their posts under predefined categories.';

CREATE UNIQUE INDEX `CATEGORY_ID_UNIQUE` ON `mydb`.`POST_CATEGORY` (`CATEGORY_ID` ASC);

CREATE UNIQUE INDEX `CATEGORY_NAME_UNIQUE` ON `mydb`.`POST_CATEGORY` (`CATEGORY_NAME` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`USER_POST`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`USER_POST` ;

CREATE TABLE IF NOT EXISTS `mydb`.`USER_POST` (
  `POST_ID` INT NOT NULL,
  `USER_ID` INT NOT NULL,
  `POST_DATE` DATETIME NOT NULL,
  `POST_CONTENT` VARCHAR(4000) NOT NULL,
  `CATEGORY_ID` INT NULL,
  PRIMARY KEY (`POST_ID`),
  CONSTRAINT `USER_ID`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `CATEGORY_ID`
    FOREIGN KEY (`CATEGORY_ID`)
    REFERENCES `mydb`.`POST_CATEGORY` (`CATEGORY_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Record the posts created by users.';

CREATE UNIQUE INDEX `POST_ID_UNIQUE` ON `mydb`.`USER_POST` (`POST_ID` ASC);

CREATE INDEX `USER_ID_idx` ON `mydb`.`USER_POST` (`USER_ID` ASC);

CREATE INDEX `CATEGORY_ID_idx` ON `mydb`.`USER_POST` (`CATEGORY_ID` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`TAG`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`TAG` ;

CREATE TABLE IF NOT EXISTS `mydb`.`TAG` (
  `TAG_ID` INT NOT NULL,
  `TAG_NAME` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`TAG_ID`))
ENGINE = InnoDB
COMMENT = 'Tags information of user posts';

CREATE UNIQUE INDEX `TAG_ID_UNIQUE` ON `mydb`.`TAG` (`TAG_ID` ASC);

CREATE UNIQUE INDEX `TAG_NAME_UNIQUE` ON `mydb`.`TAG` (`TAG_NAME` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`POST_TAGS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`POST_TAGS` ;

CREATE TABLE IF NOT EXISTS `mydb`.`POST_TAGS` (
  `POST_ID` INT NOT NULL,
  `TAG_ID` INT NOT NULL,
  PRIMARY KEY (`POST_ID`, `TAG_ID`),
  CONSTRAINT `POST_ID`
    FOREIGN KEY (`POST_ID`)
    REFERENCES `mydb`.`USER_POST` (`POST_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `TAG_ID`
    FOREIGN KEY (`TAG_ID`)
    REFERENCES `mydb`.`TAG` (`TAG_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Record the relationship between user posts and tags.';

CREATE INDEX `POST_ID_idx` ON `mydb`.`POST_TAGS` (`POST_ID` ASC);

CREATE INDEX `TAG_ID_idx` ON `mydb`.`POST_TAGS` (`TAG_ID` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`POST_COMMENTS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`POST_COMMENTS` ;

CREATE TABLE IF NOT EXISTS `mydb`.`POST_COMMENTS` (
  `COMMENT_ID` INT NOT NULL,
  `POST_ID` INT NOT NULL,
  `COMMENT_CONTENT` VARCHAR(4000) NOT NULL,
  `COMMENT_DATE` DATETIME NOT NULL,
  `COMMENT_USER_ID` INT NOT NULL,
  PRIMARY KEY (`COMMENT_ID`),
  CONSTRAINT `POST_ID`
    FOREIGN KEY (`POST_ID`)
    REFERENCES `mydb`.`USER_POST` (`POST_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `USER_ID`
    FOREIGN KEY (`COMMENT_USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Record comments from other users of user posts.';

CREATE UNIQUE INDEX `COMMENT_ID_UNIQUE` ON `mydb`.`POST_COMMENTS` (`COMMENT_ID` ASC);

CREATE INDEX `POST_ID_idx` ON `mydb`.`POST_COMMENTS` (`POST_ID` ASC);

CREATE INDEX `USER_ID_idx` ON `mydb`.`POST_COMMENTS` (`COMMENT_USER_ID` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`FAVORITE_POSTS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`FAVORITE_POSTS` ;

CREATE TABLE IF NOT EXISTS `mydb`.`FAVORITE_POSTS` (
  `FAVORITE_ID` INT NOT NULL,
  `USER_ID` INT NOT NULL,
  `POST_ID` INT NOT NULL,
  `FAVORITE_DATE` DATETIME NOT NULL,
  PRIMARY KEY (`FAVORITE_ID`),
  CONSTRAINT `USER_ID`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `POST_ID`
    FOREIGN KEY (`POST_ID`)
    REFERENCES `mydb`.`USER_POST` (`POST_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Record favorite posts of user.';

CREATE UNIQUE INDEX `FAVORITE_ID_UNIQUE` ON `mydb`.`FAVORITE_POSTS` (`FAVORITE_ID` ASC);

CREATE INDEX `USER_ID_idx` ON `mydb`.`FAVORITE_POSTS` (`USER_ID` ASC);

CREATE INDEX `POST_ID_idx` ON `mydb`.`FAVORITE_POSTS` (`POST_ID` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`FOLLOWERS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`FOLLOWERS` ;

CREATE TABLE IF NOT EXISTS `mydb`.`FOLLOWERS` (
  `USER_ID` INT NOT NULL,
  `FOLLOWED_USER_ID` INT NOT NULL,
  PRIMARY KEY (`USER_ID`, `FOLLOWED_USER_ID`),
  CONSTRAINT `USER_ID`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `USER_ID`
    FOREIGN KEY (`FOLLOWED_USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Record followers information of user.';

CREATE INDEX `USER_ID_idx` ON `mydb`.`FOLLOWERS` (`FOLLOWED_USER_ID` ASC);


-- -----------------------------------------------------
-- Table `mydb`.`NOTIFICATION`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`NOTIFICATION` ;

CREATE TABLE IF NOT EXISTS `mydb`.`NOTIFICATION` (
  `NOTIFICATION_ID` INT NOT NULL,
  `USER_ID` INT NOT NULL,
  `NOTIFICATION_TYPE` INT NOT NULL COMMENT '0 - follower notification, 1 - comments notification.',
  `NOTIFICATION_CONTENT` VARCHAR(400) NOT NULL,
  `NOTIFICATION_DATE` DATETIME NOT NULL,
  `STATUS` INT NOT NULL COMMENT '0 - unread, 1 - read.',
  PRIMARY KEY (`NOTIFICATION_ID`),
  CONSTRAINT `USER_ID`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Record the notification when other user followed current user and when comments on the post of current user.';

CREATE UNIQUE INDEX `NOTIFICATION_ID_UNIQUE` ON `mydb`.`NOTIFICATION` (`NOTIFICATION_ID` ASC);

CREATE INDEX `USER_ID_idx` ON `mydb`.`NOTIFICATION` (`USER_ID` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
