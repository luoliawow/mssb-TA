clc;clear;
X=[-3.9847,-3.5549,-1.2401,-0.9780,-0.7932,-2.8531,-2.7605,-3.7287,-2.5414,-2.2692,-3.4549,-3.0752,-3.9934,2.8792,-0.9780,0.7932,1.1882,3.0682,-1.5799,-1.4885,-0.7431,-0.4221,-1.1186,4.2532];
pw1 = 0.9;pw2 = 0.1;
[R1,R2,result] = testBayers(X,pw1,pw2);

function [R1,R2,result] = testBayers(x,pw1,pw2)
    m = numel(x);
    e1 = -2;a1 = 0.5;e2 = 2;a2 = 2;
    pw1x = (pw1*normpdf(x,e1,a1))./(pw1*normpdf(x,e1,a1)+pw2*normpdf(x,e2,a2));
    pw2x = (pw2*normpdf(x,e2,a2))./(pw1*normpdf(x,e1,a1)+pw2*normpdf(x,e2,a2));
    r = [0,4;4,0];pwx=[pw1x;pw2x];
    R = r * pwx;R1 = R(1,:);R2 = R(2,:);
    result = R1 >= R2;
    
    t = linspace(-5,5,100);
    pw1a = (pw1*normpdf(t,e1,a1))./(pw1*normpdf(t,e1,a1)+pw2*normpdf(t,e2,a2));
    pw2a = (pw2*normpdf(t,e2,a2))./(pw1*normpdf(t,e1,a1)+pw2*normpdf(t,e2,a2));
    pwa = [pw1a;pw2a];RP = r * pwa;
    hold on;plot(t,RP(1,:),'b-',t,RP(2,:),'g-');
    plot(x(~result),-0.1,'b^');plot(x(result),-0.1,'go');
    grid on;legend('normal','abnormal','location','best');title('最小风险决策分类');
end
