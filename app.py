from config import app, db
import routes  # Importa las rutas
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hola desde Flask en Render'

# Iniciar la aplicación Flask
#if __name__ == '__main__':
#   app.run(host='0.0.0.0', port=5000, debug=True)