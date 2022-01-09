FROM ros:kinetic-ros-base-xenial

## follow instructions from http://emanual.robotis.com/docs/en/platform/turtlebot3/pc_setup/

ARG username=rosmaster
ARG groupid=1000
ARG userid=1000

ENV ROS_MASTER_URI http://localhost:11311
ENV ROS_HOSTNAME localhost

# USE BASH
SHELL ["/bin/bash", "-c"]

# RUN LINE BELOW TO REMOVE debconf ERRORS (MUST RUN BEFORE ANY apt-get CALLS)
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

#### 6.1.2 
RUN apt-get install -y ros-kinetic-desktop-full ros-kinetic-rqt-*
RUN apt-get install -y python-rosinstall
RUN source ros_entrypoint.sh \
    && mkdir -p /catkin_ws/src \
    && cd /catkin_ws/src \
    && catkin_init_workspace \
    && cd /catkin_ws \
    && catkin_make
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc \
    && echo "export ROS_HOSTNAME=localhost" >> ~/.bashrc

#### 6.1.3
RUN  apt-get update -y && apt-get install -y ros-kinetic-joy \
    ros-kinetic-teleop-twist-joy ros-kinetic-teleop-twist-keyboard \
    ros-kinetic-laser-proc ros-kinetic-rgbd-launch \
    ros-kinetic-depthimage-to-laserscan ros-kinetic-rosserial-arduino \
    ros-kinetic-rosserial-python ros-kinetic-rosserial-server \
    ros-kinetic-rosserial-client ros-kinetic-rosserial-msgs ros-kinetic-amcl \
    ros-kinetic-map-server ros-kinetic-move-base ros-kinetic-urdf \
    ros-kinetic-xacro ros-kinetic-compressed-image-transport \
    ros-kinetic-rqt-image-view ros-kinetic-gmapping ros-kinetic-navigation \
    ros-kinetic-interactive-markers ros-kinetic-dynamixel-sdk ros-kinetic-turtlebot3-msgs \
    ros-kinetic-turtlebot3 ros-kinetic-cv-bridge ros-kinetic-vision-opencv \
    ros-kinetic-video-stream-opencv
COPY ./devel_final /catkin_ws/devel
RUN source ros_entrypoint.sh
RUN source /catkin_ws/devel/setup.bash 
####    && cd /catkin_ws/src \
####    && git clone https://github.com/RobotWebTools/web_video_server.git \
####    && git clone  https://github.com/fkie/async_web_server_cpp.git  \
####    && cd /catkin_ws \
####    && catkin_make

#### 6.1.4
RUN apt-get install -y net-tools && apt-get install -y iputils-ping

# setup user env at the end
# -m option creates a fake writable home folder
RUN groupadd -g $groupid $username \
    && useradd -m -r -u $userid -g $username $username
USER $username
RUN echo "source /opt/ros/kinetic/setup.bash" >> /home/$username/.bashrc

COPY ./run_multiprocess.py /run_multiprocess.py

RUN echo "source /catkin_ws/devel/setup.bash" >> /home/$username/.bashrc



CMD ["python3 /run_multiprocess.py"]
