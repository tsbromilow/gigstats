UK <- map_data("world") %>% dplyr::filter(region == "UK" | region == "Ireland")

MasterRDS      <- readRDS("Data/MasterRDS.rds")
FutureRDS      <- readRDS("Data/FutureRDS.rds")
ArtistCount    <- readRDS("Data/ArtistCountRDS.rds")
ArtistSubset   <- readRDS("Data/ArtistSubsetRDS.rds")
CityCount      <- readRDS("Data/CityCountRDS.rds")
CitySubset     <- readRDS("Data/CitySubsetRDS.rds")
VenueCount     <- readRDS("Data/VenueCountRDS.rds")
VenueSubset    <- readRDS("Data/VenueSubsetRDS.rds")
FriendsCount   <- readRDS("Data/FriendsCountRDS.rds")
FriendsSubset  <- readRDS("Data/FriendsSubsetRDS.rds")
CityLongLat    <- readRDS("Data/CityLongLatRDS.rds")
YearTable      <- readRDS("Data/YearTableRDS.rds")
LastFM         <- readRDS("Data/lastfmRDS.rds")
LastFMPercents <- readRDS("Data/lastfmpercentsRDS.rds")
CostsTable     <- readRDS("Data/CostsRDS.rds")
CostsGBPTable  <- readRDS("Data/CostsGBPRDS.rds")

# -------------------- Artist workings --------------
MostSeen        <- ArtistCount[1, 1][[1]]
mostseennumber  <- ArtistCount[1, 2][[1]]

uniqueartist <- MasterRDS %>%
  distinct(Artist, .keep_all = TRUE) %>%
  nrow()



TopArtist <- ArtistCount %>%
  slice_head(n = 20) %>%
  arrange(`Number of gigs`, desc(Artist))

TopArtist$Artist <- factor(TopArtist$Artist, levels = TopArtist$Artist)

ArtistPlot <- ggplot(TopArtist, aes(reorder(Artist, `Number of gigs`, sum), `Number of gigs`)) +
  geom_col(fill = "#605ca8") +
  coord_flip() +
  xlab("") + ylab("Number of gigs") +
  geom_text(aes(label = `Number of gigs`), hjust = 1.1, color = "white", size = 4.5, fontface = "bold") +
  scale_y_continuous(breaks = seq(0, ((ceiling(max(TopArtist$`Number of gigs`)/ 5) * 5)+1), by = 5),
                     limits = c(0, (ceiling(max(TopArtist$`Number of gigs`)/ 5) * 5)+1),
                     expand = expansion(mult = c(0, 0))) +
  gig_stats_ggplot_theme

# -------------------- City workings ----------------
mostcity       <- CityCount[1, 1][[1]]
mostcitynumber <- CityCount[1, 2][[1]]

uniquecity <- CityCount %>%
  distinct(Location, .keep_all = TRUE) %>%
  nrow()

