% ECGspectrogram: make a spectrogram of filtered ECG or of detected beats

load('tt17_128z_ecg')
HR = 60./diff(H(:,1));

figure(1), clf, hold on
plot(H(2:end,1),HR,'k.-') 
t = (1:length(ecgfilt))/ecgfilt_fs;
plot(t,ecgfilt)
xlabel('Time (sec)'), ylabel('Instantaneous HR (BPM)')

figure(2)
make_specgram(ecgfilt,256,ecgfilt_fs);
hold on
plot(H(2:end,1),HR,'k.-') % plot instantaneous HR on top


figure(3) % make spectrogram using the HR? This doesn't seem right
make_specgram(HR,256);

return


% spectrogram of another signal, eg ECG or respiratory or fluke stroke rate
% x = 3.5*ecg(2700).';
% y = repmat(sgolayfilt(x,0,21),[1 13]);
% sigData = y((1:30000) + round(2700*rand(1))).';
% Fs = 4000;
% 
% plot(sigData) % plot simulated ecg data
% xlabel('Time (sec)'), ylabel('Amplitude')

%% Load the signal, the timestamps, and the sample rate
load('nonuniformdata.mat','ecgsig','t2','Fs')

% Find the ECG peaks
[pks,locs] = findpeaks(ecgsig,Fs, ...
    'MinPeakProminence',0.3,'MinPeakHeight',0.2);

% Determine the RR intervals 
RLocsInterval = diff(locs);

% Derive the HRV signal
tHRV = locs(2:end); % times of beats
% HRV = 1./RLocsInterval; 
iBPM = 60./RLocsInterval;

% Plot the signals
figure
a1 = subplot(2,1,1); 
plot(t2,ecgsig,'b',locs,pks,'*r')
grid
a2 = subplot(2,1,2);
plot(tHRV,iBPM)
grid
xlabel(a2,'Time(s)')
ylabel(a1,'ECG (mV)')
ylabel(a2,'Instantaneous BPM (/min)')

%% plot spectrogram
NFFT =64*8;
WINDOW= hanning(NFFT);
NOVERLAP= floor(length(WINDOW)/2);

figure(2)
spectrogram(abs(ecgsig),WINDOW,NOVERLAP,NFFT,Fs,'yaxis'); colorbar off; ylim([0 10])


