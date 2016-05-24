import subprocess
from datetime import datetime, timedelta
import os

def run_batch():
    postgres_exec = ""
    postgres_db = ""
    proc_list = []
    F_NULL = open(os.devnull, 'w')
    with open('config.sh', 'r') as f:
	for line in f:    
            line = line.strip()
            if not line == "":
                value = line[line.find('=')+2:-1]
                if "DB" in line:
                    postgres_db = value
                elif "EXEC" in line:
                    postgres_exec = value

    begin_time = datetime.now()
    for i in range(1, 14):
        name_of_query = str(i).zfill(2) + ".sql"
        
	proc = subprocess.Popen([postgres_exec, '-d', postgres_db, '-f', name_of_query], stdout=F_NULL)
	proc_list.append(proc)

    for proc in proc_list:
        proc.wait()

    end_time = datetime.now()
    time_passed_in_seconds = (end_time - begin_time).total_seconds()
    print 'Time passed:', time_passed_in_seconds * 1000, 'ms'

if __name__ == "__main__":
    run_batch()

