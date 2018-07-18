config_files=(tpch-cfg/bs-1mb/20threads-all-tpch-nopipe.cfg
              tpch-cfg/bs-1mb/20threads-all-tpch-pipe.cfg
              tpch-cfg/bs-2mb/20threads-all-tpch-nopipe.cfg
              tpch-cfg/bs-2mb/20threads-all-tpch-pipe.cfg
              tpch-cfg/bs-4mb/20threads-all-tpch-nopipe.cfg
              tpch-cfg/bs-4mb/20threads-all-tpch-pipe.cfg
              tpch-cfg/bs-1mb/10threads-all-tpch-nopipe.cfg
              tpch-cfg/bs-1mb/10threads-all-tpch-pipe.cfg
              tpch-cfg/bs-2mb/10threads-all-tpch-nopipe.cfg
              tpch-cfg/bs-2mb/10threads-all-tpch-pipe.cfg
              tpch-cfg/bs-4mb/10threads-all-tpch-nopipe.cfg
              tpch-cfg/bs-4mb/10threads-all-tpch-pipe.cfg)
output_files=(20threads-tpch-sf50-bs1mb-withviz-withlip-colstore.out
              20threads-tpch-sf50-bs2mb-withviz-withlip-colstore.out
              20threads-tpch-sf50-bs4mb-withviz-withlip-colstore.out
              10threads-tpch-sf50-bs1mb-withviz-withlip-colstore.out
              10threads-tpch-sf50-bs2mb-withviz-withlip-colstore.out
              10threads-tpch-sf50-bs4mb-withviz-withlip-colstore.out)
#config_files=(tpch-individual-query-20threads-bs4mb-nopipe.cfg
#              tpch-individual-query-20threads-bs4mb-pipe.cfg)
#output_files=(q18-20threads-tpch-sf50-bs4mb-withviz-nolip-colstore.out)

num_config_files=${#config_files[@]}

for (( i=0; i < ${num_config_files}; i++));
do
        echo ${config_files[$i]}
        echo ${output_files[$((i/2))]}
        if [[ $(( $i % 2 )) == 0 ]]; then
                cmd="sudo ./run-benchmark.sh ${config_files[$i]} 2>&1 | tee ${output_files[$((i/2))]}"
                eval ${cmd}
                sleep 10
        else
                cmd="sudo ./run-benchmark.sh ${config_files[$i]} 2>&1 | tee -a ${output_files[$((i/2))]}"
                eval ${cmd}
                sleep 10
        fi
done
