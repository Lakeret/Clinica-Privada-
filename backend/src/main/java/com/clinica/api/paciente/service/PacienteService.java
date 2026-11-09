package com.clinica.api.paciente.service;

import com.clinica.api.paciente.dto.PacienteDTO;
import com.clinica.api.paciente.repository.PacienteRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PacienteService {

    private final PacienteRepository pacienteRepository;

    public PacienteService(PacienteRepository pacienteRepository) {
        this.pacienteRepository = pacienteRepository;
    }

    public List<PacienteDTO> listarPacientes() {
        return pacienteRepository.findAll()
                .stream()
                .map(paciente -> new PacienteDTO(
                        paciente.getIdPaciente(),
                        paciente.getDni(),
                        paciente.getNombre(),
                        paciente.getApellido()
                ))
                .toList();
    }
}