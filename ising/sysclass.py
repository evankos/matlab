import energy as E
import os,sys

class SystemState:
        def __init__ (self, LX,LY,J,T,TIME,FREQ,TOL=1.0E-4):
                self.Lx = LX
                self.Ly = LY
                self.N  = self.Lx*self.Ly
                self.J  = J
                self.T  = T
		self.tol = TOL
                self.time  = int(TIME)
		self.freq  = FREQ 
                self.system = E.create_new_state(self.N)
		if self.freq == 0:
			print "    Warning: freq parameter cannot be 0."
			sys.exit(1)

        def magnetization (self):
                return E.magnetization(self.system)

        def energy (self):
                return E.Total_Energy(self.J,self.Lx,self.Ly,self.system)

        def flipspin (self):
                return E.flip_spin(self.system)

	def print_lattice(self):
	        """ prints the state of the system """
	        os.system("clear")
	        for j in range(self.Ly):
	                print "   ",
	                for i in range(self.Lx):
	                        if lattice[j*self.Lx+i] == +1:
	                                print "x",
	                        else :
	                                print "o",
	                print
	        print
        
	def __str__ (self):
        	return "    (T,E,M) =({:3f},{:4f},{:4f})".format(self.T,self.energy(),self.magnetization()) 
	
	def __repr__ (self):
		return  "    Size of the system: N = Lx Ly = {}x{} = {}".format(self.Lx,self.Ly,self.N)
	
	
#def print_to_file(Lx,Ly,lattice):
#        """ Prints the system to a file for gnuplot """
#        with open("output.txt","w") as fo:
#                for j in range(Ly):
#                        for i in range(Lx):
#                                fo.write("{} {} {}\n".format(i,j,lattice[j*Lx+i]))
#
