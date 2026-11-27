testthat::test_that("c.teal_data concatenates join_keys from all teal_data objects", {
  d1 <- teal_data(iris = iris, join_keys = join_keys(join_key("iris", "iris", "iris_key")))
  d2 <- teal_data(mtcars = mtcars, join_keys = join_keys(join_key("mtcars", "mtcars", "mtcars_key")))

  res <- c(d1, d2)

  testthat::expect_s4_class(res, "teal_data")
  testthat::expect_identical(
    join_keys(res),
    join_keys(
      join_key("iris", "iris", "iris_key"),
      join_key("mtcars", "mtcars", "mtcars_key")
    )
  )
})

testthat::test_that("c.teal_data merges join_keys and parents across three teal_data objects", {
  d1 <- teal_data(
    a = data.frame(id = 1),
    join_keys = join_keys(join_key("a", "a", "id"))
  )
  d2 <- teal_data(
    b = data.frame(id = 1),
    join_keys = join_keys(join_key("b", "b", "id"), join_key("a", "b", "id"))
  )
  d3 <- teal_data(
    c = data.frame(id = 1),
    join_keys = join_keys(join_key("c", "c", "id"), join_key("a", "c", "id"))
  )

  res <- c(d1, d2, d3)

  testthat::expect_identical(
    join_keys(res),
    c(join_keys(d1), join_keys(d2), join_keys(d3))
  )
  testthat::expect_identical(parents(res), list(b = "a", c = "a"))
})

testthat::test_that("c.teal_data marks result unverified when any input is unverified", {
  d_verified <- within(teal_data(), {
    a <- 1
  })
  d_unverified <- teal_data(b = 2)

  testthat::expect_true(d_verified@verified)
  testthat::expect_false(d_unverified@verified)
  testthat::expect_false(c(d_verified, d_unverified)@verified)
  testthat::expect_false(c(d_unverified, d_verified)@verified)
  testthat::expect_error(verify(c(d_verified, d_unverified)), "Code verification failed")
})

testthat::test_that("c.teal_data preserves verified status when all inputs are verified", {
  d1 <- within(teal_data(), {
    a <- 1
  })
  d2 <- within(teal_data(), {
    b <- 2
  })

  res <- c(d1, d2)

  testthat::expect_true(res@verified)
  testthat::expect_identical(res[["a"]], 1)
  testthat::expect_identical(res[["b"]], 2)
})

testthat::test_that("c.teal_data handles single object, qenv, qenv.error, and non-qenv inputs", {
  d1 <- teal_data(iris = iris, join_keys = join_keys(join_key("iris", "iris", "iris_key")))
  q1 <- eval_code(teal.code::qenv(), "x <- 1")
  err <- eval_code(teal_data(), "stop('boom')")

  testthat::expect_identical(join_keys(c(d1)), join_keys(d1))

  res_q <- c(d1, q1)
  testthat::expect_s4_class(res_q, "teal_data")
  testthat::expect_identical(join_keys(res_q), join_keys(d1))
  testthat::expect_identical(res_q[["x"]], 1)

  testthat::expect_s3_class(c(d1, err), "qenv.error")
  testthat::expect_type(c(d1, 1), "list")
})
