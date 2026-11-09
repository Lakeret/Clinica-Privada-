# Clínica Privada

Proyecto integrador Clinica Privada sitio para pacientes hecho en HTML, CSS y JavaScript, y una API hecha en Java con Spring Boot y Maven.

## Requisitos

- Git, para clonar y actualizar el repositorio.
- JDK 21, porque el proyecto está configurado para Java 21.
- MySQL funcionando en el puerto `3306`.
- La base de datos con nombre `sistema_clinico`, con sus tablas, store prodcedures y triggers.
- Visual Studio Code o Spring Tools Suite (STS), para editar y ejecutar el proyecto.
- Conexión a Internet durante la primera ejecución, para que Maven descargue las dependencias.

No hace falta instalar Maven por separado: el proyecto incluye Maven Wrapper.

## Clonar desde la terminal

Abrí PowerShell, la terminal de Visual Studio Code o Git Bash y ejecutá:

```bash
git clone -b FrontEnd https://github.com/Lakeret/Clinica-Privada-.git
```

En Visual Studio Code podés abrir la carpeta descargada con:

```bash
code .
```

Si `code .` no está disponible, abrí Visual Studio Code y elegí **Archivo > Abrir carpeta**. Seleccioná la carpeta `Clinica-Privada-` que se creó al clonar.

## Preparar la base de datos

1. Iniciá MySQL desde XAMPP o desde el programa que uses.
2. Creá o importá la base `sistema_clinico` con las tablas y procedimientos que necesita la API.
3. Revisá `backend/src/main/resources/application.properties` y configurá la dirección, el usuario y la contraseña de tu MySQL.

No subas contraseñas reales a GitHub. El archivo `application.properties` contiene actualmente datos de conexión locales; reemplazá los valores privados antes de publicar el repositorio.

## Ejecutar en Visual Studio Code

### Extensiones

Instalá estas extensiones desde la sección **Extensiones** de VS Code (`Ctrl+Shift+X`):

- **Extension Pack for Java**: incluye las herramientas de Java, Maven, ejecución y depuración.
- **Spring Boot Extension Pack**: agrega herramientas para abrir y ejecutar aplicaciones Spring Boot.

Son suficientes para este proyecto. VS Code ya incluye soporte básico para editar HTML, CSS y JavaScript; no necesitás una extensión de servidor web para el frontend. [Documentación oficial de extensiones Java y Spring para VS Code](https://code.visualstudio.com/docs/java/extensions).

### Iniciar el proyecto

1. Abrí la carpeta raíz `Clinica-Privada-` en VS Code.
2. Abrí **Terminal > Nueva terminal**.
3. Ejecutá:

```powershell
cd backend
.\mvnw.cmd spring-boot:run
```

La primera vez Maven puede tardar porque descarga los componentes necesarios. Cuando aparezca el mensaje de que la aplicación inició, abrí en el navegador:

```text
http://localhost:8080/
```

La página principal te lleva al sitio de pacientes. El frontend se sirve desde Spring Boot, por lo que sus llamadas a `/api/...` usan la misma dirección que la API. Para probarlo, usá la dirección `localhost:8080`; no abras los HTML directamente desde el explorador de archivos.

Para detener la aplicación, volvé a la terminal y presioná `Ctrl+C`.

## Ejecutar en Spring Tools Suite (STS)

1. Instalá [Spring Tools para Eclipse](https://spring.io/tools/) y abrilo.
2. Elegí **File > Import > Maven > Existing Maven Projects**.
3. En **Root Directory**, seleccioná la carpeta `backend` de `Clinica-Privada-`.
4. Seleccioná el proyecto que aparece y presioná **Finish**. Esperá a que Maven descargue las dependencias.
5. Abrí `src/main/java/com/clinica/api/ClinicaApiApplication.java`.
6. Presioná el botón de ejecutar o hacé clic derecho en el archivo y elegí **Run As > Spring Boot App**.
7. Abrí `http://localhost:8080/` en el navegador.

Si no aparece la opción de Spring Boot, comprobá que importaste la carpeta `backend` que contiene `pom.xml` y que STS está usando JDK 21. También podés iniciar el proyecto desde la terminal integrada con `mvnw.cmd spring-boot:run`, como en la sección anterior.

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
- HTML, CSS y JavaScript
