fluidPage(
    tabsetPanel(
        tabPanel( "All DE genes",          # pestaña All #################
            tags$br(),
            fluidRow(  # primera fila
                column( width = 3,
                    box(title = h3("Every breath you take. The Police"),
                        width = "100%",
                        status = "info",
                        p("Every breath you take"),
                        p("Every move you make"),
                        p("Every bond you break"),
                        p("Every step you take"),
                        p("I'll be watching you...")
                    ) # fin caja para el texto
                ),
                column( width = 9,
                    box(title = "Table of pathways",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableAll")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( 
                    circleButton(
                        inputId = "information5",
                        icon = icon("info"),
                        size = "xs",
                        status = "primary"
                    ),
                    bsTooltip(
                        "information5",
                        paste0("Please, select rows with the pathways",
                        " of interest in the table to activate all the plots."),
                        trigger = "hover",
                        placement = "left"
                    ),
                    width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                            tabPanel(title = "Barplot",
                                    fluidRow(column(
                                         width = 3,
                                         radioGroupButtons(
                                             inputId = "selectkeggall",
                                             label = "Select bar plot type",
                                             choices = c("Dodge", "Stack", "Opposite"),
                                             selected = "Dodge",
                                             size = "sm",
                                             status = "primary",
                                             checkIcon = list(
                                                 yes = icon("ok",
                                                            lib = "glyphicon"),
                                                 no = icon("remove",
                                                           lib = "glyphicon")
                                             )
                                         )
                                     )), # fin fluidRow, column & radioGroupButtons
                                     fluidRow(class = "text-center",
                                              column(
                                                  align = "center",
                                                  plotlyOutput("keggPlotAll"),
                                                  width = 9
                                              ))),  #barplot
                        tabPanel(title = "Chordplot",
                                 tagList(fluidRow(column(width = 8,
                                                         chorddiagOutput("keggChordAll",
                                                                         width = "100%",
                                                                         height = "600px") 
                                                         ),
                                                  column(width = 4,
                                                         plotOutput("legendChorAll", width="100%",
                                                                    height="600px")
                                                         )) )
                                 ), #cordplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("keggDotAll")
                                 ), # dotplot
                        tabPanel(title = "Heatmap",
                                 plotlyOutput("heatmapKeggAll", height = "600px")
                                 ), # heatmap
                        tabPanel(title = "Netplot",
                                 column(width = 1,
                                        switchInput(
                                            size = "mini",
                                            inputId = "keggAllNet_switch",
                                            offLabel = "Static",
                                            onLabel = "Interactive"),
                                        plotOutput("legend")
                                        ),
                                 column(width = 11,
                                        uiOutput("keggAllNet")
                                        )
                                 #plotOutput("cnetKeggAll")
                        #          ), # cnetplot
                        # tabPanel(title = "VisNetPlot",
                        #          visNetworkOutput("visnetKeggAll", height = "600px")
                                  ) #visnetall
                        )
                    )
            )
        ), #fin tab all genes ..................##############
        tabPanel( "Upregulated genes",          # pestaña Up ##############
            tags$br(),
            fluidRow(  # primera fila
                column( width = 3,
                    box(title = h3("Shiny happy people. REM"),
                        width = "100%",
                        status = "info",
                        p("Meet me in the crowd, people, people"),
                        p("Throw your love around, love me, love me"),
                        p("Take it into town, happy, happy"),
                        p("Put it in the ground where the flowers grow"),
                        p("Gold and silver shine...")
                    )
                ),
                column( width = 9,
                    box(title = "Table of pathways",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("table")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( 
                    circleButton(
                        inputId = "information6",
                        icon = icon("info"),
                        size = "xs",
                        status = "primary"
                    ),
                    bsTooltip(
                        "information6",
                        paste0("Please, select rows with the pathways of interest ", 
                                "in the table to activate all the plots."),
                        trigger = "hover",
                        placement = "left"
                    ),
                    width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                        tabPanel(title = "Barplot",
                                 plotlyOutput("keggPlot")
                                              ),  #barplot
                        tabPanel(title = "Chordplot",
                                 tagList(fluidRow(
                                     column(
                                         width = 8,
                                         chorddiagOutput("keggChord",
                                                         width = "100%",
                                                         height = "600px")
                                     ),
                                     column(
                                         width = 4,
                                         plotOutput("legendChorUp", 
                                                    width ="100%",
                                                    height ="600px")
                                     )
                                 ))
                                 ), #cordplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("keggDotUp")
                                 ), # dotplot
                        tabPanel(title = "Heatmap",
                                 plotlyOutput("heatmapKeggUp", height = "600px")
                                 ), # heatmap
                        tabPanel(title = "NetplotUp",
                                 column(width = 1,
                                        switchInput(
                                            size = "mini",
                                            inputId = "keggUpNet_switch",
                                            offLabel = "Static",
                                            onLabel = "Interactive")
                                        ),
                                 column(width = 11,
                                        uiOutput("keggUpNet")
                                        )
                                  ) #visnetup
                        )
                    )
            )
        ), #fin tab Up genes ................... #####
        tabPanel( "Downregulated genes",   # pestaña Down ##########
            tags$br(),
            fluidRow(  # primera fila
                column( width = 3,
                    box(title = h3("Walk of life. Dire Straits"),
                        width = "100%",
                        status = "info",
                        p("Here comes Johnny singing oldies, goldies"),
                        p("Be-Bop-A-Lula, Baby What I Say"),
                        p("Here comes Johnny singing, I Gotta Woman"),
                        p("Down in the tunnels, trying to make it pay..."),
                    )
                ),
                column( width = 9,
                    box(title = "Table of pathways",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableDown")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( 
                    circleButton(
                        inputId = "information7",
                        icon = icon("info"),
                        size = "xs",
                        status = "primary"
                    ),
                    bsTooltip(
                        "information7",
                        paste0("Please, select rows with the pathways of interest ",
                                "in the table to activate all the plots."),
                        trigger = "hover",
                        placement = "left"
                    ),
                    width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                        tabPanel(title = "Barplot",
                                 plotlyOutput("keggPlotDown")
                                              ),  #barplot
                        tabPanel(title = "Chordplot",
                                 tagList(fluidRow(
                                     column(
                                         width = 8,
                                         chorddiagOutput("keggChordDown",
                                                         width = "100%",
                                                         height = "600px")
                                     ),
                                     column(
                                         width = 4,
                                         plotOutput("legendChorDown",
                                                    width ="100%",
                                                    height ="600px")
                                     )
                                     ))
                                 ), #cordplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("keggDotDown")
                                 ), # dotplot
                        tabPanel(title = "Heatmap",
                                 plotlyOutput("heatmapKeggDown", height = "600px")
                                 ), # heatmap
                        tabPanel(title = "NetplotDown",
                                 column(width = 1,
                                        switchInput(
                                            size = "mini",
                                            inputId = "keggDownNet_switch",
                                            offLabel = "Static",
                                            onLabel = "Interactive")
                                        ),
                                 column(width = 11,
                                        uiOutput("keggDownNet")
                                        )
                                  ) #cnetplot
                        )
                    )
            )
        ) #fin tab Down genes ............. ####
    ) # fin tabsetpanel
) #fin fluidpage    


