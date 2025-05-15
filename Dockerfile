# Usa una imagen base de Debian (Python ya está incluido)
FROM python:3.10-slim-buster

# Instalar dependencias del sistema para ODBC y pyodbc
RUN apt-get update && apt-get install -y \
    unixodbc \
    unixodbc-dev \
    gcc \
    g++ \
    make \
    curl \
    gnupg \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el archivo requirements.txt y lo instala
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto de los archivos de la aplicación
COPY . .

# Expone el puerto donde correrá tu aplicación
EXPOSE 5000

# Establece la variable de entorno para Flask
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Comando para ejecutar la aplicación
#CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT"]
