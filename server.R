#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(RSQLite)
library(digest)
library(glue)
library(shinyalert)




create_user_table <- function(conn, username) 
{
  table_exists <- dbExistsTable(conn, username)
  
  if (table_exists) {
    # Show an alert if the account already exists
    shinyalert("Account already exists", "The account for this username already exists.", type = "error")
  } else {
    # Create the user table if it does not exist
    query <- glue("CREATE TABLE IF NOT EXISTS {username} (id INTEGER PRIMARY KEY AUTOINCREMENT, usernameH BLOB NOT NULL, passwordH BLOB NOT NULL);")
    dbExecute(conn, query)
    # Show an alert if the account was successfully created
    shinyalert("Account created", "The account has been successfully created.", type = "success")
  }
  
}

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  MTdb <- dbConnect(RSQLite::SQLite(), "MTdb.sqlite")
  
  observeEvent(input$createAccount,{
    
    username = input$UserInput
    password = input$PassInput
    
    create_user_table(MTdb, username)
                 
    insertq <- glue("INSERT INTO {username} (usernameH, passwordH) VALUES ('{username}', '{password}')")
    dbExecute(MTdb, insertq)
    
  } ) 
}

