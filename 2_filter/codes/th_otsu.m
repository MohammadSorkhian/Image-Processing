function [img_final] = th_otsu(img)
% This func calculates threshold based on Otsu's method and generate
% a binary image
 Hist_arr = zeros(1,256);                 % Creat Histogram array
 [h, w] = size(img);                      % Read image width and height
for i = 1:h                               % Fill the Histogram array
    for j = 1:w
        Hist_arr(1, img(i, j)+ 1) = Hist_arr(1, img(i, j)+ 1) + 1 ;
    end
end

Hist_arr_pdf = Hist_arr / (h*w);  % Calculate PDF
var_max = 0;                      
threshold = 0;                    
for t = 1:256
    w0 = 0;                       
    w1 = 0;
    for i = 1:t
        w0 = w0+ Hist_arr_pdf(i);
    end
    for ii = t+1:256
        w1 = w1 + Hist_arr_pdf(ii);
    end
    m0 = 0;
    m1 = 0;
    for i = 1:t
        m0 = m0 + i * Hist_arr_pdf(i) / w0;
    end
    for ii = t+1:256
        m1 = m1 + ii * Hist_arr_pdf(ii) / w1;
    end
    var = w0 * w1 * (m0-m1)^2;
    if var > var_max
        threshold = t;
        var_max = var;
    end
end
disp(threshold);
img_bi = zeros(h,w);
for i = 1:h                      % Create Binary Image   
     for j = 1:w 
        if img(i, j) >= threshold 
                img_bi(i, j) = 1; 
        end
     end
end
img_final = img_bi;
end