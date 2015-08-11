from numpy import sin, cos
import numpy as np
import matplotlib.pyplot as plt
import scipy.integrate as integrate
import matplotlib.animation as animation
import math

xaxis = 5

class DoublePendulum:
    """Double Pendulum Class

    init_state is [x, theta, velocity, omega] in degrees,
    where x - position of the cart, theta is the angular position of the
    pendulum arm, velocity - velocity of the cart, and omega is the
    angular velocity of the pendulum
    """
    def __init__(self,
                 init_state = [0.0, 0.0, 0.0, 0.0],
                 l=0.3,  # length of pendulum in m
                 m=0.25,  # mass of pendulum in kg
		 L=1.0,  # length of the cart in m
                 M=0.5,  # mass of the cart in kg
		 friction = 7.68, # friction coefficient in N / m / sec
                 G=9.81, # acceleration due to gravity, in m/s^2
                 origin=(0, 0)): 
        self.init_state = np.asarray(init_state, dtype='float')
        self.params = (l, m, L, M, friction, G)
        self.origin = origin
        self.time_elapsed = 0
        self.state = self.init_state
	self.ground = False
	#self.KP = 25.0
	#self.KD = 5.0
	self.KP = 0.0
	self.KD = 0.0


    def position(self):
        """compute the current x,y positions of the pendulum arms"""
        (l, m, L, M, friction, G) = self.params

        x = np.cumsum([self.state[0],
                       L,
                       2*l * sin(self.state[1])])
        y = np.cumsum([self.origin[1],
                       self.origin[1],
                       2*l * cos(self.state[1])])
        return (x, y)

    def control_update(self):
        """compute the control update for the given state"""
        (l, m, L, M, friction, G) = self.params
	u = self.KP * self.state[1] + self.KD * self.state[3]
	return u

    def dstate_dt(self, state, t):
        """compute the derivative of the given state"""
        (l, m, L, M, friction, G) = self.params
        u = self.control_update()

        dt = np.zeros_like(state)
        dt[0] = state[2]
        dt[1] = state[3]
		
	dt2_num = u + m * l * math.sin(state[1]) * math.pow(state[3],2.0) - m * G * math.cos(state[1]) * math.sin(state[1])
	dt2_den = M + m - m * math.pow(math.cos(state[1]), 2.0)
	dt[2] = dt2_num / dt2_den

	dt3_num = u * math.cos(state[1]) - (M+m) * G * math.sin(state[1]) + m * l * (math.cos(state[1]) * math.sin(state[1])) * state[3]
	dt3_den = m * l * math.pow(math.cos(state[1]), 2.0) - (M+m) * l
	dt[3] = dt3_num / dt3_den

        return dt

    def bound_control(self, control):
	global xaxis
	# cart position and velocity
	if abs(self.state[0]) > xaxis:
            control[2] = 0
	    control[3] = 0
	return control

    def bound_state(self):
	global xaxis
	# cart position and velocity
	if self.state[0] > xaxis:
            self.state[2] = 0
	    self.state[0] = xaxis
	elif self.state[0] < -xaxis:
            self.state[2] = 0
	    self.state[0] = -xaxis

    def step(self, dt):
        """execute one time step of length dt and update state"""
        self.state = integrate.odeint(self.dstate_dt, self.state, [0, dt])[1]
	self.bound_state()
	print self.state
        self.time_elapsed += dt

#------------------------------------------------------------
# set up initial state and global variables
pendulum = DoublePendulum([0.0, np.radians(20.0), 0.0, 0.0])
dt = 1./100 

#------------------------------------------------------------
# set up figure and animation
fig = plt.figure()
ax = fig.add_subplot(111, aspect='equal', autoscale_on=False,
                     xlim=(-1.5 * xaxis, 1.5 * xaxis), ylim=(-4, 4))
ax.grid()

line, = ax.plot([], [], 'o-', lw=2)
time_text = ax.text(0.02, 0.95, '', transform=ax.transAxes)

def init():
    """initialize animation"""
    line.set_data([], [])
    time_text.set_text('')
    return line, time_text

def animate(i):
    """perform animation step"""
    global pendulum, dt
    pendulum.step(dt)
    
    line.set_data(*pendulum.position())
    time_text.set_text('time = %.1f' % pendulum.time_elapsed)
    return line, time_text

# choose the interval based on dt and the time to animate one step
from time import time
t0 = time()
animate(0)
t1 = time()
interval = 1000 * dt - (t1 - t0)

ani = animation.FuncAnimation(fig, animate, frames=300,
                              interval=interval, blit=False, init_func=init)

# save the animation as an mp4.  This requires ffmpeg or mencoder to be
# installed.  The extra_args ensure that the x264 codec is used, so that
# the video can be embedded in html5.  You may need to adjust this for
# your system: for more information, see
# http://matplotlib.sourceforge.net/api/animation_api.html
#ani.save('double_pendulum.mp4', fps=30, extra_args=['-vcodec', 'libx264'])

plt.show()
