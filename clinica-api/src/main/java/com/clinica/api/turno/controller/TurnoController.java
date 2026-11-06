package com.clinica.api.turno.controller;

import com.clinica.api.turno.dto.TurnoRequest;
import com.clinica.api.turno.dto.TurnoResponseDTO;
import com.clinica.api.turno.service.TurnoService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/turnos")
public class TurnoController {

    private final TurnoService turnoService;

    public TurnoController(TurnoService turnoService) {
        this.turnoService = turnoService;
    }

    @GetMapping("/mis-turnos")
    public ResponseEntity<List<TurnoResponseDTO>> obtenerMisTurnos(
            HttpServletRequest request
    ) {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idPaciente") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        Integer idPaciente = (Integer) session.getAttribute("idPaciente");
        return ResponseEntity.ok(turnoService.listarPorPaciente(idPaciente));
    }

    @PostMapping
    public ResponseEntity<String> crearTurno(
            @Valid @RequestBody TurnoRequest datos,
            HttpServletRequest request
    ) {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idPaciente") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        Integer idPaciente = (Integer) session.getAttribute("idPaciente");
        String mensaje = turnoService.crearTurno(idPaciente, datos);

        return ResponseEntity.status(HttpStatus.CREATED).body(mensaje);
    }
}