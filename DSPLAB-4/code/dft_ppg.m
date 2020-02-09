x = load('../data/Exp03_PPG_25hz_75samples.mat');
data = x.x3;
filter_window = 10;
filtered_data = zeros(size(data));

% sampling frequency of 25Hz
F_s = 25;

% Moving Average
for i = 1:size(data,2)
    x = 0;
    if i <= filter_window
        x = sum(data(1:i));
    else
        x = sum(data(i-filter_window:i));
    end
    filtered_data(i) = x / filter_window;
end

% DFT and DFT Matrix
dft = fft(filtered_data);
dft_matrix = dftmtx(size(filtered_data,2));
[~, index] = max(abs(dft));


figure(1);
plot(abs(dft),'r','LineWidth',2);
title('Magnitude Response');
xlabel('Frequency'); ylabel('Magnitude Value');
set(gca,'FontSize',10);
axis tight; grid on;

% Calculation of Pulse Rate
display(60*index*F_s/size(filtered_data,2));

% Pulse rate through autocorrelation

corr = xcorr(filtered_data - mean(filtered_data));
corr = corr(76:end);

figure(2);
plot(corr,'b','LineWidth',2);
set(gca,'FontSize',10);
xlabel('Time');
ylabel('Magnitude Value');
title('Autocorrelation');
axis tight; grid on;

% Zero Crossing 

zcr_i = 0;
for i=1:size(corr, 2)
    if corr(i+1) * corr(i) < 0
        zcr_i = i + 1;
        break
    end
end

% Pulse Rate using Autocorrelation

[~, index_C] = max(corr(zcr_i:end));
index_C = zcr_i + index_C;
display(60/(index_C/25));
