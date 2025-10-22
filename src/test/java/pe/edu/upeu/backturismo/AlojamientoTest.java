package pe.edu.upeu.backturismo.entity;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Pruebas unitarias para la entidad Alojamiento
 * @author [Tu nombre]
 */
class AlojamientoTest {

    private Alojamiento alojamiento;

    @BeforeEach
    void setUp() {
        alojamiento = new Alojamiento();
    }

    @Test
    void testConstructorVacio() {
        Alojamiento nuevo = new Alojamiento();
        assertNotNull(nuevo);
    }

    @Test
    void testSetAndGetId() {
        Long expectedId = 1L;
        alojamiento.setId(expectedId);
        assertEquals(expectedId, alojamiento.getId());
    }

    @Test
    void testSetAndGetTitulo() {
        String titulo = "Casa Rural en Capachica";
        alojamiento.setTitulo(titulo);
        assertEquals(titulo, alojamiento.getTitulo());
    }

    @Test
    void testSetAndGetDescripcion() {
        String descripcion = "Hermosa casa con vista al lago Titicaca";
        alojamiento.setDescripcion(descripcion);
        assertEquals(descripcion, alojamiento.getDescripcion());
    }

    @Test
    void testSetAndGetTipoPropiedad() {
        Alojamiento.TipoPropiedad tipo = Alojamiento.TipoPropiedad.CASA_COMPLETA;
        alojamiento.setTipoPropiedad(tipo);
        assertEquals(tipo, alojamiento.getTipoPropiedad());
    }

    @Test
    void testSetAndGetUbicacion() {
        alojamiento.setDepartamento("Puno");
        alojamiento.setProvincia("Puno");
        alojamiento.setDistrito("Capachica");
        alojamiento.setComunidad("Llachón");
        alojamiento.setDireccion("Calle Principal 123");

        assertEquals("Puno", alojamiento.getDepartamento());
        assertEquals("Puno", alojamiento.getProvincia());
        assertEquals("Capachica", alojamiento.getDistrito());
        assertEquals("Llachón", alojamiento.getComunidad());
        assertEquals("Calle Principal 123", alojamiento.getDireccion());
    }

    @Test
    void testSetAndGetCoordenadas() {
        BigDecimal latitud = new BigDecimal("-15.7483");
        BigDecimal longitud = new BigDecimal("-70.0133");

        alojamiento.setLatitud(latitud);
        alojamiento.setLongitud(longitud);

        assertEquals(latitud, alojamiento.getLatitud());
        assertEquals(longitud, alojamiento.getLongitud());
    }

    @Test
    void testSetAndGetCapacidad() {
        alojamiento.setMaxHuespedes(6);
        alojamiento.setNumHabitaciones(3);
        alojamiento.setNumCamas(4);

        assertEquals(6, alojamiento.getMaxHuespedes());
        assertEquals(3, alojamiento.getNumHabitaciones());
        assertEquals(4, alojamiento.getNumCamas());
    }

    @Test
    void testSetAndGetPrecios() {
        BigDecimal precioNoche = new BigDecimal("150.00");
        BigDecimal precioLimpieza = new BigDecimal("20.00");
        BigDecimal precioServicio = new BigDecimal("15.00");

        alojamiento.setPrecioNoche(precioNoche);
        alojamiento.setPrecioLimpieza(precioLimpieza);
        alojamiento.setPrecioServicio(precioServicio);

        assertEquals(precioNoche, alojamiento.getPrecioNoche());
        assertEquals(precioLimpieza, alojamiento.getPrecioLimpieza());
        assertEquals(precioServicio, alojamiento.getPrecioServicio());
    }

    @Test
    void testSetAndGetDescuentos() {
        BigDecimal descuentoSemanal = new BigDecimal("10.00");
        BigDecimal descuentoMensual = new BigDecimal("20.00");

        alojamiento.setDescuentoSemanal(descuentoSemanal);
        alojamiento.setDescuentoMensual(descuentoMensual);

        assertEquals(descuentoSemanal, alojamiento.getDescuentoSemanal());
        assertEquals(descuentoMensual, alojamiento.getDescuentoMensual());
    }

    @Test
    void testSetAndGetPoliticaCancelacion() {
        Alojamiento.PoliticaCancelacion politica = Alojamiento.PoliticaCancelacion.FLEXIBLE;
        alojamiento.setPoliticaCancelacion(politica);
        assertEquals(politica, alojamiento.getPoliticaCancelacion());
    }

    @Test
    void testSetAndGetHorariosCheckInOut() {
        LocalTime checkinDesde = LocalTime.of(14, 0);
        LocalTime checkinHasta = LocalTime.of(23, 0);
        LocalTime checkoutHasta = LocalTime.of(12, 0);

        alojamiento.setCheckinDesde(checkinDesde);
        alojamiento.setCheckinHasta(checkinHasta);
        alojamiento.setCheckoutHasta(checkoutHasta);

        assertEquals(checkinDesde, alojamiento.getCheckinDesde());
        assertEquals(checkinHasta, alojamiento.getCheckinHasta());
        assertEquals(checkoutHasta, alojamiento.getCheckoutHasta());
    }

