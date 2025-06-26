package pe.edu.upeu.backturismo.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
public class JwtUtil {

    @Value("${jwt.secret}")
    private String secretKeyString;

    @Value("${jwt.expiration}")
    private long tokenExpiration;

    private SecretKey secretKey;

    @PostConstruct
    public void init() {
        this.secretKey = Keys.hmacShaKeyFor(secretKeyString.getBytes(StandardCharsets.UTF_8));
    }

    public String generateToken(String email, String rol) {
        return Jwts.builder()
                .setSubject(email)
                .claim("rol", "ROLE_" + rol)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + tokenExpiration))
                .signWith(secretKey)
                .compact();
    }

    public Claims getClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(secretKey)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (JwtException e) {
            throw new RuntimeException("Token JWT inválido: " + e.getMessage());
        }
    }

    public String getEmail(String token) {
        return getClaims(token).getSubject();
    }

    public String getRol(String token) {
        return (String) getClaims(token).get("rol");
    }

    public boolean isTokenValid(String token) {
        try {
            Date expirationDate = getClaims(token).getExpiration();
            return expirationDate != null && expirationDate.after(new Date());
        } catch (Exception e) {
            return false;
        }
    }
}
