const formularioRegistro = document.getElementById("form-registro");
const mensajeRegistro = document.getElementById("mensaje-registro");
const botonRegistro = document.getElementById("entrar");
const passwordInput = document.getElementById("password");
const confirmarPasswordInput = document.getElementById("confirmar-password");
const verPassword = document.getElementById("ver-password");

verPassword?.addEventListener("change", () => {
    const tipo = verPassword.checked ? "text" : "password";
    passwordInput.type = tipo;
    confirmarPasswordInput.type = tipo;
});

formularioRegistro?.addEventListener("submit", async (event) => {
    event.preventDefault();

    mensajeRegistro.textContent = "";

    const dni = document.getElementById("dni").value.trim();
    const contrasena = passwordInput.value;
    const confirmarContrasena = confirmarPasswordInput.value;
    const obraSocialSeleccionada = document.getElementById("obraSocial").value;

    if (!/^\d{7,10}$/.test(dni)) {
        mensajeRegistro.textContent = "El DNI debe tener entre 7 y 10 números.";
        return;
    }

    if (contrasena !== confirmarContrasena) {
        mensajeRegistro.textContent = "Las contraseñas no coinciden.";
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
        idObraSocial: obraSocialSeleccionada? Number(obraSocialSeleccionada): null,
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

        mensajeRegistro.textContent = "Cuenta creada. Redirigiendo al inicio de sesión…";

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