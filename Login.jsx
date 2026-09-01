import { useState } from 'react'
import './Login.css'

function InicioSesion() {
  const [dni, setDni] = useState("");
  const [password, setPassword] = useState("");
  const [genero, setGenero] = useState("");

  const IngresoDatos = () => {
    if (!dni || !password || !genero) {
      alert("Por favor, completa todos los campos antes de continuar.");
      return;
    }
    console.log("DNI ingresado:", dni);
    console.log("Contraseña ingresado:", password);
    console.log("Gnero seleccionado:", genero);
  };

  return (
    <section id="mainn">
      <div className="bienvenido">
        <h2>Bienvenido/a</h2>
        <p>Ingrese a su cuenta para continuar</p>
      </div>
      <div className="login">
        <h1>INICIAR SESION</h1>
        <h3>DNI</h3>
        <input id='dni' type="number" placeholder="Ingrese su DNI" value={dni} onChange={(e) => setDni(e.target.value)} required />
        <h3>CONTRASEÑA</h3>
        <input id='psw' type='password' placeholder='Ingrese su contraseña' value={password} onChange={(e) => setPassword(e.target.value)} required />
        <h3>GENERO</h3>
        <div className='genero'>
          <label>
            <input type="radio" name="genero" value="Femenino" checked={genero == "Femenino"} onChange={(e) => setGenero(e.target.value)} /> Femenino
          </label>
          <label>
            <input type="radio" name="genero" value="Masculino" checked={genero == "Masculino"} onChange={(e) => setGenero(e.target.value)} /> Masculino
          </label>
          <label>
            <input type="radio" name="genero" value="X" checked={genero == "X"} onChange={(e) => setGenero(e.target.value)} /> X
          </label>
        </div>
        <button id="entrar" type="button" onClick={IngresoDatos}>Iniciar Sesion</button>
        <p className="recovery">¿Olvidaste tu contraseña?</p>
      </div>
    </section>
  )
}

function Login() {

  return (
    <>
      <section id="encabezado">
        <div className="texto-logo">
          <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Spotify_logo_without_text.svg/500px-Spotify_logo_without_text.svg.png?utm_source=es.wikipedia.org&utm_campaign=index&utm_content=thumbnail" alt="logo" />
          <div className="texto-encabezado">
            <h1>CLINICA PRIVADA</h1>
            <p>CUIDANDOTE SIEMPRE</p>
          </div>
        </div>
        <div className="navegador">
          <ul>
            <li>Inicio</li>
            <li>Ubicaion</li>
            <li>Contacto</li>
            <li>Ayuda</li>
          </ul>
        </div>
      </section>

      <InicioSesion />
      <footer>
        <h1>CLINICA PRIVADA</h1>
        <h4>CUIDANDOE SIEMRPE</h4>
        <p>© 2026 Clínica Privada · Todos los derechos reservados</p>
      </footer>
    </>
  )
}

export default Login
