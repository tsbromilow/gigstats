app_theme <- bs_theme(
  version = 5,
    # Core palette
  bg       = "#2A2F3A", 
  fg       = "#a0dee8",  
  primary  = "#605ca8", 
  secondary= "#828995", 
  # Surfaces & borders
  "body-bg"             = "#2A2F3A",
  "body-color"          = "#a0dee8",
  "card-bg"             = "#2A2F3A",
  "card-border-color"   = "#a0dee8",
  "border-color"        = "#a0dee8",
  # Links & states
  "link-color"          = "#a0dee8",   # lighter red for links
  "link-hover-color"    = "#FF817C",
  "success"             = "#28A745",
  "warning"             = "#E0A800",
  "danger"              = "#C2504E",
  # Inputs
  "input-bg"            = "#2A2F3A",
  "input-border-color"  = "#343A46",
  "input-color"         = "#E6E6E6",
  "input-placeholder-color" = "#9AA1AE",
  # Navbar
  "navbar-dark-color"        = "#E6E6E6",
  "navbar-dark-hover-color"  = "#FFFFFF",
  "navbar-dark-active-color" = "#FFFFFF",
  "navbar-dark-brand-color"  = "#FFFFFF",
  "navbar-dark-brand-hover-color" = "#FFFFFF"
) %>%
  bs_add_rules("
    /* Reduce inner padding of ALL bslib value boxes */
    .bslib-value-box > .card-body {
      padding: 0.5rem 0.75rem; /* default is ~1rem */
      
      padding-left: 0 !important;
      padding-right: 0 !important;

    }
    
    
    .bslib-value-box .value-box-area {
      display: flex;
      flex-direction: column-reverse;
    }


    /* Tighten title/value spacing & font sizes with higher specificity */
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
      font-weight: 700;   /* or 'bold' */

    }
    
/* Reactable: simple dark theme with your colours */
.reactable,
.reactable .rt-table {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
  border-radius: 0 !important;
}

/* Header */
.reactable .rt-th {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
}

/* Body cells */
.reactable .rt-td {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
}

/* Stripe rows: even rows get blue */
.reactable .rt-tr:nth-child(even) .rt-td {
  background: #2596be !important;
  color: #2A2F3A !important; /* ensure contrast on the bright blue */
}



.reactable,
.reactable .rt-table,
.reactable .rt-thead,
.reactable .rt-tbody,
.reactable .rt-pagination {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
  border-radius: 0 !important;
}

/* Also ensure the immediate wrapper isn't white */
.reactable .rt-table,
.reactable .rt-table > div {
  background: #2A2F3A !important;
}

/* Header + cells (no inner borders) */
.reactable .rt-th,
.reactable .rt-td {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
}

/* Even stripes */
.reactable .rt-tr:nth-child(even) .rt-td {
  background: #2596be !important;
  color: #2A2F3A !important; /* keep contrast; remove if you prefer cyan text */
}






/* Reduce row font size ONLY, leave headers untouched */
#ArtistReactable .rt-td-inner {
  font-size: 14px !important;   /* adjust size here */
}

/* Optionally tighten spacing (remove if not desired) */
#ArtistReactable .rt-td-inner {
  padding-top: 3px !important;
  padding-bottom: 3px !important;
}


/* 1) Ensure the widget container itself isn't white */
.reactable,
.reactable .rt-table,
.reactable .rt-thead,
.reactable .rt-tbody {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
}

/* 2) The *toolbar row* that holds the search box is still white in your screenshot.
      Hit the common wrapper names AND any direct child wrappers. */
.reactable .rt-toolbar,
.reactable .rt-search,
.reactable .rt-global-filter,
.reactable .ReactTable-toolbar,
.reactable .ReactTable-toolbar > div,
.reactable .rt-toolbar > div,
.reactable .rt-search > div,
.reactable .rt-global-filter > div {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
}

/* 3) Keep the search input themed (you already have this, but keep it here for completeness) */
.reactable .rt-toolbar input,
.reactable .rt-search input,
.reactable .rt-global-filter input {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
}

.reactable .rt-toolbar input::placeholder,
.reactable .rt-search input::placeholder,
.reactable .rt-global-filter input::placeholder {
  color: #828995 !important;
  opacity: 1 !important;
}


/* Kill the white background coming from the React Table root */
.reactable .ReactTable,
.reactable .ReactTable * {
  background: #2A2F3A !important;
  color: #a0dee8 !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
}

/* Hover (optional—kept neutral, can remove if unwanted) */
.reactable .rt-tr:hover .rt-td {
  background: #605ca8 !important;
}


.bslib-value-box {
  border: none !important;
  box-shadow: none !important;
}

/* Mobile: don't force the reactable iframe/container to be tall */
@media (max-width: 768px) {
  /* Make the table container shorter so the plot has room */
  #artisttable, 
  #artisttable .reactable, 
  #artisttable .ReactTable {
    height: 500px !important;   /* try 320–420px */
  }

  /* Give the plot a sensible minimum height */
  #artistplot {
    min-height: 320px !important;
  }
}

.reactable .rt-expander::after {
border-top-color: #a0dee8;

}

  ")


gig_stats_ggplot_theme <- theme(
  axis.text.y = element_text(colour = "#a0dee8",hjust = 1, size = 12, face = "bold", family = "Arial"),
  axis.text.x = element_text(colour = "#a0dee8",size = 12, face = "bold", family = "Arial"),
  plot.background = element_rect(fill = "#2A2F3A", colour = NA),
  panel.background = element_rect(fill = "#2A2F3A"),
  axis.ticks = element_blank(),
  panel.border= element_rect(colour = "#2A2F3A", fill = NA, linewidth = 0.5),
  axis.title.x = element_text(colour = "#a0dee8",face = "bold", family = "Arial"),
  axis.line = element_line(colour = "#a0dee8", linewidth = 0.5, linetype = 1, lineend = "butt"),
  panel.grid.major.y = element_blank(),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.x = element_blank(),
  panel.grid.minor.x = element_blank()
)
