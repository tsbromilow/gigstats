app_theme <- bs_theme(
  version = 5,
  primary = "#6f42c1"
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
  ")