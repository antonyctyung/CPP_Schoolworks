clear all
close all
clc

w=10:10:10^5
H=abs(-5000./((1000^2+(1.25.*w-20000./w).^2).^(1/2)))
y=1/sqrt(2).*w./w
semilogx(w,H,w,y)