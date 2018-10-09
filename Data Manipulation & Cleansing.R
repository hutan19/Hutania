
#find the mean of a column
mean(cars$speed)

#Basic plot
plot(cars$speed, cars$dist)

#Clear console
ctrl + L

#Clear variables
rm(list = ls())


#Read in csv
df <- read.csv("des_moines_housing.csv") # Read CSV file
str(df)                                  # Show structure of data frame
#or
#Fancy read in, separated via ^, don't use quotes use ~ (ex. ~A~^~B~)
#also, this has no header
usda <- read.csv("ABBREV.txt", header = FALSE, sep = "^", quote = "~",
                 stringsAsFactors = FALSE, na.strings = "")

#Column names
names(df)
colnames(df)

#Number of rows #Number of columns
nrow(df)
ncol(df)
#Get row count of specific column
length(df$city)

#Get both row/columns dimension of data frame
dim(df)

#Get memory size of df
print(format(object.size(df), units = "Mb"))

#Get statistical summary of df
summary(df)

#Data types in R
# integer = whole numbers
# numeric = decimals
# logical = TRUE or FALSE values
# character = words and written expressions (in double quotes)
# factor = [more explanation below]
# Date = dates (not times!)
# POSIXct or POSIXlt = dates and times

#Get data type of a column
class(df$city)

#Get levels of a column
levels(df$city)

#Extract entry in column/row
a <- df[5,3]
#same
b <- df[5, "baths"]
#check identical, returns TRUE if identical
identical(a,b)

#Extract entire row
df[5,]

#Extract small data frame
#Get rows 5-10 and columns 2-4
df[5:10, 2:4]

#Combine function to grab specific rows/columns
rows <- c(5,173,1000)
cols <- c(3,4,2)
df[rows,cols]
#or
cols <- c("baths","beds","price")
df[rows,cols]

#Working with NA
colSums(is.na(df))  #returns NA count in each column
sum(is.na(df))      #returns total NA count in df
mean(df$price, na.rm = TRUE) #calculate mean while removing NAs

#Change classes of columns
#input "NULL" when you don't want to bring in a column
colClasses <- c("factor", "integer",  
                "NULL", "integer", "integer",
                "Date")

df <- read.csv("des_moines_housing.csv", 
               stringsAsFactors = FALSE,
               colClasses = colClasses)
#or
colClasses <- c("price" = "integer", "beds" = "integer", "city" = "factor", 
                "sqft" = "integer", "built" = "Date", "baths" = "NULL")
df <- read.csv("des_moines_housing.csv",
               stringsAsFactors = FALSE,
               colClasses = colClasses)

#Set certain values to NA
na.strings <- c("NA", "Clive")
df <- read.csv("des_moines_housing.csv", stringsAsFactors = FALSE,
               colClasses = colClasses, na.strings = na.strings)

#Export csv file
write.csv(df, "data_frame.csv", row.names = FALSE)


# Read data
df <- read.csv("des_moines_housing_rawdata.csv", stringsAsFactors = FALSE,
               na.strings = c("NA", ""))

#Print specific number of column names
print(head(names(df), n = 25))

#Keep specific columns
cols <- c("jurisdiction", "price")
df <- df[,cols]

# Rename several additional columns
names(df)[names(df) == "sale_date"] <- "SaleDate" #changed from sale_date to SaleDate
names(df)[names(df) == "land_acres"] <- "acres"

# View column classes
print(sapply(df, class))

#change column classes change column data type
as.character(...)
factor(...)
as.integer(...)
as.numeric(...)
as.logical(...)
as.Date(...)

#How to change what's in the combine function to integers
print(as.integer(c(13.5, "-2", "blah")))
#prints out 13, -2, NA

# Convert several columns to factors
df$city <- factor(df$city)
df$zip <- factor(df$zip)

#Add factor levels
# Extend levels
levels(df_tmp$city) <- c(levels(df_tmp$city), "Springfield")
print(levels(df_tmp$city))

#Remove factor levels
#This will combine the Springfield level into the Des Moines level
levels(df_tmp$city)[levels(df_tmp$city) == "Springfield"] <- "Des Moines" 
print(levels(df_tmp$city))

