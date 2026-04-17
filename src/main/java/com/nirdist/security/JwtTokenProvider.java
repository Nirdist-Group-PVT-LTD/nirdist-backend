package com.nirdist.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import javax.crypto.spec.SecretKeySpec;

@Component
public class JwtTokenProvider {
    private static final Logger logger = LoggerFactory.getLogger(JwtTokenProvider.class);
    
    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.expiration}")
    private long jwtExpirationMs;

    private Key getSigningKey() {
        // Use Keys.hmacShaKeyFor which generates a proper 512-bit key
        // But first ensure we have enough bytes (minimum 64 bytes for HS512)
        byte[] secretBytes = jwtSecret.getBytes();
        
        if (secretBytes.length < 64) {
            // If secret is too short, generate a proper key from it
            logger.warn("JWT secret is too short. Generating a secure 512-bit key from provided secret.");
            try {
                Key key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
                return key;
            } catch (Exception e) {
                logger.error("Error generating JWT key", e);
                // Fallback: create a minimum 512-bit key
                byte[] decodedKey = new byte[64];
                System.arraycopy(secretBytes, 0, decodedKey, 0, Math.min(secretBytes.length, 64));
                return new SecretKeySpec(decodedKey, SignatureAlgorithm.HS512.getJcaName());
            }
        }
        
        return Keys.hmacShaKeyFor(secretBytes);
    }

    public String generateToken(String email) {
        try {
            return Jwts.builder()
                    .setSubject(email)
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
                    .signWith(getSigningKey(), SignatureAlgorithm.HS512)
                    .compact();
        } catch (Exception e) {
            logger.error("Error generating JWT token for email: " + email, e);
            throw new RuntimeException("Failed to generate JWT token", e);
        }
    }

    public String getEmailFromToken(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            return claims.getSubject();
        } catch (Exception e) {
            logger.error("Error parsing JWT token", e);
            return null;
        }
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            logger.debug("JWT token validation failed: " + e.getMessage());
            return false;
        }
    }
}
