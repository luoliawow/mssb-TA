clc;clear;
code = train('D:\Code\matlab\mssb\spekerRecognize\data\train\',8);
test('D:\Code\matlab\mssb\spekerRecognize\data\test\',8,code);

Fs = 22050;
recorder = audiorecorder(Fs,8,1);disp('start speaking test');
recordblocking(recorder,1);disp('End of recording test');
play(recorder);
x1 = getaudiodata(recorder);audiowrite("data\train\s9.wav",x1,Fs);
ind1 = find(x1);x1 = x1(ind1(1):end);figure(Name='Time-Domain1');plot(x1);
v1 = mfcc(x1,Fs,[]);imagesc(v1(2:end,:));set(gca,'YDir','normal');colorbar;colormap('jet');
code1 = vqlbg(v1(5:6,:),16);figure(Name='Vq1');plot(v1(5,:),v1(6,:),'b.',code1(1,:),code1(2,:),'r*');

recorder = audiorecorder(Fs,8,1);disp('start speaking train');
recordblocking(recorder,1);disp('End of recording train');
play(recorder);
x2 = getaudiodata(recorder);audiowrite("data\test\s9.wav",x2,Fs);
ind2 = find(x2);x2 = x2(ind2(1):end);figure(Name='Time-Domain2');plot(x2);
v2 = mfcc(x2,Fs,[]);imagesc(v2(2:end,:));set(gca,'YDir','normal');colorbar;colormap('jet');
code2 = vqlbg(v2(5:6,:),16);figure(Name='Vq2');plot(v2(5,:),v2(6,:),'b.',code2(1,:),code2(2,:),'r*');

clear;
code = train('D:\Code\matlab\mssb\spekerRecognize\data\train\',9);
test('D:\Code\matlab\mssb\spekerRecognize\data\test\',9,code);

function test(testdir, n, code)
    % Speaker Recognition: Testing Stage
    %
    % Input:
    %       testdir : string name of directory contains all test sound files
    %       n       : number of test files in testdir
    %       code    : codebooks of all trained speakers
    %
    % Note:
    %       Sound files in testdir is supposed to be: 
    %               s1.wav, s2.wav, ..., sn.wav
    %
    % Example:
    %       >> test('C:\data\test\', 8, code);
    
    for k = 1:n                     % read test sound file of each speaker
        file = sprintf('%ss%d.wav', testdir, k);
        [s, fs] = audioread(file);      
        ind = find(s);s = s(ind(1):end);    
        v = mfcc(s, fs, []);            % Compute MFCC's
       
        distmin = inf;
        k1 = 0;
       
        for l = 1:length(code)      % each trained codebook, compute distortion
            d = disteu(v(2:end,:), code{l}); 
            dist = sum(min(d,[],2)) / size(d,1);
          
            if dist < distmin
                distmin = dist;
                k1 = l;
            end      
        end
       
        msg = sprintf('Speaker %d matches with speaker %d', k, k1);
        disp(msg);
    end
end

function code = train(traindir, n)
    % Speaker Recognition: Training Stage
    %
    % Input:
    %       traindir : string name of directory contains all train sound files
    %       n        : number of train files in traindir
    %
    % Output:
    %       code     : trained VQ codebooks, code{i} for i-th speaker
    %
    % Note:
    %       Sound files in traindir is supposed to be: 
    %                       s1.wav, s2.wav, ..., sn.wav
    % Example:
    %       >> code = train('C:\data\train\', 8);
    
    k = 16;                         % number of centroids required
    
    for i = 1:n                     % train a VQ codebook for each speaker
        file = sprintf('%ss%d.wav', traindir, i);           
        disp(file);
       
        [s, fs] = audioread(file);
        ind = find(s);s = s(ind(1):end);
        v = mfcc(s, fs, []);            % Compute MFCC's
       
        code{i} = vqlbg(v(2:end,:), k);      % Train VQ codebook
    end
    
end