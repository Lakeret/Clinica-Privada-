package com.clinica.api.paciente.dto;

public record PacienteDTO(
        Integer idPaciente,
        String dni,
        String nombre,
        String apellido
) {
}