sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository -y 'deb http://llvm.org/apt/jessie llvm-toolchain-jessie-3.7 main'
sudo apt-get update
sudo apt-get install -y build-essential clang-3.7 gdb cmake git protobuf-compiler libprotobuf-dev flex bison libnuma-dev
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.7 20
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.7 20
sudo apt-get install -y dstat
sudo apt-get install -y tmux vim htop

(echo n; echo ; echo ; echo ; echo ; echo w) | sudo fdisk /dev/sdb
sudo mkfs.ext4 /dev/sdb1
sudo mkdir /slowdisk
sudo mount /dev/sdb1 /slowdisk

(echo n; echo ; echo ; echo ; echo ; echo w) | sudo fdisk /dev/sdc
sudo mkfs.ext4 /dev/sdc1
sudo mkdir /fastdisk
sudo mount /dev/sdc1 /fastdisk
