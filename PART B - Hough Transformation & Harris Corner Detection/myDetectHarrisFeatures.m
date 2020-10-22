function corners = myDetectHarrisFeatures(I)

%--------------------------
k = 0.06;
threshold = 1;
sigma = 1;
window = sigma * 1;
%--------------------------


%% Creating gaussian 3x3 filter.
[x_grid, y_grid] = meshgrid(-window:window, -window:window);
w = exp(-(x_grid.^2 + y_grid.^2)/(2*sigma^2));


%% Sobel Gradient filters.
horizontal_filter = [1 0 -1; 2 0 -2; 1 0 -1];
vertical_filter = [1 2 1; 0 0 0 ; -1 -2 -1];

% Horizontal and vertical derivatives
Ix = imfilter(I, horizontal_filter, 'conv');
Iy = imfilter(I, vertical_filter, 'conv');


%% Compute the components of matrix M = w * A.
M11 = imfilter(Ix.^2,  w, 'conv');
M22 = imfilter(Iy.^2,  w, 'conv');
M12 = imfilter(Ix.*Iy, w, 'conv');


%% Compute a angle metric matrix for each pixel
angleMetric = zeros(size(I));

for x = 3:size(I,1)-2
    
   for y = 3:size(I,2)-2

       %% Define at each pixel(x,y) the matrix M
       M = [M11(x,y) M12(x,y); M12(x,y) M22(x,y)];
       
       %% Compute the R metric at each pixel
       R = det(M) - k*(trace(M)^2);

       if (R > threshold)
           
          angleMetric(x,y) = R; 
          
       end
       
   end
   
end



%% Filering corners.
window = 4;
filteredCorners = zeros(size(angleMetric));

for x = 1:size(angleMetric, 1)
    
    for y = 1:size(angleMetric, 2)
        
        if (angleMetric(x,y))
            
            flag = 0;
           
            for i = -window:window
                
                for j = -window:window
                    
                    if ((x + i >= 1) && (x + i <= size(angleMetric,1)) && (y + j >= 1) && (y + j <= size(angleMetric,2)))
                        
                        if (filteredCorners(x + i, y + j) > 0)
                           
                            flag = 1;
                            break;
                            
                        end
                        
                    end
                       
                end
                
            end
            
            if (flag == 0)
           
                filteredCorners(x,y) = angleMetric(x,y);
            
            end
            
        end
        
    end
    
end
        

[corners_row, corners_col] = find(filteredCorners);
corners = [corners_col, corners_row];

end
