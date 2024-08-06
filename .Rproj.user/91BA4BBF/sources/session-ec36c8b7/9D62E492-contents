#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)

custom_theme <- bs_theme(
  bg = "#272938",  # Light background color
  fg = "#9DAAB6",  # Dark text color
  primary = "#007bff",  # Primary button color
  secondary = "#9DAAB6",  # Secondary button color
  success = "#28a745",  # Success button color
  danger = "#dc3545",  # Danger button color
  info = "#17a2b8",  # Info button color
  light = "#f8f9fa",  # Light color for backgrounds
  dark = "#343a40"  # Dark color for text
)

# Define UI for application that draws a histogram
ui <- page_fluid(
  
  window_title = "ada",
  title = "HEY",
  card(
    card(
      textInput("EnterUserInput", "Enter Username", ""),
      verbatimTextOutput("value"),
    
      textInput("EnterPassInput", "Enter Password", ""),
      verbatimTextOutput("value"),
    
      actionButton("login", label = "Login", width = 200)
    ),
    card(
      actionButton("createAccount", label = "Create Account", width = 200)
    )
  ), 
  
  theme = custom_theme
)