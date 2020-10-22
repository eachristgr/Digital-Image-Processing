function h = pdf2hist(d, f)
% PDF2HIST is a function to calculate the frequencies h of an histogram, 
% given a probability distribution and the desired linear spaces d. After
% frequencies are founded, we normalizing them by dividing with ther sum.

h = zeros(1, length(d)-1);

for i = 1:length(d)-1
        
    % h(i) = integral(f, d(i), d(i+1));
    % Simpson's rule
    a = d(i);
    b = d(i+1);
    c = (b-a)/2;
    h(i) = (c/3)*(f(a) + 4*f((a+b)/2) + f(b));
        
end
    
total = sum(h(:));
     
h = h / total;

end
