% Moving Average Filter

% Defining the coefficients of Z transform of 8th order moving average
% filter
a = [1 1 1 1 1 1 1 1];
b = [8 0 0 0 0 0 0 0];

% Convoling with 1/8
num = conv(a, 1/8);

% Getting the frequency response of the signal
[h, w] = freqz(num, 1, 5000);

% Converting to pole-zero notation from transfer function
[z,p,k] = tf2zp(a, b);

% Plotting poles-zeros along with Magnitude and Phase response
fvtool(a,b,'polezero');
text(real(z)+.1,imag(z),'Zero');
text(real(p)+.1,imag(p),'Pole');

figure;
plot(w,20*log10(abs(h)),'r');
xlabel('Frequency'); ylabel('Magnitude');axis tight;grid on;
title('MA Filter Magnitude Response')

figure;
plot(w, angle(h),'r');
xlabel('Frequency'); ylabel('Phase');axis tight;grid on;
title('MA Filter Phase Response')