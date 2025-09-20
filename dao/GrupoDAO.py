from sqlmodel import Session, select
from models.GrupoModel import vGruposDetallados,grupo, Salida, EventoSalida, EventoUpdate
from models.AlumnoModel import alumno
from models.ProfesorModel import profesor
from models.HorarioModel import horario
from datetime import date

class GrupoDAO:
    def __init__(self, session:Session):
        self.session = session
    def consultar(self):
        return self.session.query(vGruposDetallados).all()
    
    def agregar(self, grupo):
        salida = Salida(estatus=False, mensaje="")
        try:
            self.session.add(grupo)
            self.session.commit()
            self.session.refresh(grupo)
            salida.estatus=True
            salida.mensaje="Grupo agregado correctamente"
            return salida
        except Exception as ex:
            self.session.rollback()
            salida.estatus=False
            salida.mensaje="Error al agregar el grupo: "
            print(ex)
        return salida
    
    def consultarPorId(self, id_Grupo: int):
        grupo = self.session.get(vGruposDetallados, id_Grupo)
        salida = EventoSalida(estatus=False, mensaje="", grupo=None)

        if grupo:
            salida.estatus = True
            salida.mensaje = f"Listado del grupo con id {id_Grupo}"
            salida.grupo = grupo
        else:
            salida.estatus = False
            salida.mensaje = f"El grupo con id {id_Grupo} no existe"
            salida.grupo = None

        return salida

    def actualizar(self, id_Grupo: int, datos_actualizados: EventoUpdate):
        salida = Salida(estatus=False, mensaje="")
        try:
            grupo_db = self.session.get(grupo, id_Grupo)
            if not grupo_db:
                salida.mensaje = f"El horario con id {id_Grupo} no existe"
                return salida
            datos_para_actualizar = datos_actualizados.dict(exclude_unset=True)
            for key, value in datos_para_actualizar.items():
                setattr(grupo_db, key, value)
            self.session.add(grupo_db)
            self.session.commit()
            self.session.refresh(grupo_db)
            salida.estatus = True
            salida.mensaje = f"El horario con id {id_Grupo} se actualizó correctamente"
        except Exception as ex:
            self.session.rollback()
            salida.estatus = False
            salida.mensaje = f"Error al actualizar el horario: {ex}"
            print(ex)    
        return salida

    def eliminar(self, id_Grupo: int):
        salida = Salida(estatus=False, mensaje="")
        try:
            horario_db = self.session.get(grupo, id_Grupo)
            if not horario_db:
                salida.mensaje = f"El horario con id {id_Grupo} no existe"
                return salida
            self.session.delete(horario_db)
            self.session.commit()
            salida.estatus = True
            salida.mensaje = f"El horario con id {id_Grupo} se eliminó correctamente"
        except Exception as ex:
            self.session.rollback()
            salida.estatus = False
            salida.mensaje = f"Error al eliminar el horario: {ex}"
            print(ex)
        return salida
    
    def asignarAlumno(self, id_Grupo: int, id_alumno: int) -> Salida:
        salida = Salida(estatus=False, mensaje="")
        alumno_db = self.session.get(alumno, id_alumno)
        grupo_db = self.session.get(grupo, id_Grupo)
        if not grupo_db:
            salida.mensaje = f"El grupo {id_Grupo} no existe"
            return salida
        if not alumno_db:
            salida.mensaje = f"El alumno {id_alumno} no existe"
            return salida

        # Verificar si el alumno ya está en otro grupo del mismo grado
        existe = self.session.query(grupo).filter(
            grupo.id_grado == grupo_db.id_grado,
            grupo.alumnos.any(id=id_alumno)  # Asumiendo relación alumnos
        ).first()
        if existe:
            salida.mensaje = f"El alumno {id_alumno} ya está asignado a otro grupo del mismo grado"
            return salida

        # Asignar alumno
        grupo_db.alumnos.append(alumno_db)
        self.session.commit()
        salida.estatus = True
        salida.mensaje = f"Alumno {id_alumno} asignado al grupo {id_Grupo} correctamente"
        return salida

    # --- ASIGNAR PROFESOR ---
    def asignarProfesor(self, id_Grupo: int, id_profesor: int) -> Salida:
        salida = Salida(estatus=False, mensaje="")
        profesor_db = self.session.get(profesor, id_profesor)
        grupo_db = self.session.get(grupo, id_Grupo)
        if not grupo_db:
            salida.mensaje = f"El grupo {id_Grupo} no existe"
            return salida
        if not profesor_db:
            salida.mensaje = f"El profesor {id_profesor} no existe"
            return salida

        # Verificar conflicto de horarios
        conflictos = self.session.query(horario).filter(
            horario.id_profesor == id_profesor,
            horario.id_grupo == id_Grupo
        ).all()
        if conflictos:
            salida.mensaje = "El profesor ya tiene un horario asignado a este grupo"
            return salida

        # Asignar profesor
        grupo_db.id_profesor = id_profesor
        self.session.commit()
        salida.estatus = True
        salida.mensaje = f"Profesor {id_profesor} asignado al grupo {id_Grupo} correctamente"
        return salida
