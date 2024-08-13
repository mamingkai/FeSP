require(shiny)
require(shinyWidgets)
require(here)
require(deSolve)
require(shinyAce)
require(dplyr)
# load functions from an external file (to keep things tidy)
source("LP_functions.R")

# load parameters from an external file
# this can be changed depending on the datasets we want to analyze

# source("LP_parms_pH7373.R")
source("LP_parms_pH7383.R")
# source("LP_parms_pH8373.R")
# source("LP_parms_pH8383.R")
# source("LP_parms_buffer.R")
# Fe.ini can`t = 0


## NO NEED TO CHANGE BELOW HERE

# generate 5 parameter lists with default values and dataset-specific values
pars1 <- update.pars(default.pars, ind=1, 
                     Fe.ini=Fe.ini, P.ini=P.ini, Pads.ini=Pads.ini, x.fast=x.fast)
pars2 <- update.pars(default.pars, ind=2, 
                     Fe.ini=Fe.ini, P.ini=P.ini, Pads.ini=Pads.ini, x.fast=x.fast)
pars3 <- update.pars(default.pars, ind=3, 
                     Fe.ini=Fe.ini, P.ini=P.ini, Pads.ini=Pads.ini, x.fast=x.fast)
pars4 <- update.pars(default.pars, ind=4, 
                     Fe.ini=Fe.ini, P.ini=P.ini, Pads.ini=Pads.ini, x.fast=x.fast)
pars5 <- update.pars(default.pars, ind=5, 
                     Fe.ini=Fe.ini, P.ini=P.ini, Pads.ini=Pads.ini, x.fast=x.fast)

# import experimental data from 5 datasets
EXPDATA <- as.list(rep(0, length(data_files)))
for(i in 1:length(data_files)){
  EXPDATA[[i]] <- importdata(data_choice = i)
}

