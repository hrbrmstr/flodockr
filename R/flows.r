#' List flows
#'
#' @param all if \code{TRUE}, returns all the flows in an organization. If
#'     \code{FALSE} (the default), returns only the flows you have access to.
#'     You'll want to do this at least once to see what the
#'     \code{parameterized_name}s of the flows you want to use.
#' @param flowdock_api_key used to authorize you to Flowdoc. You should store this
#'     in \code{.Renviron} or some other moderately secure place. You can override
#'     the pick from the environment by passing it in here.
#' @return parsed call result (invisibly)
#' @export
list_flows <- function(all=FALSE, flowdock_api_key=Sys.getenv("FLOWDOCK_PAT")) {
  res <- GET("https://api.flowdock.com",
             path=if(all) { "/flows/all" } else { "/flows" },
             authenticate(user=flowdock_api_key, password=""))
  stop_for_status(res)
  dat <- fromJSON(content(res, as="text"), flatten=TRUE)
  arrange(dat, parameterized_name)
}

