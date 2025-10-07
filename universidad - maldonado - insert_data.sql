USE universidad;

-- 1) anios (1..6)
INSERT INTO anio_materia (id_anio) VALUES (1),(2),(3),(4),(5),(6);

-- 2) profesores (10)
INSERT INTO profesor (id_profesor, nombre, apellido, email) VALUES
(1,'Lucia','Gomez','lucia.gomez@uni.edu'),
(2,'Martin','Rodriguez','martin.rodriguez@uni.edu'),
(3,'Carolina','Perez','carolina.perez@uni.edu'),
(4,'Diego','Lopez','diego.lopez@uni.edu'),
(5,'Ana','Martinez','ana.martinez@uni.edu'),
(6,'Santiago','Diaz','santiago.diaz@uni.edu'),
(7,'Mariana','Torres','mariana.torres@uni.edu'),
(8,'Federico','Ramos','federico.ramos@uni.edu'),
(9,'Veronica','Silva','veronica.silva@uni.edu'),
(10,'Pablo','Mendoza','pablo.mendoza@uni.edu');

-- 3) estudiantes (10)
INSERT INTO estudiante (id_estudiante, nombre, apellido, email) VALUES
(1,'Juan','Perez','juan.perez@student.uni.edu'),
(2,'Maria','Lopez','maria.lopez@student.uni.edu'),
(3,'Jose','Garcia','jose.garcia@student.uni.edu'),
(4,'Laura','Fernandez','laura.fernandez@student.uni.edu'),
(5,'Diego','Alvarez','diego.alvarez@student.uni.edu'),
(6,'Sofia','Ramirez','sofia.ramirez@student.uni.edu'),
(7,'Lucas','Vargas','lucas.vargas@student.uni.edu'),
(8,'Valentina','Suarez','valentina.suarez@student.uni.edu'),
(9,'Martin','Castro','martin.castro@student.uni.edu'),
(10,'Camila','Herrera','camila.herrera@student.uni.edu');

-- 4) materias (12)
INSERT INTO materia (id_materia, nombre, id_anio) VALUES
(1,'Programacion I',1),
(2,'Algebra Lineal',1),
(3,'Matematica I',1),
(4,'Algoritmos',2),
(5,'Estructuras de Datos',2),
(6,'Sistemas Operativos',3),
(7,'Base de Datos',3),
(8,'Redes',4),
(9,'Ingenieria y Sociedad',1),
(10,'Analisis Matematico II',2),
(11,'Inteligencia Artificial',5),
(12,'Seguridad Informatica',4);

-- 5) inscripciones (10)
INSERT INTO inscripcion (id_inscripcion, id_estudiante, id_anio, fecha) VALUES
(1,1,1,'2025-03-01'),
(2,2,1,'2025-03-02'),
(3,3,2,'2025-03-05'),
(4,4,2,'2025-03-06'),
(5,5,3,'2025-03-07'),
(6,6,3,'2025-03-08'),
(7,7,4,'2025-03-09'),
(8,8,5,'2025-03-10'),
(9,9,1,'2025-03-11'),
(10,10,2,'2025-03-12');

-- 6) gestion (12)
INSERT INTO gestion (id_gestion, id_estudiante, id_materia, id_profesor, id_anio, estado, fecha) VALUES
(1,1,1,1,1,1,'2025-03-15'),
(2,1,2,2,1,1,'2025-03-16'),
(3,2,1,1,1,1,'2025-03-15'),
(4,3,4,3,2,1,'2025-03-20'),
(5,4,5,4,2,1,'2025-03-21'),
(6,5,6,5,3,1,'2025-03-22'),
(7,6,7,6,3,1,'2025-03-23'),
(8,7,8,7,4,1,'2025-03-24'),
(9,8,11,8,5,1,'2025-03-25'),
(10,9,3,9,1,1,'2025-03-26'),
(11,10,4,10,2,1,'2025-03-27'),
(12,2,5,4,2,1,'2025-03-28');
