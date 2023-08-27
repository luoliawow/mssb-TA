clear;clc;

ps = RandPoints(-5,5,100)';xs = ps(:,1);ys = ps(:,2);
figure(1);plot(xs,ys,'o');

d12 = -2 * xs - 3 * ys - 3;
d13 = -10 * xs - ys - 1;
d23 = - xs + ys - 1;

w1=[];w2=[];w3=[];wir=[];
for i=1:length(ps)
    if (d12(i)>0 && d13(i)>0) w1=[w1;ps(i,:)];
    elseif (d12(i)<0 && d23(i)>0) w2 = [w2;ps(i,:)];
    elseif (d13(i)<0 && d23(i)<0) w3 = [w3;ps(i,:)];
    else wir = [wir;ps(i,:)];
    end
end

figure(2)
x = -5:1:5;y1 = (-2/3)*x -1;y2 = -10*x-1;y3=x+1;
hold on
plot(x,y1,'r',x,y2,'g',x,y3,'b');
axis([-5,5,-5,5]);title('分类结果');%#ok<*SEPEX>
if (~isempty(w1)) plot(w1(:,1),w1(:,2),'o');end
if (~isempty(w2)) plot(w2(:,1),w2(:,2),'*');end
if (~isempty(w3)) plot(w3(:,1),w3(:,2),'^');end
if (~isempty(wir)) plot(wir(:,1),wir(:,2),'.');end
legend('d12(x)=0','d13(x)=0','d23(x)=0','w1','w2','w3','IR');