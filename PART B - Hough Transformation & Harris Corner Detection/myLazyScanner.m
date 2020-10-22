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
fprintf("Project 2 ~ myLazyScanner.m\n");
fprintf(".\n.\n.\n");



%% Load image and convert it to gray -scale.
image_number = 2;
str = sprintf('im%d.jpg', image_number);
I = imread(str);
I = rgb2gray(I);
I = imresize(I, 0.1);
% I = imgaussfilt(I, 2);
I = double(I) / 255;
figure(); imshow(I); 
str = sprintf("Initial Image %d at 10%% scale", image_number); title(str);



%% Canny Edge Detector
img_binary = edge(I, 'Canny', [0.32 0.36]);
figure(); imshow(img_binary); title("Canny Edge Detector");



%% ========================================================================
% ======================================================== HOUGH TRANSFORM 
%--------------Parameters--------------

Drho = 1;
Dtheta = 1;
n = 10; maxDist = 20; % for im1 and im2
% n = 8;  maxDist = 1; % only for im4

%--------------------------------------

[H, L, res] = myHoughTransform (img_binary, Drho, Dtheta, n);


%% Plot Lines
figure(); imshow(I); hold on; 
str = sprintf("Image %d: Hough Lines and Crosspoints", image_number); title(str);

x = 1:1:size(I,2); % x horizontal vector of image

for i = 1:size(L,1)
    
    if (sin(L(i,2)) == 0) % Vertical Line
        
        line([L(i,1) L(i,1)], [1 size(I,1)], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1.4);
               
    else
        
        y = (L(i,1) - x * cos(L(i,2)))/sin(L(i,2)); % Line Equation
        line(x, y, 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1.4);
        
    end

end

hold off;


%--------------------------------------------------------------------------


%% Finding which lines are rectangular
crosspoints = [];
x = 1:1:size(I,2); 

for i = 1:size(L,1)
    
    for j = i+1:size(L,1)
        
        if ( abs(cos(L(i,2) - L(j,2))) < 0.1 ) % Rectangular Lines
            
            if (sin(L(i,2)) == 0) % i Vertical Line
        
                xValue = L(i,1);
                y = (L(j,1) - x * cos(L(j,2)))/sin(L(j,2));
                crosspoints = [crosspoints; xValue, y(xValue)];
                
            else 
                
                if (sin(L(j,2)) == 0) % j Vertical Line
                    
                    xValue = L(j,1);
                    y = (L(i,1) - x * cos(L(i,2)))/sin(L(i,2));
                    crosspoints = [crosspoints; xValue, y(xValue)];
                    
                else
                    
                    y1 = (L(i,1) - x * cos(L(i,2)))/sin(L(i,2));
                    y2 = (L(j,1) - x * cos(L(j,2)))/sin(L(j,2));
                    
                    [minimum, index] = min(abs(y1 - y2)); % Cross Point of 2 lines
                      
                    crosspoints = [crosspoints; x(index) y1(index)];
                    
                end
                
            end
            
        end
        
    end
    
end
                    
crosspoints = unique(crosspoints, 'rows');         
    
            

%% Filtering Crosspoints
ActualCrosspoints = [];

for i = 1:size(crosspoints, 1)
    
    x1 = crosspoints(i,1);
    y1 = crosspoints(i,2);
    flag = 0; % Binary Variable to check if two crosspoints are near each other
    
    for j = 1 : size(ActualCrosspoints, 1)
        
       x2 = ActualCrosspoints(j,1);
       y2 = ActualCrosspoints(j,2);
       
       distance = sqrt((x2 - x1)^2 + (y2 - y1)^2);
       
       if (distance <= maxDist)
           
           flag = 1;
           break;
           
       end
       
    end
    
    if (flag == 0)
        
        ActualCrosspoints = [ActualCrosspoints; x1, y1];
        
    end
    
end
        
          

%% Plotting Crosspoints
hold on;
plot(ActualCrosspoints(:,1), ActualCrosspoints(:,2), 'g*', 'MarkerSize', 16);
hold off;

% Transforming to [row, column]
ActualCorners(:,1) = ActualCrosspoints(:,2);
ActualCorners(:,2) = ActualCrosspoints(:,1);
ActualCorners = round(ActualCorners);




