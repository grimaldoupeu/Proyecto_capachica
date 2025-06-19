package pe.edu.upeu.backturismo.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component
public class JwtFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String path = request.getRequestURI();
        String method = request.getMethod();

        // Debugging (puedes eliminar si no necesitas más logs)
        System.out.println("JwtFilter: Path = " + path + ", Method = " + method);
        System.out.println("JwtFilter: Authorization = " + request.getHeader("Authorization"));

        // Rutas públicas sin token
        if (path.equals("/api/usuarios/login")
                || path.equals("/api/usuarios/register")
                || path.startsWith("/doc/")
                || (path.startsWith("/api/emprendedores") && method.equals("GET"))
                || (path.startsWith("/api/alojamientos") && method.equals("GET"))) {

            filterChain.doFilter(request, response);
            return;
        }

        // Token desde header Authorization
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);

            try {
                if (jwtUtil.isTokenValid(token)) {
                    String email = jwtUtil.getEmail(token);
                    String rol = jwtUtil.getRol(token);

                    // El rol debe incluir el prefijo "ROLE_" para que funcione con hasRole()
                    SimpleGrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + rol);

                    UsernamePasswordAuthenticationToken auth =
                            new UsernamePasswordAuthenticationToken(email, null, Collections.singletonList(authority));

                    SecurityContextHolder.getContext().setAuthentication(auth);
                }
            } catch (Exception e) {
                System.out.println("JwtFilter: Error al procesar el token: " + e.getMessage());
            }
        }

        filterChain.doFilter(request, response);
    }
}
