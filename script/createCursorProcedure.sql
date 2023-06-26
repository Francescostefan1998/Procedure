USE test;
create table autori (
codiceA int auto_increment,
nomeA varchar(255),
cognomeA varchar(255),
AnnoN int,
AnnoM int,
nazione varchar(255),
sesso char,
primary key (codiceA)
);
DELIMITER //
DROP FUNCTION IF EXISTS get_age_by_autore1;
CREATE FUNCTION get_age_by_autore1(in_nome VARCHAR(255), in_cognome VARCHAR(255)) RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE bday INT;
  DECLARE age INT;

  SELECT AnnoN INTO bday FROM autori WHERE nomeA = in_nome AND cognomeA = in_cognome;
  SET age = YEAR(CURDATE()) - bday;
  
  RETURN age;
END; //
DELIMITER ;
DELIMITER //
drop procedure if exists get_age_autori_nazione1;
CREATE PROCEDURE get_age_autori_nazione1(in_nazione VARCHAR(255))
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE cur_nome VARCHAR(255);
  DECLARE cur_cognome VARCHAR(255);
  DECLARE cur CURSOR FOR SELECT nomeA, cognomeA FROM autori WHERE nazione = in_nazione and AnnoM is null;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  DROP TABLE IF EXISTS autori_eta_temp;
  CREATE TABLE autori_eta_temp(
    nome VARCHAR(255),
    cognome VARCHAR(255),
    eta INT
  );
  
  OPEN cur;
  
  read_loop: LOOP
    FETCH cur INTO cur_nome, cur_cognome;
    IF done THEN 
      LEAVE read_loop;
    END IF;
    INSERT INTO autori_eta_temp (nome, cognome, eta) 
    VALUES (cur_nome, cur_cognome, get_age_by_autore1(cur_nome, cur_cognome));
  END LOOP;
  
  CLOSE cur;
END; //
DELIMITER ;
