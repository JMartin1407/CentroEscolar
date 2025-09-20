from sqlmodel import SQLModel,Field
from datetime import date, time
from typing import Optional
from pydantic import BaseModel

class profesor(SQLModel, table=True):
    id_Profesor: Optional[int] = Field(default=None, primary_key=True)
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
    NivelEstudios: str