    @Test
    void testSetAndGetEstancias() {
        alojamiento.setEstanciaMinima(2);
        alojamiento.setEstanciaMaxima(30);

        assertEquals(2, alojamiento.getEstanciaMinima());
        assertEquals(30, alojamiento.getEstanciaMaxima());
    }

    @Test
    void testSetAndGetReglas() {
        alojamiento.setPermiteMascotas(true);
        alojamiento.setPermiteFumar(false);
        alojamiento.setPermiteFiestas(false);
        alojamiento.setPermiteNinos(true);

        assertTrue(alojamiento.getPermiteMascotas());
        assertFalse(alojamiento.getPermiteFumar());
        assertFalse(alojamiento.getPermiteFiestas());
        assertTrue(alojamiento.getPermiteNinos());
    }

    @Test
    void testSetAndGetEstados() {
        alojamiento.setActivo(true);
        alojamiento.setVerificado(true);
        alojamiento.setDisponible(true);

        assertTrue(alojamiento.getActivo());
        assertTrue(alojamiento.getVerificado());
        assertTrue(alojamiento.getDisponible());
    }

    @Test
    void testGetUbicacionCompleta() {
        alojamiento.setDepartamento("Puno");
        alojamiento.setProvincia("Puno");
        alojamiento.setDistrito("Capachica");
        alojamiento.setComunidad("Llachón");

        String ubicacionCompleta = alojamiento.getUbicacionCompleta();

        assertTrue(ubicacionCompleta.contains("Llachón"));
        assertTrue(ubicacionCompleta.contains("Capachica"));
        assertTrue(ubicacionCompleta.contains("Puno"));
    }

    @Test
    void testGetUbicacionCompletaSinComunidad() {
        alojamiento.setDepartamento("Puno");
        alojamiento.setProvincia("Puno");
        alojamiento.setDistrito("Capachica");
        alojamiento.setComunidad(null);

        String ubicacionCompleta = alojamiento.getUbicacionCompleta();

        assertTrue(ubicacionCompleta.contains("Capachica"));
        assertFalse(ubicacionCompleta.contains("null"));
    }

    @Test
    void testGetPrecioTotal() {
        alojamiento.setPrecioNoche(new BigDecimal("100.00"));
        alojamiento.setPrecioLimpieza(new BigDecimal("20.00"));
        alojamiento.setPrecioServicio(new BigDecimal("15.00"));

        BigDecimal precioTotal = alojamiento.getPrecioTotal();

        assertEquals(new BigDecimal("135.00"), precioTotal);
    }

    @Test
    void testIsDisponibleTrue() {
        alojamiento.setActivo(true);
        alojamiento.setDisponible(true);
        alojamiento.setVerificado(true);

        assertTrue(alojamiento.isDisponible());
    }

    @Test
    void testIsDisponibleFalseCuandoNoActivo() {
        alojamiento.setActivo(false);
        alojamiento.setDisponible(true);
        alojamiento.setVerificado(true);

        assertFalse(alojamiento.isDisponible());
    }

    @Test
    void testIsDisponibleFalseCuandoNoVerificado() {
        alojamiento.setActivo(true);
        alojamiento.setDisponible(true);
        alojamiento.setVerificado(false);

        assertFalse(alojamiento.isDisponible());
    }

    @Test
    void testTipoPropiedadEnum() {
        assertEquals("casa_completa", Alojamiento.TipoPropiedad.CASA_COMPLETA.getValor());
        assertEquals("habitacion_privada", Alojamiento.TipoPropiedad.HABITACION_PRIVADA.getValor());
        assertEquals("habitacion_compartida", Alojamiento.TipoPropiedad.HABITACION_COMPARTIDA.getValor());
    }

    @Test
    void testPoliticaCancelacionEnum() {
        assertEquals("flexible", Alojamiento.PoliticaCancelacion.FLEXIBLE.getValor());
        assertEquals("moderada", Alojamiento.PoliticaCancelacion.MODERADA.getValor());
        assertEquals("estricta", Alojamiento.PoliticaCancelacion.ESTRICTA.getValor());
    }

    @Test
    void testValoresDefaultConstructor() {
        // Valores por defecto según tu entidad
        assertEquals("Puno", alojamiento.getDepartamento());
        assertEquals("Puno", alojamiento.getProvincia());
        assertEquals("Capachica", alojamiento.getDistrito());
        assertEquals(1, alojamiento.getMaxHuespedes());
        assertEquals(1, alojamiento.getNumHabitaciones());
        assertEquals(1, alojamiento.getNumCamas());
        assertEquals(BigDecimal.ZERO, alojamiento.getPrecioLimpieza());
        assertEquals(BigDecimal.ZERO, alojamiento.getPrecioServicio());
        assertEquals(Alojamiento.PoliticaCancelacion.FLEXIBLE, alojamiento.getPoliticaCancelacion());
        assertEquals(LocalTime.of(15, 0), alojamiento.getCheckinDesde());
        assertEquals(LocalTime.of(22, 0), alojamiento.getCheckinHasta());
        assertEquals(LocalTime.of(11, 0), alojamiento.getCheckoutHasta());
        assertFalse(alojamiento.getPermiteMascotas());
        assertFalse(alojamiento.getPermiteFumar());
        assertTrue(alojamiento.getPermiteNinos());
        assertTrue(alojamiento.getActivo());
        assertFalse(alojamiento.getVerificado());
    }
}