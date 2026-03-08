server <- function(input, output, session) {
  
  # Pre-split once (do this once after ArtistSubset is created/loaded)
  ArtistSubset_split <- split(ArtistSubset, ArtistSubset$Artist)
  
  ArtistReactable <- reactable(
    ArtistCount,  height = 600,
    pagination = TRUE,
    striped = TRUE,
    defaultPageSize = 50,
    searchable = TRUE,
    
    defaultColDef = colDef(
      style       = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"),
      headerStyle = list(fontSize = "16px", padding = "1px 3px", lineHeight = "1.1")
    ),
    
    details = function(index) {
      # index is 1-based row index into ArtistCount
      artist_name <- ArtistCount$Artist[index]
      
      # Lookup the nested rows (returns NULL if missing)
      Artist_data <- ArtistSubset_split[[artist_name]]
      
      # If no rows found, show nothing (or return an empty div)
      if (is.null(Artist_data) || nrow(Artist_data) == 0) return(NULL)
      
      htmltools::div(
        reactable(
          Artist_data,
          compact = TRUE,
          striped = TRUE,
          
          columns = list(
            Price    = colDef(align = "center", width = 70, format = colFormat(currency = "GBP")),
            Artist   = colDef(show = FALSE),
            Venue    = colDef(align = "center"),
            Location = colDef(align = "center"),
            Date     = colDef(align = "center", width = 60),
            Year     = colDef(align = "center", width = 40),
            With     = colDef(align = "center")
          )
        )
      )
    }
  )
  
  # Artists
  output$artisttable <- renderReactable(ArtistReactable)
  output$artistplot  <- renderPlot(ArtistPlot)
  
  # Cities
  output$citytable   <- renderReactable({ CityReactable })
  output$cityplot    <- renderPlot(CityPlot)
  output$citymapplot <- renderPlot(CityMap, bg = "#2A2F3A")
  
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
  

}