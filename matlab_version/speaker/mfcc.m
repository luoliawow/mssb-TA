
function c = mfcc(s, fs, params)
    % MFCC Calculate the mel frequencey cepstrum coefficients (MFCC) of a signal
    %
    % Inputs:
    %       s       : speech signal
    %       fs      : sample rate in Hz
    %       params  : [FrameLength, FrameShift, MelFilterOrder, MFCCDimension]
    %                 256         , 100       , 24            , 12
    %       
    % Outputs:
    %       c       : MFCC output, each column contains the MFCC's for one speech frame
    
    if length(params) ~= 4 
    % N:Frame Length    N:Frame Shift
        N = 256; M = 100;
    % p:MelFilter Order L:MFCC Dimension
        p = 20; L = 20;
    else
        N = params(1); M = params(2); p = params(3); L = params(4);
    end
    % PreProcess
    % PreEmphasis & FrameBlock & window
    % s = filter([1,-0.97],1,s);
    frames = frame_block(s,N,M);
    y = frames .* hamming(N);
    f = fft(y);f2 = f .* conj(f);
    PSD = f2(1:N/2+1,:)*2;PSD(1,:) = f2(1,:);
    % DCT
    dctCoef = zeros([L,p]);
    for k = 1:L
        n = 0:p-1; dctCoef(k,:) = cos((2*n+1)*k*pi/(2*p));
    end
    % Cepstral Window
    cep = 1 + L/2 * sin(pi/L * (1:L))';cep = cep / max(cep);
    % MelBank
    bank = melfb(p,N,fs);bank = full(bank);
    bank = bank / max(bank(:));
    % Calculate mfcc for each frame
    m = dct(log(bank * PSD),L);c = m;
    % c = m .* cep;
end
    