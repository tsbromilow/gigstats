
# -------------------- Libraries --------------------
library(shiny)
library(bslib)
library(shinyWidgets)
library(ggplot2)
library(tidyverse)
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

# Try to load system fonts quietly (avoid crashing on startup)

source("calcs.R")
source("theme.R")


# -------------------- UI (bslib + navbar) ----------

ui <- page_navbar(
  title = "Tom's Gig Statistics",
  theme = app_theme,
  
  # ---------------- Home ----------------
  nav_panel(
    tagList(icon("home"), "Home"),
    
    # Two columns: LEFT = stacked value-box rows; RIGHT = map
    layout_columns(
      col_widths = c(6, 6),
      
      # ---------- LEFT COLUMN: your 4 rows (unchanged content & heights) ----------
      div(
        # --- Row 1: widths 2, 6, 4 ---
        layout_columns(
          col_widths = c(2, 6, 4), height = 80,
          value_box(
            title = "Total gigs",
            value = textOutput("totalgigsbox"),
            theme_color = "primary"
          ),
          value_box(
            title = "Most seen artist",
            value = textOutput("mostseenbox"),
            theme_color = "success"
          ),
          value_box(
            title = paste0("Completed ", format(Sys.Date(), "%Y"), " gigs"),
            value = textOutput("yearbox"),
            theme_color = "info"
          )
        ),
        
        # --- Row 2: widths 8, 4 ---
        layout_columns(
          col_widths = c(8, 4), height = 80, row_heights = "auto",
          value_box(
            title = "Most common city",
            value = textOutput("mostcitybox"),
            theme_color = "primary"
          ),
          value_box(
            title = "Unique cities",
            value = textOutput("uncit"),
            theme_color = "secondary"
          )
        ),
        
        # --- Row 3: widths 8, 4 ---
        layout_columns(
          col_widths = c(8, 4), height = 80,
          value_box(
            title = "Most common venue",
            value = textOutput("mostvenuebox"),
            theme_color = "primary"
          ),
          value_box(
            title = "Unique venues",
            value = textOutput("unven"),
            theme_color = "secondary"
          )
        ),
        
        # --- Row 4: widths 5, 3, 4 ---
        layout_columns(
          col_widths = c(5, 3, 4), height = 80,
          value_box(
            title = "Most common friend",
            value = textOutput("mostfriendbox"),
            theme_color = "primary"
          ),
          value_box(
            title = "Solo gigs",
            value = textOutput("solobox"),
            theme_color = "warning"
          ),
          value_box(
            title = "Average ticket price",
            value = textOutput("avpricebox"),
            theme_color = "success"
          )
        )
      ),
      
      # ---------- RIGHT COLUMN: Map only (no blank spacer) ----------
      div(
        card(
          card_header("Location map by number of gigs (UK and Ireland)"),
          card_body(
            style = "overflow-x: auto;",
            plotOutput("citymapplot", height = "320px")
          )
        )
      )
    )
  ),
  
  # ---------------- Artists ----------------
  nav_panel(
    tagList(icon("music"), "Artists"),
    tagList(layout_columns(
      col_widths = c(6, 6),
      card(
        card_header("Artists"),
        card_body(
          plotOutput("artistplot")  # fixed height to avoid squashing
        )
      ),
      card(
        card_body(reactableOutput("artisttable"))
      ))
    )
  ),
  
  # ---------------- Locations ----------------
  nav_panel(
    tagList(icon("map-marker"), "Locations"),
    tagList(layout_columns(
      col_widths = c(6, 6),
      card(
        card_header("Locations"),
        card_body(
          plotOutput("cityplot")
        )
      ),
      card(
        card_body(reactableOutput("citytable"))
      ))
    )
  ),
  
  # ---------------- Venues ----------------
  nav_panel(
    tagList(icon("building"), "Venues"),
    tagList(layout_columns(
      col_widths = c(6, 6),
      card(
        card_header("Venues"),
        card_body(
          plotOutput("venueplot")
        )
      ),
      card(
        card_body(reactableOutput("venuetable"))
      )
    ))
  ),
  
  # ---------------- Friends ----------------
  nav_panel(
    tagList(icon("user"), "Friends"),
    tagList(layout_columns(
      col_widths = c(6, 6),
      card(
        card_header("Friends"),
        card_body(
          plotOutput("friendplot")
        )
      ),
      card(
        card_body(reactableOutput("friendtable"))
      )
    ))
  ),
  
  # ---------------- Setlists ----------------
  nav_panel(
    tagList(icon("list-alt"), "Setlists"),
    layout_columns(
      col_widths = c(3, 9),  # left: image/setlist selector, right: table
      card(
        card_header("Setlists (click on a row to see setlist)"),
        card_body(uiOutput("img"))
      ),
      card(
        card_body(DT::DTOutput("table"))
      )
    )
  ),
  
  # ---------------- Costs ----------------
  nav_panel(
    tagList(icon("pound-sign"), "Costs"),
    tagList(layout_columns(
      col_widths = c(6, 6),
      card(
        card_header("Costs"),
        card_body(
          plotOutput("costplot")
        )
      ),
      card(
        card_body(reactableOutput("coststable"))
      )
    ))
  ),
  
  # ---------------- Years ----------------
  nav_panel(
    tagList(icon("calendar"), "Years"),
    card(
      card_header("Stats by Year"),
      card_body(reactableOutput("yearstable"))
    )
  ),
  
  # ---------------- Master table ----------------
  nav_panel(
    tagList(icon("table"), "Master table"),
    card(card_body(DT::dataTableOutput("mastertable")))
  ),
  
  # ---------------- Future gigs ----------------
  nav_panel(
    tagList(icon("forward"), "Future gigs"),
    card(card_body(DT::dataTableOutput("futuretable")))
  ),
  
  # ---------------- Last.fm ranking ----------------
  nav_panel(
    tagList(icon("headphones"), "Last.fm ranking"),
    tagList(
      layout_columns(
        value_box(title = "Top 10",   value = textOutput("tenbox"),     theme_color = "primary"),
        value_box(title = "Top 20",   value = textOutput("twentybox"),  theme_color = "primary"),
        value_box(title = "Top 50",   value = textOutput("fiftybox"),   theme_color = "primary")
      ),
      layout_columns(
        value_box(title = "Top 100",  value = textOutput("hunbox"),     theme_color = "secondary"),
        value_box(title = "Top 200",  value = textOutput("twohunbox"),  theme_color = "secondary"),
        value_box(title = "Top 500",  value = textOutput("fivehunbox"), theme_color = "secondary")
      ),
      card(
        card_body(reactableOutput("lastfmtable"))
      )
    )
  )
)


  