#Sort sorting (this doesn't alter the df)
print(head(sort(df$sale_price), n = 10))

#use order if you want to sort the df (this actually changes the df)
# Sort by rooms (decreasing) and baths (increasing)
df <- df[order(-df$rooms, df$baths),]
head(df[, c("rooms", "baths")], n = 10)

#Sorting factor levels, order factor levels
# Reorder condition to "Below Normal", "Normal", "Above Normal" #Usually default is abc order
df$condition <- factor(df$condition, levels = c("Below Normal", "Normal",
                                                "Above Normal"))

# The scale of WALKOUT is linear feet for the walkout, so a postive
# value means there is a walkout basement. Convert WALKOUT to a 0-1
# factor. Examine resulting factors

df$walkout <- factor(as.integer(df$walkout > 0))

print(levels(df$AC)) 

#Add new columns
# Add AGE column, which is defined as the difference between the current
# year and YEAR_BUILT

current_year <- as.integer(format(Sys.Date(), "%Y"))

df$age <- current_year - df$year_built

#tolower - converts a column to lowercase
# Convert to all lower case
df$address <- tolower(df$address)

#Complicated things, convert to bins, assign values to a column assign values to row values
# Define CAR as the sum of ATT_GARAGE_AREA and CARPORT_AREA. Then put
# into bins corresponding to the number of car stalls. Breakpoints
# for the bins were gotten from realtor in Summer 2011 EMBA course.
# He confirmed breakpoints were approximately correct.

df$car <- df$att_garage_area + df$carport_area # Total sqft for cars

wh0 <- which(df$car < 150)                     # Those homes fitting 0 cars
wh1 <- which(df$car >= 150 & df$car < 360)     # Those homes fitting 1 car
wh2 <- which(df$car >= 360 & df$car < 600)     # Those homes fitting 2 cars
wh3 <- which(df$car >= 600)                    # Those homes fitting 3 cars

df$car[wh0] <- 0; df$car[wh1] <- 1             # Change sqft to num of cars
df$car[wh2] <- 2; df$car[wh3] <- 3             # Change sqft to num of cars

df$att_garage_area <- NULL                     # No longer needed
df$carport_area <- NULL    

#Keep only certain rows
# Make sure each house is sensible. Note that the subset(...) command
# also removes NAs!

df <- subset(df, beds >= 1)                    # At least one bedroom
df <- subset(df, baths + toilets > 0)          # Indoor plumbing
df <- subset(df, acres >= 0 & sale_price >= 0) # No negatives
df <- subset(df, above >= 0)                   # No negatives

#Keep only 1 year one year worth of data
# Keep just the most recent one year's worth of data.

yesterday <- Sys.Date() - 1
oneyearago <- Sys.Date() - 365
df <- subset(df, oneyearago <= sale_date & sale_date <= yesterday)

#Remove all NAs from a data frame, if a single NA exists in a row, it is removed
# Remove records with even a single NA
df <- df[complete.cases(df), ]

# Reset the column names with a single command

names(df) <- c("date", "season", "year", "month", "hour", "holiday",
               "dayofweek", "workingday", "weather", "temperature", "feelslike",
               "humidity", "windspeed", "casual", "registered", "total")

#Alter levels
# 2. Alter the levels of df$year from "0" and "1" to "2011" and "2012",
# respectively.
levels(df$year) <- c("2011", "2012")

#Assign values to days of the week weekend
df$weekend <- df$dayofweek
levels(df$weekend)[levels(df$weekend) == "Sun"] <- "1"
levels(df$weekend)[levels(df$weekend) == "Sat"] <- "1"
levels(df$weekend)[levels(df$weekend) == "Mon"] <- "0"
levels(df$weekend)[levels(df$weekend) == "Tue"] <- "0"
levels(df$weekend)[levels(df$weekend) == "Wed"] <- "0"
levels(df$weekend)[levels(df$weekend) == "Thu"] <- "0"
levels(df$weekend)[levels(df$weekend) == "Fri"] <- "0"

