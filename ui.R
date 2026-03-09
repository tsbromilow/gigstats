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
              bg = "#a0dee8",
              fg = "#2A2F3A"
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
              fg = "#2A2F3A"
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
              bg = "#a0dee8",
              fg = "#2A2F3A"
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
              fg = "#2A2F3A"
            )
          ),
          value_box(
            title = "Unique venues",
            value = uniquevenue,
            theme = value_box_theme(
              bg = "#a0dee8",
              fg = "#2A2F3A"
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
              fg = "#2A2F3A"
            )
          ),
          value_box(
            title = "Average ticket price",
            value = paste0("\u00A3", avprice, " per gig"),
            theme = value_box_theme(
              bg = "#a0dee8",
              fg = "#2A2F3A"
            )
          )
        )
      ),
      
      # ---------- RIGHT COLUMN: Map only (no blank spacer) ----------
      div(
        card(
          
          card_header(
            div(
              style = "width: 100%; text-align: center; font-weight: 700;",
              "Location map by number of gigs (UK and Ireland)"
            )
          )
          ,
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
      
      div(
        style = "height: 100%; display: flex; flex-direction: column;",  # make left column stretch + stack
        
        layout_columns(
          col_widths = c(3, 3, 6), height = 80,
          value_box(
            title = "Most seen artist",
            value = MostSeen,
            theme = value_box_theme(bg = "#a0dee8", fg = "#2A2F3A")
          ),
          value_box(
            title = "Unique artists",
            value = uniqueartist,
            theme = value_box_theme(bg = "#605ca8", fg = "#ffffff")
          ),
          
          value_box(
            title = paste0("Longest time gap in seeing an artist"),
            value = paste0(longesttime_time, " years - ",longesttime_artist),
            theme = value_box_theme(bg = "#c0c0c0", fg = "#2A2F3A")
          )
          
          
        ),
        
        div(
          style = "flex: 1 1 auto; min-height: 0;",  # key for flex children to shrink/grow properly
          plotOutput("artistplot", height = "100%")
        )
      ),
      
      div(
        style = "height: 100%;",
        reactableOutput("artisttable")
      )
    )
  ),
  
  # ---------------- Locations ----------------
  nav_panel(
    tagList(icon("map-marker"), "Locations"),
    layout_columns(
      col_widths = c(6, 6),
      style = "align-items: stretch; column-gap: 1rem;",  # stretch row to tallest col + normal gap
      
      div(
        style = "height: 100%; display: flex; flex-direction: column;",  # make left column stretch + stack
        
        layout_columns(
          col_widths = c(3, 3, 6), height = 80,
          value_box(
            title = "Most common city",
            value = paste0(mostcity),
            theme = value_box_theme(bg = "#a0dee8", fg = "#2A2F3A")
          ),
          value_box(
            title = "Unique cities",
            value = uniquecity,
            theme = value_box_theme(bg = "#605ca8", fg = "#ffffff")
          ),
          
          value_box(
            title = "Furthest place from home",
            value = paste(furthest_city,"-",format(furthest_distance, big.mark = ",", trim = TRUE),"km"),
            theme = value_box_theme(bg = "#c0c0c0", fg = "#2A2F3A")
          )
          
          
        ),
        
        div(
          style = "flex: 1 1 auto; min-height: 0;",  # key for flex children to shrink/grow properly
          plotOutput("cityplot", height = "100%")
        )
      ),
      
      div(
        style = "height: 100%;",
        reactableOutput("citytable")
      )
    )),
  
  # ---------------- Venues ----------------
  nav_panel(
    tagList(icon("building"), "Venues"),
    layout_columns(
      col_widths = c(6, 6),
      style = "align-items: stretch; column-gap: 1rem;",  # stretch row to tallest col + normal gap
      
      div(
        style = "height: 100%; display: flex; flex-direction: column;",  # make left column stretch + stack
        
        layout_columns(
          col_widths = c(4, 3, 5), height = 80,
          value_box(
            title = "Most common venue",
            value = "The Brudenell",
            theme = value_box_theme(bg = "#a0dee8", fg = "#2A2F3A")),
 
          value_box(
            title = "Unique venues",
            value = uniquevenue,
            theme = value_box_theme(bg = "#605ca8", fg = "#ffffff")
          ),
          
          value_box(
            title = "Most venues in one city",
            value = paste(venue_most_city,"-",venue_most_number," venues"),
            theme = value_box_theme(bg = "#c0c0c0", fg = "#2A2F3A")
          )
          
          
        ),
        
        div(
          style = "flex: 1 1 auto; min-height: 0;",  # key for flex children to shrink/grow properly
          plotOutput("venueplot", height = "100%")
        )
      ),
      
      div(
        style = "height: 100%;",
        reactableOutput("venuetable")
      )
    )),
  
  # ---------------- Friends ----------------
  nav_panel(
    tagList(icon("user"), "Friends"),
    layout_columns(
      col_widths = c(6, 6),
      style = "align-items: stretch; column-gap: 1rem;",  # stretch row to tallest col + normal gap
      
      div(
        style = "height: 100%; display: flex; flex-direction: column;",  # make left column stretch + stack
        
        layout_columns(
          col_widths = c(4, 4, 4), height = 80,
          value_box(
            title = "Best friend",
            value = mostfriend,
            theme = value_box_theme(bg = "#a0dee8", fg = "#2A2F3A")
          ),
          value_box(
            title = "Different people",
            value = uniquefriend,
            theme = value_box_theme(bg = "#605ca8", fg = "#ffffff")
          ),
          
          value_box(
            title = "Solo gigs",
            value = solo,
            theme = value_box_theme(
              bg = "#c0c0c0",
              fg = "#2A2F3A"
            ))
          
        ),
        
        div(
          style = "flex: 1 1 auto; min-height: 0;",  # key for flex children to shrink/grow properly
          plotOutput("friendplot", height = "100%")
        ))
      ,
      
      div(
        style = "height: 100%;",
        reactableOutput("friendtable")
      )
    )),
  
  # ---------------- Setlists ----------------
  nav_panel(
    tagList(icon("list-alt"), "Setlists"),
    layout_columns(
      col_widths = c(4, 8),
      
      div(
        div(
          style = "
          text-align: left;
          font-weight: 700;
          color: #a0dee8;
          margin-bottom: 10px;
          font-size: 14px;
        ",
          "Click on a table row to view that setlist"
        ),
        uiOutput("img")
      ),
      
      DTOutput("table")
    )
  ),
  
  # ---------------- Costs ----------------
  nav_panel(
    tagList(icon("pound-sign"), "Costs"),
    layout_columns(
      col_widths = c(6, 6),
      style = "align-items: stretch; column-gap: 1rem;",  # stretch row to tallest col + normal gap
      
      div(
        style = "height: 100%; display: flex; flex-direction: column;",  # make left column stretch + stack
        
        layout_columns(
          col_widths = c(3, 6, 3), height = 80,
          value_box(
            title = "Mean ticket price",
            value = paste0("£",avplotprice),
            theme = value_box_theme(bg = "#a0dee8", fg = "#2A2F3A")),
          
          value_box(
            title = "Most expensive single gig",
            value = paste0(max_price_name," for £",max_price_money),
            theme = value_box_theme(bg = "#605ca8", fg = "#ffffff")
          ),
          
          value_box(
            title = "Number of free gigs",
            value = paste0(free_gigs," gigs"),
            theme = value_box_theme(bg = "#c0c0c0", fg = "#2A2F3A")
          )
          
          
        ),
        
        div(
          style = "flex: 1 1 auto; min-height: 0;",  # key for flex children to shrink/grow properly
          plotOutput("costplot", height = "90%")
        )
      ),
      
      div(
        style = "height: 100%;",
        reactableOutput("coststable")
      )
    )),
  
  # ---------------- Years ----------------
  nav_panel(
    tagList(icon("calendar"), "Years"),
reactableOutput("yearstable")
    
  ),
  
  # ---------------- Master table ----------------
  nav_panel(
    tagList(icon("table"), "Master table"),
    dataTableOutput("mastertable")
  ),
  
  # ---------------- Future gigs ----------------
  nav_panel(
    tagList(icon("forward"), "Future gigs"),
    dataTableOutput("futuretable")
  ),
  
  # ---------------- Last.fm ranking ----------------
  nav_panel(
    tagList(icon("headphones"), "Last.fm ranking"),
    layout_columns(
      col_widths = c(6, 6),
      div(
      layout_columns(height = 80,
        col_widths = c(4,4,4), 
                               value_box(
                                 title = "of my top 10 most listened to",
                                 value = paste0("Seen ",LastFMPercents$percent[match("t10",  LastFMPercents$top)],  "%"),
                                 theme = value_box_theme(
                                   bg = "#a0dee8",
                                   fg = "#2A2F3A"
                                 )
                               ),
                               value_box(
                                 title = "of my top 20 most listened to",
                                 value = paste0("Seen ",LastFMPercents$percent[match("t20",  LastFMPercents$top)],  "%"),
                                 theme = value_box_theme(
                                   bg = "#605ca8",
                                   fg = "#ffffff"
                                 )
                               ),
                               value_box(
                                 title = "of my top 50 most listened to",
                                 value = paste0("Seen ",LastFMPercents$percent[match("t50",  LastFMPercents$top)],  "%"),
                                 theme = value_box_theme(
                                   bg = "#c0c0c0",
                                   fg = "#2A2F3A"
                                 ))
      ),
      layout_columns(height = 80,
                     col_widths = c(4,4,4), 
                     value_box(
                       title = "of my top 100 most listened to",
                       value = paste0("Seen ",LastFMPercents$percent[match("t100",  LastFMPercents$top)],  "%"),
                       theme = value_box_theme(
                         bg = "#a0dee8",
                         fg = "#2A2F3A"
                       )
                     ),
                     value_box(
                       title = "of my top 250 most listened to",
                       value = paste0("Seen ",LastFMPercents$percent[match("t250",  LastFMPercents$top)],  "%"),
                       theme = value_box_theme(
                         bg = "#605ca8",
                         fg = "#ffffff"
                       )
                     ),
                     value_box(
                       title = "of my top 500 most listened to",
                       value = paste0("Seen ",LastFMPercents$percent[match("t500",  LastFMPercents$top)],  "%"),
                       theme = value_box_theme(
                         bg = "#c0c0c0",
                         fg = "#2A2F3A"
                       )
                     )
      ),
      layout_columns(
        col_widths = c(8, 4),
        height = 340,
        
        # LEFT panel
        div(
          style = paste0(
            "height:340px;",
            "background:#a0dee8;",
            "color:#2A2F3A;",
            "border-radius:12px;",
            "padding:16px;",
            "box-sizing:border-box;",
            "display:flex; flex-direction:column;",
            "justify-content:flex-start;",   # top align
            "align-items:flex-start;",       # left align
            "text-align:left;"
          ),
          div(
            style = "font-size:0.95rem; line-height:1; font-weight:700; margin:0;",
            "Bands I have left to see:"
          ),
          div(style = "height:0.2rem;"),
          div(
            style = "font-size:1rem; line-height:1.5; width:100%;",
            layout_columns(
              col_widths = c(6, 6),
              tags$ul(style = "margin:0; padding-left:0.9rem;", lapply(not_seen_1, tags$li)),
              tags$ul(style = "margin:0; padding-left:0.9rem;", lapply(not_seen_2, tags$li)),
              gap = "0.5rem"
            )
          )
        ),
        
        # RIGHT panel
        div(
          style = paste0(
            "height:340px;",
            "background:#605ca8;",
            "color:#ffffff;",
            "border-radius:12px;",
            "padding:16px;",
            "box-sizing:border-box;",
            "display:flex; flex-direction:column;",
            "justify-content:flex-start;",
            "align-items:flex-start;",
            "text-align:left;"
          ),
          div(
            style = "font-size:0.95rem; line-height:1; font-weight:700; margin:0;",
            "Bands I have a ticket for:"
          ),
          div(style = "height:0.2rem;"),
          div(
            style = "font-size:1rem; line-height:1.5; width:100%;",
            tags$ul(style = "margin:0; padding-left:0.9rem;", lapply(planned, tags$li))
          )
        )
      )),
      div(reactableOutput("lastfmtable"))
    )
  )
)