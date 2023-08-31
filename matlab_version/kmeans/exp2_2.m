clc;clear;data = load("data1.txt");k = 6;
figure(Name='origin');plot3(data(:,1),data(:,2),data(:,3),'b^');
view(3);title('origin');xlabel('x');ylabel('y');zlabel('z');

[ind,C] = kmeans(data,k);clusters = cell(1,k);

for i=1:k clusters{i} = [];end
for i=1:length(data) clusters{ind(i,1)} = [clusters{ind(i,1)};data(i,:)];end
figure(Name='Aggregate');hold on;lins = ["ro","g*","bx","ms","cp","kd"];
view(3);title('Aggregate');xlabel('x');ylabel('y');zlabel('z');
for i=1:k plot3(clusters{i}(:,1),clusters{i}(:,2),clusters{i}(:,3),lins(i));end
