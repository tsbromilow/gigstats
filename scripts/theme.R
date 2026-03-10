app_theme <- bs_theme(
  version = 5,
  bg        = "#2A2F3A",
  fg        = "#a0dee8",
  primary   = "#605ca8",
  secondary = "#828995",
  
  "body-bg"            = "#2A2F3A",
  "body-color"         = "#a0dee8",
  "card-bg"            = "#2A2F3A",
  "card-border-color"  = "#a0dee8",
  "border-color"       = "#a0dee8",
  
  "link-color"         = "#a0dee8",
  "link-hover-color"   = "#a0dee8",
  "danger"             = "#a0dee8",
  
  "input-bg"           = "#2A2F3A",
  "input-border-color" = "#2A2F3A"
) %>%
  bs_add_rules("
.bslib-value-box > .card-body {
  padding: 0.5rem 0.75rem;
  padding-left: 0 !important;
  padding-right: 0 !important;
}

.bslib-value-box .value-box-area {
  display: flex;
  flex-direction: column-reverse;
}

.bslib-value-box .value-box-area .value-box-title {
  margin-top: 0.1rem;
  margin-bottom: 0.1rem;
  font-size: 0.85rem;
  line-height: 1;
  text-align: center;
}

.bslib-value-box .value-box-area .value-box-value {
  font-size: 1.4rem;
  line-height: 1.1;
  margin-top: 0.1rem;
  margin-bottom: 0.1rem;
  text-align: center;
  font-weight: 700;
  border: none !important;
  box-shadow: none !important;
}

#ArtistReactable .rt-td-inner {
  font-size: 14px !important;
  padding-top: 3px !important;
  padding-bottom: 3px !important;
}

.reactable .rt-expander::after {
  border-top-color: #a0dee8;
}

.reactable .rt-td,
.reactable .rt-th {
  background-color: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
  border-radius: 0 !important;
}

.reactable .rt-tbody .rt-tr:nth-child(even) .rt-td,
.reactable .rt-tbody .rt-tr-group:nth-child(even) .rt-td {
  background-color: #2d3240 !important;
}

.reactable .rt-tbody .rt-tr:hover > .rt-td {
  background-color: #605ca8 !important;
}

.reactable .Reactable.ReactTable.rt-compact,
.reactable .Reactable.ReactTable.rt-compact .rt-table,
.reactable .Reactable.ReactTable.rt-compact .rt-thead,
.reactable .Reactable.ReactTable.rt-compact .rt-tbody,
.reactable .Reactable.ReactTable.rt-compact .rt-pagination,
.reactable .Reactable.ReactTable.rt-compact .rt-toolbar,
.reactable .Reactable.ReactTable.rt-compact .rt-search {
  background-color: #2A2F3A !important;
}

table.dataTable tbody tr.selected,
table.dataTable tbody tr.selected > td {
  color: #a0dee8 !important;
}

.dataTable tbody tr:hover,
table.dataTable tbody tr:hover > td {
  background-color: #605ca8 !important;
  color: #a0dee8 !important;
}

div.dataTables_filter { 
  margin-bottom: -6px; 
}

div.dataTables_filter input {
  height: 26px !important;
  padding: 2px 6px !important;
  font-size: 12px !important;
  line-height: 1.2 !important;
  border-radius: 6px !important;
}

div.dataTables_filter label { 
  font-size: 12px !important; 
}

@media (max-width: 768px) {
  #artisttable, #artisttable .reactable, #artisttable .ReactTable,
  #citytable,   #citytable   .reactable, #citytable   .ReactTable,
  #venuetable,  #venuetable  .reactable, #venuetable  .ReactTable,
  #friendtable, #friendtable .reactable, #friendtable .ReactTable,
  #coststable,  #coststable  .reactable, #coststable  .ReactTable {
    height: 500px !important;
  }

  #artistplot,
  #cityplot,
  #venueplot,
  #friendplot,
  #costplot {
    min-height: 320px !important;
  }
}
  ")

gig_stats_ggplot_theme <- theme(
  axis.text.y = element_text(
    colour = "#a0dee8",
    hjust = 1,
    size = 12,
    face = "bold",
    family = "Arial"
  ),
  axis.text.x = element_text(
    colour = "#a0dee8",
    size = 12,
    face = "bold",
    family = "Arial"
  ),
  plot.background = element_rect(fill = "#2A2F3A", colour = NA),
  panel.background = element_rect(fill = "#2A2F3A"),
  axis.ticks = element_blank(),
  panel.border = element_rect(
    colour = "#2A2F3A",
    fill = NA,
    linewidth = 0.5
  ),
  axis.title.x = element_text(
    colour = "#a0dee8",
    face = "bold",
    family = "Arial"
  ),
  axis.line = element_line(
    colour = "#a0dee8",
    linewidth = 0.5,
    linetype = 1,
    lineend = "butt"
  ),
  panel.grid.major.y = element_blank(),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.x = element_blank(),
  panel.grid.minor.x = element_blank()
)