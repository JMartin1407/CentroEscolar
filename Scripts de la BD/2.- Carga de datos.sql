use CentroEducativo

INSERT INTO Modalidad (ID_Modalidad, Nombre) VALUES
(1, 'Secundaria'),
(2, 'Preparatoria'),
(3, 'Prepa-mixta');
select * from modalidad

INSERT INTO Grado (ID_Grado, Nombre_grado, Nombre_nivel) VALUES
(1, '1ro', 'Secundaria'),
(2, '2do', 'Secundaria'),
(3, '3ro', 'Secundaria'),
(4, '1ro', 'Preparatoria'),
(5, '2do', 'Preparatoria'),
(6, '3ro', 'Preparatoria');
select * from grado

INSERT INTO Grupo (ID_Grupo, Nombre, ID_Grado) VALUES
(1,'A',1),
(2,'A',2),
(3,'A',3),
(4,'A',4),
(5,'B',4),
(6,'A',5),
(7,'B',5),
(8,'A',6),
(9,'B',6);
select * from grupo

INSERT INTO Alumno (ID_Alumno, Nombre, Apellido_Paterno, Apellido_Materno, CURP, Sexo, Edad, Correo, Password, Telefono, Direccion, ID_Modalidad, ID_Grado, ID_Grupo) VALUES
(1, 'Emilio', 'Garibay', 'Sánchez', 'XYJ4B7F9T5R1P2S3V4', 'M', 18, 'egaribay@hotmaill.com', 'pass123', '3511508345', 'Paseo del Jericó #14, Zamora, Michoacán', 1, 2, 3),
(2, 'Juan', 'Hernández', 'Rodríguez', 'W2L8M5R9D6Q3S1V7F4', 'M', 18, 'juan612@example.com', 'pass123', '3516742309', 'Calle Morelos #518, Zamora, Michoacán', 1, 2, 3),
(3, 'Pedro', 'Ramírez', 'García', 'Z9K1P5D4R2T8S3F6V7', 'M', 13, 'pedro943@example.com', 'pass123', '3516350188', 'Av. 5 de Mayo #947, Zamora, Michoacán', 1, 1, 2),
(4, 'Sofia', 'Hernández', 'Rodríguez', 'P7R4F2V9T6S1M3Q8D5', 'F', 13, 'sofia311_1@example.com', 'pass123', '3519230819', 'Calle Morelos #329, Zamora, Michoacán', 1, 1, 2),
(5, 'Jorge', 'Rodríguez', 'Sánchez', 'S6V9D3Q2R5P1T8F7M4', 'M', 14, 'jorge410_1@example.com', 'pass123', '3514171586', 'Calle Hidalgo #942, Zamora, Michoacán', 1, 2, 3),
(6, 'Jorge', 'García', 'Pérez', 'F1T8V5R2P9S4M6Q7D3', 'M', 12, 'jorge009_1@example.com', 'pass123', '3510026779', 'Calle Hidalgo #6, Zamora, Michoacán', 1, 1, 1),
(7, 'Ana', 'Pérez', 'Hernández', 'D4R9S3V6F2Q1P7M8T5', 'F', 16, 'ana410_1@example.com', 'pass123', '3514171586', 'Calle Hidalgo #200, Zamora, Michoacán', 1, 2, 2),
(8, 'Maria', 'Ramírez', 'Rodríguez', 'H6B2C8D1E5G3F7J9I4', 'F', 15, 'maria410_1@example.com', 'pass123', '3514171586', 'Av. 5 de Mayo #149, Zamora, Michoacán', 1, 2, 1),
(9, 'Luisa', 'Ramírez', 'Sánchez', 'J9N5M2K8L1P4O6I3H7', 'F', 14, 'luisa410_1@example.com', 'pass123', '3514171586', 'Av. 5 de Mayo #568, Zamora, Michoacán', 1, 1, 3),
(10, 'Carmen', 'Hernández', 'Robles', 'K8L3P5O2I9H4J1N6M7', 'F', 13, 'carmen410_1@example.com', 'pass123', '3514171586', 'Calle Morelos #260, Zamora, Michoacán', 1, 1, 2);
select * from Alumno



