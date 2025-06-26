package pe.edu.upeu.backturismo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.backturismo.entity.Reserva;

import java.util.List;

public interface ReservaRepository extends JpaRepository<Reserva, Long> {
    List<Reserva> findByUsuarioId(Long userId);
}