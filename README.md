# Quick example for Mahalanobis distance computation

How far is a point away from a given set of points? If its far away it could be an interesting point.

Assumption here is that we are talking about multivariate normal distributions.

### Center

The example creates a point cloud that is already centered. Don't forget to check in a real dataset that cov centers the data.

### Regularization

To be practically useful we need to add a way to cope with singular values that are close to 0 - because we want to do one over. Approach 1: Based on the product of the machine precision and the largest singular value set every singular value to 0 that is below that product. This is kind of crude as quite suddenly singular values appear as 0 in the sequence of largest to smallest singular value. Approach 2: Better to use a Tikhonov regularization in which the singular values are represented as $\frac{\sigma_i^2}{\sigma_i^2 + \alpha^2}$. Given some $\alpha$ this will slowly penalize values that are very small.

