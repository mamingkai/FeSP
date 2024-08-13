# file names containing the experimental datasets (limit to max of 5!)
DATA_FOLDER <- "/src/FeSPads/data/"
data_files  <- c("pH7373R1",
                 "pH7373R2",
                 "pH7373R3",
                 "pH7373R4",
                 "pH7373R5")
# model parameters, default values
default.pars <- list(
  tau         = 25,     # residence time [min]; tau=V/Q, Q = 1 mL/min, V = 25 mL
  n           = 0.9,
  m           = 1,
  y           = 1,
  kSads2kdes  = 0.000001,
  log_kSads   = -3,
  log_kFe     = -1.17,
  Sin         = 1.60,    # [mmol S], inflow Stot concentration
  kPads2kdes  = 0.33,
  log_kPads   = -4,
  log_kS.fast = -0.1,
  log_kS.slow = -1.5,
  PS_interference = 0.001,
  Fe.ini      = 10.3,   # [mmol Fe], initial mineral loading
  P.ini       = 0,
  Pads.ini    = 0.096,
  x.fast      = 0.5,
  S.ini       = 0,
  Sads.ini    = 0
)

# data-specific values for specific parameters (limit to max of 5!)
Fe.ini   <- c(0, 11.3, 12.40, 9.4,  12)
P.ini    <- c(0, 0.000, 0.000, 0.009,  0.009)
Pads.ini <- c(0, 0.000, 0.000, 0.090,  0.115)
x.fast   <- c(0, 0.000, 0.000, 0.1,  0.1)

outtimes    <- seq(from = 0, to = 450, length.out = 250)  # time in minutes

# 
# # model parameters, default values
# default.pars <- list(
#   tau         = 25,     # residence time [min]; tau=V/Q, Q = 1 mL/min, V = 25 mL
#   n           = 1,
#   m          = 0.5,
#   y           = 1.50,
#   kSads2kdes  = 1,
#   log_kSads   = -10,
#   log_kFe     = 1.36,
#   Sin         = 1.6,    # [mmol S], inflow Stot concentration
#   kPads2kdes  = 0.33,
#   log_kPads   = -4,
#   log_kS.fast = 0.41,
#   log_kS.slow = -0.712,
#   PS_interference = 0.0017,
#   Fe.ini      = 10.3,   # [mmol Fe], initial mineral loading
#   P.ini       = 0,
#   Pads.ini    = 0.096,
#   x.fast      = 0.1,
#   S.ini       = 0,
#   Sads.ini    = 0
# )
# 
# # data-specific values for specific parameters (limit to max of 5!)
# Fe.ini   <- c(0, 11.40, 12.70, 9.200,  11.60)
# P.ini    <- c(0, 0.000, 0.000, 0.0096, 0.0100)
# Pads.ini <- c(0, 0.000, 0.000, 0.090,  0.100)
# x.fast   <- c(0, 0.000, 0.000, 0.105,  0.100)
# 
# outtimes    <- seq(from = 0, to = 410, length.out = 250)  # time in minutes