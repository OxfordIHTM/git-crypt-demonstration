# Example workflow with encrypted environment variables and credentials --------


## Load package dependencies ----
library(googledrive)
library(codigo)


## Load encrypted environment variables ----
readRenviron(".env")


## Load project-specific functions ----
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Authenticate with ICD API and retrieve CoD code for colorectal cancer ----

### Create OAuth client ----
example_client <- icd_oauth_client(
  id = Sys.getenv("ICD_CLIENT_ID"),
  token_url = "https://icdaccessmanagement.who.int/connect/token",
  secret = Sys.getenv("ICD_CLIENT_SECRET"),
  name = "Example ICD Client"
)

### Get CoD code for colorectal cancer ----
icd_search(q = "colorectal cancer", client = example_client) |>
  dplyr::select(title, theCode) |>
  dplyr::summarise(
    title = unique(title),
    .by = theCode
  )


## Authenticate with Google Drive and download who-regions.csv dataset ----

### Download who-regions.csv ----
download_googledrive(
  filename = "who-regions.csv",
  path = "data-raw/who-regions.csv"
)

### Read who-regions.csv ----
who_regions <- read.csv("data-raw/who-regions.csv")
