clear;clc;

%数据输入初始化.x1:A_f,x2:A_pf,x3 or x4:test data
x1=[
    1.24,1.27;
    1.36,1.74;
    1.38,1.64;
    1.38,1.82;
    1.38,1.90;
    1.40,1.70;
    1.48,1.82;
    1.54,1.82;
    1.56,2.08
    ];
x2=[1.14,1.82;
    1.18,1.96;
    1.20,1.86;
    1.26,2.00;
    1.28,2.00;
    1.30,1.96];
x3=[1.40,2.04];x4=[1.24,1.80;1.28,1.84];
% 初始化并计算权向量
w=[0.1,0.1,0.1];
w=perceptron(x1,x2,w,0.1);

hold on;axis([1,1.8,1,2.5]);
scatter(x1(:,1),x1(:,2),'r','o');
scatter(x2(:,1),x2(:,2),'g','*');
scatter(x3(:,1),x3(:,2),'b','o');
scatter(x4(:,1),x4(:,2),'b','*');
% 使用隐函数的形式,画图函数的表达更为简洁,且更能体现权向量的几何意义
F = @(x,y) w(1)*x+w(2)*y+w(3);
fimplicit(F,'color','b');
xlabel('触角长度');ylabel('翅膀长度');title('感知器算法-蠓虫分类问题');
legend('A_f','A_{pf}','A_f test','A_{pf} test');hold off;

function out = perceptron(x1,x2,w,e)
    [m1,n1] = size(x1);[m2,n2] = size(x2);
    X1 = ones(m1,n1+1);X2 = ones(m2,n2+1);
    X1(:,1:n1)=x1;X2(:,1:n2)=x2;X2=-X2;
    flag = false;
    while flag == false % flag = false表示仍有点分类不正确
        flag = true;
        for i=1:m1
            s = sum(X1(i,:).*w);
            if s <= 0 
                w = w + e * X1(i,:);flag = false;
            end
        end
        
        for i=1:m2
            s = sum(X2(i,:).*w);
            if s <= 0 
                w = w + e * X2(i,:);flag = false;
            end
        end
    end
    out = w;
end