%{
 * @Author              : Fantongwen
 * @Date                : 2022-01-16 13:33:51
 * @LastEditTime        : 2022-01-16 13:44:25
 * @LastEditors         : Fantongwen
 * @Description         : 生成altboc自相关函数动画
 * @FilePath            : \GalieoE5ResultAnalyze\load_altboc_acf.m
 * @Copyright (c) 2021
%}

%% 1.1 load file data\
clear
filename = "G:\20210428\result20220116_scaid_M10msL10ms_Corre9_fixcorre\sivd_7_E5_dbsk.txt";
f_data = readFile(filename);
%% 1.2 process the data
RBPSK_a = f_data(1,15:32);
RBPSK_b = f_data(1,33:50);
Re_RBPSK_a = double(cell2mat(RBPSK_a(1:2:end)));
Im_RBPSK_a = double(cell2mat(RBPSK_a(2:2:end)));
Re_RBPSK_b = double(cell2mat(RBPSK_b(1:2:end)));
Im_RBPSK_b = double(cell2mat(RBPSK_b(2:2:end)));

idex = 1600;
axis_y = 1:-0.25:-1;
axis_0 = zeros(1,9);

phasefix = f_data{63}.';
sca = cell2mat(arrayfun(@(x) (exp((-1.5*x-axis_y*3*pi)*1i)).', phasefix, 'Uniformoutput', 0));
sca1 = cell2mat(arrayfun(@(x) (exp((-1.5*x-axis_y*3*pi)*-1i)).', phasefix, 'Uniformoutput', 0));
%% 1.3 plot the data
% v = VideoWriter('corre_result.avi');
% open(v);
pic_num = 1;
for i = 996:1200
    grid on
    combdata = (Re_RBPSK_a(i, :)+1i*Im_RBPSK_a(i, :)).*sca(:,i).'+...
        (Re_RBPSK_b(i, :)+1i*Im_RBPSK_b(i, :)).*sca1(:,i).';
    
    plot(axis_y, Re_RBPSK_a(i, :)+Re_RBPSK_b(i, :), "*-");
    hold on
    plot(axis_y, Im_RBPSK_a(i, :)+Im_RBPSK_b(i, :), "*-");
    plot(axis_y, real(combdata), "s-");
    plot(axis_y, imag(combdata),  "s-");
    set(xlabel("$\tau\;(code\;chips)$"),...
        'interpreter', 'latex');
    set(ylabel("$correlation\;result$"),...
        'interpreter', 'latex');
    set(legend("$Re(R_{QPSK}(\tau))$", ...
        "$Im(R_{QPSK}(\tau))$", ...
        "$Re(R_{QBOC}(\tau))$", ...
        "$Im(R_{QBOC}(\tau))$"), ...
        'interpreter', 'latex')
    text(-0.8,8*1E4,sprintf("time :%4.2f sec", i/100))
    hold off
    axis([-1 1 -50000 100000])
    grid on
    pause(0.0001);%设置视觉残留时间
    
    set(gcf,'color','white'); %图形背景设为无色
    set(gca,'color','white'); 
    frame=getframe(gcf);                   %录制    
    image = frame2im(frame);
    [image, map] = rgb2ind(image, 256);
    
    if pic_num == 1
        imwrite(image, map, 'correlation.gif','Loopcount',inf,'DelayTime',0.01);
    else
        imwrite(image, map, 'correlation.gif','WriteMode','append','DelayTime',0.01);
    end
    pic_num = pic_num+1;
end
%% 
function data = readFile(file_name)
data_type = ['%f %f %f %f %f %f %f %f %f %f'...
    '%u %u %u %u'...
    '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d'...
    '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d'...
    '%u %u %u %u'...
    '%u %u %u %u %u %u %u %f %f'];
file_handle = fopen(file_name);
data = textscan(file_handle, data_type, 'Delimiter', ',');
fclose(file_handle);
fclose all;
end

%{
%work1.m
%功能：生成导体介质中的平面电磁波的传播动画,并生成elc.avi的视频文件
%E：电场矢量,用红色表示
%H:  磁场矢量,用蓝色表示
%fantongwen修改于2019/5/3
clear;
clc;
close all;%清除历史变量和操作
t=0;%设置初始时间
k=2;
w=10;
y=(0:0.1:30);
l=zeros(size(y));
v = VideoWriter('elc.avi');
open(v);

for i=1:150
    grid on;
    E=cos(w*t-k.*y).*exp(-0.1.*y);%电场表达式
     H=0.3.*cos(w*t-k.*y).*exp(-0.1.*y);%磁场表达式式

    axis([-1 1 5 30 -1 1])
   quiver3(l,y,l,E,l,l,'ShowArrowHead','off','Color','r','AutoScaleFactor',1);
    hold on;
    axis([-1 1 5 30 -1 1])
   quiver3(l,y,l,l,l,H,'ShowArrowHead','off','Color','b','AutoScaleFactor',1);
    view(i,i)
    title('电磁波传播动画');
    xlabel('H（蓝色）,x');
    ylabel('y');zlabel('E（红色）,z'); 
    pause(0.1);%设置视觉残留时间
    frame=getframe(gcf);%录制   
    writeVideo(v,frame);
    t=t+0.03;    %设置时间仿真步长
    hold off;
end
close(v)
%% 
%左旋圆极化波
clear all；clc;close all;
x=(0:0.3:30);                                       %初始位置                      
l=zeros(size(x));                    
t=0;     
v = VideoWriter('leftelc.avi');
open(v);
%时间变量
for i=1:150                                       %帧数                                                       
   ey=cos(2*pi*t-0.8*x);                            %电场横向分量
   ez=cos(2*pi*t-0.8*x+pi/2);                            %电场纵向分量
   quiver3(x,l,l,l,ey,ez);                 %画矢量图
   title('左旋圆极化波');               %标题
   xlabel('x');                       %x标签
   ylabel('y');                       %y标签   
   zlabel('z');                      %z标签      
   axis([0,30,-4,4,-4,4]);   view(20,40);                        %观察范围
  pause(0.001);                                    %延时 

 frame=getframe(gcf);                   %录制     
    writeVideo(v,frame);
  t=t+0.01;                                        
end
hold off;   
close(v)
%}