#!/bin/bash

INPUT_FILE="/home/ufuoma.ejite/data_pipeline/input/sales_data.csv"
OUTPUT_FILE="/home/ufuoma.ejite/data_pipeline/output/cleaned_sales_data.csv"
LOG_FILE="/home/ufuoma.ejite/data_pipeline/logs/preprocess.log"
COLUMN_NUMBER=7
STATUS_COLUMN=6
FILTERED_STATUS="Failed"

# --- Check if the csv file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "--- $(date) | ERROR: Input file '$INPUT_FILE' not found. ---" >> "$LOG_FILE"
    echo "ERROR: Input file '$INPUT_FILE' not found. Check the log file for details."
    exit 1
fi

# --- Logging starts
echo "--- $(date) | STARTING PREPROCESSING ---" >> "$LOG_FILE"
echo "Processing '$INPUT_FILE'..." >> "$LOG_FILE"
echo "Filtering out rows where column $STATUS_COLUMN is '$FILTERED_STATUS'." >> "$LOG_FILE"
echo "Removing column $COLUMN_NUMBER." >> "$LOG_FILE"


# --- Data preprocessing
awk -F ',' -v status_col="$STATUS_COLUMN" -v filter_value="$FILTERED_STATUS" 'BEGIN { OFS = "," } (NR == 1) || ($status_col != filter_value) { print $1, $2, $3, $4, $5, $6 }' "$INPUT_FILE" > >


# --- Logging and success message
if [ $? -eq 0 ]; then
    LOG_MESSAGE="SUCCESS: Data cleaned and saved to '$OUTPUT_FILE'."
    echo "$LOG_MESSAGE" | tee -a "$LOG_FILE"
else
    LOG_MESSAGE="ERROR: Awk command failed."
    echo "$LOG_MESSAGE" | tee -a "$LOG_FILE"
fi

echo "--- $(date) | PREPROCESSING FINISHED ---" >> "$LOG_FILE"
