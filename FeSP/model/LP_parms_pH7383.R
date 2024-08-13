# file names containing the experimental datasets (limit to max of 5!)
DATA_FOLDER <- "/src/FeSPads/data/"
data_files  <- c("pH7383R1",
                 "pH7383R2",
                 "pH7383R3",
                 "pH7383R4",
                 "pH7383R5")

# model parameters, default values
default.pars <- list(
  tau         = 25,     # residence time [min]; tau=V/Q, Q = 1 mL/min, V = 25 mL
  n           = 0.9,
  m           = 1,
  y           = 1,
  kSads2kdes  = 0.000001,
  log_kSads   = -3,
  log_kFe     = -1.34,
  Sin         = 1.55,    # [mmol S], inflow Stot concentration
  kPads2kdes  = 0.33,
  log_kPads   = -4,
  log_kS.fast = -0.58,
  log_kS.slow = -2.1,
  PS_interference = 0.0004,
  Fe.ini      = 10.3,   # [mmol Fe], initial mineral loading
  P.ini       = 0,
  Pads.ini    = 0.096,
  x.fast      = 0.5,
  S.ini       = 0,
  Sads.ini    = 0
)

# data-specific values for specific parameters (limit to max of 5!)
Fe.ini   <- c(0, 9.3, 11.20, 13.20,  14.00)
P.ini    <- c(0, 0.000, 0.000, 0.011,  0.0105)
Pads.ini <- c(0, 0.000, 0.000, 0.14,  0.145)
x.fast   <- c(0, 0.000, 0.000, 0.15,  0.15)

outtimes    <- seq(from = 0, to = 450, length.out = 250)  # time in minutes
