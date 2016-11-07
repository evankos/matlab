from __future__ import division


# from matlab_local import engine_context
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt
from numpy import *
from tqdm import *

def img33_4():

    """
    Image 33.4 page 430 McKay
    :return:
    """



    def updateQ_m(data,Q_s):

        """
        implements the update seen in 33.41
        :param Q_s: Q of sigma
        :param data: the samples
        :return: Q_m
        """
        mu_mean = np.mean(data)
        mean_sigma, var_sigma = Q_s.stats(moments='mv')
        mean_beta = 1/mean_sigma**2

        # beta_vec = 1. / (np.arange(0.001, 10000, 0.01) ** 2)
        # Q_s_sigma = 2 * np.sqrt(2) * (beta_vec ** (3/2.)) * Q_s.pdf(beta_vec)
        # mean_beta = 1. / (data.size * np.average(beta_vec, weights=Q_s_sigma))

        mu_sigma_data = np.sqrt(1/(data.size * mean_beta))
        return stats.norm(mu_mean,mu_sigma_data)

    def updateQ_s(data,Q_m,Q_s):

        """
        implements the update seen in 33.44
        :param Q_m: Q of m optimal
        :param data: the samples
        :return: Q_s
        """
        mean_sigma, var_sigma = Q_s.stats(moments='mv')
        mean_beta = 1/mean_sigma**2

        # beta_vec = 1. / (np.arange(0.001, 10000, 0.01) ** 2)
        # Q_s_sigma = 2 * np.sqrt(2) * (beta_vec ** (3/2.)) * Q_s.pdf(beta_vec)
        # mean_beta = 1. / (data.size * np.average(beta_vec, weights=Q_s_sigma))

        mu_sigma_data = np.sqrt(1/(data.size * mean_beta))
        S = np.std(data)**2 * data.size

        b_prime=0.5*(data.size * mu_sigma_data**2 + S)
        c_prime=data.size/2
        return stats.invgamma(a=b_prime,scale=c_prime)


    # True mean and sigma
    m=1
    s=1.2

    # Starting mean and sigma
    m_s=2
    s_s=.5

    # Sample 5 datapoints from posterior, we asume thats all we have.
    data = stats.norm(m,s).rvs(10)
    print

    # Code to Plot the results and the Distributions.
    thetas1 = np.linspace(0, 4, 101)
    thetas2 = np.linspace(0, 4, 101)
    X, Y = np.meshgrid(thetas1, thetas2)

    # conjugate prior for a standard deviation sigma and mu
    data_mean = np.mean(data)
    data_var = np.std(data)
    alpha_inv_gamma = 1 + data.size /2
    beta_inv_gamma = np.std(data)**2 * data.size /2
    posterior = stats.invgamma(a=alpha_inv_gamma,scale=beta_inv_gamma).pdf(Y) * stats.norm(data_mean,data_var/data.size).pdf(X)

    startQ_s=stats.invgamma(a=m_s / s_s**2,scale=s_s**2)
    startQ_m=stats.norm(m_s,s_s)
    prior = startQ_s.pdf(Y) * startQ_m.pdf(X)


    fig, ax = plt.subplots(3, 2, sharex='col', sharey='row')
    ax[0][0].contour(X, Y, posterior, colors='k', ylabel='sigma',xlabel='mean')
    ax[0][0].contour(X, Y, -prior, colors='k')
    ax[0][0].set_title('A conjugate prior')

    # Starting Q_s
    Q_s = startQ_s


    # Updating Q_m from 33.41
    Q_m = updateQ_m(data, Q_s)
    prior = Q_s.pdf(Y) * Q_m.pdf(X)
    ax[0][1].contour(X, Y, -prior, colors='k') #negative contours are dashed
    ax[0][1].contour(X, Y, posterior, colors='k')
    ax[0][1].set_title('B updated mean')

    # Updating Q_s from 33.44
    Q_s = updateQ_s(data, Q_m, Q_s)
    prior = Q_s.pdf(Y) * Q_m.pdf(X)
    ax[1][0].contour(X, Y, -prior, colors='k') #negative contours are dashed
    ax[1][0].contour(X, Y, posterior, colors='k')
    ax[1][0].set_title('C updated sigma')



    # Updating Q_m from 33.41
    Q_m = updateQ_m(data, Q_s)
    prior = Q_s.pdf(Y) * Q_m.pdf(X)
    ax[1][1].contour(X, Y, -prior, colors='k') #negative contours are dashed
    ax[1][1].contour(X, Y, posterior, colors='k')
    ax[1][1].set_title('D updated mean')

    # Updating Q_s from 33.44
    Q_s = updateQ_s(data, Q_m, Q_s)
    prior = Q_s.pdf(Y) * Q_m.pdf(X)
    ax[2][0].contour(X, Y, -prior, colors='k') #negative contours are dashed
    ax[2][0].contour(X, Y, posterior, colors='k')
    ax[2][0].set_title('C updated sigma')










    plt.show()

if __name__ == "__main__":
    img33_4()