INSERT INTO Profesor (ID_Profesor, Nombre, Apellido_Paterno, Apellido_Materno, CURP, Sexo, Edad, Correo, Password, Telefono, Direccion, Nivel_de_estudio) VALUES
(1, 'Juan', 'Perez', 'Gomez', 'M1K2L9M6N3O1P8Q7R4', 'M', 35, 'juan.perez@colegio.edu.mx', 'password123', '5551234567', 'Calle Morelos 123, Zamora, Michoacan', 'Maestria'),
(2, 'Maria', 'Hernandez', 'Ruiz', 'T2U9V6W3X1Y8Z5A7B4', 'F', 33, 'maria.hernandez@escuela.mx', 'password123', '5559876543', 'Calle 20 de Noviembre 45, Zamora, Michoacan', 'Licenciatura'),
(3, 'Roberto', 'Lopez', 'Martinez', 'C5D2E9F6G3H1I7J4K8', 'M', 39, 'roberto.lopez@academia.edu.mx', 'password123', '5556789123', 'Av. Juarez 250, Zamora, Michoacan', 'Doctorado'),
(4, 'Laura', 'Torres', 'Jimenez', 'L4M1N8O5P2Q9R6S3T7', 'F', 32, 'laura.torres@colegio.mx', 'password123', '5553456789', 'Calle Reforma 50, Zamora, Michoacan', 'Licenciatura'),
(5, 'Ricardo', 'Gomez', 'Sanchez', 'U9V6W3X1Y8Z5A7B4C2', 'M', 40, 'ricardo.gomez@universidad.mx', 'password123', '5551234987', 'Calle Independencia 100, Zamora, Michoacan', 'Maestria'),
(6, 'Gabriela', 'Diaz', 'Perez', 'D7E4F1G8H5I2J9K6L3', 'F', 34, 'gabriela.diaz@escuela.mx', 'password123', '5559871234', 'Calle Constitucion 75, Zamora, Michoacan', 'Licenciatura'),
(7, 'Jorge', 'Mendoza', 'Morales', 'M9N6O3P1Q8R5S2T4U7', 'M', 38, 'jorge.mendoza@academia.mx', 'password123', '5556785432', 'Av. Gonzalez 200, Zamora, Michoacan', 'Doctorado'),
(8, 'Sandra', 'Vazquez', 'Rodriguez', 'V4W1X8Y5Z2A9B6C3D7', 'F', 33, 'sandra.vazquez@colegio.mx', 'password123', '5553459871', 'Calle de la Paz 130, Zamora, Michoacan', 'Licenciatura'),
(9, 'Francisco', 'Ramirez', 'Castillo', 'E1F8G5H2I9J7K4L6M3', 'M', 37, 'francisco.ramirez@escuela.mx', 'password123', '5551298347', 'Av. Lazaro Cardenas 60, Zamora, Michoacan', 'Maestria'),
(10, 'Claudia', 'Aguilar', 'Medina', 'N7O4P1Q8R5S2T9U6V3', 'F', 31, 'claudia.aguilar@universidad.mx', 'password123', '5559877654', 'Calle 5 de Febrero 85, Zamora, Michoacan', 'Licenciatura');
select * from Profesor

