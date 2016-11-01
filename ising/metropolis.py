import math as m
import random as rn
import energy as E
# import output
import sys


def transition_probability (E,T):
	T_min = 1.0E-10
	k_B = 1.0
	beta = 1.0/k_B*T
	if T < T_min :
		return False
	else :
		p = m.exp(-beta*E)
		if p > rn.uniform(0,1) :
			return True
	
	
def metropolis_hashting (system):

	current_state = system
	avg_E = 0
	avg_M = 0
	
	TOL = system.tol
	diff_E = 10 
	tmax = system.time
	t = 0

	for t in range(tmax):
		# Compute the energy of the system
		E_curr = current_state.energy()

		# Create a new system and compute its energy
		new_state = current_state
		new_state.system = new_state.flipspin() 
		E_new = new_state.energy() 

		# Compute Energy difference between the two systems
		diff_E = -(E_new - E_curr)

		# Choosing to keep the new state or not
		if diff_E < 0.0 : 
			current_state = new_state
		else :
			if transition_probability(diff_E,system.T) : 
				current_state = new_state 

		# Print results every now and then
		if t % system.freq == 0 :
			print "  {:4d}  {:6f}  {:6f}  {:6f}".format(t,E_curr,E_new,diff_E)

		# Averages
		avg_E += current_state.energy()
		avg_M += current_state.magnetization()

	# Print final state after Metropolis-Hashting
	print current_state
	print "    (avg_E,avg_M) = ({},{})".format(avg_E/float(tmax),avg_M/float(tmax))
		
	return current_state
