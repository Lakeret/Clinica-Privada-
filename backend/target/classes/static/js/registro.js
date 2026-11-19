const formularioRegistro = document.getElementById("form-registro");
const mensajeRegistro = document.getElementById("mensaje-registro");
const botonRegistro = document.getElementById("entrar");
const passwordInput = document.getElementById("password");
const confirmarPasswordInput = document.getElementById("confirmar-password");
const verPassword = document.getElementById("ver-password");

verPassword.addEventListener("change", () => {
    if (verPassword.checked) {
        passwordInput.type = "text";
        confirmarPasswordInput.type = "text";
    } else {
        passwordInput.type = "password";
        confirmarPasswordInput.type = "password";
    }
});

formularioRegistro.addEventListener("submit", async (event) => {
    event.preventDefault();

    mensajeRegistro.textContent = "";

    const dni = document.getElementById("dni").value.trim();
    const contrasena = passwordInput.value;
    const confirmarContrasena = confirmarPasswordInput.value;
    const obraSocialSeleccionada = document.getElementById("obraSocial").value;

    if (dni.length < 7 || dni.length > 9 || isNaN(dni)) {
        mensajeRegistro.textContent = "El DNI debe tener entre 7 y 8 números.";
        return;
    }

    if (contrasena !== confirmarContrasena) {
        mensajeRegistro.textContent = "Las contraseñas no coinciden.";
        return;
    }

    if (contrasena.length <= 8 || contrasena.length > 72) {
        mensajeRegistro.textContent = "La contraseña debe tener entre 8 y 72 caracteres.";
        return;
    }

    botonRegistro.disabled = true;

    const datos = {
        dni,
        nombre: document.getElementById("nombre").value.trim(),
        apellido: document.getElementById("apellido").value.trim(),
        nacionalidad: document.getElementById("nacionalidad").value,
        sexo: document.getElementById("sexo").value,
        direccion: document.getElementById("direccion").value.trim(),
        provincia: document.getElementById("provincia").value,
        contrasena,
        confirmarContrasena,
        idObraSocial: obraSocialSeleccionada ? Number(obraSocialSeleccionada) : null,
        telefono: document.getElementById("tele").value.trim(),
        email: document.getElementById("correo").value.trim(),
        fechaNacimiento: document.getElementById("nacimiento").value
    };

    try {
        const respuesta = await fetch("/api/auth/registro", {
            method: "POST",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(datos)
        });

        const resultado = await respuesta.json().catch(() => ({}));

        if (!respuesta.ok) {
            throw new Error(resultado.detail || "No se pudo crear la cuenta.");
        }

        mensajeRegistro.textContent = "Cuenta creada con exito...";

        setTimeout(() => {
            window.location.href = "../paginas/LogIn-Pacientes.html";
        }, 2200);
    } catch (error) {
        mensajeRegistro.textContent =
            error.message || "No se pudo conectar con la API.";
    } finally {
        botonRegistro.disabled = false;
    }
});