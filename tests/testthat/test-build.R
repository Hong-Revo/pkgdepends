
context("build")

test_that("build_package", {
  args <- NULL
  mockery::stub(build_package, "build", function(...) args <<- list(...))
  build_package(tmp <- tempfile())
  expect_equal(args$path, tmp)
})

test_that("vignettes can be turned on and off", {
  skip_if_offline()
  dir.create(tmplib <- tempfile())
  on.exit(rimraf(tmplib), add = TRUE)
  pkgdir <- test_path("fixtures", "packages", "vignettes")
  inst <- new_pkg_installation_proposal(
    paste0("local::", pkgdir),
    config = list(`build-vignettes` = FALSE, library = tmplib)
  )
  inst$solve()
  inst$download()
  inst$install()

  expect_false("doc" %in% dir(file.path(tmplib, "pkgdependstest")))
  rimraf(tmplib, "pkgdependstest")

  inst2 <- new_pkg_installation_proposal(
    paste0("local::", pkgdir),
    config = list(`build-vignettes` = TRUE, library = tmplib)
  )
  inst2$solve()
  inst2$download()
  inst2$install()

  expect_true("doc" %in% dir(file.path(tmplib, "pkgdependstest")))
})
