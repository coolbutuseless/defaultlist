

test_that("list and defaultlist behave the same when elements exist", {

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Starting with en empty dlist
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dl <- empty_dlist(0)
  ll <- list()

  expect_true(is.list(dl))
  expect_true(is.list(ll))

  expect_equivalent(dl, ll)

  ll$a <- 1
  ll$b <- 2
  ll$c <- 3

  dl$a <- 1
  dl$b <- 2
  dl$c <- 3

  expect_equivalent(dl, ll)


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Simple list
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dl <- dlist(a = 1, b = 'hello', c = FALSE, .default = 0)
  ll <-  list(a = 1, b = 'hello', c = FALSE)

  expect_true(is.list(dl))
  expect_true(is.list(ll))

  expect_equivalent(dl, ll)

  for (i in seq_along(dl)) {
    expect_identical(dl[[i]], ll[[i]])
    expect_equivalent(dl[i]  , ll[i])
  }

  expect_identical(dl$a, ll$a)
  expect_identical(dl$b, ll$b)
  expect_identical(dl$c, ll$c)


  expect_equivalent(dl[ 0], ll[ 0])
  expect_equivalent(dl[-1], ll[-1])
  expect_equivalent(dl[-2], ll[-2])
  expect_equivalent(dl[-3], ll[-3])

  expect_equivalent(dl[c(1:3)], ll[c(1:3)])
  expect_equivalent(dl[c(1:2)], ll[c(1:2)])
  expect_equivalent(dl[c(2:3)], ll[c(2:3)])
  expect_equivalent(dl[c(1,3)], ll[c(1,3)])

  expect_equivalent(dl[0:2], ll[0:2])

  expect_error(dl[[-1]], "attempt to select more than one element")
  expect_error(ll[[-1]], "attempt to select more than one element")


  expect_true(is.list(dl))
  expect_true(is.list(ll))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Vector indexing of nested lists with `[[`
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dl <- dlist(a = list(a = 1, b = 2, c = 3), d = 4, e = 5, .default = 0)
  ll <-  list(a = list(a = 1, b = 2, c = 3), d = 4, e = 5)

  expect_equivalent(ll[[c(1, 2)]], dl[[c(1, 2)]])
  expect_equivalent(ll[[c('a', 'c')]], dl[[c('a', 'c')]])


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Starting with en empty dlist with a NULL default
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dl <- empty_dlist(NULL)
  ll <- list()

  expect_true(is.list(dl))
  expect_true(is.list(ll))

  expect_equivalent(dl, ll)

  ll$a <- 1
  ll$b <- 2
  ll$c <- 3

  dl$a <- 1
  dl$b <- 2
  dl$c <- 3

  expect_equivalent(dl, ll)

  expect_null(dl$d)
  expect_null(dl[[6]])

})
