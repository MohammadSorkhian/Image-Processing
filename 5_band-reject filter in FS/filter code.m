clear all
img =double(imread('moonlanding.png')); % Read the image

    %%%%%   part 01   %%%%%
fr = fft2(img);          % Convert the image to frequency domain
fr_sh = fftshift(fr);    % Center the spectrom
FS_max = max(fr_sh(:));  % Calculate the maximum value of the frequency spectrum
% figure, imshow(fr), title("Frequency Spectrum");
% figure, imshow(fr_sh), title("Frequency Spectrum - shifted");

    %%%%%   part 02   %%%%%
fr_sh_dis = log(1 + abs(fr_sh));  % Convert to log for displaying the result
% figure, imshow(fr_sh_dis,[]), title("Frequency Spectrum - shifted") ;

    %%%%%   part 03   %%%%%
% Introdce noise to the FS
[hight,width] = size(fr_sh);
Center = [hight/2 width/2];   
D = 100;
deg = pi/4;
fs_max = FS_max/10;
N  = [Center(1)-D  Center(2)];
E  = [Center(1)    Center(2)+D];   
W  = [Center(1)  Center(2)-D];
S  = [Center(1)+D  Center(2)];
NE = [round(Center(1)-(sin(deg)*D)), round(Center(2)+(cos(deg)*D))];
NW = [round(Center(1)-(sin(deg)*D)), round(Center(2)-(cos(deg)*D))];
SE = [round(Center(1)+(sin(deg)*D)), round(Center(2)+(cos(deg)*D))];
SW = [round(Center(1)+(sin(deg)*D)), round(Center(2)-(cos(deg)*D))];
fr_sh_noise = fr_sh;
for x = (1:8)
   points = [N; E; W; S; NE; NW; SE; SW];
   P = points(x,:);
   fr_sh_noise = noise_m(fr_sh_noise, P, fs_max);
end
fr_sh_noise_dis = log(1 + abs(fr_sh_noise));  % Convert to log for displaying the result
% figure, imshow(fr_sh_noise_dis, []), title("Frequency Spectrum - shifted with noise");

    %%%%%   part 04   %%%%%
fr_sh_sh = fftshift(fr_sh);                  % Shift the centered FS back
fr_sh_sh_noise = fftshift(fr_sh_noise);      % Shift the centered FS with noise back
img_fr_sh_sh = ifft2(fr_sh_sh);              % Convert FS to Spatial Domain
img_fr_sh_sh_noise = ifft2(fr_sh_sh_noise);  % Convert FS with noise to Spatial Domain
% figure, imshow(img_fr_sh_sh,[]), title('Spetial Domain from FS');
% figure, imshow(img_fr_sh_sh_noise,[]), title('Spetial Domain from FS with noise');

    %%%%   part 05   %%%%%
fr_4 = fft2(img_fr_sh_sh_noise);      % Convert corrupted image in q4 to FS                   
fr_4_sh = fftshift(fr_4);             % Center the FS
fr_4_sh_dis = log(1 + abs(fr_4_sh));  % Convert to log for displaying the result
% figure, imshow(fr_sh_noise_dis, []), title("Frequency Specrum - with manual noise (Q3)");
% figure, imshow(fr_4_sh_dis,[]), title("Frequency Specrum obtained from corrupted image (Q4)");

    %%%%   part 06   %%%%%
D0 = 100;
W = 8;
[hight,width]=size(img);
filter_ideal = ones(hight,width);
x0 = round(width/2);
y0 = round(hight/2);
for j = 1:hight     % Design Ideal-band-reject filter
   for i = 1: width
       ii = i-x0;
       jj = j-y0;
       D = sqrt(ii^2+jj^2);
       if (D0-W/2) <= D && D <= (D0+W/2)
           filter_ideal(j,i) = 0;
       end
   end
end
filter_btw = ones(hight,width);
n = 4;
for j = 1:hight    % Design Butterworth-band-reject filter
   for i = 1: width
       ii = i-x0;
       jj = j-y0;
       D = sqrt(ii^2+jj^2); 
       filter_btw(j,i) = 1/(1+(((D*W)/(D^2-D0^2))^(2*n)));
   end
end
filter_gaussian = ones(hight,width);
for j = 1:hight    % Design Gaussian-band-reject filter
   for i = 1: width
       ii = i-x0;
       jj = j-y0;
       D = sqrt(ii^2+jj^2); 
       filter_gaussian(j,i) = 1-exp(-(((D^2-D0^2)/(D*W))^2));
   end
end
% figure, imshow(filter_ideal), title("Ideal band-reject filter");
% figure, imshow(filter_btw), title('Butterworth band-reject filter (n=4)');
% figure, imshow(filter_gaussian), title('Gaussian band-reject filter');
 
     %%%%   part 07   %%%%%
% Applying designed filters on the FS with noise
fr_sh_rm_noise_ideal = fr_sh_noise.*filter_ideal;  
fr_sh_rm_noise_btw = fr_sh_noise.*filter_btw;
fr_sh_rm_noise_gaussian = fr_sh_noise.*filter_gaussian;
figure, imshow(log(abs(fr_sh_rm_noise_ideal)),[]), title('Frequency Spectrum with Ideal filter');
figure, imshow(log(abs(fr_sh_rm_noise_btw)),[]), title('Frequency Spectrum with butterworth filter (n=4)');
figure, imshow(log(abs(fr_sh_rm_noise_gaussian)),[]), title('Frequency Spectrum with Gaussian filter');

    %%%%   part 08   %%%%%
% Convert filtered FSs to the spatial domain
fr_rm_noise_ideal = fftshift(fr_sh_rm_noise_ideal);
fr_rm_noise_btw = fftshift(fr_sh_rm_noise_btw);
fr_rm_noise_gaussian = fftshift(fr_sh_rm_noise_gaussian);
img_rm_noise_ideal = ifft2(fr_rm_noise_ideal);
img_rm_noise_btw = ifft2(fr_rm_noise_btw);
img_rm_noise_gaussian = ifft2(fr_rm_noise_gaussian);
% figure, imshow(img_rm_noise_ideal,[]), title('Spatial Domain from FS with Ideal filter');
% figure, imshow(img_rm_noise_btw,[]), title('Spatial Domain from FS with Butterwork filter n=4');
% figure, imshow(img_rm_noise_gaussian,[]), title('Spatial Domain from FS with Gaussian filter');



function [result] = noise_m(img, point, value)
% This function gets an image and desired point, 
% then apply noise(value) on the 3*3 neighboring pixels
for j = -1:1
    for i =-1:1
        img((point(1)+i), (point(2)+j)) = value;
    end
end
result = img;
end
