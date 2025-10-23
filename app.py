import os
import re
from typing import Optional
from mysql.connector.connection import MySQLConnection
from dotenv import load_dotenv
import mysql.connector
from mysql.connector import Error
from tabulate import tabulate

load_dotenv()

DATABASE_CONFIG = {
    "host": os.getenv("MYSQL_HOST", "localhost"),
    "port": int(os.getenv("MYSQL_PORT", 3306)),
    "user": os.getenv("MYSQL_USER", "root"),
    "password": os.getenv("MYSQL_PASSWORD", ""),
    "database": os.getenv("MYSQL_DB", "legacy_escolar"),
    "autocommit": False,
}


# conexion sql
def conectar_db():
    """
    Crear conexion con mysql
    """
    return mysql.connector.connect(**DATABASE_CONFIG)

# Helpers
def formtatear_semestre(valor:str) -> Optional[str]:
    """
    Valida y formatea el semestre (01 - 10)
    """
    if re.fullmatch(r"(0?[1-9]|10)", valor):
        return f"{int(valor):02d}"
    return None

def formatear_fecha(cadena:str) -> Optional[str]:
    """
    Convierte fechas con formato DD/MM/YYYY a YYYY-MM-DD
    """    
    cadena = cadena.strip()
    if not cadena or cadena.upper() == "NULL":
        return None
    
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", cadena):
        return cadena
    
    match = re.fullmatch(r"(\d{2})/(\d{2})/(\d{4})", cadena)
    if match:
        dia, mes, anio = match.groups()
        return f"{anio}-{mes}-{dia}"

    print("Formato de fecha invalido. Usa YYYY-MM-DD o DD/MM/YYYY")
    return None

# Consulta a bd

def carrera_existe(conn: MySQLConnection, clave_carrera: str) -> bool:
    """
    Verifica si una carrera existe en la base de datos
    """
    query = "SELECT 1 FROM carreras WHERE clave = %s"
    with conn.cursor() as cursor:
        cursor.execute(query, (clave_carrera,))
        return cursor.fetchone() is not None
    
def obtener_materias(conn: MySQLConnection):
    """
    Obtiene todas las materias disponibles y las muestra en una tabla
    """
    query = "SELECT clave, descri FROM materias ORDER BY clave"
    with conn.cursor() as cursor:
        cursor.execute(query)
        materias = cursor.fetchall()

    print("\n=== MATERIAS DISPONIBLES ===")
    print(tabulate(materias, headers=["Clave", "Descripción"], tablefmt="github"))
    return {str[fila[0]] for fila in materias}

def mostrar_planes(conn: MySQLConnection):
    """
    Muestra todos los planes
    """
    query = "SELECT * FROM planes ORDER BY id"
    with conn.cursor() as cursor:
        cursor.execute(query)
        resultados = cursor.fetchall()
        encabezados = [desc[0] for desc in cursor.description]
    
    print("\n=== PLANES DE ESTUDIO ===")
    print(tabulate(resultados, headers=encabezados, tablefmt="github"))

    
    # Operaciones CRUD