import metropolis as mt
import energy as E
import random as rn
import metropolis
# import output
import sysclass
import sys, os, time

def main ():
	""" Lx,Ly is the size of the sistem, N is the total number of spins, 
	    M is the time, T temperature, J is the interaction parameter
	"""

        Lx = 10
        Ly = 10
	time = 5.0E4 
	freq = 1.00 * time
	Ti = 0.00
	Te = 1.0
	dT = 0.05
	NT = int((Te-Ti) / dT +1)
	T = [Ti+n*dT for n in range(NT)]
        J = - 1.0

	system = sysclass.SystemState(Lx,Ly,J,Ti,time,freq)

#        print "  Number of Spins = {}".format(system.N)
	print repr(system)

        rn.seed()

	system.T = T[0]
	for i in range(100):
		system = metropolis.metropolis_hashting(system)

if __name__=='__main__':
	main()

