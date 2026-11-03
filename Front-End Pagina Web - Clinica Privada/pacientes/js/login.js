const dni = document.getElementById("dni");

function validacion(){
    if(dni.value.length === 8){
        window.location.href = "./inicio-paciente.html";
    }else{
        alert("Ingrese dni valido");
    }
}