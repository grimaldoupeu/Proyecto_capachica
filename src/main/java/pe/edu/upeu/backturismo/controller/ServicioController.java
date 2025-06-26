package pe.edu.upeu.backturismo.controller;

import pe.edu.upeu.backturismo.entity.Servicio;
import pe.edu.upeu.backturismo.service.ServicioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/servicios")
public class ServicioController {

    @Autowired
    private ServicioService servicioService;

    @GetMapping
    public List<Servicio> getAllServicios() {
        return servicioService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Servicio> getServicioById(@PathVariable Long id) {
        Optional<Servicio> servicio = servicioService.findById(id);
        return servicio.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/usuario/{userId}")
    public List<Servicio> getServiciosByUsuario(@PathVariable Long userId) {
        return servicioService.findByUsuarioId(userId);
    }

    @PostMapping
    public ResponseEntity<?> createServicio(@RequestBody Servicio servicio) {
        try {
            if (servicio.getNombre() == null || servicio.getNombre().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "El nombre es obligatorio"));
            }
            Servicio nuevo = servicioService.save(servicio);
            return ResponseEntity.ok(Map.of(
                    "message", "Servicio creado exitosamente",
                    "servicio", nuevo
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Error al crear servicio: " + e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateServicio(@PathVariable Long id, @RequestBody Servicio servicioDetails) {
        Optional<Servicio> optional = servicioService.findById(id);
        if (optional.isPresent()) {
            Servicio servicio = optional.get();
            if (servicioDetails.getNombre() != null) {
                servicio.setNombre(servicioDetails.getNombre());
            }
            if (servicioDetails.getDescripcion() != null) {
                servicio.setDescripcion(servicioDetails.getDescripcion());
            }
            if (servicioDetails.getIcono() != null) {
                servicio.setIcono(servicioDetails.getIcono());
            }
            Servicio actualizado = servicioService.save(servicio);
            return ResponseEntity.ok(Map.of(
                    "message", "Servicio actualizado",
                    "servicio", actualizado
            ));
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteServicio(@PathVariable Long id) {
        if (servicioService.findById(id).isPresent()) {
            servicioService.deleteById(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
