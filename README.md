
<!-- README.md is generated from README.Rmd. Please edit that file -->

# defaultlist

<!-- badges: start -->

![](https://img.shields.io/badge/cool-useless-green.svg)
<!-- badges: end -->

`defaultlist` provides an object which behaves like a normal R list, but
which has a user-defined default value when the requested element is not
present.

Regular `list` objects will return `NULL` when an unknown character
index is used, or throw an error if a numeric index is beyond the length
of the list.

A `defaultlist` in these situations will instead return a default value
set by the user during initialisation.

## Why?

Use defaultlist objects if you would like to:

  - avoid having to initialise for every entry
  - avoid having to check whether an entry exists before accessing

## What’s in the box?

  - `dlist(..., .default)` - used to construct a new `defaultlist`. Same
    syntax as `list()` but needs an additional argument to set the
    default value
  - `empty_dlist(.default)` - create an empty list with the given
    default.
  - `as.dlist()` - identical to `as.list()` except it requires an
    additional argument to set the default value

## Installation

You can install from
[GitHub](https://github.com/coolbutuseless/defaultlist) with:

``` r
# install.package('remotes')
remotes::install_github('coolbutuseless/defaultlist')
```

## Basic Example

In this example a `defaultlist` is created which will return `FALSE` for
any access to an unknown element. Besides this, it will bevave
identically to a normal `list()` object.

``` r
haystack <- empty_dlist(FALSE)
haystack$surprise <- TRUE

haystack[['hello']]
#> [1] FALSE
haystack$mcfly
#> [1] FALSE
haystack[['surprise']]
#> [1] TRUE
haystack$surprise
#> [1] TRUE

haystack[11:13]
#> [[1]]
#> [1] FALSE
#> 
#> [[2]]
#> [1] FALSE
#> 
#> [[3]]
#> [1] FALSE
#> 
#> [.default = FALSE]
haystack[c('x', 'y')]
#> $x
#> [1] FALSE
#> 
#> $y
#> [1] FALSE
#> 
#> [.default = FALSE]
```

## Example: Counters

When counting from a stream of unknown objects, using a normal `list`
can get a little messy as for each object pulled from the stream there
needs to be an explicit check to see if the value is already in the list
or not.

Using a `defaultlist` lets you avoid lots of checking, and assume that
for any object not in the list, the count is zero.

``` r
census <- empty_dlist(0)

population <- c('andy', 'bob', 'carol', 'carol')

for (name in population) {
  census[[name]] <- census[[name]] + 1
}

census
```

    #> $andy
    #> [1] 1
    #> 
    #> $bob
    #> [1] 1
    #> 
    #> $carol
    #> [1] 2
    #> 
    #> [.default = 0]

``` r
census$mike
```

    #> [1] 0

## Extra Credit Example - using nested defaultlists

In this example, nested defaultlists are used to determine the most
common pairing of elements in a stream of unknown values.

This implementation does not need to know anything about the possible
values in the stream beforehand, and does not need to explicitly test
for list membership for every new token plucked from the stream.

``` r
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create a stream of characters heavily weighted towards 'a' and 'e'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set.seed(1)
stream <- sample(letters[1:5], 1000, replace = TRUE, prob = c(5, 1, 1, 1, 4))
head(stream)
```

    #> [1] "a" "a" "e" "d" "a" "d"

``` r
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create nested defaultlists
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
counter <- empty_dlist(empty_dlist(0))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Count the pair of characters (prev, this)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for (idx in 2:length(stream)) {
  this <- stream[[idx]]
  prev <- stream[[idx  - 1]]
  counter[[prev]][[this]] <- counter[[prev]][[this]] + 1
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The most probable letter pair in the stream is: a-a
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sort(unlist(counter), decreasing = TRUE)
```

    #> a.a a.e e.a e.e a.b b.a b.e d.a a.c e.b a.d c.e c.a e.c e.d d.e b.b c.b c.c d.b 
    #> 178 138 137 108  41  39  37  35  32  32  30  30  30  28  27  19   8   8   8   7 
    #> d.c b.d b.c d.d c.d 
    #>   7   7   5   4   4

## Related Software

  - Python’s
    [defaultdict](https://docs.python.org/3.8/library/collections.html#collections.defaultdict)
  - R’s [collections
    package](https://cran.r-project.org/package=collections)

## Acknowledgements

  - R Core & CRAN maintainers for giving me a playground
  - [Hadley Wickham](https://github.com/hadley) for
    [testthat](https://cran.r-project.org/package=testthat) which
    allowed test-driver-development, without which this package never
    would have worked.
