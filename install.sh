#!/usr/bin/env bash


# ====================================================

function print_blue(){
	printf "\033[34;1m"
	printf "$@ \n"
	printf "\033[0m"
}

# ====================================================

print_blue '================================================'
print_blue 'Installing 3dpatrolling'
print_blue '================================================'

set -e

# --------------------------
# install catkin tools 
# --------------------------
# from https://catkin-tools.readthedocs.io/en/latest/installing.html

print_blue 'Installing catking tools'

# first you must have the ROS repositories which contain the .deb for catkin_tools:
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -

# once you have added that repository, run these commands to install catkin_tools:
sudo apt-get update
sudo apt-get install python-catkin-tools


# --------------------------
# solve problems with ROS melodic  
# --------------------------

version=$(lsb_release -a 2>&1)
if [[ $version == *"18.04"* ]] ; then
	if [ ! -d  patrolling_ws/src/msgs ]; then
		mkdir -p patrolling_ws/src/msgs
	fi
	cd patrolling_ws/src/msgs 
	if [ ! -d  brics_actuator ]; then
		echo 'downloading brics_actuator'
		git clone https://github.com/wnowak/brics_actuator
	fi 
	cd - 
fi 

# --------------------------
# install necessary workspace dependencies 
# --------------------------

print_blue 'ROS dependencies'

rosdep update
rosdep install --from-paths mapping_ws/src --ignore-src -r
rosdep install --from-paths patrolling_ws/src --ignore-src -r

sudo apt-get install -y cmake-extras     # https://bugs.launchpad.net/ubuntu/+source/googletest/+bug/1644062

sudo apt-get install -y python-rosinstall python-rospkg
sudo apt-get install -y ros-$ROS_DISTRO-octomap-mapping ros-$ROS_DISTRO-octomap-msgs ros-$ROS_DISTRO-octomap-ros ros-$ROS_DISTRO-octomap-server
sudo apt-get install -y ros-$ROS_DISTRO-move-base-msgs 
sudo apt-get install -y ros-$ROS_DISTRO-move-base
sudo apt-get install -y ros-$ROS_DISTRO-tf2-geometry-msgs 
sudo apt-get install -y ros-$ROS_DISTRO-tf2
sudo apt-get install -y ros-$ROS_DISTRO-joy
sudo apt-get install -y ros-$ROS_DISTRO-navigation
sudo apt-get install -y sox
sudo apt-get install -y doxygen
sudo apt-get install -y screen 

sudo apt-get install -y libqt4-dev xterm

sudo apt-get install -y libnss3-dev

sudo apt-get install -y liboctomap-dev
sudo apt-get install -y protobuf-compiler libgoogle-glog-dev
sudo apt-get install -y googletest google-mock 

# compile google-test dev   from https://stackoverflow.com/questions/24295876/cmake-cannot-find-googletest-required-library-in-ubuntu
sudo apt-get install -y libgtest-dev
cd /usr/src/googletest
sudo cmake .
sudo cmake --build . --target install
cd - 

# these are necessary for the qt application with PyQt5
sudo apt-get install -y python3-pip 
pip3 install pyqt5==5.14.0 --user  # issues with newest PyQt5 https://stackoverflow.com/questions/59711301/install-pyqt5-5-14-1-on-linux

if [[ $version == *"18.04"* ]] ; then
	sudo apt-get install -y libcanberra-gtk-module libcanberra-gtk3-module
	sudo apt-get install -y libqt4-dev python-qt4
fi 


# --------------------------
# install V-REP
# --------------------------
./install-vrep.sh

# --------------------------
# Compile all
# --------------------------
./compile-all.sh






