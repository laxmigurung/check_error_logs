#!/bin/bash

# download the log file you need for investigation
# naviagate to the downloaded log file and look into "404" error and  transfer the new investigated log to a new file.
# perform extraction on each line if the new trasfered logs and store it in a new file.
# try to get the count of distinct ipaddress from the new file where you stored the ipaddress.

cat /home/ubuntu/web-server-access-logs.log | grep " 404 " >> transferred_error_logs.log 
transferred_file_path="/home/ubuntu/bash_scripts/check_error_logs/transferred_error_logs.log"
while read -r line; do
    new_line=$line
    first_extracted_line=$(echo "$line" | cut -d',' -f2|awk -F'"' '{print $2}')
    second_extracted_line=$(echo "$first_extracted_line" | cut -d' ' -f1)
    echo "$second_extracted_line" >> ipaddress.txt
done <$transferred_file_path

ip_address_file_path="/home/ubuntu/bash_scripts/check_error_logs/ipaddress.txt"

# try to get the count of distinct ipaddress from the new file where you stored the ipaddress.
count_distinct_ipaddress() {
  ip_counts=()

  while IFS= read -r ip; do
    ((ip_counts[$ip]++))
  done <$ip_address_file_path

  echo "Distinct IP addresses and their counts:"
  for ip in "${!ip_counts[@]}"; do
    echo "$ip: ${ip_counts[$ip]}"
  done

  echo "Total distinct IP addresses: ${#ip_counts[@]}" >> ipaddress_count.txt
}

count_distinct_ipaddress
