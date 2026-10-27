document.addEventListener('DOMContentLoaded', () => {
    const dniInput = document.getElementById('dni');
    const pswInput = document.getElementById('psw');
    const entrarBtn = document.getElementById('entrar');
    const recoveryLink = document.querySelector('.recovery');

    // ==========================================
    // 1. MOSTRAR / OCULTAR CONTRASEÑA
    // ==========================================
    // Creamos dinámicamente un ícono de ojo dentro del contenedor de la contraseña
    const passwordContainer = pswInput.parentElement;
    
    // Aseguramos posición relativa para posicionar el ícono absoluto
    pswInput.style.position = 'relative';
    
    const eyeIcon = document.createElement('i');
    eyeIcon.className = 'fa-solid fa-eye toggle-password';
    eyeIcon.setAttribute('title', 'Mostrar/Ocultar contraseña');
    
    // Estilos rápidos para el ícono dentro del input
    eyeIcon.style.position = 'absolute';
    eyeIcon.style.right = '15px';
    eyeIcon.style.top = '48px'; // Ajustalo según tu diseño
    eyeIcon.style.cursor = 'pointer';
    eyeIcon.style.color = '#71818a';

    // Insertamos el ícono después del input de contraseña
    pswInput.insertAdjacentElement('afterend', eyeIcon);

    eyeIcon.addEventListener('click', () => {
        const type = pswInput.getAttribute('type') === 'password' ? 'text' : 'password';
        pswInput.setAttribute('type', type);
        
        // Cambiar el ícono del ojo
        eyeIcon.classList.toggle('fa-eye');
        eyeIcon.classList.toggle('fa-eye-slash');
    });

    // ==========================================
    // 2 y 3. VALIDACIÓN Y ESTADO DE CARGA (LOADING)
    // ==========================================
    // Cambiamos el tipo de botón a 'button' en HTML para controlarlo desde JS
    entrarBtn.addEventListener('click', (e) => {
        e.preventDefault(); // Evita que recargue o navegue sin validar

        const dniValue = dniInput.value.trim();
        const pswValue = pswInput.value.trim();

        // Validar campos vacíos
        if (dniValue === '' || pswValue === '') {
            alert('Por favor, completá todos los campos.');
            highlightError(dniValue === '' ? dniInput : pswInput);
            return;
        }

        // Validar que el DNI sea numérico
        if (isNaN(dniValue) ) {
            alert('El DNI debe contener únicamente números.');
            highlightError(dniInput);
            return;
        }

        // Estado de carga (Loading)
        entrarBtn.disabled = true;
        entrarBtn.style.opacity = '0.7';
        entrarBtn.style.cursor = 'cargando';
        entrarBtn.textContent = 'Verificando datos...';

        // Simular tiempo de respuesta de servidor (1.2 segundos) y redirigir
        setTimeout(() => {
            location.href = 'Inicio.html';
        }, 2000);
    });

    // Función auxiliar para resaltar campos con error
    function highlightError(inputElement) {
        inputElement.style.borderColor = '#d71920';
        inputElement.focus();
        setTimeout(() => {
            inputElement.style.borderColor = '#d5dfe4';
        }, 3000);
    }

    // ==========================================
    // 4. AYUDA / RECUPERACIÓN INTERACTIVA
    // ==========================================
    recoveryLink.addEventListener('click', () => {
        alert('¿Olvidaste tus datos?\n\nPara recuperar tu contraseña o usuario, comunicate con la administración de la clínica.');
    });
});