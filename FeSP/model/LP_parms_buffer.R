# file names containing the experimental datasets (limit to max of 5!)
DATA_FOLDER <- "/src/FeSPads/data/"
data_files  <- c("buffer7373",
                 "buffer7383",
                 "buffer8373",
                 "buffer8383")

# model parameters, default values
default.pars <- list(
  tau         = 25,     # residence time [min]; tau=V/Q, Q = 1 mL/min, V = 25 mL
  n           = 0.9,
  m           = 1,
  y           = 1,
  kSads2kdes  = 0.15,
  log_kSads   = 0,
  log_kFe     = -2.3,
  Sin         = 0,    # [mmol S], inflow Stot concentration
  kPads2kdes  = 0.33,
  log_kPads   = -4,
  log_kS.fast = -1.2,
  log_kS.slow = -2.2,
  PS_interference = 0,
  Fe.ini      = 10.3,   # [mmol Fe], initial mineral loading
  P.ini       = 0,
  Pads.ini    = 0.096,
  x.fast      = 0,
  S.ini       = 0,
  Sads.ini    = 0
)

# data-specific values for specific parameters (limit to max of 5!)
Fe.ini   <- c(rep(14,5))
P.ini    <- c(0.10, 0.10, 0.10, 0.10,  0.10)
Pads.ini <- c(0, 0.000, 0.000, 0.00,  0.00)
x.fast   <- c(0, 0.000, 0.000, 0.000,  0.000)

outtimes    <- seq(from = 0, to = 450, length.out = 250)  # time in minutes
