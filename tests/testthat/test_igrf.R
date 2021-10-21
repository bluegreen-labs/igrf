# valid main field run
test_that("check main field run", {
  field <- igrf::igrf(
    field = "main",
    year = 2000,
    type = "spheroid",
    altitude = 2,
    latitude = 50,
    longitude = 10
  )

  expect_type(field, "list")
})

# valid main field run
test_that("check main field run", {
  field <- igrf::igrf(
    field = "main",
    year = 2021,
    type = "spheroid",
    altitude = 2,
    latitude = 50,
    longitude = 10
  )

  expect_type(field, "list")
})

# valid main field run
test_that("check main field run (<1995)", {
  field <- igrf::igrf(
    field = "main",
    year = 1990,
    type = "sphere",
    altitude = 3487,
    latitude = 50,
    longitude = 10
  )

  expect_type(field, "list")
})

# invalid sphere run
test_that("check sphere", {
  expect_error(
    igrf::igrf(
      field = "main",
      year = 1990,
      type = "sphere",
      altitude = 3480,
      latitude = 50,
      longitude = 10
    )
  )
})

# wrong type
test_that("check sphere", {
  expect_error(
    igrf::igrf(
      field = "main",
      year = 1990,
      type = "spher",
      altitude = 3480,
      latitude = 50,
      longitude = 10
    )
  )
})

# valid main field run
test_that("check main field run", {
  field <- igrf::igrf_grid(
    field = "main",
    year = 2000,
    type = "spheroid",
    altitude = 2,
    resolution = 5
  )
  expect_type(field, "list")
})

# valid secular variation run
test_that("check secular variation run", {
  field <- igrf::igrf(
    field = "variation",
    year = 2000,
    type = "spheroid",
    altitude = 2,
    latitude = 50,
    longitude = 10
  )

  expect_type(field, "list")
})

# out of bound latitude
test_that("invalid latitude", {
  expect_error(
    igrf::igrf(
      field = "main",
      year = 2000,
      type = "spheroid",
      altitude = 2,
      latitude = -200,
      longitude = 10
    )
  )
})

# out of bound longitude
test_that("invalid longitude", {
  expect_error(
    igrf::igrf(
      field = "main",
      year = 2000,
      type = "spheroid",
      altitude = 2,
      latitude = -20,
      longitude = 200
    )
  )
})

# out of bound year >2030
test_that("invalid year (>2030)", {
  expect_error(
    igrf::igrf(
      field = "main",
      year = 2050,
      type = "spheroid",
      altitude = 2,
      latitude = -20,
      longitude = 10
    )
  )
})

# out of bound year >2030
test_that("invalid year (<1900)", {
  expect_error(
    igrf::igrf(
      field = "main",
      year = 1850,
      type = "spheroid",
      altitude = 2,
      latitude = -20,
      longitude = 10
    )
  )
})

# spurious year >2025
test_that("spurious year (2025><2030", {
  expect_warning(
    igrf::igrf(
      field = "main",
      year = 2027,
      type = "spheroid",
      altitude = 2,
      latitude = -20,
      longitude = 10
    )
  )
})
