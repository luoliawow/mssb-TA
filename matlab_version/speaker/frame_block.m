function frames = frame_block(x,N,M)
    frames = [];curr = 1;len = length(x);
    while curr+N-1 < len
        frame = x(curr:curr+N-1);
        curr = curr + M;frames = [frames,frame];
    end
    frame_len = len-curr+1;frame = zeros(N,1);
    frame(1:frame_len) = x(curr:end);frames = [frames,frame];
end