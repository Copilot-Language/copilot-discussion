#!/usr/bin/python

from numpy import sin, cos
from mpl_toolkits.mplot3d import Axes3D, art3d
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import sys
import math

l = 0.5

def plot_projection(data):
    newdata = []
    for hyperRect in data:
	    avgx = (hyperRect[0][0] + hyperRect[0][1]) / 2.0
	    theta = hyperRect[1][0]
	    for theta in hyperRect[1]:
                x = []
                y = []
		# base point of pendulum
	        x.append(avgx)
	        y.append(0)
		# end point of pendulum
                x.append(avgx + l * sin(theta))
                y.append(l * cos(theta))
                newdata.append([x,y])
    return newdata

def plot(data, endpoints = False):
    fig = plt.figure()
    ax = fig.gca()

    total = len(data)
    count = 0.0
    # Plot data
    for line in data:
	count = count + 1.0
        ax.plot(line[0], line[1], str(0.5-(count/total)*0.50))
	if endpoints:
            ax.plot(line[0][1], line[1][1], 'ro')

    plt.axis('equal')
    plt.show()

# Read the data from the file
def readPath(filename):
    lines = [line.rstrip() for line in open(filename) if len(line.rstrip()) > 0]

    if len(lines) == 0:
        print "Empty File"
        sys.exit(1)

    return [[[float(x) for x in interval[1:-1].split(' ')] for interval in line.strip().split('\t')] for line in lines]

if __name__ == '__main__':
    filename = 'data.txt'
    data = readPath(filename)
    plot(plot_projection(data))
