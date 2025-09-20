from sqlmodel import Session, select
from models.GradoModel import grado, Salida, EventoSalida, vGradoConGrupos, EventoUpdate
from datetime import date

class GrupoDAO:
    def __init__(self, session:Session):
        self.session = session
    def consultar(self):
        return self.session.query(vGradoConGrupos).all()
    
    def agregar(self, grupo):
        salida = Salida(estatus=False, mensaje="")
        try:
            self.session.add(grupo)
            self.session.commit()
            self.session.refresh(grupo)
            salida.estatus=True
            salida.mensaje="Grado agregado correctamente"
            return salida
        except Exception as ex:
            self.session.rollback()
            salida.estatus=False
            salida.mensaje="Error al agregar el grupo: "
            print(ex)
        return salida
    
    def consultarPorId(self, id_grado: int):
        grado = self.session.get(vGradoConGrupos, id_grado)
        salida = EventoSalida(estatus=False, mensaje="", grupo=None)

        if grado:
            salida.estatus = True
            salida.mensaje = f"Listado del grupo con id {id_grado}"
            salida.grado = grado
        else:
            salida.estatus = False
            salida.mensaje = f"El grupo con id {id_grado} no existe"
            salida.grado = None

        return salida

    def actualizar(self, id_grado: int, datos_actualizados: EventoUpdate):
        salida = Salida(estatus=False, mensaje="")
        try:
            grupo_db = self.session.get(grado, id_grado)
            if not grupo_db:
                salida.mensaje = f"El horario con id {id_grado} no existe"
                return salida
            datos_para_actualizar = datos_actualizados.dict(exclude_unset=True)
            for key, value in datos_para_actualizar.items():
                setattr(grupo_db, key, value)
            self.session.add(grupo_db)
            self.session.commit()
            self.session.refresh(grupo_db)
            salida.estatus = True
            salida.mensaje = f"El horario con id {id_grado} se actualizó correctamente"
        except Exception as ex:
            self.session.rollback()
            salida.estatus = False
            salida.mensaje = f"Error al actualizar el horario: {ex}"
            print(ex)    
        return salida

    def eliminar(self, id_grado: int):
        salida = Salida(estatus=False, mensaje="")
        try:
            horario_db = self.session.get(grado, id_grado)
            if not horario_db:
                salida.mensaje = f"El horario con id {id_grado} no existe"
                return salida
            self.session.delete(horario_db)
            self.session.commit()
            salida.estatus = True
            salida.mensaje = f"El horario con id {id_grado} se eliminó correctamente"
        except Exception as ex:
            self.session.rollback()
            salida.estatus = False
            salida.mensaje = f"Error al eliminar el horario: {ex}"
            print(ex)
        return salida
    

    
