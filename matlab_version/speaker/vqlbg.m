function c = vqlbg(d, k)
    % VQLBG Vector quantization using the Linde-Buzo-Gray algorithm
    %
    % Inputs:
    %       d contains training data vectors (one per column)
    %       k is number of centroids required
    %
    % Outputs:
    %       c contains the result VQ codebook (k columns, one for each centroids)
    e = 0.01;
    r = mean(d,2);
    for i=1:log2(k)
        r = [r*(1+e), r*(1-e)];
        dpr = 10000;
        while true
            z = disteu(d,r);
            [~,ind] = min(z,[],2);
            t = 0;
            for j = 1:2^i
                r(:, j) = mean(d(:, find(ind == j)), 2); %#ok<FNDSB>
                x = disteu(d(:, find(ind == j)), r(:, j)); %#ok<FNDSB>
                t = t + sum(x);
            end
            if (((dpr - t)/t) < e)
                break;
            else
                dpr = t;
            end
        end
    end
    
    c = r;
    
end