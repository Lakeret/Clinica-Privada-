let pacienteActual = null;
async function cargarMisDatos() {
    const mensaje = document.getElementById("mensaje-datos");
    function mostrar(id, valor, alternativo = "No registrado") {
        const elemento = document.getElementById(id);
        if (elemento) {
            elemento.textContent = valor || alternativo;
        }
    }

    try {
        const respuesta = await fetch("/api/auth/me", {
            credentials: "same-origin"
        });

        if (respuesta.status === 401) {
            window.location.href = "LogIn-Pacientes.html";
            return;
        }

        if (!respuesta.ok) {
            throw new Error("No se pudieron cargar tus datos.");
        }

        pacienteActual = await respuesta.json();
        const paciente = pacienteActual;
        const nombreCompleto = `${paciente.nombre} ${paciente.apellido}`;

        mostrar("nombrePaciente", nombreCompleto);
        mostrar("dniPaciente", `DNI: ${paciente.dni}`);
        mostrar("datoNombreCompleto", nombreCompleto);
        mostrar("datoDni", `DNI ${paciente.dni}`);

        if (paciente.fechaNacimiento) {
            const fecha = new Date(`${paciente.fechaNacimiento}T00:00:00`)
                .toLocaleDateString("es-AR");
            mostrar("datoFechaNacimiento", fecha);
        } else {
            mostrar("datoFechaNacimiento", null);
        }

        const sexos = {
            M: "Masculino",
            F: "Femenino",
            X: "Otro",
            NO_ESPECIFICADO: "No especificado"
        };

        const nacionalidades = {
            argentina: "Argentina",
            boliviana: "Boliviana",
            chilena: "Chilena",
            colombiana: "Colombiana",
            costarricense: "Costarricense",
            cubana: "Cubana",
            ecuatoriana: "Ecuatoriana",
            salvadoreña: "Salvadoreña",
            guatemalteca: "Guatemalteca",
            hondureña: "Hondureña",
            mexicana: "Mexicana",
            nicaraguense: "Nicaragüense",
            panameña: "Panameña",
            paraguaya: "Paraguaya",
            peruana: "Peruana",
            puertorriqueña: "Puertorriqueña",
            dominicana: "Dominicana",
            uruguaya: "Uruguaya",
            venezolana: "Venezolana",
            estadounidense: "Estadounidense",
            española: "Española",
            italiana: "Italiana",
            francesa: "Francesa",
            alemana: "Alemana",
            brasileña: "Brasileña",
            china: "China",
            otro: "Otro / Otra"
        };

        const provincias = {
            caba: "CABA",
            "buenos-aires": "BUENOS AIRES",
            catamarca: "CATAMARCA",
            chaco: "CHACO",
            chubut: "CHUBUT",
            cordoba: "CÓRDOBA",
            corrientes: "CORRIENTES",
            "entre-rios": "ENTRE RÍOS",
            formosa: "FORMOSA",
            jujuy: "JUJUY",
            "la-pampa": "LA PAMPA",
            "la-rioja": "LA RIOJA",
            mendoza: "MENDOZA",
            misiones: "MISIONES",
            neuquen: "NEUQUÉN",
            "rio-negro": "RÍO NEGRO",
            salta: "SALTA",
            "san-juan": "SAN JUAN",
            "san-luis": "SAN LUIS",
            "santa-cruz": "SANTA CRUZ",
            "santa-fe": "SANTA FE",
            "santiago-del-estero": "SANTIAGO DEL ESTERO",
            "tierra-del-fuego": "TIERRA DEL FUEGO, ANTÁRTIDA E ISLAS DEL ATLÁNTICO SUR",
            tucuman: "TUCUMÁN",
        };

        mostrar("datoSexo", sexos[paciente.sexo] || paciente.sexo);
        mostrar("datoNacionalidad", nacionalidades[paciente.nacionalidad] || paciente.nacionalidad);
        mostrar("txtEmail", paciente.email);
        mostrar("txtTel", paciente.telefono);
        mostrar("txtDireccion", paciente.direccion);
        mostrar("datoProvincia", provincias[paciente.provincia] || paciente.provincia);

        mostrar(
            "txtObraSocial",
            paciente.idObraSocial
                ? `Cobertura registrada (ID ${paciente.idObraSocial})`
                : null,
            "Sin cobertura registrada"
        );

        mostrar("txtPlan", null, "No registrado");

        if (mensaje) {
            mensaje.textContent = "";
        }
    } catch (error) {
        console.error("Error al cargar los datos:", error);
        if (mensaje) {
            mensaje.textContent = error.message;
        }
    }
}

cargarMisDatos();

function abrirModal() {
    if (!pacienteActual) return;

    document.getElementById("inputEmail").value = pacienteActual.email || "";
    document.getElementById("inputTel").value = pacienteActual.telefono || "";
    document.getElementById("inputDireccion").value = pacienteActual.direccion || "";
    document.getElementById("inputProvincia").value = pacienteActual.provincia || "";

    document.getElementById("modalEdicion").classList.add("activo");
}

function cerrarModal() {
    document.getElementById("modalEdicion").classList.remove("activo");
}

async function guardarDatos(event) {
    event.preventDefault();

    const boton = document.querySelector(
        "#formularioDatos button[type='submit']"
    );
    const mensaje = document.getElementById("mensaje-datos");

    const datos = {
        email: document.getElementById("inputEmail").value.trim(),
        telefono: document.getElementById("inputTel").value.trim(),
        direccion: document.getElementById("inputDireccion").value.trim(),
        provincia: document.getElementById("inputProvincia").value
    };

    boton.disabled = true;

    try {
        const respuesta = await fetch("/api/auth/me/contacto", {
            method: "PUT",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(datos)
        });

        if (respuesta.status === 401) {
            window.location.href = "./LogIn-Pacientes.html";
            return;
        }

        const resultado = await respuesta.json().catch(() => ({}));

        if (!respuesta.ok) {
            throw new Error(resultado.detail || "No se pudieron guardar los cambios.");
        }

        cerrarModal();
        await cargarMisDatos();

        if (mensaje) {
            mensaje.textContent = "Tus datos se actualizaron correctamente.";
        }
    } catch (error) {
        if (mensaje) {
            mensaje.textContent = error.message;
        }
    } finally {
        boton.disabled = false;
    }
}

document.getElementById("botonEliminarCuenta").addEventListener("click", async () => {
    const confirmar = window.confirm(
        "Se eliminarán de forma permanente tu cuenta, tus datos y tus registros médicos. ¿Querés continuar?"
    );

    if (!confirmar) return;

    const boton = document.getElementById("botonEliminarCuenta");
    const mensaje = document.getElementById("mensaje-eliminar-cuenta");
    boton.disabled = true;
    mensaje.textContent = "Eliminando la cuenta...";

    try {
        const respuesta = await fetch("/api/auth/me", {
            method: "DELETE",
            credentials: "same-origin"
        });

        if (respuesta.status === 401) {
            window.location.href = "LogIn-Pacientes.html";
            return;
        }

        const resultado = await respuesta.json().catch(() => ({}));

        if (!respuesta.ok) {
            throw new Error(resultado.detail || "No se pudo eliminar la cuenta.");
        }

        window.location.href = "crear-cuenta.html";
    } catch (error) {
        mensaje.textContent = error.message;
        boton.disabled = false;
    }
});
