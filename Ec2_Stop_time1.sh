#!/bin/bash

#Taking input from the user. Will check if any EC2 instance is stopped from the last 'n' no of days
#echo "Please enter the no of days"

#read No_of_Days

#Storing curent date in YY-MM-DD format
CURRENT_DATE=`date +%Y-%m-%d`



#Subtarcting no of days from current date
#FINAL_DATE=$(date --date="${CURRENT_DATE} -${No_of_Days} day" +%Y-%m-%d)


#Print EC2 instances with stopped state from last n no of days and store it in a file
#echo "Below is the ec2 instances with stopped state from last ${No_of_Days} days : "
aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped"  --query 'Reservations[].Instances[].[InstanceId,LaunchTime]' --output text > Instanceinfo.txt



echo "<html> <table width="300" border="1" cellspacing="0" cellpadding="3" bordercolor="#980000"> <tr> <th> InstanceID </th> <th> Stopped Time </th> </tr>" > htmlreport.html


#Read Time in Insrtanceinfo file and apply condition according to the input by user

#create rows functions
HTML_ROWS()
{
 Instance_no=$1
 Column_no=1
 echo "<tr>" >> htmlreport.html 
 echo "<td>" >> htmlreport.html
 awk "NR==$Instance_no {print \$1}" Instanceinfo.txt >> htmlreport.html
 echo "</td>" >> htmlreport.html
 echo "<td>" >> htmlreport.html
 awk "NR==$Instance_no {print \$2}" Instanceinfo.txt >> htmlreport.html
 echo "</td>" >> htmlreport.html

}


#Calling function

file=Instanceinfo.txt
Row_No=1

while IFS= read line
do
 STOPPED_TIME=$(awk "NR==${Row_No} {print \$2}" ${file})
 TIME_TRIM=${STOPPED_TIME:0:10}
 TIME_DIFFERENCE=$(( ($(date -d ${CURRENT_DATE} +%s) - $(date -d ${TIME_TRIM} +%s)) / 86400))

 if [ ${TIME_DIFFERENCE}  -ge  ${No_of_Days} ]
 then
 HTML_ROWS ${Row_No}
 fi
 Row_No=' expr $Row_No + 1 '

done <"$file"

echo "</tr> </table> </html>" >> htmlreport.html