# Season has some invalid data ("5"). Keep all rows where season is not 5.
#subset example 
df <- subset(df, season != "5")


#Reorder factors
# 14. Make sure the Category column is a factor with levels sorted in
# reverse alphabetical order. [Hint: See the section "Sorting factor
# levels" in the Data Transformation and Cleaning topic from class.]

mcd$Category <- factor(mcd$Category)
mcd$Category <- factor(mcd$Category, sort(levels(mcd$Category), decreasing = TRUE))


df <- read.csv("des_moines_housing_rawdata.csv", stringsAsFactors = FALSE,
               na.strings = c("NA", ""))

#Select two columns
#this doesn't change the data frame
library(dplyr)
select(df, address, price)

#How to change dataframe to selected colums
cols <- c("jurisdiction", "sale_date", "price", "address", "zip",
          "quality1", "quality2", "land_acres", "occupancy",
          "total_living_area", "fin_bsmt_area_tot", "bsmt_walkout",
          "att_garage_area", "carport_area", "bathrooms", "toilet_rooms",
          "fireplaces", "bedrooms", "rooms", "year_built", "condition",
          "air_conditioning")

#This will create a new dataframe df2, and it will only have the afformentioned columns
df2 <- select(df, cols)

#Rename columns dplyr
# Rename "jurisdiction" column to "city"
df <- rename(df, city = jurisdiction)

#Rename multiple columns at a time
# And two more
df <- rename(df, acres = land_acres, above = total_living_area)

#Sort by column specified, then show results in ascending order (default)
# Sort by price in ascending order
tmp <- arrange(df, price)

# View the results
head(select(tmp, price, address), n = 10)

# Sort by rooms (descending) and baths (ascending)
tmp <- arrange(df, desc(rooms), baths)
head(select(tmp, rooms, baths), n = 10)

# rooms already counts beds. So subtract out beds
df <- mutate(df, rooms = rooms - beds)

df <- mutate(df, AC = factor(as.integer(AC >= 50)))


#This will create a new dataframe df3, and it will only have the afformentioned columns
#This will take # values in air_conditioning, anything >=50 will return a 1, NA will give NA
#and anything below 50 will return a 0
cols <- c("air_conditioning")
df3 <- select(df, cols)
df3 <- mutate(df3, air_conditioning = factor(as.integer(air_conditioning >= 50)))


#Add a new column with dplyr and use a calcuation
current_year <- as.integer(format(Sys.Date(), "%Y"))
df <- mutate(df, age = current_year - year_built)


#Do more complicated things with dplyr
df <- mutate(df, car = att_garage_area + carport_area) # Total sqft for cars

wh0 <- which(df$car < 150)                             # Those homes fitting 0 cars
wh1 <- which(df$car >= 150 & df$car < 360)             # Those homes fitting 1 car
wh2 <- which(df$car >= 360 & df$car < 600)             # Those homes fitting 2 cars
wh3 <- which(df$car >= 600)                            # Those homes fitting 3 cars

df$car[wh0] <- 0; df$car[wh1] <- 1                     # Change sqft to num of cars
df$car[wh2] <- 2; df$car[wh3] <- 3                     # Change sqft to num of cars

df <- select(df, -att_garage_area)                     # No longer needed
df <- select(df, -carport_area)

#Filter command only returns rows that specify a condition
df <- filter(df, rooms >= 1 | rooms <= 5)
df <- filter(df, land_full >= 0 & price >= 100000)

#Summary tables using dplyr, pivot tables
suppressPackageStartupMessages(library(dplyr))
library(reshape2)

# Read in data
df <- read.csv("des_moines_housing_with_latlon.csv", stringsAsFactors = FALSE)

# Set two columns to factor
df$city <- factor(df$city)
df$condition <- factor(df$condition)

# Limit analysis to just Des Moines and West Des Moines
df <- filter(df, city == "Des Moines" | city == "West Des Moines")

# Prepare for grouping by city and condition
df <- group_by(df, city, condition)
head(df, n = 7)

