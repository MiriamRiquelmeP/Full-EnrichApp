library(shinydashboard)
library(AnnotationDbi)
library(org.Mm.eg.db) #Mus musculus
library(org.Hs.eg.db) #Homo sapiens
#library(org.Dr.eg.db) #Danio rerio (zebra fish)
library(org.Rn.eg.db) #Rattus norvegicus
#library(org.Mmu.eg.db) #Macaca mulata
library(chorddiag)
library(EnsDb.Mmusculus.v79)
library(EnsDb.Hsapiens.v86)
library(EnsDb.Rnorvegicus.v79)
library(limma)
library(tidyverse)
library(DT)
library(RColorBrewer)
library(purrr)
library(plotly)
library(ggpubr)
library(DESeq2)
library(fgsea)
library(shinyalert)
library(shinyBS)
library(shinyWidgets)
library(shinydashboardPlus)
library(pheatmap)
library(heatmaply)
library(shinyjs)
library(shinythemes)
library(rgl)
library(rglwidget)
library(scales)
library(stringr)
library(shinybusy)
library(visNetwork)
library(ggrepel)
library(circlize)
library(mychordplot)
library(ggwordcloud)
library(wordcloud2)
library(randomcoloR)
library(tidytext)
source("global.R")
source("UpdatepopModals.R")
source("utils.R")
options(shiny.maxRequestSize = 3000*1024^2)


### HEADER ############ 
header <- dashboardHeader(title = "Gene list enrichment", 
                          titleWidth = 300, 
                          dropdownMenuOutput("messageMenu"),
                          tags$li(class="dropdown", actionButton("moreinfo","Tutorial",
                                                                 style = "background-color: #8ec4d9"),
                                  style="margin-top:8px; margin-right: 5px"),
                          tags$li(class="dropdown", actionButton("notesButton","Notes"),
                                  style="margin-top:8px; margin-right: 5px"),
                          tags$li(class = "dropdown", actionButton("aboutButton", "About"),
                                  style="margin-top:8px; margin-right: 15px"),
                          tags$li(class = "dropdown", actionBttn(inputId = "resetbutton",
                                                                 label = "Reset App", style="simple", size="sm",
                                                                 color ="danger"),
                                  style="margin-top:8px; margin-right: 10px"
                          )
                          )
### SIDEBAR ##########
sidebar <- dashboardSidebar(useShinyalert(),
                            useShinyjs(),
                            sidebarMenu(
                              menuItem(
                              "App Information",
                              tabName = "info",
                              icon = icon("info")
                            )),
                            sidebarMenu(
                                menuItem(
                                    pickerInput(
                                        inputId = "specie",
                                        label = "Select species",
                                        choices = list( "Human" = "Hs", "Mouse" = "Mm"),
                                        options = list(title = "species"),
                                        selected = "Mm"
                                    ) 
                                ),
                                menuItem(
                                  pickerInput(
                                    inputId = "annotation",
                                    label = "Select annotation gene",
                                    choices = list("Ensembl" = "ensg", "Symbol"="symbol"),
                                    options = list(title="annotation"),
                                    selected = "ensg"
                                  )
                                ),
                                sidebarMenu("", sidebarMenuOutput("prevw")),
                                sidebarMenu("", sidebarMenuOutput("menuKegg")),
                                sidebarMenu("", sidebarMenuOutput("menuGO")),
                                sidebarMenu("", sidebarMenuOutput("menuGSEA"))
                            ),
                            tags$div(
                              box(width = 12,
                                h5(strong("Generate report"), align = 'center'),
                                sidebarMenu( 
                                  menuItem(
                                    fluidRow(column(12, align = "center", offset=0,
                                                    uiOutput("report")))))
                            ),
                            tags$a(href='https://jacob.cea.fr/drf/ifrancoisjacob/Pages/Departements/MIRCen/themes/astrocytes-reactifs-biomarqueurs-imagerie-cibles-therapeutiques.aspx', target="_blank",
                                   tags$img(src='mircen.png',width='50%',
                                            style="padding: 5px; position: absolute; bottom:10px; left:0") ),
                            tags$a(href='http://www.bioinformatica.imib.es', target="_blank",
                                   tags$img(src='imib.png',width='50%',
                                            style="padding: 5px; float: right;") ),
                            
                            style = "position: absolute; bottom:0;width:100%;"
                            ) #fin div
                            ) # fin sideDashBoard

