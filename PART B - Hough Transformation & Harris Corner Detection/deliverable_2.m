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
fprintf("Project 2 ~ deliverable_2.m\n");
fprintf(".\n.\n.\n");



%% Load image, and convert it to gray -scale.
I = imread('im2.jpg');
I = rgb2gray(I);
I = imresize(I, 0.1);
I = double(I) / 255;
figure(); imshow(I); title('Initial Grayscale Image at 10%');



%% ========================================================================
% ================================================= Harris Corner Detection 
myCorners = myDetectHarrisFeatures(I);

figure, subplot(1,2,1); imshow(I); hold on;

d = 5;
for i = 1:size(myCorners,1)
    
    x = myCorners(i,1) - d/2;
    y = myCorners(i,2) - d/2;
    pos = [x y d d];
    rectangle('Position', pos, 'EdgeColor', 'r', 'LineWidth', 1)
    
end

hold off; title("My Harris Corner Detection");

% ---------------------------------------------- MATLAB Library
corners = detectHarrisFeatures(I);

subplot(1,2,2); imshow(I); hold on;

for i = 1:size(corners,1)
    
    x = corners.Location(i,1) - d/2;
    y = corners.Location(i,2) - d/2;
    pos = [x y d d];
    rectangle('Position', pos, 'EdgeColor', 'r', 'LineWidth', 1)
    
end

hold off; title("MATLAB Corner Detection");


toc 
