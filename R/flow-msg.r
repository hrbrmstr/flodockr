#' Post a message to a flow
#'
#' @param message message to send
#' @param flow parameterized flow name (i.e. "\code{this-flow}")
#' @param tags vector of tags for the flow
#' @param flowdock_api_key used to authorize you to Flowdoc. You should store this
#'     in \code{.Renviron} or some other moderately secure place. You can override
#'     the pick from the environment by passing it in here.
#' @return parsed call result (invisibly)
#' @export
flow_msg <- function(message=NULL,
                     flow=Sys.getenv("FLOWDOCK_DEFAULT_FLOW", NULL),
                     tags="",
                     flowdock_api_key=Sys.getenv("FLOWDOCK_PAT")) {

  if (is.null(flow) | is.null(message)) {
    stop("flow+message required", call.=FALSE)
  }

  accessible_flows <- list_flows(FALSE, flowdock_api_key)
  if (!flow %in% accessible_flows$parameterized_name) {
    stop("You don't have access to that flow", call.=FALSE)
  }

  target_flow <- filter(accessible_flows, parameterized_name == flow)

  res <- POST("https://api.flowdock.com",
              path=sprintf("flows/%s/%s/messages",
                           target_flow$organization.parameterized_name,
                           flow),
              query=list(
                event="message",
                content=message,
                tags=tags
              ),
              authenticate(user=flowdock_api_key, password=""))
  stop_for_status(res)
  dat <- fromJSON(content(res, as="text"), flatten=TRUE)
  invisible(dat)

}
