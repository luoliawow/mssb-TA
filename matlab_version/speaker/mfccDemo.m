clc;clear;
[x,Fs] = audioread('data\train\s1.wav');sound(x,Fs);
figure('Name','TimeDomain');plot(x);title('Input Speech Signal');xlabel('Frequency/Hz')

%Set mfcc parameters
% N:FrameLength N:FrameShift
N = 256;M = 100;
% p:MelFilterOrder L:
p = 20;L = 20;

frames = frame_block(x,N,M);
figure('Name','Framing');imagesc(frames);colorbar;set(gca,'YDir','normal');
xlabel('Frame Number');ylabel('Speech sample in frames');title("Frames");colormap jet;

y = frames .* hamming(N);
f = fft(y);f2 = f .* conj(f);
PSD = f2(1:N/2+1,:)*2;PSD(1,:) = f2(1,:);
figure("Name","PSD");imagesc(PSD);set(gca,'YDir','normal');
colorbar;title('Power Spectral Density');colormap jet;
xlabel('Time(frame number)');ylabel('Frequency(FFT number)');

%DCT
dctCoef = zeros(L,p);
for k = 1:L
    n = 0:p-1; dctCoef(k,:) = cos((2*n+1)*k*pi/(2*p));
end
%Cepstral Window
cep = 1 + L/2 * sin(pi/L * (1:L))';
cep = cep / max(cep);
%MelBank
bank = melfb(p,N,Fs);bank = full(bank);bank = bank / max(bank(:));
figure("Name","MelSpectrum");imagesc(bank * PSD);set(gca,'YDir','normal');colormap jet;
colorbar;xlabel('Time(frame number)');ylabel('Frequency(FFT number)');title('Mel-Spectrum')

m1 = dct(log(bank * PSD),L);
mfcc1 = m1 .* cep;
figure("Name","MFCC1");imagesc(m1(2:end,:));set(gca,'YDir','normal');colorbar;colormap('jet');
xlabel('Time(frame number)');ylabel('MFCC');title('Mel-frequency cepstrum coefficients');
