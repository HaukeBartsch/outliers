# Mahalanobis distance computation

How far away (different) is a point from a given set of points? If it is far away it could be an interesting point to look at.

The provided Octave/Matlab script [mahalanobis.m](https://github.com/HaukeBartsch/outliers/blob/main/mahalanobis.m) demonstrates the process of computing the Mahalanobis distance in 2d.

Assumption here is that we are talking about multi-variate normal distributions.

### Regularization

To be practically useful we need a way to cope with singular values that are close to 0. Inverting such values can otherwise introduce a large dependency of the results on noise (division by small values).

Approach 1: Based on the product of the machine precision and the largest singular value set every singular value to 0 that is below that product. This is kind of crude as quite suddenly singular values appear as 0 in the sequence of largest to smallest singular value. Noise on the other hand can be assumed to affect all singular values. Above our threshold we accept the noise and below the threshold we ignore all remaining information.

Approach 2: Better to use a Tikhonov regularization. To compute the inverse of S we use diagonal elements in S that are $\frac{\sigma_i}{\sigma_i^2 + \alpha^2}$ where $\sigma$ are the singular values. Given some $\alpha$ (0.001?) this will slowly penalize values that are small.

> [!NOTE]
> You can see how the regularization works if you ignore $\alpha$, remove a $\sigma$ from above and below the fraction and you get one over $\sigma$.


![distance as color background with point-cloud](https://github.com/HaukeBartsch/outliers/blob/main/images/distance_overlay.png)
Fig.1: Point-cloud (red circles) from an elongated distribution with Mahalanobis distance as underlay computed at a regular grid.


## Observations

The example in the code is two dimensional. But the approach naturally extends to N>2 dimensions.

Not all data is numerical. There are also categorical/factor level variables (e.g. is-female) and ordinal valued data (e.g. Likert-scales).

Many datasets are far away from being normal (or Gaussian, or defined by first and second order moments only). Data can be skewed or have unusual kurtosis (peakedness or heavy tails). Transform those first?

The Mahalanobis distance ignores any higher order moments (>2), it relies on second-order correlations only. What about statistical independence?

What about a large number of dimension and few datapoints? Computation of a variance-covariance matrix requires at least 2 data points with values in all dimensions. What if there are missing values? Most variance/covariance matrix computations will remove the whole datapoint if even one of the dimension is unknown. Remove the dimension or have a look at imputation.

### How to use and related ideas

1) One idea is to rank data points. Sort datapoints using their Mahalanobis distance from largest to smallest. The hope is that points that appear early in this list are 'different' from most other points. Basically this works if the distribution is normal with most points close to 0.

> [!NOTE]
> Notice that de-correlation does not rotate our distribution? The eigenvectors will point into some usfull directions but because we just want to compute a scalar distance we ignore that information if we compute Mahalanobis.

2) Another idea is to use the Mahalanobis distance as a sensitive novelty detector (turbulence index). If we assume a stable distribution and successively look at new points the rate at which we get large Mahalanobis distances should be stable. If we receive larger values this might indicate that our stability assumption is no longer valid, something changed the distribution.

3) We can also generate new data that has the same first and second order moments. This is not really related to the distance computation because we just need to draw a new point from the normal distribution and transform it using SVD of the target 
distributions co-variance matrix.

4) Removing first and second order information from data is called de-correlation or 'whitening'. This technique can be used to normalize data as only higher order information remains after this process. If large differences in variances between dimensions are an issue this can set all variances to 1.

5) In statistics (e.g. linear regression) the Mahalanobis distance of a point defines its 'leverage', its ability to change the slope of the regression line. You can make a regression line more resistent to outliers if you use the leverage values to weight points. Large leverage should have a lower influence on slope etc.
