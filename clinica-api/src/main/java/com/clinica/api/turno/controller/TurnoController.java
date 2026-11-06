package com.clinica.api.turno.controller;

import com.clinica.api.turno.dto.TurnoResponseDTO;
import com.clinica.api.turno.repository.TurnoRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/turnos")
public class TurnoController {

    private final TurnoRepository turnoRepository;

    public TurnoController(TurnoRepository turnoRepository) {
        this.turnoRepository = turnoRepository;
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

        List<TurnoResponseDTO> turnos = turnoRepository
                .findByIdPacienteOrderByFechaAscHoraAsc(idPaciente)
                .stream()
                .map(turno -> new TurnoResponseDTO(
                        turno.getFecha(),
                        turno.getHora().toString(),
                        "Pendiente de vincular",
                        "Pendiente de vincular",
                        turno.getEstado()
                ))
                .toList();

        return ResponseEntity.ok(turnos);
    }
}