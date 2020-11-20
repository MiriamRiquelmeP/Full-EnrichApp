fluidPage(
      tabsetPanel(
## All genes ##########################################
## BP all #######################
        tabPanel( "All DE genes",          # pestaña All
            #tags$br(),
            tabsetPanel(  # tabsetpanel all
                tabPanel("Biological Proccess",
                         fluidRow(# primera fila all
                             column(
                                 width = 3,
                                  box(title = h3("Masters of war. Bob Dylan"),
                                      width = "100%",
                                      status = "info",
                                      p("Masters of war"),
                                      p("Build to destroy"),
                                      p("You play with my world"),
                                      p("Like it's your little toy"),
                                      p("All the money you made will never buy back your soul...")
                                  )
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
                    tabBox( width = 12, # caja con pestañas para los plots
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
                            tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotAllBP")
                                     ),
                            tabPanel(title = "GoCirclePlot",
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
                          title = h3("Masters of war. Bob Dylan"),
                          width = "100%",
                          status = "info",
                          p("Masters of war"),
                          p("Build to destroy"),
                          p("You play with my world"),
                          p("Like it's your little toy"),
                          p("All the money you made will never buy back your soul...")
                        )
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
                    tabBox( width = 12, # caja con pestañas para los plots
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
                            tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotAllMF")
                                     ),
                            tabPanel(title = "GoCirclePlot",
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
                              title = h3("Masters of war. Bob Dylan"),
                              width = "100%",
                              status = "info",
                              p("Masters of war"),
                              p("Build to destroy"),
                              p("You play with my world"),
                              p("Like it's your little toy"),
                              p("All the money you made will never buy back your soul...")
                            )
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
                    tabBox( width = 12, # caja con pestañas para los plots
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
                            tabPanel(title = "GoBarplot",
                                     plotOutput("gobarplotAllCC")
                                     ),
                            tabPanel(title = "GoCirclePlot",
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
        tabPanel( "Upregulated genes",          # pestaña upregulates
            tabsetPanel(  # tabsetpanel up
             tabPanel("Biological Proccess",
            fluidRow(  # primera fila
                column( width = 3,
                        box(
                          title = h3("The final countdown. Europe"),
                          width = "100%",
                          status = "info",
                          p("We're leavin' together"),
                          p("But still it's farewell"),
                          p("And maybe we'll come back"),
                          p("To Earth, who can tell?"),
                          p("I guess there is no one to blame...")
                        )
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
                          title = h3("The final countdown. Europe"),
                          width = "100%",
                          status = "info",
                          p("We're leavin' together"),
                          p("But still it's farewell"),
                          p("And maybe we'll come back"),
                          p("To Earth, who can tell?"),
                          p("I guess there is no one to blame...")
                        )
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
                                  title = h3("The final countdown. Europe"),
                                  width = "100%",
                                  status = "info",
                                  p("We're leavin' together"),
                                  p("But still it's farewell"),
                                  p("And maybe we'll come back"),
                                  p("To Earth, who can tell?"),
                                  p("I guess there is no one to blame...")
                                )
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
        tabPanel( "Downregulated genes",          # pestaña downregulates
            tabsetPanel(
                tabPanel( "Biological proccess",
            fluidRow(  # primera fila
                column( width = 3,
                        box(
                          title = h3("All that she wants. Ace of base"),
                          width = "100%",
                          status = "info",
                          p("When she woke up late in the morning light"),
                          p("And the day had just begun"),
                          p("She opened up her eyes and thought"),
                          p("Oh, what a morning"),
                          p("It's not a day for work...")
                        )
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
                          title = h3("All that she wants. Ace of base"),
                          width = "100%",
                          status = "info",
                          p("When she woke up late in the morning light"),
                          p("And the day had just begun"),
                          p("She opened up her eyes and thought"),
                          p("Oh, what a morning"),
                          p("It's not a day for work...")
                        )
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
                          title = h3("All that she wants. Ace of base"),
                          width = "100%",
                          status = "info",
                          p("When she woke up late in the morning light"),
                          p("And the day had just begun"),
                          p("She opened up her eyes and thought"),
                          p("Oh, what a morning"),
                          p("It's not a day for work...")
                        )
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