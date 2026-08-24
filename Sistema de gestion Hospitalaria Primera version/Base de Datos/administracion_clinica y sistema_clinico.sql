-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-07-2026 a las 01:22:43
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
CREATE DATABASE IF NOT EXISTS `administracion_clinica` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `administracion_clinica`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `RegistrarSueldo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarSueldo` (IN `p_id_empleado` INT, IN `p_sueldo_base` DECIMAL(10,2), IN `p_fecha_vigencia` DATE, IN `p_estado` VARCHAR(20))   BEGIN

    INSERT INTO Sueldo(
        id_empleado,
        sueldo_base,
        fecha_vigencia,
        estado
    )
    VALUES(
        p_id_empleado,
        p_sueldo_base,
        p_fecha_vigencia,
        p_estado
    );

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bono`
--

DROP TABLE IF EXISTS `bono`;
CREATE TABLE `bono` (
  `id_bono` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descuento`
--

DROP TABLE IF EXISTS `descuento`;
CREATE TABLE `descuento` (
  `id_descuento` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_bono`
--

DROP TABLE IF EXISTS `detalle_bono`;
CREATE TABLE `detalle_bono` (
  `id_detalle_bono` int(11) NOT NULL,
  `id_recibo` int(11) NOT NULL,
  `id_bono` int(11) NOT NULL,
  `importe` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_descuento`
--

DROP TABLE IF EXISTS `detalle_descuento`;
CREATE TABLE `detalle_descuento` (
  `id_detalle_descuento` int(11) NOT NULL,
  `id_recibo` int(11) NOT NULL,
  `id_descuento` int(11) NOT NULL,
  `importe` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

DROP TABLE IF EXISTS `factura`;
CREATE TABLE `factura` (
  `id_factura` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `id_obra_social` int(11) NOT NULL,
  `fecha_emision` date NOT NULL,
  `importe_total` decimal(10,2) NOT NULL,
  `porcentaje_cobertura` decimal(5,2) NOT NULL,
  `importe_cubierto` decimal(10,2) NOT NULL,
  `importe_paciente` decimal(10,2) NOT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago_obra_social`
--

DROP TABLE IF EXISTS `pago_obra_social`;
CREATE TABLE `pago_obra_social` (
  `id_pago` int(11) NOT NULL,
  `id_factura` int(11) NOT NULL,
  `fecha_pago` date NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recibo_sueldo`
--

DROP TABLE IF EXISTS `recibo_sueldo`;
CREATE TABLE `recibo_sueldo` (
  `id_recibo` int(11) NOT NULL,
  `id_sueldo` int(11) NOT NULL,
  `periodo` varchar(20) NOT NULL,
  `fecha_emision` date NOT NULL,
  `total_bruto` decimal(10,2) NOT NULL,
  `total_descuentos` decimal(10,2) NOT NULL,
  `total_bonos` decimal(10,2) NOT NULL,
  `total_neto` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sueldo`
--

DROP TABLE IF EXISTS `sueldo`;
CREATE TABLE `sueldo` (
  `id_sueldo` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `sueldo_base` decimal(10,2) NOT NULL,
  `fecha_vigencia` date NOT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bono`
--
ALTER TABLE `bono`
  ADD PRIMARY KEY (`id_bono`);

--
-- Indices de la tabla `descuento`
--
ALTER TABLE `descuento`
  ADD PRIMARY KEY (`id_descuento`);

--
-- Indices de la tabla `detalle_bono`
--
ALTER TABLE `detalle_bono`
  ADD PRIMARY KEY (`id_detalle_bono`),
  ADD KEY `id_recibo` (`id_recibo`),
  ADD KEY `id_bono` (`id_bono`);

--
-- Indices de la tabla `detalle_descuento`
--
ALTER TABLE `detalle_descuento`
  ADD PRIMARY KEY (`id_detalle_descuento`),
  ADD KEY `id_recibo` (`id_recibo`),
  ADD KEY `id_descuento` (`id_descuento`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`id_factura`);

--
-- Indices de la tabla `pago_obra_social`
--
ALTER TABLE `pago_obra_social`
  ADD PRIMARY KEY (`id_pago`),
  ADD KEY `id_factura` (`id_factura`);

--
-- Indices de la tabla `recibo_sueldo`
--
ALTER TABLE `recibo_sueldo`
  ADD PRIMARY KEY (`id_recibo`),
  ADD KEY `id_sueldo` (`id_sueldo`);

--
-- Indices de la tabla `sueldo`
--
ALTER TABLE `sueldo`
  ADD PRIMARY KEY (`id_sueldo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bono`
--
ALTER TABLE `bono`
  MODIFY `id_bono` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `descuento`
--
ALTER TABLE `descuento`
  MODIFY `id_descuento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_bono`
--
ALTER TABLE `detalle_bono`
  MODIFY `id_detalle_bono` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_descuento`
--
ALTER TABLE `detalle_descuento`
  MODIFY `id_detalle_descuento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `id_factura` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pago_obra_social`
--
ALTER TABLE `pago_obra_social`
  MODIFY `id_pago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `recibo_sueldo`
--
ALTER TABLE `recibo_sueldo`
  MODIFY `id_recibo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sueldo`
--
ALTER TABLE `sueldo`
  MODIFY `id_sueldo` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_bono`
--
ALTER TABLE `detalle_bono`
  ADD CONSTRAINT `detalle_bono_ibfk_1` FOREIGN KEY (`id_recibo`) REFERENCES `recibo_sueldo` (`id_recibo`),
  ADD CONSTRAINT `detalle_bono_ibfk_2` FOREIGN KEY (`id_bono`) REFERENCES `bono` (`id_bono`);

--
-- Filtros para la tabla `detalle_descuento`
--
ALTER TABLE `detalle_descuento`
  ADD CONSTRAINT `detalle_descuento_ibfk_1` FOREIGN KEY (`id_recibo`) REFERENCES `recibo_sueldo` (`id_recibo`),
  ADD CONSTRAINT `detalle_descuento_ibfk_2` FOREIGN KEY (`id_descuento`) REFERENCES `descuento` (`id_descuento`);

--
-- Filtros para la tabla `pago_obra_social`
--
ALTER TABLE `pago_obra_social`
  ADD CONSTRAINT `pago_obra_social_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `factura` (`id_factura`);

--
-- Filtros para la tabla `recibo_sueldo`
--
ALTER TABLE `recibo_sueldo`
  ADD CONSTRAINT `recibo_sueldo_ibfk_1` FOREIGN KEY (`id_sueldo`) REFERENCES `sueldo` (`id_sueldo`);
--
-- Base de datos: `sistema_clinico`
--
DROP DATABASE IF EXISTS `sistema_clinico`;
CREATE DATABASE IF NOT EXISTS `sistema_clinico` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `sistema_clinico`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `AgregarPaciente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AgregarPaciente` (IN `p_id_obra_social` INT, IN `p_dni` VARCHAR(15), IN `p_nombre` VARCHAR(50), IN `p_apellido` VARCHAR(50), IN `p_fecha_nacimiento` DATE, IN `p_sexo` VARCHAR(20), IN `p_telefono` VARCHAR(20), IN `p_email` VARCHAR(100), IN `p_direccion` VARCHAR(150))   BEGIN

    INSERT INTO Paciente(
        id_obra_social,
        dni,
        nombre,
        apellido,
        fecha_nacimiento,
        sexo,
        telefono,
        email,
        direccion
    )
    VALUES(
        p_id_obra_social,
        p_dni,
        p_nombre,
        p_apellido,
        p_fecha_nacimiento,
        p_sexo,
        p_telefono,
        p_email,
        p_direccion
    );

END$$

DROP PROCEDURE IF EXISTS `BuscarHistoriaClinica`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarHistoriaClinica` (IN `p_id_internacion` INT)   BEGIN

    SELECT *
    FROM Historia_Clinica
    WHERE id_internacion = p_id_internacion
    ORDER BY fecha, hora;

END$$

DROP PROCEDURE IF EXISTS `BuscarPaciente`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuscarPaciente` (IN `p_dni` VARCHAR(15))   BEGIN

    SELECT *
    FROM Paciente
    WHERE dni = p_dni;

END$$

DROP PROCEDURE IF EXISTS `CrearFactura`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CrearFactura` (IN `p_id_paciente` INT, IN `p_id_obra_social` INT, IN `p_fecha_emision` DATE, IN `p_importe_total` DECIMAL(10,2), IN `p_porcentaje_cobertura` DECIMAL(5,2), IN `p_importe_cubierto` DECIMAL(10,2), IN `p_importe_paciente` DECIMAL(10,2), IN `p_estado` VARCHAR(20))   BEGIN

    INSERT INTO Factura(
        id_paciente,
        id_obra_social,
        fecha_emision,
        importe_total,
        porcentaje_cobertura,
        importe_cubierto,
        importe_paciente,
        estado
    )
    VALUES(
        p_id_paciente,
        p_id_obra_social,
        p_fecha_emision,
        p_importe_total,
        p_porcentaje_cobertura,
        p_importe_cubierto,
        p_importe_paciente,
        p_estado
    );

END$$

DROP PROCEDURE IF EXISTS `CrearTurno`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CrearTurno` (IN `p_id_paciente` INT, IN `p_id_empleado` INT, IN `p_fecha` DATE, IN `p_hora` TIME, IN `p_estado` VARCHAR(30), IN `p_motivo` VARCHAR(255))   BEGIN

    INSERT INTO Turno(
        id_paciente,
        id_empleado,
        fecha,
        hora,
        estado,
        motivo
    )
    VALUES(
        p_id_paciente,
        p_id_empleado,
        p_fecha,
        p_hora,
        p_estado,
        p_motivo
    );

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

DROP TABLE IF EXISTS `departamento`;
CREATE TABLE `departamento` (
  `id_departamento` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `ubicacion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

DROP TABLE IF EXISTS `empleado`;
CREATE TABLE `empleado` (
  `id_empleado` int(11) NOT NULL,
  `id_departamento` int(11) NOT NULL,
  `dni` varchar(15) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `fecha_ingreso` date NOT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitacion`
--

DROP TABLE IF EXISTS `habitacion`;
CREATE TABLE `habitacion` (
  `id_habitacion` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `piso` int(11) NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historia_clinica`
--

DROP TABLE IF EXISTS `historia_clinica`;
CREATE TABLE `historia_clinica` (
  `id_historia_clinica` int(11) NOT NULL,
  `id_internacion` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `tipo_registro` varchar(50) NOT NULL,
  `diagnostico` varchar(255) DEFAULT NULL,
  `tratamiento` varchar(255) DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `internacion`
--

DROP TABLE IF EXISTS `internacion`;
CREATE TABLE `internacion` (
  `id_internacion` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `id_habitacion` int(11) NOT NULL,
  `fecha_ingreso` date NOT NULL,
  `fecha_alta` date DEFAULT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `codigo_qr` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medicamento`
--

DROP TABLE IF EXISTS `medicamento`;
CREATE TABLE `medicamento` (
  `id_medicamento` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `presentacion` varchar(100) DEFAULT NULL,
  `dosis` varchar(50) DEFAULT NULL,
  `laboratorio` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medico`
--

DROP TABLE IF EXISTS `medico`;
CREATE TABLE `medico` (
  `id_empleado` int(11) NOT NULL,
  `id_departamento` int(11) NOT NULL,
  `matricula` varchar(30) NOT NULL,
  `especialidad` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `obra_social`
--

DROP TABLE IF EXISTS `obra_social`;
CREATE TABLE `obra_social` (
  `id_obra_social` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

DROP TABLE IF EXISTS `paciente`;
CREATE TABLE `paciente` (
  `id_paciente` int(11) NOT NULL,
  `id_obra_social` int(11) NOT NULL,
  `dni` varchar(15) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `sexo` varchar(20) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro_medicacion`
--

DROP TABLE IF EXISTS `registro_medicacion`;
CREATE TABLE `registro_medicacion` (
  `id_registro_medicacion` int(11) NOT NULL,
  `id_internacion` int(11) NOT NULL,
  `id_medicamento` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `dosis_administrada` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

DROP TABLE IF EXISTS `rol`;
CREATE TABLE `rol` (
  `id_rol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `stock_medicamentos`
--

DROP TABLE IF EXISTS `stock_medicamentos`;
CREATE TABLE `stock_medicamentos` (
  `id_stock` int(11) NOT NULL,
  `id_medicamento` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `stock_minimo` int(11) NOT NULL,
  `numero_lote` varchar(50) DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `ubicacion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turno`
--

DROP TABLE IF EXISTS `turno`;
CREATE TABLE `turno` (
  `id_turno` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `motivo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`id_departamento`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`id_empleado`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `id_departamento` (`id_departamento`);

--
-- Indices de la tabla `habitacion`
--
ALTER TABLE `habitacion`
  ADD PRIMARY KEY (`id_habitacion`);

--
-- Indices de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  ADD PRIMARY KEY (`id_historia_clinica`),
  ADD KEY `id_internacion` (`id_internacion`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `internacion`
--
ALTER TABLE `internacion`
  ADD PRIMARY KEY (`id_internacion`),
  ADD KEY `id_paciente` (`id_paciente`),
  ADD KEY `id_habitacion` (`id_habitacion`);

--
-- Indices de la tabla `medicamento`
--
ALTER TABLE `medicamento`
  ADD PRIMARY KEY (`id_medicamento`);

--
-- Indices de la tabla `medico`
--
ALTER TABLE `medico`
  ADD PRIMARY KEY (`id_empleado`),
  ADD UNIQUE KEY `matricula` (`matricula`),
  ADD KEY `id_departamento` (`id_departamento`);

--
-- Indices de la tabla `obra_social`
--
ALTER TABLE `obra_social`
  ADD PRIMARY KEY (`id_obra_social`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`id_paciente`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `id_obra_social` (`id_obra_social`);

--
-- Indices de la tabla `registro_medicacion`
--
ALTER TABLE `registro_medicacion`
  ADD PRIMARY KEY (`id_registro_medicacion`),
  ADD KEY `id_internacion` (`id_internacion`),
  ADD KEY `id_medicamento` (`id_medicamento`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `stock_medicamentos`
--
ALTER TABLE `stock_medicamentos`
  ADD PRIMARY KEY (`id_stock`),
  ADD KEY `id_medicamento` (`id_medicamento`);

--
-- Indices de la tabla `turno`
--
ALTER TABLE `turno`
  ADD PRIMARY KEY (`id_turno`),
  ADD KEY `id_paciente` (`id_paciente`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `id_empleado` (`id_empleado`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD KEY `id_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `departamento`
--
ALTER TABLE `departamento`
  MODIFY `id_departamento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `id_empleado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `habitacion`
--
ALTER TABLE `habitacion`
  MODIFY `id_habitacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  MODIFY `id_historia_clinica` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `internacion`
--
ALTER TABLE `internacion`
  MODIFY `id_internacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `medicamento`
--
ALTER TABLE `medicamento`
  MODIFY `id_medicamento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `obra_social`
--
ALTER TABLE `obra_social`
  MODIFY `id_obra_social` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `id_paciente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `registro_medicacion`
--
ALTER TABLE `registro_medicacion`
  MODIFY `id_registro_medicacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `stock_medicamentos`
--
ALTER TABLE `stock_medicamentos`
  MODIFY `id_stock` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `turno`
--
ALTER TABLE `turno`
  MODIFY `id_turno` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`);

--
-- Filtros para la tabla `historia_clinica`
--
ALTER TABLE `historia_clinica`
  ADD CONSTRAINT `historia_clinica_ibfk_1` FOREIGN KEY (`id_internacion`) REFERENCES `internacion` (`id_internacion`),
  ADD CONSTRAINT `historia_clinica_ibfk_2` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`);

--
-- Filtros para la tabla `internacion`
--
ALTER TABLE `internacion`
  ADD CONSTRAINT `internacion_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
  ADD CONSTRAINT `internacion_ibfk_2` FOREIGN KEY (`id_habitacion`) REFERENCES `habitacion` (`id_habitacion`);

--
-- Filtros para la tabla `medico`
--
ALTER TABLE `medico`
  ADD CONSTRAINT `medico_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  ADD CONSTRAINT `medico_ibfk_2` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`id_obra_social`) REFERENCES `obra_social` (`id_obra_social`);

--
-- Filtros para la tabla `registro_medicacion`
--
ALTER TABLE `registro_medicacion`
  ADD CONSTRAINT `registro_medicacion_ibfk_1` FOREIGN KEY (`id_internacion`) REFERENCES `internacion` (`id_internacion`),
  ADD CONSTRAINT `registro_medicacion_ibfk_2` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`),
  ADD CONSTRAINT `registro_medicacion_ibfk_3` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`);

--
-- Filtros para la tabla `stock_medicamentos`
--
ALTER TABLE `stock_medicamentos`
  ADD CONSTRAINT `stock_medicamentos_ibfk_1` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`);

--
-- Filtros para la tabla `turno`
--
ALTER TABLE `turno`
  ADD CONSTRAINT `turno_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
  ADD CONSTRAINT `turno_ibfk_2` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  ADD CONSTRAINT `usuario_ibfk_2` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
