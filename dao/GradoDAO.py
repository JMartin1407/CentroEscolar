from sqlmodel import Session, select
from models.GradoModel import grado, Salida, EventoSalida, vGradoConGrupos, EventoUpdate
from datetime import date


class GradoDAO:
    def __init__(self, session:Session):
        self.session = session
    def consultar(self):
        return self.session.query(vGradoConGrupos).all()
    
    def agregar(self, grado):
        salida = Salida(estatus=False, mensaje="")
        try:
            self.session.add(grado)
            self.session.commit()
            self.session.refresh(grado)
            salida.estatus=True
            salida.mensaje="Grado agregado correctamente"
            return salida
        except Exception as ex:
            self.session.rollback()
            salida.estatus=False
            salida.mensaje="Error al agregar el grupo: "
            print(ex)
        return salida
    
    def consultarPorId(self, id_Grado: int): 
        grado = self.session.get(vGradoConGrupos, id_Grado) 
        salida = EventoSalida(estatus=False, mensaje="", grado=None) 
        if grado: 
            salida.estatus = True 
            salida.mensaje = f"Listado del grupo con id {id_Grado}" 
            salida.grado = grado 

        else: 
            salida.estatus = False 
            salida.mensaje = f"El grupo con id {id_Grado} no existe" 
            salida.grado = None
        return salida


    def actualizar(self, id_grado: int, datos_actualizados: EventoUpdate):
        salida = {"estatus": False, "mensaje": ""}
        try:
            grado_db = self.session.get(grado, id_grado)
            if not grado_db:
                salida["mensaje"] = f"El grado con id {id_grado} no existe"
                return salida

            datos = datos_actualizados.dict(exclude_unset=True)
            for key, value in datos.items():
                setattr(grado_db, key, value)

            self.session.add(grado_db)
            self.session.commit()
            self.session.refresh(grado_db)

            salida["estatus"] = True
            salida["mensaje"] = f"El grado con id {id_grado} se actualizó correctamente"
        except Exception as ex:
            self.session.rollback()
            salida["mensaje"] = f"Error al actualizar el grado: {ex}"
        return salida

    def eliminar(self, id_grado: int):
        salida = Salida(estatus=False, mensaje="")
        try:
            grado_db = self.session.get(grado, id_grado)
            if not grado_db:
                salida.mensaje = f"El grado con id {id_grado} no existe"
                return salida
            self.session.delete(grado_db)
            self.session.commit()
            salida.estatus = True
            salida.mensaje = f"El grado con id {id_grado} se eliminó correctamente"
        except Exception as ex:
            self.session.rollback()
            salida.estatus = False
            salida.mensaje = f"Error al eliminar el grado: {ex}"
            print(ex)
        return salida