async function cargarPacienteSidebar() {
    const nombre = document.getElementById("nombrePaciente");
    const dni = document.getElementById("dniPaciente");

    if (!nombre || !dni) return;

    try {
        const respuesta = await fetch("/api/auth/me", {
            credentials: "same-origin"
        });

        if (respuesta.status === 401) {
            window.location.href = "LogIn-Pacientes.html";
            return;
        }

        if (!respuesta.ok) {
            throw new Error("No se pudieron cargar los datos del paciente.");
        }

        const paciente = await respuesta.json();
        nombre.textContent = `${paciente.nombre} ${paciente.apellido}`;
        dni.textContent = `DNI: ${paciente.dni}`;
    } catch (error) {
        console.error("Error al cargar el paciente del menú:", error);
        nombre.textContent = "No se pudieron cargar los datos";
        dni.textContent = "";
    }
}

cargarPacienteSidebar();
