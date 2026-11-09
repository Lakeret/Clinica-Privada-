package com.clinica.api.auth.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record LoginRequest(
        @NotBlank
        @Pattern(regexp = "\\d{7,10}")
        String dni,

        @NotBlank
        String contrasena
) {
}