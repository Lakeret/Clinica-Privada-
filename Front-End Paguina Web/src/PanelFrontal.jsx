import { useState } from 'react'
import "./PanelFrontal.css"
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {faBars, faBell, faRightToBracket, faExclamation } from '@fortawesome/free-solid-svg-icons';

function Header() {
    return (
        <>
            <header>
                <section id="encabezado2">
                    <h1><FontAwesomeIcon icon={faBars} /></h1>
                    <div className="texto1">
                        <h1>CLINICA PRIVADA</h1>
                        <p>CUIDANDOTE SIEMPRE</p>
                    </div>
                    <div className="usuario">
                        <span><FontAwesomeIcon icon={faBell} /></span>
                        <strong>DR.NombreDoctor</strong>
                        <span><FontAwesomeIcon icon={faRightToBracket} /></span>
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
            <main>
                <section id='fondo2'>
                    <div className='bienvenida-dr'>
                        <h1>Bienvenido/a DR.NombreDoctor</h1>
                    </div>
                    <div className='cuadricula'>
                        <div className='activos'>
                            <h3>Pacientes</h3>
                            <p>99</p>
                            <h3>Activos</h3>
                        </div>
                        <div className='guardia'>
                            <h3>Guardia</h3>
                            <p>99</p>
                            <h3>En Atencion</h3>
                        </div>
                        <div className='salas'>
                            <h3>Salas</h3>
                            <p>99</p>
                            <h3>Ocupadas</h3>
                        </div>
                        <div className='alertas'>
                            <h3>Pacientes</h3>
                            <p>99</p>
                            <h3>Requiere Atencion</h3>
                        </div>
                    </div>
                    <div className='cuadri'>
                        <div className='alertas-urgencias'>
                            <div className='textoAlertas'>
                                <h4><FontAwesomeIcon icon={faExclamation} />ALERTAS Y URGENCIAS</h4>
                            </div>
                            <div className='urgencias'>
                                <div className='circulo-rojo'></div>
                                <div>
                                    <h3>URGENCIA - Habitacion 99</h3>
                                    <p>Emergencia cardiorespiratoria paciente: NombrePaciente</p>
                                </div>
                            </div>
                            <div className='atencion'>
                                <div className='circulo-naranja'></div>
                                <div>
                                    <h3>ATENCION - Habitacion 99</h3>
                                    <p>Atencion para el Paciente: NombrePaciente ID</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="parte-inferior">

                        <div className="ultimos-pacientes">
                            <h3>ULTIMOS PACIENTES</h3>

                            <div className="paciente">
                                <span>Paciente 999</span>
                                <span>Habitacion 999</span>
                                <span className="estado-verde"></span>
                            </div>

                            <div className="paciente">
                                <span>Paciente 999</span>
                                <span>Habitacion 999</span>
                                <span className="estado-naranja"></span>
                            </div>

                            <div className="paciente">
                                <span>Paciente 999</span>
                                <span>Habitacion 999</span>
                                <span className="estado-verde"></span>
                            </div>
                        </div>

                        <div className="turnos">
                            <h3>TURNOS DE HOY</h3>

                            <div className="turno">
                                <span>10:00</span>
                                <span>NombrePaciente</span>
                                <span>DNI</span>
                            </div>

                            <div className="turno">
                                <span>10:00</span>
                                <span>NombrePaciente</span>
                                <span>DNI</span>
                            </div>

                            <div className="turno">
                                <span>10:00</span>
                                <span>NombrePaciente</span>
                                <span>DNI</span>
                            </div>
                        </div>

                    </div>
                </section>
            </main>
        </>
    )
}

function Inicio() {


    return (
        <>
            <Header />
            <Main />
            <Footer />
        </>
    )
}

export default Inicio
