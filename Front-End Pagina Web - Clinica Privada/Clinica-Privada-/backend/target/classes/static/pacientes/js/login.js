const dniInput = document.getElementById("dni");
const pswInput = document.getElementById("psw");
const entrarBtn = document.getElementById("entrar");
const verPasswordCheckbox = document.getElementById("ver-password");
const recoveryText = document.querySelector(".recovery");
const mensajeLogin = document.getElementById("mensaje-login");

verPasswordCheckbox?.addEventListener("change", () => {
    pswInput.type = verPasswordCheckbox.checked ? "text" : "password";
});

entrarBtn.addEventListener("click", async () => {
    const dni = dniInput.value.trim();
    const password = pswInput.value;

    if (!dni || !password) {
        alert("Completá el DNI y la contraseña.");
        return;
    }

    if (!/^\d{8}$/.test(dni)) {
        alert("El DNI debe tener 8 números.");
        return;
    }

    entrarBtn.disabled = true;
    if (mensajeLogin) mensajeLogin.textContent = "";

    try {
        const respuesta = await fetch("/api/auth/login", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ dni, password })
        });

        const resultado = await respuesta.json().catch(() => ({}));

        if (!respuesta.ok) {
            alert(resultado.mensaje || "DNI o contraseña incorrectos.");
            return;
        }

        if (mensajeLogin) {
            mensajeLogin.textContent = `Hola ${resultado.nombre}`;
        }
    } catch (error) {
        alert("No se pudo conectar con la API. Verificá que Spring Boot esté ejecutándose.");
        console.error(error);
    } finally {
        entrarBtn.disabled = false;
    }
});

recoveryText?.addEventListener("click", () => {
    alert("Para recuperar tus datos, comunicate con la administración de la clínica.");
});