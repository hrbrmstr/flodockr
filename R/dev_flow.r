#' Send the graphics contents of the current device to a Flowdock flow
#'
#' @param ... other arguments passed into png device
#' @param file prefix for filenames (defaults to \code{plot})
#' @param flow parameterized flow name (i.e. "\code{this-flow}")
#' @param tags vector of tags for the flow
#' @param flowdock_api_key used to authorize you to Flowdoc. You should store this
#'     in \code{.Renviron} or some other moderately secure place. You can override
#'     the pick from the environment by passing it in here.
#' @return parsed call result (invisibly)
#' @export
dev_flow <- function(...,
                     file="Rplot",
                     flow=Sys.getenv("FLOWDOCK_DEFAULT_FLOW", NULL),
                     tags="",
                     flowdock_api_key=Sys.getenv("FLOWDOCK_PAT")) {

  loc <- Sys.getlocale('LC_CTYPE')
  Sys.setlocale('LC_CTYPE','C')
  on.exit(Sys.setlocale("LC_CTYPE", loc))

  ftmp <- tempfile(file, fileext=".png")
  dev.copy(png, file=ftmp, ...)
  dev.off()

  on.exit(unlink(ftmp), add=TRUE)

  res <- flow_file(ftmp, flow, tags=tags, flowdock_api_key=flowdock_api_key)

  unlink(ftmp)

  invisible(res)

}
