% Dimitrios - Marios Exarchou 8805
% Digital Image Processing
% Project 2
% May 2020



%% Clearing.
clear all;
close all;
clc;
tic



%% Starting.
fprintf("Digital Image Processing\n");
fprintf("Exarchou Dimitrios-Marios 8805\n");
fprintf("Project 2 ~ deliverable_1.m\n");
fprintf(".\n.\n.\n");



%% Load image, and convert it to gray -scale.
I = imread('im2.jpg');
I = rgb2gray(I);
I = imresize(I, 0.1);
I = double(I) / 255;
figure(); imshow(I); title('Initial Grayscale Image at 10%');



%% Canny Edge Detector
img_binary = edge(I, 'Canny', [0.32 0.35]);
figure(); imshow(img_binary); title('Binary Image after Canny Edge Detector');



%% ========================================================================
% ========================================================= Hough Transform 
%--------------Parameters---

Drho = 1;
Dtheta = 1;
n = 9;

%----------------------------

[H, L, res] = myHoughTransform (img_binary, Drho, Dtheta, n);


%% Plot Lines
figure(); imshow(I); hold on;
 
x = 1:1:size(I,2); % x horizontal vector of image

for i = 1:size(L,1)
    
    if (sin(L(i,2)) == 0) % Vertical Line
        
        line([L(i,1) L(i,1)], [1 size(I,1)], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1.4);
               
    else
        
        y = (L(i,1) - x * cos(L(i,2)))/sin(L(i,2)); % Line Equation
        line(x, y, 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1.4);
        
    end

end

hold off; title('Hough Lines');


toc
