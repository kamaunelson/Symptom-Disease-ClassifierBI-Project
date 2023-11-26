#Milestone 1


#Issue 1
### Code ----
library(readr)
# Load the mice package
library(mice)

# Read the CSV file with read.csv
dataset <- read.csv("data/communicable_dataset.csv", na.strings = "NA")

# Convert the "Disease" column to a factor with specified levels
dataset$Disease <- factor(dataset$Disease, levels = c(
  "Allergy", "GERD", "Chronic cholestasis", "Drug Reaction", "Peptic ulcer disease",
  "AIDS", "Diabetes", "Gastroenteritis", "Bronchial Asthma", "Hypertension",
  "Migraine", "Cervical spondylosis", "Paralysis (brain hemorrhage)", "Jaundice",
  "Malaria", "Chicken pox", "Dengue", "Typhoid", "hepatitis A", "Hepatitis B",
  "Hepatitis C", "Hepatitis D", "Hepatitis E", "Alcoholic hepatitis", "Tuberculosis",
  "Common Cold", "Pneumonia", "Dimorphic hemmorhoids(piles)", "Heart attack",
  "Varicose veins", "Hypothyroidism", "Hyperthyroidism", "Hypoglycemia", "Osteoarthristis",
  "Arthritis", "(vertigo) Paroxysmal Positional Vertigo", "Acne", "Urinary tract infection",
  "Psoriasis", "Impetigo"
))

# View the first few rows of the dataset
head(dataset)

#Issue 2

# Measure of Frequency
disease_frequencies <- table(dataset$Disease)

# Measure of Central Tendency
mean_disease_length <- mean(nchar(dataset$Disease))
median_disease_length <- median(nchar(dataset$Disease))
mode_disease <- names(which.max(disease_frequencies))

# Measure of Distribution
sd_disease_length <- sd(nchar(dataset$Disease))

# Measure of Relationship
disease_association <- chisq.test(dataset$Disease)

# Print results
print(disease_frequencies)
print(mean_disease_length)
print(median_disease_length)
print(mode_disease)
print(sd_disease_length)
print(disease_association)

# Check unique levels in Disease and Symptom_1
table(dataset$Disease)
table(dataset$Symptom_1)

# Perform chi-square test of independence
chisq_result <- chisq.test(dataset$Disease, dataset$Symptom_1)
print(chisq_result)

#Issue 3

# Load required libraries
library(arules)
library(arulesViz)
library(RColorBrewer)

# Load your dataset (replace 'your_data.csv' with your actual data file)
data <- read.csv("data/communicable_dataset.csv")

# Convert character data type to factor data type
data[, c("Disease", "Symptom_1", "Symptom_2", "Symptom_3", "Symptom_4", "Symptom_5", "Symptom_6", "Symptom_7", "Symptom_8")] <- lapply(data[, c("Disease", "Symptom_1", "Symptom_2", "Symptom_3", "Symptom_4", "Symptom_5", "Symptom_6", "Symptom_7", "Symptom_8")], as.factor)

# Create a transaction object
trans <- as(data, "transactions")

# Create an item frequency plot for the top 10 items
itemFrequencyPlot(trans, topN = 10, type = "absolute",
                  col = brewer.pal(8, "Pastel2"),
                  main = "Absolute Item Frequency Plot",
                  horiz = TRUE,
                  mai = c(2, 2, 2, 2))

itemFrequencyPlot(trans, topN = 10, type = "relative",
                  col = brewer.pal(8, "Pastel2"),
                  main = "Relative Item Frequency Plot",
                  horiz = TRUE,
                  mai = c(2, 2, 2, 2))


#Milestone 2

#Issue 5

# Load required libraries
## plyr ----
if (require("plyr")) {
  require("plyr")
} else {
  install.packages("plyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## dplyr ----
if (require("dplyr")) {
  require("dplyr")
} else {
  install.packages("dplyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
library(caret)
library(randomForest)  # You can choose another classification algorithm

# Load your dataset (replace 'your_data.csv' with your actual data file)
data <- read.csv("data/communicable_dataset.csv")

# STEP 2. Data Preprocessing ----
# Remove unnecessary columns
data <- data[, c("Disease", "Symptom_1", "Symptom_2", "Symptom_3", "Symptom_4", "Symptom_5", "Symptom_6", "Symptom_7", "Symptom_8")]

# Convert character data type to factor data type
data[, c("Disease", "Symptom_1", "Symptom_2", "Symptom_3", "Symptom_4", "Symptom_5", "Symptom_6", "Symptom_7", "Symptom_8")] <- lapply(data[, c("Disease", "Symptom_1", "Symptom_2", "Symptom_3", "Symptom_4", "Symptom_5", "Symptom_6", "Symptom_7", "Symptom_8")], as.factor)

#Data transformation
# Replace missing values with the mode of the respective column
data <- data %>% 
    mutate_at(vars(Symptom_1:Symptom_8), ~ifelse(is.na(.), mode(., na.rm = TRUE), .))

#confirmation of missing data
sapply(data, function(x) sum(is.na(x)))

# Summary of missing values
summary(data)

library(naniar)

# Visualize missing data patterns
gg_miss_var(data)
gg_miss_upset(data)

# Split the data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(data$Disease, p = .7, list = FALSE, times = 1)
train <- data[trainIndex, ]
test <- data[-trainIndex, ]

# Train a decision tree model
library(rpart)
model_decision_tree <- rpart(Disease ~ ., data = train)

# Train a random forest model on the training data
model <- randomForest(Disease ~ ., data = train)

# Use the trained model to make predictions on the test data
predictions <- predict(model, test)

# Compare model performance using resampling methods
library(caret)

# Define control parameters for resampling
control <- trainControl(method = "cv", number = 10)

# Train a decision tree model using cross-validation
model_cv <- train(Disease ~ ., data = train, method = "rpart", trControl = control)

# Summarize model performance
print(model_cv)

#Milestone 4
# Issue 7: Grid search parameter tuning

# Load necessary libraries
library(caret)
library(randomForest)

# Define the grid of hyperparameters for mtry
grid <- expand.grid(mtry = c(2, 4, 6, 8, 10)) # Vary the number of variables randomly sampled as candidates at each split

# Set up the control parameters for grid search
control <- trainControl(method = "cv", number = 5) 

# Perform grid search for hyperparameters (only mtry)
model_grid_search <- train(Disease ~ ., data = train, method = "rf",
                           trControl = control, tuneGrid = grid)

