library(shinydashboard)
library(AnnotationDbi)
library(org.Mm.eg.db) #Mus musculus
library(org.Hs.eg.db) #Homo sapiens
#library(org.Dr.eg.db) #Danio rerio (zebra fish)
library(org.Rn.eg.db) #Ratus norvegicus
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
source("utils.R")
options(shiny.maxRequestSize = 3000*1024^2)
  
### HEADER ############ 
header <- dashboardHeader(title = "RNAseq viewer and report App", 
                          titleWidth = 300, 
                          dropdownMenuOutput("messageMenu"),
                          tags$li(class="dropdown", actionButton("notesButton","Notes"),
                                  style="margin-top:8px; margin-right: 5px"),
                          tags$li(class = "dropdown", actionButton("aboutButton", "About"),
                                  style="margin-top:8px; margin-right: 5px")
)
### SIDEBAR ##########
sidebar <- dashboardSidebar(useShinyalert(),
                            useShinyjs(),
                            sidebarMenu(id="menupreview",
                              menuItem("App Information",
                                       tabName = "info",
                                       icon = icon("info"))),
                            sidebarMenu(
                                menuItem(
                                    pickerInput(
                                        inputId = "specie",
                                        label = "1. Select specie",
                                        choices = list( "Human" = "Hs",
                                                        "Mouse" = "Mm", "Ratus" = "Rn"),
                                        options = list(title = "specie"),
                                        selected = NULL
                                    ) 
                                )
                            ),
                            sidebarMenu(menuItem(uiOutput("matrixDeseq"))),
                            sidebarMenu(fluidRow(
                                        column(width=1,menuItem(uiOutput("circleinfoDO"))),
                                        column(width=11,menuItem(uiOutput("tooltipDO")),
                                        menuItem(uiOutput("deseqFile"))))),
                            sidebarMenu(fluidRow(
                                        column(width=1,menuItem(uiOutput("circleinfoCM"))),
                                        column(width=11,menuItem(uiOutput("tooltipCM")),
                                        menuItem(uiOutput("countFile"))))),
                            sidebarMenu(fluidRow(
                                        column(width = 11,
                                          menuItem(uiOutput("sampleFile"))))),
                            sidebarMenu(id="menuimport",sidebarMenuOutput("importvw")),
                            sidebarMenu(id = "previewMenu", sidebarMenuOutput("prevw")),
                            sidebarMenu("", sidebarMenuOutput("menu")),
                            tags$br(),
                            sidebarMenu(menuItem(uiOutput("design"))),
                            tags$div(
                            box(width = 12,
                            h5(strong("Generate report"), align = 'center'),
                              sidebarMenu( 
                                menuItem(
                                  fluidRow(column(12, align = "center", offset=0, uiOutput("report"))))),
                              sidebarMenu(
                                menuItem(
                                  fluidRow(column(12, align = "center", offset=0, uiOutput("pdf")))))
                            ),
                            tags$a(href='https://jacob.cea.fr/drf/ifrancoisjacob/Pages/Departements/MIRCen/themes/astrocytes-reactifs-biomarqueurs-imagerie-cibles-therapeutiques.aspx', target="_blank",
                                   tags$img(src='mircen.png',width='50%',
                                            style="padding: 5px; position: absolute; bottom:10px; left:0") ),
                            tags$a(href='http://www.bioinformatica.imib.es', target="_blank",
                                   tags$img(src='imib.png',width='50%',
                                            style="padding: 5px; float: right;") ),
                            
                            style = "position: absolute; bottom:0;width:100%;")
                            
)
                      

