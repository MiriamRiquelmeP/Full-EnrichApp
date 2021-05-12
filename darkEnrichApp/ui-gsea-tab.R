fluidPage(
    h3("Gene Set Enrichment Analysis"),
    fluidRow(
      column(width = 3,
             box(
               title = "",
               width = 12,
               status = "info",
               uiOutput("gseaSelectize")
             )
             ),
      column(width = 9,
             box(title = "Table of GSEA pathways",
                 solidHeader = FALSE,
                 status = "primary",
                 width = NULL,
                 bsAlert("gsea"),
                 DTOutput("gseaTable"),
                 actionButton("resetgseaTable","Clear selection")
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
                  plotOutput("gseaPlot"),
            fluidRow(column(width = 2,
                            downloadButton("gseaButton","Download SVG") ))
              )
      )
    )
)

