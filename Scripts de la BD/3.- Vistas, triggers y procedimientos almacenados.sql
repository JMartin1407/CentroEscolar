use CentroEscolar
DROP VIEW vGradosConGrupos;
-- =========================================
--               Vistas
-- ========================================
select * from horario
-- Vista única para detallar Horarios, incluyendo datos de Grupo, Grado, Profesor y Materia.
CREATE VIEW vHorariosDetallados AS
SELECT
    h.ID_Horario,
    h.Fecha,
    h.Hora_inicio,
    h.Hora_fin,
    g.ID_Grupo,
    g.Nombre AS Grupo,
    gr.ID_Grado,
    gr.Nombre_grado AS Grado,
    gr.Nombre_nivel AS Nivel,
    m.ID_Materia,
    m.Nombre AS Materia,
    p.ID_Profesor,
    p.Nombre AS NombreProfesor,
    p.Apellido_Paterno AS ApellidoPaternoProfesor
FROM Horario h
JOIN Grupo g ON h.ID_Grupo = g.ID_Grupo
JOIN Grado gr ON h.ID_Grado = gr.ID_Grado
JOIN Materia m ON h.ID_Materia = m.ID_Materia
JOIN Profesor p ON h.ID_Profesor = p.ID_Profesor;

-- Vista para detallar Grupos con información de su Grado y el total de alumnos y profesores.
CREATE VIEW vGruposDetallados AS
SELECT
    g.ID_Grupo,
    g.Nombre AS NombreGrupo,
    gr.ID_Grado,
    gr.Nombre_grado AS NombreGrado,
    gr.Nombre_nivel as NombreNivel
FROM Grupo g
JOIN Grado gr ON g.ID_Grado = gr.ID_Grado;

-- Vista para detallar Grados con el número total de grupos.
CREATE VIEW vGradoConGrupos AS
SELECT 
    gr.ID_Grado   AS id_grado,
    gr.Nombre_grado AS NombreGrado,
    gr.Nombre_nivel AS NombreNivel
FROM Grado gr;

-- ====================================================
--                  Triggers
-- ====================================================
DELIMITER //

