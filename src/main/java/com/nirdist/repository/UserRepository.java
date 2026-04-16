package com.nirdist.repository;

import com.nirdist.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    
    @Query("SELECT u FROM User u WHERE u.email = :email")
    Optional<User> findByEmail(@Param("email") String email);
    
    @Query("SELECT u FROM User u WHERE u.vUsername = :vUsername")
    Optional<User> findByVUsername(@Param("vUsername") String vUsername);
    
    @Query("SELECT u FROM User u WHERE u.vId = :vId")
    Optional<User> findByVId(@Param("vId") Integer vId);
    
    @Query("SELECT u FROM User u WHERE u.vName LIKE %:query% OR u.vUsername LIKE %:query% OR u.email LIKE %:query%")
    List<User> searchUsers(@Param("query") String query);
}
