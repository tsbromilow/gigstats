# Calculations that need to be run every time the data file changes #

rm(list = ls())

# Libraries-------------------
library(dplyr)
library(tidyr)
library(scales)
library(xml2)
library(purrr)
library(tibble)

# Last.fm --------------------------

xml_url = "https://ws.audioscrobbler.com/2.0/?method=user.gettopartists&limit=500&user=sacredshape&api_key=9aab21d574f6a5490eb205b900f6b114"
lfm_data = read_xml(xml_url) %>% as_list()

lfm_data = tibble::as_tibble(lfm_data) %>% unnest_longer('lfm') %>%
  unnest_wider(lfm, names_repair = "minimal", ) %>%
  select(name, playcount) %>%
  unnest_wider(name, names_sep = '-') %>%
  rename('Artist' = "name-1") %>%
  unnest_wider(playcount, names_sep = '-') %>%
  rename('Scrobbles' = "playcount-1")

lfm_data$Rank <- 1:nrow(lfm_data)

lastfm <- lfm_data  %>% relocate(Rank, .before = Artist)

# Import CSVs --------------------------

Master <- read.csv(file = 'Concerts.csv', encoding = "UTF-8-BOM") %>%
  map_df(rev) %>%
  mutate(Gig = ifelse(HL == 1, cumsum(HL), NA), Order = row_number()) %>%
  map_df(rev) %>%
  relocate(Order, .before = Artist) %>%
  relocate(Gig, .before = Artist)
Future <- read.csv(file = 'Concerts.new.csv', encoding = "UTF-8-BOM") %>%
  mutate(Gig = ifelse(HL == 1, cumsum(HL), NA)) %>%
  relocate(Gig, .before = Artist)
LatLong <- read.csv(file = 'data/cities.csv', encoding = "UTF-8-BOM")

# Create tables ------------------------

MasterRDS <- Master %>% select(-HL, -VHL, -W) %>%
  mutate(
    With = replace(
      With,
      With == "Katrina, Ollie Bass, Florian, Henry, Dad, Lucy, Mum, Richard, Morag, Sam Harper, Lewis Sallows, Alex Daines",
      "Everyone!"
    )
  )

saveRDS(MasterRDS, file = "data/MasterRDS.rds")

FutureRDS <- Future  %>% select(-HL, -VHL, -W, -Img, -Setlist)

saveRDS(FutureRDS, file = "data/FutureRDS.rds")

# Artist workings -----------------------


ArtistSubset <- Master %>%
  filter(Artist %in% names(which(table(Artist) >= 2))) %>%
  select(-VHL, -1, -Notes, -W, -HL, -Gig, -Img, -Setlist)


saveRDS(ArtistSubset, file = "data/ArtistSubsetRDS.rds")


Artist <- ArtistSubset %>%
  count(Artist) %>%
  subset(Artist != "") %>%
  arrange(desc(n), Artist) %>%
  select(Artist, n)

ArtistRDS <- Artist %>%
  rename("Number of gigs" = n)

saveRDS(ArtistRDS, file = "data/ArtistCountRDS.rds")

# City workings -----------------------

CitySubset <- Master %>%
  select(-VHL, -1, -Notes, -W, -Gig, -Img, -Setlist, -Price) %>%
  subset(HL == 1) %>%
  select(-HL)

saveRDS(CitySubset, file = "data/CitySubsetRDS.rds")

CityCount <- CitySubset %>%
  count(Location) %>%
  subset(Location != "") %>%
  arrange(desc(n), Location) %>%
  select(Location, n) %>%
  rename("Number of gigs" = n)

saveRDS(CityCount, file = "data/CityCountRDS.rds")

# City map workings -----------------------

CityLeeds <- Master %>%
  subset(VHL == 1) %>%
  mutate(Location = replace(Location, Location == "Bramham Park", "Leeds")) %>%
  count(Location) %>%
  subset(Location != "") %>%
  arrange(desc(n), Location) %>%
  select(Location, n)

UKLongLat <- LatLong %>%
  subset(UK == 1)

CityLongLat <- CityLeeds %>%
  inner_join(UKLongLat)

saveRDS(CityLongLat, file = "data/CityLongLatRDS.rds")

home <- LatLong %>% filter(Location == "Home") %>% slice(1)

haversine_km <- function(lat1, lon1, lat2, lon2) {
  R <- 6371  # km
  to_rad <- pi / 180
  dlat <- (lat2 - lat1) * to_rad
  dlon <- (lon2 - lon1) * to_rad
  a <- sin(dlat / 2)^2 + cos(lat1 * to_rad) * cos(lat2 * to_rad) * sin(dlon /
                                                                         2)^2
  2 * R * asin(pmin(1, sqrt(a)))
}

