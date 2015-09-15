# Case Study 2 - multiple robots

import math, sys, os
sys.path.append('/usr/local/lib/python2.7/site-packages/')
sys.path.append('/usr/local/lib64/python2.7/site-packages/')
from playerc import *

# Make proxies for Client, Sonar, Position2d

# first robot
robot = playerc_client(None, 'localhost', 6665)
if robot.connect():
	raise Exception(playerc_error_str())
sp = playerc_ranger(robot,0)
if sp.subscribe(PLAYERC_OPEN_MODE):
	raise Exception(playerc_error_str())
lp = playerc_ranger(robot,1)
if lp.subscribe(PLAYERC_OPEN_MODE):
	raise Exception(playerc_error_str())
pp = playerc_position2d(robot,0)
if pp.subscribe(PLAYERC_OPEN_MODE):
	raise Exception(playerc_error_str())

# second robot
sp2 = playerc_ranger(robot,2)
if sp2.subscribe(PLAYERC_OPEN_MODE):
	raise Exception(playerc_error_str())
lp2 = playerc_ranger(robot,3)
if lp2.subscribe(PLAYERC_OPEN_MODE):
	raise Exception(playerc_error_str())
pp2 = playerc_position2d(robot,1)
if pp2.subscribe(PLAYERC_OPEN_MODE):
	raise Exception(playerc_error_str())

# shared simulation proxy
simp = playerc_simulation(robot,0)
if simp.subscribe(PLAYERC_OPEN_MODE):
	raise Exception(playerc_error_str())

sp.get_geom()
lp.get_geom()
sp2.get_geom()
lp2.get_geom()

while True:
	# Read from proxies
	robot.read()

	# Print out sonars for fun
	print "%d sonar ranges (robot 1): "% sp.ranges_count
	for i in range(sp.ranges_count):
		print "%.3f, " % sp.ranges[i],
	print "."

	# Print out lasers for fun
	print "%d laser ranges (robot 1): "% lp.ranges_count
	for i in range(lp.ranges_count):
		print "%.3f, " % lp.ranges[i],
	print "."

	# do simple collision avoidance
	short = 0.5;
	if sp.ranges[0] < short or sp.ranges[2]<short:
		turnrate = math.radians(-20); # Turn 20 degrees persecond
	elif sp.ranges[1] <short or sp.ranges[3]<short:
		turnrate = math.radians(20)
	else:
		turnrate = 0;

	if sp.ranges[0] < short or sp.ranges[1] < short:
		speed = 0;
	else:
		speed = 0.100;

	# Command the motors
	pp.set_cmd_vel(speed, 0.0, turnrate, 1)


	# Print out sonars for fun
	print "%d sonar ranges (robot 1): "% sp2.ranges_count
	for i in range(sp2.ranges_count):
		print "%.3f, " % sp2.ranges[i],
	print "."

	# Print out lasers for fun
	print "%d laser ranges (robot 1): "% lp2.ranges_count
	for i in range(lp2.ranges_count):
		print "%.3f, " % lp2.ranges[i],
	print "."

	# do simple collision avoidance
	short = 0.5;
	if sp2.ranges[0] < short or sp2.ranges[2]<short:
		turnrate = math.radians(-20); # Turn 20 degrees persecond
	elif sp2.ranges[1] <short or sp2.ranges[3]<short:
		turnrate = math.radians(20)
	else:
		turnrate = 0;

	if sp2.ranges[0] < short or sp2.ranges[1] < short:
		speed = 0;
	else:
		speed = 0.100;

	# Command the motors
	pp2.set_cmd_vel(speed, 0.0, turnrate, 1)

	rtn,x,y,a = simp.get_pose2d("bob1")
	print "bob1 is at Pose = %.2f,%.2f,%.2f)" % (x,y,a)
	rtn,x,y,a = simp.get_pose2d("bob2")
	print "bob2 is at Pose = %.2f,%.2f,%.2f)" % (x,y,a)
