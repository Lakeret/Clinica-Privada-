document.addEventListener("DOMContentLoaded", () => {
    
    const usuarioInput = document.getElementById("usuario");
    const pswInput = document.getElementById("psw");
    const entrarBtn = document.getElementById("entrar");
    if (!usuarioInput || !pswInput || !entrarBtn) {
        console.error("Error: Uno o más elementos no se encontraron en el HTML. Revisa los IDs.");
        return;
    }

    entrarBtn.addEventListener('click', (e) => {
        e.preventDefault(); 

        if (usuarioInput.value.trim() === "" || pswInput.value.trim() === "") {
            alert("Todos los campos deben estar completos");
        } else {
            window.location.href = 'paginas/Inicio.html';
        }
    });
});
