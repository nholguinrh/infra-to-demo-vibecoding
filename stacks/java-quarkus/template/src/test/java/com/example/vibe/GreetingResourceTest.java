package com.example.vibe;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.containsString;

import org.junit.jupiter.api.Test;

import io.quarkus.test.junit.QuarkusTest;

@QuarkusTest
class GreetingResourceTest {

    @Test
    void healthReturnsOk() {
        given()
                .when().get("/health")
                .then()
                .statusCode(200)
                .body(containsString("ok"));
    }
}