-- Trigger consolidado para validar el nombre del Grupo antes de la inserción o actualización.
CREATE TRIGGER tg_validar_nombre_grupo_insert BEFORE INSERT ON Grupo
FOR EACH ROW
BEGIN
    IF NEW.Nombre IS NULL OR TRIM(NEW.Nombre) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del grupo no puede estar vacío.';
    END IF;
    IF EXISTS (SELECT 1 FROM Grupo WHERE Nombre = NEW.Nombre AND ID_Grado = NEW.ID_Grado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un grupo con ese nombre en el mismo grado.';
    END IF;
END;
//

-- Trigger para validar horarios antes de la inserción.
DELIMITER //
CREATE TRIGGER tg_validar_horario_insert BEFORE INSERT ON Horario
FOR EACH ROW
BEGIN
    -- Validar que la hora de inicio sea menor que la de fin.
    IF NEW.Hora_inicio >= NEW.Hora_fin THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La hora de inicio debe ser menor que la hora de fin.';
    END IF;

    -- Validar solapamiento de horario para el mismo grupo.
    IF EXISTS (
        SELECT 1 FROM Horario
        WHERE Fecha = NEW.Fecha
          AND ID_Grupo = NEW.ID_Grupo
          AND (
              (NEW.Hora_inicio BETWEEN Hora_inicio AND Hora_fin)
              OR (NEW.Hora_fin BETWEEN Hora_inicio AND Hora_fin)
              OR (Hora_inicio BETWEEN NEW.Hora_inicio AND NEW.Hora_fin)
          )
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El grupo ya tiene un horario asignado en ese rango de horas.';
    END IF;

    -- Validar solapamiento de horario para el mismo profesor.
    IF EXISTS (
        SELECT 1 FROM Horario
        WHERE Fecha = NEW.Fecha
          AND ID_Profesor = NEW.ID_Profesor
          AND (
              (NEW.Hora_inicio BETWEEN Hora_inicio AND Hora_fin)
              OR (NEW.Hora_fin BETWEEN Hora_inicio AND Hora_fin)
              OR (Hora_inicio BETWEEN NEW.Hora_inicio AND NEW.Hora_fin)
          )
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor ya tiene un horario asignado en ese rango de horas.';
    END IF;
END;
//

-- Trigger para validar el nombre del Grado antes de la inserción.
DELIMITER //
CREATE TRIGGER tg_validar_nombre_grado BEFORE INSERT ON Grado
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Grado WHERE Nombre_grado = NEW.Nombre_grado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un grado con ese nombre.';
    END IF;
END;
//
DELIMITER ;
-- ====================================================================
--                 Procedimiento almacenados
-- ====================================================================
DELIMITER //

-- Procedimiento para crear un nuevo Grado con validación de existencia.
CREATE PROCEDURE sp_crear_grado(
    IN pID INT,
    IN pNombre VARCHAR(30),
    IN pNivel VARCHAR(30)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Grado WHERE Nombre_grado = pNombre AND Nombre_nivel = pNivel) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un grado con ese nombre y nivel.';
    ELSE
        INSERT INTO Grado (ID_Grado, Nombre_grado, Nombre_nivel)
        VALUES (pID, pNombre, pNivel);
    END IF;
END;
//

-- Procedimiento para consultar Grados (todos o por ID)
CREATE PROCEDURE sp_consultar_grados(
    IN pID INT
)
BEGIN
    IF pID IS NULL THEN
        SELECT * FROM vGradosConGrupos;
    ELSE
        IF NOT EXISTS (SELECT 1 FROM Grado WHERE ID_Grado = pID) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El grado especificado no existe.';
        ELSE
            SELECT * FROM vGradosConGrupos WHERE ID_Grado = pID;
        END IF;
    END IF;
END;
//

-- Procedimiento para crear un nuevo Grupo con validación de grado.
CREATE PROCEDURE sp_crear_grupo(
    IN pID INT,
    IN pNombre VARCHAR(30),
    IN pGrado INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Grado WHERE ID_Grado = pGrado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El grado especificado no existe.';
    ELSE
        INSERT INTO Grupo (ID_Grupo, Nombre, ID_Grado)
        VALUES (pID, pNombre, pGrado);
    END IF;
END;
//

-- Procedimiento para consultar Grupos (todos o por ID)
CREATE PROCEDURE sp_consultar_grupos(
    IN pID INT
)
BEGIN
    IF pID IS NULL THEN
        SELECT * FROM vGruposDetallados;
    ELSE
        IF NOT EXISTS (SELECT 1 FROM Grupo WHERE ID_Grupo = pID) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El grupo especificado no existe.';
        ELSE
            SELECT * FROM vGruposDetallados WHERE ID_Grupo = pID;
        END IF;
    END IF;
END;
//

-- Procedimiento para crear un nuevo Horario con validaciones.
DELIMITER //
CREATE PROCEDURE sp_crear_horario(
    IN pID INT,
    IN pFecha DATE,
    IN pInicio TIME,
    IN pFin TIME,
    IN pGrupo INT,
    IN pProfesor INT,
    IN pGrado INT,
    IN pMateria INT
)
BEGIN
    -- Validar que los IDs existan en sus respectivas tablas.
    IF NOT EXISTS (SELECT 1 FROM Grupo WHERE ID_Grupo = pGrupo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El grupo especificado no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM Profesor WHERE ID_Profesor = pProfesor) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor especificado no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM Grado WHERE ID_Grado = pGrado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El grado especificado no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM Materia WHERE ID_Materia = pMateria) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La materia especificada no existe.';
    ELSE
        -- Insertar el nuevo registro en la tabla Horario.
        INSERT INTO Horario (ID_Horario, Fecha, Hora_inicio, Hora_fin, ID_Grupo, ID_Profesor, ID_Grado, ID_Materia)
        VALUES (pID, pFecha, pInicio, pFin, pGrupo, pProfesor, pGrado, pMateria);
    END IF;
END;
//

-- Procedimiento para consultar Horarios (por ID, grupo, profesor o grado)
CREATE PROCEDURE sp_consultar_horarios(
    IN pID INT,
    IN pGrupo INT,
    IN pProfesor INT,
    IN pGrado INT
)
BEGIN
    IF pID IS NOT NULL THEN
        SELECT * FROM vHorariosDetallados WHERE ID_Horario = pID;
    ELSEIF pGrupo IS NOT NULL THEN
        SELECT * FROM vHorariosDetallados WHERE ID_Grupo = pGrupo;
    ELSEIF pProfesor IS NOT NULL THEN
        SELECT * FROM vHorariosDetallados WHERE ID_Profesor = pProfesor;
    ELSEIF pGrado IS NOT NULL THEN
        SELECT * FROM vHorariosDetallados WHERE ID_Grado = pGrado;
    ELSE
        SELECT * FROM vHorariosDetallados;
    END IF;
END;
//

-- Procedimiento para eliminar un Horario por ID.
CREATE PROCEDURE sp_eliminar_horario(
    IN pID INT
)
BEGIN
    DELETE FROM Horario WHERE ID_Horario = pID;
END;
//

DELIMITER ;
-- =====================================================================
-- Creacion de Usuario admin
-- =====================================================================
CREATE USER 'adminEscolar'@'localhost' IDENTIFIED BY 'Admin2025';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.grupo TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.grado TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.horario TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.alumno TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.conducta TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.kardex TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.materia TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.modalidad TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.profesor TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.padre_tutor TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON CentroEscolar.tutoria TO 'adminEscolar'@'localhost';
GRANT SELECT, INSERT, UPDATE,DELETE ON CentroEscolar.admin TO 'adminEscolar'@'localhost';
GRANT SELECT ON vHorariosDetallados TO 'adminEscolar'@'localhost' ;
GRANT SELECT ON  vGruposDetallados TO 'adminEscolar'@'localhost' ;
GRANT SELECT ON  vGradosConGrupos TO 'adminEscolar'@'localhost' ;
FLUSH PRIVILEGES;

SELECT user, host FROM mysql.user WHERE user = 'adminEscolar';

DROP USER 'adminEscolar'@'%';
FLUSH PRIVILEGES;