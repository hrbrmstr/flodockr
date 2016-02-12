#' Retrieve flow metadata
#'
#' @param flow parameterized flow name (i.e. "\code{this-flow}")
#' @param flowdock_api_key used to authorize you to Flowdoc. You should store this
#'     in \code{.Renviron} or some other moderately secure place. You can override
#'     the pick from the environment by passing it in here.
#' @return parsed call result (invisibly)
#' @export
get_flow_info <- function(flow=Sys.getenv("FLOWDOCK_DEFAULT_FLOW", NULL),
                          flowdock_api_key=Sys.getenv("FLOWDOCK_PAT")) {

  if (is.null(flow)) {
    stop("flow name is required", call.=FALSE)
  }

  accessible_flows <- list_flows(FALSE, flowdock_api_key)
  if (!flow %in% accessible_flows$parameterized_name) {
    stop("You don't have access to that flow", call.=FALSE)
  }

  target_flow <- filter(accessible_flows, parameterized_name == flow)

  res <- GET("https://api.flowdock.com",
             path=sprintf("flows/%s/%s",
                          target_flow$organization.parameterized_name,
                          flow),
             authenticate(user=flowdock_api_key, password=""))
  stop_for_status(res)
  dat <- fromJSON(content(res, as="text"), flatten=TRUE)
  dat

}
