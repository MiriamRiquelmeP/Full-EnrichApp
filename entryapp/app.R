library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shiny.router)
library(shinyWidgets)
library(shinyjs)
library(networkD3)
library(dplyr)
library(tmap)
library(jsonlite)
library(datasets)
source("global.R")
data("World")
dataWorld <- mapData()
ui <- dashboardPage(
  dashboardHeader(title = "Multiomics web utils lobby", titleWidth = "300px",
                  # tags$li(class = "dropdown", actionButton("statButton", "Stats",
                  #                                          onclick = "window.open('report_stats.html','_blank')"),
                  #                 style="margin-top:8px; margin-right: 15px")
                  tags$li(class = "dropdown", actionButton("statButton", "Stats",
                                   style="margin-top:8px; margin-right: 15px"))
                  ),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
      setShadow(class = "box"),
      tags$head(tags$style(HTML('
                                .bg-limon {
                                background-color: #295e7d;
                                }
                                .box-body {
                                color: #ffffff;
                                }'))),
            useShinyjs(),
      fluidRow(
          column(width = 6, offset = 0,
                 flipBox(
                     width = 2,
                     id = 1,
                     main_img = "https://image.flaticon.com/icons/svg/189/189664.svg",
                     header_img = "https://image.flaticon.com/icons/svg/119/119595.svg",
                     front_title = "Multiomic interactive tools set",
                     back_title = "About us",
                     front_btn_text = "About us", 
                     "With this two applications, a complete set of graphics and tables 
          can be obtained from an enrichment analysis based on several databases 
          or functions applied. Firstly, depending on the type of data input, different 
          results may be achieved, since each plot depends on a serie of needs 
          (can be seen in the interactive image on the right hand side). 
          
                The more complete the element we introduce, the more information we 
          can generate from it. Thus, by adding an Expression Matrix 
          and a table with the information corresponding 
          to the samples (such as the group to which they belong, sex, age...), 
          we can extract the Gene List and their Expression values, 
          generating all the images related to the Sample Info. Plots, the 
          Expression Plots and the functional gene Enrichment Plots. From a single Gene List 
          we can only obtain the gene names to perform the Enrichment Plots but, if we introduce 
          the lists with its statistical values, we can extend the analysis to many Statistics Plots 
          that imply knowing the Pval and the logFC of each gene. Finally, if we enter a DESeq 
          object, we can have all the different information seen before.
                     
                Hence, if we want to enter data in gene list or expression matrix format, 
            please use the link to Simple Enrichment below. If you have a DESeq object 
            already generated, you may proceed via DESeq enrichment link to the tool.",
                     
                     back_content = tagList(
                         column(
                             width = 12,
                             align = "center",
                             HTML("<img src='dna-svg-small-13.gif', width='100px'><br>
                  <h4>Authors:<br><br>
    Miriam Riquelme Pérez 
    <a href='https://www.linkedin.com/in/miriam-riquelme-perez/' target='_blank'> 
    <img src='linkedin_little.svg'> </a> <a href='mailto:miriam.riquelmep@gmail.com'>
    <img src='email.svg'></a><br>
    Fernando Pérez Sanz 
    <a href='https://www.linkedin.com/in/fernandoperez72/' target='_blank'> 
    <img src='linkedin_little.svg'> 
    </a> <a href='mailto:fernando.perez@ffis.es'> <img src='email.svg'></a></h4><br>
    For any suggestion or bug, please contact us")
                         )
                     )
                 )
          ),
          column(width = 6,
                 sankeyNetworkOutput("sankey"))
      ),
      fluidRow(
        column(width =12, offset = 2,
          miBoxPlus(
              title = "Simple Enrichment",
              closable = FALSE,
              width = 4,
              background = "limon",
              height = "250px",
              tags$p("Enter a single list of genes or proteins in one of the different annotation format allowed 
                     and the integrated species to get a full functional enrichment analysis, plus other extra images with many tables and plots, based mainly
                     on Kyoto Encyclopedia of Genes and Genomes (", a("Kegg", href="https://www.genome.jp/kegg/pathway.html"), 
                     ") pathways database, Gene Ontology terms resource (", a("GO", href="http://geneontology.org"), ") 
                     and Gene Set Enrichment Analysis (", a("GSEA", href="https://www.gsea-msigdb.org/gsea/index.jsp"),")."),
              tags$br(),
              fluidRow(
                  column(
                      align = "center",
                      width = 2,
                      dropdown(
                          style = "unite",
                          icon = icon("info"),
                          status = "primary",
                          width = "600px",
                          animate = animateOptions(
                              enter = animations$fading_entrances$fadeInLeftBig,
                              exit = animations$fading_exits$fadeOutRightBig
                          ),
                          box(
                              width = 15,
                              status = "primary",
                              height = "150px",
                              title = tags$strong("EnrichApp 2020"),
                              background = "light-blue",
                              tags$h4(
                                  "Annotation gene names: Ensembl and Gene Symbol."
                              )
                          )
                      ),# fin dropdown
                  ),#fin column
                  column(
                      width = 8,
                      align = "center",
                      actionBttn(
                          inputId = "simple",
                          label = "Go Simple EnrichApp",
                          style = "jelly",
                          color = "primary",
                      )
                  ) #fin column
              ) # fin fluid row
          ), # fin miboxplus 1
          # miBoxPlus(
          #     title = "Count importer & DE analysis",
          #     closable = FALSE,
          #     width = 4,
          #     background = "limon",
          #     height = "250px",
          #     tags$p("Create a DESeq2 object starting from the counting matrix of your transcriptomics experiment. Add a file with the 
          #            samples description, insert your design and the contrast of interest that you would like to test 
          #            and get an object ready for differential expression gene analysis and enrichment exploration."),
          #     tags$br(),
          #     fluidRow(
          #         column(
          #             align = "center",
          #             width = 2,
          #             dropdown(
          #                 style = "unite",
          #                 icon = icon("info"),
          #                 status = "primary",
          #                 width = "600px",
          #                 animate = animateOptions(
          #                     enter = animations$fading_entrances$fadeInDownBig,
          #                     exit = animations$fading_exits$fadeOutDownBig
          #                 ),
          #                 box(
          #                     width = 12,
          #                     status = "primary",
          #                     height = "300px",
          #                     title = tags$strong("Enrich app 2020"),
          #                     background = "light-blue",
          #                     tags$h4(
          #                         "The accepted format for the counting file is a .csv file in which 
          #                         the columns are samples and the rows are genes."
          #                     )
          #                 )
          #             ), # fin dropdown
          #         ), #fin column
          #         column(
          #             width = 8,
          #             align = "center",
          #             actionBttn(
          #                 inputId = "import",
          #                 label = "Go importer & DE",
          #                 style = "jelly",
          #                 color = "primary",
          #             )
          #         ) #fin column
          #     ) # fin fluid row
          # ), # fin miboxplus 2

          miBoxPlus(
              title = "DESeq enrichment",
              closable = FALSE,
              width = 4,
              background = "limon",
              height = "250px",
              tags$p("Enter a DESeq2 object with the designs or contrasts you are interested in, 
                     or a counting matrix plus a sample table information; indicate the 
                     annotation and the specie and generate a full functional enrichment analysis, plus other extra images with many tables and plots, based mainly
                     on Kyoto Encyclopedia of Genes and Genomes (", a("Kegg", href="https://www.genome.jp/kegg/pathway.html"), 
                     ") pathways database, Gene Ontology terms resource (", a("GO", href="http://geneontology.org"), ") 
                     and Gene Set Enrichment Analysis (", a("GSEA", href="https://www.gsea-msigdb.org/gsea/index.jsp"),")."),
              tags$br(),
              fluidRow(
                  column(
                      align = "center",
                      width = 2,
                      dropdown(
                          style = "unite",
                          icon = icon("info"),
                          status = "primary",
                          width = "600px",
                          animate = animateOptions(
                              enter = animations$fading_entrances$fadeInRightBig,
                              exit = animations$fading_exits$fadeOutLeftBig
                          ),
                          box(
                              width = 15,
                              status = "primary",
                              height = "150px",
                              title = tags$strong("EnrichApp 2020"),
                              background = "light-blue",
                              tags$h4(
                                  "Formats allowed: a compressed RDS file containing the DESeq object
                                  or a .txt, .tsv or .xlsx file containing the counting matrix plus 
                                  the sample data information."
                              )
                          )
                      ),
                      # fin dropdown
                  ),
                  #fin column
                  column(
                      width = 8,
                      align = "center",
                      actionBttn(
                          inputId = "enrich",
                          label = "Go DESeq EnrichApp",
                          style = "jelly",
                          color = "primary",
                      )
                  ) #fin column
              ) # fin fluid row
          )) # fin miboxplus 3
      ) # fin fluidrow 
  ) # fin dashboardbody
) # fin dashboarpage

# Plug router into Shiny server.
server <- function(input, output) {
  shinyjs::onclick("enrich", runjs("window.open('http://155.54.120.105/shiny/enrichappDark/','_blank')") )
  shinyjs::onclick("simple", runjs("window.open('http://155.54.120.105/shiny/enrich_listable/','_blank')") )
  
  
  observeEvent(input$statButton, {
    showModal(popupModal())
  })
  
  #########################
  output$distPlot <- renderTmap({
    tm_shape(dataWorld) + tm_polygons("count") +
      tm_layout(legend.format = list(format="d") ) +
      tm_view(set.view = 0.5, view.legend.position = c("left","bottom") ) +
      tmap_options(basemaps = "OpenStreetMap")
  
  })
  #########################
  output$visits <- renderValueBox({
    valueBox(sum(dataWorld$count, na.rm = T), "Visits", width = 1, icon = icon("eye"), color="orange")
  })
  
  
  # output$sankey <- renderSankeyNetwork({
  #     links <- data.frame(
  #         source=c("DEseq","DEseq","DEseq","DEseq","DEseq",
  #                  "UserGeneList", "GeneList",
  #                  "ExprsMatrix","ExprsMatrix",
  #                  "SampleData",
  #                  "GeneList+Pval+logFC","GeneList+Pval+logFC","GeneList+Pval+logFC",
  #                  "Exprs","ColData","logFC","Pval","logFC","Pval","Exprs","Exprs","ColData",
  #                  "Exprs","ColData","Exprs","ColData","Exprs","ColData","logFC","Pval",
  #                  "EnrichObj","EnrichObj","EnrichObj","EnrichObj","EnrichObj",
  #                  "EnrichObj","EnrichObj","EnrichObj","Pval","logFC","EnrichObj","Pval","logFC",
  #                  "EnrichObj","Pval","logFC"), 
  #         target=c("Exprs","ColData","logFC","Pval","GeneList",
  #                  "GeneList", "EnrichObj",
  #                  "Exprs","GeneList",
  #                  "ColData",
  #                  "GeneList","Pval","logFC",
  #                  "PCA","PCA","Volcano","Volcano","MA","MA","MA","Boxplot/Violin","Boxplot/Violin",
  #                  "Heatmap","Heatmap","Cluster","Cluster","TopGene","TopGene","Karyoplot","Karyoplot",
  #                  "KeggBarplot","KeggChorplot","KeggDotplot","KeggHeatmap","KeggNetplot",
  #                  "GOBar","GODot","GOplotBar","GOplotBar","GOplotBar","GOCircle","GOCircle","GOCircle",
  #                  "GSEA","GSEA","GSEA"), 
  #         value=rep(3,46)
  #     )
  
  
  output$sankey <- renderSankeyNetwork({
 links <- data.frame(
      source=c("User DEseq Object","User DEseq Object","User DEseq Object","User DEseq Object",
               "ColData",
               "Expression Matrix",
               "User Gene List", "Gene List",
               "User Expression Matrix","User Expression Matrix",
               "Expression Matrix",
               "Pval + logFC",
               "User Gene List + Pval + logFC","User Gene List + Pval + logFC",
               "Gene List","Gene List","Gene List",
               "Expression Plots","Sample Info. Plots","Statistics Plots","Statistics Plots","Expression Plots","Expression Plots","Sample Info. Plots",
               "Expression Plots","Sample Info. Plots","Expression Plots","Sample Info. Plots","Expression Plots","Sample Info. Plots","Statistics Plots",
               "Enrichment Plots","Enrichment Plots","Enrichment Plots","Enrichment Plots","Enrichment Plots",
               "Enrichment Plots","Enrichment Plots","Enrichment Plots","Statistics Plots","Enrichment Plots","Statistics Plots",
               "Enrichment Plots","Statistics Plots"), 
      target=c("Gene List","Pval + logFC","Expression Matrix","ColData",
               "Sample Info. Plots",
               "Expression Plots",
               "Gene List", "Enrichment Plots",
               "Gene List", "Expression Matrix",
               "Sample Info. Plots",
               "Statistics Plots",
               "Gene List","Pval + logFC",
               "Statistics Plots","Expression Plots","Sample Info. Plots",
               "PCA","PCA","Volcano","MA","MA","Boxplot/Violin","Boxplot/Violin",
               "Heatmap","Heatmap","Cluster","Cluster","TopGene","TopGene","Karyo plot",
               "Kegg Barplot","Kegg Chorplot","Kegg Dotplot","Kegg Heatmap","Kegg Netplot",
               "GO Bar","GO Dot","GO plotBar","GO plotBar","GO Circle","GO Circle",
               "GSEA","GSEA"), 
      value=rep(3,44)
      )
    # From these flows we need to create a node data frame: it lists every entities involved in the flow
    nodes <- data.frame(
      name=c(as.character(links$source), 
      as.character(links$target)) %>% unique()
    )
    # With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
    links$IDsource <- match(links$source, nodes$name)-1 
    links$IDtarget <- match(links$target, nodes$name)-1
    links$group <- "blue"
    my_color <- 'd3.scaleOrdinal() .domain(["blue"]) .range(["blue"])'
    
    # Make the Network
    sankeyNetwork(Links = links, Nodes = nodes,
                  Source = "IDsource", Target = "IDtarget",
                  Value = "value", NodeID = "name", 
                  sinksRight=TRUE, fontSize = 14, margin=0)

  })
}

# Run server in a standard way.
shinyApp(ui, server)