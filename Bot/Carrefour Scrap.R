library(rvest)
library(RMySQL)

library(rvest)



con <- dbConnect(MySQL(), user = "root", password = "", dbname = "price_db", host = "localhost")

# Create the table
dbSendQuery(con, "CREATE TABLE carrefour (ProductName VARCHAR(100), Price VARCHAR(20), original_Price VARCHAR(20))")

# Define the URL of the website to scrape
url <- "https://www.carrefour.ke/mafken/en/"

# Send a GET request to the URL and read the HTML content
page <- read_html(url)
element <- page %>% html_node("[dir='ltr']") 

# Extract the desired information using CSS selectors
product_name <- page %>% html_node("[data-testid='product_name']") %>% html_text()
price_element <- page %>% html_node("[data-testid='product_price']") %>% html_text()

# Insert data into the database table
for (i in 1:length(product_names)) {
  query <- paste0("INSERT INTO carrefour (ProductName, Price, original_Price) VALUES ('", product_name[i], "', '", price_element[i], "')")
  dbSendQuery(con, query)
}

# Close the database connection
dbDisconnect(con)





