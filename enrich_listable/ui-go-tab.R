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
                                              ))),  #barplot
                            tabPanel(title = "Dotplot",
                                     plotOutput("BPDotall")
                                     ), # dotplot
                            tabPanel(title = "GoBarplot", value = "gobarplotallbp",
                                     plotOutput("gobarplotAllBP")
                                     ),
                            tabPanel(title = "GoCirclePlot", value = "gocirplotallbp",
                                     plotOutput("goCircleAllBP")
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
                                              ))),  #barplot
                            tabPanel(title = "Dotplot",
                                     plotOutput("MFDotall")
                                     ), # dotplot
                            tabPanel(title = "GoBarplot", value = "gobarplotallmf",
                                     plotOutput("gobarplotAllMF")
                                     ),
                            tabPanel(title = "GoCirclePlot", value = "gocirplotallmf",
                                     plotOutput("goCircleAllMF")
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
                                              ))),  #barplot
                            tabPanel(title = "Dotplot",
                                     plotOutput("CCDotall")
                                     ), # dotplot
                            tabPanel("GoBarplot", value = "gobarplotallcc", 
                                     plotOutput("gobarplotAllCC")
                                     ),
                            tabPanel( "GoCirclePlot", value="gocirplotallcc",
                                     plotOutput("goCircleAllCC")
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
                                  plotlyOutput("plotBP")
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("BPDotUp")
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotUpBP")
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleUpBP")
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
                                  plotlyOutput("plotMF")
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("MFDotUp")
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotUpMF")
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleUpMF")
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
                                  plotlyOutput("plotCC")
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("CCDotUp")
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotUpCC")
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleUpCC")
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
                                  plotlyOutput("plotBPdown")
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("BPDotDown")
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotDownBP")
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleDownBP")
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
                                  plotlyOutput("plotMFdown")
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("MFDotDown")
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotDownMF")
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleDownMF")
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
                                  plotlyOutput("plotCCdown")
                                              ),  #barplot
                        tabPanel(title = "Dotplot",
                                 plotOutput("CCDotDown")
                                 ), # dotplot
                        tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotDownCC")
                                     ),
                        tabPanel(title = "GoCirclePlot",
                                     plotOutput("goCircleDownCC")
                                     )
                        )
                    )
            ))
) # fin tabsetpanel downregulated
        ) #fin tab downrergulated genes
    ) # fin tabsetpanel
)#fin fluidpage