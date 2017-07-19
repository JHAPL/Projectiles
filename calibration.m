%%
clear
clc
%%
% assigining the camera a value
camR = webcam(1);
% lowering camera resolution
camR.Resolution = '352x288';

%%
%for messuring pixels
disp('place rig to the in center of fov');
preview(camR)
q = input('press any button when ready ');
% takes a snapshot
pic = snapshot(camR);
imtool(pic)
a = input('number of pixels = ');
b = input('actual distance between pixels = ');
c = input('distance between camera and pixel mesurement = ');
e = (((atan(b/c))*180)/pi);
dppCC = e/a;


%%
disp('move rig to the Top Right corner');
preview(camR)
q = input('press any button when ready ');
pic = snapshot(camR);
imtool(pic)
a = input('number of pixels = ');
b = input('actual distance between pixels = ');
c = input('distance between camera and pixel mesurement = ');
e = (((atan(b/c))*180)/pi);
dppTR = e/a;


%%
disp('move rig to the Bottom Right corner');
preview(camR)
q = input('press any button when ready ');
pic = snapshot(camR);
imtool(pic)
a = input('number of pixels = ');
b = input('actual distance between pixels = ');
c = input('distance between camera and pixel mesurement = ');
e = (((atan(b/c))*180)/pi);
dppBR = e/a;


%%
disp('move rig to the Top Left corner');
preview(camR)
q = input('press any button when ready ');
pic = snapshot(camR);
imtool(pic)
a = input('number of pixels = ');
b = input('actual distance between pixels = ');
c = input('distance between camera and pixel mesurement = ');
e = (((atan(b/c))*180)/pi);
dppTL = e/a;


%%
disp('move rig to the Bottom Left corner');
preview(camR)
q = input('press any button when ready ');
pic = snapshot(camR);
imtool(pic)
a = input('number of pixels = ');
b = input('actual distance between pixels = ');
c = input('distance between camera and pixel mesurement = ');
e = (((atan(b/c))*180)/pi);
dppBL = e/a;

%%
x = [dppTR 0 dppTL; 0 dppCC 0; dppBR 0 dppBL];
disp('values');
disp(x);
y = [dppCC 0 dppCC; 0 dppCC 0; dppCC 0 dppCC];
error = x - y;
disp('error');
disp(error);
