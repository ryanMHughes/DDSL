% ---------  Plate dimension calculator  ----------
% The purpose of this script is to take plate width and water tunnel 
% flow speed, and return a .csv containing possible plate dimension
% combinations that set the nth natural frequency of the plate equal to 
% the Vortex Shedding Frequency (VSF) at a location inside the Karman-wake.

clear all; clc;

% Width of plate (cm)
w = input("Desired plate width (m): ");

% Water tunnel flow speed (m/s)
U = input("Water tunnel flow speed (m/s): ");
VSF = 2.625 * U;

% Material properties
material = input("Plate material (PLA or ABS): ", 's');

rohWater = 998.2; % kg / m^3

if material == "PLA"
    E = 3.986e9; % N / m^2
    roh = 1290; % kg / m^3
elseif material == "ABS"
    E = 2.06e9; % N / m^2
    roh = 1070; % kg / m^3
end

% Calculation for mode of vibration (Hz)
mode = input("Desired mode of vibration (integer): ");

if (mode == 1)
    lambda = 1.875;
elseif (mode == 2)
    lambda = 4.694;
elseif (mode == 3)
    lambda = 7.885;
end

% Wn = lambda^2 (E*I / roh*A)^(0.5) (L^-2) (1 + (pi*w*rohWater / 4*t*roh))^(-0.5)
%      -----------a----------------             ------b-------   ---c---

a = ( (lambda ^ 2) * ((E * (1/12)) / roh) ^ (0.5) ) / VSF;
b = pi * w * rohWater;
c = 4 * roh;
d = b / c;

lengths = [];
widths = [w; w; w; w; w; w; w; w; w];
t = 0.0025:-0.00025:0.0005;
t = t.';
for i = 1:length(t)
    lenSQ = (  a * t(i)  ) / (  (  1 + (  d / t(i)  )  ) ^ (0.5)  ); 
    len = lenSQ ^ (0.5);
    lengths = [lengths; len];
end

dimensions = table(widths, lengths, t);

writetable(dimensions, "Combinations.txt");

