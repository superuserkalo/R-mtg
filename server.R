library(shiny)
library(RSQLite)
library(sodium)
library(glue)
library(shinyalert)

account_init <- function(username, password){
  conn <- dbConnect(RSQLite::SQLite(), dbname = "MTG.db")
  
  table_exists <- dbExistsTable(conn,username)
  
  if (table_exists) {
    shinyalert("Account already exists", "The account for this username already exists.", type = "error")
  } else {
    dbExecute(conn, glue("
    CREATE TABLE IF NOT EXISTS {username} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username_hash BLOB NOT NULL,
      password_hash BLOB NOT NULL
      )
    "))
    username_hash <- sodium::password_store(username)
    password_hash <- sodium::password_store(password)
    
    dbExecute(conn, glue("INSERT INTO {username} (username_hash, password_hash) VALUES (?, ?)"),
              params = list(username_hash, password_hash))
    
    dbDisconnect(conn)
    
    shinyalert("Account created", "The account has been successfully created.", type = "success")  
  }
}

server <- function(input, output, session) {
  
  observeEvent(input$createAccount, {
    username_string <- input$usernameInput
    password_string <- input$passInput
    
    account_init(username_string,password_string)    

    })
}


