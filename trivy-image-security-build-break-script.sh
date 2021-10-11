#!/bin/bash
#this script is used to break the build if CRITICAL, HIGH AND MEDIUM values are detected
# trivy-reports.logs file should be available in the execution script directory

THRESHOLD_FILE=trivy-reports.logs

# check the trivy-reports.logs file exsist or not in the current directory

if [[ -f $THRESHOLD_FILE ]]; then
    echo "$THRESHOLD_FILE exsist!"
else
    echo "$THRESHOLD_FILE doesnot exsist! please check build logs.............!"
    exit 1
fi

CRITICAL_COUNT=`cat $THRESHOLD_FILE | grep Failures | cut -d ":" -f 7 | cut -b 2`
HIGH_COUNT=`cat $THRESHOLD_FILE | grep Failures | cut -d ":" -f 6 | cut -d "," -f 1`
MEDIUM_COUNT=`cat $THRESHOLD_FILE | grep Failures | cut -d ":" -f 5 | cut -d "," -f 1`

#check the results and failed the build if CRITIAL_COUNT, HIGH_COUNT, MEDIUM_COUNT found in the trivy-reports.logs

if [[ CRITICAL_COUNT == 0 ]] && [[ HIGH_COUNT == 0 ]] && [[ MEDIUM_COUNT == 0 ]]; then
   echo "docker image reports are looks good and no vulnerabilities found..................!"
else
  echo "docker image have below vulnerabilites.............!"
  echo CRITICAL_COUNT = $CRITICAL_COUNT
  echo HIGH_COUNT = $HIGH_COUNT
  echo MEDIUM_COUNT = $MEDIUM_COUNT
  exit 1
fi

####################################################  end #########################################################
