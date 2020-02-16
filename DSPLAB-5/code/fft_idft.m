% Loading the data
x = load('ppgwithRespiration_25hz_30seconds.mat');
x = x.xppg;


L = 10; Fs = 25;

% The index at which to split the PPG and respiratory signal
ind = 21;

% Finding out the FFt
y = fft(x);

% Calcaulating the spectrum of PPG and Respiratory
f_ppg = y(:,1:750);
f_res = y(:,1:750);
f_ppg(:,ind:750-ind) = zeros(1,750-2*ind+1);

f_res(:,1:ind) = zeros(1,ind);
f_res(:,751-ind:750) = zeros(1,ind);

% Finding the maximum frequency in respiratory spectrum
[~,index] = max(f_ppg(:,2:ind));

% Printing the respiratory rate
fprintf("Respiratory rate = %f", index*Fs*60/750);

% Finding the IFFT 
x_ppg = ifft(f_ppg);
x_res = ifft(f_res);

% Plotting the results
figure;
subplot(6,1,1)
plot(x, 'r');
title('Actual PPG with Respiratory signal')
xlabel('Samples');ylabel('Magnitude')
grid on; axis tight;

subplot(6,1,2)
plot(abs(y), 'r');
grid on; axis tight;
xlabel('Samples');ylabel('Magnitude')
title('FFT of the Signal')

subplot(6,1,3)
plot(abs(f_ppg), 'r');
grid on; axis tight;
xlabel('Samples');ylabel('Magnitude')
title('FFT of Signal with PPG removed')

subplot(6,1,4)
plot(abs(f_res), 'r');
grid on; axis tight;
xlabel('Samples');ylabel('Magnitude')
title('FFT of Signal with Respiratory removed')

subplot(6,1,5)
plot(abs(x_res), 'r');
grid on; axis tight;
xlabel('Samples');ylabel('Magnitude')
title('Extracted PPG signal')

subplot(6,1,6)
plot(abs(x_ppg), 'r');
grid on; axis tight;
xlabel('Samples');ylabel('Magnitude')
title('Extracted Respiratory signal')
