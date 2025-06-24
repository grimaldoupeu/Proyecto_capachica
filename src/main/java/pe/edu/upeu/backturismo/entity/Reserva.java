package pe.edu.upeu.backturismo.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Reserva {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "alojamiento_id", nullable = false)
    private Alojamiento alojamiento; // Corregido: era "Alojamientos"

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin", nullable = false)
    private LocalDate fechaFin;

    @Column(name = "num_huespedes", nullable = false)
    private Integer numHuespedes = 1;

    @Column(name = "precio_noche", nullable = false, precision = 10, scale = 2)
    private BigDecimal precioNoche;

    @Column(name = "precio_limpieza", precision = 10, scale = 2)
    private BigDecimal precioLimpieza = BigDecimal.ZERO;

    @Column(name = "precio_servicio", precision = 10, scale = 2)
    private BigDecimal precioServicio = BigDecimal.ZERO;

    @Column(name = "precio_total", nullable = false, precision = 10, scale = 2)
    private BigDecimal precioTotal;

    @Column(name = "noches_total", nullable = false)
    private Integer nochesTotal;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private EstadoReserva estado = EstadoReserva.PENDIENTE;

    @Column(name = "codigo_reserva", unique = true, length = 50)
    private String codigoReserva;

    @Column(name = "notas_especiales", columnDefinition = "TEXT")
    private String notasEspeciales;

    @Column(name = "telefono_contacto", length = 20)
    private String telefonoContacto;

    @Column(name = "created_at")
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @Column(name = "fecha_cancelacion")
    private LocalDateTime fechaCancelacion;

    @Column(name = "motivo_cancelacion", columnDefinition = "TEXT")
    private String motivoCancelacion;

    // Enum para estados de reserva
    public enum EstadoReserva {
        PENDIENTE("pendiente"),
        CONFIRMADA("confirmada"),
        CANCELADA("cancelada"),
        PAGADA("pagada"),
        COMPLETADA("completada");

        private final String valor;

        EstadoReserva(String valor) {
            this.valor = valor;
        }

        public String getValor() {
            return valor;
        }
    }

    // Método para generar código de reserva único
    @PrePersist
    public void generarCodigoReserva() {
        if (this.codigoReserva == null) {
            this.codigoReserva = "RES" + System.currentTimeMillis();
        }
    }

    // Métodos de utilidad
    public boolean isPendiente() {
        return estado == EstadoReserva.PENDIENTE;
    }

    public boolean isConfirmada() {
        return estado == EstadoReserva.CONFIRMADA;
    }

    public boolean isCancelada() {
        return estado == EstadoReserva.CANCELADA;
    }

    public boolean isPuedeCancelar() {
        return estado == EstadoReserva.PENDIENTE || estado == EstadoReserva.CONFIRMADA;
    }
}