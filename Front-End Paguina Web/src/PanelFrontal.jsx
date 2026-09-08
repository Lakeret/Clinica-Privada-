import { useState } from 'react'
import "./PanelFrontal.css"

function Header() {
    return (
        <>
            <header>
                <section id="arriba">
                    <div className="texto1">
                        <h1>CLINICA PRIVADA</h1>
                        <p>CUIDANDOTE SIEMPRE</p>
                    </div>
                    <div className="nave">
                        <ul>
                            <li>Inicio</li>
                            <li>Ubicaion</li>
                            <li>Contacto</li>
                            <li>Ayuda</li>
                        </ul>
                    </div>
                </section>
            </header>
        </>
    )
}

function Footer() {
    return (
        <>
            <footer>
                <h1>CLINICA PRIVADA</h1>
                <h4>CUIDANDOE SIEMRPE</h4>
                <p>© 2026 Clínica Privada · Todos los derechos reservados</p>
            </footer>
        </>
    )
}

function Main() {
    return (
        <>

        </>
    )
}

function Inicio() {


    return (
        <>
            <Header />
            <Footer />
        </>
    )
}

export default Inicio