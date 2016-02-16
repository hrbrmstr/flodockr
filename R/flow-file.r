#' Upload a file to a flow
#'
#' @param fil path to file to upload
#' @param flow parameterized flow name (i.e. "\code{this-flow}")
#' @param tags vector of tags for the flow
#' @param flowdock_api_key used to authorize you to Flowdoc. You should store this
#'     in \code{.Renviron} or some other moderately secure place. You can override
#'     the pick from the environment by passing it in here.
#' @return parsed call result (invisibly)
#' @export
flow_file <- function(fil=NULL,
                      flow=Sys.getenv("FLOWDOCK_DEFAULT_FLOW", NULL),
                      tags="",
                      flowdock_api_key=Sys.getenv("FLOWDOCK_PAT")) {

  if (is.null(flow) | is.null(fil)) {
    stop("flow+file required", call.=FALSE)
  }

  accessible_flows <- list_flows(FALSE, flowdock_api_key)
  if (!flow %in% accessible_flows$parameterized_name) {
    stop("You don't have access to that flow", call.=FALSE)
  }

  target_flow <- dplyr::filter(accessible_flows, parameterized_name == flow)

  flow_fil <- upload_file(path.expand(fil))

  res <- POST("https://api.flowdock.com",
              path=sprintf("flows/%s/%s/messages",
                           target_flow$organization.parameterized_name,
                           flow),
              encode="multipart",
              body=list(
                event="file",
                content=flow_fil,
                tags=tags
              ),
              authenticate(user=flowdock_api_key, password=""))

  stop_for_status(res)
  dat <- fromJSON(content(res, as="text"), flatten=TRUE)
  invisible(dat)

}
