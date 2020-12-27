fluidPage(
      tabsetPanel(id = "goTabSetPanel",
## All genes ##########################################
## BP all #######################
        tabPanel( "All DE genes",          # pestaña All
            #tags$br(),
            tabsetPanel( id = "goAllTabSetPanel", # tabsetpanel all
                tabPanel("Biological Proccess",
                         fluidRow(# primera fila all
                             column(
                                 width = 3,
                                 box(
                                   width = 12,
                                   status = "info",
                                   h3("Voyage Voyage. Desireless"),
                                   p("Au dessus des vieux volcans"),
                                   p("Glissent des ailes sous les tapis du vent"),
                                   p("Voyage, voyage"),
                                   p("Éternellement,..."),
                                   p("De nuages en marécages")
                                 ) #tabbox
                             ),
                             column(
                                 width = 9,
                                 box(
                                     title = "Biological proccess terms",
                                     solidHeader = FALSE,
                                     status = "primary",
                                     width = NULL,
                                     DTOutput("tableBPall")
                                 ) # caja para la tabla
                             )), 
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox( id = "boxPanelBP", width = 12, # caja con pestañas para los plots
                            tabPanel(title = "Barplot",
                                     fluidRow(column(
                                         width = 3,
                                         radioGroupButtons(
                                             inputId = "selectbpall",
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
                                                  plotlyOutput("plotBPall"),
                                                  width = 9
                                              )),
                                     fluidRow(column(width=2,
                                            downloadButton("barBpAll","Download SVG")))
                                     ),  #barplot
                            tabPanel(title = "Dotplot",
                                     plotOutput("BPDotall"),
                                     fluidRow(column(width=2,
                                            downloadButton("dotBpAll","Download SVG")))
                                     ), # dotplot
                            tabPanel(title = "GoBarplot", value = "gobarplotallbp",
                                     plotOutput("gobarplotAllBP"),
                                     fluidRow(column(width=2,
                                            downloadButton("gobarBpAll","Download SVG")))
                                     ),
                            tabPanel(title = "GoCirclePlot", value = "gocirplotallbp",
                                     plotOutput("goCircleAllBP"),
                                     fluidRow(column(width=2,
                                            downloadButton("cirBpAll","Download SVG")))
                                     )
                        )
                    )
            )),
                ### MF all #############################
            #tags$br(),
            tabPanel("Molecular function",  # MF all
             fluidRow(  # primera fila mf all 
                column( width = 3,
                        box(
                          width = 12,
                          status = "info",
                          h3("Voyage Voyage. Desireless"),
                          p("Au dessus des vieux volcans"),
                          p("Glissent des ailes sous les tapis du vent"),
                          p("Voyage, voyage"),
                          p("Éternellement,..."),
                          p("De nuages en marécages")
                        ) #tabbox
                ),
                column( width = 9,
                    box(title = "Molecular function terms",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableMFall")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox( id = "boxPanelMF", width = 12, # caja con pestañas para los plots
                            tabPanel(title = "Barplot",
                                     fluidRow(column(
                                         width = 3,
                                         radioGroupButtons(
                                             inputId = "selectmfall",
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
                                                  plotlyOutput("plotMFall"),
                                                  width = 9
                                              )),
                                     fluidRow(column(width=2,
                                            downloadButton("barMfAll","Download SVG")))
                                     ),  #barplot
                            tabPanel(title = "Dotplot",
                                     plotOutput("MFDotall"),
                                     fluidRow(column(width=2,
                                            downloadButton("dotMfAll","Download SVG")))
                                     ), # dotplot
                            tabPanel(title = "GoBarplot", value = "gobarplotallmf",
                                     plotOutput("gobarplotAllMF"),
                                     fluidRow(column(width=2,
                                            downloadButton("gobarMfAll","Download SVG")))
                                     ),
                            tabPanel(title = "GoCirclePlot", value = "gocirplotallmf",
                                     plotOutput("goCircleAllMF"),
                                     fluidRow(column(width=2,
                                            downloadButton("cirMfAll","Download SVG")))
                            )
                        )
                    )
            )),
                ### CC all #############################
                tabPanel("Cellular component",   ##tab CC all
                fluidRow(  # primera fila all CC
                    column( width = 3,
                            box(
                              width = 12,
                              status = "info",
                              h3("Voyage Voyage. Desireless"),
                              p("Au dessus des vieux volcans"),
                              p("Glissent des ailes sous les tapis du vent"),
                              p("Voyage, voyage"),
                              p("Éternellement,..."),
                              p("De nuages en marécages")
                            ) #tabbox
                    ),
                column( width = 9,
                    box(title = "Cellular component terms",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableCCall")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox(id = "boxPanelCC", width = 12, # caja con pestañas para los plots
                            tabPanel(title = "Barplot",
                                     fluidRow(column(
                                         width = 3,
                                         radioGroupButtons(
                                             inputId = "selectccall",
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
                                                  plotlyOutput("plotCCall"),
                                                  width = 9
                                              )),
                                     fluidRow(column(width=2,
                                            downloadButton("barCcAll","Download SVG")))
                                     ),  #barplot
                            tabPanel(title = "Dotplot",
                                     plotOutput("CCDotall"),
                                     fluidRow(column(width=2,
                                            downloadButton("dotCcAll","Download SVG")))
                                     ), # dotplot
                            tabPanel("GoBarplot", value = "gobarplotallcc", 
                                     plotOutput("gobarplotAllCC"),
                                     fluidRow(column(width=2,
                                            downloadButton("gobarCcAll","Download SVG")))
                                     ),
                            tabPanel( "GoCirclePlot", value="gocirplotallcc",
                                     plotOutput("goCircleAllCC"),
                                     fluidRow(column(width=2,
                                            downloadButton("cirCcAll","Download SVG")))
                            )
                        ) #tabbox
                    ) #column 
            ) #fluidrow
            ) # tabpanel CC 
            ) # tabsetpanel all
        ), #fin tab all genes
###### Upregulated genes #####################################
## BP up #############################
        tabPanel(value = "goUpTab", title = "Upregulated genes",          # pestaña upregulates
            tabsetPanel(  # tabsetpanel up
             tabPanel("Biological Proccess",
            fluidRow(  # primera fila
                column( width = 3,
                        box(
                          width = 12,
                          status = "info",
                          h3("It's my life. Bon Jovi"),
                          p("It's my life"),
                          p("It's now or never"),
                          p("I ain't gonna live forever"),
                          p("I just want to live while I'm alive"),
                          p("My heart is like an open highway...")
                        ) #tabbox
                ),
                column( width = 9,
                    box(title = "Biological proccess terms",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableBP")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                        tabPanel(title = "Barplot",
                                  plotlyOutput("plotBP"),
                                 fluidRow(column(width=2,
                                            downloadButton("barBpUp","Download SVG")))
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("BPDotUp"),
                                 fluidRow(column(width=2,
                                            downloadButton("dotBpUp","Download SVG")))
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotUpBP"),
                                 fluidRow(column(width=2,
                                            downloadButton("gobarBpUp","Download SVG")))
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleUpBP"),
                                 fluidRow(column(width=2,
                                            downloadButton("cirBpUp","Download SVG")))
                                     )
                        )
                    )
            )),
## MF up #############################
tabPanel("Molecular function",
fluidRow(  # primera fila
                column( width = 3,
                        box(
                          width = 12,
                          status = "info",
                          h3("It's my life. Bon Jovi"),
                          p("It's my life"),
                          p("It's now or never"),
                          p("I ain't gonna live forever"),
                          p("I just want to live while I'm alive"),
                          p("My heart is like an open highway...")
                        ) #tabbox
                ),
                column( width = 9,
                    box(title = "Molecular function terms",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableMF")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                        tabPanel(title = "Barplot",
                                  plotlyOutput("plotMF"),
                                 fluidRow(column(width=2,
                                            downloadButton("barMfUp","Download SVG")))
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("MFDotUp"),
                                 fluidRow(column(width=2,
                                            downloadButton("dotMfUp","Download SVG")))
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotUpMF"),
                                 fluidRow(column(width=2,
                                            downloadButton("gobarMfUp","Download SVG")))
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleUpMF"),
                                 fluidRow(column(width=2,
                                            downloadButton("cirMfUp","Download SVG")))
                                     )
                        )
                    )
            )),
## CC up ###################################
        tabPanel("Cellular component",
            fluidRow(  # primera fila
                        column( width = 3,
                                box(
                                  width = 12,
                                  status = "info",
                                  h3("It's my life. Bon Jovi"),
                                  p("It's my life"),
                                  p("It's now or never"),
                                  p("I ain't gonna live forever"),
                                  p("I just want to live while I'm alive"),
                                  p("My heart is like an open highway...")
                                ) #tabbox
                        ),
                        column( width = 9,
                            box(title = "Cellular component terms",
                                solidHeader = FALSE,
                                status = "primary",
                                width = NULL,
                                DTOutput("tableCC")
                            ) # caja para la tabla
                            )
                        ),
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                        tabPanel(title = "Barplot",
                                  plotlyOutput("plotCC"),
                                 fluidRow(column(width=2,
                                            downloadButton("barCcUp","Download SVG")))
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("CCDotUp"),
                                 fluidRow(column(width=2,
                                            downloadButton("dotCcUp","Download SVG")))
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotUpCC"),
                                 fluidRow(column(width=2,
                                            downloadButton("gobarCcUp","Download SVG")))
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleUpCC"),
                                 fluidRow(column(width=2,
                                            downloadButton("cirCcUp","Download SVG")))
                                     )
                            )
                        )
                    )
        ))), #fin tab upregulated genes
