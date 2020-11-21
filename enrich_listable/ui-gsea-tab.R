fluidPage(
    h3("Gene Set Enrichment Analysis"),
    fluidRow(
      column(width = 3,
             box(
               width = 12,
               status = "info",
               h3("Losing my religion. REM"),
               p("Oh life, is bigger"),
               p("It's bigger than you"),
               p("And you are not me"),
               p("The lengths that I will go to"),
               p("The distance in your eyes...")
             ) #tabbox
             ),
      column(width = 9,
             box(title = "Table of GSEA pathways",
                 solidHeader = FALSE,
                 status = "primary",
                 width = NULL,
                 bsAlert("gsea"),
                 DTOutput("gseaTable")
                 )
        )
      ),
    fluidRow(column( 
        circleButton(
          inputId = "information21",
          icon = icon("info"),
          size = "xs",
          status = "primary"
        ),
        bsTooltip(
          "information21",
          "Select up to 3 pathways at the same time.",
          trigger = "hover",
          placement = "left"
        ),
        width = 9, offset = 3,
        box(title = "GSEA plot",
            
                  solidHeader = FALSE,
                  status = "primary",
                  width = NULL,
                  bsAlert("gseaPlot"),
                  plotOutput("gseaPlot")
              )
      )
    )
)

