from datetime import datetime
from flask import *
import mysql.connector
import urllib.parse

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
    database="mi_primer_tutor3"
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

@app.route('/lista_alumnos', methods=['GET'])
def lista_alumnos():
    # Recuperar el id_usuario del profesor desde los parámetros de la solicitud
    id_usuario_profesor = request.args.get('id_usuario_profesor')

    # Buscar el id_profesor en la tabla de Profesores
    cursor.execute("SELECT id_profesor FROM Profesores WHERE id_usuario = %s", (id_usuario_profesor,))
    resultado_profesor = cursor.fetchone()

    if resultado_profesor:
        id_profesor = resultado_profesor['id_profesor']

        # Buscar los alumnos que tienen el id_profesor igual al id_profesor del profesor
        cursor.execute("SELECT id_alumno, nombre FROM Alumnos WHERE id_profesor = %s", (id_profesor,))
        resultado_alumnos = cursor.fetchall()

        # Crear una lista de alumnos
        lista_alumnos = [{'id_alumno': alumno['id_alumno'], 'nombre': alumno['nombre']} for alumno in resultado_alumnos]

        return jsonify({'alumnos': lista_alumnos})
    else:
        return jsonify({'error': 'No se encontró el profesor'}), 404

@app.route('/lista_materias', methods=['GET'])
def lista_materias():
    # Recupera el id_usuario del profesor desde los parámetros de la solicitud
    id_usuario_profesor = request.args.get('id_usuario_profesor')

    print(f"ID de usuario del profesor: {id_usuario_profesor}")

    # Busca el id_profesor en la tabla de Profesores
    cursor.execute("SELECT id_profesor FROM Profesores WHERE id_usuario = %s", (id_usuario_profesor,))
    resultado_profesor = cursor.fetchone()

    if resultado_profesor:
        id_profesor = resultado_profesor['id_profesor']

        print(f"ID de profesor encontrado: {id_profesor}")

        # Busca los alumnos que tienen el id_profesor igual al id_profesor del profesor
        cursor.execute("SELECT id_alumno, nombre FROM Alumnos WHERE id_profesor = %s", (id_profesor,))
        resultado_alumnos = cursor.fetchall()

        # Crea una lista de alumnos
        lista_alumnos = [{'id_alumno': alumno['id_alumno'], 'nombre': alumno['nombre']} for alumno in resultado_alumnos]

        print(f"Lista de alumnos: {lista_alumnos}")

        # Inicializa la lista de materias
        lista_materias = []

        # Recorre la lista de alumnos y obtiene las materias para cada uno
        for alumno in lista_alumnos:
            id_alumno = alumno['id_alumno']

            print(f"Procesando alumno con ID: {id_alumno}")

            # Busca las materias que tienen el id_alumno igual al id_alumno del alumno
            cursor.execute("SELECT DISTINCT area FROM Niveles WHERE id_nivel IN (SELECT DISTINCT id_nivel FROM Puntuacion WHERE id_alumno = %s)", (id_alumno,))
            resultado_materias = cursor.fetchall()

            # Agrega las materias a la lista
            materias_alumno = [materia['area'] for materia in resultado_materias]
            lista_materias.append({'id_alumno': id_alumno, 'materias': materias_alumno})

        print(f"Lista de materias: {lista_materias}")

        return jsonify({'alumnos_materias': lista_materias})
    else:
        print("Profesor no encontrado")
        return jsonify({'error': 'No se encontró el profesor'}), 404


@app.route('/preguntas_por_categoria', methods=['GET'])
def preguntas_por_categoria():
    # Obtener parámetros de la solicitud
    area = request.args.get('area')
    numero_nivel = request.args.get('numero_nivel')

    # Buscar el id_nivel correspondiente a la categoría
    cursor.execute("SELECT id_nivel FROM Niveles WHERE area = %s AND numero_nivel = %s", (area, numero_nivel))
    resultado_nivel = cursor.fetchone()

    if resultado_nivel:
        id_nivel = resultado_nivel['id_nivel']

        # Buscar las preguntas que tienen el id_nivel igual al id_nivel obtenido
        cursor.execute("SELECT * FROM Preguntas WHERE id_nivel = %s", (id_nivel,))
        resultado_preguntas = cursor.fetchall()

        # Crear una lista de preguntas
        lista_preguntas = [{'numero_pregunta': pregunta['numero_pregunta'],
                            'nombre_imagen': pregunta['nombre_imagen'],
                            'respuesta_correcta': pregunta['respuesta_correcta']} for pregunta in resultado_preguntas]

        return jsonify({'preguntas': lista_preguntas})
    else:
        return jsonify({'error': 'No se encontró la categoría'}), 404
    
