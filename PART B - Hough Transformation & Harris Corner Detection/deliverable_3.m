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
fprintf("Project 2 ~ deliverable_3.m\n");
fprintf(".\n.\n.\n");



%% Load image, and convert it to gray -scale.
I = imread('im2.jpg');
% I = rgb2gray(I);
I = imresize(I, 0.1);
I = double(I) / 255;
figure(); imshow(I); title("Initial Image at 10%");



%% Rotate Image 
angle1 = 54 * pi / 180;
RotatedImage1 = myImgRotation(I, angle1);
figure; imshow(RotatedImage1);
str = sprintf("Rotated Image at %d degrees after bilinear interpolation", angle1 * 180 / pi); title(str);


angle2 = 213 * pi / 180;
RotatedImage2 = myImgRotation(I, angle2);
figure; imshow(RotatedImage2);
str = sprintf("Rotated Image at %d degrees after bilinear interpolation", angle2 * 180 / pi); title(str);

toc