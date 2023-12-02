from datetime import datetime
from flask import *
import mysql.connector

class Cliente:
    def __init__(self, noCliente, nombre, apellidoPaterno, apellidoMaterno, fechaNacimiento, sexo):
        self.noCliente = noCliente
        self.nombre = nombre
        self.apellidoPaterno = apellidoPaterno
        self.apellidoMaterno = apellidoMaterno
        self.fechaNacimiento = fechaNacimiento
        self.sexo = sexo

app = Flask(__name__)

conexion = mysql.connector.connect(
    host="localhost",
    port="3306",
    user="root",
    database="mi_primer_tutor2"
)

cursor = conexion.cursor(dictionary=True)

def formato_fecha(fecha):
    return fecha.strftime('%Y-%m-%d')

@app.route('/')
def hola():
    return '<html><body bgcolor=#EFE4B0><h1>Mi Primer Tutor</h1></body><html>'

@app.route('/crear_usuario', methods=['POST'])
def crear_usuario():
    datos = request.get_json()
    email = datos.get('email')
    contrasena = datos.get('contrasena')
    tipo_usuario = datos.get('tipo_usuario')
    uid = datos.get('uid')

    # Obtener el nombre de usuario (sin @gmail.com) a partir del email
    nombre_usuario = email.split('@')[0]

    # Insertar el nuevo usuario en la tabla Usuarios
    cursor.execute("INSERT INTO Usuarios (id_usuario, nombre_usuario, contrasena, tipo_usuario) VALUES (%s, %s, %s, %s)",
                   (uid, email, contrasena, tipo_usuario))
    conexion.commit()

    # Obtener el ID del nuevo usuario
    nuevo_usuario_id = uid

    # Dependiendo del tipo de usuario, insertar en la tabla correspondiente (Padres, Profesores, Alumnos, etc.)
    if tipo_usuario == 'padre':
        cursor.execute("INSERT INTO Padres (nombre, id_usuario) VALUES (%s, %s)", (nombre_usuario, nuevo_usuario_id))
    elif tipo_usuario == 'profesor':
        cursor.execute("INSERT INTO Profesores (nombre, id_usuario) VALUES (%s, %s)", (nombre_usuario, nuevo_usuario_id))
    elif tipo_usuario == 'alumno':
        cursor.execute("INSERT INTO Alumnos (nombre, id_usuario) VALUES (%s, %s)", (nombre_usuario, nuevo_usuario_id))
    # Añadir más casos según sea necesario

    conexion.commit()

    return jsonify({'message': 'Usuario creado correctamente'}), 201

@app.route('/alta_alumno', methods=['POST'])
def alta_alumno():
    datos = request.get_json()
    uid = datos.get('uid')
    nombre_alumno = datos.get('nombre')

    # Buscar en la tabla Padres para obtener el id_padre correspondiente al uid
    cursor.execute("SELECT id_padre FROM Padres WHERE id_usuario = %s", (uid,))
    resultado_padre = cursor.fetchone()

    if resultado_padre:
        id_padre = resultado_padre['id_padre']

        # Insertar el nuevo alumno en la tabla Alumnos
        cursor.execute("INSERT INTO Alumnos (nombre, id_usuario, id_padre, id_profesor) VALUES (%s, %s, %s, %s)",
                       (nombre_alumno, uid, id_padre, 1))  # 1 es el id_profesor predeterminado
        conexion.commit()

        return jsonify({'message': 'Alumno registrado correctamente'}), 201
    else:
        return jsonify({'error': 'No se encontró un padre con el UID proporcionado'}), 404

@app.route('/login_alumno', methods=['POST'])
def login_alumno():
    datos = request.get_json()
    nombre_alumno = datos.get('nombre')

    # Buscar el nombre del alumno en la tabla Alumnos
    cursor.execute("SELECT id_alumno FROM Alumnos WHERE nombre = %s", (nombre_alumno,))
    resultado_alumno = cursor.fetchone()

    if resultado_alumno:
        id_alumno = resultado_alumno['id_alumno']
        return jsonify({'id_alumno': id_alumno})
    else:
        return jsonify({'message': 'No se encontró el alumno'}), 404

if __name__ == '__main__':
    app.run(debug=True,port=8000)

