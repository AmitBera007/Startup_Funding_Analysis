# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)



### Load the dataset and process ###

file_path <- "startup_funding.xlsx"
df <- read_excel(file_path)

# View the first few rows of the dataset
head(df)

# Rename columns for easier access
df <- df %>%
  rename(
    Serial_Number = `Sr No`,
    Date = `Date dd/mm/yyyy`,
    Startup_Name = `Startup Name`,
    Industry_Vertical = `Industry Vertical`,
    SubVertical = `SubVertical`,
    City_Location = `City  Location`,
    Investors_Name = `Investors Name`,
    Investment_Type = `InvestmentnType`,
    Amount_USD = `Amount in USD`
  )

# Convert Date to Date type
df$Date <- as.Date(df$Date, format="%Y-%m-%d")

# Convert Amount_USD to numeric, handling commas and missing values
df$Amount_USD <- as.numeric(gsub(",", "", df$Amount_USD))

# Summary statistics
summary(df)

# Check for missing values
missing_values <- sapply(df, function(x) sum(is.na(x)))
missing_values



### Visualizations ###


## Visualization: Number of startups funded by year
df$Year <- format(df$Date, "%Y")
ggplot(df, aes(x = Year)) +
  geom_bar(fill = "skyblue") +
  theme_minimal() +
  labs(title = "Number of Startups Funded by Year", x = "Year", y = "Number of Startups")


## Visualization: Industry Vertical distribution with count labels

# view the table
table(df$Industry_Vertical)

# Function to compact industry categories with more specific grouping
compact_industry <- function(industry) {
  industry <- str_trim(tolower(industry))
  
  if (str_detect(industry, "food|beverages|f&b|restaurant|cafe|snack|dairy")) {
    return("Food & Beverage")
  } else if (str_detect(industry, "e-commerce|ecommerce|online|marketplace|retailtech")) {
    return("E-Commerce")
  } else if (str_detect(industry, "technology|tech|it|software|ai|artificial intelligence|big data|cloud|machine learning|cybersecurity|blockchain")) {
    return("Technology")
  } else if (str_detect(industry, "health|medical|pharma|biotech|medtech|healthcare|wellness|fitness|healthtech|hospital")) {
    return("Healthcare")
  } else if (str_detect(industry, "fintech|finance|banking|payment|insurtech|investment|wealthtech|financial services|accounting|insurance|lending")) {
    return("FinTech")
  } else if (str_detect(industry, "education|edtech|learning|training|tutoring|elearning")) {
    return("Education")
  } else if (str_detect(industry, "logistics|transport|shipping|delivery|supply chain|mobility|trucking|warehousing")) {
    return("Logistics & Transportation")
  } else if (str_detect(industry, "media|entertainment|content|gaming|digital media|film|music|video|publishing")) {
    return("Media & Entertainment")
  } else if (str_detect(industry, "travel|tourism|hospitality|hotel|airline|vacation|traveltech|booking")) {
    return("Travel & Hospitality")
  } else if (str_detect(industry, "consumer internet|internet|web services|social network|online services")) {
    return("Consumer Internet")
  } else if (str_detect(industry, "retail|consumer goods|fashion|apparel|clothing|lifestyle|beauty|cosmetics|furniture")) {
    return("Retail & Lifestyle")
  } else if (str_detect(industry, "real estate|property|housing|construction|proptech|infrastructure")) {
    return("Real Estate & Construction")
  } else if (str_detect(industry, "consulting|business services|management|hr|recruitment|staffing|outsourcing|human resources")) {
    return("Consulting & Business Services")
  } else if (str_detect(industry, "automobile|auto|vehicle|car|transportation|automotive|electric vehicle|auto tech")) {
    return("Automobile & Transportation")
  } else if (str_detect(industry, "agriculture|agritech|farming|agro|foodtech|organic|agricultural technology|agri")) {
    return("Agriculture")
  } else if (str_detect(industry, "legal|law|compliance|govtech|government|regtech")) {
    return("Legal & Compliance")
  } else if (str_detect(industry, "advertising|marketing|adtech|digital marketing|branding|pr|public relations")) {
    return("Advertising & Marketing")
  } else if (str_detect(industry, "energy|cleantech|renewable|environment|greentech|sustainability|solar|electric|energy storage|environmental|clean energy")) {
    return("Energy & Environment")
  } else if (str_detect(industry, "manufacturing|industrial|production|engineering|automation|machinery|factory")) {
    return("Manufacturing & Industrial")
  } else if (str_detect(industry, "gaming|sports|recreation|fitness|outdoor|esports|sport")) {
    return("Sports & Fitness")
  } else if (str_detect(industry, "social|network|community|dating|collaboration|communication")) {
    return("Social & Communication")
  } else {
    return("Other")  # Use "Other" for any category not explicitly listed
  }
}

