-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: sistema_clinico
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `auditoria_bd`
--

DROP TABLE IF EXISTS `auditoria_bd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_bd` (
  `id_auditoria` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tabla_afectada` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_registro` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operacion` enum('INSERT','UPDATE','DELETE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_auditoria_tabla_fecha` (`tabla_afectada`,`fecha_hora`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_bd`
--

LOCK TABLES `auditoria_bd` WRITE;
/*!40000 ALTER TABLE `auditoria_bd` DISABLE KEYS */;
INSERT INTO `auditoria_bd` VALUES (1,'Paciente','1','INSERT','2026-10-23 18:46:21'),(2,'Departamento','1','INSERT','2026-10-23 18:47:37'),(3,'Empleado','1','INSERT','2026-10-23 18:47:59'),(4,'Turno','1','INSERT','2026-10-23 18:56:45'),(5,'Paciente','3','INSERT','2026-10-23 19:37:58'),(6,'Turno','1','UPDATE','2026-10-23 20:03:42'),(7,'Consulta','1','INSERT','2026-10-23 20:03:42'),(8,'Historia_Clinica','1','INSERT','2026-10-23 20:07:54'),(9,'Turno','2','INSERT','2026-10-23 20:24:47'),(10,'Turno','2','UPDATE','2026-10-23 20:43:48'),(11,'Turno','3','INSERT','2026-10-26 20:28:46'),(12,'Turno','3','DELETE','2026-10-26 20:30:59'),(13,'Turno','4','INSERT','2026-10-26 21:05:19'),(14,'Turno','4','UPDATE','2026-10-26 21:06:49'),(15,'Consulta','2','INSERT','2026-10-26 21:17:00'),(16,'Consulta','2','UPDATE','2026-10-26 21:25:24'),(17,'Consulta','2','DELETE','2026-10-26 21:29:46'),(18,'Historia_Clinica','2','INSERT','2026-10-27 19:09:55'),(19,'Historia_Clinica','2','UPDATE','2026-10-27 19:12:39'),(20,'Consulta','3','INSERT','2026-10-27 19:23:12'),(21,'Historia_Clinica','3','INSERT','2026-10-27 19:24:25'),(22,'Historia_Clinica','3','DELETE','2026-10-27 19:25:31'),(23,'Internacion','1','INSERT','2026-10-27 19:43:54'),(24,'Internacion','2','INSERT','2026-10-28 13:40:16'),(25,'Internacion','2','UPDATE','2026-10-28 13:50:14'),(26,'Internacion','2','DELETE','2026-10-28 13:59:39'),(27,'Medicamento','1','INSERT','2026-10-28 14:18:54'),(28,'Stock_Medicamentos','1','INSERT','2026-10-28 14:22:33'),(29,'Stock_Medicamentos','1','UPDATE','2026-10-28 14:26:59'),(30,'Registro_Medicacion','1','INSERT','2026-10-28 14:26:59'),(31,'Stock_Medicamentos','2','INSERT','2026-10-28 14:30:20'),(32,'Stock_Medicamentos','3','INSERT','2026-10-28 14:33:10'),(33,'Medicamento','2','INSERT','2026-10-28 14:35:27'),(34,'Stock_Medicamentos','4','INSERT','2026-10-28 14:36:27'),(35,'Internacion','3','INSERT','2026-10-28 14:39:16'),(36,'Internacion','3','UPDATE','2026-10-28 14:39:58'),(37,'Receta','1','INSERT','2026-10-28 14:44:26'),(38,'Receta','1','UPDATE','2026-10-28 14:46:49'),(39,'Receta','1','DELETE','2026-10-28 14:48:37'),(40,'Departamento','2','INSERT','2026-10-28 14:51:29'),(41,'Departamento','2','UPDATE','2026-10-28 14:52:25'),(42,'Departamento','2','DELETE','2026-10-28 14:53:07'),(43,'Empleado','2','INSERT','2026-10-28 14:55:39'),(44,'Empleado','2','UPDATE','2026-10-28 14:57:15'),(45,'Empleado','2','DELETE','2026-10-28 14:58:25'),(46,'Paciente','4','INSERT','2026-10-28 15:10:54'),(47,'Paciente','4','UPDATE','2026-10-28 15:12:08'),(48,'Paciente','4','DELETE','2026-10-28 15:13:38'),(49,'Usuario','1','INSERT','2026-10-28 15:27:11'),(50,'Usuario','1','UPDATE','2026-10-28 15:38:01'),(51,'Usuario','1','DELETE','2026-10-28 15:47:45'),(52,'Paciente','5','INSERT','2026-10-28 16:15:17'),(53,'Historia_Clinica','4','INSERT','2026-10-28 17:28:26'),(54,'Turno','5','INSERT','2026-10-28 17:33:56'),(57,'Historia_Clinica','1','DELETE','2026-11-06 02:20:31'),(58,'Historia_Clinica','2','DELETE','2026-11-06 02:20:31'),(59,'Historia_Clinica','4','DELETE','2026-11-06 02:20:31'),(60,'Registro_Medicacion','1','DELETE','2026-11-06 02:20:31'),(61,'Consulta','1','DELETE','2026-11-06 02:20:31'),(62,'Consulta','3','DELETE','2026-11-06 02:20:31'),(63,'Internacion','1','DELETE','2026-11-06 02:20:31'),(64,'Internacion','3','DELETE','2026-11-06 02:20:31'),(65,'Turno','1','DELETE','2026-11-06 02:20:31'),(66,'Turno','2','DELETE','2026-11-06 02:20:31'),(67,'Turno','4','DELETE','2026-11-06 02:20:31'),(68,'Turno','5','DELETE','2026-11-06 02:20:31'),(69,'Paciente','1','DELETE','2026-11-06 02:20:31'),(70,'Paciente','3','DELETE','2026-11-06 02:20:31'),(71,'Paciente','5','DELETE','2026-11-06 02:20:31'),(72,'Paciente','7','INSERT','2026-11-06 03:00:12'),(73,'Usuario','2','INSERT','2026-11-06 03:00:12'),(74,'Paciente','8','INSERT','2026-11-06 04:16:16'),(75,'Usuario','3','INSERT','2026-11-06 04:16:16'),(76,'Paciente','9','INSERT','2026-11-06 04:22:39'),(77,'Usuario','4','INSERT','2026-11-06 04:22:39'),(78,'Usuario','2','DELETE','2026-11-06 04:43:35'),(79,'Usuario','3','DELETE','2026-11-06 04:43:35'),(80,'Usuario','4','DELETE','2026-11-06 04:43:35'),(81,'Paciente','7','DELETE','2026-11-06 04:43:35'),(82,'Paciente','8','DELETE','2026-11-06 04:43:35'),(83,'Paciente','9','DELETE','2026-11-06 04:43:35'),(84,'Paciente','10','INSERT','2026-11-06 04:46:43'),(85,'Usuario','5','INSERT','2026-11-06 04:46:43'),(86,'Usuario','5','DELETE','2026-11-06 04:53:34'),(87,'Paciente','10','DELETE','2026-11-06 04:53:34'),(88,'Paciente','11','INSERT','2026-11-06 04:55:20'),(89,'Usuario','6','INSERT','2026-11-06 04:55:20'),(90,'Usuario','6','DELETE','2026-11-06 05:16:10'),(91,'Paciente','11','DELETE','2026-11-06 05:16:10'),(92,'Paciente','12','INSERT','2026-11-06 05:17:35'),(93,'Usuario','7','INSERT','2026-11-06 05:17:35'),(94,'Usuario','7','DELETE','2026-11-06 05:23:32'),(95,'Paciente','12','DELETE','2026-11-06 05:23:32'),(96,'Paciente','13','INSERT','2026-11-06 05:25:02'),(97,'Usuario','8','INSERT','2026-11-06 05:25:02'),(98,'Usuario','8','DELETE','2026-11-06 05:42:55'),(99,'Paciente','13','DELETE','2026-11-06 05:42:55'),(100,'Paciente','14','INSERT','2026-11-06 05:44:28'),(101,'Usuario','9','INSERT','2026-11-06 05:44:28'),(102,'Usuario','9','DELETE','2026-11-06 05:50:00'),(103,'Paciente','14','DELETE','2026-11-06 05:50:00'),(104,'Paciente','15','INSERT','2026-11-06 05:59:44'),(105,'Usuario','10','INSERT','2026-11-06 05:59:44'),(106,'Paciente','15','UPDATE','2026-11-06 06:45:46'),(107,'Paciente','15','UPDATE','2026-11-06 06:46:23'),(108,'Turno','6','INSERT','2026-11-06 07:35:32'),(109,'Turno','7','INSERT','2026-11-06 07:35:32'),(110,'Turno','8','INSERT','2026-11-06 07:35:32'),(111,'Paciente','16','INSERT','2026-11-06 08:26:35'),(112,'Usuario','11','INSERT','2026-11-06 08:26:35'),(113,'Usuario','11','DELETE','2026-11-06 08:27:04'),(114,'Paciente','16','DELETE','2026-11-06 08:27:04'),(115,'Empleado','3','INSERT','2026-11-06 08:53:21'),(116,'Empleado','4','INSERT','2026-11-06 08:53:21'),(117,'Empleado','5','INSERT','2026-11-06 08:53:21'),(118,'Empleado','6','INSERT','2026-11-06 08:53:21'),(119,'Empleado','7','INSERT','2026-11-06 08:53:21'),(120,'Empleado','8','INSERT','2026-11-06 08:53:21'),(121,'Turno','6','UPDATE','2026-11-06 08:53:21'),(122,'Turno','7','UPDATE','2026-11-06 08:53:21'),(123,'Turno','8','UPDATE','2026-11-06 08:53:21'),(124,'Paciente','17','INSERT','2026-11-06 08:56:07'),(125,'Usuario','12','INSERT','2026-11-06 08:56:07'),(126,'Turno','9','INSERT','2026-11-06 08:56:08'),(127,'Turno','9','DELETE','2026-11-06 08:56:18'),(128,'Usuario','12','DELETE','2026-11-06 08:56:18'),(129,'Paciente','17','DELETE','2026-11-06 08:56:18'),(130,'Turno','6','DELETE','2026-11-06 08:59:14'),(131,'Turno','7','DELETE','2026-11-06 08:59:14'),(132,'Turno','8','DELETE','2026-11-06 08:59:14'),(133,'Usuario','10','DELETE','2026-11-06 08:59:14'),(134,'Paciente','15','DELETE','2026-11-06 08:59:14'),(135,'Paciente','18','INSERT','2026-11-06 09:01:44'),(136,'Usuario','13','INSERT','2026-11-06 09:01:44'),(137,'Paciente','18','UPDATE','2026-11-06 09:02:05'),(138,'Paciente','19','INSERT','2026-11-06 09:43:10'),(139,'Usuario','14','INSERT','2026-11-06 09:43:10'),(140,'Turno','10','INSERT','2026-11-06 09:43:10'),(141,'Turno','10','DELETE','2026-11-06 09:43:10'),(142,'Usuario','14','DELETE','2026-11-06 09:43:10'),(143,'Paciente','19','DELETE','2026-11-06 09:43:10'),(144,'Paciente','20','INSERT','2026-11-06 09:45:19'),(145,'Usuario','15','INSERT','2026-11-06 09:45:19'),(146,'Turno','11','INSERT','2026-11-06 09:45:19'),(147,'Turno','11','DELETE','2026-11-06 09:45:19'),(148,'Usuario','15','DELETE','2026-11-06 09:45:19'),(149,'Paciente','20','DELETE','2026-11-06 09:45:19'),(150,'Turno','12','INSERT','2026-11-06 10:16:06');
/*!40000 ALTER TABLE `auditoria_bd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consulta`
--

DROP TABLE IF EXISTS `consulta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consulta` (
  `id_consulta` int unsigned NOT NULL AUTO_INCREMENT,
  `id_turno` int unsigned DEFAULT NULL,
  `id_paciente` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Médico que atendió',
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `motivo` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_consulta`),
  UNIQUE KEY `id_turno` (`id_turno`),
  KEY `fk_consulta_medico` (`id_empleado`),
  KEY `idx_consulta_paciente_fecha` (`id_paciente`,`fecha`),
  CONSTRAINT `fk_consulta_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`),
  CONSTRAINT `fk_consulta_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
  CONSTRAINT `fk_consulta_turno` FOREIGN KEY (`id_turno`) REFERENCES `turno` (`id_turno`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consulta`