CityReactable <- reactable(
  CityCount,
  pagination = FALSE,
  searchable = FALSE,
  striped = TRUE,
  compact = TRUE,
  defaultColDef = colDef(
    style = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"),
    headerStyle = list(fontSize = "16px", padding = "1px 3px", lineHeight = "1.1")),
  details = function(index) {
    location_data <- CitySubset[CitySubset$Location == CityCount$Location[index], ]
    htmltools::div(reactable(
      location_data,
      outlined = TRUE, pagination = FALSE, compact = TRUE,
      columns = list(
        Price    = colDef(vAlign = "center",align = "center", width = 70, format = colFormat(currency = "GBP")),
        Artist   = colDef(vAlign = "center",align = "center"),
        Venue    = colDef(vAlign = "center",align = "center"),
        Location = colDef(show = FALSE),
        Date     = colDef(vAlign = "center",align = "center", width = 80),
        Year     = colDef(vAlign = "center",align = "center", width = 80),
        With     = colDef(vAlign = "center",align = "center")),
        defaultColDef = colDef(
          style = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"),
          headerStyle = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"))
      )
    )
  }
)

TopCity <- CityCount %>%
  slice_head(n = 10) %>%
  arrange(`Number of gigs`, desc(Location))

TopCity$Location <- factor(TopCity$Location, levels = TopCity$Location)

CityPlot <- ggplot(TopCity, aes(reorder(Location, `Number of gigs`, sum), `Number of gigs`)) +
  geom_col(fill = "#605ca8") +
  coord_flip() +
  xlab("") + ylab("Number of gigs") +
  scale_y_continuous(breaks = seq(0, ((ceiling(max(TopCity$`Number of gigs`)/ 50) * 50)+1), by = 50),
                     limits = c(0, (ceiling(max(TopCity$`Number of gigs`)/ 50) * 50)+10),
                     expand = expansion(mult = c(0, 0))) +
  geom_text(aes(label = `Number of gigs`), hjust = 1.1, color = "white", size = 4.5, fontface = "bold") +
  gig_stats_ggplot_theme


CityMap <- ggplot() +
  geom_polygon(data = UK, aes(x=long, y = lat, group = group), fill="#FFFFFF") +
  geom_point(data=CityLongLat, aes(x=Long, y=Lat, alpha=n)) +
  
  geom_point(data=CityLongLat, aes(x=Long, y=Lat, size = n*2), color="#605ca8") +
  scale_size_continuous(range=c(0,6)) +
  theme_void() + ylim(50,59) + coord_map() +
  theme(plot.title = element_text(color="black", size=32, hjust = 0.5, face="bold", family="Arial"),
        legend.position="none",
        plot.background  = element_rect(fill = "#2A2F3A", color = NA),
        panel.background = element_rect(fill = "#2A2F3A", color = NA)
  )


# -------------------- Venue workings ---------------
mostvenue       <- VenueCount[1, 1][[1]]
mostvenuenumber <- VenueCount[1, 3][[1]]

uniquevenue <- VenueCount %>%
  distinct(Venue, .keep_all = TRUE) %>%
  nrow()

VenueReactable <- reactable(
  VenueCount,
  pagination = TRUE,
  defaultPageSize = 50,
  searchable = TRUE,
  columns = list(Location = colDef(align = "center")),
  defaultColDef = colDef(
    style = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"),
    headerStyle = list(fontSize = "16px", padding = "1px 3px", lineHeight = "1.1")),
  details = function(index) {
    Venue_data <- VenueSubset[VenueSubset$Venue == VenueCount$Venue[index], ]
    htmltools::div(reactable(
      Venue_data,
      outlined = TRUE, pagination = FALSE, compact = TRUE,
      columns = list(
        Price    = colDef(align = "center", width = 70, format = colFormat(currency = "GBP")),
        Venue    = colDef(show = FALSE),
        Location = colDef(show = FALSE),
        Date     = colDef(align = "center", width = 60),
        Year     = colDef(align = "center", width = 40),
        With     = colDef(align = "center")
      ),
      striped = TRUE
    ))
  }
)

TopVenue <- VenueCount %>%
  slice_head(n = 10) %>%
  arrange(`Number of gigs`, desc(Venue))

TopVenue$Venue <- factor(TopVenue$Venue, levels = TopVenue$Venue)

VenuePlot <- ggplot(TopVenue, aes(reorder(Venue, `Number of gigs`, sum), `Number of gigs`)) +
  geom_col(fill = "#605ca8") +
  coord_flip() +
  xlab("") + ylab("Number of gigs") +
  scale_y_continuous(breaks = seq(0, ((ceiling(max(TopVenue$`Number of gigs`)/ 5) * 5)+1), by = 5),
                     limits = c(0, (ceiling(max(TopVenue$`Number of gigs`)/ 5) * 5)+1),
                     expand = expansion(mult = c(0, 0))) +
  geom_text(aes(label = `Number of gigs`), hjust = 1.1, color = "white", size = 4.5, fontface = "bold", family = "Arial") +
  gig_stats_ggplot_theme

# -------------------- Friends workings -------------
mostfriend       <- FriendsCount[1, 1][[1]]
mostfriendnumber <- FriendsCount[1, 2][[1]]
solo             <- FriendsCount[2, 2][[1]]

FriendsReactable <- reactable(
  FriendsCount,
  pagination = FALSE,
  defaultColDef = colDef(
    style = list(fontSize = "14px", padding = "1px 3px", lineHeight = "1.0"),
    headerStyle = list(fontSize = "16px", padding = "1px 3px", lineHeight = "1.1")),
  details = function(index) {
    Friend_data <- FriendsSubset[FriendsSubset$Friend == FriendsCount$Friend[index], ]
    htmltools::div(reactable(
      Friend_data,
      outlined = TRUE, pagination = FALSE, compact = TRUE,
      columns = list(
        Price   = colDef(align = "center", width = 70, format = colFormat(currency = "GBP")),
        Venue   = colDef(align = "center"),
        Location= colDef(align = "center"),
        Date    = colDef(align = "center", width = 60),
        Year    = colDef(align = "center", width = 40),
        Friend  = colDef(show = FALSE)
      ),
      striped = TRUE
    ))
  }
)

TopFriends <- FriendsCount %>%
  slice_head(n = 10) %>%
  arrange(`Number of gigs`, desc(Friend))

TopFriends$Friend <- factor(TopFriends$Friend, levels = TopFriends$Friend)

FriendsPlot <- ggplot(TopFriends, aes(reorder(Friend, `Number of gigs`, sum), `Number of gigs`)) +
  geom_col(fill = "#605ca8") +
  coord_flip() +
  xlab("") + ylab("Number of gigs") +
  scale_y_continuous(breaks = seq(0, ((ceiling(max(TopFriends$`Number of gigs`)/ 50) * 50)+10), by = 50),
                     limits = c(0, (ceiling(max(TopFriends$`Number of gigs`)/ 50) * 50)+10),
                     expand = expansion(mult = c(0, 0))) +
  geom_text(aes(label = `Number of gigs`), hjust = 1.1, color = "white", size = 4.5, fontface = "bold", family = "Arial") +
  gig_stats_ggplot_theme

# -------------------- Costs workings ----------------
CostReactable <- reactable(
  CostsGBPTable,
  pagination = FALSE,
  columns = list(
    Year            = colDef(align = "left"),
    "Number of gigs"= colDef(align = "center"),
    "Average Price" = colDef(align = "center")
  ),
  striped = TRUE, compact = TRUE
)

avprice     <- round(mean(MasterRDS$Price, na.rm = TRUE), 2)
NewMasterRDS <- MasterRDS %>% filter(Year >= 2015)
avplotprice <- round(mean(NewMasterRDS$Price, na.rm = TRUE), 2)

CostSummary <- CostsTable %>%
  select(-"Number of gigs") %>%
  slice(-c(1)) %>%
  head(-2)

CostPlot <- ggplot(CostSummary, aes(x = Year, y = Price, group = 1)) +
  geom_hline(aes(yintercept = avplotprice), size = 1.5, linetype = "dashed", alpha = 0.8, color = "#3c8dbc") +
  geom_line(col = "#605ca8", size = 1, alpha = 0.4, linetype = "dotted") +
  geom_point(shape = 23, size = 5, col = "#605ca8", fill = "#605ca8") +  # 23 is diamond filled
  ylab("Mean Price Per Year") +
  annotate("text", label = paste0("Overall mean price (", "\u00A3", avplotprice, ")"), x = 5, y = avplotprice - 1) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 50), labels = function(x) paste0("\u00A3", x)) +
  theme(
    axis.text.y = element_text(hjust = 1, size = 12, face = "bold", family = "Arial"),
    axis.text.x = element_text(size = 12, face = "bold", family = "Arial"),
    panel.background = element_blank(),
    axis.title.x = element_text(size = 13, face = "bold", family = "Arial"),
    axis.title.y = element_text(size = 13, face = "bold", family = "Arial"),
    axis.line = element_line(colour = "black", linewidth = 0.5, linetype = 1, lineend = "butt"),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray", linewidth = 0.5)
  )

