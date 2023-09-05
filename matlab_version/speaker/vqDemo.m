clc;clear;k = 16;
[x1,fs1] = audioread('data\train\s1.wav');c1 = mfcc(x1,fs1,[]);
hold on;axis([-5,5,-6,3]);
d = [c1(6,:);c1(7,:)];plot(c1(6,:),c1(7,:),'b.');
r=vq(d,k);
plot(r(1,:),r(2,:),'r*');

function r=vq(d,k)
    e = 0.01;
    r = mean(d,2);
    for i=1:log2(k)
        r = [r*(1+e), r*(1-e)];
        dpr = 10000;
        while true
            z = disteu(d,r);
            [m,ind] = min(z,[],2);
            t = 0;
            for j = 1:2^i
                r(:, j) = mean(d(:, ind == j), 2); 
                x = disteu(d(:, ind == j), r(:, j)); 
                t = t + sum(x);
            end
            if (((dpr - t)/t) < e)
                break;
            else
                dpr = t;
            end
        end
    end
end
