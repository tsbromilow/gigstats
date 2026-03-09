server <- function(input, output, session) {
  
  ArtistSubset_split <- split(ArtistSubset, ArtistSubset$Artist)
  
  ArtistReactable <- reactable(
    ArtistCount,  height = 600,
    pagination = FALSE,
    striped = TRUE,
    compact = TRUE,
    defaultPageSize = 50,
    searchable = TRUE,
    
    defaultColDef = colDef(
      style       = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"),
      headerStyle = list(fontSize = "16px", padding = "1px 3px", lineHeight = "1.2")
    ),
    
    details = function(index) {
      # index is 1-based row index into ArtistCount
      artist_name <- ArtistCount$Artist[index]
      
      # Lookup the nested rows (returns NULL if missing)
      Artist_data <- ArtistSubset_split[[artist_name]]
      
      # If no rows found, show nothing (or return an empty div)
      if (is.null(Artist_data) || nrow(Artist_data) == 0) return(NULL)
      
      div(
        reactable(
          Artist_data,
          compact = TRUE,
          striped = TRUE,
          pagination = FALSE,
          
          defaultColDef = colDef(
            style       = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"),
            headerStyle = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.1")
          ),
          columns = list(
            Price    = colDef(align = "center", minWidth  = 70, format = colFormat(currency = "GBP")),
            Artist   = colDef(show = FALSE),
            Venue    = colDef(align = "left", minWidth  = 150),
            Location = colDef(align = "center"),
            Date     = colDef(align = "center", minWidth  = 60),
            Year     = colDef(align = "center", minWidth  = 60),
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
  output$costplot    <- renderPlot({CostPlot})
  
  # Years
  output$yearstable  <- renderReactable({ YearReactable })
  
  # Master/Future tables
  MasterTable <- MasterRDS %>% dplyr::select(-Img)
  
  output$mastertable <- DT::renderDataTable({
    DT::datatable(
      MasterTable,
      rownames = FALSE,
      options = list(
        paging = FALSE,
        info = FALSE,
        scrollY = "500px",
        scrollCollapse = TRUE,
        scrollX = TRUE,
        scrollX = TRUE,
        columnDefs = list(
          list(className = "dt-center", targets = 0:1),
          list(className = "dt-left",   targets = 2),
          list(className = "dt-center", targets = 3:9)
        )
      )
    ) %>%
      DT::formatStyle(
        columns   = names(MasterTable),
        fontSize  = "14px",
        lineHeight = '1',
        
      )
  })
  
  output$futuretable <- DT::renderDataTable({
    DT::datatable(
      FutureRDS,
      rownames = FALSE,
      
      options = list(
        paging = FALSE,
        info = FALSE,
        scrollY = "500px",
        scrollCollapse = TRUE,
        scrollX = TRUE,
        columnDefs = list(
          list(className = "dt-center", targets = 0),
          list(className = "dt-left",   targets = 1),
          list(className = "dt-center", targets = 2:8)
        )
      )
    ) %>%
      DT::formatStyle(
        columns   = names(FutureRDS),
        fontSize  = "14px",
        lineHeight = '1',
        
      )
  })
  
  # Last.fm table
  output$lastfmtable <- renderReactable({
    reactable::reactable(
      LastFM, height = 600,
      pagination = TRUE,
      defaultColDef = colDef(
        style       = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"),
        headerStyle = list(fontSize = "16px", padding = "1px 3px", lineHeight = "1.2")
      ),
      columns = list(
        "Rank"      = reactable::colDef(align = "left"),
        "Artist"    = reactable::colDef(align = "center", minWidth = 300),
        "Seen"      = reactable::colDef(align = "center"),
        "Scrobbles" = reactable::colDef(align = "center")
      ),
      striped = TRUE, compact = TRUE, defaultPageSize = 100, minRows = 1, searchable = TRUE
    )
  })
  

  
  # Setlists
  
  
  output$table <- DT::renderDT({
    DT::datatable(
      dat,
      selection = list(mode = "single", target = "row", selected = 1),
      rownames = FALSE,
      options = list(
        paging = FALSE,
        info = FALSE,
        scrollY = "500px",
        scrollCollapse = TRUE,
          columnDefs = list(
            list(className = "dt-left",   targets = c(0)),  # e.g. first two columns
            list(className = "dt-center", targets = c(1:4)),
            list(visible = FALSE, targets = 5)
          ),
        autowidth  = TRUE,

        
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
        fontSize  = "14px",
        lineHeight = '1',

      )
  })
  
  
  
  df <- reactive({ dat[input[["table_rows_selected"]], ] })
  
  output$img <- renderUI({
    req(nrow(df()) > 0)
    imgfr <- lapply(df()$Img, function(file) {
      tags$div(
        tags$img(src = file, width = "85%", height = "85%"),
        tags$script(src = "titlescript.js")
      )
    })
    do.call(tagList, imgfr)
  })
  

}