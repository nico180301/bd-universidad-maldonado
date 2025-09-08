CREATE SCHEMA universidad;
USE universidad;

-- Tabla Estudiantes
CREATE TABLE estudiantes (
  id_estudiantes INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla Profesores
CREATE TABLE profesores (
  id_profesor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla AñosMateria
CREATE TABLE anios_materia (
  id_anio INT NOT NULL,  -- 1 a 6
  PRIMARY KEY (id_anio)
);

-- Tabla Materias
CREATE TABLE materias (
  id_materia INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  id_anio INT NOT NULL,
  FOREIGN KEY (id_anio) REFERENCES anios_materia(id_anio)
);

-- Tabla Inscripciones
CREATE TABLE inscripciones (
  id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
  id_estudiantes INT NOT NULL,
  id_anio INT NOT NULL,
  fecha DATE NOT NULL,
  FOREIGN KEY (id_estudiantes) REFERENCES estudiantes(id_estudiantes),
  FOREIGN KEY (id_anio) REFERENCES anios_materia(id_anio)
);

-- Tabla Gestion
CREATE TABLE gestion (
  id_gestion INT PRIMARY KEY AUTO_INCREMENT,
  id_estudiantes INT NOT NULL,
  id_materia INT NOT NULL,
  id_profesor INT NOT NULL,
  id_anio INT NOT NULL,
  estado TINYINT NOT NULL DEFAULT 1, -- 1=activo, 0=inactivo
  fecha DATE NOT NULL,
  FOREIGN KEY (id_estudiantes) REFERENCES estudiantes(id_estudiantes),
  FOREIGN KEY (id_materia) REFERENCES materias(id_materia),
  FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor),
  FOREIGN KEY (id_anio) REFERENCES anios_materia(id_anio)
);

-- Precarga de los años de la carrera (1 a 6)
INSERT INTO anios_materia (id_anio) VALUES (1),(2),(3),(4),(5),(6);