@app.route('/guardar_puntuacion', methods=['POST'])
def guardar_puntuacion():
    datos = request.get_json()

    print("Datos recibidos:", datos)  # Imprime los datos recibidos

    id_alumno = datos.get('id_alumno')
    id_nivel = datos.get('id_nivel')

    # Convertir puntos_acumulados a punto flotante
    puntos_acumulados = float(datos.get('puntos_acumulados'))

    # Obtener la fecha actual como un objeto de fecha
    fecha_completado = datetime.now().date()

    # Imprimir el query antes de ejecutarlo
    query = "INSERT INTO Puntuacion (fecha_completado, puntos_acumulados, id_alumno, id_nivel) VALUES (%s, %s, %s, %s)"
    print("Query:", query % (fecha_completado, puntos_acumulados, id_alumno, id_nivel))

    # Insertar la nueva puntuación en la tabla Puntuacion
    cursor.execute(query, (fecha_completado, puntos_acumulados, id_alumno, id_nivel))
    conexion.commit()

    # Devolver una respuesta JSON indicando que la puntuación se ha guardado correctamente
    return jsonify({'message': 'Puntuación guardada correctamente'}), 201

@app.route('/obtener_puntuacion', methods=['POST'])
def obtener_puntuacion():
    data = request.get_json()
    nombre_alumno = data.get('nombre_alumno')
    materia = data.get('materia')

    # Buscar el id_alumno correspondiente al nombre del alumno
    cursor.execute("SELECT id_alumno FROM Alumnos WHERE nombre = %s", (nombre_alumno,))
    resultado_alumno = cursor.fetchone()

    if resultado_alumno:
        id_alumno = resultado_alumno['id_alumno']

        # Buscar el id_nivel correspondiente a la materia
        cursor.execute("SELECT id_nivel FROM Niveles WHERE area = %s", (materia,))
        resultado_nivel = cursor.fetchone()

        if resultado_nivel:
            id_nivel = resultado_nivel['id_nivel']

            # Consumir los resultados antes de la siguiente consulta
            cursor.fetchall()

            # Buscar todos los registros de puntuación para el alumno y nivel especificados
            cursor.execute("SELECT id_puntuacion, fecha_completado, puntos_acumulados FROM Puntuacion WHERE id_alumno = %s AND id_nivel = %s", (id_alumno, id_nivel))
            
            # Fetch all results after executing the query
            resultados_puntuacion = cursor.fetchall()

            if resultados_puntuacion:
                # Devolver todos los registros de puntuación
                puntuaciones = [
                    {
                        'id_puntuacion': row['id_puntuacion'],
                        'fecha_completado': row['fecha_completado'],
                        'puntos_acumulados': row['puntos_acumulados']
                    }
                    for row in resultados_puntuacion
                ]
                return jsonify({'puntuaciones': puntuaciones})
            else:
                return jsonify({'message': f'No hay registros de puntuación para el alumno {nombre_alumno} en la materia {materia}'}), 404
        else:
            return jsonify({'error': 'No se encontró el nivel para la materia especificada'}), 404
    else:
        return jsonify({'error': f'No se encontró el alumno con el nombre {nombre_alumno}'}), 404

@app.route('/obtener_puntuacion_acumulada', methods=['POST'])
def obtener_puntuacion_acumulada():
    data = request.get_json()
    nombre_alumno = data.get('nombre_alumno')
    materia = data.get('materia')

    # Buscar el id_alumno correspondiente al nombre del alumno
    cursor.execute("SELECT id_alumno FROM Alumnos WHERE nombre = %s", (nombre_alumno,))
    resultado_alumno = cursor.fetchone()

    if resultado_alumno:
        id_alumno = resultado_alumno['id_alumno']

        # Buscar el id_nivel correspondiente a la materia
        cursor.execute("SELECT id_nivel FROM Niveles WHERE area = %s", (materia,))
        resultado_nivel = cursor.fetchone()

        if resultado_nivel:
            id_nivel = resultado_nivel['id_nivel']

            # Consumir los resultados antes de la siguiente consulta
            cursor.fetchall()

            # Sumar los puntos acumulados para el alumno y nivel especificados
            cursor.execute("SELECT SUM(puntos_acumulados) as total_puntos FROM Puntuacion WHERE id_alumno = %s AND id_nivel = %s", (id_alumno, id_nivel))

            resultado_total_puntos = cursor.fetchone()

            if resultado_total_puntos['total_puntos']:
                total_puntos = resultado_total_puntos['total_puntos']
                return jsonify({'total_puntos': total_puntos})
            else:
                return jsonify({'message': f'No hay registros de puntuación para el alumno {nombre_alumno} en la materia {materia}'}), 404
        else:
            return jsonify({'error': 'No se encontró el nivel para la materia especificada'}), 404
    else:
        return jsonify({'error': f'No se encontró el alumno con el nombre {nombre_alumno}'}), 404
        


if __name__ == '__main__':
    app.run(debug=True,port=8000)