# -------------------- Setlists ---------------------
dat <- MasterRDS %>%
  filter(Setlist == "Yes") %>%
  select(-1, -Notes, -Gig, -With, -Price, -Setlist)

# -------------------- Years ------------------------
YearReactable <- reactable(
  YearTable,
  pagination = FALSE,
  defaultColDef = colDef(align = "center", minWidth = 60),
  columns = list("Year" = colDef(align = "left", maxWidth = 40)),
  striped = TRUE, compact = TRUE
)

# -------------------- General KPIs -----------------
gigs <- MasterRDS %>% tidyr::drop_na(Gig)
TotalGigs <- as.character(max(gigs$Gig))

year <- gigs %>% dplyr::filter(Year == format(Sys.Date(), "%Y"))
YearGigs <- nrow(year)

FutureTableCurrent <- FutureRDS %>% dplyr::filter(Year == format(Sys.Date(), "%Y"))
FutureTotal <- suppressWarnings(max(FutureTableCurrent$Gig, na.rm = TRUE))
CurrentYearTotal <- YearGigs + ifelse(is.infinite(FutureTotal), 0, FutureTotal)

longest_time <- MasterRDS %>% select(Artist,Date,Year) %>% 
  group_by(Artist) %>%
  filter(n() > 1) %>%
  ungroup() %>% 
  mutate(full_date = as.Date(paste(Date, Year), format = "%d-%b %Y")) %>% 
  select(Artist,full_date) %>%
  arrange(Artist, full_date) %>%
  group_by(Artist) %>%
  mutate(
    `First Date` = lag(full_date),
    gap_days  = as.integer(full_date - `First Date`)
  ) %>%
  filter(!is.na(gap_days)) %>%
  slice_max(gap_days, n = 1, with_ties = FALSE) %>%
  transmute(
    Artist,
    `First Date`,
    `Second Date` = full_date,
    `Gap in Days` = gap_days
  ) %>%
  ungroup() %>% 
  arrange(desc(`Gap in Days`))


longesttime_artist <- longest_time$Artist[1:3]
longesttime_time <- round(longest_time$`Gap in Days`[1:3]/365,1)



  


