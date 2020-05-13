#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a \code{defaultlist} object
#'
#' Similar to a `defaultdict` in Python, a \code{defaultlist} is mostly identical
#' to a list except it will return the user-defined default value if the
#' requested elements are not in the list.
#'
#' @param ... objects with which to initialise the list.
#' @param .default default value to return when item not in list
#'
#' @return new `defaultlist` object
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dlist <- function(..., .default) {
  convert_list_to_dlist(list(...), .default)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname dlist
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
empty_dlist <- function(.default) {
  convert_list_to_dlist(list(), .default)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Coerce object to list with a default value
#'
#' @inheritParams dlist
#' @param x object
#' @param all.names a logical indicating whether to copy all values or (default)
#'        only those whose names do not begin with a dot.
#' @param sorted a logical indicating whether the names of the resulting list
#'        should be sorted (increasingly). Note that this is somewhat costly,
#'        but may be useful for comparison of environments.
#' @param ... objects, possibly named.
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.dlist <- function(x, all.names = FALSE, sorted = FALSE, ..., .default) {
  res <- as.list(x, all.names = all.names, sorted = sorted, ...)
  convert_list_to_dlist(res, .default)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Internal helper to consistently convert a list to a defaultlist
#'
#' @inheritParams dlist
#' @param lst list object
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
convert_list_to_dlist <- function(lst, .default) {
  structure(lst, class = 'defaultlist', .default = .default)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Fetch value from defaultlist: [[]] or $
#'
#' @param x defaultlist object
#' @param y character or numeric index
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
`[[.defaultlist` <- `$.defaultlist` <- function(x, y) {

  if (length(y) > 1) {
    tryCatch(
      NextMethod(),
      error = function(cond) {
        attr(x, '.default')
      }
    )
  } else if ((is.character(y) && y %in% names(x)) ||
      (is.numeric(y) && as.integer(y) <= length(x))) {
    NextMethod()
  } else {
    attr(x, '.default')
  }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Fetch value from defaultlist: [[]] or $
#'
#' @param x defaultlist object
#' @param y character or numeric index
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
`$.defaultlist` <- `[[.defaultlist`



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Fetch value(s) from defaultlist: []
#'
#' @param x defaultlist object
#' @param y character or numeric index
#'
#' @importFrom stats setNames
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
`[.defaultlist` <- function(x, y) {

  .default <- attr(x, '.default')

  if (is.character(y)) {
    res <- NextMethod()
    res[!y %in% names(x)] <- list(.default)
    res <- setNames(res, y)
  } else {
    res <- NextMethod()
    .missing <- is.na(names(res))
    res[.missing] <- list(.default)
    names(res)[.missing] <- ''
  }

  convert_list_to_dlist(res, .default)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Print defaultlist
#'
#' Drop attributes to ensure it looks like a standard list.
#'
#' @param x defaultlist object
#' @param ... other arguments ignored
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print.defaultlist <- function(x, ...) {
  .default <- attr(x, '.default')
  attr(x, '.default') <- NULL
  attr(x, 'class'   ) <- NULL
  print(x)
  cat("[.default = ", .default, "]\n", sep="")
}
