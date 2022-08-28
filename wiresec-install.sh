#!/bin/bash

echo '============================================'
echo '    Making sure Python 3 is installed...'

VER='^Python 3\.(8|9|10).*'
RES=$(python3 -V)
if [[ $RES =~ $VER ]]; then
    echo '[+] OK'
else
    echo '[-] Python 3 is not installed!'
    exit 1
fi

echo '    Updating APT packages...'
sudo apt update

echo '============================================'
echo '    Running upgrades...'
sudo apt upgrade

echo '============================================'
echo '    Installing required APT packages...'
sudo apt install aircrack-ng ant audacity autoconf bluez bluez-tools build-essential \
cmake default-jdk doxygen dumpasn1 gcc git gnss-sdr gnuradio gnuradio-dev \
gr-osmosdr hackrf hashcat hcxdumptool libacsccid1 libcppunit-dev libfftw3-bin \
libfftw3-dev libhackrf-dev liblog4cpp5-dev liborc-0.4-dev libosmocore-dev libssl-dev \
libtool libusb-1.0-0 libusb-1.0-0-dev make mingw-w64 net-tools pcsc-tools pcscd \
pkg-config python3-docutils python3-matplotlib python3-pyscard python3-scipy \
python3-serial python3-yaml rtl-433 swig vpb-utils wireshark

# echo '    Making sure pip is installed...'
# VER='^pip .*'
# RES=$(python3 -m pip -V)
# if [[ $RES =~ $VER ]]; then
#     echo '[+] OK'
# else
#     echo '[-] pip is not installed! Installing pip... proceed? (y/n)'
#     read proceed
#     if [[ $xtraPackages == 'n' ]]; then
#         exit 1
#     else
#         echo '    Installing package python3-pip...'
#         sudo apt install python3-pip
#     fi
# fi


echo '============================================'
echo '    Creating folder WIRESEC to store tools...'
mkdir WIRESEC
sudo chmod 777 WIRESEC
cd WIRESEC
echo '[+] OK'

echo '    Installing BTLE...'
git clone https://github.com/JiaoXianjun/BTLE.git
git config --global --add safe.directory ./BTLE
cd BTLE/host
mkdir build
cd build
cmake ../
make
echo '[+] OK'
cd ../../../

echo '============================================'
echo '    Installing hackrf-spectrum-analyzer...'
git clone --depth=1 https://github.com/pavsa/hackrf-spectrum-analyzer.git
git config --global --add safe.directory ./hackrf-spectrum-analyzer
cd hackrf-spectrum-analyzer/src/hackrf-sweep/
make
echo '[+] OK'
cd ../../../

# echo '============================================'
# echo '    Installing hcxtools...'
# sudo apt install curl
# git clone https://github.com/ZerBea/hcxtools.git
# git config --global --add safe.directory ./hcxtools
# cd hcxtools
# make
# sudo make install
# echo '[+] OK'
# cd ../

# echo '============================================'
# echo '    Installing gr-gsm...'
# git clone https://gitea.osmocom.org/sdr/gr-gsm
# git config --global --add safe.directory ./gr-gsm
# cd gr-gsm
# mkdir build
# cd build
# cmake ../
# mkdir $HOME/.grc_gnuradio/ $HOME/.gnuradio/
# make
# sudo make install
# sudo ldconfig
# echo '[+] OK'
# cd ../../


echo '============================================'
echo '    Setting up python venv...'
python3 -m venv venv
source venv/bin/activate
echo '    Installing required python packages...'
python -m pip install crccheck geopy pycrypto


echo '============================================'
echo '    [?] Do you want to install additional packages? (y/n)'
read xtraPackages

if [[ $xtraPackages == 'y' ]]; then
    echo '    Installing additional APT packages...'
    sudo apt install gpsd gpsd-clients libairspy-dev libblas-dev libitpp-dev \
    liblapack-dev libncurses5-dev librtlsdr-dev librtlsdr0 libsoxr-dev \
    pixiewps python3-pyqt5.qtchart python3-setuptools python3-tk reaver
    echo '============================================'
    echo '[+] OK'
    echo '    Adding kismet GPG key...'
    wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key | sudo apt-key add -
    echo '    Adding kismet to sources list...'
    echo 'deb [arch=amd64] https://www.kismetwireless.net/repos/apt/release/buster buster main' | sudo tee /etc/apt/sources.list.d/kismet.list
    echo '    Updating APT packages...'
    sudo apt update
    echo '============================================'
    echo '    Running upgrades...'
    sudo apt upgrade
    echo '[+] OK'
    echo 'Installing kismet...'
    sudo apt install kismet
    echo '============================================'
    echo '    Installing additional python packages...'
    python3 -m pip install dronekit gps3 manuf matplotlib numpy pybluez2
fi

echo '    Done'
exit 0