# -------------------- Server -----------------------
server <- function(input, output, session) {
  # Artists
  output$artisttable <- renderReactable(ArtistReactable)
  output$artistplot  <- renderPlot(ArtistPlot)
  
  # Cities
  output$citytable   <- renderReactable({ CityReactable })
  output$cityplot    <- renderPlot(CityPlot)
  output$citymapplot <- renderPlot(CityMap)
  
  # Venues
  output$venueplot   <- renderPlot(VenuePlot)
  output$venuetable  <- renderReactable({ VenueReactable })
  
  # Friends
  output$friendplot  <- renderPlot(FriendsPlot)
  output$friendtable <- renderReactable({ FriendsReactable })
  
  # Costs
  output$coststable  <- renderReactable({ CostReactable })
  output$costplot    <- renderPlot(CostPlot)
  
  # Years
  output$yearstable  <- renderReactable({ YearReactable })
  
  # Master/Future tables
  MasterTable <- MasterRDS %>% dplyr::select(-Img)
  
  output$mastertable <- DT::renderDataTable({
    DT::datatable(
      MasterTable,
      rownames = FALSE,
      options = list(
        lengthMenu = c(10, 50, 100),
        pageLength = 50,
        scrollX = TRUE,
        columnDefs = list(
          list(className = "dt-center", targets = 0:1),
          list(className = "dt-left",   targets = 2),
          list(className = "dt-center", targets = 3:9)
        )
      )
    )
  })
  
  output$futuretable <- DT::renderDataTable({
    DT::datatable(
      FutureRDS,
      rownames = FALSE,
      options = list(
        lengthMenu = c(10, 50, 100),
        pageLength = 50,
        scrollX = TRUE,
        columnDefs = list(
          list(className = "dt-center", targets = 0),
          list(className = "dt-left",   targets = 1),
          list(className = "dt-center", targets = 2:8)
        )
      )
    )
  })
  
  # Last.fm table
  output$lastfmtable <- renderReactable({
    reactable::reactable(
      LastFM,
      pagination = TRUE,
      columns = list(
        "Rank"      = reactable::colDef(align = "left"),
        "Artist"    = reactable::colDef(align = "center"),
        "Seen"      = reactable::colDef(align = "center"),
        "Scrobbles" = reactable::colDef(align = "center")
      ),
      striped = TRUE, compact = TRUE, defaultPageSize = 100, minRows = 1, searchable = TRUE
    )
  })
  
  # Last.fm KPI tiles (plain text)
  output$tenbox     <- renderText({ paste0(LastFMPercents$percent[match("t10",  LastFMPercents$top)],  "%") })
  output$twentybox  <- renderText({ paste0(LastFMPercents$percent[match("t25",  LastFMPercents$top)],  "%") })
  output$fiftybox   <- renderText({ paste0(LastFMPercents$percent[match("t50",  LastFMPercents$top)],  "%") })
  output$hunbox     <- renderText({ paste0(LastFMPercents$percent[match("t100", LastFMPercents$top)],  "%") })
  output$twohunbox  <- renderText({ paste0(LastFMPercents$percent[match("t250", LastFMPercents$top)],  "%") })
  output$fivehunbox <- renderText({ paste0(LastFMPercents$percent[match("t500", LastFMPercents$top)],  "%") })
  
  # Setlists


output$table <- DT::renderDT({
  DT::datatable(
    dat,
    selection = list(mode = "single", target = "row", selected = 1),
    rownames = FALSE,
    options = list(
      autowidth  = TRUE,
      pageLength = 15,
      lengthMenu = c(15, 25, 50),
      initComplete = DT::JS("
        function(settings, json) {
          var $cont = $(this.api().table().container());
          
          // Header font-size (as you had)
          $(this.api().table().header()).css({'font-size': '80%'});

          // Search control (top right)
          $cont.find('.dataTables_filter label').css({'font-size': '80%'}); // 'Search:' label
          $cont.find('.dataTables_filter input').css({
            'font-size': '80%',
            'height': '1.8em'  // optional: adjust to match the smaller text
          });

          // Show entries control (top left)
          $cont.find('.dataTables_length label').css({'font-size': '80%'}); // 'Show _ entries' label
          $cont.find('.dataTables_length select').css({
            'font-size': '80%',
            'height': '2.5em'  // optional: keep visual balance
          });
        }
      ")
    )
  ) %>%
    DT::formatStyle(
      columns   = names(dat),
      fontSize  = '80%',
      lineHeight = '1'
    )
})


  
  df <- reactive({ dat[input[["table_rows_selected"]], ] })
  
  output$img <- renderUI({
    req(nrow(df()) > 0)
    imgfr <- lapply(df()$Img, function(file) {
      tags$div(
        tags$img(src = file, width = "100%", height = "100%"),
        tags$script(src = "titlescript.js")
      )
    })
    do.call(tagList, imgfr)
  })
  
  # Home KPI tiles (plain text for bslib::value_box)
  output$totalgigsbox  <- renderText({ TotalGigs })
  output$mostseenbox   <- renderText({ paste0(MostSeen, " - ", mostseennumber, " gigs") })
  output$mostcitybox   <- renderText({ paste0(mostcity, " - ", mostcitynumber, " gigs") })
  output$mostvenuebox  <- renderText({ paste0("The Brudenell - ", mostvenuenumber, " gigs") })
  output$mostfriendbox <- renderText({ paste0(mostfriend, " - ", mostfriendnumber, " gigs") })
  output$unven         <- renderText({ uniquevenue })
  output$uncit         <- renderText({ uniquecity })
  output$avpricebox    <- renderText({ paste0("\u00A3", avprice, " per gig") })
  output$solobox       <- renderText({ solo })
  output$yearbox       <- renderText({ paste0(YearGigs, " of ", CurrentYearTotal) })
}

# -------------------- Run app ----------------------
shinyApp(ui = ui, server = server)
