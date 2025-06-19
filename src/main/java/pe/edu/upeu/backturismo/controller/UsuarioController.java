package pe.edu.upeu.backturismo.controller;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import pe.edu.upeu.backturismo.entity.Usuario;
import pe.edu.upeu.backturismo.service.UsuarioService;
import pe.edu.upeu.backturismo.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    @Qualifier("usuarioServiceImpl")
    @Autowired
    private UsuarioService usuarioService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    // REGISTRO
    @PostMapping("/register")
    public ResponseEntity<?> registerUsuario(@RequestBody Usuario usuario) {
        try {
            if (usuarioService.existsByEmail(usuario.getEmail())) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "El email ya está registrado"));
            }

            if (usuario.getPassword() == null || usuario.getPassword().isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "La contraseña no puede ser nula o vacía"));
            }

            usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));

            if (usuario.getRol() == null || usuario.getRol().isEmpty()) {
                usuario.setRol("USER");
            }

            Usuario savedUsuario = usuarioService.save(usuario);
            savedUsuario.setPassword(null); // ocultar contraseña en la respuesta

            return ResponseEntity.ok(Map.of(
                    "message", "Usuario registrado exitosamente",
                    "usuario", savedUsuario
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Error al registrar usuario: " + e.getMessage()));
        }
    }

    // LOGIN
    @PostMapping("/login")
    public ResponseEntity<?> loginUsuario(@RequestBody Map<String, String> loginData) {
        try {
            String email = loginData.get("email");
            String password = loginData.get("password");

            if (email == null || password == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Email y contraseña son requeridos"));
            }

            Usuario usuario = usuarioService.findByEmail(email);
            if (usuario == null || !passwordEncoder.matches(password, usuario.getPassword())) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Credenciales inválidas"));
            }

            String token = jwtUtil.generateToken(usuario.getEmail(), usuario.getRol());

            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("usuario", Map.of(
                    "id", usuario.getId(),
                    "email", usuario.getEmail(),
                    "rol", usuario.getRol()
            ));

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "Error al iniciar sesión: " + e.getMessage()));
        }
    }

    // CRUD DE USUARIOS
    @GetMapping
    public List<Usuario> getAllUsuarios() {
        return usuarioService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Usuario> getUsuarioById(@PathVariable Long id) {
        Optional<Usuario> usuario = usuarioService.findById(id);
        if (usuario.isPresent()) {
            usuario.get().setPassword(null);
            return ResponseEntity.ok(usuario.get());
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping
    public Usuario createUsuario(@RequestBody Usuario usuario) {
        if (usuario.getPassword() != null) {
            usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        }
        return usuarioService.save(usuario);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Usuario> updateUsuario(@PathVariable Long id, @RequestBody Usuario usuarioDetails) {
        Optional<Usuario> usuario = usuarioService.findById(id);
        if (usuario.isPresent()) {
            Usuario existingUsuario = usuario.get();

            if (usuarioDetails.getEmail() != null) {
                existingUsuario.setEmail(usuarioDetails.getEmail());
            }
            if (usuarioDetails.getPassword() != null) {
                existingUsuario.setPassword(passwordEncoder.encode(usuarioDetails.getPassword()));
            }
            if (usuarioDetails.getRol() != null) {
                existingUsuario.setRol(usuarioDetails.getRol());
            }

            Usuario updatedUsuario = usuarioService.save(existingUsuario);
            updatedUsuario.setPassword(null);
            return ResponseEntity.ok(updatedUsuario);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUsuario(@PathVariable Long id) {
        if (usuarioService.findById(id).isPresent()) {
            usuarioService.deleteById(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
