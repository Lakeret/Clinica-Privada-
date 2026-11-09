package com.clinica.api.turno.dto;

import java.time.LocalDate;

public record TurnoResponseDTO(
        LocalDate fecha,
        String hora,
        String especialidad,
        String profesional,
        String estado
) {
}