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

create_user_table <- function(conn, username) 
{
  
  query <- glue("CREATE TABLE IF NOT EXISTS {username} (id INTEGER PRIMARY KEY AUToINCREMENT, usernameH BLOB NOT NULL, passwordH BLOB NOT NULL);")
  
  dbExecute(conn, query)
  
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

