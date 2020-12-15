%clear all define variables
clear;
%read the orignal image
img = imread('test.jpg'); 
%if it is image then converted to gray image
if length(size(img))>2
    img = rgb2gray(img);
end 
% find the length of image
height = size(img,1);
width = size(img,2);
% create two back image the same size as orinal image
result = zeros(height,width); 
R = zeros(height,width);
% difine first drivative mask for finding image edge
fx = [-1 0 1;-1 0 1;-1 0 1];
fy = [1 1 1;0 0 0;-1 -1 -1];
% apply first drivative depend on dx and dy
Ix = filtering(fx,img);
Iy = filtering(fy,img); 
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;


% applying gaussian filter on the computed value to reduce noise
% I try the algorithm without gaussian all the values are minus and the
% algorithm not working
h= fspecial('gaussian',[7 7],2); 
% apply gaussian filter
Ix2 = filtering(h,Ix2);
Iy2 = filtering(h,Iy2);
Ixy = filtering(h,Ixy);
 
% loop throw all the image pixel
for i = 1:height
    for j = 1:width
        % create the matrix depend on the drivative values
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)]; 
        % finding harris algorithm for all pixels
        R(i,j) = det(M)-0.01*(trace(M))^2;
    end
end
% saving max value form R
Rmax = max(max(R));

% we multiple max value by 0.1 (it is constant use by harris, he suggest 0.4 but it is not fixed number becuase of that we use 0.1)
% In those two loop we check for all R values if anyone greater than the
% threshold (Rmax*0.1) and greater than all neighbours then we recognize the point as corner
for i = 2:height-1
    for j = 2:width-1
        % if it is greater than threshold and thier neighbours
        if R(i,j) > 0.1*Rmax && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
            result(i,j) = 1;
        end
    end
end
% find the index of all 1 pixel value (the matrix values are just zero and one)
[column_position, row_position] = find(result == 1);
%show the image
imshow(img);
hold on;
%show the corner as red points
plot(row_position,column_position,'r.');
% this function use for findig the filters
function filter_output= filtering(image,mask)
    filter_output = filter2(image,mask);
end