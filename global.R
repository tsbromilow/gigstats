
# -------------------- Libraries --------------------
library(shiny)
library(bslib)
library(shinyWidgets)
library(ggplot2)
#library(tidyverse)
library(DT)
library(ggthemes)
library(rsconnect)
library(dplyr)
library(mapproj)
library(ggrepel)
library(plotly)
library(maps)
library(scales)
library(reactable)
library(shinyjs)

options(shiny.fullstacktrace = TRUE)
options(sass.cache=FALSE)

source("theme.R")
source("calcs.R")


source("ui.R")
source("server.R")

# -------------------- Run app ----------------------
shinyApp(ui = ui, server = server)
