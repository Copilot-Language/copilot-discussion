from numpy import sin, cos
import numpy as np
import matplotlib.pyplot as plt
import scipy.integrate as integrate
import matplotlib.animation as animation
import math
import fileinput

dims = 4
xaxis = 5
L = 0.5
l = 0.5

data_points = []
rtr_predict = []
status = []

#------------------------------------------------------------
count = 1
for line in fileinput.input():
    if (count % 3) == 1:
        data_points.append([x for x in line.split(' ')])
    elif (count % 3) == 2:
        rtr_predict.append([[float(x) for x in interval[1:-1].split(' ')] for interval in line.strip().split('\t')])
    else:
        status.append(line.strip())
    count = count + 1

# set up figure and animation
fig = plt.figure()
ax = fig.add_subplot(111, aspect='equal', autoscale_on=False,
                     xlim=(-xaxis, xaxis), ylim=(-4, 4))
ax.grid()

line, = ax.plot([], [], 'o-', lw=2)
predict, = ax.plot([], [], 'o-', lw=2)
rtr_monitor_text = ax.text(0.02, 0.95, '', transform=ax.transAxes)

def init():
    """initialize animation"""
    line.set_data([], [])
    predict.set_data([], [])
    rtr_monitor_text.set_text('')
    return line

def animate(i):
    """perform animation step"""
    line.set_data(get_data_pt(i))
    predict.set_data(get_predict_pt(i))
    rtr_monitor_text.set_text(status[i])
    # set rtr predict line color
    if status[i] == "Safe":
        predict.set_color('g')
    else:
        predict.set_color('r')
    return line

def get_predict_pt(i):
    minV = 0
    maxV = 1
    pos = 0
    theta = 1
    hyperRect = rtr_predict[i]
    x = np.cumsum([L + hyperRect[pos][maxV], l * sin(hyperRect[theta][maxV])])
    y = np.cumsum([0, l * cos(hyperRect[theta][minV])])
    return (x, y)

def get_data_pt(i):
    x = np.cumsum([float(data_points[i][0]), L, l * sin(float(data_points[i][1]))])
    y = np.cumsum([0, 0, l * cos(float(data_points[i][1]))])
    return (x, y)

from time import time
frame_rate = 60.0
interval = 1000.0/frame_rate

# choose the interval based on dt and the time to animate one step
ani = animation.FuncAnimation(fig, animate, frames=len(data_points)-1, init_func=init,
                              interval=interval, blit=False)

# save the animation as an mp4.  This requires ffmpeg or mencoder to be
# installed.  The extra_args ensure that the x264 codec is used, so that
# the video can be embedded in html5.  You may need to adjust this for
# your system: for more information, see
# http://matplotlib.sourceforge.net/api/animation_api.html
#ani.save('inverted_pendulum.mp4', fps=30, extra_args=['-vcodec', 'libx264'])

plt.show()