# Apply the function to create the 'Updated_Industry_Vertical' column
df <- df %>%
  mutate(Updated_Industry_Vertical = sapply(Industry_Vertical, compact_industry))

# Display the first few rows to verify the changes
head(df[, c("Industry_Vertical", "Updated_Industry_Vertical")])

# Group smaller categories into "Other" for visualization purposes
df <- df %>%
  mutate(Updated_Industry_Vertical = ifelse(Updated_Industry_Vertical %in% c("Consulting & Business Services", 
                                                                             "Automobile & Transportation", 
                                                                             "Agriculture", 
                                                                             "Legal & Compliance", 
                                                                             "Advertising & Marketing",
                                                                             "Real Estate & Construction",
                                                                             "Retail & Lifestyle"), 
                                            "Other", 
                                            Updated_Industry_Vertical))

# Reorder factor levels by count for better presentation
df$Updated_Industry_Vertical <- factor(df$Updated_Industry_Vertical, 
                                       levels = names(sort(table(df$Updated_Industry_Vertical), decreasing = TRUE)))

# Visualization: Industry Vertical distribution with count labels
ggplot(df, aes(x = Updated_Industry_Vertical)) +
  geom_bar(fill = "orange") +
  theme_minimal() +
  coord_flip() +
  labs(title = "Distribution of Startups by Industry Vertical", x = "Industry Vertical", y = "Count") +
  geom_text(stat='count', aes(label=..count..), hjust=-0.1, size=3.5, color="black") +
  theme(axis.text.y = element_text(size = 8),
        plot.title = element_text(hjust = 0.5, size = 14),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12))


## Visualization: Investment Type distribution

# Create a Function to Compact Investment Types
compact_investment_type <- function(investment_type) {
  investment_type <- str_trim(tolower(investment_type))
  
  if (str_detect(investment_type, "seed|angel")) {
    return("Seed/Angel Funding")
  } else if (str_detect(investment_type, "private|equity|venture")) {
    return("Private Equity / Venture")
  } else if (str_detect(investment_type, "series a")) {
    return("Series A")
  } else if (str_detect(investment_type, "series b")) {
    return("Series B")
  } else if (str_detect(investment_type, "series c|series d|series e|series f")) {
    return("Series C-F")
  } else if (str_detect(investment_type, "debt|loan|debt funding")) {
    return("Debt Funding")
  } else if (str_detect(investment_type, "corporate")) {
    return("Corporate Round")
  } else if (str_detect(investment_type, "grant")) {
    return("Grant")
  } else if (str_detect(investment_type, "convertible")) {
    return("Convertible Note")
  } else {
    return("Other")
  }
}

# Apply the Function to Create a New Column
df <- df %>%
  mutate(Updated_Investment_Type = sapply(Investment_Type, compact_investment_type))

# Visualize the Compact Investment Type Distribution
ggplot(df, aes(x = Updated_Investment_Type)) +
  geom_bar(fill = "purple") +
  theme_minimal() +
  coord_flip() +
  labs(title = "Distribution of Investment Types", x = "Investment Type", y = "Count") +
  geom_text(stat='count', aes(label=..count..), hjust=-0.1, size=3.5, color="black") +  # Add counts on the bars
  theme(axis.text.y = element_text(size = 10),  # Adjust y-axis text size for readability
        plot.title = element_text(hjust = 0.5, size = 14))  # Center and adjust title size


## Assuming top_investors is your data frame and it's already loaded
top_investors_pie <- top_investors[1:10, ] %>%
  mutate(Investors_Name = factor(Investors_Name, levels = Investors_Name[order(-Investments)]))

ggplot(top_investors_pie, aes(x = "", y = Investments, fill = Investors_Name)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  theme_void() +
  labs(title = "Top 10 Investors by Number of Investments",
       fill = "Investor Name") +
  theme(plot.title = element_text(hjust = 0.5, size = 14)) +
  geom_text(aes(label = Investments), 
            position = position_stack(vjust = 0.5), size = 3, color = "white") +
  theme(legend.position = "right")  # Adjust legend position if needed


## Visualization: Total funding by city

# Summarize total funding by city and plot all cities
city_funding <- df %>%
  group_by(City_Location) %>%
  summarize(Total_Funding = sum(Amount_USD, na.rm = TRUE)) %>%
  arrange(desc(Total_Funding))

# Plot total funding for all cities (horizontal)
ggplot(city_funding, aes(x = reorder(City_Location, -Total_Funding), y = Total_Funding)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Total Funding by City", x = "City Location", y = "Total Funding (USD)")

# Plot total funding for top 10 cities (vertical with labels)
ggplot(city_funding %>% top_n(10, Total_Funding), aes(x = reorder(City_Location, Total_Funding), y = Total_Funding)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = scales::comma(Total_Funding)), vjust = -0.5, color = "black") +
  theme_minimal() +
  labs(title = "Top 10 Cities by Total Funding", x = "City Location", y = "Total Funding (USD)")
