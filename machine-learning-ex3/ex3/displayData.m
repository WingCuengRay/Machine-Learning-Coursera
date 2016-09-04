function [h, display_array] = displayData(X, example_width)
%DISPLAYDATA Display 2D data in a nice grid
%   [h, display_array] = DISPLAYDATA(X, example_width) displays 2D data
%   stored in X in a nice grid. It returns the figure handle h and the
%   displayed array if requested.


% 假设传入的 X 为 100*400
% example_width 默认为 sqrt(400) = 20   每个数字宽的像素值
% m = 100, n = 400
% example_height = 400/20 = 20      每个数字高的像素值
% display_rows = floor(sqrt(100)) = 10
% display_cols = ceil(400/10) = 40

% display_array = -ones(1 + 10*(20+1), 1+(40*(20+1)))

% Set example_width automatically if not passed in
if ~exist('example_width', 'var') || isempty(example_width)
	% round() :返回最近的整数
	% example_width 的默认长度为 sqrt(n)，其中 n 为训练数据的个数(X的列数)
	example_width = round(sqrt(size(X, 2)));
end

% Gray Image
% 设为灰度图像
colormap(gray);

% Compute rows, cols
[m n] = size(X);
example_height = (n / example_width);

% Compute number of items to display
display_rows = floor(sqrt(m));			% 向下取整
display_cols = ceil(m / display_rows);	% 向上取整

% Between images padding
pad = 1;

% Setup blank display
% 生成整幅图的像素矩阵
display_array = - ones(pad + display_rows * (example_height + pad), ...
                       pad + display_cols * (example_width + pad));

% Copy each example into a patch on the display array
curr_ex = 1;
for j = 1:display_rows
	for i = 1:display_cols
		if curr_ex > m,
			break;
		end
		% Copy the patch

		% Get the max value of the patch
		max_val = max(abs(X(curr_ex, :)));
		display_array(pad + (j - 1) * (example_height + pad) + (1:example_height), ...
		              pad + (i - 1) * (example_width + pad) + (1:example_width)) = ...
						reshape(X(curr_ex, :), example_height, example_width) / max_val;
		curr_ex = curr_ex + 1;
	end
	if curr_ex > m,
		break;
	end
end

% Display Image
h = imagesc(display_array, [-1 1]);

% Do not show axis
axis image off

drawnow;

end