--

LOCK TABLES `consulta` WRITE;
/*!40000 ALTER TABLE `consulta` DISABLE KEYS */;
/*!40000 ALTER TABLE `consulta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bi_consulta_validar` BEFORE INSERT ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Turno t WHERE t.id_turno=NEW.id_turno AND t.id_paciente=NEW.id_paciente AND t.id_empleado=NEW.id_empleado AND t.estado<>'CANCELADO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente y medico deben coincidir con el turno asociado'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_consulta` AFTER INSERT ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',NEW.id_consulta,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_consulta_turno` AFTER INSERT ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL THEN UPDATE Turno SET estado='ATENDIDO' WHERE id_turno=NEW.id_turno; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bu_consulta_validar` BEFORE UPDATE ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Turno t WHERE t.id_turno=NEW.id_turno AND t.id_paciente=NEW.id_paciente AND t.id_empleado=NEW.id_empleado AND t.estado<>'CANCELADO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente y medico deben coincidir con el turno asociado'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_consulta` AFTER UPDATE ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',NEW.id_consulta,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_consulta` AFTER DELETE ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',OLD.id_consulta,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `consultorios`
--

DROP TABLE IF EXISTS `consultorios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultorios` (
  `id_consultorio` int unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` int unsigned DEFAULT NULL,
  `nombre` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubicacion` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_consultorio`),
  UNIQUE KEY `id_empleado` (`id_empleado`),
  CONSTRAINT `fk_consultorio_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultorios`
--

LOCK TABLES `consultorios` WRITE;
/*!40000 ALTER TABLE `consultorios` DISABLE KEYS */;
/*!40000 ALTER TABLE `consultorios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departamento`
--

DROP TABLE IF EXISTS `departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamento` (
  `id_departamento` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubicacion` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_departamento`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamento`
--

LOCK TABLES `departamento` WRITE;
/*!40000 ALTER TABLE `departamento` DISABLE KEYS */;
INSERT INTO `departamento` VALUES (1,'Departamento de Prueba','Consultorio de prueba');
/*!40000 ALTER TABLE `departamento` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_departamento` AFTER INSERT ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',NEW.id_departamento,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_departamento` AFTER UPDATE ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',NEW.id_departamento,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_departamento` AFTER DELETE ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',OLD.id_departamento,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `empleado`
--

DROP TABLE IF EXISTS `empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleado` (
  `id_empleado` int unsigned NOT NULL AUTO_INCREMENT,
  `id_departamento` int unsigned NOT NULL,
  `dni` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `telefono` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `id_rol` int NOT NULL,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `dni` (`dni`),
  KEY `fk_empleado_departamento` (`id_departamento`),
  KEY `fk_empleado_rol` (`id_rol`),
  CONSTRAINT `fk_empleado_departamento` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`),
  CONSTRAINT `fk_empleado_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleado`
--

LOCK TABLES `empleado` WRITE;
/*!40000 ALTER TABLE `empleado` DISABLE KEYS */;
INSERT INTO `empleado` VALUES (1,1,'99000002','Medico','Prueba',NULL,NULL,NULL,NULL,'ACTIVO',1),(3,1,'88000011','Andrea','Fernández',NULL,'1100000011','andrea.fernandez@example.com','Consultorio 1','ACTIVO',1),(4,1,'88000012','Martín','López',NULL,'1100000012','martin.lopez@example.com','Consultorio 2','ACTIVO',1),(5,1,'88000013','Carla','Gómez',NULL,'1100000013','carla.gomez@example.com','Consultorio 3','ACTIVO',1),(6,1,'88000014','Pablo','Ruiz',NULL,'1100000014','pablo.ruiz@example.com','Consultorio 4','ACTIVO',1),(7,1,'88000015','Valeria','Torres',NULL,'1100000015','valeria.torres@example.com','Consultorio 5','ACTIVO',1),(8,1,'88000016','Bruno','Díaz',NULL,'1100000016','bruno.diaz@example.com','Consultorio 6','ACTIVO',1);
/*!40000 ALTER TABLE `empleado` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_empleado` AFTER INSERT ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',NEW.id_empleado,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_empleado` AFTER UPDATE ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',NEW.id_empleado,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_empleado` AFTER DELETE ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',OLD.id_empleado,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `habitacion`
--

DROP TABLE IF EXISTS `habitacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `habitacion` (
  `id_habitacion` int unsigned NOT NULL AUTO_INCREMENT,
  `numero` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `piso` smallint DEFAULT NULL,
  `tipo` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('DISPONIBLE','OCUPADA','MANTENIMIENTO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DISPONIBLE',
  PRIMARY KEY (`id_habitacion`),
  UNIQUE KEY `numero` (`numero`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `habitacion`
--

LOCK TABLES `habitacion` WRITE;
/*!40000 ALTER TABLE `habitacion` DISABLE KEYS */;
INSERT INTO `habitacion` VALUES (1,'TEST-01',1,'Individual','OCUPADA'),(2,'TEST-02',1,'Individual','MANTENIMIENTO'),(3,'TEST-03',1,'Individual','DISPONIBLE');
/*!40000 ALTER TABLE `habitacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historia_clinica`
--

DROP TABLE IF EXISTS `historia_clinica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historia_clinica` (
  `id_historia_clinica` int unsigned NOT NULL AUTO_INCREMENT,
  `id_internacion` int unsigned DEFAULT NULL,
  `id_consulta` int unsigned DEFAULT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Empleado que registra la evolución',
  `fecha` date NOT NULL DEFAULT (curdate()),
  `hora` time NOT NULL DEFAULT (curtime()),
  `tipo_registro` enum('DIAGNOSTICO','EVOLUCION','ENFERMERIA','SIGNOS_VITALES','MEDICACION','OTRO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `diagnostico` text COLLATE utf8mb4_unicode_ci,
  `tratamiento` text COLLATE utf8mb4_unicode_ci,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_historia_clinica`),
  KEY `fk_historia_empleado` (`id_empleado`),
  KEY `idx_historia_internacion_fecha` (`id_internacion`,`fecha`,`hora`),
  KEY `idx_historia_consulta_fecha` (`id_consulta`,`fecha`,`hora`),
  CONSTRAINT `fk_historia_consulta` FOREIGN KEY (`id_consulta`) REFERENCES `consulta` (`id_consulta`),
  CONSTRAINT `fk_historia_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  CONSTRAINT `fk_historia_internacion` FOREIGN KEY (`id_internacion`) REFERENCES `internacion` (`id_internacion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historia_clinica`
--

LOCK TABLES `historia_clinica` WRITE;
/*!40000 ALTER TABLE `historia_clinica` DISABLE KEYS */;
/*!40000 ALTER TABLE `historia_clinica` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bi_historia_origen` BEFORE INSERT ON `historia_clinica` FOR EACH ROW BEGIN
 IF (NEW.id_internacion IS NULL AND NEW.id_consulta IS NULL) OR (NEW.id_internacion IS NOT NULL AND NEW.id_consulta IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La historia clinica debe pertenecer a una internacion o a una consulta'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_historia` AFTER INSERT ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',NEW.id_historia_clinica,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bu_historia_origen` BEFORE UPDATE ON `historia_clinica` FOR EACH ROW BEGIN
 IF (NEW.id_internacion IS NULL AND NEW.id_consulta IS NULL) OR (NEW.id_internacion IS NOT NULL AND NEW.id_consulta IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La historia clinica debe pertenecer a una internacion o a una consulta'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_historia` AFTER UPDATE ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',NEW.id_historia_clinica,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_historia` AFTER DELETE ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',OLD.id_historia_clinica,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `internacion`
--

DROP TABLE IF EXISTS `internacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internacion` (
  `id_internacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `id_habitacion` int unsigned NOT NULL,
  `fecha_ingreso` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_alta` datetime DEFAULT NULL,
  `motivo` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('ACTIVA','ALTA','CANCELADA') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVA',
  `codigo_qr` char(36) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id_internacion`),
  UNIQUE KEY `codigo_qr` (`codigo_qr`),
  KEY `idx_internacion_paciente_estado` (`id_paciente`,`estado`),
  KEY `idx_internacion_habitacion_estado` (`id_habitacion`,`estado`),
  CONSTRAINT `fk_internacion_habitacion` FOREIGN KEY (`id_habitacion`) REFERENCES `habitacion` (`id_habitacion`),
  CONSTRAINT `fk_internacion_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internacion`
--

LOCK TABLES `internacion` WRITE;
/*!40000 ALTER TABLE `internacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacion` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bi_internacion_validar` BEFORE INSERT ON `internacion` FOR EACH ROW BEGIN
 IF NEW.fecha_alta IS NOT NULL AND NEW.fecha_alta < NEW.fecha_ingreso THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha de alta no puede ser anterior al ingreso'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=NEW.id_habitacion AND estado='ACTIVA') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La habitacion ya tiene una internacion activa'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Habitacion WHERE id_habitacion=NEW.id_habitacion AND estado='MANTENIMIENTO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se puede internar en una habitacion en mantenimiento'; END IF;
 SET NEW.codigo_qr = COALESCE(NULLIF(NEW.codigo_qr,''), UUID());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_internacion` AFTER INSERT ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',NEW.id_internacion,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_internacion_habitacion` AFTER INSERT ON `internacion` FOR EACH ROW BEGIN
 IF NEW.estado='ACTIVA' THEN UPDATE Habitacion SET estado='OCUPADA' WHERE id_habitacion=NEW.id_habitacion AND estado<>'MANTENIMIENTO'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bu_internacion_validar` BEFORE UPDATE ON `internacion` FOR EACH ROW BEGIN
 IF NEW.fecha_alta IS NOT NULL AND NEW.fecha_alta < NEW.fecha_ingreso THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha de alta no puede ser anterior al ingreso'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=NEW.id_habitacion AND estado='ACTIVA' AND id_internacion<>NEW.id_internacion) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La habitacion ya tiene una internacion activa'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Habitacion WHERE id_habitacion=NEW.id_habitacion AND estado='MANTENIMIENTO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se puede internar en una habitacion en mantenimiento'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_internacion` AFTER UPDATE ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',NEW.id_internacion,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_internacion_habitacion` AFTER UPDATE ON `internacion` FOR EACH ROW BEGIN
 IF OLD.id_habitacion<>NEW.id_habitacion OR OLD.estado<>NEW.estado THEN
  IF OLD.estado='ACTIVA' AND NOT EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=OLD.id_habitacion AND estado='ACTIVA' AND id_internacion<>NEW.id_internacion) THEN UPDATE Habitacion SET estado='DISPONIBLE' WHERE id_habitacion=OLD.id_habitacion AND estado='OCUPADA'; END IF;
  IF NEW.estado='ACTIVA' THEN UPDATE Habitacion SET estado='OCUPADA' WHERE id_habitacion=NEW.id_habitacion AND estado<>'MANTENIMIENTO'; END IF;
 END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_internacion` AFTER DELETE ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',OLD.id_internacion,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medicamento`
--

DROP TABLE IF EXISTS `medicamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicamento` (
  `id_medicamento` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `presentacion` enum('COMPRIMIDOS','CAPSULAS','INYECTABLES','LIQUIDOS','CREMA','GOTAS','OTROS') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OTROS',
  `dosis` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Concentración del producto, por ejemplo 500 mg',
  `laboratorio` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_medicamento`),
  KEY `idx_medicamento_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicamento`
--

LOCK TABLES `medicamento` WRITE;
/*!40000 ALTER TABLE `medicamento` DISABLE KEYS */;
INSERT INTO `medicamento` VALUES (1,'Medicamento Prueba Trigger','Registro temporal para probar los triggers de medicacion','COMPRIMIDOS','500 mg','Laboratorio de prueba'),(2,'Medicamento Prueba Trigger 2','Segundo medicamento temporal para probar la validacion de lotes','CAPSULAS','250 mg','Laboratorio de prueba');
/*!40000 ALTER TABLE `medicamento` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_medicamento` AFTER INSERT ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',NEW.id_medicamento,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_medicamento` AFTER UPDATE ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',NEW.id_medicamento,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_medicamento` AFTER DELETE ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',OLD.id_medicamento,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medico`
--

DROP TABLE IF EXISTS `medico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medico` (
  `id_empleado` int unsigned NOT NULL,
  `matricula` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `especialidad` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `matricula` (`matricula`),
  CONSTRAINT `fk_medico_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medico`
--

LOCK TABLES `medico` WRITE;
/*!40000 ALTER TABLE `medico` DISABLE KEYS */;
INSERT INTO `medico` VALUES (1,'MAT-PRUEBA-001','Clínica'),(3,'MAT-DEMO-011','Cardiología'),(4,'MAT-DEMO-012','Oftalmología'),(5,'MAT-DEMO-013','Traumatología'),(6,'MAT-DEMO-014','Diagnóstico por Imágenes'),(7,'MAT-DEMO-015','Flebología'),(8,'MAT-DEMO-016','Endocrinología');
/*!40000 ALTER TABLE `medico` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bi_medico_categoria` BEFORE INSERT ON `medico` FOR EACH ROW BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Empleado e
        INNER JOIN Rol r ON r.id_rol = e.id_rol
        WHERE e.id_empleado = NEW.id_empleado
          AND r.nombre = 'Medico'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'El empleado debe tener asignado el rol Medico';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bu_medico_categoria` BEFORE UPDATE ON `medico` FOR EACH ROW BEGIN
    IF NEW.id_empleado <> OLD.id_empleado THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'No se permite cambiar el empleado asociado al medico';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Empleado e
        INNER JOIN Rol r ON r.id_rol = e.id_rol
        WHERE e.id_empleado = NEW.id_empleado
          AND r.nombre = 'Medico'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'El empleado debe tener asignado el rol Medico';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `obra_social`
--

DROP TABLE IF EXISTS `obra_social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `obra_social` (
  `id_obra_social` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (`id_obra_social`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obra_social`
--

LOCK TABLES `obra_social` WRITE;
/*!40000 ALTER TABLE `obra_social` DISABLE KEYS */;
INSERT INTO `obra_social` VALUES (1,'OSDE',NULL,NULL,NULL,'ACTIVA'),(2,'Galeno',NULL,NULL,NULL,'ACTIVA'),(3,'Swiss Medical',NULL,NULL,NULL,'ACTIVA'),(4,'OSDEPYM',NULL,NULL,NULL,'ACTIVA'),(5,'Medifé',NULL,NULL,NULL,'ACTIVA'),(6,'Sancor Salud',NULL,NULL,NULL,'ACTIVA'),(7,'OSECAC',NULL,NULL,NULL,'ACTIVA'),(8,'PAMI',NULL,NULL,NULL,'ACTIVA'),(9,'IOMA',NULL,NULL,NULL,'ACTIVA'),(10,'Unión Personal',NULL,NULL,NULL,'ACTIVA'),(11,'Medicus',NULL,NULL,NULL,'ACTIVA'),(12,'Omint',NULL,NULL,NULL,'ACTIVA'),(13,'Avalian',NULL,NULL,NULL,'ACTIVA'),(14,'Hominis',NULL,NULL,NULL,'ACTIVA'),(15,'OSUTHGRA',NULL,NULL,NULL,'ACTIVA');
/*!40000 ALTER TABLE `obra_social` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paciente`
--

DROP TABLE IF EXISTS `paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente` (
  `id_paciente` int unsigned NOT NULL AUTO_INCREMENT,
  `id_obra_social` int unsigned DEFAULT NULL,
  `dni` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `sexo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nacionalidad` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provincia` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_paciente`),
  UNIQUE KEY `dni` (`dni`),
  KEY `fk_paciente_obra_social` (`id_obra_social`),
  CONSTRAINT `fk_paciente_obra_social` FOREIGN KEY (`id_obra_social`) REFERENCES `obra_social` (`id_obra_social`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente`
--

LOCK TABLES `paciente` WRITE;
/*!40000 ALTER TABLE `paciente` DISABLE KEYS */;
INSERT INTO `paciente` VALUES (18,10,'12345678','Alexi','Colque','1231-06-26','M','11 2345 1231','alexis.colque@gmail.com','Parana 1234','argentina','caba');
/*!40000 ALTER TABLE `paciente` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_paciente` AFTER INSERT ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',NEW.id_paciente,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_paciente` AFTER UPDATE ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',NEW.id_paciente,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_paciente` AFTER DELETE ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',OLD.id_paciente,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `receta`
--

DROP TABLE IF EXISTS `receta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receta` (
  `id_receta` int unsigned NOT NULL AUTO_INCREMENT,
  `id_consulta` int unsigned NOT NULL,
  `id_paciente` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Médico prescriptor',
  `id_medicamento` int unsigned NOT NULL,
  PRIMARY KEY (`id_receta`),
  KEY `fk_receta_paciente` (`id_paciente`),
  KEY `fk_receta_medico` (`id_empleado`),
  KEY `fk_receta_medicamento` (`id_medicamento`),
  KEY `idx_receta_consulta` (`id_consulta`),
  CONSTRAINT `fk_receta_consulta` FOREIGN KEY (`id_consulta`) REFERENCES `consulta` (`id_consulta`),
  CONSTRAINT `fk_receta_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`),
  CONSTRAINT `fk_receta_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`),
  CONSTRAINT `fk_receta_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receta`
--

LOCK TABLES `receta` WRITE;
/*!40000 ALTER TABLE `receta` DISABLE KEYS */;
/*!40000 ALTER TABLE `receta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bi_receta_validar` BEFORE INSERT ON `receta` FOR EACH ROW BEGIN
 IF NOT EXISTS(SELECT 1 FROM Consulta c WHERE c.id_consulta=NEW.id_consulta AND c.id_paciente=NEW.id_paciente AND c.id_empleado=NEW.id_empleado) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La receta debe coincidir con el paciente y medico de la consulta'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_receta` AFTER INSERT ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',NEW.id_receta,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_receta` AFTER UPDATE ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',NEW.id_receta,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_receta` AFTER DELETE ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',OLD.id_receta,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `registro_medicacion`
--

DROP TABLE IF EXISTS `registro_medicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registro_medicacion` (
  `id_registro_medicacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_internacion` int unsigned NOT NULL,
  `id_medicamento` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Empleado que administra; validación de rol en backend',
  `id_stock` int unsigned NOT NULL,
  `fecha` date NOT NULL DEFAULT (curdate()),
  `hora` time NOT NULL DEFAULT (curtime()),
  `dosis_administrada` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_registro_medicacion`),
  KEY `fk_registro_medicamento` (`id_medicamento`),
  KEY `fk_registro_empleado` (`id_empleado`),
  KEY `fk_registro_stock` (`id_stock`),
  KEY `idx_registro_internacion_fecha` (`id_internacion`,`fecha`,`hora`),
  CONSTRAINT `fk_registro_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  CONSTRAINT `fk_registro_internacion` FOREIGN KEY (`id_internacion`) REFERENCES `internacion` (`id_internacion`),
  CONSTRAINT `fk_registro_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`),
  CONSTRAINT `fk_registro_stock` FOREIGN KEY (`id_stock`) REFERENCES `stock_medicamentos` (`id_stock`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registro_medicacion`
--

LOCK TABLES `registro_medicacion` WRITE;
/*!40000 ALTER TABLE `registro_medicacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `registro_medicacion` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bi_registro_medicacion_validar` BEFORE INSERT ON `registro_medicacion` FOR EACH ROW BEGIN
 DECLARE v_medicamento INT UNSIGNED DEFAULT NULL;
 DECLARE v_cantidad INT UNSIGNED DEFAULT NULL;
 DECLARE v_vencimiento DATE DEFAULT NULL;
 DECLARE v_estado VARCHAR(20) DEFAULT NULL;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_medicamento = NULL;
 SELECT id_medicamento, cantidad, fecha_vencimiento INTO v_medicamento, v_cantidad, v_vencimiento FROM Stock_Medicamentos WHERE id_stock=NEW.id_stock FOR UPDATE;
 SELECT estado INTO v_estado FROM Internacion WHERE id_internacion=NEW.id_internacion;
 IF v_medicamento IS NULL OR v_medicamento<>NEW.id_medicamento THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El lote de stock no corresponde al medicamento'; END IF;
 IF v_cantidad<1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No hay unidades disponibles en ese lote'; END IF;
 IF v_vencimiento<CURRENT_DATE THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se puede administrar un medicamento vencido'; END IF;
 IF v_estado<>'ACTIVA' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Solo se registra medicacion en internaciones activas'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_registro_medicacion` AFTER INSERT ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',NEW.id_registro_medicacion,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_registro_medicacion_stock` AFTER INSERT ON `registro_medicacion` FOR EACH ROW BEGIN
 UPDATE Stock_Medicamentos SET cantidad=cantidad-1 WHERE id_stock=NEW.id_stock AND cantidad>0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_registro_medicacion` AFTER UPDATE ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',NEW.id_registro_medicacion,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_registro_medicacion` AFTER DELETE ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',OLD.id_registro_medicacion,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'Medico','Personal médico'),(2,'Enfermero','Personal de enfermería'),(3,'Jefatura','Personal de jefatura'),(4,'Administracion','Personal administrativo'),(5,'Farmaceutico','Personal farmacéutico');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_medicamentos`
--

DROP TABLE IF EXISTS `stock_medicamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_medicamentos` (
  `id_stock` int unsigned NOT NULL AUTO_INCREMENT,
  `id_medicamento` int unsigned NOT NULL,
  `cantidad` int unsigned NOT NULL DEFAULT '0',
  `stock_minimo` int unsigned NOT NULL DEFAULT '0',
  `numero_lote` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  PRIMARY KEY (`id_stock`),
  UNIQUE KEY `uq_stock_medicamento_lote` (`id_medicamento`,`numero_lote`),
  KEY `idx_stock_vencimiento` (`fecha_vencimiento`),
  CONSTRAINT `fk_stock_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_medicamentos`
--

LOCK TABLES `stock_medicamentos` WRITE;
/*!40000 ALTER TABLE `stock_medicamentos` DISABLE KEYS */;
INSERT INTO `stock_medicamentos` VALUES (1,1,9,2,'LOTE-PRUEBA-TRIGGER-001','2027-12-31'),(2,1,5,1,'LOTE-VENCIDO-PRUEBA','2025-01-01'),(3,1,0,1,'LOTE-AGOTADO-PRUEBA','2027-12-31'),(4,2,5,1,'LOTE-MEDICAMENTO-2','2027-12-31');
/*!40000 ALTER TABLE `stock_medicamentos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_stock` AFTER INSERT ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',NEW.id_stock,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_stock` AFTER UPDATE ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',NEW.id_stock,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_stock` AFTER DELETE ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',OLD.id_stock,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `turno`
--

DROP TABLE IF EXISTS `turno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turno` (
  `id_turno` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Médico asignado',
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `estado` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `motivo` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_turno`),
  KEY `idx_turno_medico_fecha` (`id_empleado`,`fecha`,`hora`,`estado`),
  KEY `idx_turno_paciente_fecha` (`id_paciente`,`fecha`,`hora`,`estado`),
  CONSTRAINT `fk_turno_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`),
  CONSTRAINT `fk_turno_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turno`
--

LOCK TABLES `turno` WRITE;
/*!40000 ALTER TABLE `turno` DISABLE KEYS */;
INSERT INTO `turno` VALUES (12,18,3,'2026-11-21','14:00:00','PENDIENTE','Consulta de Cardiología');
/*!40000 ALTER TABLE `turno` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bi_turno_disponibilidad` BEFORE INSERT ON `turno` FOR EACH ROW BEGIN
 IF NEW.estado<>'CANCELADO' AND EXISTS(SELECT 1 FROM Turno t WHERE t.fecha=NEW.fecha AND t.estado<>'CANCELADO' AND t.hora < ADDTIME(NEW.hora,'00:30:00') AND ADDTIME(t.hora,'00:30:00') > NEW.hora AND (t.id_empleado=NEW.id_empleado OR t.id_paciente=NEW.id_paciente)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El medico o el paciente ya tiene un turno en ese horario'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_turno` AFTER INSERT ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',NEW.id_turno,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bu_turno_disponibilidad` BEFORE UPDATE ON `turno` FOR EACH ROW BEGIN
    IF NEW.estado <> 'CANCELADO'
       AND EXISTS (
           SELECT 1
           FROM Turno t
           WHERE t.fecha = NEW.fecha
             AND t.estado <> 'CANCELADO'
             AND t.id_turno <> NEW.id_turno
             AND t.hora < ADDTIME(NEW.hora, '00:30:00')
             AND ADDTIME(t.hora, '00:30:00') > NEW.hora
             AND (
                 t.id_empleado = NEW.id_empleado
                 OR t.id_paciente = NEW.id_paciente
             )
       )
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'El medico o el paciente ya tiene un turno en ese horario';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_turno` AFTER UPDATE ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',NEW.id_turno,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_turno` AFTER DELETE ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',OLD.id_turno,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` int unsigned DEFAULT NULL,
  `id_paciente` int unsigned DEFAULT NULL,
  `contrasena` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Hash generado por el backend, nunca texto plano',
  `estado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `id_empleado` (`id_empleado`),
  UNIQUE KEY `id_paciente` (`id_paciente`),
  CONSTRAINT `fk_usuario_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  CONSTRAINT `fk_usuario_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (13,NULL,18,'$2a$10$PmT0b1ZK.zYmN4Rx3K0nDOkV7qXAA5gph6dDIJbRqOfawY1oSsGeS','ACTIVO');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bi_usuario_relacion` BEFORE INSERT ON `usuario` FOR EACH ROW BEGIN
 IF (NEW.id_empleado IS NULL AND NEW.id_paciente IS NULL) OR (NEW.id_empleado IS NOT NULL AND NEW.id_paciente IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El usuario debe pertenecer a un empleado o a un paciente, no a ambos'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ai_aud_usuario` AFTER INSERT ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',NEW.id_usuario,'INSERT') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bu_usuario_relacion_update` BEFORE UPDATE ON `usuario` FOR EACH ROW BEGIN
 IF (NEW.id_empleado IS NULL AND NEW.id_paciente IS NULL) OR (NEW.id_empleado IS NOT NULL AND NEW.id_paciente IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El usuario debe pertenecer a un empleado o a un paciente, no a ambos'; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `au_aud_usuario` AFTER UPDATE ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',NEW.id_usuario,'UPDATE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ad_aud_usuario` AFTER DELETE ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',OLD.id_usuario,'DELETE') */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'sistema_clinico'
