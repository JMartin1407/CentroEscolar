from sqlmodel import SQLModel,Field
from datetime import date, time
from typing import Optional
from pydantic import BaseModel

class alumno(SQLModel, table=True):
    id_Alumno: Optional[int] = Field(default=None, primary_key=True)
    Nombre: str
    ApellidoPaterno: str
    ApellidoMaterno: str
    Curp: str
    Sexo: str
    edad: int
    Correo: str
    password: str
    Telefono: str
    Direccion: str
    id_modadidad: int
    id_grupo: int
    id_grado: int


