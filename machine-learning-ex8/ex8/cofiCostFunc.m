function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the ;
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%

% non-vectorized implementation -- Unregulization
%{
for i=1 : num_movies
	for j=1 : num_users
		if R(i, j) == 1
			J = J + (X(i, :)*Theta(j, :)' - Y(i, j))^2;
		end
	end
end


J = 1/2 * J;


% Remember do not miswrite Theta(j, :) as Theta(j) !!!
for i=1 : num_movies
	for j=1 : num_users
		if R(i, j) == 1
			X_grad(i, :) += (X(i, :)*Theta(j, :)' - Y(i, j)) * Theta(j, :);
		end
	end
end


for j=1 : num_users
	for i=1 : num_movies
		if R(i, j) == 1
			Theta_grad(j, :) += (X(i, :)*Theta(j, :)' - Y(i, j)) * X(i, :);
		end;
	end;
end;
%}



% vectorized implementation -- Unregulization
%{
J = 1/2 * sum( sum((X*Theta'-Y).^2 .* R) ) + reg_term;



for i=1 : num_movies
	% find out which users(index) are revelant to movie i
	idx = find(R(i, :) == 1);

	% substract the relevant data of which R(i, :) == 1
	% Theta_tmp is length(idx) * n matrix, Y_tmp is 1*1 matrix 
	Theta_tmp = Theta(idx, :);
	Y_tmp = Y(i, idx);
	X_grad(i, :) = (X(i, :)*Theta_tmp' - Y_tmp) * Theta_tmp;
end

for j=1 : num_users
	idx = find(R(:, j) == 1);
	
	X_tmp = X(idx, :);
	Y_tmp = Y(idx, j);		% length(idx)*1 matrix

	% X_tmp is length(idx)*n matrix, Theta(j, :) is 1*n matrix  -->  length(idx)*1
	% 这里的 (X_tmp*Theta(j, :)' - Y_tmp) 一次性计算了所有用户 j 有评价的电影的 derivatives
 	Theta_grad(j, :) = ((X_tmp*Theta(j, :)' - Y_tmp))' * X_tmp;
 end
 %}


% vectorized implementation -- with Regularization
reg_term = lambda/2 * sum(sum(Theta.^2)) + lambda/2 * sum(sum(X.^2));
J = 1/2 * sum( sum((X*Theta'-Y).^2 .* R) ) + reg_term;

for i=1 : num_movies
	idx = find(R(i, :) == 1);
	
	Theta_tmp = Theta(idx, :);
	Y_tmp = Y(i, idx);
	X_grad(i, :) = (X(i, :)*Theta_tmp' - Y_tmp)*Theta_tmp + lambda*X(i, :);
end

for j=1 : num_users
	idx = find(R(:, j) == 1);
	
	X_tmp = X(idx, :);
	Y_tmp = Y(idx, j);
	Theta_grad(j, :) = (X_tmp*Theta(j, :)' - Y_tmp)'*X_tmp + lambda*Theta(j, :);
end







% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
