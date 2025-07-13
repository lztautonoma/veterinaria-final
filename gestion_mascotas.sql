-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: gestion_mascotas
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
-- Table structure for table `adopcion`
--

DROP TABLE IF EXISTS `adopcion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adopcion` (
  `ID_Adopcion` int NOT NULL AUTO_INCREMENT,
  `Fecha` date DEFAULT NULL,
  `Estado` varchar(50) DEFAULT NULL,
  `Observaciones` text,
  `ID_Mascota` int NOT NULL,
  `ID_Dueno` int NOT NULL,
  PRIMARY KEY (`ID_Adopcion`),
  UNIQUE KEY `ID_Mascota` (`ID_Mascota`),
  KEY `ID_Dueno` (`ID_Dueno`),
  CONSTRAINT `adopcion_ibfk_1` FOREIGN KEY (`ID_Mascota`) REFERENCES `mascota` (`ID_Mascota`),
  CONSTRAINT `adopcion_ibfk_2` FOREIGN KEY (`ID_Dueno`) REFERENCES `dueno` (`ID_Dueno`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adopcion`
--

LOCK TABLES `adopcion` WRITE;
/*!40000 ALTER TABLE `adopcion` DISABLE KEYS */;
INSERT INTO `adopcion` VALUES (1,'2025-06-01','Aprobado','Proceso exitoso',2,2);
/*!40000 ALTER TABLE `adopcion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cita_medica`
--

DROP TABLE IF EXISTS `cita_medica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cita_medica` (
  `ID_Cita` int NOT NULL AUTO_INCREMENT,
  `Fecha` date NOT NULL,
  `Hora` time NOT NULL,
  `Motivo` text,
  `Diagnostico` text,
  `Tratamiento` text,
  `ID_Mascota` int NOT NULL,
  `ID_Veterinario` int NOT NULL,
  `Atendida` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID_Cita`),
  KEY `ID_Mascota` (`ID_Mascota`),
  KEY `ID_Veterinario` (`ID_Veterinario`),
  CONSTRAINT `cita_medica_ibfk_1` FOREIGN KEY (`ID_Mascota`) REFERENCES `mascota` (`ID_Mascota`),
  CONSTRAINT `cita_medica_ibfk_2` FOREIGN KEY (`ID_Veterinario`) REFERENCES `veterinario` (`ID_Veterinario`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cita_medica`
--

LOCK TABLES `cita_medica` WRITE;
/*!40000 ALTER TABLE `cita_medica` DISABLE KEYS */;
INSERT INTO `cita_medica` VALUES (1,'2025-07-01','10:00:00','Chequeo general','En buena salud','vever agua',1,1,1),(2,'2025-07-02','14:00:00','Vacuna anual','Sin novedades','Aplicación de vacuna',2,2,1);
/*!40000 ALTER TABLE `cita_medica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dueno`
--

DROP TABLE IF EXISTS `dueno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dueno` (
  `ID_Dueno` int NOT NULL AUTO_INCREMENT,
  `Nombres` varchar(100) NOT NULL,
  `Apellidos` varchar(100) NOT NULL,
  `DNI` varchar(15) NOT NULL,
  `Direccion` varchar(255) DEFAULT NULL,
  `Telefono` varchar(15) DEFAULT NULL,
  `Correo` varchar(100) DEFAULT NULL,
  `contrasena` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_Dueno`),
  UNIQUE KEY `DNI` (`DNI`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dueno`
--

LOCK TABLES `dueno` WRITE;
/*!40000 ALTER TABLE `dueno` DISABLE KEYS */;
INSERT INTO `dueno` VALUES (1,'Carlos','Ramírez','12345678','Av. Perú 123','987654321','carlos@mail.com',NULL),(2,'Ana','Torres','87654321','Calle Lima 456','912345678','ana@mail.com',NULL),(3,'Angel','Farfan','34567891','Av. Perú 123','999999999','farfan@mail.com',NULL),(4,'Pablo','Chirri','98754321','Calle Lima 456','912345678','pablo@mail.com',NULL),(5,'Brandy','Fernandez','13254687','Calle Lima 458','900223345','brandy@mail.com',NULL),(6,'andres','veliz','74563559','mzf1lt10','948171514','siento7v1@gmail.com','$2b$10$PvuinjaxAWzPsd/PTj77/O5h9A18sm776YBMY4.FSA4.CymXqKoFu'),(7,'angel','farfan','745635595','mzg1lt','902749317','xt6342@rimac.com.pe','$2b$10$BUjp2d58nIRT/kByLaJS4.E7S8yN.P5M3DxuFnzTa6T2d/UKsjkjK'),(8,'afwawf','awfsw','75581','mzf1lt','91751815','awffwf@rimac.com.pe','$2b$10$Tv9hyQevLQawQm9KkeqHkuIAmwivP57QUqRpKB7nrK8wCRgdSuXui'),(9,'angel','farfan','41968148919','mzmcmswm','6515616516','farfanangiz10@autonoma.edu.pe','$2b$10$3Oh5bP/s/5Ep7cBumk8b5.fO61F/kWaeie6kKu/ScGglBORstIAjG');
/*!40000 ALTER TABLE `dueno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mascota`
--

DROP TABLE IF EXISTS `mascota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mascota` (
  `ID_Mascota` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Especie` varchar(50) DEFAULT NULL,
  `Raza` varchar(50) DEFAULT NULL,
  `Edad` int DEFAULT NULL,
  `Sexo` varchar(10) DEFAULT NULL,
  `FechaNacimiento` date DEFAULT NULL,
  `EstadoSalud` varchar(100) DEFAULT NULL,
  `Foto` blob,
  `ID_Dueno` int NOT NULL,
  PRIMARY KEY (`ID_Mascota`),
  KEY `ID_Dueno` (`ID_Dueno`),
  CONSTRAINT `mascota_ibfk_1` FOREIGN KEY (`ID_Dueno`) REFERENCES `dueno` (`ID_Dueno`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mascota`
--

LOCK TABLES `mascota` WRITE;
/*!40000 ALTER TABLE `mascota` DISABLE KEYS */;
INSERT INTO `mascota` VALUES (1,'Firulais','Perro','Labrador',5,'Macho','2019-03-15','Saludable',NULL,1),(2,'Mishita','Gato','Siames',3,'Hembra','2021-01-20','Alergia leve',NULL,2),(3,'Pepe','Loro','Pico Rojo',3,'Macho','2025-03-10','Saludable',NULL,3),(4,'Lia','Conejo','Minilop',5,'Hembra','2021-01-20','Alergia leve',NULL,4),(5,'Terry','Perro','Pitbull',3,'Macho','2021-01-21','Saludable',NULL,5),(6,'pepe','perro','chusco',2,'Macho','2025-06-11','good',NULL,7),(7,'caspa del diablo','gato','mixta',2,'Hembra','2023-11-10','embarazada',NULL,7),(8,'CASPA DEL DIABLO','gato','mixta',2,'Hembra','2025-07-22','mrd',NULL,7),(9,'caspa del diablo','gato','mixto',7,'Hembra','2025-08-05','good',NULL,9);
/*!40000 ALTER TABLE `mascota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vacuna`
--

DROP TABLE IF EXISTS `vacuna`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vacuna` (
  `ID_Vacuna` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Descripcion` text,
  `FechaAplicacion` date DEFAULT NULL,
  `ProximaDosis` date DEFAULT NULL,
  `ID_Mascota` int NOT NULL,
  PRIMARY KEY (`ID_Vacuna`),
  KEY `ID_Mascota` (`ID_Mascota`),
  CONSTRAINT `vacuna_ibfk_1` FOREIGN KEY (`ID_Mascota`) REFERENCES `mascota` (`ID_Mascota`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vacuna`
--

LOCK TABLES `vacuna` WRITE;
/*!40000 ALTER TABLE `vacuna` DISABLE KEYS */;
INSERT INTO `vacuna` VALUES (1,'Rabia','Vacuna contra la rabia','2025-06-15','2026-06-15',1),(2,'Triple felina','Protección para gatos','2025-06-20','2026-06-20',2);
/*!40000 ALTER TABLE `vacuna` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `veterinario`
--

DROP TABLE IF EXISTS `veterinario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `veterinario` (
  `ID_Veterinario` int NOT NULL AUTO_INCREMENT,
  `Nombres` varchar(100) NOT NULL,
  `Apellidos` varchar(100) NOT NULL,
  `DNI` varchar(20) NOT NULL,
  `CMP` varchar(20) NOT NULL,
  `Especialidad` varchar(100) DEFAULT NULL,
  `Telefono` varchar(15) DEFAULT NULL,
  `Correo` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_Veterinario`),
  UNIQUE KEY `CMP` (`CMP`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `veterinario`
--

LOCK TABLES `veterinario` WRITE;
/*!40000 ALTER TABLE `veterinario` DISABLE KEYS */;
INSERT INTO `veterinario` VALUES (1,'Lucía','González','789456123','CMP1234','Medicina General','998877665','lucia@mail.com'),(2,'Pedro','Mejía','159753456','CMP5678','Vacunación','987112233','pedro@mail.com');
/*!40000 ALTER TABLE `veterinario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'gestion_mascotas'
--

--
-- Dumping routines for database 'gestion_mascotas'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-10  8:52:29
