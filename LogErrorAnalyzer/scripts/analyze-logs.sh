#!/bin/bash

LOG_DIR="/home/onenomii/Downloads/logs/"

REPORT_FILE="/home/onenomii/Downloads/reports/log_report.txt"

ERROR_PATTERNS=("ERROR" "FATAL" "CRITICAL")

echo "Analyzing log file modified in last 24 hours" >> $REPORT_FILE
echo -e "============================================\n" >> $REPORT_FILE
LOG_FILES=$(find $LOG_DIR -name "*.log" -mtime -1)
echo "$LOG_FILES" >> $REPORT_FILE

for LOG_FILE in $LOG_FILES;
do

echo -e "\n" >> $REPORT_FILE
echo "=========================================" >> $REPORT_FILE
echo "================$LOG_FILE================" >> $REPORT_FILE
echo "=========================================" >> $REPORT_FILE

    for PATTERN in ${ERROR_PATTERNS[@]};
    do
        echo -e "\nSearching for $PATTERN logs in application.log file\n" >> $REPORT_FILE
        grep "$PATTERN" "$LOG_FILE" >> $REPORT_FILE

        echo -e "\nNumber of $PATTERN logs found in application.log file" >> $REPORT_FILE

        ERROR_COUNT=$(grep -c "$PATTERN" "$LOG_FILE")
        echo $ERROR_COUNT >> $REPORT_FILE

        if [ "$ERROR_COUNT" -gt 10 ]; then
            echo -e "\n⚠️ Action required: Too many $PATTERN issues in log file $LOG_FILE"
        fi 

    done
done

echo "Log report saved to $REPORT_FILE"