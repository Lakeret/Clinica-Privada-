package com.clinica.api.turno.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.time.LocalTime;

public record TurnoRequest(
        @NotNull
        LocalDate fecha,

        @NotNull
        @JsonFormat(pattern = "HH:mm")
        LocalTime hora,

        @NotBlank
        String especialidad
) {
}