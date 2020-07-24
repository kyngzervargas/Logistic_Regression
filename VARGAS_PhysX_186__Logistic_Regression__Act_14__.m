clear all;
% close all;

load banana_ripe.mat
load banana_unripe.mat
load banana_inbet.mat

%% 
% no_ = ones(1,size(banana_ripe,1))*-1;
no_ = zeros(1,size(banana_ripe,1)); %FOR ACT 14
% no_ = ones(1,size(banana,1))*-1;
o_ = ones(1,size(banana_unripe,1));
no_ = no_';
o_ = o_';

%LABEL matrix
d = [o_;no_];
% d = flipud(d);

%Data matrix
data = [banana_ripe;banana_unripe;banana_inbet];
% data = [banana;orange];

%Variables
bias = ones(1,size(data,1));
bias = bias';
n = 0.5; %learning rate

X = [bias,data]; %Data
%%
%WEIGHTS
a_ = 0; b_ = 1; %range
w = (b_-a_).*rand(3,1)/100 + a_;
w = w';
% weights = -1*2.*rand(3,1);
%%

ww = w;
% w = ww;
%% FOR ACT 14
maxIters = 1000;
eps_ = [];
z_ = [];
aa = [];
res = [];
label = [];
SSE = 1;
error = 0.01;
count = 0;

for j = 1:maxIters
% while abs(SSE) > error
for i = 1:length(X)
% for i = 1:22
    if i > 30
        a = (X(i,1).*w(1)) + (X(i,2).*w(2)) + (X(i,3).*w(3)); 
        z = 1/(1+exp(-a));
        aa = [aa;a];
        z_ = [z_;z];
        if z >= 0.90
            label = [label;{'ripe'}];
        elseif z <= 0.10
            label = [label;{'unripe'}];
        else
            label = [label;{'inbet'}];
        end
    else
        a = (X(i,1).*w(1)) + (X(i,2).*w(2)) + (X(i,3).*w(3));
% % Perceptron
%     if a >= 0;
%         z = 1;
%     else 
%         z = -1;
%     end

% % Logistic Function
        z = 1/(1+exp(-a));
        if z >= 0.90
            label = [label;{'ripe'}];
        elseif z <= 0.10
            label = [label;{'unripe'}];
        else
            label = [label;{'inbet'}];
        end
        d_ = d(i);
        eps = (d_-z);
        delta = n* eps.*X(i,:);
%     predictions  = [predictions; delta];
        w = w + delta;
        
        %stores the values
        aa = [aa;a];
        z_ = [z_;z];
        eps_ = [eps_;eps];   
        res = [res;(eps^2)];
    end
        
    
end
    SSE = sum(res);
    
    if SSE <= error
        disp('done');
        break
% %     else
% %         maxIters = maxIters + 1;
    end
    
    label = [];
    eps_ = [];
    z_ = [];
    aa = [];
    res = [];
%     if SSE <= error
%         disp('done');
%         break
% % %     else
% % %         maxIters = maxIters + 1;
%     end
%     count = count + 1;
%     disp(count);
%     if count == 50
%         break 
%     end
% end
end

%% GRAPH
figure;
% scatter((banana_ripe(:,1)),banana_ripe(:,2),'x');
hold on;
% scatter((banana_unripe(:,1)),banana_ripe(:,2),'*');
% scatter(banana(:,1),banana(:,2),'d');
% scatter(normalize(data(:,1),'range'),data(:,2));
bxx = normalize(data(:,1),'range');
scatter((bxx(1:15,1)),data(1:15,2),'x');
scatter((bxx(16:30,1)),data(16:30,2),'*');
scatter((bxx(31:40,1)),data(31:40,2),'d');

xx = linspace(min(X(:,2)),max(X(:,2)));
A = w(2);
B = w(3);
C = -w(1);

m = -A/B;
bb = C/B;
yy = m*xx + bb;

xx = normalize(xx,'range');
% yy = normalize(yy,'range');
% xx_sig = xx;
% yy_sig = yy;
plot(xx,yy);
% plot(xx_sig,yy_sig);
% legend('banana ripe','banana unripe','perceptron','sigmoid', 'Location', 'best');
% legend('banana ripe','banana unripe','sigmoid', 'Location', 'best');
legend('banana ripe','banana unripe','unknowns','decision line', 'Location', 'best');
% legend('apple','orange', 'banana','decision line', 'Location', 'best');
% legend('apple','orange', 'banana', 'Location', 'best');

yscale = 20;
y_min = min(X(:,3))-(max(X(:,3))/yscale);
y_max = max(X(:,3))+(max(X(:,3))/yscale);
ylim([y_min y_max]);
% ylim([-2 2]);

% title('Feature Extraction');
% title('Perceptron');
title('Logistic Regression');
xlabel('Ripeness');
ylabel('Eccentricity');
