package com.clinica.api.auth.service;

import com.clinica.api.auth.dto.ActualizarContactoRequest;

import com.clinica.api.auth.dto.RegistroRequest;
import com.clinica.api.paciente.entity.Paciente;
import com.clinica.api.paciente.repository.PacienteRepository;
import com.clinica.api.usuario.entity.Usuario;
import com.clinica.api.usuario.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class AuthService {

        private final PacienteRepository pacienteRepository;
        private final UsuarioRepository usuarioRepository;
        private final PasswordEncoder passwordEncoder;

        public AuthService(
                        PacienteRepository pacienteRepository,
                        UsuarioRepository usuarioRepository,
                        PasswordEncoder passwordEncoder) {
                this.pacienteRepository = pacienteRepository;
                this.usuarioRepository = usuarioRepository;
                this.passwordEncoder = passwordEncoder;
        }

        @Transactional
        public Paciente registrar(RegistroRequest datos) {
                String dni = datos.dni().trim();

                if (!datos.contrasena().equals(datos.confirmarContrasena())) {
                        throw new ResponseStatusException(
                                        HttpStatus.BAD_REQUEST,
                                        "Las contraseñas no coinciden");
                }

                if (pacienteRepository.existsByDni(dni)) {
                        throw new ResponseStatusException(
                                        HttpStatus.CONFLICT,
                                        "Ya existe un paciente con ese DNI");
                }

                Paciente paciente = new Paciente();
                paciente.setDni(dni);
                paciente.setNombre(datos.nombre().trim());
                paciente.setApellido(datos.apellido().trim());
                paciente.setFechaNacimiento(datos.fechaNacimiento());
                paciente.setTelefono(datos.telefono().trim());
                paciente.setEmail(datos.email().trim());
                paciente.setSexo(datos.sexo());
                paciente.setDireccion(datos.direccion().trim());
                paciente.setNacionalidad(datos.nacionalidad());
                paciente.setIdObraSocial(datos.idObraSocial());
                paciente.setProvincia(datos.provincia());

                Paciente pacienteGuardado = pacienteRepository.save(paciente);

                Usuario usuario = new Usuario();
                usuario.setPaciente(pacienteGuardado);
                usuario.setContrasena(passwordEncoder.encode(datos.contrasena()));
                usuario.setEstado("ACTIVO");

                usuarioRepository.save(usuario);

                return pacienteGuardado;
        }

        @Transactional(readOnly = true)
        public Paciente iniciarSesion(String dni, String contrasena) {
                Usuario usuario = usuarioRepository.findByPaciente_Dni(dni.trim())
                                .orElseThrow(() -> new ResponseStatusException(
                                                HttpStatus.UNAUTHORIZED,
                                                "DNI o contraseña incorrectos"));

                boolean contrasenaCorrecta = passwordEncoder.matches(contrasena, usuario.getContrasena());

                if (!"ACTIVO".equals(usuario.getEstado()) || !contrasenaCorrecta) {
                        throw new ResponseStatusException(
                                        HttpStatus.UNAUTHORIZED,
                                        "DNI o contraseña incorrectos");
                }

                return usuario.getPaciente();
        }

        @Transactional(readOnly = true)
        public Paciente buscarPorId(Integer idPaciente) {
                return pacienteRepository.findById(idPaciente)
                                .orElseThrow(() -> new ResponseStatusException(
                                                HttpStatus.NOT_FOUND,
                                                "No se encontró el paciente"));
        }

        @Transactional
        public Paciente actualizarContacto(Integer idPaciente, ActualizarContactoRequest datos) {
                Paciente paciente = buscarPorId(idPaciente);

                paciente.setEmail(datos.email().trim());
                paciente.setTelefono(datos.telefono().trim());
                paciente.setDireccion(datos.direccion().trim());
                paciente.setProvincia(datos.provincia());

                return pacienteRepository.save(paciente);
        }
}