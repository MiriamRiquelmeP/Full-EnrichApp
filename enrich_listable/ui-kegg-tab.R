fluidPage(
   tabsetPanel( id = "keggTabSetPanel",
        tabPanel( "All DEG genes",          # pestaña All #################
            tags$br(),
            fluidRow(  # primera fila
                column( width = 3,
                        box(
                            width = 12,
                            status = "info",
                            h3("I want to break free. Queen"),
                            p("I want to break free from your lies"),
                            p("You're so self satisfied I dont need you"),
                            p("I've got to break free"),
                            p("God knows God knows I want to break free...")
                        ) #tabbox
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
                                     ),
                                     column(width=2, offset = 3, downloadButton("barKeggAll","Download SVG")),
                                     ), # fin fluidRow, column & radioGroupButtons
                                         
                                     fluidRow(class = "text-center",
                                              column(
                                                  width = 9,
                                                  align = "center",
                                                  plotlyOutput("keggPlotAll"),
                                              )
                                              )
                                    ),  #barplot
                        tabPanel(title = "Chordplot",
                                 tagList(fluidRow(column(width = 8,
                                                         mychordplotOutput("chartdiv",
                                                                         width = "100%",
                                                                         height = "600px") 
                                                         ),
                                                  column(width = 4,
                                                         plotOutput("legendChorAll", width="100%",
                                                                    height="600px")
                                                         )) )#,
                                 ), #cordplot
                        tabPanel(title = "Dotplot",
                                 fluidRow(column(width=2,
                                                 downloadButton("dotkeggAll","Download SVG"))),
                                 plotOutput("keggDotAll")
                                 ), # dotplot
                        tabPanel(title = "Heatmap",
                                 fluidRow(column(
                                     width=2,
                                     downloadButton(outputId = "heatKeggAll","Download SVG")
                                 )),
                                 plotlyOutput("heatmapKeggAll", height = "600px")
                                 ), # heatmap
                        tabPanel(title = "Netplot",
                                 column(width = 1,
                                        switchInput(
                                            size = "mini",
                                            inputId = "keggAllNet_switch",
                                            offLabel = "Static",
                                            onLabel = "Interactive"),
                                        plotOutput("legendAll")
                                        ),
                                 column(width = 11,
                                        uiOutput("keggAllNet")
                                        ),
                                  fluidRow(column(
                                     width=2,
                                     downloadButton(outputId = "cnetKeggAll","Download SVG")
                                 ))
                                  ) #visnetall
                        )
                    )
            )
        ), #fin tab all genes ..................##############
        tabPanel(value = "keggUpTab", title = "Upregulated genes",          # pestaña Up ##############
            tags$br(),
            fluidRow(  # primera fila
                column( width = 3,
                        box(
                            width = 12,
                            status = "info",
                            h3("I will survive. Gloria Gaynor"),
                            p("At first I was afraid, I was petrified"),
                            p("Kept thinking I could never live without you by my side"),
                            p("But then I spent so many nights thinking how you did me wrong"),
                            p("And I grew strong"),
                            p("And I learned how to get along...")
                        ) #tabbox
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
                                 fluidRow(column(width=3,
                                                 downloadButton("barKeggUp","Download SVG"))),
                                 plotlyOutput("keggPlot")
                                              ),  #barplot
                        tabPanel(title = "Chordplot",
                                 tagList(fluidRow(
                                     column(
                                         width = 8,
                                         mychordplotOutput("keggChord",
                                                         width = "100%",
                                                         height = "600px")
                                     ),
                                     column(
                                         width = 4,
                                         plotOutput("legendChorUp", 
                                                    width ="100%",
                                                    height ="600px")
                                     )
                                 ))#,
                                # fluidRow(column(
                                #      width=2,
                                #      downloadButton(outputId = "chordKeggUp","Download SVG")
                                #  ))
                                 ), #cordplot
                        tabPanel(title = "Dotplot",
                                    fluidRow(column(width=2,
                                         downloadButton("dotKeggUp","Download SVG"))),
                                 plotOutput("keggDotUp")
                                 ), # dotplot
                        tabPanel(title = "Heatmap",
                                 fluidRow(column(width=2,
                                         downloadButton("heatKeggUp","Download SVG"))),
                                 plotlyOutput("heatmapKeggUp", height = "600px")
                                 ), # heatmap
                        tabPanel(title = "Netplot",
                                 column(width = 1,
                                        switchInput(
                                            size = "mini",
                                            inputId = "keggUpNet_switch",
                                            offLabel = "Static",
                                            onLabel = "Interactive"),
                                        plotOutput("legendUp")
                                        ),
                                 column(width = 11,
                                        uiOutput("keggUpNet"),
                                        fluidRow(column(width=2,
                                            downloadButton("cnetkeggUp","Download SVG"))),
                                        )
                                  ) #visnetup
                        )
                    )
            )
        ), #fin tab Up genes ................... #####
        tabPanel(value = "keggDownTab", title = "Downregulated genes",   # pestaña Down ##########
            tags$br(),
            fluidRow(  # primera fila
                column( width = 3,
                        box(
                            width = 12,
                            status = "info",
                            h3("Take on me. A-ha"),
                            p("We're talking away"),
                            p("I don't know what"),
                            p("I'm to say I'll say it anyway"),
                            p("Today's another day to find you"),
                            p("Shying away...")
                        ) #tabbox
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
                                 fluidRow(column(width=3,
                                    downloadButton("barKeggDown","Download SVG"))),
                                 plotlyOutput("keggPlotDown")
                                              ),  #barplot
                        tabPanel(title = "Chordplot",
                                 tagList(fluidRow(
                                     column(
                                         width = 8,
                                         mychordplotOutput("keggChordDown",
                                                         width = "100%",
                                                         height = "600px")
                                     ),
                                     column(
                                         width = 4,
                                         plotOutput("legendChorDown",
                                                    width ="100%",
                                                    height ="600px")
                                     )
                                     ))#,
                                 #    fluidRow(column(
                                 #     width=2,
                                 #     downloadButton(outputId = "chordKeggDown","Download SVG")
                                 # ))
                                 ), #cordplot
                        tabPanel(title = "Dotplot",
                                 fluidRow(column(width=2,
                                            downloadButton("dotKeggDown","Download SVG"))),
                                 plotOutput("keggDotDown"),
                                 ), # dotplot
                        tabPanel(title = "Heatmap",
                                 fluidRow(column(width=2,
                                            downloadButton("heatKeggDown","Download SVG"))),
                                 plotlyOutput("heatmapKeggDown", height = "600px")
                                 ), # heatmap
                        tabPanel(title = "Netplot",
                                 column(width = 1,
                                        switchInput(
                                            size = "mini",
                                            inputId = "keggDownNet_switch",
                                            offLabel = "Static",
                                            onLabel = "Interactive"),
                                        plotOutput("legendDown")
                                        ),
                                 column(width = 11,
                                        uiOutput("keggDownNet"),
                                        fluidRow(column(width=2,
                                            downloadButton("cnetkeggDown","Download SVG"))),
                                        )
                                  ) #visnetup
                        )
                    )
            )
        ) #fin tab Down genes ............. ####
    ) # fin tabsetpanel
) #fin fluidpage    


