from fastapi import FastAPI, Request, HTTPException, status, Depends
from fastapi.security import HTTPBasic, HTTPBasicCredentials
import uvicorn

from dao.AutenticarDAO import AutenticacionDAO
from dao.HorarioDAO import HorarioDAO
from dao.GrupoDAO import GrupoDAO
from dao.database import Conexion
from models.HorarioModel import vHorariosDetallados, horario, AsignarClaseInput
from models.GrupoModel import vGruposDetallados, grupo

app = FastAPI()
security = HTTPBasic()

# --- STARTUP ---
@app.on_event("startup")
def startup():
    conexion = Conexion()
    session = conexion.getSession()
    app.session = session
    print("Conexión a la base de datos establecida")

# --- VALIDAR USUARIO (BASIC AUTH) ---
def validar_usuario(credentials: HTTPBasicCredentials = Depends(security), request: Request = None):
    if not credentials:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales requeridas",
            headers={"WWW-Authenticate": "Basic"}
        )
    dao = AutenticacionDAO(request.app.session)
    usuario = dao.autenticar(credentials.username, credentials.password)
    if not usuario["estatus"]:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Usuario o contraseña incorrectos",
            headers={"WWW-Authenticate": "Basic"}
        )
    return usuario

# --- VERIFICAR ROLES ---
def roles_permitidos(roles: list[str]):
    def dependencia(usuario: dict = Depends(validar_usuario)):
        if usuario["rol"] not in roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Rol no permitido"
            )
        return usuario
    return dependencia

