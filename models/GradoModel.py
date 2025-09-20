from sqlmodel import SQLModel,Field
from datetime import date, time
from typing import Optional
from pydantic import BaseModel

class vGradoConGrupos(SQLModel, table=True):
    id_grado: Optional[int] = Field(default=None, primary_key=True)
    NombreGrado: str
    NombreNivel: str


class grado(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    NombreGrado: str
    id_nivel: int

class Salida(BaseModel):
    estatus:bool
    mensaje:str

class EventoSalida(Salida):
    grupo: vGradoConGrupos|None = None

class EventoUpdate(SQLModel):
    nombre: Optional[str]
    id_grado: Optional[int]