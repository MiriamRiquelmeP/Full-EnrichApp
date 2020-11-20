fluidPage(
    h3("Gene Set Enrichment Analysis"),
    fluidRow(
      column(width = 3,
             box(
               title = h3("Always. Bon Jovi"),
               width = "100%",
               status = "info",
               p("...And I will love you, baby, always"),
               p("And I'll be there forever and a day, always"),
               p("I'll be there 'til the stars don't shine"),
               p("Till the heavens burst and the words don't rhyme"),
               p("I know when I die, you'll be on my mind...")
             )
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

