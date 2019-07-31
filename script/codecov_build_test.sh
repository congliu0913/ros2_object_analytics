#!/bin/bash

# sync code
cd /root/
mkdir -p ros2_ws/src && cd ros2_ws/src
cp -r /root/ros2_object_analytics ./
git clone --depth=1 https://github.com/intel/ros2_object_msgs 
git clone --depth=1 https://github.com/ros-perception/vision_opencv -b ros2
git clone --depth=1 https://github.com/ros2/pcl_conversions -b dashing 
ls -lh
cd ../

# setup env
source /home/robot/ros2_ws/install/local_setup.bash

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE &&\
  sh -c 'echo "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo `lsb_release -cs` main" > /etc/apt/sources.list.d/librealsense.list' &&\
  apt update && apt-get install -qq -y librealsense2-dkms librealsense2-utils librealsense2-dev libboost-all-dev libpcl-dev liblz4-1 liblz4-dev

# build ros2 object analytics
colcon build --symlink-install --cmake-args  -DCMAKE_BUILD_TYPE=Debug -DCOVERAGE_ENABLED=True

# test
source install/local_setup.bash
colcon test --base-paths src/ros2_object_analytics
