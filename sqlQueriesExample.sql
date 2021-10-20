/* 
-- AUTHOR: Debra Wilkie
-- This is an example of SQL database queries and table creation
*/

--COMPLEX QUERIES
--Search for composers born between two years:
SELECT composer.composerFirstName, composer.composerLastName, composer.birthYear FROM composer
WHERE composer.birthYear < ['year'] AND composer.birthYear > ['year'];

--Search for operas composed in a certain year:
SELECT opera.operaName, opera.operaNameEnglish, opera.librettist, opera.yearComposed, composer.composerLastName, languages.langType FROM opera
INNER JOIN composer ON composer.id = opera.composerID
INNER JOIN languages ON languages.id = opera.languagesID
WHERE opera.yearComposed > ['year'];

--Search for opera grouped by librettist's names descending 
SELECT opera.operaName, opera.operaNameEnglish, opera.librettist, opera.yearComposed FROM opera
GROUP BY opera.librettist DESC;

--Search for characters in more than one opera using COUNT:
SELECT characterName.charName FROM characterName
INNER JOIN operaCharacter ON operaCharacter.characterNameID = characterName.id
GROUP BY characterName.charName 
HAVING COUNT(characterNameID) > 1;

--Combining the search for character in more than one opera with the list of the operas and voice types using a NOT IN and a COUNT statement:
--The LEFT JOIN is for the aria chart to show that they are in the opera but have no arias
SELECT characterName.charName, voiceType.voiceTypeName, opera.operaName, composer.composerLastName, aria.ariaTitle
FROM operaCharacter
INNER JOIN characterName ON characterName.id = operaCharacter.characterNameID
INNER JOIN voiceType ON voiceType.id = operaCharacter.voiceTypeID
INNER JOIN opera ON opera.id = operaCharacter.operaID
INNER JOIN composer ON composer.id = opera.composerID
LEFT JOIN aria ON aria.operaCharacterID = operaCharacter.id
WHERE characterName.charName NOT IN 
(SELECT characterName.charName FROM characterName
INNER JOIN operaCharacter ON operaCharacter.characterNameID = characterName.id
GROUP BY characterName.charName 
HAVING COUNT(characterNameID) = 1)
GROUP BY characterName.charName, voiceType.voiceTypeName, opera.operaName, composer.composerLastName


--BASIC QUERIES to display information
--If you know the opera and want to find arias in a particular voiceType:
SELECT opera.operaName, aria.ariaTitle, aria.ariaTitleEnglish, voiceType.voiceTypeName, characterName.charName, languages.langType FROM opera
INNER JOIN languages ON languages.id = opera.languagesID
INNER JOIN operaCharacter ON operaCharacter.operaID = opera.id
INNER JOIN voiceType ON voiceType.id = operaCharacter.voiceTypeID
INNER JOIN characterName ON characterName.id = operaCharacter.characterNameID
INNER JOIN aria ON aria.operaCharacterID = operaCharacter.id
WHERE opera.operaName = ['opera name'] AND voiceType.voiceTypeName = ['voice Type'];

--If you want to find all arias in a particular language and grouped by composer:
SELECT opera.operaName, composer.composerLastName, aria.ariaTitle, aria.ariaTitleEnglish, voiceType.voiceTypeName, characterName.charName, languages.langType FROM languages
INNER JOIN opera ON opera.languagesID = languages.id
INNER JOIN composer ON composer.id = opera.composerID
INNER JOIN operaCharacter ON operaCharacter.operaID = opera.id
INNER JOIN voiceType ON voiceType.id = operaCharacter.voiceTypeID
INNER JOIN characterName ON characterName.id = operaCharacter.characterNameID
INNER JOIN aria ON aria.operaCharacterID = operaCharacter.id
WHERE languages.langType = ['type']
GROUP BY composer.composerLastName, opera.operaName, aria.ariaTitle, aria.ariaTitleEnglish, voiceType.voiceTypeName, characterName.charName, languages.langType;

--UPDATE QUERIES:
--Update the librettist:
UPDATE opera SET opera.librettist = ['librettist'] WHERE opera.id = ['operaID'];
--Update the opera name:
UPDATE opera SET opera.operaName = ['opera name'] WHERE opera.id = ['operaID'];
--Update yearComposed:
UPDATE opera SET opera.yearComposed = ['year Composed'] WHERE opera.id = ['operaID'];

--DELETE QUERIES:
DELETE FROM composer WHERE composer.id = ['composerID'];
DELETE FROM opera WHERE opera.id = ['operaID'];


--TABLE CREATION:
CREATE TABLE `composer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `composerFirstName` varchar(255) DEFAULT NULL,
  `composerLastName` varchar(255) NOT NULL,
  `birthYear` int(11) DEFAULT NULL,
  `yearOfDeath` int(11) DEFAULT NULL,
  `countryName` varchar(255) DEFAULT NULL,
PRIMARY KEY (`id`)
);

CREATE TABLE `languages` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `langType` varchar(255) NOT NULL,
PRIMARY KEY (`id`)
);

CREATE TABLE `opera` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `operaName` varchar(255) NOT NULL,
   `operaNameEnglish` varchar(255) NOT NULL, 
   `librettist` varchar(255) DEFAULT NULL,
   `yearComposed` int(11) DEFAULT NULL,
   `composerID` int(11) NOT NULL,
   `languagesID` int(11) NOT NULL, 
     PRIMARY KEY (`id`),
FOREIGN KEY (`composerID`) REFERENCES `composer` (`id`)     
ON UPDATE CASCADE,
FOREIGN KEY (`languagesID`) REFERENCES `languages` (`id`)     
ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE `characterName` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
)ENGINE=InnoDB;

CREATE TABLE `voiceType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `voiceTypeName` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
)ENGINE=InnoDB;

CREATE TABLE `operaCharacter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operaID` int(11) NOT NULL, 
  `characterNameID` int(11) NOT NULL,
  `voiceTypeID` int(11) NOT NULL,
 PRIMARY KEY (`id`),
FOREIGN KEY (`operaID`) REFERENCES `opera` (`id`)     
ON UPDATE CASCADE,
FOREIGN KEY (`characterNameID`) REFERENCES `characterName` (`id`)     
ON UPDATE CASCADE,
FOREIGN KEY (`voiceTypeID`) REFERENCES `voiceType` (`id`)     
ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `operaScene` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `act` int(11),
  `scene` int(11),
  `operaID` int(11) NOT NULL, 
PRIMARY KEY (`id`),
FOREIGN KEY (`operaID`) REFERENCES `opera` (`id`)     
ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `aria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ariaTitle` varchar(255) NOT NULL,
  `ariaTitleEnglish` varchar(255) DEFAULT NULL,
  `operaCharacterID` int(11) NOT NULL,
  `operaSceneID` int(11) NOT NULL,
 PRIMARY KEY (`id`),
FOREIGN KEY (`operaCharacterID`) REFERENCES `operaCharacter` (`id`)     
ON UPDATE CASCADE,
FOREIGN KEY (`operaSceneID`) REFERENCES `operaScene` (`id`)     
ON UPDATE CASCADE
) ENGINE=InnoDB;


