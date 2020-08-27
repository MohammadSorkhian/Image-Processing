clear all;
%%%%%    Section 1&2    %%%%%
img = imread("image.png");
[h, w] = size(img);                % Fetch image size
h_pad = h/4; 
w_pad = w/4;
h_n = h + 2*h_pad;
w_n = w + 2*w_pad;
Im1 = zeros(h_n, w_n);
for j = 1:h                                      % Add original image to padded image
    for i = 1:w   
        Im1(h_pad+j, w_pad+i) = img(j, i);
    end
end
Im1 = Im1/255;
% imshow(Im1);

%%%%%    Section 3    %%%%%
T1 = maketform('affine', [1 0 0; 0 1 0; w_pad h_pad 1]);
Im2 = imtransform(Im1, T1,'XData',[1 size(Im1,1)], 'YData',[1 size(Im1,2)]);
% imshow(Im2);

%%%%%    Section 4    %%%%%
T2 = maketform('affine', [0.5 0 0; 0 0.5 0; 0 0 1]);
Im3 = imtransform(Im1, T2, 'XData',[1 size(Im1,1)], 'YData',[1 size(Im1,2)]);
% imshow(Im3);

%%%%%    Section 5    %%%%%
T3 = maketform('affine', [cos(pi/4) sin(pi/4) 0; -sin(pi/4) cos(pi/4) 0; 0 0 1]);
Im4 = imtransform(Im1, T3,'XData',[-269 size(Im1,1)-270], 'YData',[+111 size(Im1,2)+110]);
% imshow(Im4);

%%%%%    Section 6    %%%%%
T4 = maketform('affine', [cos(pi/2) sin(pi/2) 0; -sin(pi/2) cos(pi/2) 0; 0 0 1]);
Im5 = imtransform(Im1, T4,'XData',[-539 size(Im1,1)-540], 'YData',[1 size(Im1,2)]);
% imshow(Im5);

%%%%%    Section 7    %%%%%
Im6=flipdim(Im1,2);
% imshow(Im6);

%%%%%    Section 8    %%%%%
% imshow(Moment_invariants(Im1));
Moment_invariants(Im1);
Moment_invariants(Im2);
Moment_invariants(Im3);
Moment_invariants(Im4);
Moment_invariants(Im5);
Moment_invariants(Im6);


