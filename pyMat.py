from __future__ import division


# from matlab_local import engine_context
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt
from numpy import *
from tqdm import *



# @engine_context
# def test_engine(ctx):
#     # ctx.matlab_engine.desktop(nargout=0)
#     print ctx.matlab_engine.sqrt(4.)
#     print ctx.matlab_engine.linspace(0.,1.,100.)

def ex29_13():
    """
    Exercise 29.13 page 382 McKay
    """
    sigma_p = 1
    sigma_segmentation=1000 # Stepping through sigma linear space
    P = stats.norm(loc=0,scale=sigma_p)
    Z_true = P.cdf(10) # Z=1 we pretend we dont know

    plot_x = np.linspace(.1,1.6,sigma_segmentation)
    R = [1000,10000,100000]
    means = np.zeros((4,sigma_segmentation))
    stds = np.zeros((4,sigma_segmentation))
    weights = np.zeros((30,sigma_segmentation))
    for i,sigma_q in enumerate(plot_x):
        np.random.seed(2016) #using the same random seed
        Q = stats.norm(loc=0,scale=sigma_q)
        x = Q.rvs(R[2])
        Weights = P.pdf(x)/Q.pdf(x)
        weights[:,i] = Weights[:30]
        for j,r in enumerate(R):
            means[j,i] = np.mean(Weights[:r])
            stds[j,i] = np.std(Weights[:r])
        means[3,i] = 1
        stds[3,i] = sigma_q**2/sqrt(sigma_p * (2 * sigma_q**2 - sigma_p**2)) - 1


    f, axarr = plt.subplots(3, sharex=True)
    axarr[0].plot(plot_x, means[0,:],'k:',label='1K')
    axarr[0].plot(plot_x, means[1,:],'k--',label='10K')
    axarr[0].plot(plot_x, means[2,:],'k',label='100K')
    axarr[0].plot(plot_x, means[3,:],label='Theory')
    axarr[0].set_title('Estimated Normalizing Constant')
    axarr[0].legend(loc='upper right', shadow=False)

    axarr[1].plot(plot_x, stds[0,:],'k:',label='1K')
    axarr[1].plot(plot_x, stds[1,:],'k--',label='10K')
    axarr[1].plot(plot_x, stds[2,:],'k',label='100K')
    axarr[1].plot(plot_x, stds[3,:],label='Theory')
    axarr[1].set_title('Empirical Standard Deviation')
    axarr[1].legend(loc='upper right', shadow=False)

    for i in range(30):
        axarr[2].plot(plot_x, weights[i,:],'k')
    axarr[2].set_title('Weights')

    plt.show()

def ex29_15():

    """
    Exercise 29.15 page 383 McKay
    :return:
    """

    def gibbs(m,s,N=2000,thin=10, burnin=100):
        """
        Gibbs function for Exercise 29.15 page 383 McKay
        :param m: Starting out value of mean
        :param s: Starting out value of sigma
        :param N: Number of gathered samples
        :param thin: Distance between 2 samples in algorithm steps, in order to avoid correlated samples
        :param burnin: Number of samples to discard at the beginning
        :return: List of [m,s] samples
        """
        m_static = m # Making this static to avoid self-correlation
        s_static = s # Making this static to avoid self-correlation
        datas = []
        try:
            for i in tqdm(range(N+burnin)):
                for j in range(thin):#step separation for practicaly independent samples

                    # Updating the mean
                    m=np.abs(stats.norm(m_static,s).rvs())


                    # Updating the sigma, scale is 1/beta for this implementation and a is expressed
                    # as function of the desired mean and variance
                    s = np.abs(stats.gamma(a=m / s_static**2,scale=s_static**2).rvs())

                # Discarding occasional samples too far out of plot focus
                if(m<15 and s<15 and i>burnin): datas.append([m,s])
        except:
            print "exception"
        print m,s
        return datas
    # Our starting parameters, we need these to get the algorithm going.
    # We chose parameters that make both distributions broad, as requested by the exercise.
    m=5
    s=2

    # Running Gibbs and collecting the resulting samples.
    data_points = np.array(gibbs(m,s))


    # Code to Plot the results and the Distributions.
    thetas1 = np.linspace(-5, 15, 101)
    thetas2 = np.linspace(-5, 15, 101)
    X, Y = np.meshgrid(thetas1, thetas2)


    prior = stats.gamma.pdf(X,a=m / s**2,scale=s**2) * stats.norm(m,s).pdf(Y)

    x_dist_norm = np.linspace(-5, 15, 101)
    x_dist_gamma = np.linspace(-5, 15, 101)
    fig, ax = plt.subplots(3, sharex=True)
    ax[0].contour(X, Y, prior, ylabel='normal',xlabel='gamma')
    ax[0].set_title('P(m|sigma) * P(sigma|m)')
    ax[0].scatter(data_points[:,1], data_points[:,0], marker='o', c='b', s=3.0)
    ax[1].plot(x_dist_gamma, stats.gamma.pdf(x_dist_gamma,a=m / s**2,scale=s**2))
    ax[1].set_title('Gamma distribution of variance: P(sigma|m)')
    ax[2].plot(x_dist_norm, stats.norm(m,s).pdf(x_dist_norm))
    ax[2].set_title('Normal distribution of mean: P(m|sigma)')
    plt.show()







if __name__=="__main__":
    ex29_13()
    # ex29_15()
