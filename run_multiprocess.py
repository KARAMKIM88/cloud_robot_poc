#!/usr/bin/env python2

import SimpleHTTPServer
import SocketServer
import os
import time



ROS_MASTER_URI = os.environ['ROS_MASTER_URI']
ROS_HOSTNAME = os.environ['ROS_HOSTNAME']
TURTLEBOT3_MODEL = os.environ['TURTLEBOT3_MODEL']
LOG_FOLER = '/home/rosmaster/ros-log/'


print("ROS_MASTER_URI : " + ROS_MASTER_URI)
print("ROS_HOSTNAME : " + ROS_HOSTNAME)
print("TURTLEBOT3_MODEL : " + TURTLEBOT3_MODEL)

os.system('/home/rosmaster/web_video_server.sh' )
os.system('(roscore >> /home/rosmaster/ros-log/roscore-kkr.log) & ' )
time.sleep(5)
#os.system('rosrun video_stream_opencv video_stream &' )  for debugging
os.system('(roslaunch turtlebot3_navigation turtlebot3_navigation.launch map_file:=/home/rosmaster/map/map.yaml >> /home/rosmaster/ros-log/rosnavi-kkr.log ) &' )
#os.system('(roslaunch  web_video_server web_video_server.launch >> /home/rosmaster/ros-log/rosvideo-kkr.log ) &' )
os.system('(rosrun  web_video_server web_video_server >> /home/rosmaster/ros-log/rosvideo-kkr.log ) &' )

"""
subprocess.Popen(['roscore'])
subprocess.Popen(['rosrun web_video_server web_video_server'])
subprocess.Popen(['rosrun video_stream_opencv video_stream_opencv'])
"""



HOST, PORT = "localhost", 10808
Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer((HOST, PORT), Handler)
print('Server listening on port 10808...')
httpd.serve_forever()

