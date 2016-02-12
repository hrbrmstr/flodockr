#' Post R objects to Flowdock
#'
#' @param ... one or more R objects
#' @param flow parameterized flow name (i.e. "\code{this-flow}")
#' @param tags vector of tags for the flow
#' @param flowdock_api_key used to authorize you to Flowdoc. You should store this
#'     in \code{.Renviron} or some other moderately secure place. You can override
#'     the pick from the environment by passing it in here.
#' @return parsed call result (invisibly)
#' @export
flow_r <- function(...,
                   flow=Sys.getenv("FLOWDOCK_DEFAULT_FLOW", NULL),
                   tags="",
                   flowdock_api_key=Sys.getenv("FLOWDOCK_PAT")) {

  if (is.null(flow)) {
    stop("flow paramaterized name required", call.=FALSE)
  }

  accessible_flows <- list_flows(FALSE, flowdock_api_key)
  if (!flow %in% accessible_flows$parameterized_name) {
    stop("You don't have access to that flow", call.=FALSE)
  }

  target_flow <- filter(accessible_flows, parameterized_name == flow)

  resp_ret <- ""

  dat <- NULL

  if (!missing(...)) {

    # mimics capture.output

    # get the arglist
    args <- substitute(list(...))[-1L]

    # setup in-memory sink
    rval <- NULL
    file <- textConnection("rval", "w", local = TRUE)

    sink(file)
    on.exit({
      sink()
      close(file)
    })

    # where we'll need to eval expressions
    pf <- parent.frame()

    # how we'll eval expressions
    evalVis <- function(expr) withVisible(eval(expr, pf))

    # for each expression
    for (i in seq_along(args)) {

      expr <- args[[i]]

      # do something, note all the newlines...Flowdock ``` needs them
      tmp <- switch(mode(expr),
                    # if it's actually an expresison, iterate over it
                    expression = {
                      cat(sprintf("> %s\n", deparse(expr)))
                      lapply(expr, evalVis)
                    },
                    # if it's a call or a name, eval, printing run output as if in console
                    call = ,
                    name = {
                      cat(sprintf("> %s\n", deparse(expr)))
                      list(evalVis(expr))
                    },
                    # if pretty much anything else (i.e. a bare value) just output it
                    integer = ,
                    double = ,
                    complex = ,
                    raw = ,
                    logical = ,
                    numeric = cat(sprintf("%s\n\n", as.character(expr))),
                    character = cat(sprintf("%s\n\n", expr)),
                    stop("mode of argument not handled at present by slackr"))

      for (item in tmp) if (item$visible) { print(item$value); cat("\n") }

    }

    on.exit()

    sink()
    close(file)

    # combined all of them (rval is a character vector)
    output <- paste0(rval, collapse="\n")

    res <- POST("https://api.flowdock.com",
                path=sprintf("flows/%s/%s/messages",
                             target_flow$organization.parameterized_name,
                             flow),
                query=list(
                  event="message",
                  content=sprintf("```\n%s\n```", output),
                  tags=tags
                ),
                authenticate(user=flowdock_api_key, password=""))
    stop_for_status(res)
    dat <- fromJSON(content(res, as="text"), flatten=TRUE)

  } else {

  }

  invisible(dat)

}
