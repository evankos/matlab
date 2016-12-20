from __future__ import division


# from matlab_local import engine_context
import scipy.stats as stats
import numpy as np
import matplotlib.pyplot as plt

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

        mu_sigma_data = np.sqrt(1/(data.size * mean_beta))
        S = np.std(data)**2 * data.size

        b_prime=0.5*(data.size * mu_sigma_data**2 + S)
        c_prime=data.size/2
        return stats.invgamma(a=b_prime,scale=c_prime)


    # True mean and sigma
    m=1
    s=1

    # Starting mean and sigma
    m_s=3
    s_s=.1
    a_s=6
    b_s=10

    # Sample 5 datapoints from the true distribution, we asume thats all we have.
    data = stats.norm(m,s).rvs(5)

    # Code to Plot the results and the Distributions.
    thetas1 = np.linspace(0, 4, 101)
    thetas2 = np.linspace(0, 4, 101)
    X, Y = np.meshgrid(thetas1, thetas2)

    # conjugate prior for a standard deviation sigma and mu
    data_mean = np.mean(data)
    data_var = np.std(data)
    alpha_inv_gamma = data.size /2
    beta_inv_gamma = np.std(data)**2 * data.size /2
    # Inverse Gamma for sigma
    Q_s_true = stats.invgamma(a=alpha_inv_gamma,scale=beta_inv_gamma)
    # Normal for mu
    Q_m_true = stats.norm(data_mean,data_var/data.size)
    posterior = Q_s_true.pdf(Y) * Q_m_true.pdf(X)

    # Drawing starting state
    startQ_s=stats.invgamma(a=a_s,scale=b_s)
    startQ_m=stats.norm(m_s,s_s)
    prior = startQ_m.pdf(X)*startQ_s.pdf(Y)

    # displaying first aproximation
    fig, ax = plt.subplots(4, 2, sharex='col', sharey='row')
    ax[0][0].contour(X, Y, posterior, colors='k', ylabel='sigma',xlabel='mean')
    ax[0][0].contour(X, Y, prior, colors='k', linestyles='dashed')
    ax[0][0].set_title('A conjugate prior')

    # Setting Starting Q_s and starting updates
    Q_s = startQ_s
    cnt=0
    for j in range(4):
        for i in range(2):
            if j==0 and i== 0:
                continue
            if i==1:
                # Updating Q_m from 33.41
                Q_m = updateQ_m(data, Q_s)
                prior = Q_m.pdf(X)*Q_s.pdf(Y)
                ax[j][i].contour(X, Y, prior, colors='k', linestyles='dashed') #negative contours are dashed
                ax[j][i].contour(X, Y, posterior, colors='k')
                ax[j][i].set_title('%d) updated mean'%cnt)
                cnt+=1
            else:
                # Updating Q_s from 33.44
                Q_s = updateQ_s(data, Q_m, Q_s)
                prior = Q_m.pdf(X)*Q_s.pdf(Y)
                ax[j][i].contour(X, Y, prior, colors='k', linestyles='dashed') #negative contours are dashed
                ax[j][i].contour(X, Y, posterior, colors='k')
                ax[j][i].set_title('%d) updated sigma'%cnt)
                cnt+=1

    plt.show()

if __name__ == "__main__":
    img33_4()
