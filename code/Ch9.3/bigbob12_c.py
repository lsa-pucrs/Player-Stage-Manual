# Simple python client example 
# Based on example0.cc from player distribution
# K. Nickels 7/24/13

import math, sys, os
sys.path.append('/usr/local/lib64/python2.7/site-packages/')
from playerc import *

# Make proxies for Client, blobfinder
robot = playerc_client(None, 'localhost', 6665)
if robot.connect():
	raise Exception(playerc_error_str())

# Create a proxy for position2d:0 device
p = playerc_position2d(robot,0)
if p.subscribe(PLAYERC_OPEN_MODE) !=0:
	raise Exception(playerc_error_str())

s = playerc_simulation(robot,0)
if s.subscribe(PLAYERC_OPEN_MODE) !=0:
	raise Exception(playerc_error_str())

p.set_cmd_vel(0.0, 0.0, 40.0 * math.pi / 180.0, 1)

for i in range(0,30):
# Wait for new data from server
	if robot.read() == None:
		raise Exception(playerc_error_str())
	# Print current robot pose
	print 'Robot pose: (%.3f,%.3f,%.3f)' % (p.px,p.py,p.pa)

	rtn,x,y,a = s.get_pose2d("bob1")
	if rtn<0:
		raise Exception(playerc_error_str())
	else:
		print 'Sim : (%.3f,%.3f,%.3f)' % (x,y,a)
	
# Now stop
p.set_cmd_vel(0.0, 0.0, 0.0, 1)

# Clean up (l.unsubcribe is for laser sensor)
p.unsubscribe()
robot.disconnect()
