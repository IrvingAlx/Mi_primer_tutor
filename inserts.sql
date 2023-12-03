USE mi_primer_tutor3;

INSERT INTO Niveles (area, numero_nivel) VALUES ('espanol', 1);
INSERT INTO Niveles (area, numero_nivel) VALUES ('espanol', 2);
INSERT INTO Niveles (area, numero_nivel) VALUES ('ingles', 1);
INSERT INTO Niveles (area, numero_nivel) VALUES ('ingles', 2);
INSERT INTO Niveles (area, numero_nivel) VALUES ('matematicas', 1);
INSERT INTO Niveles (area, numero_nivel) VALUES ('matematicas', 2);
INSERT INTO Niveles (area, numero_nivel) VALUES ('lenguaje', 1);
INSERT INTO Niveles (area, numero_nivel) VALUES ('lenguaje', 2);
INSERT INTO Niveles (area, numero_nivel) VALUES ('general', 1);
INSERT INTO Niveles (area, numero_nivel) VALUES ('general', 2);


INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (1, 'espanol1', 'd', 1);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (2, 'espanol2', 'a', 1);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (3, 'espanol3', 'c', 1);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (1, 'espanol1', 'd', 2);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (2, 'espanol2', 'a', 2);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (3, 'espanol3', 'c', 2);

INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (1, 'ingles1', 'a', 3);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (2, 'ingles2', 'b', 3);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (3, 'ingles3', 'd', 3);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (1, 'ingles1', 'a', 4);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (2, 'ingles2', 'b', 4);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (3, 'ingles3', 'd', 4);

INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (1, 'matematicas1', 'c', 5);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (2, 'matematicas2', 'a', 5);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (3, 'matematicas3', 'd', 5);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (1, 'matematicas1', 'c', 6);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (2, 'matematicas2', 'a', 6);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (3, 'matematicas3', 'd', 6);


INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (1, 'general1', 'd', 9);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (2, 'general2', 'b', 9);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (3, 'general3', 'c', 9);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (1, 'general1', 'd', 10);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (2, 'general2', 'b', 10);
INSERT INTO Preguntas (numero_pregunta, nombre_imagen, respuesta_correcta, id_nivel) VALUES (3, 'general3', 'c', 10);