sudo touch /etc/apt/sources.list.d/monetdb.list
sudo cat "deb http://dev.monetdb.org/downloads/deb/ xenial monetdb" > /etc/apt/sources.list.d/monetdb.list
sudo cat "deb-src http://dev.monetdb.org/downloads/deb/ xenial monetdb" > /etc/apt/sources.list.d/monetdb.list
wget --output-document=- https://www.monetdb.org/downloads/MonetDB-GPG-KEY | sudo apt-key add -

sudo apt-get update
sudo apt-get install monetdb5-sql monetdb-client
sudo usermod -a -G monetdb $USER

