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
import java.util.Base64;
import java.util.Date;

@Component
public class JwtTokenProvider {
    private static final Logger logger = LoggerFactory.getLogger(JwtTokenProvider.class);
    
    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.expiration}")
    private long jwtExpirationMs;

    private Key getSigningKey() {
        try {
            // Decode the Base64-encoded secret to get the raw bytes
            byte[] decodedSecret = Base64.getDecoder().decode(jwtSecret);
            logger.debug("JWT secret decoded from Base64. Length: {} bytes", decodedSecret.length);
            
            if (decodedSecret.length < 64) {
                logger.error("JWT secret is only {} bytes but HS512 requires at least 64 bytes (512 bits)", decodedSecret.length);
                throw new IllegalStateException("JWT secret must be at least 512 bits (64 bytes) for HS512 algorithm");
            }
            
            // Create the signing key from the decoded bytes
            return Keys.hmacShaKeyFor(decodedSecret);
        } catch (IllegalArgumentException e) {
            logger.error("Failed to decode Base64 JWT secret. Ensure jwt.secret in application.properties is valid Base64", e);
            throw new RuntimeException("Invalid JWT secret configuration", e);
        } catch (Exception e) {
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
