from sqlmodel import Session, select
from models.HorarioModel import vHorariosDetallados, horario, Salida, EventoSalida, EventoUpdate
from datetime import date

class HorarioDAO:
    def __init__(self, session:Session):
        self.session = session
    def consultar(self):
        return self.session.query(vHorariosDetallados).all()

    
    def agregar(self, horario:horario):
        salida = Salida(estatus=False, mensaje="")
        try:
            self.session.add(horario)
            self.session.commit()
            self.session.refresh(horario)
            salida.estatus=True
            salida.mensaje="Horario agregado correctamente"
            return salida
        except Exception as ex:
            self.session.rollback()
            salida.estatus=False
            salida.mensaje="Error al agregar el horario: "
            print(ex)
        return salida
    
    def consultarPorId(self,id_horario):
        horario= self.session.get(vHorariosDetallados,id_horario)
        salida = EventoSalida(estatus=False,mensaje="",horario=None)
        if horario:
            salida.estatus = True
            salida.mensaje = f"Listado del horario con id {id_horario}"
            salida.horario = horario
        else:
            salida.estatus = False
            salida.mensaje = f"El evento con id {id_horario} no existe"
            salida.horario = None
        return salida
    
    def ConsultarPorGrado(self,id_grado):
        horarioGrado = self.session.exec(select(vHorariosDetallados).where(vHorariosDetallados.ID_Grado == id_grado)).all()
        Salida=EventoSalida(estatus=False,mensaje="",horario=None)

        if horarioGrado:
            Salida.estatus = True
            Salida.mensaje = f"Listado de horarios del grado con id {id_grado}"
            Salida.horario = horarioGrado
        else:
            Salida.estatus = False
            Salida.mensaje = f"No existen horarios para el grado con id {id_grado}"
            Salida.horario =[]
        return Salida

    def consultarPorProfesor(self,id_profesor):
        horarioProfesor = self.session.exec(select(vHorariosDetallados).where(vHorariosDetallados.ID_Profesor == id_profesor)).all()
        Salida = EventoSalida(estatus = False,mensaje="",horario=None)

        if horarioProfesor:
            Salida.estatus = True
            Salida.mensaje = f"Listado de horarios del profesor con id {id_profesor}"
            Salida.horario = horarioProfesor
        else:
            Salida.estatus = False
            Salida.mensaje = f"No existen horarios para el profesor con id {id_profesor}"
            Salida.horario =[]
        return Salida
    
    def consultarPorGrupo(self, id_grupo):
        horariogrupo = self.session.exec(select(vHorariosDetallados).where(vHorariosDetallados.ID_Grupo == id_grupo)).all()
        Salida = EventoSalida (estatus = False, mensaje = "", horario = None)

        if horariogrupo:
            Salida.estatus = True
            Salida.mensaje = f"Lista de horarios del grupo con id{id_grupo}"
            Salida.horario = horariogrupo
        else:
            Salida.estatus = False
            Salida.mensaje = f"No existe horarios para el grupo con id{id_grupo}"
            Salida.horario = []
        return Salida
    
    def actualizar(self, id_horario: int, datos_actualizados: EventoUpdate):
        salida = Salida(estatus=False, mensaje="")
        try:
            horario_db = self.session.get(horario, id_horario)
            if not horario_db:
                salida.mensaje = f"El horario con id {id_horario} no existe"
                return salida
            datos_para_actualizar = datos_actualizados.dict(exclude_unset=True)
            for key, value in datos_para_actualizar.items():
                setattr(horario_db, key, value)
            self.session.add(horario_db)
            self.session.commit()
            self.session.refresh(horario_db)
            salida.estatus = True
            salida.mensaje = f"El horario con id {id_horario} se actualizó correctamente"
        except Exception as ex:
            self.session.rollback()
            salida.estatus = False
            salida.mensaje = f"Error al actualizar el horario: {ex}"
            print(ex)    
        return salida
    
    def eliminar(self, id_horario: int):
        salida = Salida(estatus=False, mensaje="")
        try:
            horario_db = self.session.get(horario, id_horario)
            if not horario_db:
                salida.mensaje = f"El horario con id {id_horario} no existe"
                return salida
            self.session.delete(horario_db)
            self.session.commit()
            salida.estatus = True
            salida.mensaje = f"El horario con id {id_horario} se eliminó correctamente"
        except Exception as ex:
            self.session.rollback()
            salida.estatus = False
            salida.mensaje = f"Error al eliminar el horario: {ex}"
            print(ex)
        return salida
    
    def asignarClase(self, input):
        salida = Salida(estatus=False, mensaje="")
        try:
            # Validar si el profesor tiene conflicto de horario
            conflicto = self.session.exec(
                select(horario).where(
                    horario.id_profesor == input.idProfesor,
                    horario.Fecha == input.Fecha,
                    horario.hora_inicio < input.hora_fin,
                    horario.hora_fin > input.hora_inicio
                )
            ).first()
            if conflicto:
                salida.mensaje = "El profesor tiene conflicto de horario en esa fecha y hora"
                return salida

            # Validar si el grupo tiene conflicto de horario
            conflicto_grupo = self.session.exec(
                select(horario).where(
                    horario.id_grupo == input.id_grupo,
                    horario.Fecha == input.Fecha,
                    horario.hora_inicio < input.hora_fin,
                    horario.hora_fin > input.hora_inicio
                )
            ).first()
            if conflicto_grupo:
                salida.mensaje = "El grupo tiene conflicto de horario en esa fecha y hora"
                return salida

            # Crear nuevo horario
            nueva_clase = horario(
                Fecha=input.Fecha,
                hora_inicio=input.hora_inicio,
                hora_fin=input.hora_fin,
                id_grupo=input.id_grupo,
                id_grado=input.id_grado,
                id_materia=input.idMateria,
                id_profesor=input.idProfesor
            )
            self.session.add(nueva_clase)
            self.session.commit()
            self.session.refresh(nueva_clase)

            salida.estatus = True
            salida.mensaje = "Clase asignada correctamente"
            return salida

        except Exception as ex:
            self.session.rollback()
            salida.mensaje = f"Error al asignar la clase: {ex}"
            return salida