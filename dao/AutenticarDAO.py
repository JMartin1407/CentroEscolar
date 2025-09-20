
from sqlalchemy.orm import Session
from sqlalchemy import text
from fastapi import HTTPException, status

class AutenticacionDAO:
    def __init__(self, session: Session):
        self.session = session

    def autenticar(self, correo: str, password: str) -> dict:
        tablas = [
            {"nombre": "alumno", "rol": "Alumno"},
            {"nombre": "profesor", "rol": "Docente"},
            {"nombre": "admin", "rol": "Administrativo"},
            {"nombre": "padre_tutor", "rol": "Padre"}
        ]

        for tabla in tablas:
            sql = text(f"SELECT * FROM {tabla['nombre']} WHERE correo = :correo AND password = :password")
            resultado = self.session.execute(sql, {"correo": correo, "password": password}).first()
            if resultado:
                usuario = dict(resultado._mapping)
                return {"estatus": True, "usuario": usuario, "rol": tabla["rol"]}

        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Correo o contraseña incorrectos"
        )
