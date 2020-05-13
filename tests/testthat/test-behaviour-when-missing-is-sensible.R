test_that("behaviour when index missing is sane", {

  dl <- dlist(a=1, b=2, 3, .default = 0)

  expect_identical(dl[['a']], dl$a)
  expect_identical(dl[['b']], dl$b)
  expect_identical(dl[['y']], dl$y)
  expect_identical(dl[['z']], dl$z)

  expect_identical(dl[['z']], 0)
  expect_identical(dl$z, 0)
})
