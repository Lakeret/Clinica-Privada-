package com.clinica.api.auth.service;

import com.clinica.api.auth.dto.ActualizarContactoRequest;

import com.clinica.api.auth.dto.RegistroRequest;
import com.clinica.api.paciente.entity.Paciente;
import com.clinica.api.paciente.repository.PacienteRepository;
import com.clinica.api.usuario.entity.Usuario;
import com.clinica.api.usuario.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;

@Service
public class AuthService {

        private final PacienteRepository pacienteRepository;
        private final UsuarioRepository usuarioRepository;
        private final PasswordEncoder passwordEncoder;
        private final JdbcTemplate jdbcTemplate;

        public AuthService(
                        PacienteRepository pacienteRepository,
                        UsuarioRepository usuarioRepository,
                        PasswordEncoder passwordEncoder,
                        JdbcTemplate jdbcTemplate) {
                this.pacienteRepository = pacienteRepository;
                this.usuarioRepository = usuarioRepository;
                this.passwordEncoder = passwordEncoder;
                this.jdbcTemplate = jdbcTemplate;
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

                Integer idPaciente = jdbcTemplate.queryForObject(
                                "CALL AgregarPaciente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                                (resultado, fila) -> resultado.getInt("id_paciente"),
                                datos.idObraSocial(),
                                dni,
                                datos.nombre().trim(),
                                datos.apellido().trim(),
                                datos.fechaNacimiento(),
                                datos.sexo(),
                                datos.telefono().trim(),
                                datos.email().trim(),
                                datos.direccion(),
                                datos.nacionalidad(),
                                datos.provincia());

                Paciente pacienteGuardado = buscarPorId(idPaciente);

                Usuario usuario = new Usuario();
                usuario.setPaciente(pacienteGuardado);
                usuario.setContrasena(passwordEncoder.encode(datos.contrasena()));
                usuario.setEstado("ACTIVO");

                usuarioRepository.save(usuario);

                return pacienteGuardado;
        }

        @Transactional(readOnly = true)
        public Paciente iniciarSesion(String dni, String contrasena) {
                Map<String, Object> credenciales;
                try {
                        credenciales = jdbcTemplate.queryForMap(
                                        "CALL BuscarCredencialesPaciente(?)",
                                        dni.trim());
                } catch (EmptyResultDataAccessException error) {
                        throw new ResponseStatusException(
                                        HttpStatus.UNAUTHORIZED,
                                        "DNI o contraseña incorrectos");
                }

                String contrasenaGuardada = (String) credenciales.get("contrasena");
                String estado = (String) credenciales.get("estado");
                Integer idPaciente = ((Number) credenciales.get("id_paciente")).intValue();

                boolean contrasenaCorrecta = passwordEncoder.matches(contrasena, contrasenaGuardada);

                if (!"ACTIVO".equals(estado) || !contrasenaCorrecta) {
                        throw new ResponseStatusException(
                                        HttpStatus.UNAUTHORIZED,
                                        "DNI o contraseña incorrectos");
                }

                return buscarPorId(idPaciente);
        }

        @Transactional(readOnly = true)
        public Paciente buscarPorId(Integer idPaciente) {
                try {
                        return jdbcTemplate.queryForObject(
                                        "CALL ObtenerPacientePorId(?)",
                                        (resultado, fila) -> {
                                                Paciente paciente = new Paciente();
                                                paciente.setIdPaciente(resultado.getInt("id_paciente"));
                                                paciente.setDni(resultado.getString("dni"));
                                                paciente.setNombre(resultado.getString("nombre"));
                                                paciente.setApellido(resultado.getString("apellido"));
                                                paciente.setFechaNacimiento(resultado.getDate("fecha_nacimiento") == null
                                                                ? null
                                                                : resultado.getDate("fecha_nacimiento").toLocalDate());
                                                paciente.setSexo(resultado.getString("sexo"));
                                                paciente.setTelefono(resultado.getString("telefono"));
                                                paciente.setEmail(resultado.getString("email"));
                                                paciente.setDireccion(resultado.getString("direccion"));
                                                paciente.setNacionalidad(resultado.getString("nacionalidad"));
                                                paciente.setProvincia(resultado.getString("provincia"));

                                                Object idObraSocial = resultado.getObject("id_obra_social");
                                                paciente.setIdObraSocial(idObraSocial == null
                                                                ? null
                                                                : ((Number) idObraSocial).intValue());
                                                return paciente;
                                        },
                                        idPaciente);
                } catch (EmptyResultDataAccessException error) {
                        throw new ResponseStatusException(
                                        HttpStatus.NOT_FOUND,
                                        "No se encontró el paciente");
                }
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

        @Transactional
        public void eliminarCuenta(Integer idPaciente) {
                jdbcTemplate.queryForObject(
                                "CALL EliminarCuentaPaciente(?)",
                                (resultado, fila) -> resultado.getString("resultado"),
                                idPaciente);
        }
}
