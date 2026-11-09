package com.clinica.api.turno.repository;

import com.clinica.api.turno.entity.Turno;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TurnoRepository extends JpaRepository<Turno, Integer> {

    List<Turno> findByIdPacienteOrderByFechaAscHoraAsc(Integer idPaciente);
}