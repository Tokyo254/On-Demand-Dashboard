library(rvest)
library(RMySQL)
library(DBI)
library(taskscheduleR)


scrape_data <- function() {
# Scrape data from the website
url <- "https://naivas.online/module/ambjolisearch/jolisearch?s=maize+meal"
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

# Create a data frame with the scraped data
scraped_data <- data.frame(
  ProductName = product_names,
  Availability = availabilities,
  Description = descriptions,
  Price = prices
)
return(scraped_data)
}

send_to_db <- function(data) {
  # Connect to the MySQL database
  con <- dbConnect(MySQL(), 
                   user = "root", 
                   password = "", 
                   dbname = "price_db", 
                   host = "localhost")
  
  # Check if the table already exists
  if (!dbExistsTable(con, "naivas")) {
    # If the table does not exist, create it with the same structure as the data frame
    dbCreateTable(con, "naivas", data, overwrite = FALSE)
  }
  
  # Update rows with matching prices
  for (i in 1:nrow(data)) {
    query <- paste0("UPDATE naivas SET Availability = '", data[i, "Availability"], "', Description = '", data[i, "Description"], "' WHERE Price = '", data[i, "Price"], "'")
    rows_updated <- dbExecute(con, query)
  }
  
  # Close the database connection
  dbDisconnect(con)
}




# Main function to schedule scraping and sending to the database
main <- function() {
  # Scrape the data
  data <- scrape_data()
  
  # Send the data to the database
  send_to_db(data)
}

# Execute the main function
main()







