package pe.edu.upeu.backturismo.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.TestPropertySource;
import pe.edu.upeu.backturismo.entity.Alojamiento;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Pruebas de integración del repositorio Alojamiento
 * Usa H2 en memoria para las pruebas
 * @author [Tu nombre]
 */
@DataJpaTest
@TestPropertySource(locations = "classpath:application-test.properties")
class AlojamientoRepositoryTest {

    @Autowired
    private AlojamientoRepository alojamientoRepository;

    @Autowired
    private TestEntityManager entityManager;

    private Alojamiento crearAlojamientoTest() {
        Alojamiento alojamiento = new Alojamiento();
        alojamiento.setTitulo("Casa Turística Capachica");
        alojamiento.setDescripcion("Hermosa casa con vista al lago");
        alojamiento.setTipoPropiedad(Alojamiento.TipoPropiedad.CASA_COMPLETA);
        alojamiento.setDepartamento("Puno");
        alojamiento.setProvincia("Puno");
        alojamiento.setDistrito("Capachica");
        alojamiento.setComunidad("Llachón");
        alojamiento.setDireccion("Calle Principal s/n");
        alojamiento.setLatitud(new BigDecimal("-15.7483"));
        alojamiento.setLongitud(new BigDecimal("-70.0133"));
        alojamiento.setMaxHuespedes(4);
        alojamiento.setNumHabitaciones(2);
        alojamiento.setNumCamas(3);
        alojamiento.setPrecioNoche(new BigDecimal("120.00"));
        alojamiento.setPrecioLimpieza(new BigDecimal("20.00"));
        alojamiento.setPrecioServicio(new BigDecimal("10.00"));
        alojamiento.setActivo(true);
        alojamiento.setVerificado(true);
        alojamiento.setDisponible(true);
        return alojamiento;
    }

    @Test
    void testSaveAlojamiento() {
        // Arrange
        Alojamiento alojamiento = crearAlojamientoTest();

        // Act
        Alojamiento guardado = alojamientoRepository.save(alojamiento);

        // Assert
        assertNotNull(guardado.getId());
        assertEquals("Casa Turística Capachica", guardado.getTitulo());
        assertEquals(new BigDecimal("120.00"), guardado.getPrecioNoche());
        assertEquals("Capachica", guardado.getDistrito());
    }

    @Test
    void testFindById() {
        // Arrange
        Alojamiento alojamiento = crearAlojamientoTest();
        alojamiento.setTitulo("Hotel Lago Titicaca");
        Alojamiento guardado = entityManager.persist(alojamiento);
        entityManager.flush();

        // Act
        Optional<Alojamiento> encontrado = alojamientoRepository.findById(guardado.getId());

        // Assert
        assertTrue(encontrado.isPresent());
        assertEquals("Hotel Lago Titicaca", encontrado.get().getTitulo());
        assertEquals(new BigDecimal("120.00"), encontrado.get().getPrecioNoche());
    }

    @Test
    void testFindByIdNoExiste() {
        // Act
        Optional<Alojamiento> encontrado = alojamientoRepository.findById(999L);

        // Assert
        assertFalse(encontrado.isPresent());
    }

    @Test
    void testFindAll() {
        // Arrange
        Alojamiento alojamiento1 = crearAlojamientoTest();
        alojamiento1.setTitulo("Alojamiento 1");
        entityManager.persist(alojamiento1);

        Alojamiento alojamiento2 = crearAlojamientoTest();
        alojamiento2.setTitulo("Alojamiento 2");
        alojamiento2.setPrecioNoche(new BigDecimal("150.00"));
        entityManager.persist(alojamiento2);

        entityManager.flush();

        // Act
        List<Alojamiento> lista = alojamientoRepository.findAll();

        // Assert
        assertNotNull(lista);
        assertTrue(lista.size() >= 2);
    }

    @Test
    void testUpdateAlojamiento() {
        // Arrange
        Alojamiento alojamiento = crearAlojamientoTest();
        alojamiento.setTitulo("Título Original");
        Alojamiento guardado = entityManager.persist(alojamiento);
        entityManager.flush();

        // Act
        guardado.setTitulo("Título Actualizado");
        guardado.setPrecioNoche(new BigDecimal("180.00"));
        guardado.setMaxHuespedes(6);
        Alojamiento actualizado = alojamientoRepository.save(guardado);

        // Assert
        assertEquals("Título Actualizado", actualizado.getTitulo());
        assertEquals(new BigDecimal("180.00"), actualizado.getPrecioNoche());
        assertEquals(6, actualizado.getMaxHuespedes());
    }

