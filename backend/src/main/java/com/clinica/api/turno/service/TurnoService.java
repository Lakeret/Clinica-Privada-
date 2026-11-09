package com.clinica.api.turno.service;

import com.clinica.api.turno.dto.TurnoRequest;
import com.clinica.api.turno.dto.TurnoResponseDTO;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class TurnoService {

    private final JdbcTemplate jdbcTemplate;

    public TurnoService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<TurnoResponseDTO> listarPorPaciente(Integer idPaciente) {
        return jdbcTemplate.query(
                "CALL ObtenerTurnosPaciente(?)",
                (resultado, fila) -> new TurnoResponseDTO(
                        resultado.getDate("fecha").toLocalDate(),
                        resultado.getTime("hora").toString(),
                        resultado.getString("especialidad"),
                        resultado.getString("profesional"),
                        resultado.getString("estado")
                ),
                idPaciente
        );
    }

    public String crearTurno(Integer idPaciente, TurnoRequest datos) {
        Integer idMedico;

        try {
            idMedico = jdbcTemplate.queryForObject(
                    "SELECT m.id_empleado " +
                            "FROM medico m " +
                            "JOIN empleado e ON e.id_empleado = m.id_empleado " +
                            "WHERE LOWER(m.especialidad) = LOWER(?) " +
                            "AND e.estado = 'ACTIVO' " +
                            "ORDER BY m.id_empleado " +
                            "LIMIT 1",
                    Integer.class,
                    datos.especialidad().trim()
            );
        } catch (EmptyResultDataAccessException error) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND,
                    "No hay un médico activo para esa especialidad"
            );
        }

        try {
            jdbcTemplate.queryForObject(
                    "CALL CrearTurno(?, ?, ?, ?, ?)",
                    (resultado, fila) -> resultado.getInt("id_turno"),
                    idPaciente,
                    idMedico,
                    datos.fecha(),
                    datos.hora(),
                    "Consulta de " + datos.especialidad().trim()
            );
        } catch (DataAccessException error) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Ese horario no está disponible. Elegí otra fecha u hora"
            );
        }

        return "Turno creado correctamente";
    }
}