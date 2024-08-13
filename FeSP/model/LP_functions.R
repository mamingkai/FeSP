# functions required to run the FeSPads model as a shiny app
# L.Polerecky, 17-04-2022

# model function (to calculate dc/dt)
FeSPmodel <- function(t, state, parms) {
  with (as.list(c(state, parms)),{

    # do this to avoid that the power of a tiny negative number gives NaN
    Fe        <- max(0, Fe)
    S         <- max(0, S)
    P         <- max(0, P)
    Sads      <- max(0, Sads)
    Pads.slow <- max(0, Pads.slow)
    Pads.fast <- max(0, Pads.fast)

    # convert rate constants from log10-scale to lin-scale
    kFe       <- 10^log_kFe # [mmol Fe min-1]
    kPads     <- 10^log_kPads
    kPads     <- 10^log_kPads
    kS.fast   <- 10^log_kS.fast
    kS.slow   <- 10^log_kS.slow
    kSads     <- 10^log_kSads

    # calculate additional rate constants
    kPdes    <- kPads/kPads2kdes
    kSdes     <- kSads/kSads2kdes
    D         <- 1/tau

    # rate expressions [mol/m3/d]
    #R         <- kFe   * S^m * Fe.ini^(1-n) * Fe^n
    Fe.term <- ifelse(Fe.ini<0.01,0,Fe.ini^(1-n) * Fe^n)#in case Fe=0 then gives a NA
    R         <- kFe   * S^m * Fe.term
    Rads      <- kPads * P   * Fe.term
    RSads     <- kSads * S   * Fe.term
    RSdes     <- kSdes * Sads
    Rdes.fast <- kPdes * Pads.fast
    Rdes.slow <- kPdes * Pads.slow
    RHS.fast  <- kS.fast^y * Pads.fast * S^y
    RHS.slow  <- kS.slow^y * Pads.slow * S^y
    RPdes.term<- ifelse(Fe.ini<0.01,0,R * (Pads.fast+Pads.slow)/Fe)
    # (Pads.fast+Pads.slow)/Fe)#incase Fe=0,gives NA
    # RPdes.stoi <- kPdes* RPdes.term # = kPdes* RPdes.term,however it`s fitted without the k for now.
    RPdes.stoi <- RPdes.term
    Sinflow   <- D * Sin
    Soutflow  <- D * S
    Poutflow  <- D * P

    # Time-derivatives:
    dFe.dt        <- -R
    dS.dt         <- -3/2*R + Sinflow - Soutflow - RSads + RSdes - RHS.fast - RHS.slow
    dSads.dt      <-  RSads - RSdes + RHS.fast + RHS.slow
    dP.dt         <- -Rads + RPdes.stoi + RHS.fast + RHS.slow - Poutflow
    dPads.fast.dt <-  Rads * x.fast      - Rdes.fast - RHS.fast - R*((Pads.fast)/Fe)
    dPads.slow.dt <-  Rads * (1-x.fast)  - Rdes.slow - RHS.slow - R*((Pads.slow)/Fe)

    list(c(dFe.dt, dS.dt, dSads.dt, dP.dt, dPads.fast.dt, dPads.slow.dt),

         # other output: process rates
         R.Fe        = R,
         R.Pads      = Rads,
         R.Pdes.slow = Rdes.slow,
         R.Pdes.fast = Rdes.fast,
         R.Pdes.stoi = RPdes.stoi,
         RHS.slow    = RHS.slow,
         RHS.fast    = RHS.fast,
         R.Sads      = RSads,
         R.Sdes      = RSdes
    )
  })
}
#convert the model function to a character string, later parse
FeSPmodel_string <- deparse(expr = FeSPmodel)
# calculate initial state from the parameters
get.state.ini <- function(parms){
  with(as.list(parms),{
    state.ini <- c( 
      Fe        = Fe.ini, 
      S         = S.ini, 
      Sads      = Sads.ini, 
      P         = P.ini, 
      Pads.fast = Pads.ini*x.fast, 
      Pads.slow = Pads.ini*(1-x.fast) 
    )
    return(state.ini)
  })
}

# update dataset-specific parameters
update.pars <- function(parms, ind=1, Fe.ini=1, P.ini=1, Pads.ini=1, x.fast=1){
  parms$Fe.ini   <- Fe.ini  [ind]
  parms$P.ini    <- P.ini   [ind]
  parms$Pads.ini <- Pads.ini[ind]
  parms$x.fast   <- x.fast  [ind]
  return(parms)
}

# figure out the best mfrow setting based on the number of displayed graphs
get.mfrow <- function(w=1){
  if (length(w)>9){
    cols <- 4
    rows <- ceiling(length(w)/cols)
  } 
  else if (length(w)>4){
    cols <- 3
    rows <- ceiling(length(w)/cols)
  }
  else if (length(w)>2){
    cols <- 2
    rows <- 2
  }
  else if (length(w)==2){
    cols <- 2
    rows <- 1
  }
  else {
    cols <- 1
    rows <- 1
  }
  return(c(rows, cols))
}

# import experimental data as a data.frame
importdata <- function(data_choice=1){
  # input folder
  bdir <- paste(here(), DATA_FOLDER, sep="")
  # load the data from a specific file
  input_file  <- paste(bdir, data_files[data_choice], ".csv", sep="")
  data <- read.csv(file = input_file)
  return( data.frame( data ) )
}

#save results as a data.frame
savedata <- function(data,uniquetext) {
  # data <- t(data) #transpose data
  outputDir <- "/Users/mamingkai/Desktop/"
  # Create a unique file name
  fileName <- sprintf("%s_%s_%s.csv", as.character(uniquetext),Sys.time(), digest::digest(data))
  # Write the file to the local system
  write.csv(
    x = data,
    file = file.path(outputDir, fileName), 
    row.names = T, col.names=T, quote = TRUE
  )
}

#save file
# define a function that takes a data frame and a simulation name and
# returns a new data frame with a "simulation" column added to it
# and the "simulation" column moved to the first position
add_simulation_column <- function(df, simulation) {
  df %>% 
    dplyr::mutate(simulation=simulation) %>%
    dplyr::select(simulation, everything())
}

