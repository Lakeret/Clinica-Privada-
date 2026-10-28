const dniInput = document.getElementById("dni");
const pswInput = document.getElementById("psw");
const entrarBtn = document.getElementById("entrar");
const verPasswordCheckbox = document.getElementById("ver-password");
const recoveryText = document.querySelector(".recovery");

verPasswordCheckbox.addEventListener("change", () => {
    if (verPasswordCheckbox.checked) {
        pswInput.type = "text";
    } else {
        pswInput.type = "password";
    }
});

entrarBtn.addEventListener("click", () => {
    if (dniInput.value === "" || pswInput.value === "") {
        alert("Todos los campos deben estar completos");
    } else {
        if(dniInput.value.length === 8){
            window.location.href = 'index.html';    
        }else{
            alert("El dni debe ser valido.");
        }
    }
});

recoveryText.addEventListener("click", () => {
    alert("Para recuperar tus datos comunicate con la clinica");
});