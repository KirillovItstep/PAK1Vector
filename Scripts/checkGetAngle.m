clc; clear all; close all;
%{
im0=imread('resa.jpg');
image = imread('Frames/17.jpg');
angle = getAngle(image,im0);
disp(angle);
%}

image=imread('res0.jpg');
%figure,imshow(image);
box = cropScale(image);
angle = getAngle(image,box);
disp(angle);

