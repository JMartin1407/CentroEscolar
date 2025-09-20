Create database CentroEscolar
use CentroEscolar

drop database CentroEscolar

create table Modalidad(
ID_Modalidad int Primary key,
Nombre varchar(30) not null
);

CREATE TABLE Grado (
    ID_Grado INT PRIMARY KEY,
    Nombre_grado VARCHAR(30) NOT NULL,
    Nombre_nivel VARCHAR(30),
    CONSTRAINT chk_grado_nombre CHECK (CHAR_LENGTH(Nombre_grado) > 0)
);

CREATE TABLE Grupo (
    ID_Grupo INT PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    ID_Grado INT NOT NULL,
    CONSTRAINT fk_grupo_grado FOREIGN KEY (ID_Grado) REFERENCES Grado(ID_Grado) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_grupo_nombre_por_grado UNIQUE (Nombre, ID_Grado),
    CONSTRAINT chk_grupo_nombre CHECK (CHAR_LENGTH(Nombre) > 0)
);


CREATE TABLE Materia (
    ID_Materia INT PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    CONSTRAINT chk_materia_nombre CHECK (CHAR_LENGTH(Nombre) > 0)
);

CREATE TABLE Profesor (
    ID_Profesor INT PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Apellido_Paterno VARCHAR(30) NOT NULL,
    Apellido_Materno VARCHAR(30),
    CURP VARCHAR(18) NOT NULL,
    Sexo CHAR(1) NOT NULL,
    Edad INT,
    Correo VARCHAR(40) NOT NULL UNIQUE,
    Password VARCHAR(30) NOT NULL,
    Telefono VARCHAR(12),
    Direccion VARCHAR(60),
    Nivel_de_estudio VARCHAR(30),
    CONSTRAINT chk_profesor_curp_len CHECK (CHAR_LENGTH(CURP) = 18),
    CONSTRAINT chk_profesor_curp_chars CHECK (CURP REGEXP '^[A-Z0-9]{18}$'),
    CONSTRAINT chk_profesor_sexo CHECK (Sexo IN ('M','F','O')),
    CONSTRAINT chk_profesor_edad CHECK (Edad BETWEEN 18 AND 120),
    CONSTRAINT chk_profesor_tel CHECK (Telefono IS NULL OR Telefono REGEXP '^[0-9]{7,12}$'),
    CONSTRAINT chk_profesor_email_format CHECK (Correo REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_profesor_pass_len CHECK (CHAR_LENGTH(Password) >= 6)
);


CREATE TABLE Alumno (
    ID_Alumno INT PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Apellido_Paterno VARCHAR(30) NOT NULL,
    Apellido_Materno VARCHAR(30),
    CURP VARCHAR(18) NOT NULL,
    Sexo CHAR(1) NOT NULL,
    Edad INT,
    Correo VARCHAR(40) UNIQUE,
    Password VARCHAR(30),
    Telefono VARCHAR(12),
    Direccion VARCHAR(60),
    ID_Modalidad INT,
    ID_Grado INT,
    ID_Grupo INT,
    CONSTRAINT fk_alumno_modalidad FOREIGN KEY (ID_Modalidad) REFERENCES Modalidad(ID_Modalidad) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_alumno_grado FOREIGN KEY (ID_Grado) REFERENCES Grado(ID_Grado) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_alumno_grupo FOREIGN KEY (ID_Grupo) REFERENCES Grupo(ID_Grupo) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_alumno_curp_len CHECK (CHAR_LENGTH(CURP) = 18),
    CONSTRAINT chk_alumno_curp_chars CHECK (CURP REGEXP '^[A-Z0-9]{18}$'),
    CONSTRAINT chk_alumno_sexo CHECK (Sexo IN ('M','F','O')),
    CONSTRAINT chk_alumno_edad CHECK (Edad BETWEEN 12 AND 60),
    CONSTRAINT chk_alumno_tel CHECK (Telefono IS NULL OR Telefono REGEXP '^[0-9]{7,12}$'),
    CONSTRAINT chk_alumno_email_format CHECK (Correo IS NULL OR Correo REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
);

CREATE TABLE Padre_Tutor (
    ID_Padre_tutor INT PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Apellido_Paterno VARCHAR(30) NOT NULL,
    Apellido_Materno VARCHAR(30),
    CURP VARCHAR(18),
    Estado_civil VARCHAR(20),
    Sexo CHAR(1),
    Edad INT,
    Correo VARCHAR(40) UNIQUE,
    Password VARCHAR(30),
    Telefono VARCHAR(12),
    Direccion VARCHAR(60),
    CONSTRAINT chk_padre_curp_len CHECK (CURP IS NULL OR CHAR_LENGTH(CURP) = 18),
    CONSTRAINT chk_padre_curp_chars CHECK (CURP IS NULL OR CURP REGEXP '^[A-Z0-9]{18}$'),
    CONSTRAINT chk_padre_sexo CHECK (Sexo IS NULL OR Sexo IN ('M','F','O')),
    CONSTRAINT chk_padre_edad CHECK (Edad IS NULL OR (Edad BETWEEN 18 AND 120)),
    CONSTRAINT chk_padre_tel CHECK (Telefono IS NULL OR Telefono REGEXP '^[0-9]{7,12}$'),
    CONSTRAINT chk_padre_email_format CHECK (Correo IS NULL OR Correo REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')
);

CREATE TABLE Tutoria (
    ID_Tutoria INT PRIMARY KEY,
    Relacion VARCHAR(30) NOT NULL,
    ID_Alumno INT NOT NULL,
    ID_Padre_tutor INT NOT NULL,
    CONSTRAINT fk_tutoria_alumno FOREIGN KEY (ID_Alumno) REFERENCES Alumno(ID_Alumno) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tutoria_padre FOREIGN KEY (ID_Padre_tutor) REFERENCES Padre_Tutor(ID_Padre_tutor) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_tutoria_relacion CHECK (CHAR_LENGTH(Relacion) > 0)
);

CREATE TABLE Conducta (
    ID_Conducta INT PRIMARY KEY,
    Mes VARCHAR(15) NOT NULL,
    Anio YEAR NOT NULL,
    Clasificador VARCHAR(10) NOT NULL,
    ID_Alumno INT NOT NULL,
    CONSTRAINT fk_conducta_alumno FOREIGN KEY (ID_Alumno) REFERENCES Alumno(ID_Alumno) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_conducta_mes CHECK (Mes REGEXP '^[A-Za-z]{3,15}$'),
    CONSTRAINT chk_conducta_clasificador CHECK (Clasificador IN ('Excelente','Bueno','Regular','Malo'))
);

CREATE TABLE Kardex (
    ID_Kardex INT PRIMARY KEY,
    Calificacion float NOT NULL,
    Mes VARCHAR(15) NOT NULL,
    Anio YEAR NOT NULL,
    ID_Alumno INT NOT NULL,
    ID_Materia INT NOT NULL,
    CONSTRAINT fk_kardex_alumno FOREIGN KEY (ID_Alumno) REFERENCES Alumno(ID_Alumno) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_kardex_materia FOREIGN KEY (ID_Materia) REFERENCES Materia(ID_Materia) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_kardex_calificacion CHECK (Calificacion >= 0 AND Calificacion <= 10),
    CONSTRAINT chk_kardex_mes CHECK (Mes REGEXP '^[A-Za-z]{3,15}$')
);

CREATE TABLE Horario (
    ID_Horario INT PRIMARY KEY,
    Fecha date,
    Hora_inicio TIME NOT NULL,
    Hora_fin TIME NOT NULL,
    ID_Grupo INT NOT NULL,
    ID_Profesor INT NOT NULL,
    ID_Grado INT NOT NULL,
    ID_Materia INT NOT NULL,
    CONSTRAINT fk_horario_grupo FOREIGN KEY (ID_Grupo) REFERENCES Grupo(ID_Grupo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_horario_profesor FOREIGN KEY (ID_Profesor) REFERENCES Profesor(ID_Profesor) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_horario_grado FOREIGN KEY (ID_Grado) REFERENCES Grado(ID_Grado) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_horario_materia FOREIGN KEY (ID_Materia) REFERENCES Materia(ID_Materia) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_horario_horas CHECK (Hora_inicio < Hora_fin)
);

CREATE TABLE Admin (
    ID_Admin INT PRIMARY KEY AUTO_INCREMENT,
    Correo VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL DEFAULT 'admin'
);

CREATE INDEX idx_alumno_curp ON Alumno(CURP);
CREATE INDEX idx_profesor_curp ON Profesor(CURP);
CREATE INDEX idx_alumno_grupo ON Alumno(ID_Grupo);
CREATE INDEX idx_horario_profesor ON Horario(ID_Profesor);
CREATE INDEX idx_horario_grupo ON Horario(ID_Grupo);
CREATE INDEX idx_kardex_alumno ON Kardex(ID_Alumno);