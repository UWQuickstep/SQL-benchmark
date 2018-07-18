configFile=$1
outputFile=$2
runFile=run-benchmark.sh
if [ -f ${outputFile} ] ; then
  rm ${outputFile} &>/dev/null
fi
touch ${outputFile}
#sequences=("0,1,2"
#           "1,0,2"
#           )
sequences=("3,7,2,6,15,1,5,0,4,9,17,28"
           "0,4,1,2,6,15,5,9,3,7,17,28"
           "2,6,15,1,5,0,4,9,3,7,17,28"
           )
#sequences=("0,1,5,4,2,6,3,7,14,22"
#           "1,5,0,4,2,6,3,7,14,22"
#           "2,1,5,0,4,6,3,7,14,22"
#           "3,7,2,1,5,0,4,6,14,22")
for i in ${sequences[@]}
do
  replaceCmd="sed -i 's/sequence=0A0A0A/sequence=${i}/g' ${configFile}"
  eval ${replaceCmd}
  cmd="sudo ./${runFile} ${configFile} 2>&1 | tee -a ${outputFile}"
  eval ${cmd}
  restoreCmd="sed -i 's/sequence=${i}/sequence=0A0A0A/g' ${configFile}"
  eval ${restoreCmd}
done
