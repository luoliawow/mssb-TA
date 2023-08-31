clc;clear;origin = load("heightweight.txt");data = origin(:,2:end);
fm = origin(origin(:,1)==0,2:end);m = origin(origin(:,1)==1,2:end);
figure(Name='origin');hold on;title('origin');
plot(fm(:,1),fm(:,2),'bo');plot(m(:,1),m(:,2),'r^');legend('female','male');

k = 2;[ind,C] = kmeans(data,k,Distance="sqeuclidean");clusters = cell(1,k);
for i=1:k clusters{i} = [];end
for i=1:length(data) clusters{ind(i,1)} = [clusters{ind(i,1)};data(i,:)];end

figure(Name='Aggregate');hold on;lins = ["bo","r^"];
for i=1:k plot(clusters{i}(:,1),clusters{i}(:,2),lins(i));end
title('aggregate');legend('female','male');
