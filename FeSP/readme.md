---
README
Date: 14 August 2024

Project Overview
This repository contains the models and data for the paper titled "Kinetics of the Release of Adsorbed Phosphate Accompanying the Reaction of Lepidocrocite (gamma-FeOOH) with Dissolved Sulfide."

Contents
data/: Folder containing all datasets used in the experiments.
model/: Contains the code for the FTR (Flow Through Reactor) model.
MCMC/: Contains scripts for conducting Markov Chain Monte Carlo (MCMC) tests.
Prerequisites
Ensure that you have both "R" and "RStudio" installed on your device. Additionally, several R packages are required. Please install and configure these packages before attempting to run any of the code provided.

Installation
R and RStudio: Ensure you have the latest versions installed.
R Packages: Install necessary packages using install.packages("package_name") within RStudio.
Running the Code
FTR Model
Navigate to the model/ directory.
Open LP_app.R.
Ensure the data path in the script is correctly linked to your local setup.
Run the app by clicking "Run App" or using the shortcut Shift + Cmd + Enter to launch the web-based model interface.
Note: For clarity, some model parameters in the code are named differently from those used in the paper.

MCMC Tests
Adjust the file paths for the data.
Install any required R packages not previously set up.
Execute the scripts block by block due to the potentially lengthy computation times.
Support
For any queries or issues, please contact:

Mingkai Ma, Utrecht University
PM via github: @mamingkai (https://mamingkai.github.io/)
Email: m.ma@uu.nl
