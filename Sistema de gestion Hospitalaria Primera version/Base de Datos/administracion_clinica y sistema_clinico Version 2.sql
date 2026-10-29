-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-10-2026 a las 01:12:23
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `administracion_clinica`
--
DROP DATABASE IF EXISTS `administracion_clinica`;
CREATE DATABASE IF NOT EXISTS `administracion_clinica` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `administracion_clinica`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `ActualizarEstadoFactura`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarEstadoFactura` (IN `p_id_factura` INT UNSIGNED)   BEGIN
 DECLARE v_total DECIMAL(12,2);
 DECLARE v_pagado DECIMAL(12,2);
 SELECT importe_total INTO v_total FROM Factura WHERE id_factura=p_id_factura;
 IF v_total IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La factura no existe'; END IF;
 SELECT COALESCE((SELECT SUM(monto) FROM Pago_Obra_Social WHERE id_factura=p_id_factura AND estado='REGISTRADO'),0)+
        COALESCE((SELECT SUM(monto) FROM Pago_Paciente WHERE id_factura=p_id_factura AND estado='REGISTRADO'),0) INTO v_pagado;
 UPDATE Factura SET estado=CASE WHEN v_pagado<=0 THEN 'PENDIENTE' WHEN v_pagado<v_total THEN 'PARCIAL' ELSE 'PAGADA' END WHERE id_factura=p_id_factura;
END$$

DROP PROCEDURE IF EXISTS `AnularRecibo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AnularRecibo` (IN `p_id_recibo` INT UNSIGNED, IN `p_motivo` VARCHAR(500))   BEGIN
 DECLARE v_estado VARCHAR(20) DEFAULT NULL;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 IF p_motivo IS NULL OR TRIM(p_motivo)='' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Debe indicar el motivo de anulacion'; END IF;
 START TRANSACTION;
 SELECT estado INTO v_estado FROM Recibo_Sueldo WHERE id_recibo=p_id_recibo FOR UPDATE;
 IF v_estado IS NULL OR v_estado<>'PENDIENTE' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Solo se pueden anular recibos pendientes'; END IF;
 INSERT INTO Anulacion_Recibo(id_recibo,motivo) VALUES(p_id_recibo,TRIM(p_motivo));
 UPDATE Recibo_Sueldo SET estado='ANULADO',fecha_anulacion=CURRENT_TIMESTAMP WHERE id_recibo=p_id_recibo;
 COMMIT;
END$$

DROP PROCEDURE IF EXISTS `CrearFactura`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CrearFactura` (IN `p_id_paciente` INT UNSIGNED, IN `p_id_obra_social` INT UNSIGNED, IN `p_importe_total` DECIMAL(12,2), IN `p_porcentaje_cobertura` DECIMAL(5,2))   BEGIN
 DECLARE v_obra_paciente INT UNSIGNED;
 DECLARE v_cubierto DECIMAL(12,2) DEFAULT 0;
 DECLARE v_paciente DECIMAL(12,2);
 IF p_importe_total<0 OR p_porcentaje_cobertura<0 OR p_porcentaje_cobertura>100 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Importe o porcentaje de cobertura invalido'; END IF;
 SELECT id_obra_social INTO v_obra_paciente FROM sistema_clinico.Paciente WHERE id_paciente=p_id_paciente;
 IF v_obra_paciente IS NULL AND NOT EXISTS(SELECT 1 FROM sistema_clinico.Paciente WHERE id_paciente=p_id_paciente) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El paciente no existe'; END IF;
 IF p_id_obra_social IS NULL THEN SET p_porcentaje_cobertura=0;
 ELSE
  IF v_obra_paciente IS NULL OR v_obra_paciente<>p_id_obra_social THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La obra social no coincide con la cobertura registrada del paciente'; END IF;
  IF NOT EXISTS(SELECT 1 FROM sistema_clinico.Obra_Social WHERE id_obra_social=p_id_obra_social AND estado='ACTIVA') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La obra social no existe o esta inactiva'; END IF;
 END IF;
 SET v_cubierto=ROUND(p_importe_total*p_porcentaje_cobertura/100,2);
 SET v_paciente=p_importe_total-v_cubierto;
 INSERT INTO Factura(id_paciente,id_obra_social,importe_total,porcentaje_cobertura,importe_cubierto,importe_paciente,estado)
 VALUES(p_id_paciente,p_id_obra_social,p_importe_total,p_porcentaje_cobertura,v_cubierto,v_paciente,'PENDIENTE');
 SELECT LAST_INSERT_ID() AS id_factura;
END$$