furthest <- LatLong %>%
  filter(Location != "Home") %>%
  mutate(dist_km = haversine_km(Lat, Long, home$Lat, home$Long)) %>%
  arrange(desc(dist_km)) %>%
  slice(1)

saveRDS(furthest, file = "data/FurthestLongLatRDS.rds")

#Venue workings

Master.venue <- Master %>%
  mutate(Venue = ifelse(Venue == "Manchester Academy 1", "Manchester Academy", Venue)) %>%
  mutate(Venue = ifelse(Venue == "Manchester Academy 2", "Manchester Academy", Venue)) %>%
  mutate(Venue = ifelse(Venue == "Manchester Academy 3", "Manchester Academy", Venue)) %>%
  mutate(Venue = ifelse(Venue == "Manchester Club Academy", "Manchester Academy", Venue)) %>%
  mutate(Venue = ifelse(Venue == "Think Tank Underground", "Think Tank", Venue)) %>%
  mutate(Venue = ifelse(Venue == "Riverside 2", "Riverside", Venue)) %>%
  mutate(Venue = ifelse(
    Venue == "Boom 2 (Millwright Street)",
    "Boom (Millwright Street)",
    Venue
  )) %>%
  mutate(Venue = ifelse(
    Venue == "Brudenell Social Club (Main)",
    "Brudenell Social Club",
    Venue
  )) %>%
  mutate(Venue = ifelse(
    Venue == "Brudenell Social Club (Community)",
    "Brudenell Social Club",
    Venue
  )) %>%
  mutate(Venue = ifelse(
    Venue == "Sidney and Matilda (Basement)",
    "Sidney and Matilda",
    Venue
  )) %>%
  mutate(Venue = ifelse(
    Venue == "Sidney and Matilda (Gallery)",
    "Sidney and Matilda",
    Venue
  )) %>%
  mutate(Venue = ifelse(Venue == "The Cluny 2", "The Cluny", Venue))

VenueSubset <- Master.venue %>%
  select(-HL, -1, -Notes, -W, -Gig, -Img, -Setlist, -Price) %>%
  subset(VHL == 1) %>%
  select(-VHL)

saveRDS(VenueSubset, file = "data/VenueSubsetRDS.rds")

VenueCount <- VenueSubset %>%
  count(Venue) %>%
  subset(Venue != "") %>%
  arrange(desc(n), Venue) %>%
  select(Venue, n)

Venue.city <- Master.venue %>%
  select("Venue", "Location") %>%
  filter(Venue != "")  %>%
  distinct(Venue, .keep_all = TRUE)

VenueCount <- VenueCount %>%
  rename("Number of gigs" = n) %>%
  right_join(Venue.city) %>%
  relocate("Number of gigs", .after = last_col())

saveRDS(VenueCount, file = "data/VenueCountRDS.rds")

# Friends workings -------------------------------------

FriendsSubset <- Master %>%
  select(-VHL, -1, -Notes, -W, -Gig, -Img, -Setlist, -Price) %>%
  rename(Friend = With) %>%
  separate_rows(Friend, sep = ", ", convert = FALSE) %>%
  subset(HL == 1) %>%
  select(-HL)

saveRDS(FriendsSubset, file = "data/FriendsSubsetRDS.rds")

FriendsCount <- Master %>%
  subset(W == 1) %>%
  rename(Friend = With) %>%
  separate_rows(Friend, sep = ", ", convert = FALSE) %>%
  count(Friend) %>%
  subset(Friend != "") %>%
  arrange(desc(n), Friend) %>%
  select(Friend, n) %>%
  mutate(n = as.integer(n)) %>%
  rename("Number of gigs" = n)

saveRDS(FriendsCount, file = "data/FriendsCountRDS.rds")


#last fm workings ------------------------

masterseen <- Master %>%
  select(Artist) %>%
  distinct(Artist) %>%
  mutate("Seen" = "Yes")

futureseen <- Future %>%
  select(Artist) %>%
  distinct(Artist) %>%
  mutate("Seen" = "Planned")

futureseen <- Future %>%
  select(Artist) %>%
  distinct(Artist) %>%
  mutate("Seen" = "Planned")

artistseen <- Master %>%
  select(Artist) %>%
  distinct(Artist) %>%
  mutate("Seen" = "Yes") %>%
  full_join(futureseen) %>%
  distinct(Artist)

masterseen <- Master %>%
  select(Artist) %>%
  distinct(Artist) %>%
  mutate("Seen" = "Yes")

finalseen <- artistseen %>%
  left_join(masterseen) %>%
  mutate(Seen = ifelse(is.na(Seen), "Planned", Seen))

