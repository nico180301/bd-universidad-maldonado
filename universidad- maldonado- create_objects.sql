-- create_objects.sql
-- Schema, tables, views, functions, stored procedures and triggers for 'universidad' DB
DROP SCHEMA IF EXISTS universidad;
CREATE SCHEMA universidad;
USE universidad;

-- Tablas (singular)
CREATE TABLE anio_materia (
  id_anio INT NOT NULL PRIMARY KEY
) ENGINE=InnoDB;

CREATE TABLE profesor (
  id_profesor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE estudiante (
  id_estudiante INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE materia (
  id_materia INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  id_anio INT NOT NULL,
  FOREIGN KEY (id_anio) REFERENCES anio_materia(id_anio)
) ENGINE=InnoDB;

CREATE TABLE inscripcion (
  id_inscripcion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_estudiante INT NOT NULL,
  id_anio INT NOT NULL,
  fecha DATE NOT NULL,
  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
  FOREIGN KEY (id_anio) REFERENCES anio_materia(id_anio)
) ENGINE=InnoDB;

CREATE TABLE gestion (
  id_gestion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_estudiante INT NOT NULL,
  id_materia INT NOT NULL,
  id_profesor INT NOT NULL,
  id_anio INT NOT NULL,
  estado TINYINT NOT NULL DEFAULT 1, -- 1=activo, 0=inactivo
  fecha DATE NOT NULL,
  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
  FOREIGN KEY (id_materia) REFERENCES materia(id_materia),
  FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
  FOREIGN KEY (id_anio) REFERENCES anio_materia(id_anio)
) ENGINE=InnoDB;

-- Tabla de auditoría para triggers
CREATE TABLE gestion_audit (
  id_audit INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_gestion INT NOT NULL,
  accion VARCHAR(20) NOT NULL,
  accion_fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================
-- VISTAS (3 vistas con joins/filtrado/agrupaciones)
-- =====================

CREATE OR REPLACE VIEW vw_estudiante_inscripciones AS
SELECT
  i.id_inscripcion,
  e.id_estudiante,
  CONCAT(e.nombre,' ',e.apellido) AS nombre_completo,
  e.email,
  i.id_anio,
  i.fecha
FROM inscripcion i
JOIN estudiante e ON e.id_estudiante = i.id_estudiante
WHERE i.fecha >= '2023-01-01';

CREATE OR REPLACE VIEW vw_materia_profesor_carga AS
SELECT
  m.id_materia,
  m.nombre AS materia,
  p.id_profesor,
  CONCAT(p.nombre,' ',p.apellido) AS profesor,
  COUNT(g.id_gestion) AS alumnos_inscriptos
FROM materia m
LEFT JOIN gestion g ON g.id_materia = m.id_materia
LEFT JOIN profesor p ON p.id_profesor = g.id_profesor
GROUP BY m.id_materia, p.id_profesor, m.nombre, p.id_profesor, p.nombre, p.apellido;

CREATE OR REPLACE VIEW vw_profesores_multiples_materias AS
SELECT
  p.id_profesor,
  CONCAT(p.nombre,' ',p.apellido) AS profesor,
  p.email,
  COUNT(DISTINCT g.id_materia) AS materias_distintas
FROM profesor p
JOIN gestion g ON g.id_profesor = p.id_profesor AND g.estado = 1
GROUP BY p.id_profesor, p.nombre, p.apellido, p.email
HAVING COUNT(DISTINCT g.id_materia) > 1;

-- =====================
-- FUNCIONES (retornan un único valor cada una)
-- =====================

DELIMITER //
CREATE FUNCTION fn_cantidad_materias_por_anio(p_anio INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_count INT;
  SELECT COUNT(*) INTO v_count FROM materia WHERE id_anio = p_anio;
  RETURN IFNULL(v_count,0);
END;
//

CREATE FUNCTION fn_total_inscripciones_estudiante(p_estudiante INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_total INT;
  SELECT COUNT(*) INTO v_total FROM inscripcion WHERE id_estudiante = p_estudiante;
  RETURN IFNULL(v_total,0);
END;
//
DELIMITER ;

-- =====================
-- STORED PROCEDURES (devuelven conjuntos de filas)
-- =====================

DELIMITER //
CREATE PROCEDURE sp_listar_materias_por_profesor(IN p_profesor INT)
BEGIN
  SELECT
    m.id_materia,
    m.nombre AS materia,
    m.id_anio,
    COUNT(g.id_gestion) AS cantidad_alumnos
  FROM materia m
  JOIN gestion g ON g.id_materia = m.id_materia
  WHERE g.id_profesor = p_profesor
  GROUP BY m.id_materia, m.nombre, m.id_anio
  ORDER BY cantidad_alumnos DESC;
END;
//

CREATE PROCEDURE sp_listar_estudiantes_por_materia(IN p_materia INT)
BEGIN
  SELECT
    e.id_estudiante,
    CONCAT(e.nombre,' ',e.apellido) AS estudiante,
    e.email,
    g.estado,
    g.fecha AS fecha_inscripcion_a_materia
  FROM gestion g
  JOIN estudiante e ON e.id_estudiante = g.id_estudiante
  WHERE g.id_materia = p_materia
  ORDER BY e.apellido, e.nombre;
END;
//
DELIMITER ;

-- =====================
-- TRIGGERS (2 ejemplos)
-- =====================

DELIMITER //
CREATE TRIGGER trg_before_insert_estudiante
BEFORE INSERT ON estudiante
FOR EACH ROW
BEGIN
  SET NEW.email = LOWER(TRIM(NEW.email));
  -- validación simple: debe contener una arroba
  IF NEW.email NOT LIKE '%@%' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email inválido para estudiante';
  END IF;
END;
//

CREATE TRIGGER trg_after_insert_gestion
AFTER INSERT ON gestion
FOR EACH ROW
BEGIN
  INSERT INTO gestion_audit (id_gestion, accion) VALUES (NEW.id_gestion, 'INSERT');
END;
//
DELIMITER ;