    @Test
    void testDeleteAlojamiento() {
        // Arrange
        Alojamiento alojamiento = crearAlojamientoTest();
        alojamiento.setTitulo("Alojamiento a Eliminar");
        Alojamiento guardado = entityManager.persist(alojamiento);
        entityManager.flush();
        Long id = guardado.getId();

        // Act
        alojamientoRepository.deleteById(id);

        // Assert
        Optional<Alojamiento> eliminado = alojamientoRepository.findById(id);
        assertFalse(eliminado.isPresent());
    }

    @Test
    void testExistsById() {
        // Arrange
        Alojamiento alojamiento = crearAlojamientoTest();
        Alojamiento guardado = entityManager.persist(alojamiento);
        entityManager.flush();

        // Act & Assert
        assertTrue(alojamientoRepository.existsById(guardado.getId()));
        assertFalse(alojamientoRepository.existsById(999L));
    }

    @Test
    void testCount() {
        // Arrange
        long countInicial = alojamientoRepository.count();

        Alojamiento alojamiento = crearAlojamientoTest();
        entityManager.persist(alojamiento);
        entityManager.flush();

        // Act
        long count = alojamientoRepository.count();

        // Assert
        assertEquals(countInicial + 1, count);
    }

    @Test
    void testSaveAlojamientoConTodosLosCampos() {
        // Arrange
        Alojamiento alojamiento = crearAlojamientoTest();
        alojamiento.setPermiteMascotas(true);
        alojamiento.setPermiteFumar(false);
        alojamiento.setPermiteFiestas(false);
        alojamiento.setPermiteNinos(true);
        alojamiento.setDescuentoSemanal(new BigDecimal("10.00"));
        alojamiento.setDescuentoMensual(new BigDecimal("20.00"));
        alojamiento.setEstanciaMinima(2);
        alojamiento.setEstanciaMaxima(30);

        // Act
        Alojamiento guardado = alojamientoRepository.save(alojamiento);

        // Assert
        assertNotNull(guardado.getId());
        assertTrue(guardado.getPermiteMascotas());
        assertFalse(guardado.getPermiteFumar());
        assertEquals(new BigDecimal("10.00"), guardado.getDescuentoSemanal());
        assertEquals(2, guardado.getEstanciaMinima());
    }

    @Test
    void testGuardarConDiferentesTipoPropiedad() {
        // Test para CASA_COMPLETA
        Alojamiento casa = crearAlojamientoTest();
        casa.setTipoPropiedad(Alojamiento.TipoPropiedad.CASA_COMPLETA);
        Alojamiento casaGuardada = alojamientoRepository.save(casa);
        assertEquals(Alojamiento.TipoPropiedad.CASA_COMPLETA, casaGuardada.getTipoPropiedad());

        // Test para HABITACION_PRIVADA
        Alojamiento habitacion = crearAlojamientoTest();
        habitacion.setTipoPropiedad(Alojamiento.TipoPropiedad.HABITACION_PRIVADA);
        Alojamiento habitacionGuardada = alojamientoRepository.save(habitacion);
        assertEquals(Alojamiento.TipoPropiedad.HABITACION_PRIVADA, habitacionGuardada.getTipoPropiedad());
    }

    @Test
    void testGuardarConDiferentesPoliticasCancelacion() {
        // Test para FLEXIBLE
        Alojamiento flexible = crearAlojamientoTest();
        flexible.setPoliticaCancelacion(Alojamiento.PoliticaCancelacion.FLEXIBLE);
        Alojamiento flexibleGuardado = alojamientoRepository.save(flexible);
        assertEquals(Alojamiento.PoliticaCancelacion.FLEXIBLE, flexibleGuardado.getPoliticaCancelacion());

        // Test para ESTRICTA
        Alojamiento estricta = crearAlojamientoTest();
        estricta.setPoliticaCancelacion(Alojamiento.PoliticaCancelacion.ESTRICTA);
        Alojamiento estrictaGuardada = alojamientoRepository.save(estricta);
        assertEquals(Alojamiento.PoliticaCancelacion.ESTRICTA, estrictaGuardada.getPoliticaCancelacion());
    }
}