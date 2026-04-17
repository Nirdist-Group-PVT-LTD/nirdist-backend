package com.nirdist.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Error controller for SPA routing
 * Redirects 404 errors to index.html so Flutter can handle the routing
 */
@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError() {
        return "forward:/index.html";
    }

    public String getErrorPath() {
        return "/error";
    }
}
