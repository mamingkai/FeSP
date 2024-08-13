# file names containing the experimental datasets (limit to max of 5!)
DATA_FOLDER <- "/src/FeSPads/data/"
data_files  <- c("pH8383R1",
                 "pH8383R2",
                 "pH8383R3",
                 "pH8383R4",
                 "pH8383R5")

# model parameters, default values
default.pars <- list(
  tau         = 25,     # residence time [min]; tau=V/Q, Q = 1 mL/min, V = 25 mL
  n           = 1,
  m           = 1,
  y           = 1,
  kSads2kdes  = 0.4,
  log_kSads   = 0,
  log_kFe     = -2.7,
  Sin         = 1.8,    # [mmol S], inflow Stot concentration
  kPads2kdes  = 0.33,
  log_kPads   = -4,
  log_kS.fast = -0.73,
  log_kS.slow = -2.7,
  PS_interference = 0.0008,
  Fe.ini      = 10.3,   # [mmol Fe], initial mineral loading
  P.ini       = 0,
  Pads.ini    = 0.0,
  x.fast      = 0.3,
  S.ini       = 0,
  Sads.ini    = 0
)

# data-specific values for specific parameters (limit to max of 5!)
Fe.ini   <- c(0, 9.4, 9.6, 9.5, 8.5)
P.ini    <- c(0, 0.000, 0.000, 0.0125,  0.0045)
Pads.ini <- c(0, 0.000, 0.000, 0.065,  0.055)
x.fast   <- c(0, 0.000, 0.000, 0.400,  0.400)

outtimes    <- seq(from = 0, to = 450, length.out = 250)  # time in minutes
