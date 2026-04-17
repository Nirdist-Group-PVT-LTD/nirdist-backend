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
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Date;

@Component
public class JwtTokenProvider {
    private static final Logger logger = LoggerFactory.getLogger(JwtTokenProvider.class);
    
    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.expiration}")
    private long jwtExpirationMs;

    private byte[] resolveSecretBytes(String secret) {
        if (secret == null || secret.isBlank()) {
            throw new IllegalStateException("JWT secret is not configured");
        }

        String trimmedSecret = secret.trim();

        try {
            byte[] decodedSecret = Base64.getDecoder().decode(trimmedSecret);
            if (decodedSecret.length >= 64) {
                logger.debug("JWT secret decoded from Base64. Length: {} bytes", decodedSecret.length);
                return decodedSecret;
            }

            logger.debug("Base64-decoded JWT secret is only {} bytes, checking raw UTF-8 bytes", decodedSecret.length);
        } catch (IllegalArgumentException e) {
            logger.debug("JWT secret is not valid Base64, checking raw UTF-8 bytes");
        }

        byte[] rawSecret = trimmedSecret.getBytes(StandardCharsets.UTF_8);
        if (rawSecret.length >= 64) {
            logger.debug("JWT secret using raw UTF-8 bytes. Length: {} bytes", rawSecret.length);
            return rawSecret;
        }

        throw new IllegalStateException("JWT secret must be at least 64 bytes for HS512");
    }

    private Key getSigningKey() {
        try {
            return Keys.hmacShaKeyFor(resolveSecretBytes(jwtSecret));
        } catch (RuntimeException e) {
            logger.error("Error generating JWT key", e);
            throw new RuntimeException("Failed to generate JWT signing key", e);
        }
    }

    public String generateToken(String email) {
        try {
            return Jwts.builder()
                    .setSubject(email)
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
                    .signWith(getSigningKey(), SignatureAlgorithm.HS512)
                    .compact();
        } catch (RuntimeException e) {
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
        } catch (RuntimeException e) {
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
        } catch (RuntimeException e) {
            logger.debug("JWT token validation failed: " + e.getMessage());
            return false;
        }
    }
}
