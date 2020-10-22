function Y = pointtransform(X, x1, y1, x2, y2)
% POINTTRANSFORM is a function to calculate an output image Y
% given an input image X and a linear transformation function,
% declared of branching constants x1, x2, y1, y2.

Y = zeros(size(X,1), size(X,2));

for i = 1:size(X,1)
    
    for j = 1:size(X,2)
        
        if (X(i,j) <= x1)
            
            a = y1/x1;
            Y(i,j) = a*X(i,j);
            
        elseif (X(i,j)<= x2)
            
            b = (y2 - y1)/(x2 - x1);
            Y(i,j) = b*(X(i,j) - x1) + y1;
            
        else
            
            c = (1 - y2)/(1 - x2);
            Y(i,j) = c*(X(i,j) - x2) + y2;
            
        end
        
    end
    
end

end
