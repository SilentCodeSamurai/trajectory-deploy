#!/bin/bash

# check_mysql.sh

# Run the mysql_cli.sh script
/root/trajectory-deploy/mysql_cli.sh

# Check the exit status of the last command
if [ $? -eq 1 ]; then
    # Define email parameters
    TO="glazunovgennadyanatolyevitch@yandex.ru"  # Change to the recipient's email address
    SUBJECT="ALERT ALARM TREVOGA"
    BODY="Mysql DB FAILED"

    # Send the email
    echo "$BODY" | mail -s "$SUBJECT" "$TO"
fi

# */10 * * * * /root/trajectory-deploy/check_mysql.sh
