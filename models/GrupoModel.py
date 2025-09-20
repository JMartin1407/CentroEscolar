from sqlmodel import SQLModel,Field
from datetime import date, time
from typing import Optional
from pydantic import BaseModel

class vGruposDetallados(SQLModel, table=True):
    __tablename__ = "vGruposDetallados"

    ID_Grupo: Optional[int] = Field(default=None, primary_key=True)
    NombreGrado: str
    NombreNivel: str
    id_grado:int
    NombreGrupo:str
    

class grupo(SQLModel, table=True):
    ID_Grupo: Optional[int] = Field(default=None, primary_key=True)
    nombre: str
    ID_Grado: int

class Salida(BaseModel):
    estatus:bool
    mensaje:str

class EventoSalida(Salida):
    grupo: vGruposDetallados|None = None

class EventoUpdate(SQLModel):
    nombre: Optional[str]
    ID_Grado: Optional[int]
