img = imread('im2.png');             % Read the image
img = rgb2gray(img);                 % Convert the BRG image to the grayscale one
H=size(img,1);						 % Read the height of the image
W=size(img,2); 						 % Read the width of the image
Hist_arr = zeros(1,256);             % Create an empty array with the size of the intensity range
CDF_array=zeros(1,256); 			 % Create an empty array to hold CDF calculated from PDF
Hist_eq_arr = zeros(1,256);          % Create an empty array for holding the equalized histogram
hist_eq_img=uint8(zeros(H,W));       % Create a 2D array for keeping the histogram-equalized image

% Create a nested for-loop for reading the intensity of each pixel and increase...
% the corespondent Hist_arr element by one, since our intensity range is from 0-255...
% while that of Hist_arr is from 1-256 
for i=1:H;
    for j=1:W;
        Hist_arr(1,img(i,j)+1)=Hist_arr(1,img(i,j)+1) + 1;
    end
end

Hist_arr_pdf=Hist_arr/(H*W);         % For PDF, divide the number of pixels with each intensity level to total number of pixels
dummy1=0;

% Generating the CDF from PDF
for k=1:length(Hist_arr);            
    dummy1=dummy1+Hist_arr_pdf(k);
    CDF_array(k)= dummy1;
end

% Histogram equalization:
% In this for-loop we read the value of each pixel in the original pic and find...
% the equalized value for it in the CDF array and put it in the hist_eq_img...
% after that, add this mapped value to the Hist_eq_arr
for l=1:H;                           
    for m=1:W;
        hist_eq_img(l,m) = round(CDF_array(img(l,m)+1) * (length(Hist_arr_pdf)-1)); % scale to 255 and round to nearest integer
        Hist_eq_arr(1, hist_eq_img(l,m)+1) = Hist_eq_arr(1,hist_eq_img(l,m)+1)+1; % Its histogram
    end
end


figure, imshow(img);                 
figure, imshow(hist_eq_img)
figure, plot (Hist_arr);
figure, plot (Hist_eq_arr);