## Down regulated genes ############################################
## BP down ##############################
        tabPanel(value = "goDownTab", title = "Downregulated genes",  # pestaña downregulates
            tabsetPanel(
                tabPanel( "Biological proccess",
            fluidRow(  # primera fila
                column( width = 3,
                        box(
                          width = 12,
                          status = "info",
                          h3("I gotta feeling. Black eyed peas"),
                          p("I gotta feeling"),
                          p("That tonight's gonna be a good night"),
                          p("That tonight's gonna be a good night"),
                          p("I just want to live while I'm alive"),
                          p("That tonight's gonna be a good, good night...")
                        ) #tabbox
                ),
                column( width = 9,
                    box(title = "Biological proccess terms",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableBPdown")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                        tabPanel(title = "Barplot",
                                  plotlyOutput("plotBPdown"),
                                 fluidRow(column(width=2,
                                            downloadButton("barBpDown","Download SVG")))
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("BPDotDown"),
                                 fluidRow(column(width=2,
                                            downloadButton("dotBpDown","Download SVG")))
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotDownBP"),
                                 fluidRow(column(width=2,
                                            downloadButton("gobarBpDown","Download SVG")))
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleDownBP"),
                                 fluidRow(column(width=2,
                                            downloadButton("cirBpDown","Download SVG")))
                                     )
                        )
                    )
            )),
## MF down ###################################
        tabPanel( "Molecular function",
            fluidRow(  # primera fila
                column( width = 3,
                        box(
                          width = 12,
                          status = "info",
                          h3("I gotta feeling. Black eyed peas"),
                          p("I gotta feeling"),
                          p("That tonight's gonna be a good night"),
                          p("That tonight's gonna be a good night"),
                          p("I just want to live while I'm alive"),
                          p("That tonight's gonna be a good, good night...")
                        ) #tabbox
                ),
                column( width = 9,
                    box(title = "Molecular functions terms",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableMFdown")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                        tabPanel(title = "Barplot",
                                  plotlyOutput("plotMFdown"),
                                 fluidRow(column(width=2,
                                            downloadButton("barMfDown","Download SVG")))
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("MFDotDown"),
                                 fluidRow(column(width=2,
                                            downloadButton("dotMfDown","Download SVG")))
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotDownMF"),
                                 fluidRow(column(width=2,
                                            downloadButton("gobarMfDown","Download SVG")))
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleDownMF"),
                                 fluidRow(column(width=2,
                                            downloadButton("cirMfDown","Download SVG")))
                                     )
                        )
                    )
            )),
