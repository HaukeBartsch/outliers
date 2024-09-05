# The following code has been tested on Octave.

# x and y as iid normal 2D distribution
x = randn (1000, 1);
y = randn (1000, 1);
# scatter (xt, yt);

# an example random covariance matrix (symmetric, positive definite)
A = randn(2,2); A = A'*A; A = (A + A')/2;

# distort our centered normal distribution using A
t = A*[x, y]';
xt = t(1,:)';
yt = t(2,:)';
# and plot the result
scatter (xt, yt);
# compute its covariance matrix
C = cov(xt, yt);

# Now we can use a new point np and compute the Mahalanobis distance to our distribution
np = [0,10];

#
# Use SVD to compute singular values of the variance-covariance matrix
#
[U, S, V] = svd(C);
# Now C equals U*S*V'
# Replace the sigular values with their inverses. Attention, use Tikhonov regularization here!
Sn = diag(1./diag(S))
Ct = U*Sn*V';
# Ct represents the 'space-distortion' of our distribution of points.
# Compute the Mahalanobis distance mdist of np to C using a quadratic form.
mdist = np * Ct * np'

# Here an example. A could be:
A = [ 2.4612, 1.3870; 1.3870, 1.2047];
# The point cloud would look like this:
t = A*[x, y]';
xt = t(1,:)';
yt = t(2,:)';
scatter (xt, yt);
# and have a covariance matrix:
C = cov(xt, yt);
# The Mahalanobis computation again:
[U, S, V] = svd(C);
Sn = diag(1./diag(S))
Ct = U*Sn*V';

# And compute one scalar distance to point [5,2] (close to the distribution)
np = [5,2];
d = np * Ct * np'
# And now a point [-5,2] (farther away from the distribution)
np = [-5,2];
d = np * Ct * np'

