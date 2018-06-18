# EDGES
[![Waffle.io - Columns and their card count](https://badge.waffle.io/sofwerx/EDGES.svg?columns=all)](https://waffle.io/sofwerx/EDGES)

*E*dge  
*D*istributed  
*G*eolocation from  
*E*mitting  
*S*ystems

Geolocation in GPS-denied environments using emitters of opportunity.

## Android phone setup for RF data collection ##
Connect Android phone to computer

New install – run convergence script:  
  git clone https://github.com/sofwerx/docker-aletheios-cicd   
  cd docker-aletheios-cicd /nethunter  
  make  

adb root  
adb push <your_public_key_filename> /data/ssh/authorized_keys  
	(your public key: ~/.ssh/id_rsa.pub or curl https://github.com/<github_username>.keys)  
adb shell  

(now in shell on phone)  
/data/chroot.sh		(/data/root.sh – put chroot commands in path but not chrooted)  

(now in a nethunter Debian [latest – nightly build] chroot environment)  
Install hackrf (requires cmake, build-essential, libfftw3-dev – in converge-chroot.sh):  
  git clone https://github.com/mossmann/hackrf  
  cd hackrf/host  
  mkdir build  
  cd build  
  cmake ..  
  make  
  make install  
	
Start sshd:  
  cd /data/local/tmp  
  nohup /data/local/userinit.d/99sshd & 
  
(hook up HackRF & ssh into phone) OR  
(hold square button to run androidsu shell in nethunter terminal split screen with provost)  
su  

/data/chroot.sh  
git clone https://github.com/sofwerx/EDGES  

(run provost app on phone handset – MUST BE IN FOREGROUND)  

cd /EDGES/hackrf  
./powers.sh  

(Run import.sh with env variables to import into elasticsearch)
