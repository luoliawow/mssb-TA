clear;clc;
iris = load("iris.txt");N = 40;T = 10;%每种样本前N组数据为训练集,T组数据为测试集
chunks = mat2cell(iris(:,2:end-1),[N,T,N,T,N,T]);
% w_i为第i类样本的train set;t_i为第i类样本的test set
w1 = chunks{1,1};w2= chunks{3,1};w3 = chunks{5,1};
t1 = chunks{2,1};t2= chunks{4,1};t3 = chunks{6,1};

cov1 = cov(w1);cov2 = cov(w2);cov3 = cov(w3);
mean1 = mean(w1);mean2 = mean(w2);mean3 = mean(w3);
p1 = 0.5;p2 = 0.5;cnt1 = 0;cnt2 = 0;test = t2;%选t2为测试集
for i=1:T
    g1 = -0.5* (test(i,:)-mean1)/(cov1)*(test-mean1)' + log(p1) - 0.5*log(abs(det(cov1)));
    g2 = -0.5* (test(i,:)-mean2)/(cov2)*(test-mean2)' + log(p2) - 0.5*log(abs(det(cov2)));
    if g1 > g2 cnt1 = cnt1 +1;else cnt2 = cnt2 + 1;end
end
disp(strcat('第1类样本有',num2str(cnt1),'个;第2类样本有',num2str(cnt2),'个'));