# --- HORARIOS ---
@app.post("/horarios", tags=["Horarios"], summary="Agregar nuevo horario")
def agregarHorario(h: horario, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = HorarioDAO(request.app.session)
    return eDAO.agregar(h)

@app.get("/horarios", response_model=list[vHorariosDetallados], tags=["Horarios"], summary="Consultar todos los horarios")
def consultarHorarios(request: Request, usuario=Depends(roles_permitidos(["Administrativo", "Docente", "Padre","Alumno"]))):
    eDAO = HorarioDAO(request.app.session)
    return eDAO.consultar()

@app.get("/horarios/{id_horario}", response_model=vHorariosDetallados, tags=["Horarios"], summary="Consultar horario por ID")
def consultarHorarioPorId(id_horario: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = HorarioDAO(request.app.session)
    salida = eDAO.consultarPorId(id_horario)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida.horario

@app.get("/horarios/grado/{id_grado}", response_model=list[vHorariosDetallados], tags=["Horarios"], summary="Consultar horarios por grado")
def consultarHorarioPorGrado(id_grado: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = HorarioDAO(request.app.session)
    salida = eDAO.ConsultarPorGrado(id_grado)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida.horario

@app.get("/horarios/profesor/{id_profesor}", response_model=list[vHorariosDetallados], tags=["Horarios"], summary="Consultar horarios por profesor")
def consultarHorarioPorProfesor(id_profesor: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = HorarioDAO(request.app.session)
    salida = eDAO.consultarPorProfesor(id_profesor)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida.horario

@app.get("/horario/grupo/{id_Grupo}", response_model=list[vHorariosDetallados], tags=["Horarios"], summary="Consultar horarios por grupo")
def consultarHorarioPorGrupo(id_Grupo: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo", "Docente"]))):
    eDAO = HorarioDAO(request.app.session)
    salida = eDAO.consultarPorGrupo(id_Grupo)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida.horario

@app.put("/horarios/{id_horario}", tags=["Horarios"], summary="Actualizar horario por ID")
def actualizarHorario(id_horario: int, h: horario, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = HorarioDAO(request.app.session)
    salida = eDAO.actualizar(id_horario, h)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida

@app.delete("/horarios/{id_horario}", tags=["Horarios"], summary="Eliminar horario por ID")
def eliminarHorario(id_horario: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = HorarioDAO(request.app.session)
    salida = eDAO.eliminar(id_horario)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida

# --- ASIGNAR CLASE A HORARIO ---
@app.post("/horarios/asignar", tags=["Horarios"], summary="Asignar nueva clase")
def asignarClaseHorario(input: AsignarClaseInput, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = HorarioDAO(request.app.session)
    salida = eDAO.asignarClase(input)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=salida.mensaje)
    return salida

# --- GRUPOS ---
@app.post("/grupos", tags=["Grupos"], summary="Agregar nuevo grupo")
def agregarGrupo(g: grupo, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = GrupoDAO(request.app.session)
    return eDAO.agregar(g)

@app.get("/grupos", response_model=list[vGruposDetallados], tags=["Grupos"], summary="Consultar todos los grupos")
def consultarGrupos(request: Request, usuario=Depends(roles_permitidos(["Administrativo", "Docente", "Padre", "Alumno"]))):
    eDAO = GrupoDAO(request.app.session)
    return eDAO.consultar()

@app.get("/grupos/{id_grupo}", response_model=vGruposDetallados, tags=["Grupos"], summary="Consultar grupo por ID")
def consultarGrupoPorId(id_grupo: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = GrupoDAO(request.app.session)
    salida = eDAO.consultarPorId(id_grupo)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida.grupo

@app.put("/grupos/{id_grupo}", tags=["Grupos"], summary="Actualizar grupo por ID")
def actualizarGrupo(id_grupo: int, g: grupo, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = GrupoDAO(request.app.session)
    salida = eDAO.actualizar(id_grupo, g)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida

@app.delete("/grupos/{id_grupo}", tags=["Grupos"], summary="Eliminar grupo por ID")
def eliminarGrupo(id_grupo: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = GrupoDAO(request.app.session)
    salida = eDAO.eliminar(id_grupo)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida

# --- ASIGNAR ALUMNO ---
@app.post("/grupos/{id_grupo}/asignarAlumno", tags=["Grupos"], summary="Asignar alumno a grupo")
def asignarAlumno(id_grupo: int, payload: dict, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    id_alumno = payload.get("idAlumno")
    if not id_alumno:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Falta idAlumno")
    dao = GrupoDAO(request.app.session)
    return dao.asignarAlumno(id_grupo, id_alumno)

# --- ASIGNAR PROFESOR ---
@app.post("/grupos/{id_grupo}/asignarProfesor", tags=["Grupos"], summary="Asignar profesor a grupo")
def asignarProfesor(id_grupo: int, payload: dict, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    id_profesor = payload.get("idProfesor")
    if not id_profesor:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Falta idProfesor")
    dao = GrupoDAO(request.app.session)
    return dao.asignarProfesor(id_grupo, id_profesor)

# ----- GRADOS -----
@app.get("/grados", tags=["Grados"], summary="Consultar todos los grados")
def consultarGrados(request: Request, usuario=Depends(roles_permitidos(["Administrativo", "Docente", "Padre", "Alumno"]))):
    eDAO = GrupoDAO(request.app.session)
    return eDAO.consultar()

@app.post("/grados", tags=["Grados"], summary="Agregar nuevo grado")
def agregarGrado(g: grupo, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = GrupoDAO(request.app.session)
    return eDAO.agregarGrado(g)

@app.get("/grados/{id_grado}", tags=["Grados"], summary="Consultar grado por ID")
def consultarGradoPorId(id_grado: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = GrupoDAO(request.app.session)
    salida = eDAO.consultarGradoPorId(id_grado)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida.grado

@app.put("/grados/{id_grado}", tags=["Grados"], summary="Actualizar grado por ID")
def actualizarGrado(id_grado: int, g: grupo, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = GrupoDAO(request.app.session)
    salida = eDAO.actualizarGrado(id_grado, g)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida

@app.delete("/grados/{id_grado}", tags=["Grados"], summary="Eliminar grado por ID")
def eliminarGrado(id_grado: int, request: Request, usuario=Depends(roles_permitidos(["Administrativo"]))):
    eDAO = GrupoDAO(request.app.session)
    salida = eDAO.eliminarGrado(id_grado)
    if not salida.estatus:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=salida.mensaje)
    return salida

# --- MAIN ---
if __name__ == "__main__":
    uvicorn.run("main:app", reload=True, host="127.0.0.1", port=8000)