### BODY ###############
body <- dashboardBody(
      tags$script(HTML("$('body').addClass('fixed');")),
      add_busy_gif(src="dna-mini.gif", position = "full-page", width = 10, height = 10 ),
     #htmltools::includeCSS("./www/customDark.css"),
      #tags$head(
        #HTML("<link rel = 'stylesheet' type = 'text/css' href = 'customDark.css'>"),
      #),
    setShadow(class = "shiny-plot-output"),
    setShadow( class = "box"),
    setShadow( class = "svg-container"),
    tags$head(
      HTML("<link rel = 'stylesheet' type = 'text/css' href = 'customDark.css'>"),
      tags$style(HTML(".irs-min, .irs-max {
              color: rgb(215,215,215) !important;
              background-color: rgb(45,55,65) !important;
          }"))
      ),
  bsAlert("alert"),
  tabItems(
    # Initial INFO
    tabItem(tabName = "info",
            fluidRow(column(width = 4,
              box(width=12, 
                  uiOutput(outputId = "geneList"), 
                  uiOutput(outputId = "geneFile"),
                  uiOutput(outputId = "geneButton")
                  ),
              box(width=12,
                  dataTableOutput(outputId = "table1col"))
              ),
            column(width = 8,
            box(width=12,
                status = "info",
                title = h1(strong("Welcome to Enrich app 2020!") ),
            h3("Before starting using the app"),
            p("As a necessary initial element to start the analysis, 
                the program imports an object of the type DeseqDataSet, 
                generated by the DESeq function of the", 
              a("DESeq2", href="https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html"),
              "library. It has to be compress as an RDS object and upload 
                by clicking on the search engine button found in the upper left 
                corner of the app. Choose your object and enjoy your enrichment analysis ;)"),
            br(),
            h3("Get the app ready to use!"),
            p("First of all, select the species of your experiment. 
              Then the option to enter your RDS object containing your 
              analysis will be unlocked. Upload it and wait for the loading 
              to be completed. When the loading symbol stops moving, 
              you can proceed to the next tab! "
              ),
            br(),
            p("Take advantage of every symbol of info" , icon("info-circle"), "that you might find.
              It can provide you with information that may be useful for 
              the proper functioning of the app. "
            ),
            br(),
            h3("How to download the app"),
            p("This app can be found on ",
              a("GitHub.", 
                href = "https://github.com/"))),
            uiOutput("enrichbutton")
            )
            )
    ),
    # preview tab
    tabItem(tabName = "preview",
            source(file = "ui-preview-tab.R",
            local=TRUE,
            encoding = "UTF-8"
            )$value),
    # kegg tab content
    tabItem(tabName = "kegg",
            source(file = "ui-kegg-tab.R",
                   local = TRUE,
                   encoding = "UTF-8"
                   )$value),
    # GO tab GO tab
    tabItem( tabName = "go",
             source(file = "ui-go-tab.R",
                    local = TRUE,
                    encoding = "UTF-8",
                    )$value),
    # GSEA tab
    tabItem( tabName = "gsea",
             source(file = "ui-gsea-tab.R",
                    local = TRUE,
                    encoding = "UTF-8",
                    )$value)
  ), # fin tab items
    bsModal("modalNotes", "Notes", "notesButton",size="large",
          textAreaInput("textNotes", "Text Notes", width = "850px", height = "575px"))
)# fin dashboardbody

########################################## UI #################################################

ui <- dashboardPage(title="Rnaseq viewer and report",
                    header,
                    sidebar,
                    body
) # fin del UI

########################################## SERVER #################################################
server <- function(input, output, session) {
  
    enrichflag=NULL
    
    observeEvent(input$aboutButton, {
          shinyalert("Enrich app 2020", HTML("Authors:<br>
      Miriam Riquelme Pérez 
      <a href='https://www.linkedin.com/in/miriam-riquelme-perez/' target='_blank'> 
      <img src='linkedin_little.svg'> </a> <a href='mailto:miriam.riquelmep@gmail.com'>
      <img src='email.svg'></a><br>
      Fernando Pérez Sanz 
      <a href='https://www.linkedin.com/in/fernandoperez72/' target='_blank'> 
      <img src='linkedin_little.svg'> 
      </a> <a href='mailto:fernando.perez@ffis.es'> <img src='email.svg'></a><br>
      For any suggestion or bug, please contact us"),
                 imageUrl = "dna-svg-small-13.gif",
                 imageWidth = 200, imageHeight = 100, html=TRUE)})
  
    observeEvent(input$resetbutton,{
      session$reload()
    })
    
  observeEvent(input$moreinfo,{
    showModal(
      modalDialog(
        size="l",
        #tags$iframe(src="https://155.54.120.105/shiny/enrich_listable/pres1.html",  width="850px", height="700px")
        tags$iframe(src="pres1.html",  width="850px", height="700px")
      )
    )
  })
  
  
  
  # variables reactivas ######
  annotation <- reactive({input$annotation})
  data <- reactiveValues(df=NULL, dfilt=NULL)
  df3cols <- reactiveValues(TF=FALSE)
  enrichflag <- reactiveValues(one=NULL, three=NULL)
  fc_switch <- reactive({input$fc_switch})
  fcRange <- reactiveValues() # min y max fc
  go <- reactiveValues(all=NULL)
  goDT <- reactiveValues(all=NULL)
  gene <- reactiveValues(lost=NULL)
  genes <- reactiveValues()
  genesVolcano <- reactive({input$genesVolcano})
  gsea <- reactiveValues(gsea=NULL)
  kgg <- reactiveValues(all=NULL)
  kggDT <- reactiveValues(all=NULL)
  logfcRange <- reactiveValues() # min y max logfc
  numgenesDE <- reactiveValues(up=NULL, down=NULL)
  specie <- reactive({input$specie})
  typeBarKeggAll <- reactive({input$selectkeggall})
  validatedGene <- reactiveValues(list=NULL)
  vals <- reactiveValues()
  svg <- reactiveValues()
  ## Leer data ##########################
  observeEvent(input$geneButton,{
    # comprobaciones listado manual
    if( !is.null(input$geneList)){
      if(input$geneList!="" ){
        if (annotation() == "ensg") {
          if (length(which(grepl("^ENS", input$geneList, ignore.case = TRUE))) <
              length(input$geneList)  ) {
            shinyalert("Oops!!", "One or more genes are not 
            in ENSEMBL format",
                       type = "error")
          } else{
            validatedGene$list <- validateGeneList(input$geneList, specie(), annotation() )
            data$df <- formatData( validatedGene$list, specie(), annotation() )
            # lost <- which(is.na(data$df$ENTREZID))
            # gene$lost <- data$df$ENSEMBL[lost]
            # if(length(lost)!=0){ data$df <- data$df[-lost, ] }
            data$df$SYMBOL <- ifelse(is.na(data$df$SYMBOL), data$df$ENSEMBL, data$df$SYMBOL )
            }
        }
        if (annotation() == "symbol") {
          if (length(which(grepl("^ENS", input$geneList, ignore.case = TRUE))) ==  length(input$geneList) ) {
            shinyalert("Oops!!", "Looks like this entry is 
                       ENSEMBL please check your selection", 
                       type = "error")
          } else{
            validatedGene$list <- validateGeneList(input$geneList, specie(), annotation() )
            data$df <- formatData( validatedGene$list, specie(), annotation() )
            # lost <- which(is.na(data$df$ENTREZID))
            # gene$lost <- data$df$SYMBOL[lost]
            # if(length(lost)!=0){ data$df <- data$df[-lost, ] }
          }
          }
        }
      }
    ## comprobaciones cargar fichero
    if(!is.null(input$geneFile$datapath)){
      if(input$geneFile$datapath != "" ){
        validatedGene$list <- as.data.frame( readxl::read_xlsx(input$geneFile$datapath, sheet = 1))
        if (annotation() == "ensg") {
          if(length(which(grepl("^ENS", validatedGene$list[,1], ignore.case = TRUE))) < nrow(validatedGene$list) ) {
            shinyalert("Oops!!", "One or more genes are not 
            in ENSEMBL format",
                       type = "error" )
          } else{
                data$df <- formatData( validatedGene$list, specie(), annotation() )
                # lost <- which(is.na(data$df$ENTREZID))
                # gene$lost <- data$df$ENSEMBL[lost]
                # if(length(lost)!=0){ data$df <- data$df[-lost, ] }
                data$df$SYMBOL <- ifelse(is.na(data$df$SYMBOL), data$df$ENSEMBL, data$df$SYMBOL )
          }
        }
        if (annotation() == "symbol") {
          if (length(which(grepl("^ENS", validatedGene$list[,1], ignore.case = TRUE))) ==  nrow(validatedGene$list)) {
            shinyalert("Oops!!", "Looks like this entry is 
                       ENSEMBL please check your selection", 
                       type = "error" )
          } else{
                data$df <- formatData( validatedGene$list, specie(), annotation() )
                # lost <- which(is.na(data$df$ENTREZID))
                # gene$lost <- data$df$SYMBOL[lost]
                # if(length(lost)!=0){ data$df <- data$df[-lost, ] }
          }
        }
      }
    }
    if( dim(data$df)[2]==5 ){
      if( length( which(data$df$logFC > 0)) == 0 | length( which(data$df$logFC < 0)) ==0){
        shinyalert("Warning", "It seems that the data do not have both up and down regulated genes.
                   It will be considered as a simple gene list.", 
                       type = "warning")
        df3cols$TF <- FALSE
        data$df <- data$df %>% select(-logFC, -pval)
      }else{
        df3cols$TF <- TRUE
        logfcRange$min <- min(data$df$logFC)
        logfcRange$max <- max(data$df$logFC)
        fcRange$min <- ifelse(logfcRange$min<0, -(2^abs(logfcRange$min)), 2^abs(logfcRange$min))
        fcRange$max <- ifelse(logfcRange$max<0, -(2^abs(logfcRange$max)), 2^abs(logfcRange$max))
      }}
  })
  
  ## Pulsar Enrich Button para listado simple ##################################
  observeEvent(input$enrichButtons,{
    if( dim(data$df)[2]==3 ){
      lost <- which(is.na(data$df$ENTREZID))
      gene$lost <- data$df$SYMBOL[lost]
      if(length(lost)!=0){ data$dfilt <- data$df[-lost, ] }else{data$dfilt <- data$df}
      kgg$all <- customKegg(data$dfilt[,c("SYMBOL","ENTREZID") ], species = specie() )
      kggDT$all <- kegg2DT(kgg$all, data$dfilt[,c("SYMBOL","ENTREZID") ] )
      go$all <- customGO(data$dfilt[,c("SYMBOL","ENTREZID") ], species = "Mm")
      goDT$all <- go2DT(enrichdf = go$all, data = data$dfilt[,c("SYMBOL","ENTREZID") ] )
      enrichflag$one <- TRUE
      hideTab(inputId = "keggTabSetPanel", target = "keggDownTab")
      hideTab(inputId = "keggTabSetPanel", target = "keggUpTab")
      hideTab(inputId = "goTabSetPanel", target = "goUpTab")
      hideTab(inputId = "goTabSetPanel", target = "goDownTab")
      hideTab(inputId = "boxPanelBP", target = "gobarplotallbp")
      hideTab(inputId = "boxPanelMF", target = "gobarplotallmf")
      hideTab(inputId = "boxPanelCC", target = "gobarplotallcc")
      hideTab(inputId = "boxPanelBP", target = "gocirplotallbp")
      hideTab(inputId = "boxPanelMF", target = "gocirplotallmf")
      hideTab(inputId = "boxPanelCC", target = "gocirplotallcc")
    }  
    })
  ## Pulsar Enrich Button para listado 3 columnas ##################################
  observeEvent(input$enrichButton,{
    if( dim(data$df)[2]==5 ){
      lost <- which(is.na(data$df$ENTREZID))
      gene$lost <- data$df$SYMBOL[lost]
      if(length(lost)!=0){ data$dfilt <- data$df[-lost, ] }else{data$dfilt <- data$df}
      genes$Up <- data$dfilt[data$dfilt$logFC >= logfc()[2] & data$dfilt$pval <= padj(),
                          c("SYMBOL","ENTREZID")]
      genes$Down <- data$dfilt[data$dfilt$logFC <= logfc()[1] & data$dfilt$pval <= padj(),
                          c("SYMBOL","ENTREZID")]
      genes$all <- rbind(genes$Up, genes$Down)
      kgg$all <- customKegg(genes$all, species = specie() ) #"Mm"), species.KEGG = "mmu")
      kggDT$all <- kegg2DT(kgg$all, genes$all)
      kgg$up <- customKegg(genes$Up, species = specie() ) #"Mm")#, species.KEGG = "mmu")
      kggDT$up <- kegg2DT(kgg$up, genes$Up)
      kgg$down <- customKegg(genes$Down, species = specie() ) # "Mm")#, species.KEGG = "mmu")
      kggDT$down <- kegg2DT(kgg$down, genes$Down)
      go$all <- customGO(genes$all, species = "Mm")
      goDT$all <- go2DT(enrichdf = go$all, data = genes$all )
      go$up <- customGO(genes$Up, species = "Mm")
      goDT$up <- go2DT(enrichdf = go$up, data = genes$Up )
      go$down <- customGO(genes$Down, species = "Mm")
      goDT$down <- go2DT(enrichdf = go$down, data = genes$Down )
      gsea$gsea <- gseaKegg(data$dfilt[, c("ENTREZID","logFC")], specie() )
      enrichflag$three <- TRUE
      updateTabItems(session, "previewMenu", "preview")

    }
  })
## ........................ #####################
##datatable preview 1 columna #####################
  output$table1col <- DT::renderDT(server = FALSE,{
  shiny::validate(need(data$df, ""))
    shiny::validate(need( dim(data$df)[2]==3,"")) 
  customButtons <- list(
        list(extend = "copy", title="Preview table"),
        list(extend="collection", buttons = c("csv", "excel"),
             text="Download", filename="coldata", title="Preview table" ) )
    
    datatable( data$df, extensions = "Buttons",
               rownames=FALSE,
               filter = list(position="top", clear=FALSE),
               options = list(
                 dom = "Bfrtipl",
                 lengthMenu = list(c(10,25,50,100,-1), c(10,25,50,100,"All")),
                  columnDefs = list(list(orderable = TRUE,
                                        className = "details-control",
                                        targets = 1)),
                 buttons = customButtons,
                 list(pageLength = 10, white_space = "normal")
               )
    )
  })
## Cosas a renderizar en preview si dflist 3 columns ##################
  ## sidebar menu preview ###################
  output$prevw <- renderMenu({
      shiny::validate(need(isTRUE(df3cols$TF), ""))
      sidebarMenu(id = "previewMenu",
          menuItem(
              "Preview",
              tabName = "preview",
              icon = icon("chart-bar")
          )
          )
          })
  
  ## Gene List ####################
  output$geneList <- renderUI({
    shiny::validate(need(specie(),""))
    shiny::validate(need(annotation(),""))
    textAreaInput(inputId = "geneList", label = "Input simple gene list ...", resize = "vertical")
  })
  
  ## Gene File #####################
  output$geneFile <- renderUI({
    shiny::validate(need(specie(),""))
    shiny::validate(need(annotation(),""))
    fileInput(inputId = "geneFile", label="...or upload file with gene list")
  })
  ## Boton validar ###############
  output$geneButton <- renderUI({
    shiny::validate(need(specie(),""))
    shiny::validate(need(annotation(),""))
    actionButton("geneButton", label = "Click to validate data")
  })
  ## boton enrich #########################
  output$enrichbutton <- renderUI({
    shiny::validate(need(data$df, ""))
    shiny::validate(need(!isTRUE(df3cols$TF), ""))
    actionBttn("enrichButtons", label = "Click to run enrichment", size="lg", color="default", icon = icon("images"))
  })
  

## sidebar menu kegg ###################
  output$menuKegg <- renderMenu({
      shiny::validate(need(kgg$all, ""))
      sidebarMenu(
          menuItem(
              "Kegg Enrichment",
              tabName = "kegg",
              icon = icon("chart-bar")
          )
          )
        })
    
    # Acciones al pulsar applyButton ################
  padjVal <- reactiveValues(val=0.05)
  fcVal <- reactiveValues( val=c(-1.5, 1.5) )
  logfcVal <- reactiveValues(val=c(-0.5,0.5))
  padj <- reactive({padjVal$val})
  logfc <- reactive({logfcVal$val})
  fc <- reactive({fcVal$val})
  
  observeEvent(input$applyParam,{
      padjVal$val <- input$padj
      if( isTRUE( fc_switch()) ){
        logfcTmp <- vector()
        fcVal$val <-input$fc
        logfcTmp[1] <- ifelse(fc()[1]<0, -log2(abs(fc()[1])), log2(abs(fc()[1])) )
        logfcTmp[2] <- ifelse(fc()[2]<0, -log2(abs(fc()[2])), log2(abs(fc()[2])) )
      } else {
        logfcTmp <- input$logfc
      }
      if(logfcTmp[1]==logfcTmp[2]){
          logfcVal$val <- c(0,0)
          }else{
            logfcVal$val <- logfcTmp
          }
    })
  
      
  ## side menubar GO #########################
      output$menuGO <- renderMenu({
      shiny::validate(need(go$all,""))
      sidebarMenu(  
        menuItem(
              "GO Enrichment",
              tabName = "go",
              icon = icon("chart-bar")
          )
        )
      })
  ## sidebar menu GSEA #####################333
  output$menuGSEA <- renderMenu({
      shiny::validate(need(gsea$gsea,""))
      sidebarMenu(  
          menuItem("GSEA",
                   tabName = "gsea",
                   icon = icon("chart-line"))
        )
      })
    # ui selector de genes para volcano plot #######################
  output$geneSelector <- renderUI({
    shiny::validate(need(data$df, ""))
    genes <- as.character(data$df$SYMBOL[ which(!( data$df$pval>padj() &
                                                             data$df$logFC>logfc()[1] &
                                                             data$df$logFC<logfc()[2] )) ])
    selectInput("genesVolcano", label="Select gene[s] to label",
                choices = genes,
                multiple = TRUE)
  })
  
  # Deslizador fc/logfc según switch #################
  output$fc_control <- renderUI({
    if(isTRUE(fc_switch())){
      shiny::validate(need(data$df, ""))
      valmin <- ifelse(input$logfc[1]<0, -2^(abs(input$logfc[1] )), 2^(abs(input$logfc[1])) )
      valmax <- ifelse(input$logfc[2]<0, -2^(abs(input$logfc[2] )), 2^(abs(input$logfc[2])) )
      sliderInput("fc", label = "Select FC range to remove (keeps the tails)",
                  min=round(fcRange$min,3), max=round(fcRange$max, 3),
                  value = c(valmin, valmax), step = 0.1 )
    } else {
      shiny::validate(need(data$df, ""))
      shiny::validate(need(fc(), ""))
        if(is.null(input$fc[1]) ){
          valmin = -0.5
          valmax = 0.5
        } else{
          valmin <- ifelse(input$fc[1]<0, -log2(abs(input$fc[1] )), log2(abs(input$fc[1])) )
          valmax <- ifelse(input$fc[2]<0, -log2(abs(input$fc[2] )), log2(abs(input$fc[2])) )
      }
      sliderInput("logfc", label = "Select logFC range to remove (keeps the tails)",
                min=round(logfcRange$min,3), max=round(logfcRange$max, 3),
                value = c(valmin, valmax), 
                step = 0.1 )
    }
  })
    # ui selector padj #################################
  output$padj <- renderUI({
    shiny::validate(need(data$df,""))
    sliderInput("padj", label = "Select p-adjusted threshold", min = 0, max=0.2,
                value=0.05, step = 0.005 )
  })
  
    # infoboxes ###############################
  output$allbox <- renderInfoBox({
      shiny::validate(need(data$df, ""))
      shiny::validate(need(padj(), ""))
      shiny::validate(need(logfc(), ""))
      numall <- nrow( data$df[ ((data$df$logFC >= logfc()[2] |
                                    data$df$logFC< logfc()[1]) &
                                   data$df$pval <= padj() ),] ) 
      infoBox("All DE genes", numall, icon = icon("arrows-alt-v"), color = "light-blue", fill = TRUE)
  })
  output$upbox <- renderInfoBox({
      shiny::validate(need(data$df, ""))
      shiny::validate(need(padj(), ""))
      shiny::validate(need(logfc(), ""))
      numup <- nrow( data$df[(data$df$logFC >= logfc()[2]) & (data$df$pval <= padj()), ]) 
      numgenesDE$up <- numup
      infoBox("Upregulated genes", numup, icon = icon("thumbs-up", lib = "glyphicon"), color = "light-blue", fill=TRUE)
  })
  output$downbox <- renderInfoBox({
      shiny::validate(need(data$df, ""))
      shiny::validate(need(padj(), ""))
      shiny::validate(need(logfc(), ""))
      numdown <- nrow( data$df[(data$df$logFC <= logfc()[1]) & (data$df$pval <= padj()), ])
      numgenesDE$down <- numdown
      infoBox("Downregulated genes", numdown, icon = icon("thumbs-down", lib = "glyphicon"), color = "light-blue", fill=TRUE)
  })
  
  output$fcdown <- renderUI({
        shiny::validate(need(logfcRange$min, ""))
        shiny::validate(need(logfc(),""))
        initMin <- round( logfcRange$min, 2)
        initMax <- round( logfcRange$max, 2)
        if(logfc()[1]>=0){
            fgColor="#6baed6"
            inputColor="white"
            bgColor ="#46505a"
            rotation="clockwise"
            min=0
            max=initMax
            angleOffset = 0
        }else{
            fgColor="#46505a"
            inputColor="white"
            bgColor ="#e6550d"
            rotation="clockwise"
            min=initMin
            max=0
            angleOffset=180
        }
      knobInput(
          inputId = "myKnobdown",
          label = "Lower logFC cutoff",
          value = round(logfc()[1],2),
          min = min,
          max=max,
          rotation=rotation,
          displayPrevious = TRUE,
          fgColor = fgColor,
          inputColor = inputColor,
          bgColor = bgColor,
          #angleArc = 180,
          #angleOffset = angleOffset,
          width = "80%",
          height = "80%"
      )
  })
  output$fcup <- renderUI({
        shiny::validate(need(logfcRange$min, ""))
        shiny::validate(need(logfc(),""))
        initMin <- round( logfcRange$min, 2)
        initMax <- round( logfcRange$max, 2)
        if(logfc()[2]>=0){
            fgColor="#6baed6"
            inputColor="white"
            bgColor ="#46505a" 
            rotation="clockwise"
            min=0
            max=initMax
            angleOffset = 0
        }else{
            fgColor="#46505a"
            inputColor="white"
            bgColor ="#e6550d"
            rotation="clockwise"
            min=initMin
            max=0
            angleOffset=180
        }
      knobInput(
          inputId = "myKnobup",
          label = "Upper LogFC cutoff",
          value = round(logfc()[2], 2),
          min = min,
          max=max,
          rotation=rotation,
          displayPrevious = TRUE,
          fgColor = fgColor,
          inputColor = inputColor,
          bgColor = bgColor,
          #angleArc = 180,
          #angleOffset = angleOffset,
          width = "80%",
          height = "80%"
      )
  })
  output$pval <- renderUI({
      shiny::validate(need(padj(), ""))
      fgColor = "#74c476"
      inputColor = "white"
      bgColor = "#46505a"
      knobInput(
          inputId = "myKnobpval",
          label = "P.adj cutoff",
          value = round(padj(), 2),
          min = 0,
          max = 0.2,
          rotation = "clockwise",
          displayPrevious = TRUE,
          fgColor = fgColor,
          inputColor = inputColor,
          bgColor = bgColor,
          #angleArc = 180,
          #angleOffset = 90,
          width = "80%",
          height = "80%"
      )
  })
#....................... ####
## table preview ######################################
output$tablepreview <- DT::renderDT(server=FALSE,{
  shiny::validate(need(data$df, ""))
  customButtons <- list(
        list(extend = "copy", title="Preview table"),
        list(extend="collection", buttons = c("csv", "excel"),
             text="Download", filename="coldata", title="Preview table" ) )
    
    datatable( data$df, extensions = "Buttons",
               rownames=FALSE,
               filter = list(position="top", clear=FALSE),
               options = list(
                 dom = "Bfrtipl",
                 lengthMenu = list(c(10,25,50,100,-1), c(10,25,50,100,"All")),
                  columnDefs = list(list(orderable = TRUE,
                                        className = "details-control",
                                        targets = 1)),
                 buttons = customButtons,
                 list(pageLength = 10, white_space = "normal")
               )
    )
})

output$lostgene <- renderText({
  shiny::validate(need(data$df, ""))
  lost <- length(which(is.na(data$df$ENTREZID)))
  print(paste0(lost," out of ", dim(data$df)[1]," genes have no ENTREZ Id. Theses genes will be missing in enrichment analysis" ) )
})
# ....................... ####
  # volcano plot #########
  output$volcano <- renderPlot( {
    shiny::validate(need(data$df, "Load file to render plot"))
    res <-  data$df
    svg$volcano <- CustomVolcano(res, lab = as.character(res$SYMBOL),
                  selectLab = genesVolcano(),
                    x = 'logFC',
                    y = 'pval',
                    pCutoff = padj(),
                    FCcutoffUP = logfc()[2],
                    FCcutoffDOWN = logfc()[1],
                  drawconnectors = TRUE,
                    #xlim = c(-8, 8),
                    col = c("gray", "#7cccc3", "#d99c01", input$upColor, input$downColor))
    svg$volcano
    })

output$downVolcano <- downloadHandler(
  filename = "volcano.svg",
  content = function(file){
    ggsave(file, svg$volcano, "svg",width = 10, units = "in")}
)

xy <- reactive({
  res <- data$df
  res$`-log10padj` <- (-log10(res$pval)) 
  nearPoints(res, input$plot_click1, xvar = "logFC", yvar = "-log10padj")
})
output$texto1 <- renderTable( digitgeoms = -2, {
        xy <- xy()
        xy[,c(2,4,5,6)]
    })
#....................... ####
## karyoplot ######################################
output$karyoPlot <- renderPlot({
    shiny::validate(need(data$df, "Load file to render plot"))
    krtp(data$df, specie = specie(), pval = padj(), fcdown = logfc()[1],
         fcup = logfc()[2], bg="#46505a", coldown="#4ADBFF" , colup="#f7665c", annotation=annotation() )
})

output$downKrpt <- downloadHandler(
  filename = "karyoplot.png",
  content = function(file){
    png(file)
    krtp(data$df, specie = specie(), pval = padj(), fcdown = logfc()[1],
         fcup = logfc()[2], bg="#46505a", coldown="#4ADBFF" , colup="#f7665c",
         annotation=annotation() )
    dev.off()
    }
)
# .......................####
# Funcion tamaño plot ########################
myHeightfunction <- function(filas) {
  if (length(filas) <= 10) {
    return(400)
  } else if (length(filas) > 10 & length(filas) <= 35) {
    return(600)
  } else{
    return(800)
  }
}
  # variables KEGG ALL ##########################
  rowsAll <- reactive({input$tableAll_rows_selected})
 # KEGG table all #####################################
  output$tableAll <- DT::renderDT(server=FALSE,{
    shiny::validate(need(kgg$all, "Load file to render table"))
    names(kggDT$all)[names(kggDT$all) == "DE"] <- "DEG"
    names(kggDT$all)[names(kggDT$all) == "P.DE"] <- "p-value"
    tituloTabla <- paste0("Table: Kegg DEG genes")
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="keggall", title=tituloTabla ) )

    datatable2(
      kggDT$all,
      vars = c("genes"),
      filter = list(position="top", clear=FALSE),
      escape = FALSE,
      opts = list(order = list(list(5, 'asc')),
        pageLength = 10, white_space = "normal",
        buttons = customButtons))
  }) 
  # KEGG barplot all################
  output$keggPlotAll <- renderPlotly ({
    shiny::validate(need(kgg$all, "Load file to render BarPlot"))
    rowsAll <- rowsAll()
    if(is.null(rowsAll)){
        if( dim(kgg$all)[1]<10 ){rowsAll <-  seq_len(nrow(kgg$all)) }
        else{ rowsAll <-  seq_len(10)  }
    }
    if (isTRUE(df3cols$TF)) {
      p <- plotKeggAll( enrichdf = kgg$all[rowsAll,], nrows = length(rowsAll),
                        genesUp = genes$Up, genesDown = genes$Down, 
                        colors = c(input$downColor, input$upColor) )
      if (typeBarKeggAll() == "Dodge") {
        plt <- p[[1]]; svg$keggall <- p[[1]]
      }
      else if (typeBarKeggAll() == "Stack") {
        plt <- p[[2]]; svg$keggall <- p[[2]]
      }
      else {
        plt <- p[[3]]; svg$keggall <- p[[3]]
      }
    } else{
      # caso de que sea sólo una lista simple
      p <- plotKegg( enrichdf = kgg$all[rowsAll,], nrows = length(rowsAll), 
                     colors = "#045a8d" )
      plt <- p[[1]]
      svg$keggall <- p[[2]]
    }
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( rowsAll() )
    plt$x$layout$height <- myHeightfunction(rowsAll() )
    plt
  })

output$barKeggAll <- downloadHandler(
  filename = "barkeggall.svg",
  content = function(file){
  ggsave(file, svg$keggAll, "svg", width = 10, units = "in") }
)

# KEGG chordiag plot all ###############
  output$chartdiv <- renderMychordplot({
    shiny::validate(need(kgg$all, "Load file to render ChordPlot"))
    rowsAll<- rowsAll()
    if(is.null(rowsAll)){
        if( dim(kgg$all)[1]<10 ){rowsAll <-  seq_len(nrow(kgg$all)) }
        else{ rowsAll <-  seq_len(10)  }
    }
    mychordplot(kgg$all[rowsAll, c("Pathway","genes") ], div="chartdiv" )
    # p <- chordPlot(kgg$all[rowsAll, ], nRows = length(rowsAll), orderby = "P.DE")
    # svg$chordAll <- list(p$x$matrix, rowsAll)
    # p
  })
 output$legendChorAll <- renderPlot({
    shiny::validate(need(kgg$all, "Load file to render ChordPlot"))
    rowsAll <- rowsAll()
    if(is.null(rowsAll)){
        if (dim(kgg$all)[1] < 10) {rowsAll <-  seq_len(nrow(kgg$all))}
        else{rowsAll <-  seq_len(10)}
        
        }
    legendChorplot(kgg$all[rowsAll, ] )
  })
 # download chorplot All
#  output$chordKeggAll <- downloadHandler(
#   filename = "chordKeggAll.svg",
#   content = function(file){
#     svg(file)
#     chordDiagram(svg$chordAll[[1]], transparency = 0.3, big.gap = 1,
#                  annotationTrack = c("grid"),
#                  grid.col = colorRampPalette( 
#                    RColorBrewer::brewer.pal(11, "Spectral"))(length(svg$chordAll[[2]])) )
#     circos.track(track.index = 1, panel.fun = function(x, y) {
#     circos.text(CELL_META$xcenter, CELL_META$ylim[1], CELL_META$sector.index, 
#         facing = "clockwise", niceFacing = TRUE, adj = c(0, 3))},
#     bg.border = NA)
#     dev.off()
#      }
# )
 
  # KEGG dotplot All ################### 
  output$keggDotAll <- renderPlot({
    shiny::validate(need(kgg$all, "Load file and select to render dotPlot"))
    shiny::validate(need(rowsAll(), "Select the paths of interest to render DotPlot"))
    rowsAll <- rowsAll()
    if(is.null(rowsAll)){rowsAll <- c(1:20)}
    p <- dotPlotkegg(kgg$all[rowsAll,], n = length(rowsAll))
    svg$dotKeggAll <- p
    print(p)
  }, height = reactive( myHeightfunction(rowsAll() ) ) )
  
  output$dotkeggAll <- downloadHandler(
    filename = "dotKeggAll.svg",
    content = function(file){
    ggsave(file, svg$dotKeggAll, device = "svg", width = 10, units = "in") }
  )

  # KEGG heatmap All #################
  output$heatmapKeggAll <- renderPlotly({
    shiny::validate(need(kgg$all, "Load file and select to render Heatmap"))
    shiny::validate(need(rowsAll(), "Select the paths of interest to render HeatMap"))
    shiny::validate(need(kggDT$all, ""))
    p <- heatmapKegg(kggDT$all, rowsAll())
    svg$heatKeggAll <- list(kggDT$all, rowsAll())
    plt <- ggplotly(p)
    plt$height <- myHeightfunction( rowsAll() )
    plt$x$layout$height <- myHeightfunction(rowsAll() )
    plt
  })
 
  output$heatKeggAll <- downloadHandler(
    filename = "heatKeggAll.svg",
    content = function(file){
    p <- heatmapKegg(svg$heatKeggAll[[1]],svg$heatKeggAll[[2]] )
    ggsave(filename= file, plot = p, device = "svg", width = 10, units = "in") }
  )
  
# KEGG cnet All #################
  output$legendAll <- renderPlot({
    shiny::validate(need(kgg$all, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsAll(), "Select the paths of interest to render NetPlot"))
    shiny::validate(need(kggDT$all, ""))
    visnetLegend(kggDT = kggDT$all , rows = rowsAll() )
  })
   output$keggAllNet <- renderUI({
    if(!isTRUE( input$keggAllNet_switch ) ){
      plotOutput("cnetAllKegg", height = "600px")
    } else{
      visNetworkOutput("visnetKeggAll", height = "600px")
    }
  })
  output$cnetAllKegg <- renderPlot({
    shiny::validate(need(kgg$all, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsAll(), "Select the paths of interest to render NetPlot"))
    p <- customCnetKegg(kgg$all, rowsAll(), genesUp = data$dfilt, genesDown = NULL)
    svg$cnetKeggAll <- p
    print(p)
  })
  output$visnetKeggAll <- renderVisNetwork({
    shiny::validate(need(kgg$all, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsAll(), "Select the paths of interest to render NetPlot"))
    shiny::validate(need(kggDT$all, ""))
    visData <- customVisNet(kgg$all, nTerm=rowsAll(), kggDT$all,
                             up = genes$Up$SYMBOL, down = genes$Down$SYMBOL )
    visNetwork(visData$nodes, visData$edges, background = "#ffffff") %>%
    visOptions(highlightNearest = list(enabled=TRUE, hover=TRUE),
                nodesIdSelection = TRUE)
  })

  output$cnetKeggAll <- downloadHandler(
    filename = "cnetKeggAll.svg",
    content = function(file){
    ggsave(filename = file, plot = svg$cnetKeggAll, device = "svg", width = 10, height = 10, units = "in") }
  )
  
# ....................... ####
  # variables KEGG UP ##########################
  rowsUp <- reactive({input$table_rows_selected})
 # KEGG table up #####################################
  output$table <- DT::renderDT(server=FALSE,{
    shiny::validate(need(kgg$up, "Load file to render table"))
    names(kggDT$up)[names(kggDT$up) == "DE"] <- "DEG"
    names(kggDT$up)[names(kggDT$up) == "P.DE"] <- "p-value"
    tituloTabla <- paste0("Table: Kegg DEG genes")
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="keggup", title=tituloTabla ) )
    
    datatable2(
      kggDT$up,
      vars = c("genes"),
      filter = list(position="top", clear=FALSE),
      escape = FALSE,
      opts = list(order = list(list(5, 'asc')),
        pageLength = 10, white_space = "normal",
        buttons = customButtons))
  }) 
  # KEGG barplot up################
  output$keggPlot <- renderPlotly ({
    shiny::validate(need(kgg$up, "Load file to render BarPlot"))
    rowsUp <- rowsUp()
    if(is.null(rowsUp)){
        if( dim(kgg$up)[1]<10 ){rowsUp <-  seq_len(nrow(kgg$up)) }
        else{ rowsUp <-  seq_len(10)  }
        }
      p <- plotKegg(enrichdf = kgg$up[rowsUp,], nrows = length(rowsUp), colors = c(input$upColor))
      svg$barkeggup <- p[[2]] 
      
      plt <- p[[1]]
      plt$height <- myHeightfunction( rowsUp() )
      plt$x$layout$height <- myHeightfunction(rowsUp() )
      plt
  })
  
  output$barKeggUp <- downloadHandler(
    filename = "barkeggup.svg",
    content = function(file){
    ggsave(file, svg$barkeggup, "svg", width = 10, height = 10, units = "in") }
  )
  
  # KEGG chordiag plot up ###############
  output$keggChord <- renderMychordplot({
    shiny::validate(need(kgg$up, "Load file to render ChordPlot"))
    rowsUp <- rowsUp()
    if (is.null(rowsUp)) {
      if (dim(kgg$up)[1] < 10) {
        rowsUp <-  seq_len(nrow(kgg$up))
      }
      else{
        rowsUp <-  seq_len(10)
      }
    }
    mychordplot(kgg$up[rowsUp, c("Pathway", "genes")], div = "keggChord")
    # p <- chordPlot(kgg$up[rowsUp,], nRows = length(rowsUp), orderby = "P.DE")
    # svg$chordUp <- list(p$x$matrix, rowsUp)
    # p
  })
 output$legendChorUp <- renderPlot({
    shiny::validate(need(kgg$up, "Load file to render ChordPlot"))
    rowsUp <- rowsUp()
    if(is.null(rowsUp)){
        if (dim(kgg$up)[1] < 10) {rowsUp <-  seq_len(nrow(kgg$up))}
        else{rowsUp <-  seq_len(10)}
        
        }
    legendChorplot(kgg$up[rowsUp, ] )
  })
 # download chorplot All
 # output$chordKeggUp <- downloadHandler(
 #  filename = "chordKeggUp.svg",
 #  content = function(file){
 #    svg(file)
 #    chordDiagram(svg$chordUp[[1]], transparency = 0.3, big.gap = 1,
 #                 annotationTrack = c("grid"),
 #                 grid.col = colorRampPalette( 
 #                   RColorBrewer::brewer.pal(11, "Spectral"))(length(svg$chordUp[[2]])) )
 #    circos.track(track.index = 1, panel.fun = function(x, y) {
 #    circos.text(CELL_META$xcenter, CELL_META$ylim[1], CELL_META$sector.index, 
 #        facing = "clockwise", niceFacing = TRUE, adj = c(0, 3))},
 #    bg.border = NA)
 #    dev.off()
 #     }