%% ----------------------------------------------------------- CROPPING
NumOfImages = ceil(length(ActualCorners)/4);
myImages = cell(1, NumOfImages);
SortedCorners = sortrows(ActualCorners); % Sort corners by rows
UsedCorner = zeros(size(ActualCorners,1), 1); % Vector of usage of corners
corner1 = 0; corner2 = 0; corner3 = 0; corner4 = 0;


for im = 1:NumOfImages
    %% Searching for 1st and 2nd Corner
    for c = 1:length(UsedCorner)
        
        if (UsedCorner(c) == 0) % This corner has not been detected previously
            corner1 = c;
            UsedCorner(corner1) = 1;
            break;
        end
        
    end
    
    for c = 1:length(UsedCorner)
        
        if (UsedCorner(c) == 0) % This corner has not been detected previously
            corner2 = c;
            UsedCorner(corner2) = 1;
            break;
        end
        
    end
    
    % Order two first corners by column
    if (SortedCorners(corner1, 2) > SortedCorners(corner2, 2))
        temp = corner1;
        corner1 = corner2;
        corner2 = temp;
    end
    
    
    %% Finding first edge
    x1 = SortedCorners(corner1, 2); % column
    y1 = SortedCorners(corner1, 1); % row
    x2 = SortedCorners(corner2, 2);
    y2 = SortedCorners(corner2, 1);

    myAngle = atan((y2 - y1)/(x2 - x1)); % Slope of first edge
    
    
    %% Finding second edge (with same slope)
    for i = corner2 + 1 : size(SortedCorners,1)
    
        for j = i+1 : size(SortedCorners,1)
        
            found = 0;
        
            x1 = SortedCorners(i,2);
            y1 = SortedCorners(i,1);
            x2 = SortedCorners(j,2);
            y2 = SortedCorners(j,1);

            myAngle2 = atan((y2 - y1)/(x2 - x1));
        
            if ((abs(myAngle2 - myAngle) <= 0.015) && UsedCorner(i) == 0 && UsedCorner(j) == 0)
            
                found = 1;
                corner3 = i;
                corner4 = j;
                UsedCorner(corner3) = 1;
                UsedCorner(corner4) = 1; 
                
                % Order two second corners by column
                if (SortedCorners(corner3, 2) > SortedCorners(corner4, 2))
                    temp = corner3;
                    corner3 = corner4;
                    corner4 = temp;
                end
                break;
                
            end
            
        end
        
        if (found == 1)
            break;
        end
        
    end
    
    
    
    %% Rotation of Image and Corners
    if (abs(myAngle) >= 0.02) % > 1.15 degrees
        
        rotImg = myImgRotation(I, myAngle);
        figure; imshow(rotImg);
       
        % midpoints
        midRows = floor((size(rotImg,1))/2);
        midCols = floor((size(rotImg,2))/2);
    
        for i = 1:size(SortedCorners, 1)
        
            oldx = SortedCorners(i,2) + (size(rotImg,2) - size(I,2))/2; % Adding Pad
            oldy = SortedCorners(i,1) + (size(rotImg,1) - size(I,1))/2;
        
            newx =  (oldx-midCols)*cos(myAngle) + (oldy-midRows)*sin(myAngle);
            newy = -(oldx-midCols)*sin(myAngle) + (oldy-midRows)*cos(myAngle);
            newx = floor(newx + midCols);
            newy = floor(newy + midRows);

            SortedCorners(i,2) = newx;
            SortedCorners(i,1) = newy;
        
        end    
               
        hold on;
        plot(SortedCorners(:,2), SortedCorners(:,1), 'g*', 'MarkerSize', 16);
        hold off;
        
        I = rotImg;

    end
    
    
        
    %% Cropping            
    X_top_left = SortedCorners(corner1, 2);
    Y_top_left = SortedCorners(corner1, 1);
    X_bottom_right = SortedCorners(corner4, 2);
    Y_bottom_right = SortedCorners(corner4, 1);
    
    myImages{im} = imcrop(I, [X_top_left, Y_top_left, X_bottom_right - X_top_left, Y_bottom_right - Y_top_left]);

    figure; imshow(myImages{im});
    str = sprintf('im%d_%d.jpg', image_number, im);
    saveas(gcf, str);


end


toc