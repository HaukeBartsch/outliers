# Example for Mahalanobis distance computation

How far away (different) is a point from a given set of points? If it is far away it could be an interesting point to look at.

Assumption here is that we are talking about multi-variate normal distributions.

> [!NOTE]
> The example creates a point cloud that is already centered. Don't forget to check in a real dataset that cov centers the data.

### Regularization

To be practically useful we need to cope with singular values that are close to 0.

Approach 1: Based on the product of the machine precision and the largest singular value set every singular value to 0 that is below that product. This is kind of crude as quite suddenly singular values appear as 0 in the sequence of largest to smallest singular value.

Approach 2: Better to use a Tikhonov regularization. To compute the inverse of S we use diagonal elements in S that are $\frac{\sigma_i}{\sigma_i^2 + \alpha^2}$ where $\sigma$ are the singular values. Given some $\alpha$ (0.001?) this will slowly penalize values that are small.

> [!NOTE]
> You can see how the regularization works if you ignore $\alpha$, remove a $\sigma$ from above and below the fraction and you get one over $\sigma$.


![distance as color background with point-cloud](https://github.com/HaukeBartsch/outliers/blob/main/images/distance_overlay.png)
Fig.1: Point-cloud (red circles) from an elongated distribution with Mahalanobis distance as underlay computed at a regular grid.


## Observations

The example in the code is two dimensional but the approach natually extends to N>2 dimensions.

Numeric valued data are only one category. There are also categorical/factor level variables (is-female) and ordinal value (Likert-scale).

Many datasets are far away from being normal (Gaussian, defined by first and second order moments only), they can be skewed or have unusual kurtosis (peakedness or heavy tails). Maybe we can use a transformation of those dimensions first?

The Mahalanobis distance ignores any higher order moments (>2), it relies on correlations only. What about statistical independence? 

### How to use, related ideas

1) One idea is to rank data points. Sort datapoints using their Mahalanobis distance from largest to smallest. The hope is that points that appear early in this list are 'different' from most other points. Basically this works if the distribution is normal with most points close to 0.

> [!NOTE]
> Notice that de-correlation does not rotate our distribution? The eigenvectors will point into some usfull directions but because we just want to compute a scalar distance we ignore that information if we compute Mahalanobis.

2) Another idea is to use the Mahalanobis distance as a sensitive novelty detector. If we assume a stable distribution and successively look at new points the rate at which we get large Mahalanobis distances should be stable. If we receive larger values this might indicate that our stability assumption is no longer valid, something changed the distribution.

3) We can also generate new data that has the same first and second order moments. This is not really related to the distance computation because we just need to draw a new point from the normal distribution and transform it using SVD of the target 
distributions co-variance matrix.

4) Removing first and second order information from data is called de-correlation or 'whitening'. This technique can be used to normalize data as only higher order information remains after this process. If large differences in variances between dimensions are an issue this can set all variances to 1.