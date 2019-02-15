sudo yum -y install python3 python3-libs python3-pip python3-setuptools
sudo yum -y install git
mkdir -p ~/app
cd app
sudo git clone https://github.com/hangchan/counter.git .
sudo pip3 install virtualenv
mkdir ~/app/venv
virtualenv ~/app/venv/webapp
source ~/app/venv/webapp/bin/activate
pip install --upgrade pip
pip install gunicorn
pip install -r ~/app/requirements.txt
