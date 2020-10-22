function rotImg = myImgRotation(img, angle)

% image padding
rows = size(img,1);
cols = size(img,2);

diagonal = sqrt(rows^2 + cols^2); 
RowPad = ceil(diagonal - rows);
ColPad = ceil(diagonal - cols);
imagepad = zeros(rows+RowPad, cols+ColPad, size(img,3));
imagepad(ceil(RowPad/2):(ceil(RowPad/2)+rows-1), ceil(ColPad/2):(ceil(ColPad/2)+cols-1), :) = img;

% midpoints
midRows = floor((size(imagepad,1))/2);
midCols = floor((size(imagepad,2))/2);

% rotated image
imagerot = (zeros(size(imagepad))); % midx and midy same for both

for i = 1:size(imagerot,1)
    
    for j = 1:size(imagerot,2)
        
        x = (j-midCols)*cos(angle) - (i-midRows)*sin(angle);
        y = (j-midCols)*sin(angle) + (i-midRows)*cos(angle);
        x = floor(x + midCols);
        y = floor(y + midRows);
         
        if (y >= 2 && x >= 2 && y <= size(imagepad,2)-1 && x <= size(imagepad,1)-1)
            
            % Without bilinear interpolation 
            % imagerot(i,j,:) = imagepad(x,y,:); % k degrees rotated image  
            
            % With bilinear interpolation
            imagerot(i,j,:) = (imagepad(y-1,x,:) + imagepad(y+1,x,:) + imagepad(y,x-1,:) + imagepad(y,x+1,:))/4;

        end

    end
    
end

rotImg = imagerot;
 
end
