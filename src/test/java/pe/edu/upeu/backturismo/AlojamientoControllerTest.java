package pe.edu.upeu.backturismo.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import pe.edu.upeu.backturismo.entity.Alojamiento;
import pe.edu.upeu.backturismo.service.AlojamientoService;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.hamcrest.Matchers.*;

/**
 * Pruebas de integración del controlador REST de Alojamiento
 * @author [Tu nombre]
 */
@WebMvcTest(AlojamientoController.class)
class AlojamientoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private AlojamientoService alojamientoService;

    private Alojamiento alojamiento;

    @BeforeEach
    void setUp() {
        alojamiento = new Alojamiento();
        alojamiento.setId(1L);
        alojamiento.setTitulo("Casa Rural Capachica");
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
        alojamiento.setPrecioNoche(new BigDecimal("150.00"));
        alojamiento.setPrecioLimpieza(new BigDecimal("20.00"));
        alojamiento.setPrecioServicio(new BigDecimal("15.00"));
        alojamiento.setActivo(true);
        alojamiento.setVerificado(true);
        alojamiento.setDisponible(true);
    }

    @Test
    @WithMockUser
    void testCreateAlojamiento() throws Exception {
        // Arrange
        when(alojamientoService.save(any(Alojamiento.class))).thenReturn(alojamiento);

        // Act & Assert
        mockMvc.perform(post("/api/alojamientos")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(alojamiento)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id", is(1)))
                .andExpect(jsonPath("$.titulo", is("Casa Rural Capachica")))
                .andExpect(jsonPath("$.distrito", is("Capachica")))
                .andExpect(jsonPath("$.precioNoche", is(150.00)))
                .andExpect(jsonPath("$.maxHuespedes", is(4)));

        verify(alojamientoService, times(1)).save(any(Alojamiento.class));
    }

    @Test
    @WithMockUser
    void testGetAlojamientoById() throws Exception {
        // Arrange
        when(alojamientoService.findById(anyLong())).thenReturn(Optional.of(alojamiento));

        // Act & Assert
        mockMvc.perform(get("/api/alojamientos/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is(1)))
                .andExpect(jsonPath("$.titulo", is("Casa Rural Capachica")))
                .andExpect(jsonPath("$.comunidad", is("Llachón")))
                .andExpect(jsonPath("$.numHabitaciones", is(2)));

        verify(alojamientoService, times(1)).findById(1L);
    }

    @Test
    @WithMockUser
    void testGetAlojamientoByIdNotFound() throws Exception {
        // Arrange
        when(alojamientoService.findById(anyLong())).thenReturn(Optional.empty());

        // Act & Assert
        mockMvc.perform(get("/api/alojamientos/999"))
                .andExpect(status().isNotFound());

        verify(alojamientoService, times(1)).findById(999L);
    }

    @Test
    @WithMockUser
    void testGetAllAlojamientos() throws Exception {
        // Arrange
        Alojamiento alojamiento2 = new Alojamiento();
        alojamiento2.setId(2L);
        alojamiento2.setTitulo("Hostal Lago Azul");
        alojamiento2.setDescripcion("Hostal económico");
        alojamiento2.setDistrito("Capachica");
        alojamiento2.setPrecioNoche(new BigDecimal("80.00"));
        alojamiento2.setMaxHuespedes(2);

        List<Alojamiento> lista = Arrays.asList(alojamiento, alojamiento2);
        when(alojamientoService.findAll()).thenReturn(lista);

        // Act & Assert
        mockMvc.perform(get("/api/alojamientos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].titulo", is("Casa Rural Capachica")))
                .andExpect(jsonPath("$[1].titulo", is("Hostal Lago Azul")))
                .andExpect(jsonPath("$[0].precioNoche", is(150.00)))
                .andExpect(jsonPath("$[1].precioNoche", is(80.00)));

        verify(alojamientoService, times(1)).findAll();
    }

    @Test
    @WithMockUser
    void testUpdateAlojamiento() throws Exception {
        // Arrange
        Alojamiento actualizado = new Alojamiento();
        actualizado.setId(1L);
        actualizado.setTitulo("Casa Rural Actualizada");
        actualizado.setDescripcion("Descripción actualizada");
        actualizado.setDistrito("Capachica");
        actualizado.setPrecioNoche(new BigDecimal("180.00"));
        actualizado.setMaxHuespedes(6);

        when(alojamientoService.save(any(Alojamiento.class))).thenReturn(actualizado);

        // Act & Assert
        mockMvc.perform(put("/api/alojamientos/1")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(actualizado)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.titulo", is("Casa Rural Actualizada")))
                .andExpect(jsonPath("$.precioNoche", is(180.00)))
                .andExpect(jsonPath("$.maxHuespedes", is(6)));

        verify(alojamientoService, times(1)).save(any(Alojamiento.class));
    }

    @Test
    @WithMockUser
    void testDeleteAlojamiento() throws Exception {
        // Arrange
        doNothing().when(alojamientoService).deleteById(anyLong());

        // Act & Assert
        mockMvc.perform(delete("/api/alojamientos/1")
                        .with(csrf()))
                .andExpect(status().isNoContent());

        verify(alojamientoService, times(1)).deleteById(1L);
    }

    @Test
    @WithMockUser
    void testGetAllAlojamientosVacio() throws Exception {
        // Arrange
        when(alojamientoService.findAll()).thenReturn(Arrays.asList());

        // Act & Assert
        mockMvc.perform(get("/api/alojamientos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(0)));

        verify(alojamientoService, times(1)).findAll();
    }

    @Test
    @WithMockUser
    void testCreateAlojamientoConTodosLosCampos() throws Exception {
        // Arrange
        alojamiento.setPermiteMascotas(true);
        alojamiento.setPermiteFumar(false);
        alojamiento.setPermiteNinos(true);
        alojamiento.setDescuentoSemanal(new BigDecimal("10.00"));
        alojamiento.setDescuentoMensual(new BigDecimal("20.00"));

        when(alojamientoService.save(any(Alojamiento.class))).thenReturn(alojamiento);

        // Act & Assert
        mockMvc.perform(post("/api/alojamientos")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(alojamiento)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.permiteMascotas", is(true)))
                .andExpect(jsonPath("$.permiteFumar", is(false)))
                .andExpect(jsonPath("$.permiteNinos", is(true)));
    }
}