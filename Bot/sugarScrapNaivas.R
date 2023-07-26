library(rvest)
library(RMySQL)
library(DBI)
library(taskscheduleR)
library(RMariaDB)

send_to_db <- function(product_names, availabilities, descriptions, prices) {
  # Connect to the MySQL database
  con <- dbConnect(MySQL(), 
                   user = "root", 
                   password = "", 
                   dbname = "price_db", 
                   host = "localhost")
  
  # Insert data into the database table
  for (i in 1:length(product_names)) {
    query <- paste0("INSERT INTO naivas (ProductName, Availability, Description, Price) VALUES ('", product_names[i], "', '", availabilities[i], "', '", descriptions[i], "', '", prices[i], "')")
    result <- dbSendQuery(con, query)
    dbClearResult(result)  # Close the result set
  }
  
  # Close the database connection
  dbDisconnect(con)
}



# Main function to schedule scraping and sending to the database
main <- function() {
  # Scrape the data
  url <- "https://naivas.online/module/ambjolisearch/jolisearch?s=sugar"
  page <- read_html(url)
  
  # Extract relevant data using CSS selectors
  product_names <- page %>%
    html_nodes(".product-name") %>%
    html_text()
  
  availabilities <- page %>% html_nodes(".product-availability") %>% html_text()
  
  descriptions <- page %>% html_nodes(".product-description-short") %>% html_text()
  
  prices <- page %>%
    html_nodes(".price.product-price") %>%
    html_text()
  
  # Send the data to the database
  send_to_db(product_names, availabilities, descriptions, prices)
}

# Execute the main function
main()