--

--
-- Dumping routines for database 'sistema_clinico'
--
/*!50003 DROP PROCEDURE IF EXISTS `AgregarPaciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AgregarPaciente`(
    IN p_id_obra_social INT UNSIGNED,
    IN p_dni VARCHAR(20),
    IN p_nombre VARCHAR(80),
    IN p_apellido VARCHAR(80),
    IN p_fecha_nacimiento DATE,
    IN p_sexo VARCHAR(20),
    IN p_telefono VARCHAR(30),
    IN p_email VARCHAR(150),
    IN p_direccion VARCHAR(200),
    IN p_nacionalidad VARCHAR(60),
    IN p_provincia VARCHAR(60)
)
BEGIN
    INSERT INTO paciente (
        id_obra_social, dni, nombre, apellido, fecha_nacimiento,
        sexo, telefono, email, direccion, nacionalidad, provincia
    )
    VALUES (
        p_id_obra_social, p_dni, p_nombre, p_apellido, p_fecha_nacimiento,
        p_sexo, p_telefono, p_email, p_direccion, p_nacionalidad, p_provincia
    );

    SELECT LAST_INSERT_ID() AS id_paciente;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BuscarCredencialesPaciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarCredencialesPaciente`(IN p_dni VARCHAR(20))
BEGIN
    SELECT u.id_paciente, u.contrasena, u.estado
    FROM usuario u
    INNER JOIN paciente p ON p.id_paciente = u.id_paciente
    WHERE p.dni = p_dni
      AND u.id_paciente IS NOT NULL
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BuscarHistoriaClinica` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarHistoriaClinica`(IN `p_id_paciente` INT UNSIGNED)
BEGIN
 SELECT hc.id_historia_clinica, hc.fecha, hc.hora, hc.tipo_registro, hc.diagnostico, hc.tratamiento, hc.observaciones,
        'INTERNACION' AS origen, i.id_internacion AS id_origen, i.id_paciente, hc.id_empleado
 FROM Historia_Clinica hc JOIN Internacion i ON i.id_internacion=hc.id_internacion WHERE i.id_paciente=p_id_paciente
 UNION ALL
 SELECT hc.id_historia_clinica, hc.fecha, hc.hora, hc.tipo_registro, hc.diagnostico, hc.tratamiento, hc.observaciones,
        'CONSULTA' AS origen, c.id_consulta AS id_origen, c.id_paciente, hc.id_empleado
 FROM Historia_Clinica hc JOIN Consulta c ON c.id_consulta=hc.id_consulta WHERE c.id_paciente=p_id_paciente
 ORDER BY fecha DESC, hora DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BuscarPaciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarPaciente`(IN `p_dni` VARCHAR(20))
BEGIN
 SELECT p.*, o.nombre AS obra_social FROM Paciente p LEFT JOIN Obra_Social o ON o.id_obra_social=p.id_obra_social WHERE p.dni=p_dni;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CrearTurno` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CrearTurno`(IN `p_id_paciente` INT, IN `p_id_medico` INT, IN `p_fecha` DATE, IN `p_hora` TIME, IN `p_motivo` VARCHAR(250))
BEGIN
    DECLARE v_existe INT DEFAULT 0;

    IF p_fecha IS NULL OR p_fecha < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La fecha del turno no puede ser anterior a hoy';
    END IF;

    IF p_hora IS NULL
       OR MINUTE(p_hora) NOT IN (0, 30)
       OR SECOND(p_hora) <> 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El turno debe comenzar en un intervalo de 30 minutos';
    END IF;

    SELECT COUNT(*)
    INTO v_existe
    FROM Paciente
    WHERE id_paciente = p_id_paciente;

    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El paciente no existe';
    END IF;

    SELECT COUNT(*)
    INTO v_existe
    FROM Medico
    WHERE id_empleado = p_id_medico;

    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El empleado no es un medico registrado';
    END IF;

    SELECT COUNT(*)
    INTO v_existe
    FROM Turno
    WHERE fecha = p_fecha
      AND estado IN ('PENDIENTE', 'CONFIRMADO')
      AND (
          id_empleado = p_id_medico
          OR id_paciente = p_id_paciente
      )
      AND p_hora < ADDTIME(hora, '00:30:00')
      AND hora < ADDTIME(p_hora, '00:30:00');

    IF v_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El medico o el paciente ya tiene un turno superpuesto';
    END IF;

    INSERT INTO Turno (
        id_paciente,
        id_empleado,
        fecha,
        hora,
        estado,
        motivo
    )
    VALUES (
        p_id_paciente,
        p_id_medico,
        p_fecha,
        p_hora,
        'PENDIENTE',
        p_motivo
    );

    SELECT LAST_INSERT_ID() AS id_turno;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EliminarCuentaPaciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarCuentaPaciente`(IN p_id_paciente INT UNSIGNED)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM paciente WHERE id_paciente = p_id_paciente
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se encontró la cuenta del paciente';
    END IF;

    UPDATE habitacion h
    JOIN internacion i ON i.id_habitacion = h.id_habitacion
    SET h.estado = 'DISPONIBLE'
    WHERE i.id_paciente = p_id_paciente
      AND i.estado = 'ACTIVA'
      AND h.estado = 'OCUPADA'
      AND NOT EXISTS (
          SELECT 1
          FROM internacion otra
          WHERE otra.id_habitacion = h.id_habitacion
            AND otra.estado = 'ACTIVA'
            AND otra.id_paciente <> p_id_paciente
      );

    DELETE FROM historia_clinica
    WHERE id_consulta IN (
        SELECT id_consulta FROM consulta WHERE id_paciente = p_id_paciente
    )
    OR id_internacion IN (
        SELECT id_internacion FROM internacion WHERE id_paciente = p_id_paciente
    );

    DELETE FROM receta
    WHERE id_paciente = p_id_paciente;

    DELETE FROM registro_medicacion
    WHERE id_internacion IN (
        SELECT id_internacion FROM internacion WHERE id_paciente = p_id_paciente
    );

    DELETE FROM consulta
    WHERE id_paciente = p_id_paciente;

    DELETE FROM internacion
    WHERE id_paciente = p_id_paciente;

    DELETE FROM turno
    WHERE id_paciente = p_id_paciente;

    DELETE FROM usuario
    WHERE id_paciente = p_id_paciente;

    DELETE FROM paciente
    WHERE id_paciente = p_id_paciente;

    SELECT 'OK' AS resultado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerPacientePorId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerPacientePorId`(IN p_id_paciente INT UNSIGNED)
BEGIN
    SELECT
        id_paciente, id_obra_social, dni, nombre, apellido,
        fecha_nacimiento, sexo, telefono, email, direccion,
        nacionalidad, provincia
    FROM paciente
    WHERE id_paciente = p_id_paciente;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerTurnosPaciente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerTurnosPaciente`(IN p_id_paciente INT UNSIGNED)
BEGIN
    SELECT
        t.fecha,
        t.hora,
        COALESCE(m.especialidad, 'Sin especialidad') AS especialidad,
        CONCAT(e.nombre, ' ', e.apellido) AS profesional,
        t.estado
    FROM turno t
    INNER JOIN empleado e ON e.id_empleado = t.id_empleado
    LEFT JOIN medico m ON m.id_empleado = e.id_empleado
    WHERE t.id_paciente = p_id_paciente
      AND t.estado IN ('PENDIENTE', 'CONFIRMADO')
      AND t.fecha >= CURDATE()
    ORDER BY t.fecha, t.hora;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-06 12:13:26
