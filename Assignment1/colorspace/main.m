% test your code by using this simple script

clear
clc
close all

I = imread('peppers.png');

figure;
J = ConvertColorSpace(I,'opponent');
 
% close all
figure;
J = ConvertColorSpace(I,'rgb');

% close all
figure;
J = ConvertColorSpace(I,'hsv');

% close all
figure;
J = ConvertColorSpace(I,'ycbcr');

% close all
figure;
J = ConvertColorSpace(I,'gray');