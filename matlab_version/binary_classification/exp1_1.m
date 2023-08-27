clear;clc;

points = round(RandPoints(-10,10,20));
draw(points);

for i=1:length(points)
    distinguish(points(:,i));
end

function cordinates = RandPoints(inf,sup,len)
    % 生成下界为inf上界为sup的2xlen矩阵
    cordinates = inf + (sup - inf) * rand(2,len);
end

function draw(ps)
    x=-10:1:15;
    y1=x-1;y2=-x+4;y3=0*x+1;
    hold on;plot(x,y1,x,y2,x,y3);
    text(8,10,'d_1(x):-x+y+1=0');text(14,14,'+','fontsize',24,'color','k');text(14,10,'-','fontsize',24,'color','k');
    text(8,-6,'d_2(x):x+y-4=0');text(14,-9,'+','fontsize',24,'color','m');text(14,-11,'-','fontsize',24,'color','m');
    text(-5,1,'d_3(x):y=1');text(-8,0,'+','fontsize',24,'color','b');text(-8,2,'-','fontsize',24,'color','b');
    for i = 1:length(ps)
        p = ps(:,i);x0 = p(1);y0 = p(2);plot(x0,y0,'r*');
        text(x0+0.1,y0-0.2,PointText(x0,y0),'fontsize',8);
    end
    hold off;
end

function distinguish(p)
    pt = PointText(p(1),p(2));
    t = strcat(num2str(d1(p) > 0),num2str(d2 (p) > 0),num2str(d3(p) > 0));
    switch(t)
        case '100', disp(strcat(pt,'属于w1'));
        case '010', disp(strcat(pt,'属于w2'));
        case '001', disp(strcat(pt,'属于w3'));
        case '110', disp(strcat(pt,'属于w1/w2'));
        case '101', disp(strcat(pt,'属于w1/w3'));
        case '011', disp(strcat(pt,'属于w2/w3'));
        otherwise,  disp(strcat(pt,'不属于w1/w2/w3'));
    end
end
% 决策函数d1/d2/d3
function D1 = d1(X) 
    D1 = [-1,1] * X + 1;
end

function D2 = d2(X) 
    D2 = [-1,1] * X - 4;
end

function D3 = d3(X) 
    D3 = [0,-1] * X + 4;
end