# )
  # KEGG dotplot UP ################### 
  output$keggDotUp <- renderPlot({
    shiny::validate(need(kgg$up, "Load file and select to render dotPlot"))
    shiny::validate(need(rowsUp(), "Select the paths of interest to render DotPlot"))
    rowsUp <- rowsUp()
    if(is.null(rowsUp)){rowsUp <- c(1:20)}
    p <- dotPlotkegg(kgg$up[rowsUp,], n = length(rowsUp))
    svg$dotKeggUp <- p
    p
  }, height = reactive( myHeightfunction(rowsUp() ) ) )
  
  output$dotKeggUp <- downloadHandler(
    filename = "dotKeggUp.svg",
    content = function(file){
    ggsave(file, svg$dotKeggUp, device = "svg", width = 10, units = "in") }
  )

  # KEGG heatmap Up #################
  output$heatmapKeggUp <- renderPlotly({
    shiny::validate(need(kgg$up, "Load file and select to render Heatmap"))
    shiny::validate(need(rowsUp(), "Select the paths of interest to render HeatMap"))
    shiny::validate(need(kggDT$up, ""))
    p <- heatmapKegg(kggDT$up, rowsUp())
    svg$heatKeggUp <- list(kggDT$up, rowsUp())
    plt <- ggplotly(p)
    plt$height <- myHeightfunction( rowsUp() )
    plt$x$layout$height <- myHeightfunction(rowsUp() )
    plt
  })

  output$heatKeggUp <- downloadHandler(
    filename = "heatKeggUp.svg",
    content = function(file){
    p <- heatmapKegg(svg$heatKeggUp[[1]],svg$heatKeggUp[[2]] )
    ggsave(filename= file, plot = p, device = "svg", width = 10, units = "in") }
  )