# define the main shiny GUI
ui <- fluidPage(
  
  h4(paste0("FeSPmodel-",substring(data_files[1],1,6))),
  
  sidebarLayout(
    sidebarPanel(width = 4,
                 
      tabsetPanel(
        
        tabPanel("Common Parameters",
               fluidRow(
                 column(4,helpText(strong("Sulfidation 1")),
                        numericInput(inputId="tau", label = "tau=V/Q (min)",
                                     min = 10, max = 60, step = 1, value = default.pars$tau),
                        numericInput(inputId="n", label = "n",
                                     min = 0, max = 1, step = 0.01, value = default.pars$n),
                        numericInput(inputId="m", label = "m",
                                     min = 0, max = 5, step = 0.01, value = default.pars$m),
                        numericInput(inputId="y", label = "y",
                                     min = 0, max = 2, step = 0.01, value = default.pars$y)
                        ),
                 column(4,helpText(strong("Sulfidation 2")),
                        numericInput(inputId="kSads2kdes", label = "kSads/kSdes",
                                     min = 0, max = 1, step = 0.01, value = default.pars$kSads2kdes),
                        numericInput(inputId="log_kSads", label = "log(kSads)",
                                     min = -10, max = 1, step = 0.01, value = default.pars$log_kSads),
                        numericInput(inputId="log_kFe", label = "log(kFe)",
                                     min = -10, max = 2, step = 0.01, value = default.pars$log_kFe),
                        numericInput(inputId="Sin", label = "Sin",
                                     min = 0, max = 2, step = 0.01, value = default.pars$Sin)
                        ),
                 column(4,helpText(strong("P release")),
                        numericInput(inputId="kPads2kdes", label = "kPads/kPdes",
                                     min = 0, max = 1, step = 0.01, value = default.pars$kPads2kdes),
                        numericInput(inputId="log_kPads", label = "log(kPads)",
                                     min = -10, max = 1, step = 0.01, value = default.pars$log_kPads),
                        numericInput(inputId="log_kS.fast", label = "log(kS.fast)",
                                     min = -10, max = 1, step = 0.001, value = default.pars$log_kS.fast),
                        numericInput(inputId="log_kS.slow", label = "log(kS.slow)",
                                     min = -10, max = 1, step = 0.001, value = default.pars$log_kS.slow),
                        numericInput(inputId="PS_interference", label = "P/S-interference",
                                     min = -0.003, max = 0.003, step = 0.0001, value = default.pars$PS_interference)
                        )
               )
      ),
      
      tabPanel("Data-specific parameters",
               fluidRow(
                 column(3,helpText(strong("Fe.ini")),
                        numericInput(inputId="Fe.ini.1", label = NULL, 
                                     min = 0, max = 20, step = 0.1, value = pars1$Fe.ini),
                        numericInput(inputId="Fe.ini.2", label = NULL,
                                     min = 0, max = 20, step = 0.1, value = pars2$Fe.ini),
                        numericInput(inputId="Fe.ini.3", label = NULL,
                                     min = 0, max = 20, step = 0.1, value = pars3$Fe.ini),
                        numericInput(inputId="Fe.ini.4", label = NULL,
                                     min = 0, max = 20, step = 0.1, value = pars4$Fe.ini),
                        numericInput(inputId="Fe.ini.5", label = NULL,
                                     min = 0, max = 20, step = 0.1, value = pars5$Fe.ini)
                 ),
                 column(3,helpText(strong("P.ini")),
                        numericInput(inputId="P.ini.1", label = NULL,
                                     min = 0, max = 0.02, step = 0.01, value = pars1$P.ini),
                        numericInput(inputId="P.ini.2", label = NULL,
                                     min = 0, max = 0.02, step = 0.01, value = pars2$P.ini),
                        numericInput(inputId="P.ini.3", label = NULL,
                                     min = 0, max = 0.02, step = 0.01, value = pars3$P.ini),
                        numericInput(inputId="P.ini.4", label = NULL,
                                     min = 0, max = 0.02, step = 0.01, value = pars4$P.ini),
                        numericInput(inputId="P.ini.5", label = NULL,
                                     min = 0, max = 0.02, step = 0.01, value = pars5$P.ini)
                 ),
                 column(3,helpText(strong("Pads.ini")),
                        numericInput(inputId="Pads.ini.1", label = NULL,
                                     min = 0, max = 0.2, step = 0.01, value = pars1$Pads.ini),
                        numericInput(inputId="Pads.ini.2", label = NULL,
                                     min = 0, max = 0.2, step = 0.01, value = pars2$Pads.ini),
                        numericInput(inputId="Pads.ini.3", label = NULL,
                                     min = 0, max = 0.2, step = 0.01, value = pars3$Pads.ini),
                        numericInput(inputId="Pads.ini.4", label = NULL,
                                     min = 0, max = 0.2, step = 0.01, value = pars4$Pads.ini),
                        numericInput(inputId="Pads.ini.5", label = NULL,
                                     min = 0, max = 0.2, step = 0.01, value = pars5$Pads.ini)
                 ),
                 column(3,helpText(strong("x.fast")),
                        numericInput(inputId="x.fast.1", label = NULL,
                                     min = 0, max = 1, step = 0.01, value = pars1$x.fast),
                        numericInput(inputId="x.fast.2", label = NULL,
                                     min = 0, max = 1, step = 0.01, value = pars2$x.fast),
                        numericInput(inputId="x.fast.3", label = NULL,
                                     min = 0, max = 1, step = 0.01, value = pars3$x.fast),
                        numericInput(inputId="x.fast.4", label = NULL,
                                     min = 0, max = 1, step = 0.01, value = pars4$x.fast),
                        numericInput(inputId="x.fast.5", label = NULL,
                                     min = 0, max = 1, step = 0.01, value = pars5$x.fast)
                 )
               )
      ),
      
      tabPanel("Display",
               fluidRow(
                 column(3,
                        prettyCheckboxGroup(inputId="disp_datasets",
                                            choices = data_files,
                                            label = strong("Datasets"),
                                            selected = data_files[c(1,4)])
                 ),
                 column(3,
                        prettyCheckboxGroup(inputId="disp_variables",  
                                            choices = c("Fe", "S", "Sads", "P", "Pads.fast", "Pads.slow"),
                                            label = strong("Variables"),
                                            selected = c("S", "P"))
                 ),
                 column(3,
                        prettyCheckboxGroup(inputId="disp_rates1",  
                                            choices = c("R.Fe","R.Pads","R.Pdes.stoi","R.Pdes.slow","R.Pdes.fast"),
                                            label = strong("Rates 1"),
                                            selected = NULL)
                 ),
                 column(3,
                        prettyCheckboxGroup(inputId="disp_rates2",  
                                            choices = c("RHS.slow","RHS.fast","R.Sads","R.Sdes"),
                                            label = strong("Rates 2"),
                                            selected = NULL)
                 )
               )
      )
      
      
      
    ) # end of tabsetPanel, now next element in the sidebarPanel
    
    # br()
    
    ### if buttons were useful
    # fluidRow(
    #   column(4,
    #          actionButton(inputId="Button1",
    #                       label="Button 1")
    #   ),
    #   column(4,
    #          actionButton(inputId="Button2", 
    #                       label="Button 2")
    #   ),
    #   column(4,
    #          actionButton(inputId="Button3",
    #                       label="Button 3")
    #   )
    # ) # end of fluidRow
    
    ), # end of sidebarPanel, now next element in sidebarLayout
    
    mainPanel(width = 8,
      tabsetPanel(
        tabPanel("Plot",plotOutput("PlotFeSP", width = "900px", height = "700px"),
                 actionBttn(inputId = "save_file",label = "Save current",no_outline = T)),
        tabPanel("Model Expressions",
                 column(12,
                        # textInput(inputId = "code", label = "Model expressions", value = FeSPmodel_string, width="600px"), 
                        aceEditor("code",height = "700px",
                                  value = FeSPmodel_string),
                        prettyCheckbox(inputId = "eval", label = "Evaluate",value = F)
                        )
        ))
    )
    
  ) # end of sidebarLayout
) # end of fluidPage

