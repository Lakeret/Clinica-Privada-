function abrirModal() {
    document.getElementById('inputEmail').value = document.getElementById('txtEmail').innerText;
    document.getElementById('inputTel').value = document.getElementById('txtTel').innerText;
    document.getElementById('inputDireccion').value = document.getElementById('txtDireccion').innerText;
    document.getElementById('modalEdicion').style.display = 'flex';
}

function cerrarModal() {
    document.getElementById('modalEdicion').style.display = 'none';
}

function guardarDatos(e) {
    e.preventDefault();
    document.getElementById('txtEmail').innerText = document.getElementById('inputEmail').value;
    document.getElementById('txtTel').innerText = document.getElementById('inputTel').value;
    document.getElementById('txtDireccion').innerText = document.getElementById('inputDireccion').value;
    cerrarModal();
}