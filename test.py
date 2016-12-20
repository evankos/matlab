from __future__ import division


# from matlab_local import engine_context
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from numpy import *
from tqdm import *


def likelihood(sigma, mu, N, xbar, S):
    """gaussian likelihood"""
    return ((1 / (2 * math.pi * sigma ** 2) ** (N/2.)) * np.exp(-(N * (mu - xbar) ** 2 + S)/(2 * sigma ** 2))/(10 * sigma))

# True posterior
x = np.linspace(0, 2, 50)
y = np.linspace(0.1, 2, 50)
xbar, S, N = 1.0, 1.0, 5

X, Y = np.meshgrid(x, y)
L = likelihood(np.ravel(Y), np.ravel(X), N, xbar, S) 

# True params P(mu|D,sigma)
mu_ = xbar
sigma_ = np.sqrt((S / (N-1)) / np.sqrt(N))

# True params P(sigma|D,mu)
b_ = 0.5
c_ = (N-1) / 2.

# Init
b, c = 0.1, 10
mu, sigma = 0.1, 0.1 
beta_vec = 1. / (np.arange(0.001, 10000, 0.01) ** 2)

fig = plt.figure(figsize=(14,8))
iters = 16
for i in range(iters):
    
    # Caculate Q(mu) and Q(sigma). On first iter, plot the intiial condition
    Q_m = np.asarray([stats.norm.pdf(xx, mu, np.sqrt(sigma)) for xx in np.ravel(X)])
    Q_s = np.asarray([stats.gamma.pdf(1. / (yy ** 2), c, 0, b) for yy in np.ravel(Y)])
    
    # Joint distribution Q(mu, sigma) 
    Q = Q_m * Q_s
    
    # Only update Q(mu)
    if i % 2 == 0:
        Q_s_sigma = 2 * np.sqrt(2) * (beta_vec ** (3/2.)) * stats.gamma.pdf(beta_vec, c, 0, b)
        betabar = 1. / (N * np.average(beta_vec, weights=Q_s_sigma))
        print betabar
        mu = mu_
        sigma = np.sqrt(1. / N * betabar)

    # Only update Q(sigma)
    else:
        c = c_
        b = 2. / (N / (N * betabar)  + S)

    # plot Q(mu, sigma) and P(D|mu, sigma)
    ax = plt.subplot(2,8,i+1)
    ax.contour(X, Y, L.reshape(X.shape))
    ax.contour(X, Y, Q.reshape(X.shape), linestyles='dashed')
    
    if i == 0:
        ax.set_title('Initial Condition')
    elif i%2 is not 0:
        ax.set_title('Updated Q_mu')
    else:
        ax.set_title('Updated Q_sigma')
    
    ax.set_yscale('log', basey=np.e)
    ax.set_yticks(np.arange(0,1.0,0.2))
    ax.yaxis.set_major_formatter(matplotlib.ticker.ScalarFormatter())
    ax.set_ylim((0.1,2))
    ax.set_xlim((0,2))
    ax.set_xlabel('mu')
    ax.set_ylabel('sigma')
    
print('True Parameters')
print('Mean: ', mu_)
print('Sigma: ', sigma_)
print('Shape: ', c_)
print('Scale: ', b_)
print('Variational Parameters')
print('Mean: ', mu)
print('Sigma: ', sigma)
print('Shape: ', c)
print('Scale: ', b)

plt.show()
fig.savefig('variational.png')