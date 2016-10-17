from __future__ import division


from matlab_local import engine_context
import scipy.stats as stats
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(2016)


@engine_context
def test_engine(ctx):
    # ctx.matlab_engine.desktop(nargout=0)
    print ctx.matlab_engine.sqrt(4.)
    print ctx.matlab_engine.linspace(0.,1.,100.)

def ex29_13():
    sigma_p = 1
    P = stats.norm(loc=0,scale=sigma_p)
    Z_true = P.cdf(10)
    plot_x = np.linspace(.1,1.6,100)
    plot_y_1 = []
    plot_y_2 = []

    plot_y_1_1 = []
    plot_y_2_1 = []

    plot_y_1_2 = []
    plot_y_2_2 = []
    plot_y_3_2 = []

    for sigma_q in plot_x:
        Q = stats.norm(loc=0,scale=sigma_q)
        x = Q.rvs(1000)
        plot_y_3_2.append(P.pdf(x)/Q.pdf(x))
        for n in [1000,10000,100000]:
            x = Q.rvs(n)
            Weights = P.pdf(x)/Q.pdf(x)
            W_mean = np.mean(Weights)
            W_var = np.std(Weights)
            if n == 1000:
                plot_y_1.append(W_mean)
                plot_y_2.append(W_var)

            if n == 10000:
                plot_y_1_1.append(W_mean)
                plot_y_2_1.append(W_var)

            if n == 100000:
                plot_y_1_2.append(W_mean)
                plot_y_2_2.append(W_var)



    f, axarr = plt.subplots(3, sharex=True)
    axarr[0].plot(plot_x, np.array(plot_y_1),'k:',label='1K')
    axarr[0].plot(plot_x, np.array(plot_y_1_1),'k--',label='10K')
    axarr[0].plot(plot_x, np.array(plot_y_1_2),'k',label='100K')
    axarr[0].set_title('Estimated Normalizing Constant')
    axarr[0].legend(loc='upper right', shadow=False)
    axarr[1].plot(plot_x, np.array(plot_y_2),'k:',label='1K')
    axarr[1].plot(plot_x, np.array(plot_y_2_1),'k--',label='10K')
    axarr[1].plot(plot_x, np.array(plot_y_2_2),'k',label='100K')
    axarr[1].set_title('Empirical Standard Deviation')
    axarr[1].legend(loc='upper right', shadow=False)

    plot_y_3_2 = np.array(plot_y_3_2)
    plot_y_3_2 = np.split(plot_y_3_2,100)
    final_x = np.linspace(.1,1.6,1000)
    for i in range(30):
        axarr[2].plot(final_x, plot_y_3_2[i].reshape((1000,)))
        axarr[2].set_title('30 weights??')
    plt.show()

def ex29_15():
    sigma_p = 1
    mean_p = 0
    P = stats.norm(loc=mean_p,scale=sigma_p)
    x = [1, 2]
    mean_samples = [1]
    sigma_samples = [3]
    for iteration in range(5):
        mean_prior = stats.norm(loc=np.mean(),scale=x[1])
        new_mean = mean_prior.rvs(1)[0]
        x[0] = new_mean
        sigma_prior = stats.gamma(len(samples),scale=x[1]**2)
        new_sigma = sigma_prior.rvs(1)[0]
        x[1] = new_sigma
        samples.append(x)
        print x
    print np.array(samples)[:,1]



if __name__=="__main__":
    # ex29_13()
    ex29_15()
