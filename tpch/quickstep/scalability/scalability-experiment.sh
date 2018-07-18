config_files=(1thread-all-tpch-nopipe.cfg
              2threads-all-tpch-nopipe.cfg
              4threads-all-tpch-nopipe.cfg
              10threads-all-tpch-nopipe.cfg
              20threads-all-tpch-nopipe.cfg)
output_file=scalability-q7-sf50-bs2mb-withviz-withlip-colstore.out
num_config_files=${#config_files[@]}

for (( i=0; i < ${num_config_files}; i++));
do
        echo ${config_files[$i]}
        cmd="./run-benchmark.sh ${config_files[$i]} 2>&1 | tee -a ${output_file}"
        eval ${cmd}
done