### BODY ###############
body <- dashboardBody(
    tags$script(HTML("$('body').addClass('fixed');")),
    add_busy_gif(src="dna-mini.gif", position = "full-page", width = 10, height = 10 ),
     # tags$head(
     #   tags$link(rel = "stylesheet", type = "text/css", href = "customDark.css")
     # ),
    includeCSS("./www/customDark.css"),
    setShadow(class = "shiny-plot-output"),
    setShadow( class = "box"),
    setShadow( class = "svg-container"),
    # shiny::tagList(shiny::tags$head(
    #     shiny::tags$link(rel = "stylesheet", type = "text/css", href = "busystyle.css"),
    #     shiny::tags$script(type = "text/javascript", src = "busy.js"))),
    # div( class = "busy",
    #     #h4("Loading data, please be patient..."),
    #     img(src = "dna-svg-small-13.gif", style = "width: 150px"),
    #     style = "z-index: 99"
    # ), 
  bsAlert("alert"),
  tabItems(
    # Initial INFO
    tabItem(tabName = "info",
            br(),
            fluidRow(column(offset = 2,width = 9,
            box(width=10,
                status = "info",
                title = h1(strong("Welcome to EnrichApp 2020!") ),
            h3("Before starting using the app"),
            p("As a initial files to run the analysis, 
                the program will import either a counting matrix with a table of sample information 
                (both in separated excel files) or a DeseqDataSet object, 
                generated by the DESeq function of the", 
              a("DESeq2", href="https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html"),
              "library and compress as a RDS file. 
              Make sure that your objects matched this and enjoy your enrichment analysis ;)"),
            br(),
            h3("Get the app ready to be used!"),
            p("First of all, select the specie of your experiment. 
              Then the option to choose between entering your count matrix / DESeq object  
              containing your analysis will be unlocked. Make your choice and upload your files. 
              Select your conditions and/or design and when the loading symbol stops moving, 
              you will be moved to the next tab! "
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
    ) )),
    # import tab ######
    tabItem(tabName = "tabimport",
            source(file = "ui-import-tab.R",
            local=TRUE,
            encoding = "UTF-8"
            )$value),
    # preview tab ######
    tabItem(tabName = "preview",
            source(file = "ui-preview-tab.R",
            local=TRUE,
            encoding = "UTF-8"
            )$value),
    # kegg tab content #####
    tabItem(tabName = "kegg",
            source(file = "ui-kegg-tab.R",
                   local = TRUE,
                   encoding = "UTF-8"
                   )$value),
    # GO tab GO tab ######
    tabItem( tabName = "go",
             source(file = "ui-go-tab.R",
                    local = TRUE,
                    encoding = "UTF-8",
                    )$value),
    # GSEA tab ######
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


# Definir reactiveVariables globales ##############
  coloresPCA <- reactiveValues(niveles=NULL, numNiveles=NULL)
  countdata <- reactiveValues() # para convertir count matrix y sample data
  countfile <- reactiveValues() # para leer count matrix y sample data
  data <- reactiveValues() # genes
  datos <- reactiveValues(dds=NULL) #objetos dds post DESeq()
  fcRange <- reactiveValues() # min y max fc
  go <- reactiveValues() # enrich GO
  goDT <- reactiveValues() #pretabla GO
  gsea <- reactiveValues() # objeto GSEA
  kgg <- reactiveValues() # enrich kegg
  kggDT <- reactiveValues() # pretabla kegg
  logfcRange <- reactiveValues() # min y max logfc
  numgenesDE <- reactiveValues(up=NULL, down=NULL)
  res <- reactiveValues()
  rlog <- reactiveValues()
  validateCountData <- reactiveValues(ok=FALSE) #para validar count y sample ok
  vals <- reactiveValues()
  vsd <- reactiveValues()
  
  observeEvent(input$deseqFile, {
      datos$dds <- readRDS(input$deseqFile$datapath)
  })
  
  observeEvent(datos$dds,{
        validate(need(datos$dds, ""))
          if(!is(datos$dds, "DESeqDataSet") | !("results" %in% mcols(mcols(datos$dds))$type) ){
          createAlert(session, "alert", "fileAlert",title = "Oops!!", 
          content = "File must be a DESeqDataSet class object
           and you should have run DESeq()", append=FALSE, style = "error")}
  })
  coloresPCA$colores <- reactive({
        tmp = NULL
      for(i in seq_len(coloresPCA$numNiveles)){
          tmp <- c(tmp, input[[ coloresPCA$niveles[i] ]] )
      }
      return(tmp)
  })

  # Acciones al pulsar boton generar DESeq ###################
  observeEvent(input$applyTest, {
    countdata$sample <- countdata$sample %>% mutate_at(.vars = vars(-1), ~as.factor(.) )
    deseqObj <- DESeqDataSetFromMatrix(countData = countdata$count, 
                                        colData = DataFrame(countdata$sample),
                                        design = ~1)
    design(deseqObj) <- as.formula(paste("~", input$testVariablePicker ))
    if(input$testAlgorithmPicker == "wald"){
      datos$dds <- DESeq(deseqObj, test = "Wald")
    }
    if(input$testAlgorithmPicker == "ltr"){
      datos$dds <- DESeq(deseqObj, test = "LTR", reduced = ~1, parallel = TRUE)
      }
  })
  # Acciones al cargar fichero deseq ##########################
  observeEvent(design(), {
    validate(need(design(), ""))
        closeAlert(session, "alert")
          colData(datos$dds)@listData <-
              colData(datos$dds)@listData %>%
              as.data.frame() %>% mutate_at(vars(-sizeFactor, contains('replaceable')), as.character) %>% ##aqui##
              mutate_at(vars(-sizeFactor, contains('replaceable')), as.factor) %>% as.list()
        res$sh <- as.data.frame(lfcShrink(datos$dds, coef=(as.numeric(design())+1), type="apeglm", parallel = TRUE))
        res$sh <- res$sh[!is.na(res$sh$padj),]
        conversion <- geneIdConverter(rownames(res$sh), specie() )
        res$sh$baseMean <- round(res$sh$baseMean,4)
        res$sh$lfcSE <- round(res$sh$lfcSE,4)
        res$sh$log2FoldChange <- round(res$sh$log2FoldChange,4)
        res$sh <- cbind(`Description`=conversion$description, res$sh)
        res$sh <- cbind(`GeneName_Symbol`=conversion$consensus, res$sh)
        #res$sh$padj <- res$sh$pvalue  ##
        res$sh <-  res$sh %>% dplyr::select(-c(pvalue))
        if(specie() == "Mm" ){spc = "Mus_musculus"}
        else {spc = "Homo_sapiens"}
        links = paste0("<a href='http://www.ensembl.org/",spc,"/Gene/Summary?db=core;g=",
                       rownames(res$sh),"' target='_blank'>",rownames(res$sh),"</a>")
        res$sh <- cbind(`GeneName_Ensembl`= links, res$sh)
        vsd$data <- vst(datos$dds)
        rlog$datos <- rlog(datos$dds)
        logfcRange$min <- min(res$sh$log2FoldChange)
        logfcRange$max <- max(res$sh$log2FoldChange)
        fcRange$min <- ifelse(logfcRange$min<0, -(2^abs(logfcRange$min)), 2^abs(logfcRange$min))
        fcRange$max <- ifelse(logfcRange$max<0, -(2^abs(logfcRange$max)), 2^abs(logfcRange$max))
        closeAlert(session, "fileAlert")
        updateTabItems(session, "previewMenu", "preview")
  })
  
  # Acciones al pulsar el boton enrich #####################
  observeEvent(input$runEnrich, {
    data$genesUp <- getSigUpregulated(res$sh, padj(), logfc()[2], specie() ) 
    data$genesDown <- getSigDownregulated(res$sh, padj(), logfc()[1], specie() ) 
    data$genesall <- rbind(data$genesUp, data$genesDown)
    
    kgg$all <- customKegg(data$genesall, species = specie() ) #"Mm"), species.KEGG = "mmu")
    kggDT$all <- kegg2DT(kgg$all, data$genesall)
    
    kgg$up <- customKegg(data$genesUp, species = specie() ) #"Mm")#, species.KEGG = "mmu")
    kggDT$up <- kegg2DT(kgg$up, data$genesUp)
    
    kgg$down <- customKegg(data$genesDown, species = specie() ) # "Mm")#, species.KEGG = "mmu")
    kggDT$down <- kegg2DT(kgg$down, data$genesDown)
    
    go$all <- customGO(data$genesall, species = "Mm")
    goDT$all <- go2DT(enrichdf = go$all, data = data$genesall )
    
    go$up <- customGO(data$genesUp, species = "Mm")
    goDT$up <- go2DT(enrichdf = go$up, data = data$genesUp )
    
    go$down <- customGO(data$genesDown, species = "Mm")
    goDT$down <- go2DT(enrichdf = go$down, data = data$genesDown )
    updateTabItems(session, "previewMenu", "preview")
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
  
  # Acciones al seleccionar variables ################
  observeEvent(input$variables, {
        if(!is.factor(colData(datos$dds)[[ variables()[1] ]] ) ){
          coloresPCA$niveles <- as.character(unique( colData(datos$dds)[[ variables()[1] ]] ))
      } else {
          coloresPCA$niveles <- as.character(levels(colData(datos$dds)[[ variables()[1] ]]))
      }
      coloresPCA$numNiveles <- length(coloresPCA$niveles)
  })
  
  # generate reactive variable ###################
  rowsAll <- reactive({input$tableAll_rows_selected})
  rowsUp <- reactive({input$table_rows_selected})
  rowsdown <- reactive({input$tableDown_rows_selected})
  
  bprowsall <- reactive({input$tableBPall_rows_selected}) 
  mfrowsall <- reactive({input$tableMFall_rows_selected})
  ccrowsall <- reactive({input$tableCCall_rows_selected})
  
  bprowsup <- reactive({input$tableBP_rows_selected})
  mfrowsup <- reactive({input$tableMF_rows_selected})
  ccrowsup <- reactive({input$tableCC_rows_selected})
  
  bprowsdown <- reactive({input$tableBPdown_rows_selected})
  mfrowsdown <- reactive({input$tableMFdown_rows_selected})
  ccrowsdown <- reactive({input$tableCCdown_rows_selected})
  
  variables <- reactive({input$variables})
  genesVolcano <- reactive({input$genesVolcano})
  samplename <- reactive({input$samplename})
  gsearow <- reactive({input$gseaTable_rows_selected})
  specie <- reactive({input$specie})
  
  biologicalText <- reactive({input$biologicalText})
  explainPreview <- reactive({input$explainPreview})
  keggAllText <- reactive({input$keggAllText})
  GSEAText <- reactive({input$GSEAText})
  specie <- reactive({input$specie})
  numheatmap <- reactive({input$numheatmap})
  gene <- reactive({input$gene})
  typeBarKeggAll <- reactive({input$selectkeggall})
  typeBarBpAll <- reactive({input$selectbpall})
  typeBarMfAll <- reactive({input$selectmfall})
  typeBarCcAll <- reactive({input$selectccall})
  pca3d <- reactive({input$pca3d})
  boxplotswitch <- reactive({input$boxplotswitch})
  design <- reactive({input$designPicker})
  fc_switch <- reactive({input$fc_switch})
  
  # Matrix or DESeq ##############
  output$matrixDeseq <- renderUI({
      validate(need(specie(), ""))
      pickerInput("matrixDeseq",
          label = "2. Select input mode",
          choices = list("Count matrix"="cm", "DESeq object"="do"),
          selected = NULL,
          options = list(title = "mode")
          )
  })
  # ...... Count/sample File .......############
  
  # Render infoCM
  output$infoCM <- renderUI({
    validate(need(input$deseqFile, "")) 
    })
  
  # Render infoDO
  output$infoCM <- renderUI({
    validate(need(input$countFile,"")) 
  })
  
  
  # Tooltip de CountMAtrix ##################
  output$circleinfoCM <- renderUI({
    validate(need(input$matrixDeseq =="cm", ""))
    circleButton(
      inputId = "infoCM",
      icon = icon("info"),
      size = "xs",
      status = "primary"
    ) 
  })
  output$tooltipCM <- renderUI({
    validate(need(input$matrixDeseq =="cm", ""))
    bsTooltip(
      "infoCM",
      paste0("The accepted formats are .txt, .tsv, .xlsx"),
      trigger = "hover",
      placement = "right"
    )
  })
   # Render fileInput ########
      output$countFile <- renderUI({
      validate(need(input$matrixDeseq =="cm", ""))
      fileInput("countFile",
          "3. Choose file with counts",
          placeholder = "Counts",
          accept = c(".txt", ".tsv", ".xlsx") )
  })
     # Leer fichero count data #######
        observeEvent(input$countFile, {
        if(grepl("spreadsheet",input$countFile$type)){
            countfile$count <- readxl::read_xlsx(input$countFile$datapath)
            countdata$count <- countfile$count %>% data.frame(., row.names = 1)
        }else{
            countfile$count <- data.table::fread(input$countFile$datapath, nThread = 4,
                              header = TRUE,
                              )
            countdata$count <- countfile$count %>% data.frame(., row.names = 1)
        }
  })
    # Render sampleInput ########
      output$sampleFile <- renderUI({
      validate(need(input$matrixDeseq =="cm", ""))  
      fileInput("sampleFile",
          "4. Choose file with sample data",
          placeholder = "Sample",
          accept = c(".txt", ".tsv", ".xlsx") )
  })
     # Leer fichero sample data ########
        observeEvent(input$sampleFile, {
        if(grepl("spreadsheet",input$sampleFile$type)){
            countfile$sample <- readxl::read_xlsx(input$sampleFile$datapath)
            countdata$sample <- countfile$sample %>% data.frame()
            rownames(data$sample) <- data$sample[,1]
        }else{
            file$sample <- data.table::fread(input$sampleFile$datapath, nThread = 4,
                              header = TRUE,
                              )
            countdata$sample <- countfile$sample %>% data.frame()
            rownames(countdata$sample) <- countdata$sample[,1]
        }
  })
    observe({
      validate(need(input$sampleFile, ""))
      validate(need(input$countFile, ""))
      samplesCount <- sort(colnames(countdata$count))
      samplesSample <- sort(countdata$sample[,1])
      if( is_empty(which(samplesSample != samplesCount ) )){
        countdata$count <- countdata$count %>% select(countdata$sample[,1])
        validateCountData$ok = TRUE
      } else {
      shinyalert("Sorry!!", "At least one sample name is inconsistent between the two tables", type = "error")
        validateCountData$ok =FALSE
      }
    })
  ######........###############################
  # tooltip DEseqFile ############
    output$circleinfoDO <- renderUI({
      validate(need(input$matrixDeseq =="do", ""))
       circleButton(inputId = "infoDO",
                    icon = icon("info"),
                    size = "xs",
                    status = "primary"
                    )
    })
    output$tooltipDO <- renderUI({
      validate(need(input$matrixDeseq =="do", ""))
      bsTooltip(
      "infoDO",
      paste0("The file must be compressed as .RDS"),
      trigger = "hover",
      placement = "right"
      )
    })
  # InputFile #################
  output$deseqFile <- renderUI({
      validate(need(input$matrixDeseq =="do", ""))
      fileInput("deseqFile",
          "3. Choose DESeq object",
          placeholder = "RDS DESeq",
          accept = ".Rds")
  })
  
  # InputDesign ###########################
  output$design <- renderUI({
        validate(need(datos$dds,""))
          opciones <- as.list(seq_len(length(resultsNames(datos$dds)[-1] )))
          names(opciones) <- resultsNames(datos$dds)[-1]
          pickerInput(
          inputId = "designPicker",
          label = "Select design",
          choices = opciones,
          options = list(title = "Design"),
          selected = NULL
        ) 
          })
  
  # side bar menu ####################
  output$menu <- renderMenu({
      validate(need(kgg$all, ""))
      sidebarMenu(
          menuItem(
              "Kegg Enrichment",
              tabName = "kegg",
              icon = icon("chart-bar")
          ),
          menuItem(
              "GO Enrichment",
              tabName = "go",
              icon = icon("chart-bar")
          ),
          menuItem("GSEA",
                   tabName = "gsea",
                   icon = icon("chart-line"))
      )
      })
  
  output$prevw <- renderMenu({
    validate(need(res$sh, ""))
    sidebarMenu(
      menuItem("Preview dataset",
               tabName = "preview",
               icon = icon("eye"))
    )
  })
  
  output$importvw <- renderMenu({
    validate(need(countdata$sample,""))
    validate(need(countdata$count,""))
    menuItem("5. Import view",
             tabName = "tabimport",
             icon = icon("file-import"))
  })
  # ui selector sample groups ###################
  output$sampleGroup <- renderUI({
    validate(need(datos$dds, ""))
    nvars <- colData(datos$dds) %>% 
      as.data.frame() %>% 
      dplyr::select(-any_of(c("sizeFactor", "replaceable"))) %>% 
      names()
    selectInput("variables", label="Select condition[s] of interest to highlight",
                choices = nvars,
                selected = nvars[1],
                multiple = TRUE)
  })
  # ........................####
  # Variable Selector ###########
    output$testVariable <- renderUI({
        validate(need(countdata$sample,""))
        opciones <- as.list(names(countdata$sample))
          #names(opciones) <- resultsNames(datos$dds)[-1]
        pickerInput(
          inputId = "testVariablePicker",
          label = "6. Select variable to test",
          choices = opciones,
          options = list(title = "Variable"),
          selected = NULL
        ) 
          })
  # TextTestAlgorithm ###############
  output$textTestAlgorithm <- renderUI({
    validate(
      need(
        ( !is.null(input$testVariablePicker) & input$testVariablePicker != ""),"")
      )
    HTML(paste0(tags$p("Select Wald's test or Likelihood Ratio Test."),
    tags$p("Wald's test performs pairwise test using first category as reference."),
    tags$p("LTR performs comparison between full and reduced model"),tags$br()
    ))
  })
  # testAlgorithm #################
  output$testAlgorithm <- renderUI({
    validate(
      need(
        ( !is.null(input$testVariablePicker) & input$testVariablePicker != ""),"")
      )
    pickerInput(
          inputId = "testAlgorithmPicker",
          label = "7. Select test",
          choices = list("Wald" = "wald", "LTR" = "ltr"),
          options = list(title = "Test"),
          selected = NULL
        )
  })
  # Test Button ##########
  output$testButton <- renderUI({
    validate(
      need(( !is.null(input$testAlgorithmPicker) & input$testAlgorithmPicker != ""),"")
      )
    actionButton("applyTest", label = "Click to generate DESeq object")
  })
  
  # Tabla colData ################
  output$coldataTable <- renderDT({
    validate(need(countdata$sample,""))
    countdata$sample %>% datatable()
  })
    # Tabla countData ################
  output$expressionTable <- DT::renderDataTable({
    validate(need(countdata$sample,""))
    countdata$count %>% head(10) %>% DT::datatable()
  })
  
  # ........................####
  # ui selector de genes para volcano plot #######################
  output$geneSelector <- renderUI({
    validate(need(res$sh, ""))
    validate(need(padj(),""))
    genes <- as.character(res$sh$GeneName_Symbol[ which(!( res$sh$padj>padj() &
                                                             res$sh$log2FoldChange>logfc()[1] &
                                                             res$sh$log2FoldChange<logfc()[2] )) ])
    selectInput("genesVolcano", label="Select gene[s] to label",
                choices = genes,
                multiple = TRUE)
  })
  # ui selector sample name ###################
  output$samplesName <- renderUI({
    validate(need(datos$dds, ""))
    nvars <- colData(datos$dds) %>% 
      as.data.frame() %>% 
      dplyr::select(-any_of(c("sizeFactor", "replaceable"))) %>% 
      names()
    selectInput("samplename", label="Select column to use for sample name or gathering",
                choices = nvars,
                multiple = FALSE)
  })
  
  # Deslizador fc/logfc según switch #################
  output$fc_control <- renderUI({
    if(isTRUE(fc_switch())){
      validate(need(datos$dds, ""))
      valmin <- ifelse(input$logfc[1]<0, -2^(abs(input$logfc[1] )), 2^(abs(input$logfc[1])) )
      valmax <- ifelse(input$logfc[2]<0, -2^(abs(input$logfc[2] )), 2^(abs(input$logfc[2])) )
      sliderInput("fc", label = "Select FC range to remove (keeps the tails)",
                  min=round(fcRange$min,3), max=round(fcRange$max, 3),
                  value = c(valmin, valmax), step = 0.1 )
    } else {
      validate(need(datos$dds, ""))
      validate(need(fc(), ""))
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
  
  # # ui selector fc #######################
  # output$fc <- renderUI({
  #   validate(need(datos$dds, ""))
  #   sliderInput("fc", label = "Select FC range to remove (keeps the tails)",
  #               min=round(fcRange$min,3), max=round(fcRange$max, 3),
  #               #value = c(round(logfcRange$min,3)+1,round(logfcRange$max,3)-1 ), step = 0.1 )
  #               value = c(-1.5,1.5), step = 0.1 )
  # })
  # 
  # # ui selector logfc #######################
  # output$logfc <- renderUI({
  #   validate(need(datos$dds, ""))
  #   validate(need(fc(), ""))
  #   valmin <- ifelse(fc()[1]<0, -log2(abs(fc()[1])), log2(abs(fc()[1])) )
  #   valmax <- ifelse(fc()[2]<0, -log2(abs(fc()[2])), log2(abs(fc()[2])) )
  #   sliderInput("logfc", label = "Select logFC range to remove (keeps the tails)",
  #               min=round(logfcRange$min,3), max=round(logfcRange$max, 3),
  #               #value = c(round(logfcRange$min,3)+1,round(logfcRange$max,3)-1 ), step = 0.1 )
  #               value = c(valmin, valmax), #value = c(-0.5,0.5), 
  #               step = 0.1 )
  # })
  
  # ui selector padj #################################
  output$padj <- renderUI({
    validate(need(datos$dds,""))
    sliderInput("padj", label = "Select p-adjusted threshold", min = 0, max=0.2,
                value=0.05, step = 0.005 )
  })
  # ui selector Colores para PCA y demás #######################
  output$colorPalettes <- renderUI({
      validate(need(datos$dds, ""))
      validate(need(variables(), ""))
      validate(need(coloresPCA$numNiveles, ""))
      l1 <- rep(1:6, times = coloresPCA$numNiveles / 6 , length.out = coloresPCA$numNiveles)
      l2 <- rep(1:9, each = 6, length.out = coloresPCA$numNiveles)
      selectores <- lapply(seq_len(coloresPCA$numNiveles), function(x){
          spectrumInput(
            inputId = paste0(coloresPCA$niveles[x]),
            label = paste0("Select ",coloresPCA$niveles[x]," color"),
            selected = choices_brewer2[[l1[x]]][l2[x]],
            choices = choices_brewer2,
            width = "50%",
            options = list(`toggle-palette-more-text` = "Show more")
            )
      })
  })
 
  # infoboxes ###############################
  output$allbox <- renderInfoBox({
      validate(need(res$sh, ""))
      validate(need(padj(), ""))
      validate(need(logfc(), ""))
      numall <- nrow( res$sh[ ((res$sh$log2FoldChange >= logfc()[2] |
                                    res$sh$log2FoldChange< logfc()[1]) &
                                   res$sh$padj <= padj() ),] ) 
      infoBox("All DE genes", numall, icon = icon("arrows-alt-v"), color = "light-blue", fill = TRUE)
  })
  output$upbox <- renderInfoBox({
      validate(need(res$sh, ""))
      validate(need(padj(), ""))
      validate(need(logfc(), ""))
      numup <- nrow( res$sh[(res$sh$log2FoldChange >= logfc()[2]) & (res$sh$padj <= padj()), ]) 
      numgenesDE$up <- numup
      infoBox("Upregulated genes", numup, icon = icon("thumbs-up", lib = "glyphicon"), color = "light-blue", fill=TRUE)
  })
  output$downbox <- renderInfoBox({
      validate(need(res$sh, ""))
      validate(need(padj(), ""))
      validate(need(logfc(), ""))
      numdown <- nrow( res$sh[(res$sh$log2FoldChange <= logfc()[1]) & (res$sh$padj <= padj()), ])
      numgenesDE$down <- numdown
      infoBox("Downregulated genes", numdown, icon = icon("thumbs-down", lib = "glyphicon"), color = "light-blue", fill=TRUE)
  })
  
  output$fcdown <- renderUI({
        validate(need(logfcRange$min, ""))
        validate(need(logfc(),""))
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
        validate(need(logfcRange$min, ""))
        validate(need(logfc(),""))
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
      validate(need(padj(), ""))
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

  # preview samples ###################
  output$samples <- DT::renderDataTable(server = TRUE,{
    validate(need(datos$dds, "Load file to render table"))
    metadata <- as.data.frame(colData(datos$dds)) %>% dplyr::select(-any_of(c("sizeFactor", "replaceable")))
    tituloTabla <- paste0("Table: ColData | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
        list(extend = "copy", title=tituloTabla),
        list(extend="collection", buttons = c("csv", "excel"),
             text="Download", filename="coldata", title=tituloTabla ) )
    
    datatable( metadata, extensions = "Buttons",
               rownames=FALSE,
               filter = list(position="top", clear=FALSE),
               options = list(
                 columnDefs = list(list(orderable = TRUE,
                                        className = "details-control",
                                        targets = 1),
                                   list(className = "dt-right", targets = 1:(ncol(metadata)-1))
                 ),
                 dom = "Bfrtipl",
                 buttons = customButtons,
                 list(pageLength = 10, white_space = "normal")
               )
    )
  })  
  # preview table ###################
  output$preview <- DT::renderDT(server=FALSE,{
    validate(need(datos$dds, "Load file to render table"))
    validate(need(res$sh, "Load file to render table"))
    res.sh <- res$sh
    res.sh <- res.sh[ ((res.sh$log2FoldChange >= logfc()[2] |
                          res.sh$log2FoldChange < logfc()[1]) &
                         res.sh$padj <= padj() ),]
    tituloTabla <- paste0("Table: Expression values | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="expressionValues", title=tituloTabla ) )

    datatable( res.sh, extensions = "Buttons", escape = FALSE,
               rownames = FALSE,
               filter = list(position="top", clear=FALSE),
               options = list(order = list(list(6, 'asc')),
                 lengthMenu = list(c(10,25,50,100,-1), c(10,25,50,100,"All")),
                 columnDefs = list(list(orderable = TRUE,
                                        className = "details-control",
                                        targets = 1),
                                   list(className = "dt-right", targets = 1:(ncol(res.sh)-1))
                 ),
                 rowCallback = JS(
                   "function(row, data) {",
                   "for (i = 6; i < 8; i++) {",
                   "if (data[i]>1000 | data[i]<1){",
                   "$('td:eq('+i+')', row).html(data[i].toExponential(3));",
                   "}",
                   "}",
                   "}"),
                 dom = "Bfrtipl",
                 buttons = customButtons,
                 list(pageLength = 10, white_space = "normal")
               )
    )
  })
# ............ #############
  # view pca plot data ###################
output$pca3 <- renderUI({
      if (!isTRUE(pca3d())) {
          plotlyOutput("pca", width = "100%", height = "800px")
      } else{
          rglwidgetOutput("pca3d", width = "500px", height = "500px")
      }
  })

output$pca <- renderPlotly({
    validate(need(!isTRUE(pca3d()), ""))
    validate(need(datos$dds, ""))
    validate(need(variables(), "Select condition to render PCA"))
    validate(need(samplename(), ""))
    validate(need(coloresPCA$colores(), ""))
    plotPCA(
        rlog$datos,
        intgroup = variables(),
        labels = samplename(),
        customColor = coloresPCA$colores()
    ) +
        theme(plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) +
        scale_size_manual(values = 3) +
        theme(text = element_text(size = 16))
})

output$pca3d <- renderRglwidget({
    validate(need(datos$dds, ""))
    validate(need(variables(),"Select condition to render PCA" ) )
    validate(need(coloresPCA$colores(), "" ))
    d <- pca3dplot(rlog$datos, intgroup = variables(), ntop = 500,
                   returnData = TRUE )
    levels(d$labels) <- coloresPCA$colores()
    try(rgl.close(), silent = TRUE)
    rgl.open(useNULL = TRUE) 
    x = d$PC1; y = d$PC2; z = d$PC3
    plot3d(x,y,x, size = 2, type="s", col = (d$labels),
           box=FALSE, axes=FALSE, xlab = names(d)[1],
           ylab=names(d)[2], names(d)[3])
    bg3d(sphere = FALSE, fogtype = "none", color = "#46505a")#"#dadee3" )
    #rgl.bbox(xlen=0, ylen=0, zlen=0)
    rgl.lines(c(min(x), max(x)), c(0, 0), c(0, 0), color = "white")
    rgl.lines(c(0, 0), c(min(y),max(y)), c(0, 0), color = "white")
    rgl.lines(c(0, 0), c(0, 0), c(min(z),max(z)), color = "white")
    rglwidget()
  })
  
  # view Volcano plot data ###################
   output$volcano <- renderPlot( {
    #validate(need(datos$dds, "Load file and condition to render Volcano"))
    validate(need(res$sh, "Load file to render plot"))
    res <-  res$sh
    #res$`-log10padj` <- (-log10(res$padj)) 
    CustomVolcano(res, lab = as.character(res$GeneName_Symbol),
                  selectLab = genesVolcano(),
                    x = 'log2FoldChange',
                    y = 'padj',
                    pCutoff = padj(),
                    FCcutoffUP = logfc()[2],
                    FCcutoffDOWN = logfc()[1],
                    drawConnectors=TRUE,
                    #xlim = c(-8, 8),
                    col = c("gray", "#7cccc3", "#d99c01", input$upColor, input$downColor))
    })
    #volcany(res$sh, padj=padj(), fcdown=logfc()[1], fcup=logfc()[2],
    #        col=c(input$upColor, input$downColor), genes=genesVolcano() )
  
xy <- reactive({
  res <- res$sh
  res$`-log10padj` <- (-log10(res$padj)) 
  nearPoints(res, input$plot_click1, xvar = "log2FoldChange", yvar = "-log10padj")
})
output$texto1 <- renderTable( digits = -2, {
        xy <- xy()
        xy[,c(2,5,7,8)]
    })

# view MA plot data ###################
  output$MA <- renderPlot( {
    #validate(need(datos$dds, ""))
    validate(need(res$sh, "Load file to render plot"))
    validate(need(logfc(), ""))
    MA(res$sh, main = 'MA plot applying the DESeq2 Shrinkage normalization for Foldchange',
       fdr = padj(), fcDOWN = logfc()[1], fcUP = logfc()[2] , size = 1.5,
       palette = c(input$upColor, input$downColor, "gray"),
       genenames = res$sh$GeneName_Symbol,
       legend = "top", top = 15, select.top.method = c('padj','fc'),
       font.label = c("plain", 12),
       font.legend = c("plain", 15),
       font.main = "plain",
       cex.axis = 1.1, cex.lab = 1.3,
       ggtheme = theme_classic()
    )
  })

clicked <- reactive({
  res <- res$sh
  res$`log2(mean - 1)` <- log2(res$baseMean + 1)
  nearPoints(res, input$plot_click2, xvar = "log2(mean - 1)", yvar = "log2FoldChange")
})

output$texto2 <- renderTable( digits = -2, {
  clicked <- clicked()
  clicked[,c(2,5,7,8)]
} )

  # view HEATMAP data ###################
  output$heat <- renderPlotly( {
    validate(need(datos$dds, ""))
    validate(need(vsd$data, "Load file to render plot"))
    validate(need(variables(),"Load condition to render plot" ) )
    validate(need(samplename(),"Load condition to render plot" ) )
    heat2(vsd$data, n=numheatmap(), intgroup = variables(), sampleName = samplename(),
         specie=specie(), customColor = coloresPCA$colores() )
  })
  # view CLUSTER data ###################
  output$cluster <- renderPlotly( {
    validate(need(datos$dds, ""))
    validate(need(vsd$data, "Load file to render plot"))
    validate(need(variables(),"Load condition to render plot" ) )
    validate(need(samplename(),"Load condition to render plot" ) )
    cluster(vsd$data, intgroup = samplename())
  })
# view TOP6 data ###################
  output$top6 <- renderPlotly( {
    validate(need(datos$dds, ""))
    validate(need(res$sh, "Load file to render plot"))
    validate(need(variables(),"Load condition to render plot" ) )
    validate(need(coloresPCA$colores(), ""))
    topGenes <- rownames(res$sh)[order(res$sh$padj)][1:6]
    topSymbol <- as.character(res$sh$GeneName_Symbol)[order(res$sh$padj)][1:6]
    z <- lapply(topGenes, function(x) plotCounts(dds=datos$dds, gene=x,
                                                 res=res$sh, intgroup = variables(),
                                                 returnData = TRUE))
    z <- lapply(z, function(x){x %>% group_by(!!as.name(variables()[1])) %>%
        mutate(mean = round(mean(count),2), sem = round(sd(count)/sqrt(n()),3 ), n = n() ) %>% 
        mutate(text = paste0("Mean: ",mean,"\n","SEM: ",sem)) } )
    z <- do.call(rbind, z)
    z$symbol <- rep(topSymbol, each =(nrow(z)/6) ) 
    z[[variables()[1]]] <- as.factor(z[[variables()[1]]])
    p <- ggplot(z, aes_(as.name(variables()), ~count, colour = as.name(variables()[1] ), text = ~text ) ) + 
      scale_y_log10() +
      geom_point(position = position_jitter(width = 0.1, height = 0), size = 2) +
      facet_wrap(~symbol) + scale_color_manual( values = coloresPCA$colores() ) +
      ggtitle("Expression of top 6 most significant genes")
    p %>% ggplotly(tooltip = c("x","y","text"))
    })
# view TOP1 data ###################  
  output$top1 <- renderPlotly( {
    validate(need(datos$dds, ""))
    validate(need(res$sh, "Load file to render plot"))
    validate(need(variables(),"Load condition to render plot" ) )
    validate(need(coloresPCA$colores(), ""))
    validate(need(gene(), "Enter a gene of interest in Ensembl or symbol name"))
    gene <- gene()
    if (grepl("^ENS", gene, ignore.case = TRUE)) {
        gene <- toupper(gene)
        z <- plotCounts(dds = datos$dds,gene = gene, returnData = TRUE,
                        intgroup = variables()[1])
        symbol = as.character(res$sh$GeneName_Symbol[rownames(res$sh) == gene])
    } else{
        if (specie() == "Mm" | specie() == "Rn") {
            gene <- stringr::str_to_title(gene)
        }
        else{
            gene = toupper(gene)
        }
        z <- plotCountsSymbol(dds = datos$dds, gene = gene, returnData = TRUE,
                              intgroup = variables()[1], specie=specie())
        symbol <- gene
    }
    z <- z %>% group_by(!!as.name(variables()[1])) %>%
        mutate(mean = round(mean(count),2), sem = round(sd(count)/sqrt(n()),3 ), n = n() ) %>% 
        mutate(text = paste0("Mean: ",mean,"\n","SEM: ",sem))
    p <- z %>% ggplot(aes_(as.name(variables()[1]), ~count, colour = as.name(variables()[1] ),
                           text = ~text) ) + scale_y_log10() +
        geom_point(position = position_jitter(width = 0.1, height = 0), size = 2)+
        scale_color_manual( values = coloresPCA$colores() )+
        ggtitle(paste0(symbol) )
    # texto del plot1 #############
    output$top1text <- renderUI({
        validate(need(gene(), ""))
        texto <- as.data.frame(unique(z[ ,c(variables()[1],"text") ] ))
        txt <- paste0(apply(texto, 1, function(x){x} ), collapse = "<br/><br/>")
        txt <- gsub("\n","<br/>",txt)
        tags$h5(HTML(txt))
    })
    p %>% ggplotly(tooltip = c("x","y","text"))
  })
## karyoplot ######################################
output$karyoPlot <- renderPlot({
    validate(need(res$sh, "Load file to render plot"))
    krtp(res$sh, specie = specie(), pval = padj(), fcdown = logfc()[1],
         fcup = logfc()[2], bg="#46505a", coldown="#4ADBFF" , colup="#f7665c")
})

 # Boxviolin plot #################################
  output$boxviolin <- renderPlotly({
          validate(need(datos$dds, "Load file and condition to render Volcano"))
          validate(need(variables(),"Load condition to render plot" ) )
          validate(need(vsd$data, ""))
          validate(need(variables(), ""))
          validate(need(samplename(),"" ) )
          validate(need(coloresPCA$colores(), ""))
          boxViolin( names = samplename() , vsd=vsd$data, boxplotswitch=boxplotswitch(),
                    intgroup=variables(), customColor = coloresPCA$colores() ) 
  })

# ............ ###############################
# KEGG table All #####################################
  output$tableAll <- DT::renderDT(server=FALSE,{
    validate(need(kgg$all, "Load file to render table"))
    names(kggDT$all)[names(kggDT$all) == "DE"] <- "DEG"
    names(kggDT$all)[names(kggDT$all) == "P.DE"] <- "p-value"
    tituloTabla <- paste0("Table: Kegg all genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="keggAll", title=tituloTabla ) )
      
    datatable2(
      kggDT$all, 
      vars = c("genes"),
      filter = list(position="top", clear=FALSE),
      escape = FALSE,
      opts = list(order = list(list(5, 'asc')),
        pageLength = 10, white_space = "normal",
        buttons = customButtons
        ) )
  }) 
# KEGG barplot All ################
  output$keggPlotAll <- renderPlotly ({
    validate(need(kgg$all, "Load file to render BarPlot"))
    rowsAll <- rowsAll()
    if(is.null(rowsAll)){
        if( dim(kgg$all)[1]<10 ){rowsAll <-  seq_len(nrow(kgg$all)) }
        else{ rowsAll <-  seq_len(10)  }
        }
    p <- plotKeggAll(enrichdf = kgg$all[rowsAll,], nrows = length(rowsAll),
                genesUp = data$genesUp, genesDown = data$genesDown,
                colors = c(input$downColor, input$upColor))
    if(typeBarKeggAll() == "Dodge"){
        print(p[[1]])   } else if(typeBarKeggAll()=="Stack"){
            print(p[[2]])} else {print(p[[3]])}
        
  })
  # KEGG chordiag plot All ###############
  output$keggChordAll <- renderChorddiag({
    validate(need(kgg$all, "Load file to render ChordPlot"))
    rowsAll <- rowsAll()
    if(is.null(rowsAll)){
        if( dim(kgg$all)[1]<10 ){rowsAll <-  seq_len(nrow(kgg$all)) }
        else{ rowsAll <-  seq_len(10)  }
        }
    chordPlot(kgg$all[rowsAll, ], nRows = length(rowsAll), orderby = "P.DE")
  })
output$legendChorAll <- renderPlot({
    validate(need(kgg$all, "Load file to render ChordPlot"))
    rowsAll <- rowsAll()
    if(is.null(rowsAll)){
        if( dim(kgg$all)[1]<10 ){rowsAll <-  seq_len(nrow(kgg$all)) }
        else{ rowsAll <-  seq_len(10)  }
        }
    legendChorplot(kgg$all[rowsAll, ] )
  })
  # KEGG dotplot All ################### 
  output$keggDotAll <- renderPlot({
    validate(need(kgg$all, "Load file and select to render dotPlot"))
    validate(need(rowsAll(), "Select the paths of interest to render DotPlot"))
    rowsAll <- rowsAll()
    if(is.null(rowsAll)){rowsAll <- c(1:20)}
    dotPlotkegg(kgg$all[rowsAll,], n = length(rowsAll))
  })
  # KEGG heatmap All #################
  output$heatmapKeggAll <- renderPlotly({
    validate(need(kgg$all, "Load file and select to render Heatmap"))
    validate(need(rowsAll(), "Select the paths of interest to render HeatMap"))
    validate(need(kggDT$all, ""))
    heatmapKeggLogFC(kggDT$all, res$sh, rowsAll() ) 
  })
  # KEGG cnet All #################
  output$legend <- renderPlot({
    validate(need(kgg$all, "Load file and select to render Net Plot"))
    validate(need(rowsAll(), "Select the paths of interest to render NetPlot"))
    validate(need(kggDT$all, ""))
    visnetLegend(kggDT = kggDT$all , rows = rowsAll() )
  })

  output$keggAllNet <- renderUI({
    if(!isTRUE( input$keggAllNet_switch ) ){
      plotOutput("cnetKeggAll", height = "600px")
    } else{
      visNetworkOutput("visnetKeggAll", height = "600px")
    }
  })

  output$cnetKeggAll <- renderPlot({
    validate(need(kgg$all, "Load file and select to render Net Plot"))
    validate(need(rowsAll(), "Select the paths of interest to render NetPlot"))
    customCnetKegg(kgg$all, rowsAll(), genesUp = data$genesUp, genesDown = data$genesDown)
  })

  output$visnetKeggAll <- renderVisNetwork({
    validate(need(kgg$all, "Load file and select to render Net Plot"))
    validate(need(rowsAll(), "Select the paths of interest to render NetPlot"))
    validate(need(kggDT$all, ""))
    visData <- customVisNet(kgg$all, nTerm=rowsAll(), kggDT$all,
                             up = data$genesUp$SYMBOL, down = data$genesDown$SYMBOL )
    visNetwork(visData$nodes, visData$edges, background = "#ffffff") %>%
    visOptions(highlightNearest = list(enabled=TRUE, hover=TRUE),
                nodesIdSelection = TRUE)
  })
  # ............ ###############################
  # KEGG table up#####################################
  output$table <- DT::renderDT(server=FALSE,{
    validate(need(kgg$up, "Load file to render table"))
    names(kggDT$up)[names(kggDT$up) == "DE"] <- "DEG"
    names(kggDT$up)[names(kggDT$up) == "P.DE"] <- "p-value"
    tituloTabla <- paste0("Table: Kegg up-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="keggUp", title=tituloTabla ) )

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
    validate(need(kgg$up, "Load file to render BarPlot"))
    rowsUp <- rowsUp()
    if(is.null(rowsUp)){
        if( dim(kgg$up)[1]<10 ){rowsUp <-  seq_len(nrow(kgg$up)) }
        else{ rowsUp <-  seq_len(10)  }
        }
    plotKegg(enrichdf = kgg$up[rowsUp,], nrows = length(rowsUp), colors = c(input$upColor))
  })
  # KEGG chordiag plot up ###############
  output$keggChord <- renderChorddiag({
    validate(need(kgg$up, "Load file to render ChordPlot"))
    rowsUp<- rowsUp()
    if(is.null(rowsUp)){
        if( dim(kgg$up)[1]<10 ){rowsUp <-  seq_len(nrow(kgg$up)) }
        else{ rowsUp <-  seq_len(10)  }
        }
    chordPlot(kgg$up[rowsUp, ], nRows = length(rowsUp), orderby = "P.DE")
  })
 output$legendChorUp <- renderPlot({
    validate(need(kgg$up, "Load file to render ChordPlot"))
    rowsUp <- rowsUp()
    if(is.null(rowsUp)){
        if (dim(kgg$up)[1] < 10) {rowsUp <-  seq_len(nrow(kgg$up))}
        else{rowsUp <-  seq_len(10)}
        
        }
    legendChorplot(kgg$up[rowsUp, ] )
  })
  # KEGG dotplot UP ################### 
  output$keggDotUp <- renderPlot({
    validate(need(kgg$up, "Load file and select to render dotPlot"))
    validate(need(rowsUp(), "Select the paths of interest to render DotPlot"))
    rowsUp <- rowsUp()
    if(is.null(rowsUp)){rowsUp <- c(1:20)}
    dotPlotkegg(kgg$up[rowsUp,], n = length(rowsUp))
  })
  # KEGG heatmap Up #################
  output$heatmapKeggUp <- renderPlotly({
    validate(need(kgg$up, "Load file and select to render Heatmap"))
    validate(need(rowsUp(), "Select the paths of interest to render HeatMap"))
    validate(need(kggDT$up, ""))
    #heatmapKegg(kggDT$up, rowsUp())
    heatmapKeggLogFC(kggDT$up, res$sh, rowsUp() ) 
  })
  # KEGG cnet Up #################
   output$keggUpNet <- renderUI({
    if(!isTRUE( input$keggUpNet_switch ) ){
      plotOutput("cnetKeggUp", height = "600px")
    } else{
      visNetworkOutput("visnetKeggUp", height = "600px")
    }
  })
  output$cnetKeggUp <- renderPlot({
    validate(need(kgg$up, "Load file and select to render Net Plot"))
    validate(need(rowsUp(), "Select the paths of interest to render NetPlot"))
    customCnetKegg(kgg$up, rowsUp(), genesUp = data$genesUp, genesDown = data$genesDown)
  })
  output$visnetKeggUp <- renderVisNetwork({
    validate(need(kgg$up, "Load file and select to render Net Plot"))
    validate(need(rowsUp(), "Select the paths of interest to render NetPlot"))
    validate(need(kggDT$up, ""))
    visData <- customVisNet(kgg$up, nTerm=rowsUp(), kggDT$up,
                             up = data$genesUp$SYMBOL, down = data$genesDown$SYMBOL )
    visNetwork(visData$nodes, visData$edges, background = "#ffffff") %>%
    visOptions(highlightNearest = list(enabled=TRUE, hover=TRUE),
                nodesIdSelection = TRUE)
  })
  
  # ............ ###############################
  # KEGG table down #####################################
  output$tableDown <- DT::renderDT(server=FALSE,{
    validate(need(kgg$down, "Load file to render table"))
    names(kggDT$down)[names(kggDT$down) == "DE"] <- "DEG"
    names(kggDT$down)[names(kggDT$down) == "P.DE"] <- "p-value"
    tituloTabla <- paste0("Table: Kegg down-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
      list(extend = "copy", title=tituloTabla),
      list(extend="collection", buttons = c("csv", "excel"),
           text="Download", filename="keggDown", title=tituloTabla ) )

    datatable2(
      kggDT$down,
      vars = c("genes"),
      filter = list(position="top", clear=FALSE),
      escape = FALSE,
      opts = list(order = list(list(5, 'asc')),
        pageLength = 10, white_space = "normal",
        buttons = customButtons))
  }) 
  # KEGG barplot down ################
  output$keggPlotDown <- renderPlotly ({
    validate(need(kgg$down, "Load file to render BarPlot"))
    rowsdown <- rowsdown()
    if(is.null(rowsdown)){
        if( dim(kgg$down)[1]<10 ){rowsdown <-  seq_len(nrow(kgg$down)) }
        else{ rowsdown <-  seq_len(10)  }
        }
    plotKegg(enrichdf = kgg$down[rowsdown,], nrows = length(rowsdown), 
             colors = c(input$downColor))
  })
  # KEGG chordiag plot down ###############
  output$keggChordDown <- renderChorddiag({
    validate(need(kgg$down, "Load file to render ChordPlot"))
    rowsdown <- rowsdown()
    if(is.null(rowsdown)){
        if( dim(kgg$down)[1]<10 ){rowsdown <-  seq_len(nrow(kgg$down)) }
        else{ rowsdown <-  seq_len(10)  }
        }
    chordPlot(kgg$down[rowsdown, ], nRows = length(rowsdown), orderby = "P.DE")
  })
  output$legendChorDown <- renderPlot({
    validate(need(kgg$down, "Load file to render ChordPlot"))
    rowsdown <- rowsdown()
    if(is.null(rowsdown)){
        if( dim(kgg$down)[1]<10 ){rowsdown <-  seq_len(nrow(kgg$down)) }
        else{ rowsdown <-  seq_len(10)  }
        }
    legendChorplot(kgg$down[rowsdown, ] )
  })
  # KEGG dotplot Down ################### 
  output$keggDotDown <- renderPlot({
    validate(need(kgg$down, "Load file to render DotPlot"))
    validate(need(rowsdown(), "Select the paths of interest to render dotPlot"))
    rowsdown <- rowsdown()
    if(is.null(rowsdown)){rowsdown <- c(1:20)}
    dotPlotkegg(kgg$down[rowsdown,], n = length(rowsdown))
  })
  # KEGG heatmap Down #################
  output$heatmapKeggDown <- renderPlotly({
    validate(need(kgg$down, "Load file to render Heatmap"))
    validate(need(rowsdown(), "Select the paths of interest to render Heatmap"))
    #heatmapKegg(kggDT$down, rowsdown())
    heatmapKeggLogFC(kggDT$down, res$sh, rowsdown() ) 
  })
    # KEGG cnet Down #################
   output$keggDownNet <- renderUI({
    if(!isTRUE( input$keggDownNet_switch ) ){
      plotOutput("cnetKeggDown", height = "600px")
    } else{
      visNetworkOutput("visnetKeggDown", height = "600px")
    }
  })
  output$cnetKeggDown <- renderPlot({
    validate(need(kgg$down, "Load file and select to render Net Plot"))
    validate(need(rowsdown(), "Select the paths of interest to render NetPlot"))
    customCnetKegg(kgg$down, rowsdown(), genesUp = data$genesUp, genesDown = data$genesDown)
  })
  output$visnetKeggDown <- renderVisNetwork({
    validate(need(kgg$down, "Load file and select to render Net Plot"))
    validate(need(rowsdown(), "Select the paths of interest to render NetPlot"))
    validate(need(kggDT$down, ""))
    visData <- customVisNet(kgg$down, nTerm=rowsdown(), kggDT$down,
                             up = data$genesUp$SYMBOL, down = data$genesDown$SYMBOL )
    visNetwork(visData$nodes, visData$edges, background = "#ffffff") %>%
    visOptions(highlightNearest = list(enabled=TRUE, hover=TRUE),
                nodesIdSelection = TRUE)
  })
  # ............ ###############################
  # GO table BP ALL #####################
  output$tableBPall <- DT::renderDataTable(server=FALSE,{
    validate(need(goDT$all, "Load file to render table"))
    goDT <- goDT$all 
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level) 
    tituloTabla <- paste0("Table: GO-BP all genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$all, "Load file to render plot"))
    bprowsall <- bprowsall()
    if(is.null(bprowsall)){bprowsall <- c(1:10)}
    gosBP <- go$all[go$all$Ont=="BP",]
    p <- plotGOAll(enrichdf = gosBP[bprowsall, ], nrows = length(bprowsall), ont="BP", 
              genesUp = data$genesUp, genesDown = data$genesDown,
              colors = c(input$downColor, input$upColor))
    if( typeBarBpAll() == "Dodge") { print(p[[1]]) }
    else if ( typeBarBpAll() == "Stack") { print(p[[2]]) }
    else { print(p[[3]]) }
  })
  # GO BP dotplot all ################### 
  output$BPDotall <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    validate(need(bprowsall(), "Select the terms of interest to render DotPlot"))
    bprowsall <- bprowsall()
    if(is.null(bprowsall)){bprowsall <- c(1:20)}
    gosBP <- go$all[go$all$Ont=="BP",]
    dotPlotGO(gosBP[bprowsall,], n = length(bprowsall))
  })
  # GO gobarplot BP all #######################
  output$gobarplotAllBP <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    bprowsall <- bprowsall()
    goBarplot(enrichGO = go$all, resGO = res$sh, genes= data$genesall,
              category = "BP", nrows = bprowsall)
  })
  # GO circle BP all #####################
  output$goCircleAllBP <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( bprowsall() , "Select at least 4 rows"))
    bprowsall <- bprowsall()
    goall <- go$all[go$all$Ont=="BP", ]
    if(length(bprowsall)>=4){
      circ <- data2circle(go=goall[bprowsall, ], res=res$sh, genes=data$genesall)
      circle(circ, label.size = 3, nsub = length(bprowsall), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GO table MF all #####################
  output$tableMFall <- DT::renderDataTable({
    validate(need(goDT$all, "Load file to render table"))
    goDT <- goDT$all
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-MF all genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$all, "Load file to render plot"))
    mfrowsall <- mfrowsall()
    if(is.null(mfrowsall)){mfrowsall <- c(1:10)}
    gosMF <- go$all[go$all$Ont=="MF",]
    p <- plotGOAll(enrichdf = gosMF[mfrowsall, ], nrows = length(mfrowsall), ont="MF", 
                   genesUp = data$genesUp, genesDown = data$genesDown,
                   colors = c(input$downColor, input$upColor))
    if( typeBarMfAll() == "Dodge") { print(p[[1]]) }
    else if ( typeBarMfAll() == "Stack") { print(p[[2]]) }
    else { print(p[[3]]) }
  })
  # GO MF dotplot all ################### 
  output$MFDotall <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    validate(need(mfrowsall(), "Select the terms of interest to render DotPlot"))
    mfrowsall <- mfrowsall()
    if(is.null(mfrowsall)){mfrowsall <- c(1:20)}
    gosMF <- go$all[go$all$Ont=="MF",]
    dotPlotGO(gosMF[mfrowsall,], n = length(mfrowsall))
  })
  # GO gobarplot MF all ####################
  output$gobarplotAllMF <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    mfrowsall <- mfrowsall()
    goBarplot(enrichGO = go$all, resGO = res$sh, genes= data$genesall,
              category = "MF", nrows = mfrowsall)
  })
  # GO circle MF all #####################
  output$goCircleAllMF <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( mfrowsall() , "Select at least 4 rows"))
    mfrowsall <- mfrowsall()
    goall <- go$all[go$all$Ont=="MF", ]
    if(length(mfrowsall)>=4){
      circ <- data2circle(go=goall[mfrowsall, ], res=res$sh, genes=data$genesall)
      circle(circ, label.size = 3, nsub = length(mfrowsall), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GO table CC all #####################
  output$tableCCall <- DT::renderDataTable(server=FALSE,{
    validate(need(goDT$all, "Load file to render table"))
    goDT <- goDT$all
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-CC all genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$all, "Load file to render plot"))
    ccrowsall <- ccrowsall()
    if(is.null(ccrowsall)){ccrowsall <- c(1:10)}
    gosCC <- go$all[go$all$Ont=="CC",]
    p <- plotGOAll(enrichdf = gosCC[ccrowsall, ], nrows = length(ccrowsall), ont="CC", 
                   genesUp = data$genesUp, genesDown = data$genesDown,
                   colors = c(input$downColor, input$upColor))
    if( typeBarCcAll() == "Dodge") { print(p[[1]]) }
    else if ( typeBarCcAll() == "Stack") { print(p[[2]]) }
    else { print(p[[3]]) }
  })
  # GO CC dotplot all ################### 
  output$CCDotall <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    validate(need(ccrowsall(), "Select the terms of interest to render DotPlot"))
    ccrowsall <- ccrowsall()
    if(is.null(ccrowsall)){ccrowsall <- c(1:20)}
    gosCC <- go$all[go$all$Ont=="CC",]
    dotPlotGO(gosCC[ccrowsall,], n = length(ccrowsall))
  })
  # GO gobarplot CC all #######################
  output$gobarplotAllCC <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    ccrowsall <- ccrowsall()
    goBarplot(enrichGO = go$all, resGO = res$sh, genes= data$genesall,
              category = "CC", nrows = ccrowsall)
  })
  # GO circle CC all #####################
  output$goCircleAllCC <- renderPlot({
    validate(need(go$all, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( ccrowsall() , "Select at least 4 rows"))
    ccrowsall <- ccrowsall()
    goall <- go$all[go$all$Ont=="CC", ]
    if(length(ccrowsall)>=4){
      circ <- data2circle(go=goall[ccrowsall, ], res=res$sh, genes=data$genesall)
      circle(circ, label.size = 3, nsub = length(ccrowsall), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GO table BP UP#####################
  output$tableBP <- DT::renderDataTable(server=FALSE,{
    validate(need(goDT$up, "Load file to render table"))
    goDT <- goDT$up
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-BP up-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$up, "Load file to render plot"))
    bprowsup <- bprowsup()
    if(is.null(bprowsup)){bprowsup <- c(1:10)}
    gosBP <- go$up[go$up$Ont=="BP",]
    plotGO(enrichdf = gosBP[bprowsup, ], nrows = length(bprowsup), ont="BP",
           colors = c(input$upColor) )
  })
  # GO BP dotplot up ################### 
  output$BPDotUp <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    validate(need(bprowsup(), "Select the terms of interest to render DotPlot"))
    bprowsup <- bprowsup()
    if(is.null(bprowsup)){bprowsup <- c(1:20)}
    gosBP <- go$up[go$up$Ont=="BP",]
    dotPlotGO(gosBP[bprowsup,], n = length(bprowsup))
  })
  # GO gobarplot BP Up #######################
  output$gobarplotUpBP <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    bprowsup <- bprowsup()
    goBarplot(enrichGO = go$up, resGO = res$sh, genes= data$genesUp,
              category = "BP", nrows = bprowsup)
  })
    # GO circle BP Up #####################
  output$goCircleUpBP <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( bprowsup() , "Select at least 4 rows"))
    bprowsup <- bprowsup()
    if(length(bprowsup)>=4){
      circ <- data2circle(go=go$up[bprowsup, ], res=res$sh, genes=data$genesUp)
      circle(circ, label.size = 3, nsub = length(bprowsup), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GO table MF UP #####################
  output$tableMF <- DT::renderDataTable({
    validate(need(goDT$up, "Load file to render table"))
    goDT <- goDT$up
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-MF up-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$up, "Load file to render plot"))
    mfrowsup <- mfrowsup()
    if(is.null(mfrowsup)){mfrowsup <- c(1:10)}
    gosMF <- go$up[go$up$Ont=="MF",]
    plotGO(enrichdf = gosMF[mfrowsup, ], nrows = length(mfrowsup), ont = "MF",
           colors = c(input$upColor) )
  })
  # GO MF dotplot up ################### 
  output$MFDotUp <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    validate(need(mfrowsup(), "Select the terms of interest to render DotPlot"))
    mfrowsup <- mfrowsup()
    if(is.null(mfrowsup)){mfrowsup <- c(1:20)}
    gosMF <- go$up[go$up$Ont=="MF",]
    dotPlotGO(gosMF[mfrowsup,], n = length(mfrowsup))
  })
  # GO gobarplot MF Up #######################
  output$gobarplotUpMF <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    mfrowsup <- mfrowsup()
    goBarplot(enrichGO = go$up, resGO = res$sh, genes= data$genesUp,
              category = "MF", nrows = mfrowsup)
  })
  # GO circle MF Up #####################
  output$goCircleUpMF <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( mfrowsup() , "Select at least 4 rows"))
    mfrowsup <- mfrowsup()
    if(length(mfrowsup)>=4){
      circ <- data2circle(go=go$up[mfrowsup, ], res=res$sh, genes=data$genesUp)
      circle(circ, label.size = 3, nsub = length(mfrowsup), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GO table CC UP #####################
  output$tableCC <- DT::renderDataTable(server=FALSE,{
    validate(need(goDT$up, "Load file to render table"))
    goDT <- goDT$up
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-CC up-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$up, "Load file to render plot"))
    ccrowsup <- ccrowsup()
    if(is.null(ccrowsup)){ccrowsup <- c(1:10)}
    gosCC <- go$up[go$up$Ont=="CC",]
    plotGO(enrichdf = gosCC[ccrowsup,], nrows = length(ccrowsup), ont="CC",
           colors = c(input$upColor))
  })
  # GO CC dotplot up ################### 
  output$CCDotUp <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    validate(need(ccrowsup(), "Select the terms of interest to render DotPlot"))
    ccrowsup <- ccrowsup()
    if(is.null(ccrowsup)){ccrowsup <- c(1:20)}
    gosCC <- go$up[go$up$Ont=="CC",]
    dotPlotGO(gosCC[ccrowsup,], n = length(ccrowsup))
  })
  # GO gobarplot CC Up #######################
  output$gobarplotUpCC <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    ccrowsup <- ccrowsup()
    goBarplot(enrichGO = go$up, resGO = res$sh, genes= data$genesUp,
              category = "CC", nrows = ccrowsup)
  })
  # GO circle CC Up #####################
  output$goCircleUpCC <- renderPlot({
    validate(need(go$up, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( ccrowsup() , "Select at least 4 rows"))
    ccrowsup <- ccrowsup()
    if(length(ccrowsup)>=4){
      circ <- data2circle(go=go$up[ccrowsup, ], res=res$sh, genes=data$genesUp)
      circle(circ, label.size = 3, nsub = length(ccrowsup), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GO table BP DOWN #####################
  output$tableBPdown <- DT::renderDataTable(server=FALSE,{
    validate(need(goDT$down, "Load file to render table"))
    goDT <- goDT$down
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-BP down-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$down, "Load file to render plot"))
    bprowsdown <- bprowsdown()
    if(is.null(bprowsdown)){bprowsdown <- c(1:10)}
    gosBP <- go$down[go$down$Ont=="BP",]
    plotGO(enrichdf = gosBP[bprowsdown, ], nrows = length(bprowsdown), ont="BP",
           colors = c(input$downColor))
  })
  # GO BP dotplot down ################### 
  output$BPDotDown <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    validate(need(bprowsdown(), "Select the terms of interest to render DotPlot"))
    bprowsdown <- bprowsdown()
    if(is.null(bprowsdown)){bprowsdown <- c(1:20)}
    gosBP <- go$down[go$down$Ont=="BP",]
    dotPlotGO(gosBP[bprowsdown,], n = length(bprowsdown))
  })
  # GO gobarplot BP down #######################
  output$gobarplotDownBP <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    bprowsdown <- bprowsdown()
    goBarplot(enrichGO = go$down, resGO = res$sh, genes= data$genesDown,
              category = "BP", nrows = bprowsdown)
  })
  # GO circle BP Down #####################
  output$goCircleDownBP <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( bprowsdown() , "Select at least 4 rows"))
    bprowsdown <- bprowsdown()
    if(length(bprowsdown)>=4){
      circ <- data2circle(go=go$down[bprowsdown, ], res=res$sh, genes=data$genesDown)
      circle(circ, label.size = 3, nsub = length(bprowsdown), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GO table MF DOWN #####################
  output$tableMFdown <- DT::renderDataTable({
    validate(need(goDT$down, "Load file to render table"))
    goDT <- goDT$down
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-MF down-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$down, "Load file to render plot"))
    mfrowsdown <- mfrowsdown()
    if(is.null(mfrowsdown)){mfrowsdown <- c(1:10)}
    gosMF <- go$down[go$down$Ont=="MF",]
    plotGO(enrichdf = gosMF[mfrowsdown, ], nrows = length(mfrowsdown), ont = "MF",
           colors = c(input$downColor) )
  })
  # GO MF dotplot down ################### 
  output$MFDotDown <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    validate(need(mfrowsdown(), "Select the terms of interest to render DotPlot"))
    mfrowsdown <- mfrowsdown()
    if(is.null(mfrowsdown)){mfrowsdown <- c(1:20)}
    gosMF <- go$down[go$down$Ont=="MF",]
    dotPlotGO(gosMF[mfrowsdown,], n = length(mfrowsdown))
  })
  # GO gobarplot MF down #######################
  output$gobarplotDownMF <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    mfrowsdown <- mfrowsdown()
    goBarplot(enrichGO = go$down, resGO = res$sh, genes= data$genesDown,
              category = "MF", nrows = mfrowsdown)
  })
  # GO circle MF Down #####################
  output$goCircleDownMF <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( mfrowsdown() , "Select at least 4 rows"))
    mfrowsdown <- mfrowsdown()
    if(length(mfrowsdown)>=4){
      circ <- data2circle(go=go$down[mfrowsdown, ], res=res$sh, genes=data$genesDown)
      circle(circ, label.size = 3, nsub = length(mfrowsdown), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GO table CC DOWN #####################
  output$tableCCdown <- DT::renderDataTable(server=FALSE,{
    validate(need(goDT$down, "Load file to render table"))
    goDT <- goDT$down
    names(goDT)[names(goDT) == "DE"] <- "DEG"
    names(goDT)[names(goDT) == "P.DE"] <- "p-value"
    names(goDT)[names(goDT) == "level"] <- "Ont.level"
    goDT$Ont.level = as.integer(goDT$Ont.level)
    tituloTabla <- paste0("Table: GO-CC down-regulated genes | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
                          "Num genes Up/down: ",numgenesDE$up,"/",numgenesDE$down)
    customButtons <- list(
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
    validate(need(go$down, "Load file to render plot"))
    ccrowsdown <- ccrowsdown()
    if(is.null(ccrowsdown)){ccrowsdown <- c(1:10)}
    gosCC <- go$down[go$down$Ont=="CC",]
    plotGO(enrichdf = gosCC[ccrowsdown,], nrows = length(ccrowsdown), ont="CC",
           colors = c(input$downColor) )
  })
  # GO CC dotplot down ################### 
  output$CCDotDown <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    validate(need(ccrowsdown(), "Select the terms of interest to render DotPlot"))
    ccrowsdown <- ccrowsdown()
    if(is.null(ccrowsdown)){ccrowsdown <- c(1:20)}
    gosCC <- go$down[go$down$Ont=="CC",]
    dotPlotGO(gosCC[ccrowsdown,], n = length(ccrowsdown))
  })
  # GO gobarplot CC down #######################
  output$gobarplotDownCC <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    ccrowsdown <- ccrowsdown()
    goBarplot(enrichGO = go$down, resGO = res$sh, genes= data$genesDown,
              category = "CC", nrows = ccrowsdown)
  })
  # GO circle CC Down #####################
  output$goCircleDownCC <- renderPlot({
    validate(need(go$down, "Load file to render dotPlot"))
    validate(need(res$sh,""))
    validate(need( ccrowsdown() , "Select at least 4 rows"))
    ccrowsdown <- ccrowsdown()
    if(length(ccrowsdown)>=4){
      circ <- data2circle(go=go$down[ccrowsdown, ], res=res$sh, genes=data$genesDown)
      circle(circ, label.size = 3, nsub = length(ccrowsdown), table.legend = FALSE)
    }
  })
  # ............ ###############################
  # GSEA table ##########################
  output$gseaTable <- renderDataTable({
    validate(need(res$sh, "Load file to render table"))
    gsea$gsea <- gseaKegg(res$sh, specie() )
    mygsea <- gsea$gsea
    if( length(which(mygsea@result$p.adjust<=0.05)) == 0 ){
        createAlert(session, anchorId = "gsea", title = "Oops!!", 
          content = "Sorry, I didn't get any significant results for this analysis",
          append=FALSE, style = "info")
    } else{
    table <- mygsea@result[mygsea@result$p.adjust<=0.05 ,2:9] %>% 
      mutate_at(vars(3:7), ~round(., 4))

    tituloTabla <- paste0("Table: GSEA pathway | ","log2FC: ",logfc()[1],"_",logfc()[2]," | ","padj: ",padj()," | ",
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
    validate(need(gsea$gsea, "Load file to render table"))
    gseanr <- gsearow()
    if(is.null(gseanr)){gseanr <- c(1)}
    mygsea <- gsea$gsea
    if( length(which(mygsea@result$p.adjust<=0.05)) == 0 ){
        createAlert(session, anchorId = "gseaPlot", title = "Oops!!", 
          content = "Sorry, I didn't get any significant results for this analysis",
          append=FALSE, style = "info")
    } else{
        enrichplot::gseaplot2(gsea$gsea, geneSetID = gseanr, pvalue_table = TRUE, ES_geom = "line")
        }
  })
  # ............ ###############################
  # author name ######################
  #author <- reactive({input$author})
  # generate report #############################
  output$report <- renderUI({
    validate(need(res$sh, ""))
    #downloadButton("report2", "html report")
    actionButton("report2", "html report")
  })
  
  observeEvent(input$report2, {
      showModal(popupModal())
    })

  applyPress <- reactiveValues(ok=FALSE)
  observeEvent(input$ok,{
        applyPress$ok <- TRUE
        vals$preview <- input$modalPreview
        vals$keggAll <- input$modalkeggAll
        vals$keggUp <- input$modalkeggUp
        vals$keggDown <- input$modalkeggDown
        vals$GOAll <- input$modalGOAll
        vals$GOUp <- input$modalGOUp
        vals$GODown <- input$modalGODown
        vals$GSEA <- input$modalGSEA
        #removeModal()
  })
  
  output$downloadhtml <- renderUI({
    validate(need(isTRUE(applyPress$ok), ""))
    downloadButton("download", "Download report")
    })
  
    output$download <- downloadHandler(
    filename = "report.html",
    content = function(file) {
      removeModal()
      applyPress$ok <- FALSE
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      file.copy("mystyle.css", file.path(tempdir(), "mystyle.css"), overwrite = TRUE)
      file.copy("utilsReport.R", file.path(tempdir(),"utils.R"), overwrite = TRUE)
      file.copy("resources/", tempdir(), overwrite = TRUE, recursive = TRUE)
      file.copy("resources/dna-svg-small-13.gif",
      file.path(tempdir(), "resources/dna-svg-small-13.gif"), overwrite = TRUE)
      ## inicializar variables preview
      pcaObj <- boxObj <- heatObj <- clusterObj <- top6Obj <- top1Obj <- FALSE
      karyObj <- FALSE
      volcObj <- maObj <- FALSE
      ## inicializar variables kegg
      tablekgaObj <- barkgaObj <- chorkgaObj <- dotkgaObj <- heatkgaObj <- netkgaObj <- FALSE
      tablekguObj <- barkguObj <- chorkguObj <- dotkguObj <- heatkguObj <- netkguObj <- FALSE
      tablekgdObj <- barkgdObj <- chorkgdObj <- dotkgdObj <- heatkgdObj <- netkgdObj <- FALSE
      ## inicializar variables Go
      tablegoaObj <- bargoaObj <- dotgoaObj <- gobargoaObj <- gocirclegoaObj <- FALSE
      tablegouObj <- bargouObj <- dotgouObj <- gobargouObj <- gocirclegouObj <- FALSE
      tablegodObj <- bargodObj <- dotgodObj <- gobargodObj <- gocirclegodObj <- FALSE
      ## inicializar variables GSEA
      tablegseaObj <- plotgseaObj <- FALSE 
      ## Asigna variables
          rlogdatos <- rlog$datos; colorespca <- coloresPCA$colores();
          variables <- variables(); samplename <- samplename() 
          vsddata <- vsd$data; boxplotswitch <- boxplotswitch()
          specie <- specie(); numheatmap <- numheatmap()
          ressh <- res$sh; datosdds <- datos$dds; gene <- gene(); 
          padj <- padj(); logfc <- logfc(); genesvolcano <- genesVolcano();
          upcolor <- input$upColor; downcolor <- input$downColor
          kggall <- kgg$all; genesdeup <- numgenesDE$up; genesdedown <- numgenesDE$down
          kggdtall <- kggDT$all; datagenesup <- data$genesUp; datagenesdown <- data$genesDown
          typebarkeggall <- typeBarKeggAll()
          typebarbpall <- typeBarBpAll(); typebarmfall <- typeBarMfAll();
          typebarccall <- typeBarCcAll()
          kggup <- kgg$up; kggdown <- kgg$down; kggdtup <- kggDT$up; kggdtdown <- kggDT$down; 
          goall <- go$all; godtall <- goDT$all; 
          goup <- go$up; godtup <- goDT$up; 
          godown <- go$down; godtdown <- goDT$down; 
          bprowsall <- bprowsall(); mfrowsall <- mfrowsall(); ccrowsall <- ccrowsall()
          bprowsup <- bprowsup(); mfrowsup <- mfrowsup(); ccrowsup <- ccrowsup()
          bprowsdown <- bprowsdown(); mfrowsdown <- mfrowsdown(); ccrowsdown <- ccrowsdown()
          gsearow <- gsearow(); gseagsea <- gsea$gsea
          textnotes <- input$textNotes
      #nrows
          nrowsall <- rowsAll()
          if(!is.null(kggDT$all)){
            if(is.null(nrowsall)){ 
              nrowsall <-  ( if( dim(kggDT$all)[1]<10) seq_len(nrow(kggDT$all)) else seq_len(10) ) }
          }
          nrowsup <- rowsUp()
          if(!is.null(kggDT$up)){
            if(is.null(nrowsup)){ 
              nrowsup <-  ( if( dim(kggDT$up)[1]<10) seq_len(nrow(kggDT$up)) else seq_len(10) ) }
          }
          nrowsdown <- rowsdown()
          if(!is.null(kggDT$down)){
            if(is.null(nrowsdown)){ 
              nrowsdown <-  ( if( dim(kggDT$down)[1]<10) seq_len(nrow(kggDT$down)) else seq_len(10) ) }
          }
      if(!is.null(vals$preview)){      #para preview
        if( ("PCA" %in% vals$preview) ){ pcaObj <- TRUE}
        if("BoxPlot" %in% vals$preview){boxObj <- TRUE}
        if("Heatmap" %in% vals$preview){heatObj <- TRUE}
        if("Cluster" %in% vals$preview){clusterObj <- TRUE}
        if("Top6" %in% vals$preview){top6Obj <- TRUE}
        if("Top1" %in% vals$preview){top1Obj <- TRUE}
        if("Karyoplot" %in% vals$preview){karyObj <- TRUE}
        if("Volcano" %in% vals$preview){volcObj <- TRUE}
        if("MA" %in% vals$preview){ maObj <- TRUE}
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
        if("Table" %in% vals$GOAll){ tablegoaObj <- TRUE }
        if("Barplot" %in% vals$GOAll){ bargoaObj <- TRUE }
        if("Dotplot" %in% vals$GOAll){ dotgoaObj <- TRUE }
        if("GObarplot" %in% vals$GOAll){ gobargoaObj <- TRUE }
        if("GOcircleplot" %in% vals$GOAll){ gocirclegoaObj <- TRUE }
      }
      if(!is.null(vals$GOUp)){#para GoUp
        if("Table" %in% vals$GOUp){ tablegouObj <- TRUE }
        if("Barplot" %in% vals$GOUp){ bargouObj <- TRUE }
        if("Dotplot" %in% vals$GOUp){ dotgouObj <- TRUE }
        if("GObarplot" %in% vals$GOUp){ gobargouObj <- TRUE }
        if("GOcircleplot" %in% vals$GOUp){ gocirclegouObj <- TRUE }
      }
      if(!is.null(vals$GODown)){#para GoDown
        if("Table" %in% vals$GODown){ tablegodObj <- TRUE }
        if("Barplot" %in% vals$GODown){ bargodObj <- TRUE }
        if("Dotplot" %in% vals$GODown){ dotgodObj <- TRUE }
        if("GObarplot" %in% vals$GODown){ gobargodObj <- TRUE }
        if("GOcircleplot" %in% vals$GODown){ gocirclegodObj <- TRUE }
      }
      if(!is.null(vals$GSEA)){#para GSEA
        if("Table" %in% vals$GSEA){ tablegseaObj <- TRUE}
        if("GSEA plot" %in% vals$GSEA){ plotgseaObj <- TRUE}
        }

      params <- list( values = vals, 
                      pcaObj = pcaObj, rlog = rlogdatos, colorespca = colorespca,
                     variables = variables, samplename = samplename,
                     vsd = vsddata, boxplotswitch = boxplotswitch, boxObj = boxObj,
                     specie = specie, numheatmap = numheatmap, heatObj = heatObj,
                     clusterObj = clusterObj, 
                     ressh = ressh, datosdds = datosdds, top6Obj = top6Obj, 
                     gene = gene, top1Obj = top1Obj,
                     karyObj = karyObj, padj =padj, logfc = logfc,
                     volcObj = volcObj, genesvolcano = genesvolcano, 
                     upcolor = upcolor, downcolor = downcolor, 
                     maObj = maObj, 
                     tablekgaObj = tablekgaObj, kggall = kggall, genesdedown = genesdedown,
                     genesdeup = genesdeup, kggdtall = kggdtall,
                     barkgaObj = barkgaObj, nrowsall = nrowsall, datagenesdown = datagenesdown, 
                     datagenesup = datagenesup, typebarkeggall = typebarkeggall,
                     chorkgaObj = chorkgaObj, dotkgaObj = dotkgaObj, heatkgaObj = heatkgaObj,
                     netkgaObj = netkgaObj, tablekguObj = tablekguObj, barkguObj = barkguObj,
                     chorkguObj = chorkguObj, dotkguObj =dotkguObj, heatkguObj = heatkguObj,
                     netkguObj = netkguObj, tablekgdObj = tablekgdObj, barkgdObj = barkgdObj,
                     chorkgdObj = chorkgdObj, dotkgdObj = dotkgdObj, heatkgdObj = heatkgdObj,
                     netkgdObj = netkgdObj, kggup = kggup, kggdown = kggdown, kggdtup = kggdtup, 
                     kggdtdown = kggdtdown, nrowsup = nrowsup, nrowsdown = nrowsdown, 
                     typebarbpall=typebarbpall, typebarmfall=typebarmfall, typebarccall=typebarccall,
                     tablegoaObj = tablegoaObj, bargoaObj=bargoaObj, dotgoaObj=dotgoaObj,
                     gobargoaObj=gobargoaObj,gocirclegoaObj=gocirclegoaObj, tablegouObj = tablegouObj,
                     bargouObj=bargouObj, dotgouObj=dotgouObj, gobargouObj=gobargouObj,
                     gocirclegouObj=gocirclegouObj, tablegodObj = tablegodObj, bargodObj=bargodObj,
                     dotgodObj=dotgodObj, gobargodObj=gobargodObj, gocirclegodObj=gocirclegodObj,
                     goall = goall, godtall=godtall, goup = goup, godtup=godtup,
                     godown = godown, godtdown=godtdown,
                     bprowsall=bprowsall, mfrowsall=mfrowsall, ccrowsall=ccrowsall,
                     bprowsup=bprowsup, mfrowsup=mfrowsup, ccrowsup=ccrowsup,
                     bprowsdown=bprowsdown, mfrowsdown=mfrowsdown, ccrowsdown=ccrowsdown,
                     gsearow = gsearow, gseagsea = gseagsea, tablegseaObj = tablegseaObj,
                     plotgseaObj = plotgseaObj, textnotes = textnotes)
      
      params <- c(params, list(tempdir=tempdir() ))
      rmarkdown::render(
        tempReport,
        output_file = file,
        params = params,
        envir = new.env(parent = globalenv( ))
      )
    } )
  # output$reportpdf <- downloadHandler(
  #   # For PDF output, change this to "report.pdf"
  #   filename = "report.pdf",
  #   content = function(file) {
  #     tempReport <- file.path(tempdir(), "pdfReport.Rmd")
  #     file.copy("pdfReport.Rmd", tempReport, overwrite = TRUE)
  #     file.copy("utils.R", file.path(tempdir(),"utils.R"), overwrite = TRUE)
  #     file.copy("tmpResources/", tempdir(), overwrite = TRUE, recursive = TRUE)
  #     do.call(file.remove, list(list.files("tmpResources/", full.names = TRUE)))
  #     nrall <- rowsAll()
  #     nrup <- rowsUp()
  #     nrdown <- rowsdown()
  #     if(is.null(nrall)){nrall <- c(1:10)}
  #     if(is.null(nrup)){nrup <- c(1:10)}
  #     if(is.null(nrdown)){nrdown <- c(1:10)}
  #     bpnrall <- bprowsall()
  #     mfnrall <- mfrowsall()
  #     ccnrall <- ccrowsall()
  #     if(is.null(bpnrall)){bpnrall <- c(1:10)}
  #     if(is.null(mfnrall)){mfnrall <- c(1:10)}
  #     if(is.null(ccnrall)){ccnrall <- c(1:10)}
  #     bpnrup <- bprowsup()
  #     mfnrup <- mfrowsup()
  #     ccnrup <- ccrowsup()
  #     if(is.null(bpnrup)){bpnrup <- c(1:10)}
  #     if(is.null(mfnrup)){mfnrup <- c(1:10)}
  #     if(is.null(ccnrup)){ccnrup <- c(1:10)}
  #     bpnrdown <- bprowsdown()
  #     mfnrdown <- mfrowsdown()
  #     ccnrdown <- ccrowsdown()
  #     if(is.null(bpnrdown)){bpnrdown <- c(1:10)}
  #     if(is.null(mfnrdown)){mfnrdown <- c(1:10)}
  #     if(is.null(ccnrdown)){ccnrdown <- c(1:10)}
  #     variablepca <- variables()
  #     if(is.null(variablepca)){variablepca=NULL}
  #     gseanr <- gsearow()
  #     if(is.null(gseanr)){gseanr <- c(1)}
  #     params <- list(nrup=nrup, nrdown=nrdown, bpnrup=bpnrup, bpnrdown=bpnrdown,
  #                    mfnrup=mfnrup, mfnrdown=mfnrdown, ccnrup=ccnrup, ccnrdown=ccnrdown,
  #                    variablepca=variablepca, tempdir =tempdir(),
  #                    gseanr=gseanr, author=author(), nrall = nrall,
  #                    bpnrall=bpnrall, mfnrall=mfnrall, ccnrall=ccnrall)
  #     rmarkdown::render(
  #       tempReport,
  #       output_file = file,
  #       params = params,
  #       envir = new.env(parent = globalenv())
  #     )
  #   } )
}


shinyApp(ui, server)
