-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le :  mar. 14 avr. 2020 à 09:51
-- Version du serveur :  5.7.23
-- Version de PHP :  7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `go_style_project_db`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `get_all_available_promo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_available_promo` ()  NO SQL
SELECT titre FROM codes_promo WHERE (CURDATE() BETWEEN date_debut AND date_fin)$$

DROP PROCEDURE IF EXISTS `get_code_promo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_code_promo` (IN `P_UUID` BIGINT UNSIGNED)  NO SQL
SELECT IF((SELECT code FROM codes_promo WHERE uuid=p_uuid) IS NULL,
    #on renvois ce message
    'Ce QRCode n''existe pas',
    #sinon si les dates de validitées ne correspondent pas
    (SELECT IF((SELECT code FROM codes_promo WHERE uuid=p_uuid AND (CURDATE() BETWEEN date_debut AND date_fin)) IS NULL,
        #on renvois ce message
        'Dates du code promo hors période de validité',
        #sinon on retourne le code
        (SELECT code FROM codes_promo WHERE uuid=p_uuid AND (CURDATE() BETWEEN date_debut AND date_fin)))
    )
) as code$$

DROP PROCEDURE IF EXISTS `insert_code`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_code` (IN `p_code` VARCHAR(20), IN `p_titre` VARCHAR(200), IN `p_date_debut` DATE, IN `p_date_fin` DATE)  NO SQL
BEGIN
DECLARE v_guid BIGINT UNSIGNED;
SET v_guid = (SELECT UUID_SHORT());
INSERT INTO codes_promo (uuid, code, titre, date_debut, date_fin) VALUES (v_guid, p_code, p_titre, p_date_debut, p_date_fin);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `codes_promo`
--

DROP TABLE IF EXISTS `codes_promo`;
CREATE TABLE IF NOT EXISTS `codes_promo` (
  `uuid` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(20) CHARACTER SET utf8 NOT NULL,
  `titre` varchar(200) CHARACTER SET utf8 NOT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `codes_promo`
--

INSERT INTO `codes_promo` (`uuid`, `code`, `titre`, `date_debut`, `date_fin`) VALUES
(98670694493061121, 'NOEL19', '25% de promotion pour votre NOËL 2019 !!', '2019-11-01', '2020-01-01'),
(98670694493061122, 'NOEL20', '20% de promotion pour votre NOËL 2020 !!', '2020-11-01', '2021-01-01'),
(98670694493061123, 'HALLOWEEN19', '15% de promotion pour HALLOWEEN 2019!', '2019-10-01', '2019-10-31'),
(98670694493061124, 'HALLOWEEN20', '20% de promotion pour HALLOWEEN 2020!!', '2020-10-01', '2020-10-31'),
(98670694493061125, 'CODETEST1', 'promotion de test 1', '2019-11-15', '2020-09-01'),
(98673509726683136, 'ETE2020', '10% de promotion sur toute la collection été 2020!!', '2020-06-01', '2020-08-31'),
(98674726192283648, 'BASKET0420', '40% de promotion sur toutes les baskets!', '2020-04-01', '2020-04-30');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
