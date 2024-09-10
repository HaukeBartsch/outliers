#
# The following code has been tested on Octave.
#

# create x and y as iid normal 2D distribution
x = randn (1000, 1);
y = randn (1000, 1);
# We believe the above and do not plot - but we could.
# scatter (xt, yt);

# An example random covariance matrix A (symmetric, positive definite).
A = randn(2,2); A = A'*A; A = (A + A')/2;

# Distort our centered normal distribution using A
t = A*[x, y]';
xt = t(1,:)';
yt = t(2,:)';
# and plot the result:
scatter (xt, yt);
# The plot often reverts to a single long line with some random orientation. Do this
# a couple of times and you will end up with one that is a wider elipsoid.

# Compute the covariance matrix of this 2d distribution.
C = cov(xt, yt);

# Now we can use a new 2d-point np and compute the Mahalanobis distance to our distribution.
np = [0,10];

#
# Use SVD to compute singular value decomposition of the variance-covariance matrix.
[U, S, V] = svd(C);
# Now C equals U*S*V'.
# Replace the sigular values with their inverses, using Tikhonov regularization
# Instead of Sn = diag(1./diag(S)) use regularization:
Sn = diag( diag(S) ./ (diag(S).^2 + 0.001^2) )

# Reconstitute a C using the changed/inverted singular values. Applying this Ct matrix to a datapoint
# will change the datapoint, large values are getting smaller and small values are getting larger. 
# This does not rotate our distribution but makes the two axes/dimensions have the same variance - we 
# de-correlate the data in [xt; yt].
Ct = U*Sn*V';
# Compute the Mahalanobis distance mdist of np to C using a quadratic form.
mdist = np * Ct * np'
# The above "quadratic form" transforms np by Ct, decorrelating it, np is moved to undo the 
# distortion caused by the correlation of the data. We compute a sum of squares as a distance 
# to the origin in that decorrelated space. 'mdist' is now a scalar distance value associated 
# with np. Large mdist means a large Mahalanobis distance of np to the center of the distribution
# (first order) and based on the variances (second order moments).

#
# Here an example. A nice $A$ could be:
#
A = [ 2.4612, 1.3870; 1.3870, 1.2047];
# The point cloud looks like this:
t = A*[x, y]';
xt = t(1,:)';
yt = t(2,:)';
scatter (xt, yt);
# and has a variance/covariance matrix:
C = cov(xt, yt);
# The Mahalanobis computation using Tikhonov regularization:
[U, S, V] = svd(C);
Sn = diag( (diag(S) ./ (diag(S).^2 + 0.001^2)) );
Ct = U*Sn*V';

# And compute one scalar distance $d$ to point [5,2] (close to the distribution)
np = [5,2];
d = np * Ct * np'
# And now a point [-5,2] (farther away from the distribution)
np = [-5,2];
d = np * Ct * np'

#
# Distance map to verify what we are doing.
#
[mx,my] = meshgrid(-10:1:10, -10:1:10);
m = zeros(size(mx,1),size(mx,2))
for i=1:size(mx,1)
    for j=1:size(mx,2)
        np = [mx(i,j); my(i,j)]';
        m(i,j) = np * Ct * np';
    end
end
pcolor (mx, my, m); colorbar; colormap(gray);
hold on;
scatter (xt, yt);
# In this image large values are farther away from the distribution.
