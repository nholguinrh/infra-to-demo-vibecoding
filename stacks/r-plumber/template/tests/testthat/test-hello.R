source(file.path("..", "..", "R", "hello.R"))

test_that("health returns ok", {
  expect_equal(health()$status, "ok")
})
