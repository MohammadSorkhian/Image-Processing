function [img_final] = filter_median(image,kernel_size)
% This func takes two args, image and kernel size, and apply median filter on the image
[h, w] = size(image);   
s = (kernel_size - 1) / 2;      
h_n = h+(2*s);           
w_n = w+(2*s);       
img_padded = zeros(h_n, w_n); 
for t = 1:s 
%     img_padded(t, s+1:s+w) = image(t, :);             % Padding from original image (straight) 
%     img_padded(h_n-t+1, s+1:s+w) = image(h-t+1, :);
%     img_padded(s+1:s+h, t) = image(:, t);
%     img_padded(s+1:s+h, w_n-t+1) = image(:, w-t+1);   
    img_padded(t, s+1:s+w) = image(s-t+1, :);          % Padding from original image (mirror)
    img_padded(h_n-t+1, s+1:s+w) = image(h-s+t, :);    
    img_padded(s+1:s+h, t) = image(:, s-t+1);    
    img_padded(s+1:s+h, w_n-t+1) = image(:, h-s+t);
end
for i = (s+1):s+h                                      % Add original image to padded image
    for j = (s+1):s+w    
        img_padded(i, j) = image(i-s, j-s);
    end
end
img_filtered = zeros(h_n, w_n);
for i = (s+1):s+h                    % Apply the kernel on the image
    for j = (s+1):s+w
        temp = [];
        for ii = -s:s
            for jj = -s:s
                temp = [temp, img_padded(i-ii, j-jj)];                         
            end
        end
        temp = sort(temp);
        mid_index = ((kernel_size^2-1)/2+1);
        img_filtered(i, j) = temp(mid_index);
    end
end
img_final = zeros(h, w);
for i = (s+1):s+h                    % Remove the padding
    for j = (s+1):s+w
        img_final(i-s, j-s) = img_filtered(i, j);
    end
end
img_final = img_final/255;           % Normalize values
end
