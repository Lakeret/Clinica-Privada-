const botonAbrirTurno = document.getElementById("abrirFormularioTurno");
const botonCancelarTurno = document.getElementById("cancelarFormularioTurno");
const panelNuevoTurno = document.getElementById("panelNuevoTurno");
const formularioNuevoTurno = document.getElementById("formularioNuevoTurno");
const mensajeCrearTurno = document.getElementById("mensaje-crear-turno");

if (botonAbrirTurno && panelNuevoTurno) {
    botonAbrirTurno.addEventListener("click", () => {
        panelNuevoTurno.hidden = false;
        panelNuevoTurno.scrollIntoView({ behavior: "smooth" });
    });
}

if (botonCancelarTurno && panelNuevoTurno && formularioNuevoTurno) {
    botonCancelarTurno.addEventListener("click", () => {
        formularioNuevoTurno.reset();
        panelNuevoTurno.hidden = true;
        mensajeCrearTurno.textContent = "";
    });
}

const fechaTurnoInput = document.getElementById("fechaTurno");

if (fechaTurnoInput) {
    const ahora = new Date();
    ahora.setMinutes(ahora.getMinutes() - ahora.getTimezoneOffset());
    fechaTurnoInput.min = ahora.toISOString().split("T")[0];
}

if (formularioNuevoTurno) {
    formularioNuevoTurno.addEventListener("submit", async (event) => {
        event.preventDefault();

        const botonEnviar = formularioNuevoTurno.querySelector("button[type='submit']");
        const mensajeTurnos = document.getElementById("mensaje-turnos");

        const datos = {
            fecha: document.getElementById("fechaTurno").value,
            hora: document.getElementById("horaTurno").value,
            especialidad: document.getElementById("especialidadTurno").value
        };

        botonEnviar.disabled = true;
        mensajeCrearTurno.textContent = "Registrando el turno...";

        try {
            const respuesta = await fetch("/api/turnos", {
                method: "POST",
                credentials: "same-origin",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datos)
            });

            const texto = await respuesta.text();

            if (respuesta.status === 401) {
                window.location.href = "LogIn-Pacientes.html";
                return;
            }

            if (!respuesta.ok) {
                let errorApi = {};
                try {
                    errorApi = texto ? JSON.parse(texto) : {};
                } catch {
                    errorApi = {};
                }

                throw new Error(
                    errorApi.detail ||
                    texto ||
                    "No se pudo crear el turno."
                );
            }

            formularioNuevoTurno.reset();
            panelNuevoTurno.hidden = true;
            await cargarTurnos();

            if (mensajeTurnos) {
                mensajeTurnos.textContent = texto || "Turno creado correctamente.";
            }
        } catch (error) {
            mensajeCrearTurno.textContent = error.message;
        } finally {
            botonEnviar.disabled = false;
        }
    });
}

async function cargarTurnos() {
    const lista = document.getElementById("listaTurnos");
    const mensaje = document.getElementById("mensaje-turnos");

    try {
        const respuesta = await fetch("/api/turnos/mis-turnos", {
            credentials: "same-origin"
        });

        if (respuesta.status === 401) {
            window.location.href = "LogIn-Pacientes.html";
            return;
        }

        if (!respuesta.ok) {
            throw new Error("No se pudieron cargar tus turnos.");
        }

        const turnos = await respuesta.json();
        lista.replaceChildren();

        if (turnos.length === 0) {
            const fila = document.createElement("tr");
            const celda = document.createElement("td");

            celda.colSpan = 5;
            celda.textContent = "No tenés turnos registrados.";
            fila.appendChild(celda);
            lista.appendChild(fila);
            return;
        }

        turnos.forEach((turno) => {
            const fila = document.createElement("tr");

            const valores = [
                formatearFecha(turno.fecha),
                turno.hora,
                turno.especialidad,
                turno.profesional,
                turno.estado
            ];

            valores.forEach((valor, indice) => {
                const celda = document.createElement("td");

                if (indice === 4) {
                    const estado = document.createElement("span");
                    estado.className = "estado";
                    estado.textContent = valor || "Sin estado";
                    celda.appendChild(estado);
                } else {
                    celda.textContent = valor || "No disponible";
                }

                fila.appendChild(celda);
            });

            lista.appendChild(fila);
        });

        if (mensaje) {
            mensaje.textContent = "";
        }
    } catch (error) {
        console.error("Error al cargar los turnos:", error);
        lista.replaceChildren();
        const fila = document.createElement("tr");
        const celda = document.createElement("td");
        celda.colSpan = 5;
        celda.textContent = "No se pudieron cargar los turnos.";
        fila.appendChild(celda);
        lista.appendChild(fila);

        if (mensaje) {
            mensaje.textContent = error.message;
        }
    }
}

function formatearFecha(fecha) {
    if (!fecha) return "No disponible";

    const partes = fecha.split("-");
    return partes[2] + "/" + partes[1] + "/" + partes[0];
}

cargarTurnos();