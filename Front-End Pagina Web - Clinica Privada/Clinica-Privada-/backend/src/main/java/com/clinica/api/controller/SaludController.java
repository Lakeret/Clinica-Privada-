package com.clinica.api.controller;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class SaludController {

    @GetMapping("/salud")
    public Map<String, String> verificarEstado() {
        return Map.of("mensaje", "API de Clínica Privada funcionando");
    }
}