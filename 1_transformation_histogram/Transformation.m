clear all
imc = imread('im3.jpg');          % Read the image from the source folder
img = rgb2gray(imc);              % Convert BGR to Grayscale

theta = 0.2778 * pi;              % The rotation matrix
R = [cos(theta) sin(theta) 0;     
    -sin(theta) cos(theta) 0; 
    0           0          1];    
    tx = 25;    ty = 30;          % The translation matrix
T = [1    0     0;                
     0    1     0;
     tx   ty    1];
    cx = 0.5;   cy = 1.5;         % The Scale matrix
S = [cx   0     0;                
     0    cy    0; 
     0    0     1];
    sv = 0.2;                     % The Shear Vertical matrix
S_V = [1    sv  0;              
       0    1   0; 
       0    0   1]; 
    sh = 0.3;                     % The Shear Horizontal matrix
R_H = [1     0    0;              
       sh    1    0; 
       0     0    1];
   
[y_max, x_max] = size(img);       % Store original image size in two variables
corners = [0,     0,     1;       % Specify corners of the original image
           x_max, 0,     1; 
           0,     y_max, 1; 
           x_max, y_max, 1];
%R = R * T;                      % This line of code is used for two consecutive transformations
new_corners = corners * R;        % Calculate coordinates of rotated image corners
new_width = round(max(new_corners(:,1)) - min(new_corners(:,1)));  % Based on the rotated image find the max of width & height
new_height = round(max(new_corners(:,2)) - min(new_corners(:,2))); 
rot_img = zeros(new_height,new_width);                             % Create a new empty image based on previous step width & height
min_width = abs(min(new_corners(:,1)));     % Find the width & height of the rotated image on the negative side of x & y axis
min_height = abs(min(new_corners(:,2)));
min_width = round(min_width)+1;
min_height = round(min_height)+1;  
% In this step, instead of mapping the rotated image to the empty image, we use
% the inverse of our desirable matrix to transform the empty image, and
% for each pixel of it, we read the value of the corresponding pixel in the 
% original pixel. With this approach, we would be able to solve the problem
% of those black dots
refPoint = [min_width  min_height  1];      % Use this point to extract amounts of shifting(dif_x & dif_y)...
refPoint_R = refPoint * inv(R);             % required for aligning the desirable part of the rotated image... 
dif_x = refPoint_R(1);                      % with the original image for reading and writing values from... 
dif_y = refPoint_R(2);                      % original image to empty image respectively
for ii = 1 : new_height                     
    for jj = 1 : new_width
        temp = ([jj ii 1]) * inv(R);        % Transform each pixel of the empty image
        x_new = round(temp(1,1)-dif_x);     
        y_new = round(temp(1,2)-dif_y);
        if 0 < x_new & x_new < x_max & 0 < y_new & y_new < y_max
            rot_img(ii, jj) = img(y_new, x_new);  % mapping original image to the rotated empty image  
        end
    end
end
imshow(rot_img,[])

% img = imread('im3.jpg');                  %%%%%% Performance Evaluation %%%%%%
% img = rgb2gray(img);                      % With this built-in function, the rotation process takes about 4(s)...
% tform3 = maketform('affine',R);           % While with the implemented algorithm, it takes about 15(s)...
% I3 = imtransform(img,tform3);
% imshow(I3,[])