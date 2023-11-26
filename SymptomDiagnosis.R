### Code ----
library(readr)
# Read the CSV file with read.csv
stock_ror_dataset <- read.csv("data/medicaldataset.csv", na.strings = "NA")

# Convert the "Disease" column to a factor with specified levels
stock_ror_dataset$Disease <- factor(stock_ror_dataset$Disease, levels = c(
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
head(stock_ror_dataset)
