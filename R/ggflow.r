#' Send a rendered ggplot object to Flowdock
#'
#' @param plot ggplot object
#' @param file prefix for filenames (defaults to \code{ggplot})
#' @param flow parameterized flow name (i.e. "\code{this-flow}")
#' @param tags vector of tags for the flow
#' @param scale scaling factor
#' @param width width (defaults to the width of current plotting window)
#' @param height height (defaults to the height of current plotting window)
#' @param units units for width and height when either one is explicitly specified (in, cm, or mm)
#' @param dpi dpi to use for raster graphics
#' @param limitsize when TRUE (the default), ggsave will not save images larger than 50x50 inches,
#'        to prevent the common error of specifying dimensions in pixels.
#' @param flowdock_api_key used to authorize you to Flowdoc. You should store this
#'     in \code{.Renviron} or some other moderately secure place. You can override
#'     the pick from the environment by passing it in here.
#' @param ... other arguments passed to graphics device
#' @return parsed call result (invisibly)
#' @export
ggflow <- function(plot=last_plot(),
                   file="ggplot",
                   flow=Sys.getenv("FLOWDOCK_DEFAULT_FLOW", NULL),
                   tags="",
                   scale=1,
                   width=par("din")[1],
                   height=par("din")[2],
                   units=c("in", "cm", "mm"),
                   dpi=300,
                   limitsize=TRUE,
                   flowdock_api_key=Sys.getenv("FLOWDOCK_PAT"),
                   ...) {

  Sys.setlocale('LC_ALL','C')
  ftmp <- tempfile(file, fileext=".png")
  ggsave(filename=ftmp, plot=plot, scale=scale, width=width,
         height=height, units=units, dpi=dpi, limitsize=limitsize, ...)

  res <- flow_file(ftmp, flow, tags=tags, flowdock_api_key=flowdock_api_key)

  unlink(ftmp)

  invisible(res)

}
