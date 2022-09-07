##### Custom Metric 
 we use custom metric to send data by our slef. For example instnace does not have a memory metric by-default we use custom metric for that to send data to cloud-watch

 Step 1
    Go to insntance Terminal install this memory script. Change instance name with your ec2 ID

    ```rb
    #!/bin/bash

    USEDMEMORY=$(free -m | awk 'NR==2{printf "%.2f\t", $3*100/$2 }')
    

    aws cloudwatch put-metric-data --metric-name memory-usage --dimensions Instance=i-0c51f9f1213e63159 --namespace "Custom" --value $USEDMEMORY
    ```

Step 2 
    Run chmod +x mem.sh to give execution permession
step 3
    Run Script
    ./mem.sh

step 4 
    refresh  cloud watch page and you will able to see that sutom metric

####    REFERENCE ##########
https://dev.to/issaurabhpandey/how-do-i-push-custom-metrics-from-an-ec2-linux-instance-to-cloudwatch-117o