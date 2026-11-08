const formularioLogin = document.getElementById("form-login");
const dniInput = document.getElementById("dni");
const passwordInput = document.getElementById("psw");
const verPassword = document.getElementById("ver-password");
const mensajeLogin = document.getElementById("mensaje-login");
const botonLogin = document.getElementById("entrar");

verPassword?.addEventListener("change", () => {
    passwordInput.type = verPassword.checked ? "text" : "password";
});

formularioLogin?.addEventListener("submit", async (event) => {
    event.preventDefault();

    mensajeLogin.textContent = "";

    const dni = dniInput.value.trim();
    const contrasena = passwordInput.value;

    if (!/^\d{7,10}$/.test(dni)) {
        mensajeLogin.textContent = "Ingresá un DNI válido.";
        return;
    }

    botonLogin.disabled = true;

    try {
        const respuesta = await fetch("/api/auth/login", {
            method: "POST",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ dni, contrasena })
        });

        const resultado = await respuesta.json().catch(() => ({}));

        if (!respuesta.ok) {
            throw new Error(resultado.detail || "DNI o contraseña incorrectos.");
        }

        window.location.href = "../paginas/inicio-paciente.html";
    } catch (error) {
        mensajeLogin.textContent =
            error.message || "No se pudo conectar con la API.";
    } finally {
        botonLogin.disabled = false;
    }
});

document.querySelector(".recovery")?.addEventListener("click", () => {
    alert("Para recuperar tus datos, comunicate con la administración de la clínica.");
});