## ---------------------------------------------------------------------------------
server <- function(input, output) {
  
  getpars <- reactive( {
    pars            <- default.pars
    
    # update common parameters
    pars$tau         <- input$tau
    pars$n           <- input$n
    pars$m          <- input$m
    pars$y           <- input$y
    pars$kSads2kdes  <- input$kSads2kdes
    pars$log_kSads   <- input$log_kSads
    pars$log_kFe     <- input$log_kFe
    pars$Sin         <- input$Sin
    pars$kPads2kdes  <- input$kPads2kdes
    pars$log_kPads   <- input$log_kPads
    pars$log_kS.fast <- input$log_kS.fast
    pars$log_kS.slow <- input$log_kS.slow
    pars$PS_interference <- input$PS_interference
    
    # update data-specific parameters
    pars1 <- pars2 <- pars3 <- pars4 <- pars5 <- pars
    
    pars1$Fe.ini     <- input$Fe.ini.1
    pars2$Fe.ini     <- input$Fe.ini.2
    pars3$Fe.ini     <- input$Fe.ini.3
    pars4$Fe.ini     <- input$Fe.ini.4
    pars5$Fe.ini     <- input$Fe.ini.5
    
    pars1$P.ini      <- input$P.ini.1
    pars2$P.ini      <- input$P.ini.2
    pars3$P.ini      <- input$P.ini.3
    pars4$P.ini      <- input$P.ini.4
    pars5$P.ini      <- input$P.ini.5
    
    pars1$Pads.ini   <- input$Pads.ini.1
    pars2$Pads.ini   <- input$Pads.ini.2
    pars3$Pads.ini   <- input$Pads.ini.3
    pars4$Pads.ini   <- input$Pads.ini.4
    pars5$Pads.ini   <- input$Pads.ini.5
    
    pars1$x.fast     <- input$x.fast.1
    pars2$x.fast     <- input$x.fast.2
    pars3$x.fast     <- input$x.fast.3
    pars4$x.fast     <- input$x.fast.4
    pars5$x.fast     <- input$x.fast.5
    
    return(list(pars1=pars1, pars2=pars2, pars3=pars3, pars4=pars4, pars5=pars5))
  })
  
  shinyEnv <- environment() 
  codeInput <- reactive({ input$code })
  output$PlotFeSP <- renderPlot({     # will be visible in the main panel
    
    # update parameters using the above reactive function
    pars <- getpars()

    # calculate model solutions for all 5 parameter sets
    out1 <- ode(y = get.state.ini(pars$pars1), parms = pars$pars1, func  = FeSPmodel, times = outtimes)
    out2 <- ode(y = get.state.ini(pars$pars2), parms = pars$pars2, func  = FeSPmodel, times = outtimes)
    out3 <- ode(y = get.state.ini(pars$pars3), parms = pars$pars3, func  = FeSPmodel, times = outtimes)
    out4 <- ode(y = get.state.ini(pars$pars4), parms = pars$pars4, func  = FeSPmodel, times = outtimes)
    out5 <- ode(y = get.state.ini(pars$pars5), parms = pars$pars5, func  = FeSPmodel, times = outtimes)
    if (input$eval == T){
      FeSPmodel_eval <- eval(parse(text=codeInput()), envir=shinyEnv)
      out1 <- ode(y = get.state.ini(pars$pars1), parms = pars$pars1, func  = FeSPmodel_eval, times = outtimes)
      out2 <- ode(y = get.state.ini(pars$pars2), parms = pars$pars2, func  = FeSPmodel_eval, times = outtimes)
      out3 <- ode(y = get.state.ini(pars$pars3), parms = pars$pars3, func  = FeSPmodel_eval, times = outtimes)
      out4 <- ode(y = get.state.ini(pars$pars4), parms = pars$pars4, func  = FeSPmodel_eval, times = outtimes)
      out5 <- ode(y = get.state.ini(pars$pars5), parms = pars$pars5, func  = FeSPmodel_eval, times = outtimes)
    }
    # "massage" the data by adding a S-dependent offset to the P-data (analytical interference?)
    PS_interference <- pars$pars1$PS_interference
    # out1[,"P"] <- out1[,"P"] + out1[,"S"]*PS_interference
    # out2[,"P"] <- out2[,"P"] + out2[,"S"]*PS_interference
    # out3[,"P"] <- out3[,"P"] + out3[,"S"]*PS_interference
    out4[,"P"] <- out4[,"P"] + out4[,"S"]*PS_interference
    out5[,"P"] <- out5[,"P"] + out5[,"S"]*PS_interference
    
    # figure out which variables/rates to display
    w <- c(input$disp_variables, input$disp_rates1, input$disp_rates2)

    # figure out which data to display (experimental and model)
    ind <- match(input$disp_datasets, data_files)
    OBS <- NULL
    if (length(ind)>0) # for some reason, the ifelse() does not work, so I do it this way
      OBS <- EXPDATA[ind]
    
    # # generate command to display the data
    PLOT_OUT     <- c("out1", "out2", "out3", "out4", "out5")
    PLOT_OPTIONS <- c("which=w, mfrow = get.mfrow(w)",
                      "obs = OBS", # include experimental data
                      "obspar = list(col=ind)",
                      "lwd = 3, las = 1, lty = 1, col=ind",
                      "cex.main = 2, cex.axis = 1.25, cex.lab = 2)")

    # # this is the command to be evaluated:
    CMD <- paste(paste("plot(", toString(PLOT_OUT[c(ind)]), sep=""),
                 toString(PLOT_OPTIONS), sep=",")
    # print(CMD)
    # evaluate the command (if there is anything to be plotted)
    if (length(ind)>0){
      e_CMD <- parse(text=CMD)
      plot <- eval(e_CMD) 
    }
      
    
    
    
#save file
    
    if (input$save_file){
      # create empty lists to store the data frames
      results_list <- list()
      parms_list <- list()
      
      # loop through the "out" and "pars" variables to create the data frames
      for (i in 1:5) {
        results_list[[paste0("out", i)]] <- add_simulation_column(as.data.frame(get(paste0("out", i))), paste0("out", i))
      }
      
      parms_list[[paste0("parm")]] <- add_simulation_column(as.data.frame(pars), paste0("parm"))
      
      # combine the data frames using dplyr::bind_rows()
      results_df <- dplyr::bind_rows(results_list)
      parms_df <- dplyr::bind_rows(parms_list)
      
      # save the data frames to files
      savedata(results_df, uniquetext="results")
      savedata(parms_df, uniquetext="parameters")
    }
    
    
    
  })  # end ouput$PlotFeSP

} # end of the definition of the server function

shinyApp(ui=ui, server=server)
#runGadget(ui, server, viewer = browserViewer(browser = getOption("browser")))
