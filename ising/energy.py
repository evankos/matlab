import random as rn
import sys,os,time
import metropolis

def Neighbours (i, j, L, lattice):
	""" Given a site (i,j) of the lattice return the four neighbours 
	    of the given index as a list of indices. L is the length of the
	    lattice in the X axis 
	"""
	neigh = []

	# There are four special cases: the four corners
	# Elsewhere these neigh indices can be used:
	# Right Neighbour
	if i == L-1 :
		if j == 0 :
			neigh.append(0)
		elif j == L-1 :
			neigh.append(L*(L-1))
		else :
			neigh.append(L*j)
	else :
		neigh.append(L*j+i+1)
		

	# Left Neighbour
	if i == 0 :
		if j == 0 :
			neigh.append(L-1)
		elif j == L-1 :
			neigh.append(L**2-1)
		else :
			neigh.append(L*(j+1)-1)
	else :
		neigh.append(L*j+i-1)

	# Up Neighbour
	if j == L-1 :
		if i == 0: 
			neigh.append(0)
		elif i == L-1 :
			neigh.append(L-1)
		else :
			neigh.append(i)
	else :
		neigh.append(L*(j+1)+i)

	# Down Neighbour
	if j == 0 :
		if i == 0 :
			neigh.append(L*(L-1))
		elif i == L-1 :
			neigh.append(L**2-1)
		else :
			neigh.append(L*(L-1)+i)
	else :
		neigh.append(L*(j-1)+i)

	return sorted(neigh)

def print_neighbours(lattice):
	""" Print the list of neighbours of each spin site """
	for j in range(Ly):
		for i in range(Lx):
			print "  [{}]-({}, {})".format(j*Lx+i,i,j), Neighbours(i,j,Lx,lattice)

	

def Single_Energy_Contribution (i,j,L,lattice):
	""" Returns the energy contribution of one single spin in the (i,j)
	    location.
	"""
	partial_energy = 0.0

	for n in Neighbours(i,j,L,lattice):
		partial_energy += lattice[i*L+j]*lattice[n]

	return partial_energy

def Total_Energy (J,Lx,Ly,lattice):
	""" Iterates over all atoms in lattice and computes the total energy 
	    of the system. The parameter J is the interaction parameter 
	"""
	if J == 0:
		return 0
	else :
		# Assume Lx, Ly as integers for now
		Lx = int(Lx)
		Ly = int(Ly)
		t_energy = 0
		for j in range(Ly):
			for i in range(Lx):
				t_energy += Single_Energy_Contribution(i,j,Lx,lattice)

		return (-1)*J*t_energy 

def magnetization (lattice):
	""" Computes the magnetization of the system: The pro
	    portion of spin up vs the total number of spins
	"""
	UP = 0
	for s in range(len(lattice)):
		if lattice[s] == +1:
			UP += 1

	return UP/float(len(lattice))	

def create_new_state(N):
	""" Creates a new random state with <M> = r """
	r = rn.uniform(0,1)
	new_state = [+1 for n in range(int(r*N))]+[-1 for n in range(int((1-r)*N)+1)]
	rn.shuffle(new_state)
	return new_state

def flip_spin(lattice):
	""" Flip a single spin of the system """
	r = rn.randint(0,len(lattice)-1)
	flip_lattice = lattice
	flip_lattice[r] = (-1)*flip_lattice[r]
	return flip_lattice