# KEGG cnet Up #################
  output$legendUp <- renderPlot({
    shiny::validate(need(kgg$up, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsUp(), "Select the paths of interest to render NetPlot"))
    shiny::validate(need(kggDT$up, ""))
    visnetLegend(kggDT = kggDT$up , rows = rowsUp() )
  })
   output$keggUpNet <- renderUI({
    if(!isTRUE( input$keggUpNet_switch ) ){
      plotOutput("cnetKeggUp", height = "600px")
    } else{
      visNetworkOutput("visnetKeggUp", height = "600px")
    }
  })
  output$cnetKeggUp <- renderPlot({
    shiny::validate(need(kgg$up, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsUp(), "Select the paths of interest to render NetPlot"))
    p <- customCnetKegg(kgg$up, rowsUp(), genesUp = data$dfilt, genesDown = NULL)
    svg$cnetKeggUp <- p
    print(p)
  })
  output$visnetKeggUp <- renderVisNetwork({
    shiny::validate(need(kgg$up, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsUp(), "Select the paths of interest to render NetPlot"))
    shiny::validate(need(kggDT$up, ""))
    visData <- customVisNet(kgg$up, nTerm=rowsUp(), kggDT$up,
                             up = genes$Up$SYMBOL, down = NULL )
    visNetwork(visData$nodes, visData$edges, background = "#ffffff") %>%
    visOptions(highlightNearest = list(enabled=TRUE, hover=TRUE),
                nodesIdSelection = TRUE)
  })
  
  output$cnetkeggUp <- downloadHandler(
    filename = "cnetKeggUp.svg",
    content = function(file){
    ggsave(filename = file, plot = svg$cnetKeggUp, device = "svg", width = 10, height = 10, units = "in") }
  )
  # ....................... ####
  # variables KEGG Down ##########################
  rowsDown <- reactive({input$tableDown_rows_selected})
 # KEGG table down #####################################
  output$tableDown <- DT::renderDT(server=FALSE,{
    shiny::validate(need(kgg$down, "Load file to render table"))
    names(kggDT$down)[names(kggDT$down) == "DE"] <- "DEG"
    names(kggDT$down)[names(kggDT$down) == "P.DE"] <- "p-value"
    tituloTabla <- paste0("Table: Kegg DEG genes")
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="keggdown", title=tituloTabla ) )
    
    datatable2(
      kggDT$down,
      vars = c("genes"),
      filter = list(position="top", clear=FALSE),
      escape = FALSE,
      opts = list(order = list(list(5, 'asc')),
        pageLength = 10, white_space = "normal",
        buttons = customButtons))
  }) 
  # KEGG barplot down################
  output$keggPlotDown <- renderPlotly ({
    shiny::validate(need(kgg$down, "Load file to render BarPlot"))
    rowsDown <- rowsDown()
    if(is.null(rowsDown)){
        if( dim(kgg$down)[1]<10 ){rowsDown <-  seq_len(nrow(kgg$down)) }
        else{ rowsDown <-  seq_len(10)  }
        }
    p <- plotKegg(enrichdf = kgg$down[rowsDown,], nrows = length(rowsDown), colors = c(input$downColor))
    svg$barkeggdown <- p[[2]] 
    plt <- p[[1]]
    plt$height <- myHeightfunction( rowsDown() )
    plt$x$layout$height <- myHeightfunction(rowsDown() )
    plt

  })
  
  output$barKeggDown <- downloadHandler(
    filename = "barkeggdown.svg",
    content = function(file){
    ggsave(file, svg$barkeggdown, "svg", width = 10, height = 10, units = "in") }
  )
  
  # KEGG chordiag plot down ###############
  output$keggChordDown <- renderMychordplot({
    shiny::validate(need(kgg$down, "Load file to render ChordPlot"))
    rowsDown<- rowsDown()
    if(is.null(rowsDown)){
        if( dim(kgg$down)[1]<10 ){rowsDown <-  seq_len(nrow(kgg$down)) }
        else{ rowsDown <-  seq_len(10)  }
    }
    mychordplot(kgg$down[rowsDown, c("Pathway", "genes")], div = "keggChordDown")
    # p <- chordPlot(kgg$down[rowsDown, ], nRows = length(rowsDown), orderby = "P.DE")
    # svg$chordDown <- list(p$x$matrix, rowsDown)
    # p
  })
 output$legendChorDown <- renderPlot({
    shiny::validate(need(kgg$down, "Load file to render ChordPlot"))
    rowsDown <- rowsDown()
    if(is.null(rowsDown)){
        if (dim(kgg$down)[1] < 10) {rowsDown <-  seq_len(nrow(kgg$down))}
        else{rowsDown <-  seq_len(10)}
        
        }
    legendChorplot(kgg$down[rowsDown, ] )
  })
  # download chorplot All
#  output$chordKeggDown <- downloadHandler(
#   filename = "chordKeggDown.svg",
#   content = function(file){
#     svg(file)
#     chordDiagram(svg$chordDown[[1]], transparency = 0.3, big.gap = 1,
#                  annotationTrack = c("grid"),
#                  grid.col = colorRampPalette( 
#                    RColorBrewer::brewer.pal(11, "Spectral"))(length(svg$chordDown[[2]])) )
#     circos.track(track.index = 1, panel.fun = function(x, y) {
#     circos.text(CELL_META$xcenter, CELL_META$ylim[1], CELL_META$sector.index, 
#         facing = "clockwise", niceFacing = TRUE, adj = c(0, 3))},
#     bg.border = NA)
#     dev.off()
#      }
# )
  # KEGG dotplot Down ################### 
  output$keggDotDown <- renderPlot({
    shiny::validate(need(kgg$down, "Load file and select to render dotPlot"))
    shiny::validate(need(rowsDown(), "Select the paths of interest to render DotPlot"))
    rowsDown <- rowsDown()
    if(is.null(rowsDown)){rowsDown <- c(1:20)}
    p <- dotPlotkegg(kgg$down[rowsDown,], n = length(rowsDown))
    svg$dotKeggDown<- p
    p
  }, height = reactive( myHeightfunction(rowsDown() ) ) )
 
  output$dotKeggDown <- downloadHandler(
    filename = "dotKeggDown.svg",
    content = function(file){
    ggsave(file, svg$dotKeggDown, device = "svg", width = 10, units = "in") }
  )
  # KEGG heatmap Down #################
  output$heatmapKeggDown <- renderPlotly({
    shiny::validate(need(kgg$down, "Load file and select to render Heatmap"))
    shiny::validate(need(rowsDown(), "Select the paths of interest to render HeatMap"))
    shiny::validate(need(kggDT$down, ""))
    p <- heatmapKegg(kggDT$down, rowsDown())
    svg$heatKeggDown <- list(kggDT$down, rowsDown())
    plt <- ggplotly(p)
    plt$height <- myHeightfunction( rowsDown() )
    plt$x$layout$height <- myHeightfunction(rowsDown() )
    plt
  })

  output$heatKeggDown <- downloadHandler(
    filename = "heatKeggDown.svg",
    content = function(file){
    p <- heatmapKegg(svg$heatKeggDown[[1]],svg$heatKeggDown[[2]] )
    ggsave(filename= file, plot = p, device = "svg", width = 10, units = "in") }
  )
 
