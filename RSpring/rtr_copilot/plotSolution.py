#!/usr/bin/python

from mpl_toolkits.mplot3d import Axes3D, art3d
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import sys
import math

lineSegs = [[[0, 0], [1, 0]], [[1, 0], [1, 1]], [[1, 1], [0, 1]], [[0, 1], [0, 0]]]

def sign(value):
    if value > 0:
        return 1
    elif value < 0:
        return -1
    else:
        return 0

def round_scale(value, axis_range):
    most_sig = int(math.floor(math.log10(abs(value))))
    return round(value, -most_sig)

def plot_projection(data, xaxis, yaxis):
    newdata = []
    for hyperRect in data:
        for lineSeg in lineSegs:
            x = []
            y = []
            for pt in lineSeg:
                xval = hyperRect[xaxis][pt[0]]
                yval = hyperRect[yaxis][pt[1]]
                x.append(xval)
                y.append(yval)
            newdata.append([x,y])
    return newdata

def plot(data, endpoints = False, color_scheme = 'k'):
    fig = plt.figure()
    ax = fig.gca()

    # Plot data
    for line in data:
        ax.plot(line[0], line[1], color_scheme)
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
    if len(sys.argv) > 1:
        filename = sys.argv[1]
    else:
        filename = 'data.txt'

    if len(sys.argv) > 3:
	xaxis = int(sys.argv[2])
	yaxis = int(sys.argv[3])
    else:
	xaxis = 0
	yaxis = 1

    data = readPath(filename)
    plot(plot_projection(data, xaxis, yaxis))
