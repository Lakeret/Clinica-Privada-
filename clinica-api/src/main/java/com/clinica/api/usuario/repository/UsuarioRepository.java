package com.clinica.api.usuario.repository;

import com.clinica.api.usuario.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Integer> {
    Optional<Usuario> findByPaciente_Dni(String dni);
    boolean existsByPaciente_Dni(String dni);
}