# KEGG cnet Down #################
  output$legendDown <- renderPlot({
    shiny::validate(need(kgg$down, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsDown(), "Select the paths of interest to render NetPlot"))
    shiny::validate(need(kggDT$down, ""))
    visnetLegend(kggDT = kggDT$down , rows = rowsDown() )
  })
   output$keggDownNet <- renderUI({
    if(!isTRUE( input$keggDownNet_switch ) ){
      plotOutput("cnetKeggDown", height = "600px")
    } else{
      visNetworkOutput("visnetKeggDown", height = "600px")
    }
  })
  output$cnetKeggDown <- renderPlot({
    shiny::validate(need(kgg$down, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsDown(), "Select the paths of interest to render NetPlot"))
    p <- customCnetKegg(kgg$down, rowsDown(), genesDown = data$dfilt, genesUp = NULL)
    svg$cnetKeggDown <- p
    print(p)
    })
  output$visnetKeggDown <- renderVisNetwork({
    shiny::validate(need(kgg$down, "Load file and select to render Net Plot"))
    shiny::validate(need(rowsDown(), "Select the paths of interest to render NetPlot"))
    shiny::validate(need(kggDT$down, ""))
    visData <- customVisNet(kgg$down, nTerm=rowsDown(), kggDT$down,
                             down = genes$Down$SYMBOL, up = NULL )
    visNetwork(visData$nodes, visData$edges, background = "#ffffff") %>%
    visOptions(highlightNearest = list(enabled=TRUE, hover=TRUE),
                nodesIdSelection = TRUE)
  })
  output$cnetkeggDown <- downloadHandler(
    filename = "cnetKeggDown.svg",
    content = function(file){
    ggsave(filename = file, plot = svg$cnetKeggDown, device = "svg", width = 10, height = 10, units = "in") }
  )
 # ....................... ####
 # variables GO ###################################
  bprowsall <- reactive({input$tableBPall_rows_selected}) 
  mfrowsall <- reactive({input$tableMFall_rows_selected})
  ccrowsall <- reactive({input$tableCCall_rows_selected})
  
  bprowsup <- reactive({input$tableBP_rows_selected})
  mfrowsup <- reactive({input$tableMF_rows_selected})
  ccrowsup <- reactive({input$tableCC_rows_selected})
  
  bprowsdown <- reactive({input$tableBPdown_rows_selected})
  mfrowsdown <- reactive({input$tableMFdown_rows_selected})
  ccrowsdown <- reactive({input$tableCCdown_rows_selected})
  
  typeBarBpAll <- reactive({input$selectbpall})
  typeBarMfAll <- reactive({input$selectmfall})
  typeBarCcAll <- reactive({input$selectccall})
  
 # ....................... ####
   # GO table BP ALL #####################
  output$tableBPall <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$all, "Load file to render table"))
    goDT <- goDT$all 
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level) 
    tituloTabla <- paste0("Table: GO-BP all genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="BPall", title=tituloTabla ) )
    
    datatable2(goDT[goDT$Ont=="BP",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                 pageLength = 10, white_space = "normal",
                 buttons = customButtons))
  })
  # GO plots BP all #####################
  output$plotBPall <- renderPlotly({
    shiny::validate(need(go$all, "Load file to render plot"))
    bprowsall <- bprowsall()
    if(is.null(bprowsall)){bprowsall <- c(1:10)}
    gosBP <- go$all[go$all$Ont=="BP",]
    if(isTRUE(df3cols$TF)){
          p <- plotGOAll(enrichdf = gosBP[bprowsall, ], nrows = length(bprowsall), ont="BP", 
                    genesUp = genes$Up, genesDown = genes$Down,
                    colors = c(input$downColor, input$upColor))
          if( typeBarBpAll() == "Dodge") {
            plt <- p[[1]]; svg$barbpall <- p[[1]]
            }
          else if ( typeBarBpAll() == "Stack") {
            plt <- p[[2]]; svg$barbpall <- p[[2]]
            }
          else {
            plt <- p[[3]] ;svg$barbpall <- p[[3]] 
          }
    } else{
      p <- plotGO(enrichdf = gosBP[bprowsall, ], nrows = length(bprowsall), ont="BP",
               colors = "#045a8d" )
        svg$barbpall <- p
        plt <- p
    }
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( bprowsall() )
    plt$x$layout$height <- myHeightfunction(bprowsall() )
    plt
  })
  
  output$barBpAll <- downloadHandler(
    filename = "barbpall.svg",
    content = function(file){
      ggsave(file, svg$barbpall, "svg", width = 10, units = "in") }
  )
  # GO BP dotplot all ################### 
  output$BPDotall <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    shiny::validate(need(bprowsall(), "Select the terms of interest to render DotPlot"))
    bprowsall <- bprowsall()
    if(is.null(bprowsall)){bprowsall <- c(1:20)}
    gosBP <- go$all[go$all$Ont=="BP",]
    p <- dotPlotGO(gosBP[bprowsall,], n = length(bprowsall))
    svg$dotbpall <- p
    print(p)
  }, height = reactive( myHeightfunction(bprowsall() ) ) )
  
  output$dotBpAll <- downloadHandler(
    filename = "dotbpall.svg",
    content = function(file){
      ggsave(file, svg$dotbpall, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot BP all #######################
  output$gobarplotAllBP <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    bprowsall <- bprowsall()
    p <- goBarplot(enrichGO = go$all, resGO = data$dfilt, genes= genes$all,
              category = "BP", nrows = bprowsall)
    svg$gobarbpall <- p
    print(p)
  })
  
  output$gobarBpAll <- downloadHandler(
    filename = "gobarbpall.svg",
    content = function(file){
      ggsave(file, svg$gobarbpall, device = "svg", width = 10, units = "in") }
  )
  # GO circle BP all #####################
  output$goCircleAllBP <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( bprowsall() , "Select at least 4 rows"))
    bprowsall <- bprowsall()
    if(length(bprowsall)>=4){
      circ <- data2circle(go=go$all[bprowsall, ], res=data$dfilt, genes=genes$all)
      p <- circle(circ, label.size = 3, nsub = length(bprowsall), table.legend = FALSE)
      svg$cirbpall <- p
      print(p)
    }
  })
  output$cirBpAll <- downloadHandler(
    filename = "cirbpall.svg",
    content = function(file){
      ggsave(file, svg$cirbpall, device = "svg", width = 10, units = "in") }
  )
  # GO cloud BP all #######################
  output$cloudBPAll <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    goall <- go$all[go$all$Ont=="BP", ]
    myggwordcloud(goall, bg = "#343e48")
  })
  
  output$cloudbpall <- downloadHandler(
    filename = "cloudbpall.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$all[go$all$Ont=="BP", ])
      dev.off()
      }
  )
  # ...................... #############
  # GO table MF all #####################
  output$tableMFall <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$all, "Load file to render table"))
    goDT <- goDT$all
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-MF all genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="MFall", title=tituloTabla ) )
        
    datatable2(goDT[goDT$Ont=="MF",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                           pageLength = 10, white_space = "normal",
                           buttons = customButtons,
                           ajax = list(serverSide = TRUE, processing = TRUE))
    )
  })
  # GO plots MF all  #####################
  output$plotMFall <- renderPlotly({
    shiny::validate(need(go$all, "Load file to render plot"))
    mfrowsall <- mfrowsall()
    if(is.null(mfrowsall)){mfrowsall <- c(1:10)}
    gosMF <- go$all[go$all$Ont=="MF",]
    if(isTRUE(df3cols$TF)){
        p <- plotGOAll(enrichdf = gosMF[mfrowsall, ], nrows = length(mfrowsall), ont="MF", 
                       genesUp = genes$Up, genesDown = genes$Down,
                       colors = c(input$downColor, input$upColor))
        if( typeBarMfAll() == "Dodge") {
          plt <- p[[1]]; svg$barmfall <- p[[1]]
          }
        else if ( typeBarMfAll() == "Stack") {
          plt <- p[[2]]; svg$barmfall <- p[[2]]
        }
        else { 
          plt <- p[[3]]; svg$barmfall <- p[[3]]
          }
    }
    else{
      p <- plotGO(enrichdf = gosMF[mfrowsall, ], nrows = length(mfrowsall), ont="MF",
               colors = "#045a8d" )
      svg$barmfall <- p
      plt <- p
    }
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( mfrowsall() )
    plt$x$layout$height <- myHeightfunction(mfrowsall() )
    plt
  })
  
  output$barMfAll <- downloadHandler(
    filename = "barmfall.svg",
    content = function(file){
      ggsave(file, svg$barmfall, "svg", width = 10, units = "in") }
  )
  # GO MF dotplot all ################### 
  output$MFDotall <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    shiny::validate(need(mfrowsall(), "Select the terms of interest to render DotPlot"))
    mfrowsall <- mfrowsall()
    if(is.null(mfrowsall)){mfrowsall <- c(1:20)}
    gosMF <- go$all[go$all$Ont=="MF",]
    p <- dotPlotGO(gosMF[mfrowsall,], n = length(mfrowsall))
    svg$dotmfall <- p
    print(p)
  }, height = reactive( myHeightfunction(mfrowsall() ) ) )
  
  output$dotMfAll <- downloadHandler(
    filename = "dotmfall.svg",
    content = function(file){
      ggsave(file, svg$dotmfall, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot MF all ####################
  output$gobarplotAllMF <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    mfrowsall <- mfrowsall()
    p <- goBarplot(enrichGO = go$all, resGO = data$dfilt, genes= genes$all,
              category = "MF", nrows = mfrowsall)
    svg$gobarmfall <- p
    print(p)
  })
  
  output$gobarMfAll <- downloadHandler(
    filename = "gobarmfall.svg",
    content = function(file){
      ggsave(file, svg$gobarmfall, device = "svg", width = 10, units = "in") }
  )
  # GO circle MF all #####################
  output$goCircleAllMF <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( mfrowsall() , "Select at least 4 rows"))
    mfrowsall <- mfrowsall()
    if(length(mfrowsall)>=4){
      circ <- data2circle(go=go$all[mfrowsall, ], res=data$dfilt, genes=genes$all)
      p <- circle(circ, label.size = 3, nsub = length(mfrowsall), table.legend = FALSE)
      svg$cirmfall <- p
      print(p)
    }
  })
  output$cirMfAll <- downloadHandler(
    filename = "cirmfall.svg",
    content = function(file){
      ggsave(file, svg$cirmfall, device = "svg", width = 10, units = "in") }
  )
  # GO cloud MF all #######################
  output$cloudMFAll <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    goall <- go$all[go$all$Ont=="MF", ]
    myggwordcloud(goall, bg = "#343e48")
  })
  
  output$cloudmfall <- downloadHandler(
    filename = "cloudmfall.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$all[go$all$Ont=="MF", ])
      dev.off()
    }
  )
  # ............ ###############################
  # GO table CC all #####################
  output$tableCCall <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$all, "Load file to render table"))
    goDT <- goDT$all
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-CC all genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="CCall", title=tituloTabla ) )
    
    datatable2(goDT[goDT$Ont=="CC",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                           pageLength = 10, white_space = "normal",
                           buttons = customButtons,
                           ajax = list(serverSide = TRUE, processing = TRUE))
    )
  })
  # GO plots CC all #####################
  output$plotCCall <- renderPlotly({
    shiny::validate(need(go$all, "Load file to render plot"))
    ccrowsall <- ccrowsall()
    if(is.null(ccrowsall)){ccrowsall <- c(1:10)}
    gosCC <- go$all[go$all$Ont=="CC",]
    if(isTRUE(df3cols$TF)){
    p <- plotGOAll(enrichdf = gosCC[ccrowsall, ], nrows = length(ccrowsall), ont="CC", 
                   genesUp = genes$Up, genesDown = genes$Down,
                   colors = c(input$downColor, input$upColor))
    if( typeBarCcAll() == "Dodge") {
      plt <- p[[3]]; svg$barccall <- p[[1]]
      }
    else if ( typeBarCcAll() == "Stack") {
      plt <- p[[2]] ; svg$barccall <- p[[2]]
      }
    else {
      plt <- p[[3]] ; svg$barccall <- p[[3]]
      }
    }
    else{
        p <- plotGO(enrichdf = gosCC[ccrowsall, ], nrows = length(ccrowsall), ont="CC",
               colors = "#045a8d" )
        svg$barccall <- p
        plt <- p
    }
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( ccrowsall() )
    plt$x$layout$height <- myHeightfunction(ccrowsall() )
    plt
  })
  
  output$barCcAll <- downloadHandler(
    filename = "barccall.svg",
    content = function(file){
      ggsave(file, svg$barccall, "svg", width = 10, units = "in") }
  )
  # GO CC dotplot all ################### 
  output$CCDotall <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    shiny::validate(need(ccrowsall(), "Select the terms of interest to render DotPlot"))
    ccrowsall <- ccrowsall()
    if(is.null(ccrowsall)){ccrowsall <- c(1:20)}
    gosCC <- go$all[go$all$Ont=="CC",]
    p <- dotPlotGO(gosCC[ccrowsall,], n = length(ccrowsall))
    svg$dotccall <- p
    print(p)
  }, height = reactive( myHeightfunction(ccrowsall() ) ) )
  
  
  output$dotCcAll <- downloadHandler(
    filename = "dotccall.svg",
    content = function(file){
      ggsave(file, svg$dotccall, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot CC all #######################
  output$gobarplotAllCC <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    ccrowsall <- ccrowsall()
    p <- goBarplot(enrichGO = go$all, resGO = data$dfilt, genes= genes$all,
              category = "CC", nrows = ccrowsall)
    svg$gobarmfall <- p
    print(p)
  })
  
  output$gobarMfAll <- downloadHandler(
    filename = "gobarmfall.svg",
    content = function(file){
      ggsave(file, svg$gobarmfall, device = "svg", width = 10, units = "in") }
  )
  # GO circle CC all #####################
  output$goCircleAllCC <- renderPlot({
    shiny::validate(need(go$all, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( ccrowsall() , "Select at least 4 rows"))
    ccrowsall <- ccrowsall()
    if(length(ccrowsall)>=4){
      circ <- data2circle(go=go$all[ccrowsall, ], res=data$dfilt, genes=genes$all)
      p <- circle(circ, label.size = 3, nsub = length(ccrowsall), table.legend = FALSE)
      svg$circcall <- p
      print(p)
    }
  })
  output$cirCcAll <- downloadHandler(
    filename = "circcall.svg",
    content = function(file){
      ggsave(file, svg$circcall, device = "svg", width = 10, units = "in") }
  )
  
  # GO cloud CC all #######################
  output$cloudCCAll <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    goall <- go$all[go$all$Ont=="CC", ]
    myggwordcloud(goall, bg = "#343e48")
  })
  
  output$cloudccall <- downloadHandler(
    filename = "cloudccall.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$all[go$all$Ont=="CC", ])
      dev.off()
    }
  )
  # ............ ###############################
  # GO table BP UP#####################
  output$tableBP <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$up, "Load file to render table"))
    goDT <- goDT$up
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-BP up-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="BPup", title=tituloTabla ) )
    
    datatable2(goDT[goDT$Ont=="BP",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                           pageLength = 10, white_space = "normal",
                           buttons = customButtons))
  })
  # GO plots BP UP #####################
  output$plotBP <- renderPlotly({
    shiny::validate(need(go$up, "Load file to render plot"))
    bprowsup <- bprowsup()
    if(is.null(bprowsup)){bprowsup <- c(1:10)}
    gosBP <- go$up[go$up$Ont=="BP",]
    p <- plotGO(enrichdf = gosBP[bprowsup, ], nrows = length(bprowsup), ont="BP",
           colors = c(input$upColor) )
    svg$barbpup <- p
    plt <- p
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( ccrowsall() )
    plt$x$layout$height <- myHeightfunction(ccrowsall() )
    plt
  })
  
  output$barBpUp <- downloadHandler(
    filename = "barbpup.svg",
    content = function(file){
      ggsave(file, svg$barbpup, "svg", width = 10, units = "in") }
  )
  # GO BP dotplot up ################### 
  output$BPDotUp <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    shiny::validate(need(bprowsup(), "Select the terms of interest to render DotPlot"))
    bprowsup <- bprowsup()
    if(is.null(bprowsup)){bprowsup <- c(1:20)}
    gosBP <- go$up[go$up$Ont=="BP",]
    p <- dotPlotGO(gosBP[bprowsup,], n = length(bprowsup))
    svg$dotbpup <- p
    print(p)
  }, height = reactive( myHeightfunction(bprowsup() ) ) )
  
  output$dotBpUp <- downloadHandler(
    filename = "dotbpup.svg",
    content = function(file){
      ggsave(file, svg$dotbpup, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot BP Up #######################
  output$gobarplotUpBP <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    bprowsup <- bprowsup()
    p <- goBarplot(enrichGO = go$up, resGO = data$dfilt, genes= genes$Up,
              category = "BP", nrows = bprowsup)
    svg$gobarbpup <- p
    print(p)
  })
  
  output$gobarBpUp <- downloadHandler(
    filename = "gobarbpup.svg",
    content = function(file){
      ggsave(file, svg$gobarbpup, device = "svg", width = 10, units = "in") }
  )
    # GO circle BP Up #####################
  output$goCircleUpBP <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( bprowsup() , "Select at least 4 rows"))
    bprowsup <- bprowsup()
    if(length(bprowsup)>=4){
      circ <- data2circle(go=go$up[bprowsup, ], res=data$dfilt, genes=genes$Up)
      p <- circle(circ, label.size = 3, nsub = length(bprowsup), table.legend = FALSE)
      svg$cirbpup <- p
      print(p)
    }
  })
  output$cirBpUp <- downloadHandler(
    filename = "cirbpup.svg",
    content = function(file){
      ggsave(file, svg$cirbpup, device = "svg", width = 10, units = "in") }
  )
  # GO cloud BP UP  #######################
  output$cloudBPUp <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    goup <- go$up[go$up$Ont=="BP", ]
    myggwordcloud(goup, bg = "#343e48")
  })
  
  output$cloudbpup <- downloadHandler(
    filename = "cloudbpup.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$up[go$up$Ont=="BP", ])
      dev.off()
    }
  )
  # ............ ###############################
  # GO table MF UP #####################
  output$tableMF <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$up, "Load file to render table"))
    goDT <- goDT$up
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-MF up-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="MFup", title=tituloTabla ) )
  
    datatable2(goDT[goDT$Ont=="MF",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                           pageLength = 10, white_space = "normal",
                           buttons = customButtons,
                           ajax = list(serverSide = TRUE, processing = TRUE))
    )
  })
  # GO plots MF UP #####################
  output$plotMF <- renderPlotly({
    shiny::validate(need(go$up, "Load file to render plot"))
    mfrowsup <- mfrowsup()
    if(is.null(mfrowsup)){mfrowsup <- c(1:10)}
    gosMF <- go$up[go$up$Ont=="MF",]
    p <- plotGO(enrichdf = gosMF[mfrowsup, ], nrows = length(mfrowsup), ont = "MF",
           colors = c(input$upColor) )
    svg$barmfup <- p
    plt <- p
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( mfrowsup() )
    plt$x$layout$height <- myHeightfunction(mfrowsup() )
    plt
    
  })
  
  output$barMfUp <- downloadHandler(
    filename = "barmfup.svg",
    content = function(file){
      ggsave(file, svg$barmfup, "svg", width = 10, units = "in") }
  )
  # GO MF dotplot up ################### 
  output$MFDotUp <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    shiny::validate(need(mfrowsup(), "Select the terms of interest to render DotPlot"))
    mfrowsup <- mfrowsup()
    if(is.null(mfrowsup)){mfrowsup <- c(1:20)}
    gosMF <- go$up[go$up$Ont=="MF",]
    p <- dotPlotGO(gosMF[mfrowsup,], n = length(mfrowsup))
    svg$dotmfup <- p
    print(p)
  }, height = reactive( myHeightfunction(mfrowsup() ) ) )
  
  
  output$dotMfUp <- downloadHandler(
    filename = "dotmfup.svg",
    content = function(file){
      ggsave(file, svg$dotmfup, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot MF Up #######################
  output$gobarplotUpMF <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    mfrowsup <- mfrowsup()
    p <- goBarplot(enrichGO = go$up, resGO = data$dfilt, genes= genes$Up,
              category = "MF", nrows = mfrowsup)
    svg$gobarmfup <- p
    print(p)
  })
  
  output$gobarMfUp <- downloadHandler(
    filename = "gobarmfup.svg",
    content = function(file){
      ggsave(file, svg$gobarmfup, device = "svg", width = 10, units = "in") }
  )
  # GO circle MF Up #####################
  output$goCircleUpMF <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( mfrowsup() , "Select at least 4 rows"))
    mfrowsup <- mfrowsup()
    if(length(mfrowsup)>=4){
      circ <- data2circle(go=go$up[mfrowsup, ], res=data$dfilt, genes=genes$Up)
      p <- circle(circ, label.size = 3, nsub = length(mfrowsup), table.legend = FALSE)
      svg$cirmfup <- p
      print(p)
    }
  })
  output$cirMfUp <- downloadHandler(
    filename = "cirmfup.svg",
    content = function(file){
      ggsave(file, svg$cirmfup, device = "svg", width = 10, units = "in") }
  )
  # GO cloud MF UP  #######################
  output$cloudMFUp <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    goup <- go$up[go$up$Ont=="MF", ]
    myggwordcloud(goup, bg = "#343e48")
  })
  
  output$cloudmfup <- downloadHandler(
    filename = "cloudmfup.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$up[go$up$Ont=="MF", ])
      dev.off()
    }
  )
  # ............ ###############################
  # GO table CC UP #####################
  output$tableCC <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$up, "Load file to render table"))
    goDT <- goDT$up
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-CC up-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="CCup", title=tituloTabla ) )

    datatable2(goDT[goDT$Ont=="CC",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                           pageLength = 10, white_space = "normal",
                           buttons = customButtons,
                           ajax = list(serverSide = TRUE, processing = TRUE))
    )
  })
  # GO plots CC UP #####################
  output$plotCC <- renderPlotly({
    shiny::validate(need(go$up, "Load file to render plot"))
    ccrowsup <- ccrowsup()
    if(is.null(ccrowsup)){ccrowsup <- c(1:10)}
    gosCC <- go$up[go$up$Ont=="CC",]
    p <- plotGO(enrichdf = gosCC[ccrowsup,], nrows = length(ccrowsup), ont="CC",
           colors = c(input$upColor))
    svg$barccup <- p
    plt <- p
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( ccrowsup() )
    plt$x$layout$height <- myHeightfunction(ccrowsup() )
    plt
  })
  
  output$barCcUp <- downloadHandler(
    filename = "barccup.svg",
    content = function(file){
      ggsave(file, svg$barccup, "svg", width = 10, units = "in") }
  )
  # GO CC dotplot up ################### 
  output$CCDotUp <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    shiny::validate(need(ccrowsup(), "Select the terms of interest to render DotPlot"))
    ccrowsup <- ccrowsup()
    if(is.null(ccrowsup)){ccrowsup <- c(1:20)}
    gosCC <- go$up[go$up$Ont=="CC",]
    p <- dotPlotGO(gosCC[ccrowsup,], n = length(ccrowsup))
    svg$dotccup <- p
    print(p)
  }, height = reactive( myHeightfunction(ccrowsup() ) ) )
  
  
  output$dotCcUp <- downloadHandler(
    filename = "dotccup.svg",
    content = function(file){
      ggsave(file, svg$dotccup, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot CC Up #######################
  output$gobarplotUpCC <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    ccrowsup <- ccrowsup()
    goBarplot(enrichGO = go$up, resGO = data$dfilt, genes= genes$Up,
              category = "CC", nrows = ccrowsup)
    svg$gobarccup <- p
    print(p)
  })
  
  output$gobarCcUp <- downloadHandler(
    filename = "gobarccup.svg",
    content = function(file){
      ggsave(file, svg$gobarccup, device = "svg", width = 10, units = "in") }
  )
  # GO circle CC Up #####################
  output$goCircleUpCC <- renderPlot({
    shiny::validate(need(go$up, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( ccrowsup() , "Select at least 4 rows"))
    ccrowsup <- ccrowsup()
    if(length(ccrowsup)>=4){
      circ <- data2circle(go=go$up[ccrowsup, ], res=data$dfilt, genes=genes$Up)
      p <- circle(circ, label.size = 3, nsub = length(ccrowsup), table.legend = FALSE)
      svg$circcup <- p
      print(p)
    }
  })
  output$cirCcUp <- downloadHandler(
    filename = "circcup.svg",
    content = function(file){
      ggsave(file, svg$circcup, device = "svg", width = 10, units = "in") }
  )
  # GO cloud CC UP  #######################
  output$cloudCCUp <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    goup <- go$up[go$up$Ont=="CC", ]
    myggwordcloud(goup, bg = "#343e48")
  })
  
  output$cloudccup <- downloadHandler(
    filename = "cloudccup.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$up[go$up$Ont=="CC", ])
      dev.off()
    }
  )
  # ............ ###############################
  # GO table BP DOWN #####################
  output$tableBPdown <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$down, "Load file to render table"))
    goDT <- goDT$down
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-BP down-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="BPdown", title=tituloTabla ) )
   
    datatable2(goDT[goDT$Ont=="BP",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                           buttons = customButtons,
                           pageLength = 10, white_space = "normal")
    )
  })
  # GO plots BP DOWN #####################
  output$plotBPdown <- renderPlotly({
    shiny::validate(need(go$down, "Load file to render plot"))
    bprowsdown <- bprowsdown()
    if(is.null(bprowsdown)){bprowsdown <- c(1:10)}
    gosBP <- go$down[go$down$Ont=="BP",]
    p <- plotGO(enrichdf = gosBP[bprowsdown, ], nrows = length(bprowsdown), ont="BP",
           colors = c(input$downColor))
    svg$barbpdown <- p
    plt <- p
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( bprowsdown() )
    plt$x$layout$height <- myHeightfunction(bprowsdown() )
    plt
  })
  
  output$barBpDown <- downloadHandler(
    filename = "barbpdown.svg",
    content = function(file){
      ggsave(file, svg$barbpdown, "svg", width = 10, units = "in") }
  )
  
  # GO BP dotplot down ################### 
  output$BPDotDown <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    shiny::validate(need(bprowsdown(), "Select the terms of interest to render DotPlot"))
    bprowsdown <- bprowsdown()
    if(is.null(bprowsdown)){bprowsdown <- c(1:20)}
    gosBP <- go$down[go$down$Ont=="BP",]
    p <- dotPlotGO(gosBP[bprowsdown,], n = length(bprowsdown))
    svg$dotbpdown <- p
    print(p)
  }, height = reactive( myHeightfunction(bprowsdown() ) ) )
  
  
  output$dotBpDown <- downloadHandler(
    filename = "dotbpdown.svg",
    content = function(file){
      ggsave(file, svg$dotbpdown, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot BP down #######################
  output$gobarplotDownBP <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    bprowsdown <- bprowsdown()
    p <- goBarplot(enrichGO = go$down, resGO = data$dfilt, genes= genes$Down,
              category = "BP", nrows = bprowsdown)
    svg$gobarbpdown <- p
    print(p)
  })
  
  output$gobarBpDown <- downloadHandler(
    filename = "gobarbpdown.svg",
    content = function(file){
      ggsave(file, svg$gobarbpdown, device = "svg", width = 10, units = "in") }
  )
  # GO circle BP Down #####################
  output$goCircleDownBP <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( bprowsdown() , "Select at least 4 rows"))
    bprowsdown <- bprowsdown()
    if(length(bprowsdown)>=4){
      circ <- data2circle(go=go$down[bprowsdown, ], res=data$dfilt, genes=genes$Down)
      p <- circle(circ, label.size = 3, nsub = length(bprowsdown), table.legend = FALSE)
      svg$cirbpdown <- p
      print(p)
    }
  })
  output$cirBpDown <- downloadHandler(
    filename = "cirbpdown.svg",
    content = function(file){
      ggsave(file, svg$cirbpdown, device = "svg", width = 10, units = "in") }
  )
  # GO cloud BP Down #######################
  output$cloudBPDown <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    godown <- go$down[go$down$Ont=="BP", ]
    myggwordcloud(godown, bg = "#343e48")
  })
  
  output$cloudbpdown <- downloadHandler(
    filename = "cloudbpdown.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$down[go$down$Ont=="BP", ])
      dev.off()
    }
  )
  # ............ ###############################
  # GO table MF DOWN #####################
  output$tableMFdown <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$down, "Load file to render table"))
    goDT <- goDT$down
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-MF down-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="MFdown", title=tituloTabla ) )

    datatable2(goDT[goDT$Ont=="MF",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                           pageLength = 10, white_space = "normal",
                           buttons = customButtons,
                           ajax = list(serverSide = TRUE, processing = TRUE))
    )
  })
  # GO plots MF DOWN #####################
  output$plotMFdown <- renderPlotly({
    shiny::validate(need(go$down, "Load file to render plot"))
    mfrowsdown <- mfrowsdown()
    if(is.null(mfrowsdown)){mfrowsdown <- c(1:10)}
    gosMF <- go$down[go$down$Ont=="MF",]
    p <- plotGO(enrichdf = gosMF[mfrowsdown, ], nrows = length(mfrowsdown), ont = "MF",
           colors = c(input$downColor) )
    svg$barmfdown <- p
    plt <- p
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( mfrowsdown() )
    plt$x$layout$height <- myHeightfunction(mfrowsdown() )
    plt
  })
  
  output$barMfDown <- downloadHandler(
    filename = "barmfdown.svg",
    content = function(file){
      ggsave(file, svg$barmfdown, "svg", width = 10, units = "in") }
  )
  
  # GO MF dotplot down ################### 
  output$MFDotDown <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    shiny::validate(need(mfrowsdown(), "Select the terms of interest to render DotPlot"))
    mfrowsdown <- mfrowsdown()
    if(is.null(mfrowsdown)){mfrowsdown <- c(1:20)}
    gosMF <- go$down[go$down$Ont=="MF",]
    p <- dotPlotGO(gosMF[mfrowsdown,], n = length(mfrowsdown))
    svg$dotmfdown <- p
    print(p)
  }, height = reactive( myHeightfunction(mfrowsdown() ) ) )
  
  
  output$dotMfDown <- downloadHandler(
    filename = "dotmfdown.svg",
    content = function(file){
      ggsave(file, svg$dotmfdown, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot MF down #######################
  output$gobarplotDownMF <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    mfrowsdown <- mfrowsdown()
    p <- goBarplot(enrichGO = go$down, resGO = data$dfilt, genes= genes$Down,
              category = "MF", nrows = mfrowsdown)
    svg$gobarmfdown <- p
    print(p)
  })
  
  output$gobarMfDown <- downloadHandler(
    filename = "gobarmfdown.svg",
    content = function(file){
      ggsave(file, svg$gobarmfdown, device = "svg", width = 10, units = "in") }
  )
  # GO circle MF Down #####################
  output$goCircleDownMF <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( mfrowsdown() , "Select at least 4 rows"))
    mfrowsdown <- mfrowsdown()
    if(length(mfrowsdown)>=4){
      circ <- data2circle(go=go$down[mfrowsdown, ], res=data$dfilt, genes=genes$Down)
      p <- circle(circ, label.size = 3, nsub = length(mfrowsdown), table.legend = FALSE)
      svg$cirmfdown <- p
      print(p)
    }
  })
  output$cirMfDown <- downloadHandler(
    filename = "cirmfdown.svg",
    content = function(file){
      ggsave(file, svg$cirmfdown, device = "svg", width = 10, units = "in") }
  )
  # GO cloud MF Down #######################
  output$cloudMFDown <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    godown <- go$down[go$down$Ont=="MF", ]
    myggwordcloud(godown, bg = "#343e48")
  })
  
  output$cloudmfdown <- downloadHandler(
    filename = "cloudmfdown.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$down[go$down$Ont=="MF", ])
      dev.off()
    }
  )
  # ............ ###############################
  # GO table CC DOWN #####################
  output$tableCCdown <- DT::renderDataTable(server=FALSE,{
    shiny::validate(need(goDT$down, "Load file to render table"))
    goDT <- goDT$down
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-CC down-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <-  list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="CCdown", title=tituloTabla ) )

        datatable2(goDT[goDT$Ont=="CC",], vars = c("genes"),
               filter = list(position="top", clear=FALSE),
               escape = FALSE,
               opts = list(order = list(list(6, 'asc')),
                           pageLength = 10, white_space = "normal",
                           buttons = customButtons,
                           ajax = list(serverSide = TRUE, processing = TRUE))
    )
  })
  # GO plots CC DOWN #####################
  output$plotCCdown <- renderPlotly({
    shiny::validate(need(go$down, "Load file to render plot"))
    ccrowsdown <- ccrowsdown()
    if(is.null(ccrowsdown)){ccrowsdown <- c(1:10)}
    gosCC <- go$down[go$down$Ont=="CC",]
    plotGO(enrichdf = gosCC[ccrowsdown,], nrows = length(ccrowsdown), ont="CC",
           colors = c(input$downColor) )
    svg$barccdown <- p
    plt <- p
    
    plt <- plt %>% plotly::ggplotly(tooltip = "all" )
    plt$height <- myHeightfunction( ccrowsdown() )
    plt$x$layout$height <- myHeightfunction(ccrowsdown() )
    plt
  })
  
  output$barCcDown <- downloadHandler(
    filename = "barccdown.svg",
    content = function(file){
      ggsave(file, svg$barccdown, "svg", width = 10, units = "in") }
  )
  # GO CC dotplot down ################### 
  output$CCDotDown <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    shiny::validate(need(ccrowsdown(), "Select the terms of interest to render DotPlot"))
    ccrowsdown <- ccrowsdown()
    if(is.null(ccrowsdown)){ccrowsdown <- c(1:20)}
    gosCC <- go$down[go$down$Ont=="CC",]
    p <- dotPlotGO(gosCC[ccrowsdown,], n = length(ccrowsdown))
    svg$dotccdown <- p
    print(p)
  }, height = reactive( myHeightfunction(ccrowsdown() ) ) )
  
  
  output$dotCcDown <- downloadHandler(
    filename = "dotccdown.svg",
    content = function(file){
      ggsave(file, svg$dotccdown, device = "svg", width = 10, units = "in") }
  )
  # GO gobarplot CC down #######################
  output$gobarplotDownCC <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    ccrowsdown <- ccrowsdown()
    goBarplot(enrichGO = go$down, resGO = data$dfilt, genes= genes$Down,
              category = "CC", nrows = ccrowsdown)
    svg$gobarccdown <- p
    print(p)
  })
  
  output$gobarCcDown <- downloadHandler(
    filename = "gobarccdown.svg",
    content = function(file){
      ggsave(file, svg$gobarccdown, device = "svg", width = 10, units = "in") }
  )
  # GO circle CC Down #####################
  output$goCircleDownCC <- renderPlot({
    shiny::validate(need(go$down, "Load file to render dotPlot"))
    shiny::validate(need(data$dfilt,""))
    shiny::validate(need( ccrowsdown() , "Select at least 4 rows"))
    ccrowsdown <- ccrowsdown()
    if(length(ccrowsdown)>=4){
      circ <- data2circle(go=go$down[ccrowsdown, ], res=data$dfilt, genes=genes$Down)
      p <- circle(circ, label.size = 3, nsub = length(ccrowsdown), table.legend = FALSE)
      svg$circcdown <- p
      print(p)
    }
  })
  output$cirCcDown <- downloadHandler(
    filename = "circcdown.svg",
    content = function(file){
      ggsave(file, svg$circcdown, device = "svg", width = 10, units = "in") }
  )
  # GO cloud CC Down #######################
  output$cloudCCDown <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    godown <- go$down[go$down$Ont=="CC", ]
    myggwordcloud(godown, bg = "#343e48")
  })
  
  output$cloudccdown <- downloadHandler(
    filename = "cloudccdown.svg",
    content = function(file){
      svg(file, width = 8, height = 6)
      myggwordcloud(go$down[go$down$Ont=="CC", ])
      dev.off()
    }
  )
  # ...................... ###########
  # variables gsea ################
  gsearow <- reactive({input$gseaTable_rows_selected}) 
    # GSEA table ##########################
  output$gseaTable <- renderDataTable(server=FALSE,{
    shiny::validate(need(gsea$gsea, "Load file to render table"))
    mygsea <- gsea$gsea
    if( length(which(mygsea@result$p.adjust<=0.05)) == 0 ){
        createAlert(session, anchorId = "gsea", title = "Oops!!", 
          content = "Sorry, I didn't get any significant results for this analysis",
          append=FALSE, style = "info")
    } else{
    table <- mygsea@result[mygsea@result$p.adjust<=0.05 ,2:9] %>% 
      mutate_at(vars(3:7), ~round(., 4))

    tituloTabla <- paste0("Table: GSEA pathway | ",
                          "log2FC: ",logfc()[1],"_",logfc()[2],
                          " | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="GSEAkegg", title=tituloTabla ) )
    
    DT::datatable( table,
                   rownames=FALSE,
                   filter = list(position="top", clear=FALSE),
                   options = list(order = list(list(4, 'asc')),
                     lengthMenu = list(c(10,25,50,100,-1), c(10,25,50,100,"All")),
                     columnDefs = list(list(orderable = FALSE,
                                            className = "details-control",
                                            targets = 1)
                     ),
                     dom = "Bfrtipl",
                     buttons = customButtons,
                     list(pageLength = 10, white_space = "normal")
                   )
    )
    }
  })
  # GSEA plot ##########################
  output$gseaPlot <- renderPlot({
    shiny::validate(need(gsea$gsea, "Load file to render table"))
    gseanr <- gsearow()
    if(is.null(gseanr)){gseanr <- c(1)}
    mygsea <- gsea$gsea
    if( length(which(mygsea@result$p.adjust<=0.05)) == 0 ){
        createAlert(session, anchorId = "gseaPlot", title = "Oops!!", 
          content = "Sorry, I didn't get any significant results for this analysis",
          append=FALSE, style = "info")
    } else{
        p <- enrichplot::gseaplot2(gsea$gsea, geneSetID = gseanr, pvalue_table = TRUE, ES_geom = "line")
        svg$gseaplot <- p
        print(p)
        }
  })
  
  output$gseaButton <- downloadHandler(
    filename = "gseaplot.svg",
    content = function(file){
      ggsave(file, svg$gseaplot, device = "svg", width = 10, units = "in") }
  )
  # ...................... ###########
  # #### report #############################
    output$report <- renderUI({
      shiny::validate(need(enrichflag, "" ) )
      if(isTRUE(enrichflag$one) ){
        enrichflag$three <- FALSE
        actionButton("report1", "html report")
      }else if(isTRUE(enrichflag$three) ){
        enrichflag$one <- FALSE
        actionButton("report3", "html report")
      }
  })
  
  observeEvent(input$report3, {
      showModal(popupModal3())
    })
  
  observeEvent(input$unselect3,{
    if(input$unselect3 >0){
      if(input$unselect3 %% 2 == 0 ){
        selectPopUpModal3(session = session)
      }else{
        unselectPopUpModal3(session = session)
      }
    }
  })
  
  observeEvent(input$report1, {
      showModal(popupModal1())
    })

  observeEvent(input$unselect1,{
    if(input$unselect1 >0){
      if(input$unselect1 %% 2 == 0 ){
        selectPopUpModal1(session = session)
      }else{
        unselectPopUpModal1(session = session)
      }
    }
  })

  applyPress <- reactiveValues(ok=FALSE)
  observeEvent(input$ok,{
        applyPress$ok <- TRUE
        if(isTRUE(enrichflag$three)){
          vals$preview <- input$modalPreview
          vals$keggUp <- input$modalkeggUp
          vals$keggDown <- input$modalkeggDown
          vals$GOUp <- input$modalGOUp
          vals$GODown <- input$modalGODown
          vals$GSEA <- input$modalGSEA
        }
        vals$keggAll <- input$modalkeggAll
        vals$GOAll <- input$modalGOAll
        #removeModal()
  })
  
  output$downloadhtml <- renderUI({
    shiny::validate(need(isTRUE(applyPress$ok), ""))
    downloadButton("download", "Download report")
    })
  
    output$download <- downloadHandler(
    filename = "report.html",
    content = function(file) {
      removeModal()
      applyPress$ok <- FALSE
      tempReport <- file.path(tempdir(), "report.Rmd")
      if( dim(data$df)[2]==5 ){
      file.copy("report.Rmd", tempReport, overwrite = TRUE) }else{
        file.copy("report1col.Rmd", tempReport, overwrite = TRUE)
      }
      file.copy("report.css", file.path(tempdir(), "report.css"), overwrite = TRUE)
      file.copy("utilsReport.R", file.path(tempdir(),"utils.R"), overwrite = TRUE)
      file.copy("resources/", tempdir(), overwrite = TRUE, recursive = TRUE)
      file.copy("resources/dna-svg-small-13.gif",
      file.path(tempdir(), "resources/dna-svg-small-13.gif"), overwrite = TRUE)
      ## inicializar variables preview
      volcObj <- karyObj <- FALSE
      ## inicializar variables kegg
      tablekgaObj <- barkgaObj <- chorkgaObj <- dotkgaObj <- heatkgaObj <- netkgaObj <- FALSE
      tablekguObj <- barkguObj <- chorkguObj <- dotkguObj <- heatkguObj <- netkguObj <- FALSE
      tablekgdObj <- barkgdObj <- chorkgdObj <- dotkgdObj <- heatkgdObj <- netkgdObj <- FALSE
      ## inicializar variables Go
      cloudgoaObj <- tablegoaObj <- bargoaObj <- dotgoaObj <- gobargoaObj <- gocirclegoaObj <- FALSE
      cloudgouObj <- tablegouObj <- bargouObj <- dotgouObj <- gobargouObj <- gocirclegouObj <- FALSE
      cloudgodObj <- tablegodObj <- bargodObj <- dotgodObj <- gobargodObj <- gocirclegodObj <- FALSE
      ## inicializar variables GSEA
      tablegseaObj <- plotgseaObj <- FALSE 
      bprowsall <- bprowsall(); mfrowsall <- mfrowsall(); ccrowsall <- ccrowsall()
      bprowsup <- bprowsup(); mfrowsup <- mfrowsup(); ccrowsup <- ccrowsup()
      bprowsdown <- bprowsdown(); mfrowsdown <- mfrowsdown(); ccrowsdown <- ccrowsdown()
      gsearow <- gsearow()

          nrowsall <- rowsAll()
          if(!is.null(kggDT$all)){
            if(is.null(nrowsall)){ 
              nrowsall <-  ( if( dim(kggDT$all)[1]<10) seq_len(nrow(kggDT$all))
                             else seq_len(10) ) }
          }
          nrowsup <- rowsUp()
          if(!is.null(kggDT$up)){
            if(is.null(nrowsup)){ 
              nrowsup <-  ( if( dim(kggDT$up)[1]<10) seq_len(nrow(kggDT$up))
                            else seq_len(10) ) }
          }
          nrowsdown <- rowsDown()
          if(!is.null(kggDT$down)){
            if(is.null(nrowsdown)){ 
              nrowsdown <-  ( if( dim(kggDT$down)[1]<10) seq_len(nrow(kggDT$down))
                              else seq_len(10) ) }
          }
      if(!is.null(vals$preview)){      #para preview
        if("Volcano" %in% vals$preview){volcObj <- TRUE}
        if("Karyoplot" %in% vals$preview){ karyObj <- TRUE}
      }
      if(!is.null(vals$keggAll)){ #para keggAll
        if("Table" %in% vals$keggAll){ tablekgaObj <- TRUE }
        if("Barplot" %in% vals$keggAll){ barkgaObj <- TRUE }
        if("Chorplot" %in% vals$keggAll){ chorkgaObj <- TRUE }
        if("Dotplot" %in% vals$keggAll){ dotkgaObj <- TRUE }
        if("Heatmap" %in% vals$keggAll){ heatkgaObj <- TRUE }
        if("Netplot" %in% vals$keggAll){ netkgaObj <- TRUE }
      }
      if(!is.null(vals$keggUp)){ #para keggUp
        if("Table" %in% vals$keggUp){ tablekguObj <- TRUE }
        if("Barplot" %in% vals$keggUp){ barkguObj <- TRUE }
        if("Chorplot" %in% vals$keggUp){ chorkguObj <- TRUE }
        if("Dotplot" %in% vals$keggUp){ dotkguObj <- TRUE }
        if("Heatmap" %in% vals$keggUp){ heatkguObj <- TRUE }
        if("Netplot" %in% vals$keggUp){ netkguObj <- TRUE }
      }
      if(!is.null(vals$keggDown)){ #para keggDown
        if("Table" %in% vals$keggDown){ tablekgdObj <- TRUE }
        if("Barplot" %in% vals$keggDown){ barkgdObj <- TRUE }
        if("Chorplot" %in% vals$keggDown){ chorkgdObj <- TRUE }
        if("Dotplot" %in% vals$keggDown){ dotkgdObj <- TRUE }
        if("Heatmap" %in% vals$keggDown){ heatkgdObj <- TRUE }
        if("Netplot" %in% vals$keggDown){ netkgdObj <- TRUE }
      }
      if(!is.null(vals$GOAll)){#para GoAll
        if("WordCloud" %in% vals$GOAll){cloudgoaObj <- TRUE}
        if("Table" %in% vals$GOAll){ tablegoaObj <- TRUE }
        if("Barplot" %in% vals$GOAll){ bargoaObj <- TRUE }
        if("Dotplot" %in% vals$GOAll){ dotgoaObj <- TRUE }
        if("GObarplot" %in% vals$GOAll){ gobargoaObj <- TRUE }
        if("GOcircleplot" %in% vals$GOAll){ gocirclegoaObj <- TRUE }
      }
      if(!is.null(vals$GOUp)){#para GoUp
        if("WordCloud" %in% vals$GOUp){cloudgouObj <- TRUE}
        if("Table" %in% vals$GOUp){ tablegouObj <- TRUE }
        if("Barplot" %in% vals$GOUp){ bargouObj <- TRUE }
        if("Dotplot" %in% vals$GOUp){ dotgouObj <- TRUE }
        if("GObarplot" %in% vals$GOUp){ gobargouObj <- TRUE }
        if("GOcircleplot" %in% vals$GOUp){ gocirclegouObj <- TRUE }
      }
      if(!is.null(vals$GODown)){#para GoDown
        if("WordCloud" %in% vals$GODown){cloudgodObj <- TRUE}
        if("Table" %in% vals$GODown){ tablegodObj <- TRUE }
        if("Barplot" %in% vals$GODown){ bargodObj <- TRUE }
        if("Dotplot" %in% vals$GODown){ dotgodObj <- TRUE }
        if("GObarplot" %in% vals$GODown){ gobargodObj <- TRUE }
        if("GOcircleplot" %in% vals$GODown){ gocirclegodObj <- TRUE }
      }
      if(!is.null(vals$GSEA)){#para GSEA
        if( length(which(mygsea@result$p.adjust<=0.05)) == 0 ){
          tablegseaObj <- FALSE; plotgseaObj <- FALSE
        }else{
          if("Table" %in% vals$GSEA){ tablegseaObj <- TRUE}
          if("GSEA plot" %in% vals$GSEA){ plotgseaObj <- TRUE}
        }
        }

      params <- list( values = vals, datadf = data$df, datadfilt = data$dfilt, annotation=annotation(),
                     specie = specie(), padj =padj(), logfc = logfc(),
                     volcObj = volcObj, genesvolcano = genesVolcano(), 
                     upcolor = input$upColor, downcolor = input$downColor, 
                     karyObj = karyObj,
                     datagenesup = genes$Up, datagenesdown = genes$Down,
                     tablekgaObj = tablekgaObj, kggall = kgg$all, genesdedown = numgenesDE$down,
                     genesdeup = numgenesDE$up, kggdtall = kggDT$all,
                     barkgaObj = barkgaObj, nrowsall = nrowsall, typebarkeggall = typeBarKeggAll(),
                     chorkgaObj = chorkgaObj, dotkgaObj = dotkgaObj, heatkgaObj = heatkgaObj,
                     netkgaObj = netkgaObj, tablekguObj = tablekguObj, barkguObj = barkguObj,
                     chorkguObj = chorkguObj, dotkguObj =dotkguObj, heatkguObj = heatkguObj,
                     netkguObj = netkguObj, tablekgdObj = tablekgdObj, barkgdObj = barkgdObj,
                     chorkgdObj = chorkgdObj, dotkgdObj = dotkgdObj, heatkgdObj = heatkgdObj,
                     cloudgoaObj = cloudgoaObj, cloudgouObj = cloudgouObj, cloudgodObj = cloudgodObj,
                     netkgdObj = netkgdObj, kggup = kgg$up, kggdown = kgg$down, kggdtup = kggDT$up, 
                     kggdtdown = kggDT$down, nrowsup = nrowsup, nrowsdown = nrowsdown, 
                     typebarbpall=typeBarBpAll(), typebarmfall=typeBarMfAll(),
                     typebarccall=typeBarCcAll(),
                     tablegoaObj = tablegoaObj, bargoaObj=bargoaObj, dotgoaObj=dotgoaObj,
                     gobargoaObj=gobargoaObj,gocirclegoaObj=gocirclegoaObj, tablegouObj = tablegouObj,
                     bargouObj=bargouObj, dotgouObj=dotgouObj, gobargouObj=gobargouObj,
                     gocirclegouObj=gocirclegouObj, tablegodObj = tablegodObj, bargodObj=bargodObj,
                     dotgodObj=dotgodObj, gobargodObj=gobargodObj, gocirclegodObj=gocirclegodObj,
                     goall = go$all, godtall=goDT$all, goup = go$up, godtup=goDT$up,
                     godown = go$down, godtdown=goDT$down,
                     bprowsall=bprowsall, mfrowsall=mfrowsall, ccrowsall=ccrowsall,
                     bprowsup=bprowsup, mfrowsup=mfrowsup, ccrowsup=ccrowsup,
                     bprowsdown=bprowsdown, mfrowsdown=mfrowsdown, ccrowsdown=ccrowsdown,
                     gsearow = gsearow, gseagsea = gsea$gsea, tablegseaObj = tablegseaObj,
                     plotgseaObj = plotgseaObj, textnotes = input$textNotes)
      
      params <- c(params, list(tempdir=tempdir() ))
      rmarkdown::render(
        tempReport,
        output_file = file,
        params = params,
        envir = new.env(parent = globalenv( ))
      )
    } )
  

  
     
}
shinyApp(ui, server)
