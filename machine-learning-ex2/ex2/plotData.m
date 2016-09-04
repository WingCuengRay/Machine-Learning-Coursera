function plotData(X, y)
%PLOTDATA Plots the data points X and y into a new figure
%   PLOTDATA(x,y) plots the data points with + for the positive examples
%   and o for the negative examples. X is assumed to be a Mx2 matrix.

% Create New Figure
figure; hold on;

% ====================== YOUR CODE HERE ======================
% Instructions: Plot the positive and negative examples on a
%               2D plot, using the option 'k+' for the positive
%               examples and 'ko' for the negative examples.
%
pos = find(y == 1);
nega = find(y == 0);

% plot 的前面两个参数分别是绘制的 x,y 坐标的点集
% 第三个参数及之后的都是 FMT ,即格式选项
% 'k+' 代表用 黑色+ 符号表示点， 'ko'代表用 黑色o 标记点
% LineWidth 是线宽，MarkerSize 是标记大小，MarkerFaceColor 是o的填充
plot(X(pos, 1), X(pos, 2), 'k+', 'LineWidth', 2, 'MarkerSize', 7);
plot(X(nega, 1), X(nega, 2), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7);








% =========================================================================



hold off;

end
