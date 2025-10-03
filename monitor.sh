#!/bin/bash

LOGS_DIRECTORY="/home/ufuoma.ejite/data_pipeline/logs"
PREPROCESS_LOG="/home/ufuoma.ejite/data_pipeline/preprocess.log"
SUMMARY_LOG="/home/ufuoma.ejite/data_pipeline/logs/monitoring_summary.log"
ERROR_KEYWORDS="ERROR|failed"


# Start a fresh summary log
echo "--- $(date) | STARTING MONITORING ---" > "$SUMMARY_LOG"
HAS_ERRORS=0


# Check the preprocess.log for errors
ERRORS=$(grep -iE "$ERROR_KEYWORDS" "$PREPROCESS_LOG" 2>/dev/null)
if [ -n "$ERRORS" ]; then
    echo "CRITICAL: Errors found in preprocess.log!" >> "$SUMMARY_LOG"
    echo "$ERRORS" >> "$SUMMARY_LOG"
    HAS_ERRORS=1
fi


# Final status report
if [ "$HAS_ERRORS" -eq 1 ]; then
    echo "*** PIPELINE FAILURE DETECTED ***" >> "$SUMMARY_LOG"
else
    echo "--- PIPELINE HEALTH: OK ---" >> "$SUMMARY_LOG"
fi

echo "--- $(date) | MONITORING FINISHED ---" >> "$SUMMARY_LOG"
