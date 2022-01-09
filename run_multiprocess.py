#!/usr/bin/env python3

import subprocess
import http.server
import socketserver
import os
import time


os.system('roscore &' )
time.sleep(5)
os.system('rosrun video_stream_opencv video_stream &' )
#os.system('rosrun web_video_server web_video_server &' ) for debugging

"""
subprocess.Popen(['roscore'])
subprocess.Popen(['rosrun web_video_server web_video_server'])
subprocess.Popen(['rosrun video_stream_opencv video_stream_opencv'])
"""

handler = http.server.SimpleHTTPRequestHandler

HOST, PORT = "localhost", 10808

with socketserver.TCPServer((HOST, PORT), handler) as httpd:
  print('Server listening on port 10808...')
  httpd.serve_forever()
