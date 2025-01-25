import csv
import argparse
from random import randint
from datetime import datetime, timedelta

# Step 1: Define the output file name
output_file = 'weather_dataset.txt'

# Step 2: Set up argument parsing
parser = argparse.ArgumentParser(description="Generate a weather dataset with random temperatures.")
parser.add_argument(
    'num_rows',
    type=int,
    help="The number of rows to generate in the dataset."
)
args = parser.parse_args()
num_rows = args.num_rows  # Get the number of rows from the argument

# Step 3: Set the start date
start_date = datetime(2021, 1, 1)

# Step 4: Generate the data
data = []
for i in range(num_rows):
    date = (start_date + timedelta(days=i)).strftime('%Y-%m-%d')  # Format the date
    temperature = randint(20, 30)  # Generate a random temperature between 20 and 30
    data.append([date, temperature])

# Step 5: Write the data to a CSV file
with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(data)

print(f"CSV file '{output_file}' with {num_rows} rows has been created.")
