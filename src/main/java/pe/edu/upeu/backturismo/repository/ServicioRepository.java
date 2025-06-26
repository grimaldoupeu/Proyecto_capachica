package pe.edu.upeu.backturismo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.backturismo.entity.Servicio;

import java.util.List;

public interface ServicioRepository extends JpaRepository<Servicio, Long> {
    List<Servicio> findByUsuarioId(Long userId);
}