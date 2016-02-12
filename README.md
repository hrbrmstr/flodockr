
<!-- README.md is generated from README.Rmd. Please edit that file -->
`flowdockr` is an R package to work wih the [Flowdock API](https://www.flowdock.com/api)

*Heavily* based on [`slackr`](https://github.com/hrbrmstr/slackr).

The following functions are implemented:

-   `dev_flow`: Send the graphics contents of the current device to a Flowdock flow
-   `flow_file`: Upload a file to a flow
-   `flow_msg`: Post a message to a flow
-   `flow_r`: Post R objects to Flowdock
-   `get_flow_info`: Retrieve flow metadata
-   `ggflow`: Send a rendered ggplot object to Flowdock
-   `list_flows`: List flows
-   `save_flow`: Save R objects to an RData file on Flowdock

### News

-   Version 0.1.0 released

### Installation

``` r
devtools::install_github("hrbrmstr/flowdockr")
```

### Usage

``` r
library(flowdockr)

# current verison
packageVersion("flowdockr")
# [1] '0.1.0'
```

### Test Results

``` r
library(flowdockr)
library(testthat)

date()
# [1] "Fri Feb 12 17:24:32 2016"

test_dir("tests/")
# testthat results ========================================================================================================
# OK: 0 SKIPPED: 0 FAILED: 0
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
