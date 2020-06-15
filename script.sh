 #!/bin/bash

###### SETUP ############

ACCESS_LOG=/home/denys/lab 4/acess.log

HOW_MANY_ROWS=20



######### FUNCTIONS ##############


function title() {
    echo "
---------------------------------
$@
---------------------------------
"
}

function urls_by_ip() {
    local IP=$1
    tail -5000 $ACCESS_LOG | awk -v ip=$IP ' $1 ~ ip {freq[$7]++} END {for (x in freq) {print freq[x], x}}' | sort -rn | head -20
}


function ip_addresses_by_user_agent(){
    local USERAGENT_STRING="$1"
    local TOP_20_IPS="`tail  -$HOW_MANY_ROWS $ACCESS_LOG | grep "${USERAGENT_STRING}"  | awk '{freq[$1]++} END {for (x in freq) {print freq[x], x}}' | sort -rn | head -20`"
    echo "$TOP_20_IPS"
}

####### RUN REPORTS #############


title "top 20 URLs"
TOP_20_URLS="`tail -$HOW_MANY_ROWS $ACCESS_LOG | awk '{freq[$7]++} END {for (x in freq) {print freq[x], x}}' | sort -rn | head -20`"
echo "$TOP_20_URLS"


title "top 20 URLS excluding POST data"
TOP_20_URLS_WITHOUT_POST="`tail  -$HOW_MANY_ROWS $ACCESS_LOG | awk -F"[ ?]" '{freq[$7]++} END {for (x in freq) {print freq[x], x}}' | sort -rn | head -20`"
echo "$TOP_20_URLS_WITHOUT_POST"


title "top 20 IPs"
TOP_20_IPS="`tail  -$HOW_MANY_ROWS $ACCESS_LOG | awk '{freq[$1]++} END {for (x in freq) {print freq[x], x}}' | sort -rn | head -20`"
echo "$TOP_20_IPS"

title "top 20 user agents"
TOP_20_USER_AGENTS="`tail  -$HOW_MANY_ROWS $ACCESS_LOG | cut -d\  -f12- | sort | uniq -c | sort -rn | head -20`"
echo "$TOP_20_USER_AGENTS"


title "IP Addresses for Top 3 User Agents"

for ((I=1; I<=3; I++))
do
    UA="`echo "$TOP_20_USER_AGENTS" | head -n $I | tail -n 1 | awk '{$1=""; print $0}'`"
    echo "$UA"
    echo "~~~~~~~~~~~~~~~~~~"
    ip_addresses_by_user_agent "$UA"
    echo "
    "
done
