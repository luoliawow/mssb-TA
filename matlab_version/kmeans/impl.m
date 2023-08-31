clc;clear;
data = [2.4,3.8,4.9,4.7;
    3.2,10.2,100.4,12.4;
    4.6,7.8,8.9,9.0;
    10.2,11.2,23.4,24.6];
[m,n]= size(data);cnt = 0;k = 3;

M = cell(1,m);Mold = M;
for i=1:k M{i}=zeros(1,n);end

p = [3,1,2,4];
% p = randperm(m);
for i=1:k M{i}=data(p(i),:);end
while true
    cnt = cnt + 1;
    disp(strcat('第',num2str(cnt),'次迭代'));
    count = zeros(1,k);c = cell(1,k);
    for i=1:k c{i}=zeros(m,n);end

    for i=1:m
        gap = zeros(1,k);
        for d=1:k gap(d) = norm(M{d}-data(i,:));end
        [~,l]=min(gap);
        count(l) = count(l) + 1;
        c{l}(count(l),:) = data(i,:);
    end

    Mold = M;sumvar = 0;
    for i=1:k
        E = 0;
        for j=1:count(i)
            E =  E + sum((M{i}-c{i}(j,:)) .^ 2);
        end
        sumvar = sumvar + E;
    end
    disp(strcat('总体误差平方和为',num2str(sumvar)));
    for i=1:k M{i}=sum(c{i})/count(i);end

    tally = 0;
    for i=1:k
        if abs(Mold{i}-M{i}) < 1e-5
            tally = tally + 1;
        end
    end
    if tally == k break;end
end

celldisp(M);celldisp(c);
%built-in kmeans
[ind,center] = kmeans(data,k)