INSERT INTO Materia (ID_Materia, Nombre) VALUES
(1, 'Matematicas I'),
(2, 'Espaniol I'),
(3, 'Biologia'),
(4, 'Historia I'),
(5, 'Geografia'),
(6, 'Formacion Civica y etica I'),
(7, 'Ingles I'),
(8, 'Tecnologia I'),
(9, 'Educacion Fisica I'),
(10, 'Artes Plasticas'),
(11, 'Matematicas II'),
(12, 'Espaniol II'),
(13, 'Historia II'),
(14, 'Formacion Civica y Etica II'),
(15, 'Ingles II'),
(16, 'Tecnologia II'),
(17, 'Educacion Fisica II'),
(18, 'Ecologia y Medio Ambiente'),
(19, 'Ciencias Sociales'),
(20, 'Fisica'),
(21, 'Matematicas III'),
(22, 'Espaniol III'),
(23, 'Historia III'),
(24, 'Ingles III'),
(25, 'Tecnologia III'),
(26, 'Educacion Fisica III'),
(27, 'Educacion para la Salud'),
(28, 'Ciencias de la Salud'),
(29, 'Quimica'),
(30, 'Tutoria'),
(31, 'Geometria'),
(32, 'Algebra'),
(33, 'Trigonometria'),
(34, 'Historia Universal'),
(35, 'Literatura Universal'),
(36, 'Filosofia'),
(37, 'Logica'),
(38, 'Economia'),
(39, 'Psicologia'),
(40, 'Ingles avanzado I'),
(41, 'Introduccion a la musica'),
(42, 'Introduccion a teatro'),
(43, 'Calculo Diferencial'),
(44, 'Probabilidad y Estadistica'),
(45, 'Temas selectos de Fisica I'),
(46, 'Temas selectos de Quimica I'),
(47, 'Historia de Mexico'),
(48, 'Literatura Mexicana'),
(49, 'Computacion avanzada'),
(50, 'Programacion Basica'),
(51, 'Sociologia'),
(52, 'Ingles avanzado II'),
(53, 'Musica'),
(54, 'Teatro'),
(55, 'Temas selectos de Fisica II'),
(56, 'Temas selectos de Quimica II'),
(57, 'Temas selectos de Biologia'),
(58, 'Calculo Integral'),
(59, 'Historia del Arte'),
(60, 'Metodos de Investigacion'),
(61, 'Derecho'),
(62, 'Etica'),
(63, 'Dibujo Tecnico'),
(64, 'Artes Visuales'),
(65, 'Teatro Avanzado'),
(66, 'Musica Avanzada');
select * from materia

INSERT INTO Padre_Tutor (ID_Padre_tutor, Nombre, Apellido_Paterno, Apellido_Materno, CURP, Estado_civil, Sexo, Edad, Correo, Password, Telefono, Direccion) VALUES
(1, 'Ismael', 'Garibay', 'Hurtado', 'GAHI740504HMNRGR02', 'Casado', 'M', 50, 'igaribay@grupoaltex.com', 'password123', '3511508209', 'Paseo del Jericó #14'),
(2, 'Verónica', 'Sánchez', 'Soriano', 'SASV780909MMNRSRO1', 'Casado', 'F', 46, 'veritosanchezs2@hotmail.com', 'password123', '3515472599', 'Paseo del Jericó #14'),
(3, 'Carmen', 'Rodríguez', 'García', 'VYDH250611IYTJOJ03', 'Casado', 'F', 55, 'carmen.rodriguez3@test.com', 'password123', '3519151147', 'Calle Morelos #518, Zamora, Michoacán'),
(4, 'Francisco', 'Hernández', 'Rodríguez', 'TSAL554418RONCGX04', 'Casado', 'M', 55, 'francisco.hernandez4@test.com', 'password123', '3518415356', 'Calle Morelos #518, Zamora, Michoacán'),
(5, 'Ana', 'García', 'Sánchez', 'ZJXN947605KXGAET05', 'Casado', 'F', 47, 'ana.garcia5@mail.com', 'password123', '3519029286', 'Av. 5 de Mayo #947, Zamora, Michoacán'),
(6, 'Pedro', 'Ramírez', 'Pérez', 'YBGN798534XSUDMV06', 'Casado', 'M', 47, 'pedro.ramirez6@mail.com', 'password123', '3513460317', 'Av. 5 de Mayo #947, Zamora, Michoacán'),
(7, 'Ana', 'Rodríguez', 'González', 'VMFA774476CPKDNW07', 'Casado', 'F', 52, 'ana.rodriguez7@example.com', 'password123', '3518596873', 'Calle Morelos #329, Zamora, Michoacán'),
(8, 'Alejandro', 'Hernández', 'Sánchez', 'VAXX924452CVJCID08', 'Casado', 'M', 52, 'alejandro.hernandez8@example.com', 'password123', '3511234567', 'Calle Morelos #329, Zamora, Michoacán'),
(9, 'Laura', 'Sánchez', 'Martínez', 'TXUY627607QFIHUV09', 'Casado', 'F', 50, 'laura.sanchez9@example.com', 'password123', '3517654321', 'Calle Hidalgo #942, Zamora, Michoacán'),
(10, 'Manuel', 'Rodríguez', 'Pérez', 'CGJY397506DAPUJV10', 'Casado', 'M', 50, 'manuel.rodriguez10@example.com', 'password123', '3519876543', 'Calle Hidalgo #942, Zamora, Michoacán');
select * from padre_tutor

