
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   SPATIAL FILTER   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%% Section 2 (filter func)
clear all
img = imread('img1.png');
img = rgb2gray(img);
kernel_1 = (1/9)*ones(3);
kernel_2 = (1/49)*ones(7);
kernel_3 = fspecial('average',[7,7]);
kernel_4 = fspecial('gaussian',[3,3],0.5);
kernel_5 = fspecial('gaussian',[7,7],1.2);
result = filter_func(img, kernel_5);
figure, imshow(result)
% buitin_filter = imfilter(img, kernel_5);  % Use this builtin function for checking output of our function
% figure, imshow(buitin_filter);

    %%%% Section 3 (Median filter)
clear all
img = imread('img1.png');
img = rgb2gray(img);
result = filter_median(img, 5);
figure, imshow(result);
% buitin_filter = medfilt2(img,[5 5]);      % Use this builtin function for checking output of our function
% figure, imshow(buitin_filter);

    %%%%% Section 4 (Sharpening filter)
clear all
img = imread('img2.png');
img = rgb2gray(img);
kernel_6 = [-1 0 1; -2 0 2; -1 0 1];
kernel_7 = [-1 -2 -1; 0  0  0 ; 1  2  1];
kernel_8 = fspecial('log',3);
result = filter_func(img, kernel_7);
figure, imshow(result);
% builtin_filter = imfilter(img, kernel_7);  % Use this builtin function for checking output of our function
% figure, imshow(builtin_filter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   THRESHOLDING   %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 clear all
 img = imread('img3.png');
 img = rgb2gray(img);
 result = th_otsu(img);
 figure, imshow(result);
%  [counts,x] = imhist(img);                   
%  builtin_func = otsuthresh(counts);          % Use this builtin function for checking output of our function
%  disp(round(builtin_func*256));
