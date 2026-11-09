CREATE DATABASE IF NOT EXISTS sistema_clinico
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE sistema_clinico;

-- Tablas para base de dasto

CREATE TABLE IF NOT EXISTS `auditoria_bd` (
  `id_auditoria` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tabla_afectada` varchar(100) NOT NULL,
  `id_registro` varchar(100) NOT NULL,
  `operacion` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_auditoria_tabla_fecha` (`tabla_afectada`,`fecha_hora`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `departamento` (
  `id_departamento` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `ubicacion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_departamento`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `habitacion` (
  `id_habitacion` int unsigned NOT NULL AUTO_INCREMENT,
  `numero` varchar(20) NOT NULL,
  `piso` smallint DEFAULT NULL,
  `tipo` varchar(60) NOT NULL,
  `estado` enum('DISPONIBLE','OCUPADA','MANTENIMIENTO') NOT NULL DEFAULT 'DISPONIBLE',
  PRIMARY KEY (`id_habitacion`),
  UNIQUE KEY `numero` (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `medicamento` (
  `id_medicamento` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text,
  `presentacion` enum('COMPRIMIDOS','CAPSULAS','INYECTABLES','LIQUIDOS','CREMA','GOTAS','OTROS') NOT NULL DEFAULT 'OTROS',
  `dosis` varchar(80) DEFAULT NULL COMMENT 'Concentración del producto, por ejemplo 500 mg',
  `laboratorio` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id_medicamento`),
  KEY `idx_medicamento_nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `obra_social` (
  `id_obra_social` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) NOT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') NOT NULL DEFAULT 'ACTIVA',
  PRIMARY KEY (`id_obra_social`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `rol` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `empleado` (
  `id_empleado` int unsigned NOT NULL AUTO_INCREMENT,
  `id_departamento` int unsigned NOT NULL,
  `dni` varchar(20) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `apellido` varchar(80) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `id_rol` int NOT NULL,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `dni` (`dni`),
  KEY `fk_empleado_departamento` (`id_departamento`),
  KEY `fk_empleado_rol` (`id_rol`),
  CONSTRAINT `fk_empleado_departamento` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`),
  CONSTRAINT `fk_empleado_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `paciente` (
  `id_paciente` int unsigned NOT NULL AUTO_INCREMENT,
  `id_obra_social` int unsigned DEFAULT NULL,
  `dni` varchar(20) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `apellido` varchar(80) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `sexo` varchar(20) NOT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `nacionalidad` varchar(60) DEFAULT NULL,
  `provincia` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id_paciente`),
  UNIQUE KEY `dni` (`dni`),
  KEY `fk_paciente_obra_social` (`id_obra_social`),
  CONSTRAINT `fk_paciente_obra_social` FOREIGN KEY (`id_obra_social`) REFERENCES `obra_social` (`id_obra_social`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `stock_medicamentos` (
  `id_stock` int unsigned NOT NULL AUTO_INCREMENT,
  `id_medicamento` int unsigned NOT NULL,
  `cantidad` int unsigned NOT NULL DEFAULT '0',
  `stock_minimo` int unsigned NOT NULL DEFAULT '0',
  `numero_lote` varchar(80) NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  PRIMARY KEY (`id_stock`),
  UNIQUE KEY `uq_stock_medicamento_lote` (`id_medicamento`,`numero_lote`),
  KEY `idx_stock_vencimiento` (`fecha_vencimiento`),
  CONSTRAINT `fk_stock_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `internacion` (
  `id_internacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `id_habitacion` int unsigned NOT NULL,
  `fecha_ingreso` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_alta` datetime DEFAULT NULL,
  `motivo` text NOT NULL,
  `estado` enum('ACTIVA','ALTA','CANCELADA') NOT NULL DEFAULT 'ACTIVA',
  `codigo_qr` char(36) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_internacion`),
  UNIQUE KEY `codigo_qr` (`codigo_qr`),
  KEY `idx_internacion_paciente_estado` (`id_paciente`,`estado`),
  KEY `idx_internacion_habitacion_estado` (`id_habitacion`,`estado`),
  CONSTRAINT `fk_internacion_habitacion` FOREIGN KEY (`id_habitacion`) REFERENCES `habitacion` (`id_habitacion`),
  CONSTRAINT `fk_internacion_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `medico` (
  `id_empleado` int unsigned NOT NULL,
  `matricula` varchar(50) NOT NULL,
  `especialidad` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_empleado`),
  UNIQUE KEY `matricula` (`matricula`),
  CONSTRAINT `fk_medico_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` int unsigned DEFAULT NULL,
  `id_paciente` int unsigned DEFAULT NULL,
  `contrasena` varchar(255) NOT NULL COMMENT 'Hash generado por el backend, nunca texto plano',
  `estado` varchar(20) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `id_empleado` (`id_empleado`),
  UNIQUE KEY `id_paciente` (`id_paciente`),
  CONSTRAINT `fk_usuario_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  CONSTRAINT `fk_usuario_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `consultorios` (
  `id_consultorio` int unsigned NOT NULL AUTO_INCREMENT,
  `id_empleado` int unsigned DEFAULT NULL,
  `nombre` varchar(80) NOT NULL,
  `ubicacion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_consultorio`),
  UNIQUE KEY `id_empleado` (`id_empleado`),
  CONSTRAINT `fk_consultorio_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `registro_medicacion` (
  `id_registro_medicacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_internacion` int unsigned NOT NULL,
  `id_medicamento` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Empleado que administra; validación de rol en backend',
  `id_stock` int unsigned NOT NULL,
  `fecha` date NOT NULL DEFAULT (curdate()),
  `hora` time NOT NULL DEFAULT (curtime()),
  `dosis_administrada` varchar(80) NOT NULL,
  `observaciones` text,
  PRIMARY KEY (`id_registro_medicacion`),
  KEY `fk_registro_medicamento` (`id_medicamento`),
  KEY `fk_registro_empleado` (`id_empleado`),
  KEY `fk_registro_stock` (`id_stock`),
  KEY `idx_registro_internacion_fecha` (`id_internacion`,`fecha`,`hora`),
  CONSTRAINT `fk_registro_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  CONSTRAINT `fk_registro_internacion` FOREIGN KEY (`id_internacion`) REFERENCES `internacion` (`id_internacion`),
  CONSTRAINT `fk_registro_medicamento` FOREIGN KEY (`id_medicamento`) REFERENCES `medicamento` (`id_medicamento`),
  CONSTRAINT `fk_registro_stock` FOREIGN KEY (`id_stock`) REFERENCES `stock_medicamentos` (`id_stock`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `turno` (
  `id_turno` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Médico asignado',
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `estado` varchar(255) NOT NULL,
  `motivo` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id_turno`),
  KEY `idx_turno_medico_fecha` (`id_empleado`,`fecha`,`hora`,`estado`),
  KEY `idx_turno_paciente_fecha` (`id_paciente`,`fecha`,`hora`,`estado`),
  CONSTRAINT `fk_turno_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`),
  CONSTRAINT `fk_turno_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `consulta` (
  `id_consulta` int unsigned NOT NULL AUTO_INCREMENT,
  `id_turno` int unsigned DEFAULT NULL,
  `id_paciente` int unsigned NOT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Médico que atendió',
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `motivo` varchar(250) DEFAULT NULL,
  `observaciones` text,
  PRIMARY KEY (`id_consulta`),
  UNIQUE KEY `id_turno` (`id_turno`),
  KEY `fk_consulta_medico` (`id_empleado`),
  KEY `idx_consulta_paciente_fecha` (`id_paciente`,`fecha`),
  CONSTRAINT `fk_consulta_medico` FOREIGN KEY (`id_empleado`) REFERENCES `medico` (`id_empleado`),
  CONSTRAINT `fk_consulta_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
  CONSTRAINT `fk_consulta_turno` FOREIGN KEY (`id_turno`) REFERENCES `turno` (`id_turno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `historia_clinica` (
  `id_historia_clinica` int unsigned NOT NULL AUTO_INCREMENT,
  `id_internacion` int unsigned DEFAULT NULL,
  `id_consulta` int unsigned DEFAULT NULL,
  `id_empleado` int unsigned NOT NULL COMMENT 'Empleado que registra la evolución',
  `fecha` date NOT NULL DEFAULT (curdate()),
  `hora` time NOT NULL DEFAULT (curtime()),
  `tipo_registro` enum('DIAGNOSTICO','EVOLUCION','ENFERMERIA','SIGNOS_VITALES','MEDICACION','OTRO') NOT NULL,
  `diagnostico` text,
  `tratamiento` text,
  `observaciones` text,
  PRIMARY KEY (`id_historia_clinica`),
  KEY `fk_historia_empleado` (`id_empleado`),
  KEY `idx_historia_internacion_fecha` (`id_internacion`,`fecha`,`hora`),
  KEY `idx_historia_consulta_fecha` (`id_consulta`,`fecha`,`hora`),
  CONSTRAINT `fk_historia_consulta` FOREIGN KEY (`id_consulta`) REFERENCES `consulta` (`id_consulta`),
  CONSTRAINT `fk_historia_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`),
  CONSTRAINT `fk_historia_internacion` FOREIGN KEY (`id_internacion`) REFERENCES `internacion` (`id_internacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `receta` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserto datos basicos de prueba

INSERT IGNORE INTO rol (id_rol, nombre, descripcion) VALUES
    (1, 'Medico', 'Personal médico'),
    (2, 'Enfermero', 'Personal de enfermería'),
    (3, 'Jefatura', 'Personal de jefatura'),
    (4, 'Administracion', 'Personal administrativo'),
    (5, 'Farmaceutico', 'Personal farmacéutico');

INSERT IGNORE INTO departamento (id_departamento, nombre, ubicacion) VALUES
    (1, 'Departamento de Prueba', 'Consultorio de prueba');

INSERT IGNORE INTO obra_social (id_obra_social, nombre, telefono, email, direccion, estado) VALUES
    (1, 'OSDE', NULL, NULL, NULL, 'ACTIVA'),
    (2, 'Galeno', NULL, NULL, NULL, 'ACTIVA'),
    (3, 'Swiss Medical', NULL, NULL, NULL, 'ACTIVA'),
    (4, 'OSDEPYM', NULL, NULL, NULL, 'ACTIVA'),
    (5, 'Medifé', NULL, NULL, NULL, 'ACTIVA'),
    (6, 'Sancor Salud', NULL, NULL, NULL, 'ACTIVA'),
    (7, 'OSECAC', NULL, NULL, NULL, 'ACTIVA'),
    (8, 'PAMI', NULL, NULL, NULL, 'ACTIVA'),
    (9, 'IOMA', NULL, NULL, NULL, 'ACTIVA'),
    (10, 'Unión Personal', NULL, NULL, NULL, 'ACTIVA'),
    (11, 'Medicus', NULL, NULL, NULL, 'ACTIVA'),
    (12, 'Omint', NULL, NULL, NULL, 'ACTIVA'),
    (13, 'Avalian', NULL, NULL, NULL, 'ACTIVA'),
    (14, 'Hominis', NULL, NULL, NULL, 'ACTIVA'),
    (15, 'OSUTHGRA', NULL, NULL, NULL, 'ACTIVA');

-- Carga de datops para Empleados ficticios
INSERT IGNORE INTO empleado
    (id_empleado, id_departamento, dni, nombre, apellido, estado, id_rol) VALUES
    (1, 1, '99000001', 'Sofia', 'Perexxx', 'ACTIVO', 1),
    (2, 1, '99000002', 'Liliana', 'Gonzales', 'ACTIVO', 1),
    (3, 1, '99000003', 'Leandro', 'Ibañez', 'ACTIVO', 1),
    (4, 1, '99000004', 'Faucndo', 'Sosa', 'ACTIVO', 1),
    (5, 1, '99000005', 'Damian', 'Olaso', 'ACTIVO', 1),
    (6, 1, '99000006', 'Lionel', 'Godoy', 'ACTIVO', 1);

INSERT IGNORE INTO medico (id_empleado, matricula, especialidad) VALUES
    (1, 'MAT-PRUEBA-001', 'Cardiología'),
    (2, 'MAT-PRUEBA-002', 'Oftalmología'),
    (3, 'MAT-PRUEBA-003', 'Traumatología'),
    (4, 'MAT-PRUEBA-004', 'Diagnóstico por Imágenes'),
    (5, 'MAT-PRUEBA-005', 'Flebología'),
    (6, 'MAT-PRUEBA-006', 'Endocrinología');

-- Store Procediures Y Triggers
DELIMITER //

DROP PROCEDURE IF EXISTS `AgregarPaciente`//
CREATE PROCEDURE `AgregarPaciente`(
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
END//

DROP PROCEDURE IF EXISTS `BuscarCredencialesPaciente`//
CREATE PROCEDURE `BuscarCredencialesPaciente`(IN p_dni VARCHAR(20))
BEGIN
    SELECT u.id_paciente, u.contrasena, u.estado
    FROM usuario u
    INNER JOIN paciente p ON p.id_paciente = u.id_paciente
    WHERE p.dni = p_dni
      AND u.id_paciente IS NOT NULL
    LIMIT 1;
END//

DROP PROCEDURE IF EXISTS `BuscarHistoriaClinica`//
CREATE PROCEDURE `BuscarHistoriaClinica`(IN `p_id_paciente` INT UNSIGNED)
BEGIN
 SELECT hc.id_historia_clinica, hc.fecha, hc.hora, hc.tipo_registro, hc.diagnostico, hc.tratamiento, hc.observaciones,
        'INTERNACION' AS origen, i.id_internacion AS id_origen, i.id_paciente, hc.id_empleado
 FROM Historia_Clinica hc JOIN Internacion i ON i.id_internacion=hc.id_internacion WHERE i.id_paciente=p_id_paciente
 UNION ALL
 SELECT hc.id_historia_clinica, hc.fecha, hc.hora, hc.tipo_registro, hc.diagnostico, hc.tratamiento, hc.observaciones,
        'CONSULTA' AS origen, c.id_consulta AS id_origen, c.id_paciente, hc.id_empleado
 FROM Historia_Clinica hc JOIN Consulta c ON c.id_consulta=hc.id_consulta WHERE c.id_paciente=p_id_paciente
 ORDER BY fecha DESC, hora DESC;
END//

DROP PROCEDURE IF EXISTS `BuscarPaciente`//
CREATE PROCEDURE `BuscarPaciente`(IN `p_dni` VARCHAR(20))
BEGIN
 SELECT p.*, o.nombre AS obra_social FROM Paciente p LEFT JOIN Obra_Social o ON o.id_obra_social=p.id_obra_social WHERE p.dni=p_dni;
END//

DROP PROCEDURE IF EXISTS `CrearTurno`//
CREATE PROCEDURE `CrearTurno`(IN `p_id_paciente` INT, IN `p_id_medico` INT, IN `p_fecha` DATE, IN `p_hora` TIME, IN `p_motivo` VARCHAR(250))
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
END//

DROP PROCEDURE IF EXISTS `EliminarCuentaPaciente`//
CREATE PROCEDURE `EliminarCuentaPaciente`(IN p_id_paciente INT UNSIGNED)
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
END//

DROP PROCEDURE IF EXISTS `ObtenerPacientePorId`//
CREATE PROCEDURE `ObtenerPacientePorId`(IN p_id_paciente INT UNSIGNED)
BEGIN
    SELECT
        id_paciente, id_obra_social, dni, nombre, apellido,
        fecha_nacimiento, sexo, telefono, email, direccion,
        nacionalidad, provincia
    FROM paciente
    WHERE id_paciente = p_id_paciente;
END//

DROP PROCEDURE IF EXISTS `ObtenerTurnosPaciente`//
CREATE PROCEDURE `ObtenerTurnosPaciente`(IN p_id_paciente INT UNSIGNED)
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
END//

DROP TRIGGER IF EXISTS `bi_consulta_validar`//
CREATE TRIGGER `bi_consulta_validar` BEFORE INSERT ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Turno t WHERE t.id_turno=NEW.id_turno AND t.id_paciente=NEW.id_paciente AND t.id_empleado=NEW.id_empleado AND t.estado<>'CANCELADO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente y medico deben coincidir con el turno asociado'; END IF;
END//

DROP TRIGGER IF EXISTS `ai_aud_consulta`//
CREATE TRIGGER `ai_aud_consulta` AFTER INSERT ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',NEW.id_consulta,'INSERT')//

DROP TRIGGER IF EXISTS `ai_consulta_turno`//
CREATE TRIGGER `ai_consulta_turno` AFTER INSERT ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL THEN UPDATE Turno SET estado='ATENDIDO' WHERE id_turno=NEW.id_turno; END IF;
END//

DROP TRIGGER IF EXISTS `bu_consulta_validar`//
CREATE TRIGGER `bu_consulta_validar` BEFORE UPDATE ON `consulta` FOR EACH ROW BEGIN
 IF NEW.id_turno IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Turno t WHERE t.id_turno=NEW.id_turno AND t.id_paciente=NEW.id_paciente AND t.id_empleado=NEW.id_empleado AND t.estado<>'CANCELADO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente y medico deben coincidir con el turno asociado'; END IF;
END//

DROP TRIGGER IF EXISTS `au_aud_consulta`//
CREATE TRIGGER `au_aud_consulta` AFTER UPDATE ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',NEW.id_consulta,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_consulta`//
CREATE TRIGGER `ad_aud_consulta` AFTER DELETE ON `consulta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Consulta',OLD.id_consulta,'DELETE')//

DROP TRIGGER IF EXISTS `ai_aud_departamento`//
CREATE TRIGGER `ai_aud_departamento` AFTER INSERT ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',NEW.id_departamento,'INSERT')//

DROP TRIGGER IF EXISTS `au_aud_departamento`//
CREATE TRIGGER `au_aud_departamento` AFTER UPDATE ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',NEW.id_departamento,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_departamento`//
CREATE TRIGGER `ad_aud_departamento` AFTER DELETE ON `departamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Departamento',OLD.id_departamento,'DELETE')//

DROP TRIGGER IF EXISTS `ai_aud_empleado`//
CREATE TRIGGER `ai_aud_empleado` AFTER INSERT ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',NEW.id_empleado,'INSERT')//

DROP TRIGGER IF EXISTS `au_aud_empleado`//
CREATE TRIGGER `au_aud_empleado` AFTER UPDATE ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',NEW.id_empleado,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_empleado`//
CREATE TRIGGER `ad_aud_empleado` AFTER DELETE ON `empleado` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Empleado',OLD.id_empleado,'DELETE')//

DROP TRIGGER IF EXISTS `bi_historia_origen`//
CREATE TRIGGER `bi_historia_origen` BEFORE INSERT ON `historia_clinica` FOR EACH ROW BEGIN
 IF (NEW.id_internacion IS NULL AND NEW.id_consulta IS NULL) OR (NEW.id_internacion IS NOT NULL AND NEW.id_consulta IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La historia clinica debe pertenecer a una internacion o a una consulta'; END IF;
END//

DROP TRIGGER IF EXISTS `ai_aud_historia`//
CREATE TRIGGER `ai_aud_historia` AFTER INSERT ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',NEW.id_historia_clinica,'INSERT')//

DROP TRIGGER IF EXISTS `bu_historia_origen`//
CREATE TRIGGER `bu_historia_origen` BEFORE UPDATE ON `historia_clinica` FOR EACH ROW BEGIN
 IF (NEW.id_internacion IS NULL AND NEW.id_consulta IS NULL) OR (NEW.id_internacion IS NOT NULL AND NEW.id_consulta IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La historia clinica debe pertenecer a una internacion o a una consulta'; END IF;
END//

DROP TRIGGER IF EXISTS `au_aud_historia`//
CREATE TRIGGER `au_aud_historia` AFTER UPDATE ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',NEW.id_historia_clinica,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_historia`//
CREATE TRIGGER `ad_aud_historia` AFTER DELETE ON `historia_clinica` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Historia_Clinica',OLD.id_historia_clinica,'DELETE')//

DROP TRIGGER IF EXISTS `bi_internacion_validar`//
CREATE TRIGGER `bi_internacion_validar` BEFORE INSERT ON `internacion` FOR EACH ROW BEGIN
 IF NEW.fecha_alta IS NOT NULL AND NEW.fecha_alta < NEW.fecha_ingreso THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha de alta no puede ser anterior al ingreso'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=NEW.id_habitacion AND estado='ACTIVA') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La habitacion ya tiene una internacion activa'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Habitacion WHERE id_habitacion=NEW.id_habitacion AND estado='MANTENIMIENTO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se puede internar en una habitacion en mantenimiento'; END IF;
 SET NEW.codigo_qr = COALESCE(NULLIF(NEW.codigo_qr,''), UUID());
END//

DROP TRIGGER IF EXISTS `ai_aud_internacion`//
CREATE TRIGGER `ai_aud_internacion` AFTER INSERT ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',NEW.id_internacion,'INSERT')//

DROP TRIGGER IF EXISTS `ai_internacion_habitacion`//
CREATE TRIGGER `ai_internacion_habitacion` AFTER INSERT ON `internacion` FOR EACH ROW BEGIN
 IF NEW.estado='ACTIVA' THEN UPDATE Habitacion SET estado='OCUPADA' WHERE id_habitacion=NEW.id_habitacion AND estado<>'MANTENIMIENTO'; END IF;
END//

DROP TRIGGER IF EXISTS `bu_internacion_validar`//
CREATE TRIGGER `bu_internacion_validar` BEFORE UPDATE ON `internacion` FOR EACH ROW BEGIN
 IF NEW.fecha_alta IS NOT NULL AND NEW.fecha_alta < NEW.fecha_ingreso THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La fecha de alta no puede ser anterior al ingreso'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=NEW.id_habitacion AND estado='ACTIVA' AND id_internacion<>NEW.id_internacion) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La habitacion ya tiene una internacion activa'; END IF;
 IF NEW.estado='ACTIVA' AND EXISTS(SELECT 1 FROM Habitacion WHERE id_habitacion=NEW.id_habitacion AND estado='MANTENIMIENTO') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se puede internar en una habitacion en mantenimiento'; END IF;
END//

DROP TRIGGER IF EXISTS `au_aud_internacion`//
CREATE TRIGGER `au_aud_internacion` AFTER UPDATE ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',NEW.id_internacion,'UPDATE')//

DROP TRIGGER IF EXISTS `au_internacion_habitacion`//
CREATE TRIGGER `au_internacion_habitacion` AFTER UPDATE ON `internacion` FOR EACH ROW BEGIN
 IF OLD.id_habitacion<>NEW.id_habitacion OR OLD.estado<>NEW.estado THEN
  IF OLD.estado='ACTIVA' AND NOT EXISTS(SELECT 1 FROM Internacion WHERE id_habitacion=OLD.id_habitacion AND estado='ACTIVA' AND id_internacion<>NEW.id_internacion) THEN UPDATE Habitacion SET estado='DISPONIBLE' WHERE id_habitacion=OLD.id_habitacion AND estado='OCUPADA'; END IF;
  IF NEW.estado='ACTIVA' THEN UPDATE Habitacion SET estado='OCUPADA' WHERE id_habitacion=NEW.id_habitacion AND estado<>'MANTENIMIENTO'; END IF;
 END IF;
END//

DROP TRIGGER IF EXISTS `ad_aud_internacion`//
CREATE TRIGGER `ad_aud_internacion` AFTER DELETE ON `internacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Internacion',OLD.id_internacion,'DELETE')//

DROP TRIGGER IF EXISTS `ai_aud_medicamento`//
CREATE TRIGGER `ai_aud_medicamento` AFTER INSERT ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',NEW.id_medicamento,'INSERT')//

DROP TRIGGER IF EXISTS `au_aud_medicamento`//
CREATE TRIGGER `au_aud_medicamento` AFTER UPDATE ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',NEW.id_medicamento,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_medicamento`//
CREATE TRIGGER `ad_aud_medicamento` AFTER DELETE ON `medicamento` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Medicamento',OLD.id_medicamento,'DELETE')//

DROP TRIGGER IF EXISTS `bi_medico_categoria`//
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
END//

DROP TRIGGER IF EXISTS `bu_medico_categoria`//
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
END//

DROP TRIGGER IF EXISTS `ai_aud_paciente`//
CREATE TRIGGER `ai_aud_paciente` AFTER INSERT ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',NEW.id_paciente,'INSERT')//

DROP TRIGGER IF EXISTS `au_aud_paciente`//
CREATE TRIGGER `au_aud_paciente` AFTER UPDATE ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',NEW.id_paciente,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_paciente`//
CREATE TRIGGER `ad_aud_paciente` AFTER DELETE ON `paciente` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Paciente',OLD.id_paciente,'DELETE')//

DROP TRIGGER IF EXISTS `bi_receta_validar`//
CREATE TRIGGER `bi_receta_validar` BEFORE INSERT ON `receta` FOR EACH ROW BEGIN
 IF NOT EXISTS(SELECT 1 FROM Consulta c WHERE c.id_consulta=NEW.id_consulta AND c.id_paciente=NEW.id_paciente AND c.id_empleado=NEW.id_empleado) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='La receta debe coincidir con el paciente y medico de la consulta'; END IF;
END//

DROP TRIGGER IF EXISTS `ai_aud_receta`//
CREATE TRIGGER `ai_aud_receta` AFTER INSERT ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',NEW.id_receta,'INSERT')//

DROP TRIGGER IF EXISTS `au_aud_receta`//
CREATE TRIGGER `au_aud_receta` AFTER UPDATE ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',NEW.id_receta,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_receta`//
CREATE TRIGGER `ad_aud_receta` AFTER DELETE ON `receta` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Receta',OLD.id_receta,'DELETE')//

DROP TRIGGER IF EXISTS `bi_registro_medicacion_validar`//
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
END//

DROP TRIGGER IF EXISTS `ai_aud_registro_medicacion`//
CREATE TRIGGER `ai_aud_registro_medicacion` AFTER INSERT ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',NEW.id_registro_medicacion,'INSERT')//

DROP TRIGGER IF EXISTS `ai_registro_medicacion_stock`//
CREATE TRIGGER `ai_registro_medicacion_stock` AFTER INSERT ON `registro_medicacion` FOR EACH ROW BEGIN
 UPDATE Stock_Medicamentos SET cantidad=cantidad-1 WHERE id_stock=NEW.id_stock AND cantidad>0;
END//

DROP TRIGGER IF EXISTS `au_aud_registro_medicacion`//
CREATE TRIGGER `au_aud_registro_medicacion` AFTER UPDATE ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',NEW.id_registro_medicacion,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_registro_medicacion`//
CREATE TRIGGER `ad_aud_registro_medicacion` AFTER DELETE ON `registro_medicacion` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Registro_Medicacion',OLD.id_registro_medicacion,'DELETE')//

DROP TRIGGER IF EXISTS `ai_aud_stock`//
CREATE TRIGGER `ai_aud_stock` AFTER INSERT ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',NEW.id_stock,'INSERT')//

DROP TRIGGER IF EXISTS `au_aud_stock`//
CREATE TRIGGER `au_aud_stock` AFTER UPDATE ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',NEW.id_stock,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_stock`//
CREATE TRIGGER `ad_aud_stock` AFTER DELETE ON `stock_medicamentos` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Stock_Medicamentos',OLD.id_stock,'DELETE')//

DROP TRIGGER IF EXISTS `bi_turno_disponibilidad`//
CREATE TRIGGER `bi_turno_disponibilidad` BEFORE INSERT ON `turno` FOR EACH ROW BEGIN
 IF NEW.estado<>'CANCELADO' AND EXISTS(SELECT 1 FROM Turno t WHERE t.fecha=NEW.fecha AND t.estado<>'CANCELADO' AND t.hora < ADDTIME(NEW.hora,'00:30:00') AND ADDTIME(t.hora,'00:30:00') > NEW.hora AND (t.id_empleado=NEW.id_empleado OR t.id_paciente=NEW.id_paciente)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El medico o el paciente ya tiene un turno en ese horario'; END IF;
END//

DROP TRIGGER IF EXISTS `ai_aud_turno`//
CREATE TRIGGER `ai_aud_turno` AFTER INSERT ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',NEW.id_turno,'INSERT')//

DROP TRIGGER IF EXISTS `bu_turno_disponibilidad`//
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
END//

DROP TRIGGER IF EXISTS `au_aud_turno`//
CREATE TRIGGER `au_aud_turno` AFTER UPDATE ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',NEW.id_turno,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_turno`//
CREATE TRIGGER `ad_aud_turno` AFTER DELETE ON `turno` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Turno',OLD.id_turno,'DELETE')//

DROP TRIGGER IF EXISTS `bi_usuario_relacion`//
CREATE TRIGGER `bi_usuario_relacion` BEFORE INSERT ON `usuario` FOR EACH ROW BEGIN
 IF (NEW.id_empleado IS NULL AND NEW.id_paciente IS NULL) OR (NEW.id_empleado IS NOT NULL AND NEW.id_paciente IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El usuario debe pertenecer a un empleado o a un paciente, no a ambos'; END IF;
END//

DROP TRIGGER IF EXISTS `ai_aud_usuario`//
CREATE TRIGGER `ai_aud_usuario` AFTER INSERT ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',NEW.id_usuario,'INSERT')//

DROP TRIGGER IF EXISTS `bu_usuario_relacion_update`//
CREATE TRIGGER `bu_usuario_relacion_update` BEFORE UPDATE ON `usuario` FOR EACH ROW BEGIN
 IF (NEW.id_empleado IS NULL AND NEW.id_paciente IS NULL) OR (NEW.id_empleado IS NOT NULL AND NEW.id_paciente IS NOT NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El usuario debe pertenecer a un empleado o a un paciente, no a ambos'; END IF;
END//

DROP TRIGGER IF EXISTS `au_aud_usuario`//
CREATE TRIGGER `au_aud_usuario` AFTER UPDATE ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',NEW.id_usuario,'UPDATE')//

DROP TRIGGER IF EXISTS `ad_aud_usuario`//
CREATE TRIGGER `ad_aud_usuario` AFTER DELETE ON `usuario` FOR EACH ROW INSERT INTO Auditoria_BD(tabla_afectada,id_registro,operacion) VALUES('Usuario',OLD.id_usuario,'DELETE')//

DELIMITER ;
