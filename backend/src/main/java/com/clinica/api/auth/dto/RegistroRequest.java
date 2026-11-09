package com.clinica.api.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

public record RegistroRequest(
        @NotBlank
        @Pattern(regexp = "\\d{7,10}", message = "El DNI debe tener entre 7 y 10 números")
        String dni,

        @NotBlank
        @Size(max = 80)
        String nombre,

        @NotBlank
        @Size(max = 80)
        String apellido,

        @NotBlank
        @Size(min = 8, max = 72)
        String contrasena,

        @NotBlank
        String confirmarContrasena,

        @NotBlank
        @Size(max = 30)
        String telefono,

        @NotBlank
        @Email
        @Size(max = 150)
        String email,

        @NotNull
        @Past
        LocalDate fechaNacimiento,

        @Pattern(
        regexp = "F|M|X|NO_ESPECIFICADO",
        message = "Seleccioná una opción válida para el sexo"
        )
        String sexo,

        @Size(max = 200)
        String direccion,

        @NotBlank(message = "Seleccione una nacionalidad")
        @Size(max = 60)
        String nacionalidad,

        Integer idObraSocial,

        @NotBlank
        @Size(max = 60)
        String provincia
) {
}