## CC down ###################################
                tabPanel("Cellular component",
                fluidRow(  # primera fila
                column( width = 3,
                        box(
                          width = 12,
                          status = "info",
                          h3("I gotta feeling. Black eyed peas"),
                          p("I gotta feeling"),
                          p("That tonight's gonna be a good night"),
                          p("That tonight's gonna be a good night"),
                          p("I just want to live while I'm alive"),
                          p("That tonight's gonna be a good, good night...")
                        ) #tabbox
                ),
                column( width = 9,
                    box(title = "Cellular component terms",
                        solidHeader = FALSE,
                        status = "primary",
                        width = NULL,
                        DTOutput("tableCCdown")
                    ) # caja para la tabla
                    )
                ),
            fluidRow( # 2 fila
                column( width = 9, offset = 3,
                    tabBox( width = 12, # caja con pestañas para los plots
                        tabPanel(title = "Barplot",
                                  plotlyOutput("plotCCdown"),
                                 fluidRow(column(width=2,
                                            downloadButton("barCcDown","Download SVG")))
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("CCDotDown"),
                                 fluidRow(column(width=2,
                                            downloadButton("dotCcDown","Download SVG")))
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotDownCC"),
                                 fluidRow(column(width=2,
                                            downloadButton("gobarCcDown","Download SVG")))
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleDownCC"),
                                 fluidRow(column(width=2,
                                            downloadButton("cirCcDown","Download SVG")))
                                     )
                        )
                    )
            ))
) # fin tabsetpanel downregulated
        ) #fin tab downrergulated genes
    ) # fin tabsetpanel
)#fin fluidpage