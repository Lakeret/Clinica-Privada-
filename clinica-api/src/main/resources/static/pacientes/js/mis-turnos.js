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

        mensaje.textContent = "";
    } catch (error) {
        console.error("Error al cargar los turnos:", error);
        lista.innerHTML = `
            <tr>
                <td colspan="5">No se pudieron cargar los turnos.</td>
            </tr>
        `;
        mensaje.textContent = error.message;
    }
}

function formatearFecha(fecha) {
    if (!fecha) return "No disponible";

    const [anio, mes, dia] = fecha.split("-");
    return `${dia}/${mes}/${anio}`;
}

cargarTurnos();