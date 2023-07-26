library(cronR)

# Define the cron job to run the R script every hour
cron_script <- cron_r(
  script = "C:/Users/admin/Documents/On Demand Dashboard/Bot/flour_ScrapNaivas.R",
)

# Schedule the job to run every day at 8:00 AM
cron_add(command = cron_script, frequency = "daily", at = "08:00")

# Start the cron scheduler
cron_start()
