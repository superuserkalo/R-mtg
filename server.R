library(shiny)
library(RSQLite)
library(sodium)
library(glue)
library(shinyalert)

account_creation <- function(username, password){
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

login <- function(username, password){
  conn <- dbConnect(RSQLite::SQLite(), dbname = "MTG.db")
  
  if (!dbExistsTable(conn, username)) {
    dbDisconnect(conn)
    shinyalert("Login failed!", "The account for this username doesn't exist", type = "error")  
    return(FALSE)
  }
  
  # Retrieve the stored hashes
  query <- glue("SELECT username_hash, password_hash FROM {username} LIMIT 1")
  result <- dbGetQuery(conn, query)
  dbDisconnect(conn)
  
  if (nrow(result) == 0) {
    return(FALSE)
  }
  
  stored_username_hash <- result$username_hash[[1]]
  stored_password_hash <- result$password_hash[[1]]
  
  # Verify username and password
  username_verified <- sodium::password_verify(stored_username_hash, username)
  password_verified <- sodium::password_verify(stored_password_hash, password)
  
  if (!username_verified || !password_verified) {
    shinyalert("Error", "Invalid username or password", type = "error")
    return(FALSE)
  }
  
  return(TRUE)

}

empty_fields <- function(username, password) {
  
  if (is.null(username) || username == "" || 
      is.null(password) || password == "") {
    shinyalert("Error", "Username and password cannot be empty", type = "error")
    return(FALSE)
  }
  return(TRUE)
}



server <- function(input, output, session) {
  
  observeEvent(input$createAccount, {
    username_string <- input$usernameInput
    password_string <- input$passInput
    
    if (empty_fields(username_string,password_string)) {
      account_creation(username_string,password_string)    
      
      updateTextInput(session, "usernameInput", value = "")
      updateTextInput(session, "passInput", value = "")
    }  
    

    })
  
  observeEvent(input$loginAccount, {
    username_string <- input$usernameInput
    password_string <- input$passInput
    
    if (empty_fields(username_string,password_string)) {
      login_successful <- login(username_string,password_string)
      if (login_successful){
        shinyalert("Success", "Login successful!", type = "success")
      }
    }
  })
}


