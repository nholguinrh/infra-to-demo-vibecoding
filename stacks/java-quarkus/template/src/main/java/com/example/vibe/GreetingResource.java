package com.example.vibe;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/health")
public class GreetingResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String health() {
        return "{\"status\":\"ok\"}";
    }
}
