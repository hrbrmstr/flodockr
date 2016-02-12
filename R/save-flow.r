#' Save R objects to an RData file on Flowdock
#'
#' @param ... objects to store in the R data file
#' @param file filename (without extension) to use
#' @param flow parameterized flow name (i.e. "\code{this-flow}")
#' @param tags vector of tags for the flow
#' @param flowdock_api_key used to authorize you to Flowdoc. You should store this
#'     in \code{.Renviron} or some other moderately secure place. You can override
#'     the pick from the environment by passing it in here.
#' @return parsed call result (invisibly)
#' @export
save_flow <- function(...,
                      file="flowr",
                      flow=Sys.getenv("FLOWDOCK_DEFAULT_FLOW", NULL),
                      tags="",
                      flowdock_api_key=Sys.getenv("FLOWDOCK_PAT")) {


  Sys.setlocale('LC_ALL','C')

  ftmp <- tempfile(file, fileext=".rda")
  save(..., file=ftmp)

  res <- flow_file(ftmp, flow, flowdock_api_key=flowdock_api_key)

  unlink(ftmp)

  invisible(res)

}
