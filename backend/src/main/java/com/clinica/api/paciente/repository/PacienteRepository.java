package com.clinica.api.paciente.repository;

import com.clinica.api.paciente.entity.Paciente;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PacienteRepository extends JpaRepository<Paciente, Integer> {
    boolean existsByDni(String dni);
}