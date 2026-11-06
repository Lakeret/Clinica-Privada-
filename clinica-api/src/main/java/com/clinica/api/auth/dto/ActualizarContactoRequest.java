package com.clinica.api.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ActualizarContactoRequest(
        @NotBlank
        @Email
        @Size(max = 150)
        String email,

        @NotBlank
        @Size(max = 30)
        String telefono,

        @NotBlank
        @Size(max = 200)
        String direccion,

        @NotBlank
        @Size(max = 60)
        String provincia
) {
}