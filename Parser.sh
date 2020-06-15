 
#!/bin/bash

echo Please select a menu item
echo
echo "1) Blank User Agents"
echo "2) Top 10 IPs"
echo "3) Top 10 referrers"
echo "4) Top user-agent"
echo "5) Requests per day"
echo "6) Total unique visitors"
echo "7) Real time Requests"
echo "8) Most popular URLs"
echo "9) Sorted number of visit per IP"
echo "10) Unique visitors this month"
echo
read CHOICE
case $CHOICE in
1) awk -F\" '($6 ~ /^-?$/)' $log| awk '{print $1}' | sort | uniq;;
2) cat access.log | awk '{ print $1 ; }' | sort | uniq -c | sort -n -r | head -n 10;;
3) cat access.log | awk -F\" ' { print $4 } ' | grep -v '-' | grep -v 'http://www.YOURDOMAIN.com' | sort | uniq -c | sort -rn | head -n 10;;
4) cat access.log | awk -F\" ' { print $6 } ' | sort | uniq -c | sort -rn | head -n 10;;
5) awk '{print $4}' access.log | cut -d: -f1 | uniq -c;;
6) cat access.log | awk '{print $1}' | sort | uniq -c | wc -l;;
7) tailf access.log | awk '{ printf("%-15s\t%s\t%s\t%s\n", $1, $6, $9, $7) }';;
8) cat access.log | awk '{ print $7 }' | sort | uniq -c | sort -rn | head -n 25;;
9) cat access.log | awk '{print "requests from " $1}' | sort | uniq -c | sort;;
10) cat access.* | grep `date '+%b/%G'` | awk '{print $1}' | sort | uniq -c | wc -l;;
*) echo You made an invalid selection;;
esac
