from sqlmodel import SQLModel,Field
from datetime import date, time
from typing import Optional
from pydantic import BaseModel

class vGradoConGrupos(SQLModel, table=True):
    id_grado: int = Field(..., primary_key=True)
    NombreGrado: str
    NombreNivel: Optional[str] = None  


class grado(SQLModel, table=True):
    ID_Grado: Optional[int] = Field(default=None, primary_key=True)
    Nombre_grado: str
    Nombre_nivel: Optional[str] = None

class Salida(BaseModel):
    estatus:bool
    mensaje:str

class EventoSalida(Salida):
    grado: vGradoConGrupos|None = None

class EventoUpdate(SQLModel):
    Nombre_grado: Optional[str] = None
    Nombre_nivel: Optional[str] = None