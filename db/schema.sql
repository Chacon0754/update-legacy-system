DROP DATABASE IF EXISTS legacy_escolar;
CREATE DATABASE legacy_escolar CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE legacy_escolar;

-- Tabla carreras

CREATE TABLE carreras (
  clave CHAR(2) NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  fecalt DATE NULL,
  fecbaj DATE NULL,
  PRIMARY KEY (clave)
) ENGINE=InnoDB;

-- Tabla materias
CREATE TABLE materias (
  clave INT NOT NULL,
  descri VARCHAR(120) NOT NULL,
  nsesio TINYINT UNSIGNED NULL,
  durses DECIMAL(4,1) NULL,
  taller BOOLEAN NULL,
  fecalt DATE NULL,
  fecbaj DATE NULL,
  tipo CHAR(1) NULL,
  PRIMARY KEY (clave)
) ENGINE=InnoDB;

-- Tabla Planes
CREATE TABLE planes (
  id INT NOT NULL AUTO_INCREMENT,
  carrer CHAR(2) NOT NULL,   
  materi INT NOT NULL, 
  semest CHAR(2) NOT NULL,
  fecalt DATE NULL,
  fecbaj DATE NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_planes (carrer, materi, semest),
  CONSTRAINT fk_planes_carrera FOREIGN KEY (carrer)
    REFERENCES carreras(clave)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Datos
INSERT INTO carreras (clave, nombre, fecalt, fecbaj) VALUES
('05','ING. EN SIST COMPUTACIONALES EN SOFTWARE','1990-07-20',NULL),
('07','ING. EN SIST COMPUTACIONALES EN HARDWARE','1995-03-06',NULL);

INSERT INTO materias (clave, descri, nsesio, durses, taller, fecalt, fecbaj, tipo) VALUES
(101,'ALGEBRA SUPERIOR',4,1.0,NULL,'1982-06-18',NULL,'L'),
(102,'MATEMATICAS I',5,1.0,NULL,'1982-06-18',NULL,'L'),
(103,'FISICA I',4,1.0,NULL,'1982-06-18',NULL,'L'),
(105,'INTRODUCCION A LA INGENIERIA',2,1.0,NULL,'1982-06-18',NULL,'L'),
(106,'DIBUJO',3,1.0,NULL,'1982-06-18',NULL,'L'),
(201,'MATEMATICAS II',5,1.0,NULL,'1982-06-18',NULL,'L'),
(202,'FISICA II',3,1.0,NULL,'1982-06-18',NULL,'L'),
(203,'ALGEBRA LINEAL',4,1.0,NULL,'1982-06-18',NULL,'L');

-- Planes para Software (05)
INSERT INTO planes (carrer, materi, semest, fecalt)
VALUES
('05',101,'01','1982-06-24'),
('05',102,'01','1982-06-25'),
('05',103,'01','1982-06-24'),
('05',201,'02','1982-06-28'),
('05',202,'02','1982-06-28'),
('05',203,'02','1982-06-28');

-- Planes para Hardware (07)
INSERT INTO planes (carrer, materi, semest, fecalt)
VALUES
('07',105,'01','1982-06-28'),
('07',106,'01','1982-06-28');


CREATE OR REPLACE VIEW v_planes_detalle AS
SELECT
  p.id,
  p.carrer,
  c.nombre AS carrera_nombre,
  p.semest,
  p.materi,
  m.descri AS materia_nombre,
  p.fecalt,
  p.fecbaj
FROM planes p
LEFT JOIN carreras c ON c.clave = p.carrer
LEFT JOIN materias m ON m.clave = p.materi
ORDER BY p.carrer, p.semest, p.materi;
