package com.clinica.api.auth.controller;

import com.clinica.api.auth.dto.LoginRequest;
import com.clinica.api.auth.dto.PacienteResponseDTO;
import com.clinica.api.auth.dto.RegistroRequest;
import com.clinica.api.auth.service.AuthService;
import com.clinica.api.paciente.entity.Paciente;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.clinica.api.auth.dto.ActualizarContactoRequest;
import jakarta.validation.Valid;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/registro")
    public ResponseEntity<?> registrar(@Valid @RequestBody RegistroRequest datos) {
        Paciente paciente = authService.registrar(datos);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(convertirRespuesta(paciente));
    }

    @PostMapping("/login")
    public ResponseEntity<?> iniciarSesion(
            @Valid @RequestBody LoginRequest datos,
            HttpServletRequest request) {
        Paciente paciente = authService.iniciarSesion(datos.dni(), datos.contrasena());

        HttpSession session = request.getSession(true);
        session.setAttribute("idPaciente", paciente.getIdPaciente());

        return ResponseEntity.ok(convertirRespuesta(paciente));
    }

    @GetMapping("/me")
    public ResponseEntity<PacienteResponseDTO> obtenerPacienteActual(
            HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idPaciente") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        Integer idPaciente = (Integer) session.getAttribute("idPaciente");
        Paciente paciente = authService.buscarPorId(idPaciente);

        return ResponseEntity.ok(convertirRespuesta(paciente));
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> cerrarSesion(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        return ResponseEntity.noContent().build();
    }

    private PacienteResponseDTO convertirRespuesta(Paciente paciente) {
        return new PacienteResponseDTO(
                paciente.getIdPaciente(),
                paciente.getDni(),
                paciente.getNombre(),
                paciente.getApellido(),
                paciente.getNacionalidad(),
                paciente.getFechaNacimiento(),
                paciente.getTelefono(),
                paciente.getEmail(),
                paciente.getSexo(),
                paciente.getDireccion(),
                paciente.getProvincia(),
                paciente.getIdObraSocial());
    }

    @PutMapping("/me/contacto")
    public ResponseEntity<PacienteResponseDTO> actualizarContacto(
            @Valid @RequestBody ActualizarContactoRequest datos,
            HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idPaciente") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        Integer idPaciente = (Integer) session.getAttribute("idPaciente");

        Paciente paciente = authService.actualizarContacto(idPaciente, datos);

        return ResponseEntity.ok(convertirRespuesta(paciente));
    }
}