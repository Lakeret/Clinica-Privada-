async function cargarDatosPaciente() {
    const nombreElemento = document.getElementById("nombrePaciente");
    const dniElemento = document.getElementById("dniPaciente");
    const saludoElemento = document.getElementById("saludoPaciente");

    try {
        const respuesta = await fetch("/api/auth/me", {
            credentials: "same-origin"
        });

        if (respuesta.status === 401) {
            window.location.href = "LogIn-Pacientes.html";
            return;
        }

        if (!respuesta.ok) {
            throw new Error("No se pudieron cargar los datos.");
        }

        const paciente = await respuesta.json();
        const nombreCompleto = `${paciente.nombre} ${paciente.apellido}`;

        nombreElemento.textContent = nombreCompleto;
        dniElemento.textContent = `DNI: ${paciente.dni}`;
        saludoElemento.textContent = paciente.nombre;
    } catch (error) {
        console.error("Error al cargar el paciente:", error);
        saludoElemento.textContent = "No se pudieron cargar tus datos";
    }
}

cargarDatosPaciente();