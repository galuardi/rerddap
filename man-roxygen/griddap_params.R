#' @param x Anything coercable to an object of class info. So the output of a
#' call to \code{\link{info}}, or a datasetid, which will internally be passed
#' through \code{\link{info}}
#' @param ... Dimension arguments. See examples. Can be any 1 or more of the
#' dimensions for the particular dataset - and the dimensions vary by dataset.
#' For each dimension, pass in a vector of length two, with min and max value
#' desired.
#' @param fields (character) Fields to return, in a character vector.
#' @param stride (integer) How many values to get. 1 = get every value, 2 = get
#' every other value, etc. Default: 1 (i.e., get every value)
#' @param fmt (character) One of csv or nc (for netcdf). Default: nc
#' @param url A URL for an ERDDAP server. Default:
#' \url{http://upwell.pfeg.noaa.gov/erddap/}
#' @param store One of \code{\link{disk}} (default) or \code{\link{memory}}. You
#' can pass options to \code{\link{disk}}
#' @param read (logical) Read data into memory or not. Does not apply when
#' \code{store} parameter is set to memory (which reads data into memory).
#' For large csv, or especially netcdf files, you may want to set this to
#' \code{FALSE}, which simply returns a summary of the dataset - and you can
#' read in data piecemeal later. Default: \code{TRUE}
#' @param callopts Pass on curl options to \code{\link[httr]{GET}}
#'
#' @return An object of class \code{griddap_csv} if csv chosen or
#' \code{griddap_nc} if nc file format chosen. These two classes are a thin
#' wrapper around a data.frame, so the data you get back is a data.frame with
#' metadata attached as attributes (datasetid, path (path where the nc or csv
#' is stored on your machine), url (url for the request)), along with a
#' summary of the netcdf file (if \code{fmt="nc"}). If \code{read=FALSE},
#' you get back an empty data.frame
#'
#' @details Details:
#'
#' If you run into an error like "HTTP Status 500 - There was a (temporary?)
#' problem. Wait a minute, then try again.". it's likely they are hitting
#' up against a size limit, and they should reduce the amount of data they
#' are requesting either via space, time, or variables. Pass in
#' \code{config = verbose()} to the request, and paste the URL into your
#' browser to see if the output is garbled to examine if there's a problem
#' with servers or this package
#'
#' @section Dimensions and Variables:
#' ERDDAP grid dap data has this concept of dimenions vs. variables. Dimensions
#' are things like time, latitude, longitude, altitude, and depth. Whereas
#' variables are the measured variables, e.g., temperature, salinity, air.
#'
#' You can't separately adjust values for dimensions for different variables.
#' So, here's how it's gonna work:
#'
#' Pass in lower and upper limits you want for each dimension as a vector
#' (e.g., \code{c(1,2)}), or leave to defaults (i.e., don't pass anything to
#' a dimension). Then pick which variables you want returned via the
#' \code{fields} parameter. If you don't pass in options to the \code{fields}
#' parameter, you get all variables back.
#'
#' To get the dimensions and variables, along with other metadata for a
#' dataset, run \code{\link{info}}, and each will be shown, with their min
#' and max values, and some other metadata.
#'
#' @section Where does the data go?:
#' You can choose where data is stored. Be careful though. You can easily get a
#' single file of hundreds of MB's (upper limit: 2 GB) in size with a single
#' request. To the \code{store} parameter, pass \code{\link{memory}} if you
#' want to store the data in memory (saved as a data.frame), or pass
#' \code{\link{disk}} if you want to store on disk in a file. Note that
#' \code{\link{memory}} and \code{\link{disk}} are not character strings, but
#' function calls. \code{\link{memory}} does not accept any inputs, while
#' \code{\link{disk}} does. Possibly will add other options, like
#' \dQuote{sql} for storing in a SQL database.
#'
#' @references  \url{http://upwell.pfeg.noaa.gov/erddap/rest.html}
#' @author Scott Chamberlain <myrmecocystus@@gmail.com>