# Summarize df by: (1) mean sale price per group; and (2) count per
# group. Save in a new data frame
summ <- summarize(df, avg_sale_price = mean(sale_price), num_houses = n())                  
summ   

#modify summary table modify pivot table based off what you want to see 
# Choose city for the rows, condition for the columns, and avg_sale_price
# for the values in the table
pivot1 <- dcast(summ, city ~ condition, value.var = "avg_sale_price")
pivot1

#Apply summary table when using a non factor column, created bins for summary table
# Undo the previous grouping
df <- ungroup(df)

# Bin sale_price into new col
df$sale_price_binned <- cut(df$sale_price, 100000*(0:8))

# Rename the bins for user-friendliness
levels(df$sale_price_binned) <- c("$0-$100k", "$100k-$200k", "$200k-$300k",
                                  "$300k-$400k", "$400k-$500k", "$500k-$600k", "$600k-$700k", "$700k-$800k")
# Apply the new grouping
df <- group_by(df, city, sale_price_binned)

# Summarize by count/frequency
summ <- summarize(df, num_houses = n())

# Sale price in the rows, city in the columns, and count in the values
pivot3 <- dcast(summ, sale_price_binned ~ city, value.var = "num_houses")
pivot3

#pipe operator with dplyr allows us to chain our commands together
pivot3 <-
  group_by(df, city, sale_price_binned)                     %>%
  summarize(num_houses = n())                               %>%
  dcast(sale_price_binned ~ city, value.var = "num_houses")
pivot3

#large pipe example
df <- read.csv("des_moines_housing_rawdata.csv", stringsAsFactors = FALSE,
               na.strings = c("NA", ""))

cols <- c("jurisdiction", "sale_date", "price", "address", "zip",
          "quality1", "quality2", "land_acres", "occupancy",
          "total_living_area", "fin_bsmt_area_tot", "bsmt_walkout",
          "att_garage_area", "carport_area", "bathrooms", "toilet_rooms",
          "fireplaces", "bedrooms", "rooms", "year_built", "condition",
          "air_conditioning")

df <-
  select(df, cols) %>%
  rename(city = jurisdiction) %>%
  rename(sale_price = price) %>%
  rename(basement = fin_bsmt_area_tot, walkout = bsmt_walkout,
         baths = bathrooms, toilets = toilet_rooms, beds = bedrooms,
         AC = air_conditioning) %>%
  arrange(desc(sale_price), rooms, baths) %>%
  mutate(rooms = rooms - beds) %>%
  filter(baths + toilets > 0) 

head(df, n = 10)

#Sort levels with other at the end
# 1.(c) Overwrite df$Studio so that its levels are in alphabetical
# order---except that "Other" is the last level.

# Build the new levels with specified order
new_levels <- levels(df$Studio)
new_levels <- setdiff(new_levels, "Other")
new_levels <- sort(new_levels)
new_levels <- c(new_levels, "Other")

#From hw4
df <- read.csv("movies.csv", stringsAsFactors = FALSE)
df <- mutate(df, Release = as.Date(Release))
df <- mutate(df, Studio = factor(Studio))

df$Decade <- NA
df$Decade[df$Release >= "1980-01-01" & df$Release <= "1989-12-31"] <- "1980s"
df$Decade[df$Release >= "1990-01-01" & df$Release <= "1999-12-31"] <- "1990s"
df$Decade[df$Release >= "2000-01-01" & df$Release <= "2009-12-31"] <- "2000s"
df$Decade[df$Release >= "2010-01-01" & df$Release <= "2019-12-31"] <- "2010s"
df$Decade <- factor(df$Decade)

#HW4 summary table example
df <- ungroup(df)
my_labels <- c("1-1000", "1001-2000", "2001-3000", "3001-4000", "4001-5000")
mean_rgps <- mutate(df, Screens_binned = cut(Screens, 1000 * (0:5), labels =
                                               my_labels)) %>%
  group_by(Screens_binned, Studio) %>%
  summarize(mean_rgps = mean(RealGrossPerScreen)) %>%
  dcast(Studio ~ Screens_binned, value.var = "mean_rgps")