INSERT INTO Tutoria (ID_Tutoria, Relacion, ID_Alumno, ID_Padre_tutor) VALUES
(1, 'Padre', 1, 1),
(2, 'Madre', 1, 2),
(3, 'Padre', 2, 3),
(4, 'Madre', 2, 4),
(5, 'Padre', 3, 5),
(6, 'Madre', 3, 6),
(7, 'Padre', 4, 7),
(8, 'Madre', 4, 8),
(9, 'Padre', 5, 9),
(10, 'Madre', 5, 10);

INSERT INTO Conducta (ID_Conducta, Mes, Anio, Clasificador, ID_Alumno) VALUES
(1, 'Septiembre', 2025, 'Excelente', 1),
(2, 'Septiembre', 2025, 'Excelente', 2),
(3, 'Octubre', 2025, 'Bueno', 3),
(4, 'Octubre', 2025, 'Bueno', 4),
(5, 'Noviembre', 2025, 'Bueno', 5),
(6, 'Noviembre', 2025, 'Regular', 6),
(7, 'Diciembre', 2025, 'Bueno', 7),
(8, 'Diciembre', 2025, 'Bueno', 8),
(9, 'Septiembre', 2025, 'Regular', 9),
(10, 'Septiembre', 2025, 'Bueno', 10);
select * from conducta

INSERT INTO Kardex (ID_Kardex, Calificacion, Mes, Anio, ID_Alumno, ID_Materia) VALUES
(1, 10, 'Enero', 2025, 6, 1),
(2, 9, 'Enero', 2025, 6, 2),
(3, 6, 'Enero', 2025, 6, 3),
(4, 6, 'Enero', 2025, 6, 4),
(5, 10, 'Enero', 2025, 6, 5),
(6, 8, 'Enero', 2025, 6, 6),
(7, 10, 'Enero', 2025, 6, 7),
(8, 6, 'Enero', 2025, 6, 8),
(9, 6, 'Enero', 2025, 6, 9),
(10, 8, 'Enero', 2025, 6, 10);
select * from kardex

INSERT INTO Horario (ID_Horario, Fecha, Hora_inicio, Hora_fin, ID_Grupo, ID_Profesor, ID_Grado, ID_Materia) VALUES
(1, '2025-09-20', '01:00:00', '02:00:00', 1, 1, 1, 1),
(2, '2025-09-20', '01:00:00', '03:00:00', 1, 1, 1, 2),
(3, '2025-09-20', '01:00:00', '05:00:00', 1, 1, 1, 3),
(4, '2025-09-20', '01:00:00', '05:00:00', 1, 1, 1, 4),
(5, '2025-09-20', '01:00:00', '10:00:00', 1, 1, 1, 5),
(6, '2025-09-20', '01:00:00', '12:00:00', 1, 1, 1, 6),
(7, '2025-09-20', '01:00:00', '06:00:00', 1, 1, 1, 7),
(8, '2025-09-20', '01:00:00', '08:00:00', 1, 2, 1, 1),
(9, '2025-09-20', '01:00:00', '09:00:00', 1, 2, 1, 2),
(10, '2025-09-20', '01:00:00', '02:00:00', 1, 2, 1, 3);
select * from horario

INSERT INTO Admin (Correo, password, rol)
VALUES ('adminEscolar', 'Admin2025', 'admin');