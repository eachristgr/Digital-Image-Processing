function [H, L, res] = myHoughTransform(img_binary, Drho, Dtheta, n)

[rows, cols] = size(img_binary);

distMax = round(sqrt(rows^2 + cols^2));
step = Dtheta*(2*pi)/180;
theta = 0 : step : 2*pi - step;
rho = 0 : Drho : distMax;
 
H = zeros(length(rho), length(theta));
 
%% Scan binary image to find lines
for i = 1:rows
    
     for j = 1:cols
         
         if img_binary(i,j) ~= 0
             
             for iTheta = 1:length(theta)
                        
                 dist = j*cos(theta(iTheta)) + i*sin(theta(iTheta));
                 
                 for iRho = 1:length(rho)-1
                    
                    if ( dist >= rho(iRho) && dist < rho(iRho + 1) )
                        
                        H(iRho, iTheta) = H(iRho, iTheta) + 1;
                        break;
                        
                    end
                    
                 end
                 
             end
             
         end
         
     end
     
end


%% Creating a copy of Hough Table
H_copy = H;
L = zeros(n,2);
    
k = 1;

while (k <= n)
    
    maxH_copy = max(H_copy(:));
    sameLine = 0;
    
    for i = 1:size(H_copy, 1)
        
        for j = 1:size(H_copy, 2)
            
            if (H_copy(i,j) == maxH_copy)
                
                for x = 1: k-1
                    
                    if ((abs(rho(i) - L(x,1)) <= 4) && (abs(theta(j) - L(x,2)) <= 2))
                        
                        sameLine = 1;
                        H_copy(i,j) = -1;
                        break;
                        
                    end
                    
                end
                
                if (sameLine == 0)
                    
                    L(k,1) = rho(i);
                    L(k,2) = theta(j);
                    H_copy(i,j) = -1; % So this element is only founded once. 
                    k = k + 1;
                    
                end
                
            end
            
        end
        
    end
    
end



%% Plot Hough Table
figure;
imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
colormap(gca,hot);
axis on, axis normal, hold on;
plot(L(:,2),L(:,1),'s','color','white');
hold off; title('Hough Table');



%% Delete frame edges
myNewL = [];

for i = 1:length(L)

    if L(i,1) > 2
        
        myNewL = [myNewL; L(i,1) L(i,2)];
        
    end

end

L = myNewL;



%% Create Line Table with ones if a line cross this pixel
LinesTable = zeros(size(img_binary)); % Table to put 1, if a line is crossing this pixel. 
x = 1:1:size(img_binary,2); % x horizontal vector of image

for i = 1:size(L,1)
    
    if (sin(L(i,2)) == 0) % Vertical Line
        
        for k = 1:size(img_binary,1)
            
            LinesTable(k, L(i,1)) = LinesTable(k, L(i,1)) + 1;
            
        end
        
    else
        
        y = (L(i,1) - x * cos(L(i,2)))/sin(L(i,2)); % Line Equation

        for k = 1:size(img_binary,2)
            
            if (y(k) >= 1 && y(k) <= size(img_binary,1))
            
                LinesTable(round(y(k)), x(k)) =  LinesTable(round(y(k)), x(k)) + 1;
                
            end
            
        end
        
    end

end

res = 0;

for i = 1:size(LinesTable,1)
    
    for j = 1:size(LinesTable,2)
        
        if (LinesTable(i,j) == 0)
            
            res = res + 1;
            
        end
        
    end
    
end


end