# This code renames last.fm artists in line with how I've named them in my dataset. And also makes some seen if I have kinda seen them.
lastfm <- lastfm  %>%
  mutate(Artist = ifelse(Artist == "Frank Carter & The Rattlesnakes", "Frank Carter", Artist)) %>%
  mutate(Artist = ifelse(Artist == "Esmé Patterson", "Esme Patterson", Artist)) %>%
  mutate(Artist = ifelse(Artist == "Touché Amoré", "Touche Amore", Artist)) %>%
  mutate(Artist = ifelse(
    Artist == "Aaron West and The Roaring Twenties",
    "Aaron West",
    Artist
  )) %>%
  mutate(Artist = ifelse(Artist == "Felix Hagan & The Family", "Felix Hagan", Artist)) %>%
  mutate(Artist = ifelse(Artist == "I DONT KNOW HOW BUT THEY FOUND ME", "iDKHOW", Artist)) %>%
  mutate(Artist = ifelse(Artist == "WARGASM (UK)", "Wargasm", Artist)) %>%
  mutate(Artist = ifelse(Artist == "Slaves", "Soft Play", Artist)) %>%
  mutate(Artist = ifelse(Artist == "SeeYouSpaceCowboy...", "SeeYouSpaceCowboy", Artist)) %>%
  mutate(Artist = ifelse(Artist == "'68", "68", Artist)) %>%
  
  left_join(finalseen) %>%
  mutate(Seen = ifelse(is.na(Seen), "No", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Reuben", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "The White Stripes", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Matt Bellamy", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Dan Campbell", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Oasis", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Against Me!", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "The Raconteurs", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "The Dead Weather", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "The Smiths", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Trueman", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Original Broadway Cast of Hamilton", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "The Beatles", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Rage Against the Machine", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Soft Play", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Audioslave", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "The Police", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Julien Baker", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Lucy Dacus", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Desert Sessions", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Eleven", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Ben Folds Five", "Yes", Seen))  %>%
  mutate(Seen = ifelse(Artist == "Pink Floyd", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "SeeYouSpaceCowboy", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "tankus", "Yes", Seen)) %>%
  mutate(Seen = ifelse(Artist == "Frightened Rabbit", "Yes", Seen))



lastfm <- lastfm %>%
  mutate(Artist = ifelse(Artist == "Reuben", "Reuben (Jamie Lenman)", Artist)) %>%
  mutate(Artist = ifelse(
    Artist == "The White Stripes",
    "The White Stripes (Jack White)",
    Artist
  )) %>%
  mutate(Artist = ifelse(Artist == "Oasis", "Oasis (Liam Gallagher)", Artist)) %>%
  mutate(Artist = ifelse(Artist == "Against Me!", "Against Me! (Laura Jane Grace)", Artist)) %>%
  mutate(Artist = ifelse(Artist == "The Raconteurs", "The Raconteurs (Jack White)", Artist)) %>%
  mutate(Artist = ifelse(
    Artist == "The Dead Weather",
    "The Dead Weather (Jack White)",
    Artist
  )) %>%
  mutate(Artist = ifelse(Artist == "The Smiths", "The Smiths (Johnny Marr)", Artist)) %>%
  mutate(Artist = ifelse(Artist == "The Beatles", "The Beatles (Paul McCartney)", Artist)) %>%
  mutate(
    Artist = ifelse(
      Artist == "Rage Against the Machine",
      "Rage Against the Machine (Tom Morello)",
      Artist
    )
  ) %>%
  mutate(Artist = ifelse(Artist == "Audioslave", "Audioslave (Tom Morello)", Artist)) %>%
  mutate(Artist = ifelse(Artist == "The Police", "The Police (Stewart Copeland)", Artist)) %>%
  mutate(Artist = ifelse(Artist == "Lucy Dacus", "Lucy Dacus (boygenius)", Artist)) %>%
  mutate(Artist = ifelse(Artist == "Julien Baker", "Julien Baker (boygenius)", Artist)) %>%
  mutate(Artist = ifelse(
    Artist == "Desert Sessions",
    "Desert Sessions (Alain Johannes)",
    Artist
  )) %>%
  mutate(Artist = ifelse(Artist == "Eleven", "Eleven (Alain Johannes)", Artist)) %>%
  mutate(Artist = ifelse(Artist == "Pink Floyd", "Pink Floyd (David Gilmour)", Artist)) %>%
  mutate(Artist = ifelse(Artist == "Blacklit Canopy Official", "Blacklit Canopy", Artist)) %>%
  mutate(Artist = ifelse(Artist == "tankus", "Tankus", Artist)) %>%
  mutate(Artist = ifelse(
    Artist == "Frightened Rabbit",
    "Frightened Rabbit (Sings the Greys)",
    Artist
  ))

saveRDS(lastfm, file = "data/lastfmRDS.rds")

lastfmstats <- function(num) {
  topx <- lastfm %>%
    slice_head(n = num) %>%
    filter(Seen == "Yes") %>%
    tally()
  
  tx <- topx[1, 1] / (num / 100)
  
  tx
}

t10 <- lastfmstats(10)
t20 <- lastfmstats(20)
t50 <- lastfmstats(50)
t100 <- lastfmstats(100)
t250 <- lastfmstats(250)
t500 <- lastfmstats(500)

lastfmpercents <- tibble(
  top = c("t10", "t20", "t50", "t100", "t250", "t500"),
  percent = c(t10[1, 1], t20[1, 1], t50[1, 1], t100[1, 1], t250[1, 1], t500[1, 1])
)

saveRDS(lastfmpercents, file = "data/lastfmpercentsRDS.rds")
LastFMPercents <- readRDS("data/lastfmpercentsRDS.rds")

# Cost workings ------------------

cost <- Master %>%
  arrange(desc(Price))
ExpBand <- cost[1, 3]
ExpVen <- cost[1, 4]
ExpPri <- cost[1, 8]

Cost <- Master %>%
  drop_na(Price) %>%
  mutate(Year = ifelse(Year < 2015, "2006-14", Year)) %>%
  group_by(Year) %>%
  summarize("Number of gigs" = n(), Price = round(mean(Price), 2))


Cost.means <- Master %>%
  drop_na(Price) %>%
  summarize("Number of gigs" = n(), Price = round(mean(Price), 2)) %>%
  add_column(Year = "Total", .before = "Price")

Cost.means.new <- Master %>%
  drop_na(Price) %>%
  filter(Year >= 2015) %>%
  summarize("Number of gigs" = n(), Price = round(mean(Price), 2)) %>%
  add_column(Year = "Total (excluding 2006-14)", .before = "Price")

Cost.table <- Cost %>%
  rbind(Cost.means) %>%
  rbind(Cost.means.new)

saveRDS(Cost.table, file = "data/CostsRDS.rds")


Costs.table.GBP <- Cost.table %>%
  mutate('Average Price' = paste0(enc2utf8("\u00A3"), Cost.table$Price)) %>%
  select (-Price)

saveRDS(Costs.table.GBP, file = "data/CostsGBPRDS.rds")


CostSummary <- Cost.table %>%
  select(-"Number of gigs") %>%
  slice(-c(1)) %>%
  head (-2)

NewMaster <- Master %>% filter(Year >= 2015)


# Years workings ------------------------

yearrow <- function(year) {
  current <- Master %>%
    filter(Year == year)
  
  uniqueartists <- current %>%
    distinct(Artist, .keep_all = TRUE) %>%
    nrow()
  
  uniquelocations <- current %>%
    distinct(Location, .keep_all = TRUE) %>%
    nrow()
  
  uniquevenues <- current %>%
    distinct(Venue, .keep_all = TRUE) %>%
    nrow()
  
  uniquegigs <- current %>%
    filter(HL == 1) %>%
    nrow()
  
  perweek <- round(uniquegigs / 52.1429, 2)
  
  solo <- current %>%
    filter(HL == 1) %>%
    filter(With == "Solo") %>%
    nrow()
  
  katrina <- current %>%
    filter(HL == 1) %>%
    separate_rows(With, sep = ", ", convert = FALSE) %>%
    filter(With == "Katrina") %>%
    nrow()
  
  row <- c(
    year,
    uniquegigs,
    perweek,
    uniqueartists,
    uniquelocations,
    uniquevenues,
    solo,
    katrina
  )
  
  row
}

years <- c(2015:format(Sys.Date(), "%Y"))

YearTable <- data.frame(t(sapply(years, yearrow))) %>%
  `colnames<-`(
    c(
      "Year",
      "Gigs",
      "Gigs per Week",
      "Unique Artists",
      "Unique Locations",
      "Unique Venues",
      "Solo Gigs",
      "Gigs with Katrina"
    )
  )

CurrentGpW <-     current <- Master %>%
  filter(Year == format(Sys.Date(), "%Y")) %>%
  filter(HL == 1) %>%
  nrow() / lubridate::week(Sys.Date())


YearTable$"Gigs per Week" <- replace(YearTable$"Gigs per Week",
                                     nrow(YearTable),
                                     round(CurrentGpW, 2))

saveRDS(YearTable, file = "data/YearTableRDS.rds")
