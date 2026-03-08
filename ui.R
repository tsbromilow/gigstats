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
            value = TotalGigs,
            theme = value_box_theme(
              bg = "#03c7e8",
              fg = "#ffffff"
            )
          ),
          value_box(
            title = "Most seen artist",
            value = paste0(MostSeen, " - ", mostseennumber, " gigs"),
            theme = value_box_theme(
              bg = "#605ca8",
              fg = "#ffffff"
            )
          ),
          value_box(
            title = paste0("Completed ", format(Sys.Date(), "%Y"), " gigs"),
            value = paste0(YearGigs, " of ", CurrentYearTotal),
            theme = value_box_theme(
              bg = "#c0c0c0",
              fg = "#0F1115"
            )
          )
        ),
        
        # --- Row 2: widths 8, 4 ---
        layout_columns(
          col_widths = c(8, 4), height = 80, row_heights = "auto",
          value_box(
            title = "Most common city",
            value = paste0(mostcity, " - ", mostcitynumber, " gigs"),
            theme = value_box_theme(
              bg = "#03c7e8",
              fg = "#ffffff"
            )
          ),
          value_box(
            title = "Unique cities",
            value = uniquecity,
            theme = value_box_theme(
              bg = "#605ca8",
              fg = "#ffffff"
            )
          )
        ),
        
        # --- Row 3: widths 8, 4 ---
        layout_columns(
          col_widths = c(8, 4), height = 80,
          value_box(
            title = "Most common venue",
            value = paste0("The Brudenell - ", mostvenuenumber, " gigs"),
            theme = value_box_theme(
              bg = "#c0c0c0",
              fg = "#0F1115"
            )
          ),
          value_box(
            title = "Unique venues",
            value = uniquevenue,
            theme = value_box_theme(
              bg = "#03c7e8",
              fg = "#ffffff"
            )
          )
        ),
        
        # --- Row 4: widths 5, 3, 4 ---
        layout_columns(
          col_widths = c(5, 3, 4), height = 80,
          value_box(
            title = "Most common friend",
            value = paste0(mostfriend, " - ", mostfriendnumber, " gigs"),
            theme = value_box_theme(
              bg = "#605ca8",
              fg = "#ffffff"
            )
          ),
          value_box(
            title = "Solo gigs",
            value = solo,
            theme = value_box_theme(
              bg = "#c0c0c0",
              fg = "#0F1115"
            )
          ),
          value_box(
            title = "Average ticket price",
            value = paste0("\u00A3", avprice, " per gig"),
            theme = value_box_theme(
              bg = "#03c7e8",
              fg = "#ffffff"
            )
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
    
    layout_columns(
      col_widths = c(6, 6),
      style = "align-items: stretch; column-gap: 1rem;",  # stretch row to tallest col + normal gap
      
      # LEFT column
      div(
        style = "height: 100%; display: flex; flex-direction: column;",  # make left column stretch + stack
        
        layout_columns(
          col_widths = c(3, 3, 6), height = 80,
          value_box(
            title = "Most seen artist",
            value = MostSeen,
            theme = value_box_theme(bg = "#03c7e8", fg = "#ffffff")
          ),
          value_box(
            title = "Unique artists",
            value = uniqueartist,
            theme = value_box_theme(bg = "#605ca8", fg = "#ffffff")
          ),
          
          value_box(
            title = tags$div(
              style = "font-size: 14px; line-height: 1.2; text-align: center;font-weight:400",
              HTML(
                paste0("Longest time gaps in seeing an artist"))),
            value = tags$div(
              style = "font-size: 16px; line-height: 1.2; text-align: center;font-weight:700",
              HTML(
                paste0(
                  #seq_along(longesttime_artist), ". ",
                  longesttime_artist, " (", longesttime_time, " years)",
                  collapse = "<br>"))),
            theme = value_box_theme(bg = "#c0c0c0", fg = "#0F1115")
          )
          
          
        ),
        
        # PLOT: grow to fill remaining height up to bottom of the table
        div(
          style = "flex: 1 1 auto; min-height: 0;",  # key for flex children to shrink/grow properly
          plotOutput("artistplot", height = "100%")
        )
      ),
      
      # RIGHT column (make sure this defines a height)
      div(
        style = "height: 100%;",
        reactableOutput("artisttable")
      )
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
      col_widths = c(3, 9),
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