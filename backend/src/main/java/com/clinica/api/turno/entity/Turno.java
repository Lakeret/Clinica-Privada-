package com.clinica.api.turno.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "turno")
public class Turno {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_turno")
    private Integer idTurno;

    @Column(name = "id_paciente", nullable = false)
    private Integer idPaciente;

    @Column(name = "id_empleado", nullable = false)
    private Integer idEmpleado;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false)
    private LocalTime hora;

    @Column(nullable = false)
    private String estado;

    private String motivo;

    public Integer getIdTurno() {
        return idTurno;
    }

    public Integer getIdPaciente() {
        return idPaciente;
    }

    public Integer getIdEmpleado() {
        return idEmpleado;
    }

    public LocalDate getFecha() {
        return fecha;
    }

    public LocalTime getHora() {
        return hora;
    }

    public String getEstado() {
        return estado;
    }

    public String getMotivo() {
        return motivo;
    }
}