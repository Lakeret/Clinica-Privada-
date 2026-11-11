# Clínica Privada

Proyecto integrador Clinica Privada con API hecha en Java con Spring Boot y Maven.

## Requisitos

- Git, para clonar y actualizar el repositorio.
- JDK 21, porque el proyecto está configurado para Java 21.
- MySQL funcionando en el puerto "3306".
- La base de datos con nombre "sistema_clinico", con sus tablas, store prodcedures y triggers.
- Visual Studio Code o Spring Tools Suite (STS), para editar y ejecutar el proyecto.
- Conexión a Internet durante la primera ejecución, para que Maven descargue las dependencias.

## Clonar con GIT

Abrí PowerShell, la terminal de Visual Studio Code o Git Bash y ejecutá:

```bash
git clone -b FrontEnd https://github.com/Lakeret/Clinica-Privada-.git
```

## Preparar la base de datos

1. Iniciá MySQL.
2. Ejecutar SCRIPT de la base "sistema_clinico" con las tablas, store procedures y triggers que necesita la API
3. Revisá "backend/src/main/resources/application.properties" y configurá la dirección, el usuario y la contraseña de tu MySQL

## Ejecutar en Visual Studio Code

### Extensiones

Instalá estas extensiones desde la sección **Extensiones** de VS:

- **Extension Pack for Java**
- **Spring Boot Extension Pack**

### Iniciar el proyecto

1. Abrí la carpeta raíz `Clinica-Privada-` en VS Code.
2. Abrí **Terminal > Nueva terminal**.
3. Ejecutá:

```powershell
cd backend
.\mvnw.cmd spring-boot:run
```

```buscar en el navegador:
http://localhost:8080/
```
Para detener la aplicación, volvé a la terminal y presioná `Ctrl+C`.

## Ejecutar en Spring Tools Suite (STS)

1. Abrir Spring Tools
2. Elegí **File > Import > Maven > Existing Maven Projects**.
3. En **Root Directory**, seleccioná la carpeta `backend` de `Clinica-Privada-`.
4. Seleccioná el proyecto que aparece y presioná **Finish**.
5. Abrí `src/main/java/com/clinica/api/ClinicaApiApplication.java`.
6. Presioná el botón de ejecutar o hacé clic derecho en el archivo y elegí **Run As > Spring Boot App**.
7. Abrí `http://localhost:8080/` en el navegador.

Si o si se necesita la version JDK 21. No versiones mas nuevas ni mas viejas, unicamente compatible con esa version.

## Estructura del proyecto

```text
Clinica-Privada-
├── backend/
│   ├── .mvn/wrapper/        Configuración de Maven Wrapper
│   ├── src/main/java/       API Java y clases de Spring Boot
│   ├── src/main/resources/  Configuración de la aplicación
│   ├── mvnw                 Archivo Wrapper para Linux
│   ├── mvnw.cmd             Archivo Wrapper para Windows
│   └── pom.xml              Dependencias y configuración de Maven
├── frontend/
│   ├── css/                Carpeta con los archivos CSS de las distintas paginas HTML
│   ├── js/                 Carpeta JS en los que se hacen peticiones http a la API
│   ├── paginas/            Carpeta con las distintas secciones HTML de el index
│   ├── recursos/           Otros recursos que necesita la Pagina.
│   └── index.html          index principal de la pagina
└── README.md
```

## Herramientas usadas

- Java 21 y Spring Boot 4.1.2
- Maven Wrapper 3.10.0
- MySQL
- HTML , CSS y JavaScript
