package com.clinica.api.paciente.controller;

import com.clinica.api.paciente.dto.PacienteDTO;
import com.clinica.api.paciente.service.PacienteService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pacientes")
public class PacienteController {

    private final PacienteService pacienteService;

    public PacienteController(PacienteService pacienteService) {
        this.pacienteService = pacienteService;
    }

    @GetMapping
    public List<PacienteDTO> obtenerPacientes() {
        return pacienteService.listarPacientes();
    }
}