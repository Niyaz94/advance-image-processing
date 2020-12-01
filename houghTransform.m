%% Creating a simple image
clear
% create 101 by 101 binar image all pixels are zero just the corners and image center are one
im = zeros(101,101);
im(1,1) = 1;
im(1,end) = 1;
im(end,1) = 1;
im(end,end) = 1;
im(floor(end/2),floor(end/2)) = 1;

%% define theta range it start from -90 to 90
theta = ((-90:90)./180).*pi;


% find Diagonal length of image. you can use matlab functions[hypot(size(im,1),size(im,2))]
D = sqrt(size(im,1).^2 + size(im,2).^2);
% create hough Space which his row equal [2*Diagonal] and his coloumn equal [theta length (180 in our case)]
HS = zeros(ceil(2.*D),numel(theta));
% find the index of non zero pixels and puting them inside x, y array
[y,x] = find(im);
% subtract all the items in array by one
y = y - 1;
x = x - 1;

% numel(x) ---> get the lenght of array
%A cell array is a data type with indexed data containers called cells, where each cell can contain any type of data. Cell arrays commonly contain either lists of character vectors of different lengths, or mixes of strings and numbers, or numeric arrays of different sizes.
rho = cell(1,numel(x));



%% Calculating the Hough Transform
for i = 1: numel(x)
    % Calculate rho, D is added for a positive index
    rho{i} = floor((x(i).*cos(theta) + y(i).*sin(theta))+ D) + 1;
end

%% Creating the Hough Space as an Image
for i = 1:numel(x)
    for j = 1:numel(rho{i})
        % Vote in the hough accumulator
        HS(rho{i}(j),j) = HS(rho{i}(j),j) + 1; 
    end
end

figure
imshow(HS)
