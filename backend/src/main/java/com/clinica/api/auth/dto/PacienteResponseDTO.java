package com.clinica.api.auth.dto;

import java.time.LocalDate;

public record PacienteResponseDTO(
        Integer idPaciente,
        String dni,
        String nombre,
        String apellido,
        String nacionalidad,
        LocalDate fechaNacimiento,
        String telefono,
        String email,
        String sexo,
        String direccion,
        String provincia,
        Integer idObraSocial
) {
}