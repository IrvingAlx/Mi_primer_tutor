DROP DATABASE IF EXISTS mi_primer_tutor;
CREATE DATABASE mi_primer_tutor;
USE mi_primer_tutor;

CREATE TABLE `Usuarios` (
  `id_usuario` VARCHAR(255),
  `nombre_usuario` varchar(100) NOT NULL,
  `contrasena` varchar(100) NOT NULL,
  `tipo_usuario` varchar(10) NOT NULL,
  PRIMARY KEY (`id_usuario`)
); 

CREATE TABLE `Padres` (
  `id_padre` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `id_usuario` VARCHAR(255) NOT NULL,  -- Cambiado a VARCHAR(255)
  PRIMARY KEY (`id_padre`),
  KEY `id_usuario` (`id_usuario`),
  FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE
);

CREATE TABLE `Profesores` (
  `id_profesor` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `id_usuario` VARCHAR(255) NOT NULL,  -- Cambiado a VARCHAR(255)
  PRIMARY KEY (`id_profesor`),
  KEY `id_usuario` (`id_usuario`),
  FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE
);
  

CREATE TABLE `Alumnos` (
  `id_alumno` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `id_usuario` int NOT NULL,
  `id_padre` int DEFAULT NULL,
  `id_profesor` int DEFAULT NULL,
  PRIMARY KEY (`id_alumno`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_padre` (`id_padre`),
  KEY `id_profesor` (`id_profesor`),
  FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE,
  FOREIGN KEY (`id_padre`) REFERENCES `Padres` (`id_padre`) ON DELETE CASCADE,
  FOREIGN KEY (`id_profesor`) REFERENCES `Profesores` (`id_profesor`) ON DELETE CASCADE
);

CREATE TABLE `Niveles` (
  `id_nivel` int NOT NULL AUTO_INCREMENT,
  `area` varchar(20) NOT NULL,
  `numero_nivel` int NOT NULL,
  PRIMARY KEY (`id_nivel`)
);

CREATE TABLE `Preguntas` (
  `id_pregunta` int NOT NULL AUTO_INCREMENT,
  `numero_pregunta` int NOT NULL,
  `nombre_imagen` varchar(100) NOT NULL,
  `respuesta_correcta` char(1) NOT NULL,
  `respuesta_incorrecta_1` char(1) NOT NULL,
  `respuesta_incorrecta_2` char(1) NOT NULL,
  `respuesta_incorrecta_3` char(1) NOT NULL,
  `id_nivel` int NOT NULL,
  PRIMARY KEY (`id_pregunta`),
  KEY `id_nivel` (`id_nivel`),
  FOREIGN KEY (`id_nivel`) REFERENCES `Niveles` (`id_nivel`) ON DELETE CASCADE
); 



CREATE TABLE `Puntuacion` (
  `id_puntuacion` int NOT NULL AUTO_INCREMENT,
  `fecha_completado` date NOT NULL,
  `puntos_acumulados` int NOT NULL,
  `id_alumno` int NOT NULL,
  `id_nivel` int NOT NULL,
  PRIMARY KEY (`id_puntuacion`),
  KEY `id_nivel` (`id_nivel`),
  KEY `id_alumno` (`id_alumno`),
  FOREIGN KEY (`id_nivel`) REFERENCES `Niveles` (`id_nivel`) ON DELETE CASCADE,
  FOREIGN KEY (`id_alumno`) REFERENCES `Alumnos` (`id_alumno`) ON DELETE CASCADE
); 