DROP PROCEDURE IF EXISTS `GenerarRecibo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerarRecibo` (IN `p_id_empleado` INT UNSIGNED, IN `p_anio` SMALLINT UNSIGNED, IN `p_mes` TINYINT UNSIGNED, IN `p_ids_bonos` TEXT, IN `p_ids_descuentos` TEXT)   proc: BEGIN
 DECLARE v_id_sueldo INT UNSIGNED;
 DECLARE v_sueldo DECIMAL(12,2);
 DECLARE v_estado_empleado VARCHAR(20);
 DECLARE v_id_recibo INT UNSIGNED;
 DECLARE v_bonos DECIMAL(12,2) DEFAULT 0;
 DECLARE v_descuentos DECIMAL(12,2) DEFAULT 0;
 DECLARE v_dia_fin DATE;
 DECLARE v_lista TEXT;
 DECLARE v_id INT UNSIGNED;
 DECLARE v_monto DECIMAL(12,2);
 DECLARE v_coma INT;
 DECLARE v_total_bruto DECIMAL(12,2);
 DECLARE v_total_neto DECIMAL(12,2);
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 IF p_mes<1 OR p_mes>12 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mes invalido'; END IF;
 SET v_dia_fin=LAST_DAY(STR_TO_DATE(CONCAT(p_anio,'-',LPAD(p_mes,2,'0'),'-01'),'%Y-%m-%d'));
 START TRANSACTION;
 SELECT estado INTO v_estado_empleado FROM sistema_clinico.Empleado WHERE id_empleado=p_id_empleado FOR UPDATE;
 IF v_estado_empleado IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El empleado no existe'; END IF;
 IF v_estado_empleado<>'ACTIVO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Solo se pueden generar recibos para empleados activos'; END IF;
 IF EXISTS(SELECT 1 FROM Recibo_Sueldo WHERE id_empleado=p_id_empleado AND periodo_anio=p_anio AND periodo_mes=p_mes AND estado<>'ANULADO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ya existe un recibo vigente para ese empleado y periodo'; END IF;
 SELECT id_sueldo,sueldo_base INTO v_id_sueldo,v_sueldo FROM Sueldo WHERE id_empleado=p_id_empleado AND fecha_vigencia<=v_dia_fin AND estado='ACTIVO' ORDER BY fecha_vigencia DESC,id_sueldo DESC LIMIT 1;
 IF v_id_sueldo IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El empleado no tiene sueldo registrado vigente para ese periodo'; END IF;
 SET v_total_bruto=v_sueldo;
 SET v_lista=TRIM(COALESCE(p_ids_bonos,''));
 WHILE v_lista<>'' DO
  SET v_coma=LOCATE(',',v_lista);
  IF v_coma=0 THEN SET v_id=CAST(v_lista AS UNSIGNED); SET v_lista=''; ELSE SET v_id=CAST(LEFT(v_lista,v_coma-1) AS UNSIGNED); SET v_lista=SUBSTRING(v_lista,v_coma+1); END IF;
  IF v_id=0 OR NOT EXISTS(SELECT 1 FROM Bono WHERE id_bono=v_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Uno de los bonos indicados no existe'; END IF;
  SELECT monto INTO v_monto FROM Bono WHERE id_bono=v_id;
  SET v_bonos=v_bonos+v_monto;
 END WHILE;
 SET v_lista=TRIM(COALESCE(p_ids_descuentos,''));
 WHILE v_lista<>'' DO
  SET v_coma=LOCATE(',',v_lista);
  IF v_coma=0 THEN SET v_id=CAST(v_lista AS UNSIGNED); SET v_lista=''; ELSE SET v_id=CAST(LEFT(v_lista,v_coma-1) AS UNSIGNED); SET v_lista=SUBSTRING(v_lista,v_coma+1); END IF;
  IF v_id=0 OR NOT EXISTS(SELECT 1 FROM Descuento WHERE id_descuento=v_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Uno de los descuentos indicados no existe'; END IF;
  SELECT monto INTO v_monto FROM Descuento WHERE id_descuento=v_id;
  SET v_descuentos=v_descuentos+v_monto;
 END WHILE;
 SET v_total_neto=v_total_bruto+v_bonos-v_descuentos;
 IF v_total_neto<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Los descuentos no pueden superar el total bruto mas los bonos'; END IF;
 INSERT INTO Recibo_Sueldo(id_sueldo,id_empleado,periodo_anio,periodo_mes,total_bruto,total_descuentos,total_bonos,total_neto)
 VALUES(v_id_sueldo,p_id_empleado,p_anio,p_mes,v_total_bruto,v_descuentos,v_bonos,v_total_neto);
 SET v_id_recibo=LAST_INSERT_ID();
 SET v_lista=TRIM(COALESCE(p_ids_bonos,''));
 WHILE v_lista<>'' DO
  SET v_coma=LOCATE(',',v_lista);
  IF v_coma=0 THEN SET v_id=CAST(v_lista AS UNSIGNED); SET v_lista=''; ELSE SET v_id=CAST(LEFT(v_lista,v_coma-1) AS UNSIGNED); SET v_lista=SUBSTRING(v_lista,v_coma+1); END IF;
  SELECT monto INTO v_monto FROM Bono WHERE id_bono=v_id;
  INSERT INTO Detalle_Bono(id_recibo,id_bono,importe) VALUES(v_id_recibo,v_id,v_monto);
 END WHILE;
 SET v_lista=TRIM(COALESCE(p_ids_descuentos,''));
 WHILE v_lista<>'' DO
  SET v_coma=LOCATE(',',v_lista);
  IF v_coma=0 THEN SET v_id=CAST(v_lista AS UNSIGNED); SET v_lista=''; ELSE SET v_id=CAST(LEFT(v_lista,v_coma-1) AS UNSIGNED); SET v_lista=SUBSTRING(v_lista,v_coma+1); END IF;
  SELECT monto INTO v_monto FROM Descuento WHERE id_descuento=v_id;
  INSERT INTO Detalle_Descuento(id_recibo,id_descuento,importe) VALUES(v_id_recibo,v_id,v_monto);
 END WHILE;
 COMMIT;
 SELECT * FROM Recibo_Sueldo WHERE id_recibo=v_id_recibo;
END$$

DROP PROCEDURE IF EXISTS `RegistrarPagoObraSocial`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarPagoObraSocial` (IN `p_id_factura` INT UNSIGNED, IN `p_monto` DECIMAL(12,2))   BEGIN
 IF p_monto<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El pago debe ser mayor que cero'; END IF;
 IF NOT EXISTS(SELECT 1 FROM Factura WHERE id_factura=p_id_factura AND id_obra_social IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La factura no tiene obra social asociada'; END IF;
 INSERT INTO Pago_Obra_Social(id_factura,monto) VALUES(p_id_factura,p_monto);
END$$

DROP PROCEDURE IF EXISTS `RegistrarPagoPaciente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarPagoPaciente` (IN `p_id_factura` INT UNSIGNED, IN `p_monto` DECIMAL(12,2))   BEGIN
 IF p_monto<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El pago debe ser mayor que cero'; END IF;
 IF NOT EXISTS(SELECT 1 FROM Factura WHERE id_factura=p_id_factura) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La factura no existe'; END IF;
 INSERT INTO Pago_Paciente(id_factura,monto) VALUES(p_id_factura,p_monto);
END$$

DROP PROCEDURE IF EXISTS `RegistrarPagoSueldo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarPagoSueldo` (IN `p_id_recibo` INT UNSIGNED, IN `p_banco_destino` VARCHAR(120))   BEGIN
 DECLARE v_estado VARCHAR(20) DEFAULT NULL;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 SELECT estado INTO v_estado FROM Recibo_Sueldo WHERE id_recibo=p_id_recibo FOR UPDATE;
 IF v_estado IS NULL OR v_estado<>'PENDIENTE' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Solo se pueden pagar recibos pendientes'; END IF;
 UPDATE Recibo_Sueldo SET estado='PAGADO',fecha_pago=CURRENT_TIMESTAMP,banco_destino=p_banco_destino WHERE id_recibo=p_id_recibo;
 COMMIT;
END$$

DROP PROCEDURE IF EXISTS `RegistrarSueldo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarSueldo` (IN `p_id_empleado` INT UNSIGNED, IN `p_sueldo_base` DECIMAL(12,2), IN `p_fecha_vigencia` DATE, IN `p_estado` VARCHAR(20))   BEGIN
 IF NOT EXISTS(SELECT 1 FROM sistema_clinico.Empleado WHERE id_empleado=p_id_empleado) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El empleado no existe en sistema_clinico'; END IF;
 IF p_sueldo_base<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El sueldo base no puede ser negativo'; END IF;
 INSERT INTO Sueldo(id_empleado,sueldo_base,fecha_vigencia,estado) VALUES(p_id_empleado,p_sueldo_base,p_fecha_vigencia,COALESCE(NULLIF(p_estado,''),'ACTIVO'));
 SELECT LAST_INSERT_ID() AS id_sueldo;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `anulacion_recibo`
--

DROP TABLE IF EXISTS `anulacion_recibo`;
CREATE TABLE `anulacion_recibo` (
  `id_anulacion` int(10) UNSIGNED NOT NULL,
  `id_recibo` int(10) UNSIGNED NOT NULL,
  `fecha_anulacion` datetime NOT NULL DEFAULT current_timestamp(),
  `motivo` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `anulacion_recibo`
--
DROP TRIGGER IF EXISTS `ai_aud_anulacion`;
DELIMITER $$
CREATE TRIGGER `ai_aud_anulacion` AFTER INSERT ON `anulacion_recibo` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Anulacion_Recibo',NEW.id_anulacion,'INSERT')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_bd`
--

DROP TABLE IF EXISTS `auditoria_bd`;
CREATE TABLE `auditoria_bd` (
  `id_auditoria` bigint(20) UNSIGNED NOT NULL,
  `tabla_afectada` varchar(100) NOT NULL,
  `id_registro` varchar(100) NOT NULL,
  `operacion` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bono`
--

DROP TABLE IF EXISTS `bono`;
CREATE TABLE `bono` (
  `id_bono` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `monto` decimal(12,2) NOT NULL
) ;

--
-- Disparadores `bono`
--
DROP TRIGGER IF EXISTS `ad_aud_bono`;
DELIMITER $$
CREATE TRIGGER `ad_aud_bono` AFTER DELETE ON `bono` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Bono',OLD.id_bono,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_bono`;
DELIMITER $$
CREATE TRIGGER `ai_aud_bono` AFTER INSERT ON `bono` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Bono',NEW.id_bono,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_bono`;
DELIMITER $$
CREATE TRIGGER `au_aud_bono` AFTER UPDATE ON `bono` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Bono',NEW.id_bono,'UPDATE')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuento`
--

DROP TABLE IF EXISTS `descuento`;
CREATE TABLE `descuento` (
  `id_descuento` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `monto` decimal(12,2) NOT NULL
) ;

--
-- Disparadores `descuento`
--
DROP TRIGGER IF EXISTS `ad_aud_descuento`;
DELIMITER $$
CREATE TRIGGER `ad_aud_descuento` AFTER DELETE ON `descuento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Descuento',OLD.id_descuento,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_descuento`;
DELIMITER $$
CREATE TRIGGER `ai_aud_descuento` AFTER INSERT ON `descuento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Descuento',NEW.id_descuento,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_descuento`;
DELIMITER $$
CREATE TRIGGER `au_aud_descuento` AFTER UPDATE ON `descuento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Descuento',NEW.id_descuento,'UPDATE')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_bono`
--

DROP TABLE IF EXISTS `detalle_bono`;
CREATE TABLE `detalle_bono` (
  `id_detalle_bono` int(10) UNSIGNED NOT NULL,
  `id_recibo` int(10) UNSIGNED NOT NULL,
  `id_bono` int(10) UNSIGNED NOT NULL,
  `importe` decimal(12,2) NOT NULL
) ;

--
-- Disparadores `detalle_bono`
--
DROP TRIGGER IF EXISTS `bd_detalle_bono_inmutable`;
DELIMITER $$
CREATE TRIGGER `bd_detalle_bono_inmutable` BEFORE DELETE ON `detalle_bono` FOR EACH ROW BEGIN
 IF (SELECT estado FROM Recibo_Sueldo WHERE id_recibo=OLD.id_recibo)<>'PENDIENTE' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se pueden eliminar detalles de un recibo pagado o anulado'; END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_detalle_bono_inmutable`;
DELIMITER $$
CREATE TRIGGER `bu_detalle_bono_inmutable` BEFORE UPDATE ON `detalle_bono` FOR EACH ROW BEGIN
 IF (SELECT estado FROM Recibo_Sueldo WHERE id_recibo=OLD.id_recibo)<>'PENDIENTE' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se pueden modificar detalles de un recibo pagado o anulado'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_descuento`
--

DROP TABLE IF EXISTS `detalle_descuento`;
CREATE TABLE `detalle_descuento` (
  `id_detalle_descuento` int(10) UNSIGNED NOT NULL,
  `id_recibo` int(10) UNSIGNED NOT NULL,
  `id_descuento` int(10) UNSIGNED NOT NULL,
  `importe` decimal(12,2) NOT NULL
) ;

--
-- Disparadores `detalle_descuento`
--
DROP TRIGGER IF EXISTS `bd_detalle_descuento_inmutable`;
DELIMITER $$
CREATE TRIGGER `bd_detalle_descuento_inmutable` BEFORE DELETE ON `detalle_descuento` FOR EACH ROW BEGIN
 IF (SELECT estado FROM Recibo_Sueldo WHERE id_recibo=OLD.id_recibo)<>'PENDIENTE' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se pueden eliminar detalles de un recibo pagado o anulado'; END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_detalle_descuento_inmutable`;
DELIMITER $$
CREATE TRIGGER `bu_detalle_descuento_inmutable` BEFORE UPDATE ON `detalle_descuento` FOR EACH ROW BEGIN
 IF (SELECT estado FROM Recibo_Sueldo WHERE id_recibo=OLD.id_recibo)<>'PENDIENTE' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se pueden modificar detalles de un recibo pagado o anulado'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

DROP TABLE IF EXISTS `factura`;
CREATE TABLE `factura` (
  `id_factura` int(10) UNSIGNED NOT NULL,
  `id_paciente` int(10) UNSIGNED NOT NULL COMMENT 'Referencia logica a sistema_clinico.Paciente',
  `id_obra_social` int(10) UNSIGNED DEFAULT NULL COMMENT 'Referencia logica a sistema_clinico.Obra_Social; NULL para particular',
  `fecha_emision` datetime NOT NULL DEFAULT current_timestamp(),
  `importe_total` decimal(12,2) NOT NULL,
  `porcentaje_cobertura` decimal(5,2) NOT NULL DEFAULT 0.00,
  `importe_cubierto` decimal(12,2) NOT NULL DEFAULT 0.00,
  `importe_paciente` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PARCIAL','PAGADA') NOT NULL DEFAULT 'PENDIENTE'
) ;

--
-- Disparadores `factura`
--
DROP TRIGGER IF EXISTS `ai_aud_factura`;
DELIMITER $$
CREATE TRIGGER `ai_aud_factura` AFTER INSERT ON `factura` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Factura',NEW.id_factura,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_factura`;
DELIMITER $$
CREATE TRIGGER `au_aud_factura` AFTER UPDATE ON `factura` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Factura',NEW.id_factura,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_factura_inmutable`;
DELIMITER $$
CREATE TRIGGER `bu_factura_inmutable` BEFORE UPDATE ON `factura` FOR EACH ROW BEGIN
 IF NEW.id_paciente<>OLD.id_paciente OR NOT (NEW.id_obra_social <=> OLD.id_obra_social) OR NEW.importe_total<>OLD.importe_total OR NEW.porcentaje_cobertura<>OLD.porcentaje_cobertura OR NEW.importe_cubierto<>OLD.importe_cubierto OR NEW.importe_paciente<>OLD.importe_paciente OR NEW.fecha_emision<>OLD.fecha_emision THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se pueden modificar los importes ni los datos principales de una factura emitida';
 END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `informacion_bancaria`
--

DROP TABLE IF EXISTS `informacion_bancaria`;
CREATE TABLE `informacion_bancaria` (
  `id_informacion_bancaria` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED NOT NULL COMMENT 'Referencia logica a sistema_clinico.Empleado',
  `banco` varchar(120) NOT NULL,
  `tipo_cuenta` enum('CAJA_AHORRO','CUENTA_CORRIENTE','OTRA') NOT NULL DEFAULT 'CAJA_AHORRO',
  `numero_cuenta` varchar(60) DEFAULT NULL,
  `cbu` varchar(30) DEFAULT NULL,
  `alias` varchar(60) DEFAULT NULL,
  `titular_cuenta` varchar(160) NOT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `informacion_bancaria`
--
DROP TRIGGER IF EXISTS `ad_aud_info_bancaria`;
DELIMITER $$
CREATE TRIGGER `ad_aud_info_bancaria` AFTER DELETE ON `informacion_bancaria` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Informacion_Bancaria',OLD.id_informacion_bancaria,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_info_bancaria`;
DELIMITER $$
CREATE TRIGGER `ai_aud_info_bancaria` AFTER INSERT ON `informacion_bancaria` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Informacion_Bancaria',NEW.id_informacion_bancaria,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_info_bancaria`;
DELIMITER $$
CREATE TRIGGER `au_aud_info_bancaria` AFTER UPDATE ON `informacion_bancaria` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Informacion_Bancaria',NEW.id_informacion_bancaria,'UPDATE')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago_obra_social`
--

DROP TABLE IF EXISTS `pago_obra_social`;
CREATE TABLE `pago_obra_social` (
  `id_pago` int(10) UNSIGNED NOT NULL,
  `id_factura` int(10) UNSIGNED NOT NULL,
  `fecha_pago` datetime NOT NULL DEFAULT current_timestamp(),
  `monto` decimal(12,2) NOT NULL,
  `estado` enum('REGISTRADO','ANULADO') NOT NULL DEFAULT 'REGISTRADO'
) ;

--
-- Disparadores `pago_obra_social`
--
DROP TRIGGER IF EXISTS `ad_aud_pago_obra`;
DELIMITER $$
CREATE TRIGGER `ad_aud_pago_obra` AFTER DELETE ON `pago_obra_social` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Pago_Obra_Social',OLD.id_pago,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_pago_obra`;
DELIMITER $$
CREATE TRIGGER `ai_aud_pago_obra` AFTER INSERT ON `pago_obra_social` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Pago_Obra_Social',NEW.id_pago,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_pago_obra_update`;
DELIMITER $$
CREATE TRIGGER `ai_aud_pago_obra_update` AFTER UPDATE ON `pago_obra_social` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Pago_Obra_Social',NEW.id_pago,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_pago_obra_estado`;
DELIMITER $$
CREATE TRIGGER `ai_pago_obra_estado` AFTER INSERT ON `pago_obra_social` FOR EACH ROW CALL ActualizarEstadoFactura(NEW.id_factura)
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_pago_obra_estado`;
DELIMITER $$
CREATE TRIGGER `au_pago_obra_estado` AFTER UPDATE ON `pago_obra_social` FOR EACH ROW CALL ActualizarEstadoFactura(NEW.id_factura)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago_paciente`
--

DROP TABLE IF EXISTS `pago_paciente`;
CREATE TABLE `pago_paciente` (
  `id_pago_paciente` int(10) UNSIGNED NOT NULL,
  `id_factura` int(10) UNSIGNED NOT NULL,
  `fecha_pago` datetime NOT NULL DEFAULT current_timestamp(),
  `monto` decimal(12,2) NOT NULL,
  `estado` enum('REGISTRADO','ANULADO') NOT NULL DEFAULT 'REGISTRADO'
) ;

--
-- Disparadores `pago_paciente`
--
DROP TRIGGER IF EXISTS `ad_aud_pago_paciente`;
DELIMITER $$
CREATE TRIGGER `ad_aud_pago_paciente` AFTER DELETE ON `pago_paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Pago_Paciente',OLD.id_pago_paciente,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_pago_paciente`;
DELIMITER $$
CREATE TRIGGER `ai_aud_pago_paciente` AFTER INSERT ON `pago_paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Pago_Paciente',NEW.id_pago_paciente,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_pago_paciente_estado`;
DELIMITER $$
CREATE TRIGGER `ai_pago_paciente_estado` AFTER INSERT ON `pago_paciente` FOR EACH ROW CALL ActualizarEstadoFactura(NEW.id_factura)
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_pago_paciente`;
DELIMITER $$
CREATE TRIGGER `au_aud_pago_paciente` AFTER UPDATE ON `pago_paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Pago_Paciente',NEW.id_pago_paciente,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_pago_paciente_estado`;
DELIMITER $$
CREATE TRIGGER `au_pago_paciente_estado` AFTER UPDATE ON `pago_paciente` FOR EACH ROW CALL ActualizarEstadoFactura(NEW.id_factura)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recibo_sueldo`
--

DROP TABLE IF EXISTS `recibo_sueldo`;
CREATE TABLE `recibo_sueldo` (
  `id_recibo` int(10) UNSIGNED NOT NULL,
  `id_sueldo` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED NOT NULL COMMENT 'Referencia logica a sistema_clinico.Empleado',
  `periodo_anio` smallint(5) UNSIGNED NOT NULL,
  `periodo_mes` tinyint(3) UNSIGNED NOT NULL,
  `fecha_emision` datetime NOT NULL DEFAULT current_timestamp(),
  `total_bruto` decimal(12,2) NOT NULL,
  `total_descuentos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_bonos` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_neto` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PAGADO','ANULADO') NOT NULL DEFAULT 'PENDIENTE',
  `fecha_pago` datetime DEFAULT NULL,
  `banco_destino` varchar(120) DEFAULT NULL,
  `fecha_anulacion` datetime DEFAULT NULL
) ;

--
-- Disparadores `recibo_sueldo`
--
DROP TRIGGER IF EXISTS `ai_aud_recibo`;
DELIMITER $$
CREATE TRIGGER `ai_aud_recibo` AFTER INSERT ON `recibo_sueldo` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Recibo_Sueldo',NEW.id_recibo,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_recibo`;
DELIMITER $$
CREATE TRIGGER `au_aud_recibo` AFTER UPDATE ON `recibo_sueldo` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Recibo_Sueldo',NEW.id_recibo,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_recibo_inmutable`;
DELIMITER $$
CREATE TRIGGER `bu_recibo_inmutable` BEFORE UPDATE ON `recibo_sueldo` FOR EACH ROW BEGIN
 IF NEW.id_sueldo<>OLD.id_sueldo OR NEW.id_empleado<>OLD.id_empleado OR NEW.periodo_anio<>OLD.periodo_anio OR NEW.periodo_mes<>OLD.periodo_mes OR NEW.total_bruto<>OLD.total_bruto OR NEW.total_descuentos<>OLD.total_descuentos OR NEW.total_bonos<>OLD.total_bonos OR NEW.total_neto<>OLD.total_neto THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se pueden modificar los importes de un recibo emitido';
 END IF;
 IF OLD.estado='ANULADO' AND NEW.estado<>'ANULADO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Un recibo anulado no puede reactivarse'; END IF;
 IF OLD.estado='PAGADO' AND NEW.estado<>'PAGADO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Un recibo pagado no puede cambiar de estado'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registros_sueldo`
--

DROP TABLE IF EXISTS `registros_sueldo`;
CREATE TABLE `registros_sueldo` (
  `id_registro` bigint(20) UNSIGNED NOT NULL,
  `id_sueldo` int(10) UNSIGNED NOT NULL,
  `sueldo_base_anterior` decimal(12,2) NOT NULL,
  `fecha_vigencia_anterior` date NOT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sueldo`
--

DROP TABLE IF EXISTS `sueldo`;
CREATE TABLE `sueldo` (
  `id_sueldo` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED NOT NULL COMMENT 'Referencia logica a sistema_clinico.Empleado',
  `sueldo_base` decimal(12,2) NOT NULL,
  `fecha_vigencia` date NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ;

--
-- Disparadores `sueldo`
--
DROP TRIGGER IF EXISTS `ad_aud_sueldo`;
DELIMITER $$
CREATE TRIGGER `ad_aud_sueldo` AFTER DELETE ON `sueldo` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Sueldo',OLD.id_sueldo,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_sueldo`;
DELIMITER $$
CREATE TRIGGER `ai_aud_sueldo` AFTER INSERT ON `sueldo` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Sueldo',NEW.id_sueldo,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_sueldo`;
DELIMITER $$
CREATE TRIGGER `au_aud_sueldo` AFTER UPDATE ON `sueldo` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Sueldo',NEW.id_sueldo,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_sueldo_historial`;
DELIMITER $$
CREATE TRIGGER `bu_sueldo_historial` BEFORE UPDATE ON `sueldo` FOR EACH ROW BEGIN
 IF NEW.sueldo_base <> OLD.sueldo_base OR NEW.fecha_vigencia <> OLD.fecha_vigencia THEN
  INSERT INTO Registros_Sueldo(id_sueldo,sueldo_base_anterior,fecha_vigencia_anterior) VALUES(OLD.id_sueldo,OLD.sueldo_base,OLD.fecha_vigencia);
 END IF;
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `anulacion_recibo`
--
ALTER TABLE `anulacion_recibo`
  ADD PRIMARY KEY (`id_anulacion`),
  ADD UNIQUE KEY `id_recibo` (`id_recibo`);

--
-- Indices de la tabla `auditoria_bd`
--
ALTER TABLE `auditoria_bd`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `idx_auditoria_tabla_fecha` (`tabla_afectada`,`fecha_hora`);

--
-- Indices de la tabla `bono`
--
ALTER TABLE `bono`
  ADD PRIMARY KEY (`id_bono`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `descuento`
--
ALTER TABLE `descuento`
  ADD PRIMARY KEY (`id_descuento`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `detalle_bono`
--
ALTER TABLE `detalle_bono`
  ADD PRIMARY KEY (`id_detalle_bono`),
  ADD UNIQUE KEY `uq_detalle_bono_recibo` (`id_recibo`,`id_bono`),
  ADD KEY `fk_detalle_bono_bono` (`id_bono`);

--
-- Indices de la tabla `detalle_descuento`
--
ALTER TABLE `detalle_descuento`
  ADD PRIMARY KEY (`id_detalle_descuento`),
  ADD UNIQUE KEY `uq_detalle_descuento_recibo` (`id_recibo`,`id_descuento`),
  ADD KEY `fk_detalle_descuento_descuento` (`id_descuento`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`id_factura`),
  ADD KEY `idx_factura_paciente` (`id_paciente`,`fecha_emision`),
  ADD KEY `idx_factura_estado` (`estado`);

--
-- Indices de la tabla `informacion_bancaria`
--
ALTER TABLE `informacion_bancaria`
  ADD PRIMARY KEY (`id_informacion_bancaria`),
  ADD UNIQUE KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `pago_obra_social`
--
ALTER TABLE `pago_obra_social`
  ADD PRIMARY KEY (`id_pago`),
  ADD KEY `idx_pago_obra_factura` (`id_factura`,`estado`);

--
-- Indices de la tabla `pago_paciente`
--
ALTER TABLE `pago_paciente`
  ADD PRIMARY KEY (`id_pago_paciente`),
  ADD KEY `idx_pago_paciente_factura` (`id_factura`,`estado`);

--
-- Indices de la tabla `recibo_sueldo`
--
ALTER TABLE `recibo_sueldo`
  ADD PRIMARY KEY (`id_recibo`),
  ADD KEY `fk_recibo_sueldo` (`id_sueldo`),
  ADD KEY `idx_recibo_empleado_periodo` (`id_empleado`,`periodo_anio`,`periodo_mes`,`estado`);

--
-- Indices de la tabla `registros_sueldo`
--
ALTER TABLE `registros_sueldo`
  ADD PRIMARY KEY (`id_registro`),
  ADD KEY `fk_registro_sueldo` (`id_sueldo`);

--
-- Indices de la tabla `sueldo`
--
ALTER TABLE `sueldo`
  ADD PRIMARY KEY (`id_sueldo`),
  ADD UNIQUE KEY `uq_sueldo_empleado_vigencia` (`id_empleado`,`fecha_vigencia`),
  ADD KEY `idx_sueldo_empleado_vigencia` (`id_empleado`,`fecha_vigencia`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `anulacion_recibo`
--
ALTER TABLE `anulacion_recibo`
  MODIFY `id_anulacion` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auditoria_bd`
--
ALTER TABLE `auditoria_bd`
  MODIFY `id_auditoria` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `bono`
--
ALTER TABLE `bono`
  MODIFY `id_bono` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `descuento`
--
ALTER TABLE `descuento`
  MODIFY `id_descuento` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_bono`
--
ALTER TABLE `detalle_bono`
  MODIFY `id_detalle_bono` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_descuento`
--
ALTER TABLE `detalle_descuento`
  MODIFY `id_detalle_descuento` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `id_factura` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `informacion_bancaria`
--
ALTER TABLE `informacion_bancaria`
  MODIFY `id_informacion_bancaria` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pago_obra_social`
--
ALTER TABLE `pago_obra_social`
  MODIFY `id_pago` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pago_paciente`
--
ALTER TABLE `pago_paciente`
  MODIFY `id_pago_paciente` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recibo_sueldo`
--
ALTER TABLE `recibo_sueldo`
  MODIFY `id_recibo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `registros_sueldo`
--
ALTER TABLE `registros_sueldo`
  MODIFY `id_registro` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sueldo`
--
ALTER TABLE `sueldo`
  MODIFY `id_sueldo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `anulacion_recibo`
--
ALTER TABLE `anulacion_recibo`
  ADD CONSTRAINT `fk_anulacion_recibo` FOREIGN KEY (`id_recibo`) REFERENCES `recibo_sueldo` (`id_recibo`);

--
-- Filtros para la tabla `detalle_bono`
--
ALTER TABLE `detalle_bono`
  ADD CONSTRAINT `fk_detalle_bono_bono` FOREIGN KEY (`id_bono`) REFERENCES `bono` (`id_bono`),
  ADD CONSTRAINT `fk_detalle_bono_recibo` FOREIGN KEY (`id_recibo`) REFERENCES `recibo_sueldo` (`id_recibo`);

--
-- Filtros para la tabla `detalle_descuento`
--
ALTER TABLE `detalle_descuento`
  ADD CONSTRAINT `fk_detalle_descuento_descuento` FOREIGN KEY (`id_descuento`) REFERENCES `descuento` (`id_descuento`),
  ADD CONSTRAINT `fk_detalle_descuento_recibo` FOREIGN KEY (`id_recibo`) REFERENCES `recibo_sueldo` (`id_recibo`);

--
-- Filtros para la tabla `pago_obra_social`
--
ALTER TABLE `pago_obra_social`
  ADD CONSTRAINT `fk_pago_obra_factura` FOREIGN KEY (`id_factura`) REFERENCES `factura` (`id_factura`);

--
-- Filtros para la tabla `pago_paciente`
--
ALTER TABLE `pago_paciente`
  ADD CONSTRAINT `fk_pago_paciente_factura` FOREIGN KEY (`id_factura`) REFERENCES `factura` (`id_factura`);

--
-- Filtros para la tabla `recibo_sueldo`
--
ALTER TABLE `recibo_sueldo`
  ADD CONSTRAINT `fk_recibo_sueldo` FOREIGN KEY (`id_sueldo`) REFERENCES `sueldo` (`id_sueldo`);

--
-- Filtros para la tabla `registros_sueldo`
--
ALTER TABLE `registros_sueldo`
  ADD CONSTRAINT `fk_registro_sueldo` FOREIGN KEY (`id_sueldo`) REFERENCES `sueldo` (`id_sueldo`);
--
-- Base de datos: `sistema_clinico`
--
DROP DATABASE IF EXISTS `sistema_clinico`;
CREATE DATABASE IF NOT EXISTS `sistema_clinico` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `sistema_clinico`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `AgregarPaciente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AgregarPaciente` (IN `p_id_obra_social` INT UNSIGNED, IN `p_dni` VARCHAR(20), IN `p_nombre` VARCHAR(80), IN `p_apellido` VARCHAR(80), IN `p_fecha_nacimiento` DATE, IN `p_sexo` VARCHAR(20), IN `p_telefono` VARCHAR(30), IN `p_email` VARCHAR(150), IN `p_direccion` VARCHAR(200))   BEGIN
 INSERT INTO Paciente(id_obra_social,dni,nombre,apellido,fecha_nacimiento,sexo,telefono,email,direccion)
 VALUES(p_id_obra_social,p_dni,p_nombre,p_apellido,p_fecha_nacimiento,COALESCE(NULLIF(p_sexo,''),'NO_ESPECIFICADO'),p_telefono,p_email,p_direccion);
 SELECT LAST_INSERT_ID() AS id_paciente;
END$$

DROP PROCEDURE IF EXISTS `BuscarHistoriaClinica`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarHistoriaClinica` (IN `p_id_paciente` INT UNSIGNED)   BEGIN
 SELECT hc.id_historia_clinica, hc.fecha, hc.hora, hc.tipo_registro, hc.diagnostico, hc.tratamiento, hc.observaciones,
        'INTERNACION' AS origen, i.id_internacion AS id_origen, i.id_paciente, hc.id_empleado
 FROM Historia_Clinica hc JOIN Internacion i ON i.id_internacion=hc.id_internacion WHERE i.id_paciente=p_id_paciente
 UNION ALL
 SELECT hc.id_historia_clinica, hc.fecha, hc.hora, hc.tipo_registro, hc.diagnostico, hc.tratamiento, hc.observaciones,
        'CONSULTA' AS origen, c.id_consulta AS id_origen, c.id_paciente, hc.id_empleado
 FROM Historia_Clinica hc JOIN Consulta c ON c.id_consulta=hc.id_consulta WHERE c.id_paciente=p_id_paciente
 ORDER BY fecha DESC, hora DESC;
END$$

DROP PROCEDURE IF EXISTS `BuscarPaciente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarPaciente` (IN `p_dni` VARCHAR(20))   BEGIN
 SELECT p.*, o.nombre AS obra_social FROM Paciente p LEFT JOIN Obra_Social o ON o.id_obra_social=p.id_obra_social WHERE p.dni=p_dni;
END$$

DROP PROCEDURE IF EXISTS `CrearTurno`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CrearTurno` (IN `p_id_paciente` INT, IN `p_id_medico` INT, IN `p_fecha` DATE, IN `p_hora` TIME, IN `p_motivo` VARCHAR(250))   BEGIN
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
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_bd`
--

DROP TABLE IF EXISTS `auditoria_bd`;
CREATE TABLE `auditoria_bd` (
  `id_auditoria` bigint(20) UNSIGNED NOT NULL,
  `tabla_afectada` varchar(100) NOT NULL,
  `id_registro` varchar(100) NOT NULL,
  `operacion` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `auditoria_bd`
--

INSERT INTO `auditoria_bd` (`id_auditoria`, `tabla_afectada`, `id_registro`, `operacion`, `fecha_hora`) VALUES
(1, 'Paciente', '1', 'INSERT', '2026-10-23 18:46:21'),
(2, 'Departamento', '1', 'INSERT', '2026-10-23 18:47:37'),
(3, 'Empleado', '1', 'INSERT', '2026-10-23 18:47:59'),
(4, 'Turno', '1', 'INSERT', '2026-10-23 18:56:45'),
(5, 'Paciente', '3', 'INSERT', '2026-10-23 19:37:58'),
(6, 'Turno', '1', 'UPDATE', '2026-10-23 20:03:42'),
(7, 'Consulta', '1', 'INSERT', '2026-10-23 20:03:42'),
(8, 'Historia_Clinica', '1', 'INSERT', '2026-10-23 20:07:54'),
(9, 'Turno', '2', 'INSERT', '2026-10-23 20:24:47'),
(10, 'Turno', '2', 'UPDATE', '2026-10-23 20:43:48'),
(11, 'Turno', '3', 'INSERT', '2026-10-26 20:28:46'),
(12, 'Turno', '3', 'DELETE', '2026-10-26 20:30:59'),
(13, 'Turno', '4', 'INSERT', '2026-10-26 21:05:19'),
(14, 'Turno', '4', 'UPDATE', '2026-10-26 21:06:49'),
(15, 'Consulta', '2', 'INSERT', '2026-10-26 21:17:00'),
(16, 'Consulta', '2', 'UPDATE', '2026-10-26 21:25:24'),
(17, 'Consulta', '2', 'DELETE', '2026-10-26 21:29:46'),
(18, 'Historia_Clinica', '2', 'INSERT', '2026-10-27 19:09:55'),
(19, 'Historia_Clinica', '2', 'UPDATE', '2026-10-27 19:12:39'),
(20, 'Consulta', '3', 'INSERT', '2026-10-27 19:23:12'),
(21, 'Historia_Clinica', '3', 'INSERT', '2026-10-27 19:24:25'),
(22, 'Historia_Clinica', '3', 'DELETE', '2026-10-27 19:25:31'),
(23, 'Internacion', '1', 'INSERT', '2026-10-27 19:43:54'),
(24, 'Internacion', '2', 'INSERT', '2026-10-28 13:40:16'),
(25, 'Internacion', '2', 'UPDATE', '2026-10-28 13:50:14'),
(26, 'Internacion', '2', 'DELETE', '2026-10-28 13:59:39'),
(27, 'Medicamento', '1', 'INSERT', '2026-10-28 14:18:54'),
(28, 'Stock_Medicamentos', '1', 'INSERT', '2026-10-28 14:22:33'),
(29, 'Stock_Medicamentos', '1', 'UPDATE', '2026-10-28 14:26:59'),
(30, 'Registro_Medicacion', '1', 'INSERT', '2026-10-28 14:26:59'),
(31, 'Stock_Medicamentos', '2', 'INSERT', '2026-10-28 14:30:20'),
(32, 'Stock_Medicamentos', '3', 'INSERT', '2026-10-28 14:33:10'),
(33, 'Medicamento', '2', 'INSERT', '2026-10-28 14:35:27'),
(34, 'Stock_Medicamentos', '4', 'INSERT', '2026-10-28 14:36:27'),
(35, 'Internacion', '3', 'INSERT', '2026-10-28 14:39:16'),
(36, 'Internacion', '3', 'UPDATE', '2026-10-28 14:39:58'),
(37, 'Receta', '1', 'INSERT', '2026-10-28 14:44:26'),
(38, 'Receta', '1', 'UPDATE', '2026-10-28 14:46:49'),
(39, 'Receta', '1', 'DELETE', '2026-10-28 14:48:37'),
(40, 'Departamento', '2', 'INSERT', '2026-10-28 14:51:29'),
(41, 'Departamento', '2', 'UPDATE', '2026-10-28 14:52:25'),
(42, 'Departamento', '2', 'DELETE', '2026-10-28 14:53:07'),
(43, 'Empleado', '2', 'INSERT', '2026-10-28 14:55:39'),
(44, 'Empleado', '2', 'UPDATE', '2026-10-28 14:57:15'),
(45, 'Empleado', '2', 'DELETE', '2026-10-28 14:58:25'),
(46, 'Paciente', '4', 'INSERT', '2026-10-28 15:10:54'),
(47, 'Paciente', '4', 'UPDATE', '2026-10-28 15:12:08'),
(48, 'Paciente', '4', 'DELETE', '2026-10-28 15:13:38'),
(49, 'Usuario', '1', 'INSERT', '2026-10-28 15:27:11'),
(50, 'Usuario', '1', 'UPDATE', '2026-10-28 15:38:01'),
(51, 'Usuario', '1', 'DELETE', '2026-10-28 15:47:45'),
(52, 'Paciente', '5', 'INSERT', '2026-10-28 16:15:17'),
(53, 'Historia_Clinica', '4', 'INSERT', '2026-10-28 17:28:26'),
(54, 'Turno', '5', 'INSERT', '2026-10-28 17:33:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consulta`
--

DROP TABLE IF EXISTS `consulta`;
CREATE TABLE `consulta` (
  `id_consulta` int(10) UNSIGNED NOT NULL,
  `id_turno` int(10) UNSIGNED DEFAULT NULL,
  `id_paciente` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED NOT NULL COMMENT 'Médico que atendió',
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `motivo` varchar(250) DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `consulta`
--

INSERT INTO `consulta` (`id_consulta`, `id_turno`, `id_paciente`, `id_empleado`, `fecha`, `hora_inicio`, `motivo`, `observaciones`) VALUES
(1, 1, 1, 1, '2026-10-23', '20:03:42', 'Consulta de prueba', 'Registro de prueba para verificar los triggers'),
(3, NULL, 1, 1, '2026-10-27', '19:23:12', 'Consulta temporal para auditoria', 'Registro temporal para probar DELETE de historia clinica');

--
-- Disparadores `consulta`
--
DROP TRIGGER IF EXISTS `ad_aud_consulta`;
DELIMITER $$
CREATE TRIGGER `ad_aud_consulta` AFTER DELETE ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',OLD.id_consulta,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_consulta`;
DELIMITER $$
CREATE TRIGGER `ai_aud_consulta` AFTER INSERT ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',NEW.id_consulta,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_consulta_turno`;
DELIMITER $$
CREATE TRIGGER `ai_consulta_turno` AFTER INSERT ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL THEN UPDATE Turno SET estado='ATENDIDO' WHERE id_turno=NEW.id_turno; END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_consulta`;
DELIMITER $$
CREATE TRIGGER `au_aud_consulta` AFTER UPDATE ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',NEW.id_consulta,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bi_consulta_validar`;
DELIMITER $$
CREATE TRIGGER `bi_consulta_validar` BEFORE INSERT ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Turno t WHERE t.id_turno=NEW.id_turno AND t.id_paciente=NEW.id_paciente AND t.id_empleado=NEW.id_empleado AND t.estado<>'CANCELADO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente y medico deben coincidir con el turno asociado'; END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_consulta_validar`;
DELIMITER $$
CREATE TRIGGER `bu_consulta_validar` BEFORE UPDATE ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Turno t WHERE t.id_turno=NEW.id_turno AND t.id_paciente=NEW.id_paciente AND t.id_empleado=NEW.id_empleado AND t.estado<>'CANCELADO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente y medico deben coincidir con el turno asociado'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consultorios`
--

DROP TABLE IF EXISTS `consultorios`;
CREATE TABLE `consultorios` (
  `id_consultorio` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED DEFAULT NULL,
  `nombre` varchar(80) NOT NULL,
  `ubicacion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

DROP TABLE IF EXISTS `departamento`;
CREATE TABLE `departamento` (
  `id_departamento` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `ubicacion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `departamento`
--

INSERT INTO `departamento` (`id_departamento`, `nombre`, `ubicacion`) VALUES
(1, 'Departamento de Prueba', 'Consultorio de prueba');

--
-- Disparadores `departamento`
--
DROP TRIGGER IF EXISTS `ad_aud_departamento`;
DELIMITER $$
CREATE TRIGGER `ad_aud_departamento` AFTER DELETE ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',OLD.id_departamento,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_departamento`;
DELIMITER $$
CREATE TRIGGER `ai_aud_departamento` AFTER INSERT ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',NEW.id_departamento,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_departamento`;
DELIMITER $$
CREATE TRIGGER `au_aud_departamento` AFTER UPDATE ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',NEW.id_departamento,'UPDATE')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

DROP TABLE IF EXISTS `empleado`;
CREATE TABLE `empleado` (
  `id_empleado` int(10) UNSIGNED NOT NULL,
  `id_departamento` int(10) UNSIGNED NOT NULL,
  `dni` varchar(20) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `apellido` varchar(80) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `id_rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`id_empleado`, `id_departamento`, `dni`, `nombre`, `apellido`, `fecha_nacimiento`, `telefono`, `email`, `direccion`, `estado`, `id_rol`) VALUES
(1, 1, '99000002', 'Medico', 'Prueba', NULL, NULL, NULL, NULL, 'ACTIVO', 1);

--
-- Disparadores `empleado`
--
DROP TRIGGER IF EXISTS `ad_aud_empleado`;
DELIMITER $$
CREATE TRIGGER `ad_aud_empleado` AFTER DELETE ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',OLD.id_empleado,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_empleado`;
DELIMITER $$
CREATE TRIGGER `ai_aud_empleado` AFTER INSERT ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',NEW.id_empleado,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_empleado`;
DELIMITER $$
CREATE TRIGGER `au_aud_empleado` AFTER UPDATE ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',NEW.id_empleado,'UPDATE')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitacion`
--

DROP TABLE IF EXISTS `habitacion`;
CREATE TABLE `habitacion` (
  `id_habitacion` int(10) UNSIGNED NOT NULL,
  `numero` varchar(20) NOT NULL,
  `piso` smallint(6) DEFAULT NULL,
  `tipo` varchar(60) NOT NULL,
  `estado` enum('DISPONIBLE','OCUPADA','MANTENIMIENTO') NOT NULL DEFAULT 'DISPONIBLE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `habitacion`
--

INSERT INTO `habitacion` (`id_habitacion`, `numero`, `piso`, `tipo`, `estado`) VALUES
(1, 'TEST-01', 1, 'Individual', 'OCUPADA'),
(2, 'TEST-02', 1, 'Individual', 'MANTENIMIENTO'),
(3, 'TEST-03', 1, 'Individual', 'DISPONIBLE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historia_clinica`
--

DROP TABLE IF EXISTS `historia_clinica`;
CREATE TABLE `historia_clinica` (
  `id_historia_clinica` int(10) UNSIGNED NOT NULL,
  `id_internacion` int(10) UNSIGNED DEFAULT NULL,
  `id_consulta` int(10) UNSIGNED DEFAULT NULL,
  `id_empleado` int(10) UNSIGNED NOT NULL COMMENT 'Empleado que registra la evolución',
  `fecha` date NOT NULL DEFAULT curdate(),
  `hora` time NOT NULL DEFAULT curtime(),
  `tipo_registro` enum('DIAGNOSTICO','EVOLUCION','ENFERMERIA','SIGNOS_VITALES','MEDICACION','OTRO') NOT NULL,
  `diagnostico` text DEFAULT NULL,
  `tratamiento` text DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `historia_clinica`
--

INSERT INTO `historia_clinica` (`id_historia_clinica`, `id_internacion`, `id_consulta`, `id_empleado`, `fecha`, `hora`, `tipo_registro`, `diagnostico`, `tratamiento`, `observaciones`) VALUES
(1, NULL, 1, 1, '2026-10-23', '20:07:54', 'DIAGNOSTICO', 'Diagnostico de prueba', 'Tratamiento de prueba', 'Registro creado para verificar la relacion con la consulta'),
(2, NULL, 1, 1, '2026-10-27', '19:09:55', 'EVOLUCION', 'Prueba temporal de validacion', NULL, 'Prueba de auditoria UPDATE'),
(4, 1, NULL, 1, '2026-10-28', '17:28:26', 'EVOLUCION', 'PRUEBA TEMPORAL DEL PROCEDIMIENTO', NULL, 'Registro temporal para verificar BuscarHistoriaClinica');

--
-- Disparadores `historia_clinica`
--
DROP TRIGGER IF EXISTS `ad_aud_historia`;
DELIMITER $$
CREATE TRIGGER `ad_aud_historia` AFTER DELETE ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',OLD.id_historia_clinica,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_historia`;
DELIMITER $$
CREATE TRIGGER `ai_aud_historia` AFTER INSERT ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',NEW.id_historia_clinica,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_historia`;
DELIMITER $$
CREATE TRIGGER `au_aud_historia` AFTER UPDATE ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',NEW.id_historia_clinica,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bi_historia_origen`;
DELIMITER $$
CREATE TRIGGER `bi_historia_origen` BEFORE INSERT ON `historia_clinica` FOR EACH ROW BEGIN
 IF (NEW.id_internacion IS NULL AND NEW.id_consulta IS NULL) OR (NEW.id_internacion IS NOT NULL AND NEW.id_consulta IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La historia clinica debe pertenecer a una internacion o a una consulta'; END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_historia_origen`;
DELIMITER $$
CREATE TRIGGER `bu_historia_origen` BEFORE UPDATE ON `historia_clinica` FOR EACH ROW BEGIN
 IF (NEW.id_internacion IS NULL AND NEW.id_consulta IS NULL) OR (NEW.id_internacion IS NOT NULL AND NEW.id_consulta IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La historia clinica debe pertenecer a una internacion o a una consulta'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `internacion`
--

DROP TABLE IF EXISTS `internacion`;
CREATE TABLE `internacion` (
  `id_internacion` int(10) UNSIGNED NOT NULL,
  `id_paciente` int(10) UNSIGNED NOT NULL,
  `id_habitacion` int(10) UNSIGNED NOT NULL,
  `fecha_ingreso` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_alta` datetime DEFAULT NULL,
  `motivo` text NOT NULL,
  `estado` enum('ACTIVA','ALTA','CANCELADA') NOT NULL DEFAULT 'ACTIVA',
  `codigo_qr` char(36) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `internacion`
--

INSERT INTO `internacion` (`id_internacion`, `id_paciente`, `id_habitacion`, `fecha_ingreso`, `fecha_alta`, `motivo`, `estado`, `codigo_qr`) VALUES
(1, 1, 1, '2026-10-27 19:43:54', NULL, 'Prueba de trigger de internacion', 'ACTIVA', 'e8294125-d257-11f1-b50c-722d8826233e'),
(3, 3, 3, '2026-10-28 14:39:16', '2026-10-28 14:39:58', 'Prueba temporal para validar internacion no activa', 'ALTA', '895fdfad-d2f6-11f1-b50c-722d8826233e');

--
-- Disparadores `internacion`
--
DROP TRIGGER IF EXISTS `ad_aud_internacion`;
DELIMITER $$
CREATE TRIGGER `ad_aud_internacion` AFTER DELETE ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',OLD.id_internacion,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_internacion`;
DELIMITER $$
CREATE TRIGGER `ai_aud_internacion` AFTER INSERT ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',NEW.id_internacion,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_internacion_habitacion`;
DELIMITER $$
CREATE TRIGGER `ai_internacion_habitacion` AFTER INSERT ON `internacion` FOR EACH ROW BEGIN
 IF NEW.estado='ACTIVA' THEN UPDATE Habitacion SET estado='OCUPADA' WHERE id_habitacion=NEW.id_habitacion AND estado<>'MANTENIMIENTO'; END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_internacion`;
DELIMITER $$
CREATE TRIGGER `au_aud_internacion` AFTER UPDATE ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',NEW.id_internacion,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_internacion_habitacion`;
DELIMITER $$
CREATE TRIGGER `au_internacion_habitacion` AFTER UPDATE ON `internacion` FOR EACH ROW BEGIN
 IF OLD.id_habitacion<>NEW.id_habitacion OR OLD.estado<>NEW.estado THEN
  IF OLD.estado='ACTIVA' AND NOT EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=OLD.id_habitacion AND estado='ACTIVA' AND id_internacion<>NEW.id_internacion) THEN UPDATE Habitacion SET estado='DISPONIBLE' WHERE id_habitacion=OLD.id_habitacion AND estado='OCUPADA'; END IF;
  IF NEW.estado='ACTIVA' THEN UPDATE Habitacion SET estado='OCUPADA' WHERE id_habitacion=NEW.id_habitacion AND estado<>'MANTENIMIENTO'; END IF;
 END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bi_internacion_validar`;
DELIMITER $$
CREATE TRIGGER `bi_internacion_validar` BEFORE INSERT ON `internacion` FOR EACH ROW BEGIN
 IF NEW.fecha_alta IS NOT NULL AND NEW.fecha_alta < NEW.fecha_ingreso THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha de alta no puede ser anterior al ingreso'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=NEW.id_habitacion AND estado='ACTIVA') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La habitacion ya tiene una internacion activa'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Habitacion WHERE id_habitacion=NEW.id_habitacion AND estado='MANTENIMIENTO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se puede internar en una habitacion en mantenimiento'; END IF;
 SET NEW.codigo_qr = COALESCE(NULLIF(NEW.codigo_qr,''), UUID());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_internacion_validar`;
DELIMITER $$
CREATE TRIGGER `bu_internacion_validar` BEFORE UPDATE ON `internacion` FOR EACH ROW BEGIN
 IF NEW.fecha_alta IS NOT NULL AND NEW.fecha_alta < NEW.fecha_ingreso THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha de alta no puede ser anterior al ingreso'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=NEW.id_habitacion AND estado='ACTIVA' AND id_internacion<>NEW.id_internacion) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La habitacion ya tiene una internacion activa'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Habitacion WHERE id_habitacion=NEW.id_habitacion AND estado='MANTENIMIENTO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se puede internar en una habitacion en mantenimiento'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medicamento`
--

DROP TABLE IF EXISTS `medicamento`;
CREATE TABLE `medicamento` (
  `id_medicamento` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `presentacion` enum('COMPRIMIDOS','CAPSULAS','INYECTABLES','LIQUIDOS','CREMA','GOTAS','OTROS') NOT NULL DEFAULT 'OTROS',
  `dosis` varchar(80) DEFAULT NULL COMMENT 'Concentración del producto, por ejemplo 500 mg',
  `laboratorio` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `medicamento`
--

INSERT INTO `medicamento` (`id_medicamento`, `nombre`, `descripcion`, `presentacion`, `dosis`, `laboratorio`) VALUES
(1, 'Medicamento Prueba Trigger', 'Registro temporal para probar los triggers de medicacion', 'COMPRIMIDOS', '500 mg', 'Laboratorio de prueba'),
(2, 'Medicamento Prueba Trigger 2', 'Segundo medicamento temporal para probar la validacion de lotes', 'CAPSULAS', '250 mg', 'Laboratorio de prueba');

--
-- Disparadores `medicamento`
--
DROP TRIGGER IF EXISTS `ad_aud_medicamento`;
DELIMITER $$
CREATE TRIGGER `ad_aud_medicamento` AFTER DELETE ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',OLD.id_medicamento,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_medicamento`;
DELIMITER $$
CREATE TRIGGER `ai_aud_medicamento` AFTER INSERT ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',NEW.id_medicamento,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_medicamento`;
DELIMITER $$
CREATE TRIGGER `au_aud_medicamento` AFTER UPDATE ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',NEW.id_medicamento,'UPDATE')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medico`
--

DROP TABLE IF EXISTS `medico`;
CREATE TABLE `medico` (
  `id_empleado` int(10) UNSIGNED NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `especialidad` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `medico`
--

INSERT INTO `medico` (`id_empleado`, `matricula`, `especialidad`) VALUES
(1, 'MAT-PRUEBA-001', 'Clínica');

--
-- Disparadores `medico`
--
DROP TRIGGER IF EXISTS `bi_medico_categoria`;
DELIMITER $$
CREATE TRIGGER `bi_medico_categoria` BEFORE INSERT ON `medico` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_medico_categoria`;
DELIMITER $$
CREATE TRIGGER `bu_medico_categoria` BEFORE UPDATE ON `medico` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `obra_social`
--

DROP TABLE IF EXISTS `obra_social`;
CREATE TABLE `obra_social` (
  `id_obra_social` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') NOT NULL DEFAULT 'ACTIVA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

DROP TABLE IF EXISTS `paciente`;
CREATE TABLE `paciente` (
  `id_paciente` int(10) UNSIGNED NOT NULL,
  `id_obra_social` int(10) UNSIGNED DEFAULT NULL,
  `dni` varchar(20) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `apellido` varchar(80) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `sexo` enum('F','M','X','NO_ESPECIFICADO') NOT NULL DEFAULT 'NO_ESPECIFICADO',
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`id_paciente`, `id_obra_social`, `dni`, `nombre`, `apellido`, `fecha_nacimiento`, `sexo`, `telefono`, `email`, `direccion`) VALUES
(1, NULL, '99000001', 'Paciente', 'Prueba', NULL, 'NO_ESPECIFICADO', NULL, NULL, NULL),
(3, NULL, '99000003', 'Paciente', 'Nuevo', NULL, 'NO_ESPECIFICADO', NULL, NULL, NULL),
(5, NULL, '99999993', 'Paciente', 'Prueba SP', NULL, 'NO_ESPECIFICADO', NULL, NULL, NULL);

--
-- Disparadores `paciente`
--
DROP TRIGGER IF EXISTS `ad_aud_paciente`;
DELIMITER $$
CREATE TRIGGER `ad_aud_paciente` AFTER DELETE ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',OLD.id_paciente,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_paciente`;
DELIMITER $$
CREATE TRIGGER `ai_aud_paciente` AFTER INSERT ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',NEW.id_paciente,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_paciente`;
DELIMITER $$
CREATE TRIGGER `au_aud_paciente` AFTER UPDATE ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',NEW.id_paciente,'UPDATE')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `receta`
--

DROP TABLE IF EXISTS `receta`;
CREATE TABLE `receta` (
  `id_receta` int(10) UNSIGNED NOT NULL,
  `id_consulta` int(10) UNSIGNED NOT NULL,
  `id_paciente` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED NOT NULL COMMENT 'Médico prescriptor',
  `id_medicamento` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `receta`
--
DROP TRIGGER IF EXISTS `ad_aud_receta`;
DELIMITER $$
CREATE TRIGGER `ad_aud_receta` AFTER DELETE ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',OLD.id_receta,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_receta`;
DELIMITER $$
CREATE TRIGGER `ai_aud_receta` AFTER INSERT ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',NEW.id_receta,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_receta`;
DELIMITER $$
CREATE TRIGGER `au_aud_receta` AFTER UPDATE ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',NEW.id_receta,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bi_receta_validar`;
DELIMITER $$
CREATE TRIGGER `bi_receta_validar` BEFORE INSERT ON `receta` FOR EACH ROW BEGIN
 IF NOT EXISTS(SELECT 1 FROM Consulta c WHERE c.id_consulta=NEW.id_consulta AND c.id_paciente=NEW.id_paciente AND c.id_empleado=NEW.id_empleado) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La receta debe coincidir con el paciente y medico de la consulta'; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro_medicacion`
--

DROP TABLE IF EXISTS `registro_medicacion`;
CREATE TABLE `registro_medicacion` (
  `id_registro_medicacion` int(10) UNSIGNED NOT NULL,
  `id_internacion` int(10) UNSIGNED NOT NULL,
  `id_medicamento` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED NOT NULL COMMENT 'Empleado que administra; validación de rol en backend',
  `id_stock` int(10) UNSIGNED NOT NULL,
  `fecha` date NOT NULL DEFAULT curdate(),
  `hora` time NOT NULL DEFAULT curtime(),
  `dosis_administrada` varchar(80) NOT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `registro_medicacion`
--

INSERT INTO `registro_medicacion` (`id_registro_medicacion`, `id_internacion`, `id_medicamento`, `id_empleado`, `id_stock`, `fecha`, `hora`, `dosis_administrada`, `observaciones`) VALUES
(1, 1, 1, 1, 1, '2026-10-28', '14:26:59', '1 comprimido de 500 mg', 'Prueba de trigger de descuento de stock');

--
-- Disparadores `registro_medicacion`
--
DROP TRIGGER IF EXISTS `ad_aud_registro_medicacion`;
DELIMITER $$
CREATE TRIGGER `ad_aud_registro_medicacion` AFTER DELETE ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',OLD.id_registro_medicacion,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_registro_medicacion`;
DELIMITER $$
CREATE TRIGGER `ai_aud_registro_medicacion` AFTER INSERT ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',NEW.id_registro_medicacion,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_registro_medicacion_stock`;
DELIMITER $$
CREATE TRIGGER `ai_registro_medicacion_stock` AFTER INSERT ON `registro_medicacion` FOR EACH ROW BEGIN
 UPDATE Stock_Medicamentos SET cantidad=cantidad-1 WHERE id_stock=NEW.id_stock AND cantidad>0;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_registro_medicacion`;
DELIMITER $$
CREATE TRIGGER `au_aud_registro_medicacion` AFTER UPDATE ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',NEW.id_registro_medicacion,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bi_registro_medicacion_validar`;
DELIMITER $$
CREATE TRIGGER `bi_registro_medicacion_validar` BEFORE INSERT ON `registro_medicacion` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

DROP TABLE IF EXISTS `rol`;
CREATE TABLE `rol` (
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `nombre`, `descripcion`) VALUES
(1, 'Medico', 'Personal médico'),
(2, 'Enfermero', 'Personal de enfermería'),
(3, 'Jefatura', 'Personal de jefatura'),
(4, 'Administracion', 'Personal administrativo'),
(5, 'Farmaceutico', 'Personal farmacéutico');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `stock_medicamentos`
--

DROP TABLE IF EXISTS `stock_medicamentos`;
CREATE TABLE `stock_medicamentos` (
  `id_stock` int(10) UNSIGNED NOT NULL,
  `id_medicamento` int(10) UNSIGNED NOT NULL,
  `cantidad` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `stock_minimo` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `numero_lote` varchar(80) NOT NULL,
  `fecha_vencimiento` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `stock_medicamentos`
--

INSERT INTO `stock_medicamentos` (`id_stock`, `id_medicamento`, `cantidad`, `stock_minimo`, `numero_lote`, `fecha_vencimiento`) VALUES
(1, 1, 9, 2, 'LOTE-PRUEBA-TRIGGER-001', '2027-12-31'),
(2, 1, 5, 1, 'LOTE-VENCIDO-PRUEBA', '2025-01-01'),
(3, 1, 0, 1, 'LOTE-AGOTADO-PRUEBA', '2027-12-31'),
(4, 2, 5, 1, 'LOTE-MEDICAMENTO-2', '2027-12-31');

--
-- Disparadores `stock_medicamentos`
--
DROP TRIGGER IF EXISTS `ad_aud_stock`;
DELIMITER $$
CREATE TRIGGER `ad_aud_stock` AFTER DELETE ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',OLD.id_stock,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_stock`;
DELIMITER $$
CREATE TRIGGER `ai_aud_stock` AFTER INSERT ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',NEW.id_stock,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_stock`;
DELIMITER $$
CREATE TRIGGER `au_aud_stock` AFTER UPDATE ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',NEW.id_stock,'UPDATE')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turno`
--

DROP TABLE IF EXISTS `turno`;
CREATE TABLE `turno` (
  `id_turno` int(10) UNSIGNED NOT NULL,
  `id_paciente` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED NOT NULL COMMENT 'Médico asignado',
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `estado` enum('PENDIENTE','CONFIRMADO','CANCELADO','ATENDIDO') NOT NULL DEFAULT 'PENDIENTE',
  `motivo` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `turno`
--

INSERT INTO `turno` (`id_turno`, `id_paciente`, `id_empleado`, `fecha`, `hora`, `estado`, `motivo`) VALUES
(1, 1, 1, '2026-10-24', '09:00:00', 'ATENDIDO', 'Turno de prueba'),
(2, 1, 1, '2026-10-24', '09:15:00', 'PENDIENTE', 'Prueba de trigger UPDATE'),
(4, 1, 1, '2026-10-27', '12:00:00', 'CANCELADO', 'Prueba turno cancelado para Consulta'),
(5, 1, 1, '2026-10-29', '10:00:00', 'PENDIENTE', 'Prueba temporal del procedimiento CrearTurno');

--
-- Disparadores `turno`
--
DROP TRIGGER IF EXISTS `ad_aud_turno`;
DELIMITER $$
CREATE TRIGGER `ad_aud_turno` AFTER DELETE ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',OLD.id_turno,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_turno`;
DELIMITER $$
CREATE TRIGGER `ai_aud_turno` AFTER INSERT ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',NEW.id_turno,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_turno`;
DELIMITER $$
CREATE TRIGGER `au_aud_turno` AFTER UPDATE ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',NEW.id_turno,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bi_turno_disponibilidad`;
DELIMITER $$
CREATE TRIGGER `bi_turno_disponibilidad` BEFORE INSERT ON `turno` FOR EACH ROW BEGIN
 IF NEW.estado<>'CANCELADO' AND EXISTS(SELECT 1 FROM Turno t WHERE t.fecha=NEW.fecha AND t.estado<>'CANCELADO' AND t.hora < ADDTIME(NEW.hora,'00:30:00') AND ADDTIME(t.hora,'00:30:00') > NEW.hora AND (t.id_empleado=NEW.id_empleado OR t.id_paciente=NEW.id_paciente)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El medico o el paciente ya tiene un turno en ese horario'; END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_turno_disponibilidad`;
DELIMITER $$
CREATE TRIGGER `bu_turno_disponibilidad` BEFORE UPDATE ON `turno` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `id_usuario` int(10) UNSIGNED NOT NULL,
  `id_empleado` int(10) UNSIGNED DEFAULT NULL,
  `id_paciente` int(10) UNSIGNED DEFAULT NULL,
  `contrasena` varchar(255) NOT NULL COMMENT 'Hash generado por el backend, nunca texto plano',
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `usuario`
--
DROP TRIGGER IF EXISTS `ad_aud_usuario`;
DELIMITER $$
CREATE TRIGGER `ad_aud_usuario` AFTER DELETE ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',OLD.id_usuario,'DELETE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ai_aud_usuario`;
DELIMITER $$
CREATE TRIGGER `ai_aud_usuario` AFTER INSERT ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',NEW.id_usuario,'INSERT')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `au_aud_usuario`;
DELIMITER $$
CREATE TRIGGER `au_aud_usuario` AFTER UPDATE ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',NEW.id_usuario,'UPDATE')
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bi_usuario_relacion`;
DELIMITER $$
CREATE TRIGGER `bi_usuario_relacion` BEFORE INSERT ON `usuario` FOR EACH ROW BEGIN
 IF (NEW.id_empleado IS NULL AND NEW.id_paciente IS NULL) OR (NEW.id_empleado IS NOT NULL AND NEW.id_paciente IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El usuario debe pertenecer a un empleado o a un paciente, no a ambos'; END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bu_usuario_relacion_update`;
DELIMITER $$
CREATE TRIGGER `bu_usuario_relacion_update` BEFORE UPDATE ON `usuario` FOR EACH ROW BEGIN
 IF (NEW.id_empleado IS NULL AND NEW.id_paciente IS NULL) OR (NEW.id_empleado IS NOT NULL AND NEW.id_paciente IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El usuario debe pertenecer a un empleado o a un paciente, no a ambos'; END IF;
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria_bd`
--
ALTER TABLE `auditoria_bd`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `idx_auditoria_tabla_fecha` (`tabla_afectada`,`fecha_hora`);

--
-- Indices de la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD PRIMARY KEY (`id_consulta`),
  ADD UNIQUE KEY `id_turno` (`id_turno`),
  ADD KEY `fk_consulta_medico` (`id_empleado`),
  ADD KEY `idx_consulta_paciente_fecha` (`id_paciente`,`fecha`);

--
-- Indices de la tabla `consultorios`
--
ALTER TABLE `consultorios`
  ADD PRIMARY KEY (`id_consultorio`),
  ADD UNIQUE KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`id_departamento`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`id_empleado`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `fk_empleado_departamento` (`id_departamento`),
  ADD KEY `fk_empleado_rol` (`id_rol`);

--
-- Indices de la tabla `habitacion`
--
ALTER TABLE `habitacion`
  ADD PRIMARY KEY (`id_habitacion`),
  ADD UNIQUE KEY `numero` (`numero`);

--
-- Indices de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  ADD PRIMARY KEY (`id_historia_clinica`),
  ADD KEY `fk_historia_empleado` (`id_empleado`),
  ADD KEY `idx_historia_internacion_fecha` (`id_internacion`,`fecha`,`hora`),
  ADD KEY `idx_historia_consulta_fecha` (`id_consulta`,`fecha`,`hora`);

--
-- Indices de la tabla `internacion`
--
ALTER TABLE `internacion`
  ADD PRIMARY KEY (`id_internacion`),
  ADD UNIQUE KEY `codigo_qr` (`codigo_qr`),
  ADD KEY `idx_internacion_paciente_estado` (`id_paciente`,`estado`),
  ADD KEY `idx_internacion_habitacion_estado` (`id_habitacion`,`estado`);

--
-- Indices de la tabla `medicamento`
--
ALTER TABLE `medicamento`
  ADD PRIMARY KEY (`id_medicamento`),
  ADD KEY `idx_medicamento_nombre` (`nombre`);

--
-- Indices de la tabla `medico`
--
ALTER TABLE `medico`
  ADD PRIMARY KEY (`id_empleado`),
  ADD UNIQUE KEY `matricula` (`matricula`);

--
-- Indices de la tabla `obra_social`
--
ALTER TABLE `obra_social`
  ADD PRIMARY KEY (`id_obra_social`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`id_paciente`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `fk_paciente_obra_social` (`id_obra_social`);

--
-- Indices de la tabla `receta`
--
ALTER TABLE `receta`
  ADD PRIMARY KEY (`id_receta`),
  ADD KEY `fk_receta_paciente` (`id_paciente`),
  ADD KEY `fk_receta_medico` (`id_empleado`),
  ADD KEY `fk_receta_medicamento` (`id_medicamento`),
  ADD KEY `idx_receta_consulta` (`id_consulta`);

--
-- Indices de la tabla `registro_medicacion`
--
ALTER TABLE `registro_medicacion`
  ADD PRIMARY KEY (`id_registro_medicacion`),
  ADD KEY `fk_registro_medicamento` (`id_medicamento`),
  ADD KEY `fk_registro_empleado` (`id_empleado`),
  ADD KEY `fk_registro_stock` (`id_stock`),
  ADD KEY `idx_registro_internacion_fecha` (`id_internacion`,`fecha`,`hora`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `stock_medicamentos`
--
ALTER TABLE `stock_medicamentos`
  ADD PRIMARY KEY (`id_stock`),
  ADD UNIQUE KEY `uq_stock_medicamento_lote` (`id_medicamento`,`numero_lote`),
  ADD KEY `idx_stock_vencimiento` (`fecha_vencimiento`);

--
-- Indices de la tabla `turno`
--
ALTER TABLE `turno`
  ADD PRIMARY KEY (`id_turno`),
  ADD KEY `idx_turno_medico_fecha` (`id_empleado`,`fecha`,`hora`,`estado`),
  ADD KEY `idx_turno_paciente_fecha` (`id_paciente`,`fecha`,`hora`,`estado`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `id_empleado` (`id_empleado`),
  ADD UNIQUE KEY `id_paciente` (`id_paciente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria_bd`
--
ALTER TABLE `auditoria_bd`
  MODIFY `id_auditoria` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `consulta`
--
ALTER TABLE `consulta`
  MODIFY `id_consulta` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `consultorios`
--
ALTER TABLE `consultorios`
  MODIFY `id_consultorio` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `departamento`
--
ALTER TABLE `departamento`
  MODIFY `id_departamento` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `id_empleado` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `habitacion`
--
ALTER TABLE `habitacion`
  MODIFY `id_habitacion` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  MODIFY `id_historia_clinica` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `internacion`
--
ALTER TABLE `internacion`
  MODIFY `id_internacion` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `medicamento`
--
ALTER TABLE `medicamento`
  MODIFY `id_medicamento` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `obra_social`
--
ALTER TABLE `obra_social`
  MODIFY `id_obra_social` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `id_paciente` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `receta`
--
ALTER TABLE `receta`
  MODIFY `id_receta` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `registro_medicacion`
--
ALTER TABLE `registro_medicacion`
  MODIFY `id_registro_medicacion` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `stock_medicamentos`
--
ALTER TABLE `stock_medicamentos`
  MODIFY `id_stock` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `turno`
--
ALTER TABLE `turno`
  MODIFY `id_turno` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD CONSTRAINT `fk_consulta_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`),
  ADD CONSTRAINT `fk_consulta_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
  ADD CONSTRAINT `fk_consulta_turno` FOREIGN KEY (`id_turno`) REFERENCES `turno` (`id_turno`);

--
-- Filtros para la tabla `consultorios`
--
ALTER TABLE `consultorios`
  ADD CONSTRAINT `fk_consultorio_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`);

--
-- Filtros para la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `fk_empleado_departamento` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`),
  ADD CONSTRAINT `fk_empleado_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  ADD CONSTRAINT `fk_historia_consulta` FOREIGN KEY (`id_consulta`) REFERENCES `consulta` (`id_consulta`),
  ADD CONSTRAINT `fk_historia_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  ADD CONSTRAINT `fk_historia_internacion` FOREIGN KEY (`id_internacion`) REFERENCES `internacion` (`id_internacion`);

--
-- Filtros para la tabla `internacion`
--
ALTER TABLE `internacion`
  ADD CONSTRAINT `fk_internacion_habitacion` FOREIGN KEY (`id_habitacion`) REFERENCES `habitacion` (`id_habitacion`),
  ADD CONSTRAINT `fk_internacion_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`);

--
-- Filtros para la tabla `medico`
--
ALTER TABLE `medico`
  ADD CONSTRAINT `fk_medico_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `fk_paciente_obra_social` FOREIGN KEY (`id_obra_social`) REFERENCES `obra_social` (`id_obra_social`);

--
-- Filtros para la tabla `receta`
--
ALTER TABLE `receta`
  ADD CONSTRAINT `fk_receta_consulta` FOREIGN KEY (`id_consulta`) REFERENCES `consulta` (`id_consulta`),
  ADD CONSTRAINT `fk_receta_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`),
  ADD CONSTRAINT `fk_receta_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`),
  ADD CONSTRAINT `fk_receta_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`);

--
-- Filtros para la tabla `registro_medicacion`
--
ALTER TABLE `registro_medicacion`
  ADD CONSTRAINT `fk_registro_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  ADD CONSTRAINT `fk_registro_internacion` FOREIGN KEY (`id_internacion`) REFERENCES `internacion` (`id_internacion`),
  ADD CONSTRAINT `fk_registro_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`),
  ADD CONSTRAINT `fk_registro_stock` FOREIGN KEY (`id_stock`) REFERENCES `stock_medicamentos` (`id_stock`);

--
-- Filtros para la tabla `stock_medicamentos`
--
ALTER TABLE `stock_medicamentos`
  ADD CONSTRAINT `fk_stock_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`);

--
-- Filtros para la tabla `turno`
--
ALTER TABLE `turno`
  ADD CONSTRAINT `fk_turno_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`),
  ADD CONSTRAINT `fk_turno_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  ADD CONSTRAINT `fk_usuario_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
