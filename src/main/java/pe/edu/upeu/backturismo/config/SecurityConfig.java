package pe.edu.upeu.backturismo.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import pe.edu.upeu.backturismo.security.JwtFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtFilter jwtFilter;

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth

                        // 🟢 PÚBLICAS: no requieren autenticación
                        .requestMatchers("/api/usuarios/login", "/api/usuarios/register", "/doc/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/emprendedores/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/alojamientos/**").permitAll()

                        // 🟡 USER o ADMIN: CRUD sobre sus alojamientos
                        .requestMatchers(HttpMethod.POST, "/api/alojamientos").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/alojamientos/**").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/alojamientos/**").hasAnyRole("USER", "ADMIN")

                        // 🟡 USER o ADMIN: gestionar su emprendedor
                        .requestMatchers(HttpMethod.POST, "/api/emprendedores").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/emprendedores/**").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/emprendedores/**").hasAnyRole("USER", "ADMIN")

                        // 🔴 SOLO ADMIN: ver y eliminar usuarios
                        .requestMatchers(HttpMethod.GET, "/api/usuarios/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/usuarios/**").hasRole("ADMIN")

                        // 🔴 SOLO ADMIN: ver todas las reservas (si existe endpoint /todas)
                        .requestMatchers(HttpMethod.GET, "/api/reservas/todas").hasRole("ADMIN")

                        // 🟡 USER o ADMIN: hacer/ver sus reservas
                        .requestMatchers(HttpMethod.POST, "/api/reservas").hasAnyRole("USER", "ADMIN")
                        .requestMatchers(HttpMethod.GET, "/api/reservas/**").hasAnyRole("USER", "ADMIN")

                        // 🔐 Cualquier otra ruta requiere autenticación
                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
