configFile=$1
outputFile=$2
runFile=run-benchmark.sh
if [ -f ${outputFile} ] ; then
  rm ${outputFile} &>/dev/null
fi
touch ${outputFile}
sequences=("0,1,2"
           "1,0,2"
           )
for i in ${sequences[@]}
do
  replaceCmd="sed -i 's/sequence=0A0A0A/sequence=${i}/g' ${configFile}"
  eval ${replaceCmd}
  cmd="sudo ./${runFile} ${configFile} 2>&1 | tee -a ${outputFile}"
  eval ${cmd}
  restoreCmd="sed -i 's/sequence=${i}/sequence=0A0A0A/g' ${configFile}"
  eval ${restoreCmd}
done
