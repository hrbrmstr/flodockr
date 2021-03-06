% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flows.r
\name{list_flows}
\alias{list_flows}
\title{List flows}
\usage{
list_flows(all = FALSE, flowdock_api_key = Sys.getenv("FLOWDOCK_PAT"))
}
\arguments{
\item{all}{if \code{TRUE}, returns all the flows in an organization. If
\code{FALSE} (the default), returns only the flows you have access to.
You'll want to do this at least once to see what the
\code{parameterized_name}s of the flows you want to use.}

\item{flowdock_api_key}{used to authorize you to Flowdoc. You should store this
in \code{.Renviron} or some other moderately secure place. You can override
the pick from the environment by passing it in here.}
}
\value{
parsed call result (invisibly)
}
\description{
List flows
}

