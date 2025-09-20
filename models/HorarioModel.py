from sqlmodel import SQLModel,Field
from datetime import date, time
from typing import Optional
from pydantic import BaseModel

class vHorariosDetallados(SQLModel, table=True):
    __tablename__ = "vHorariosDetallados" 
    ID_Horario: Optional[int] = Field(default=None, primary_key=True)
    Fecha: date
    hora_inicio: time
    hora_fin: time
    ID_Grupo: int
    Grupo: str
    ID_Grado: int
    Grado: str
    Nivel: str
    ID_Materia: int
    Materia: str
    ID_Profesor: int
    NombreProfesor: str
    ApellidoPaternoProfesor: str

class horario(SQLModel, table=True):
    ID_horario: Optional[int] = Field(default=None, primary_key=True)
    Fecha: date
    hora_inicio: time
    hora_fin: time
    id_Grupo: int
    id_Profesor: int
    id_Grado: int
    id_Materia: int

class Salida(BaseModel):
    estatus:bool
    mensaje:str

class EventoSalida(Salida):
    horario: vHorariosDetallados|None = None

class EventoUpdate(SQLModel):
    Fecha: Optional[date]
    hora_inicio: Optional[time]
    hora_fin: Optional[time]
    id_grupo: Optional[int]
    id_profesor: Optional[int]
    id_grado: Optional[int]
    id_materia: Optional[int]

class AsignarClaseInput(SQLModel):
    idMateria: int
    idProfesor: int
    Fecha: date
    hora_inicio: time
    hora_fin: time
    id_grupo: int
    id_grado: int

class HorarioClase(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    id_horario: int
    id_materia: int
    id_profesor: int