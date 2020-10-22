function Y = histtransform(X, h, v)
% HISTTRANSFORM is a function to calculate an output image Y
% given an input image X and the values of a desired histogram.
% Specifically it crates an output image by categorizing the pixels
% of the initial image to classes with specific frequencies and centers.
% The process is described of finding at each repeat the minimum pixel
% of the initial image, categorizing it to current class and then
% increasing its value, so it can never again be found as minimum.

    
totalPixels = size(X,1)*size(X,2);
Y = zeros(size(X,1), size(X,2));
    
for i = 1:length(h)
    
	pixels = 0;
    
	while(pixels/totalPixels <= h(i))
                 
        minX = min(X(:));
        [row, col] = find(X == minX); % Vectors to save every min value indices.
            
        if (minX == 1.1) 
            break;
        end
        
        for k = 1:length(row)
            
            Y(row(k), col(k)) = v(i);
            X(row(k), col(k)) = 1.1; % Original values are increased to 1.1, so next minimum can be founded in the next loop.
        
        end
        
        pixels = pixels + length(row);
            
	end
                 
end

end
