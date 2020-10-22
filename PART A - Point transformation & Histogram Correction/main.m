% Dimitrios - Marios Exarchou 8805
% Digital Image Processing
% Project 1
% May 2020



%% Clearing.
clear all;
close all;
clc;
tic



%% Starting.
fprintf("Digital Image Processing\n");
fprintf("Exarchou Dimitrios-Marios 8805\n");
fprintf("Project 1\n");
fprintf(".\n.\n.\n");



%% Load image, and convert it to gray -scale.
input = imread('lena.bmp');
input = rgb2gray(input);
input = double(input) / 255;
% Show the histogram of intensity values
[hn, hx] = hist(input(:), 0:1/255:1);

% Plotting initial image.
figure();
subplot(2,1,1)
imshow(input)
title('Image')
subplot(2,1,2)
bar(hx , hn)
title('Histogram')
suptitle('Initial Image')
saveas(gcf,'fig1.png')



%% Question 1

%% Case 1
x1 = 0.1961;
x2 = 0.8039;
y1 = 0.0392;
y2 = 0.9608;

output = pointtransform(input, x1, y1, x2, y2);
[hn , hx] = hist(output(:), 0:1/255:1);

figure();
subplot(2,1,1)
imshow(output)
title('Image after Point Transformation')
subplot(2,1,2)
bar(hx, hn)
title('Histogram after Point Transformation')
suptitle('Point Transformation 1')
saveas(gcf,'fig2.png')


%% Case 2
x1 = 0.5;
x2 = 0.5;
y1 = 0;
y2 = 1;

output = pointtransform(input, x1, y1, x2, y2);
[hn , hx] = hist(output(:), 0:1/255:1);

figure();
subplot(2,1,1)
imshow(output)
title('Image after Point Transformation')
subplot(2,1,2)
bar(hx, hn)
title('Histogram after Point Transformation')
suptitle('Point Transformation 2')
saveas(gcf,'fig3.png')



%% Question 2.1

%% Case 1
L = 10;
v = linspace (0, 1, L);
h = ones([1, L]) / L;

output = histtransform(input, h, v);
[hn, hx] = hist(output(:), v);

% Plots
figure();
subplot(2,1,1)
imshow(output)
title('Image after Histogram Transformation')
subplot(2,1,2)
bar(hx, hn, 0.2)
title('Histogram after Histogram Transformation')
suptitle('Histogram Transformation 1')
saveas(gcf,'fig4.png')


%% Case 2
L = 20;
v = linspace (0, 1, L);
h = ones([1, L]) / L;

output = histtransform(input, h, v);
[hn, hx] = hist(output(:), v);

% Plots
figure();
subplot(2,1,1)
imshow(output)
title('Image after Histogram Transformation')
subplot(2,1,2)
bar(hx, hn, 0.2)
title('Histogram after Histogram Transformation')
suptitle('Histogram Transformation 2')
saveas(gcf,'fig5.png')


%% Case 3
L = 10;
v = linspace (0, 1, L);
h = normpdf(v, 0.5) / sum(normpdf(v, 0.5));

output = histtransform(input, h, v);
[hn, hx] = hist(output(:), v);

% Plots
figure();
subplot(2,1,1)
imshow(output)
title('Image after Histogram Transformation')
subplot(2,1,2)
bar(hx, hn, 0.2)
title('Histogram after Histogram Transformation')
suptitle('Histogram Transformation 3')
saveas(gcf,'fig6.png')



%% Question 2.2-2.3
L = 21;
d = linspace(0, 1, L);
v = zeros(1, length(d)-1);

for i = 1:length(d)-1
    
    v(i) = (d(i) + d(i+1))/2;
    
end
    

%% Case 1
fun1 = @(x)unifpdf(x, 0, 1);
h1 = pdf2hist(d, fun1);

output = histtransform(input, h1, v);
[hn, hx] = hist(output(:), v);
Error1 = sqrt(sum((h1-(hn/sum(hn))).^2));

% Plots
figure();
subplot(2,1,1)
imshow(output)
title('Image after Histogram Transformation')
subplot(2,1,2)
bar(hx, hn, 0.2)
title('Histogram after Histogram Transformation')
suptitle('Uniform Distribution ~ [0,1]');
saveas(gcf,'fig7.png')


%% Case 2
fun2 = @(x)unifpdf(x, 0, 2);
h2 = pdf2hist(d, fun2);

output = histtransform(input, h2, v);
[hn, hx] = hist(output(:), v);
Error2 = sqrt(sum((h2-(hn/sum(hn))).^2));

% Plots
figure();
subplot(2,1,1)
imshow(output)
title('Image after Histogram Transformation')
subplot(2,1,2)
bar(hx, hn, 0.2)
title('Histogram after Histogram Transformation')
suptitle('Uniform Distribution ~ [0,2]');
saveas(gcf,'fig8.png')


%% Case 3
fun3 = @(x)normpdf(x, 0.5, 0.1);
h3 = pdf2hist(d, fun3);

output = histtransform(input, h3, v);
[hn, hx] = hist(output(:), v);
Error3 = sqrt(sum((h3-(hn/sum(hn))).^2));

% Plots
figure();
subplot(2,1,1)
imshow(output)
title('Image after Histogram Transformation')
subplot(2,1,2)
bar(hx, hn, 0.2)
title('Histogram after Histogram Transformation')
suptitle('Normal Distribution ~ [0.5,0.1]');
saveas(gcf,'fig9.png')


toc
