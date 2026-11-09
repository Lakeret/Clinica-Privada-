package com.clinica.api.usuario.entity;

import com.clinica.api.paciente.entity.Paciente;
import jakarta.persistence.*;

@Entity
@Table(name = "usuario")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    private Integer idUsuario;

    @OneToOne
    @JoinColumn(name = "id_paciente", unique = true)
    private Paciente paciente;

    @Column(name = "contrasena", nullable = false, length = 255)
    private String contrasena;

    @Column(nullable = false, length = 20)
    private String estado = "ACTIVO";

    public Usuario() {
    }

    public Integer getIdUsuario() { return idUsuario; }
    public Paciente getPaciente() { return paciente; }
    public String getContrasena() { return contrasena; }
    public String getEstado() { return estado; }

    public void setPaciente(Paciente paciente) { this.paciente = paciente; }
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }
    public void setEstado(String estado) { this.estado = estado; }
}