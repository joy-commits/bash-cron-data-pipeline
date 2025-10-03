# bash-cron-data-pipeline

This project implements an end-to-end data processing and monitoring pipeline using Bash scripting. The solution automates daily data cleaning, manages logging, and includes a self-check mechanism to ensure pipeline reliability.

## Project Architecture and File Structure

The pipeline is organized within the `data_pipeline` directory, ensuring separation between raw data, scripts, processed output, and logs.

```
/home/ufuoma.ejite/data_pipeline/
|
├── preprocess.sh         
├── monitor.sh          
├── input/
│   └── sales_data.csv         
├── output/
│   └── cleaned_sales_data.csv 
└── logs/
    ├── preprocess.log         
    ├── cron.log              
    └── monitor_summary.log 
```

## Data Processing and Core Logic (preprocess.sh)

The `preprocess.sh` script is the core transformation engine, executed daily.

| Action | Logic Implemented |
|--------|-------------------|
| **Filtering** | Excludes all rows where the status column equals 'Failed'. |
| **Cleaning** | Removes the extra_col (the last column) from the dataset. |
| **Output** | Saves the resulting clean data to `output/cleaned_sales_data.csv`. |
| **Logging** | Records the status of the script with timestamps to `logs/preprocess.log`. |

## Pipeline Automation (Cron)

The pipeline is fully automated via cron jobs running under the user `ufuoma.ejite`.

| Job | Schedule | Entry in crontab -l |  Purpose |
|-----|----------|---------------------|---------|
| **Preprocessing** | Daily at 12:00 AM (Midnight) | `0 0 * * * /data_pipeline/preprocess.sh >> /data_pipeline/logs/cron.log 2>&1` | Executes the main data cleaning task. |
| **Monitoring** | Daily at 12:05 AM | `5 0 * * * /data_pipeline/monitor.sh >> /data_pipeline/logs/monitoring_cron.log 2>&1` | Runs the health check immediately after the preprocessing completes. |

## Logging and Error Monitoring (monitor.sh)

The `monitor.sh` script provides the final health check for the daily execution:

| Feature | Implementation |
|---------|----------------|
| **Error search** | Uses grep to scan `preprocess.log` and `cron.log` for keywords like "ERROR" and "failed". |
| **Notification** | Writes a summary to `logs/monitor_summary.log`. |
| **Scheduling** | Runs 5 minutes after the main job. |

## Permissions and Security

Permissions were adjusted to meet security requirements for sensitive files:

| Target | Requirement | Command Used | Resulting Permission |
|--------|-------------|--------------|-------------------------------|
| `~/data_pipeline/input` | Writable only by the owner (ufuoma.ejite). | `chmod 744 ~/data_pipeline/input` | `drwxr--r--` |
| `~/data_pipeline/logs` | Access restricted so only authorized users can read them. | `chmod 740 ~/data_pipeline/logs` | `drwxr-----` |

This structure ensures data integrity by restricting write access to input and enhancing log confidentiality.
