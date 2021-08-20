% Single-photon Lidar Monte Carlo simulation
% copyright Zhijian Li,  Nov 11, 2019
% Contact me: lee-charlie@outlook.com
% Latest edit by Zhijian Li, Aug 20, 2021

clc
clear

% 激光雷达工作参数
N_pulse = 3; % 单个回波脉冲包含的平均光电子数
P_w = 10e-9;  % 高斯激光脉冲的FWHM脉宽
noise = 10e6; % 背景噪声速率
range_gate = 100e-9; % 距离门宽度，也就是每个周期系统的工作时间长度。这里的距离门必须大于死区时间！
dead_time = 45e-9; % 探测器死区时间长度
z0 = 5;   % 待测目标距离，米

% 辅助参数
count = 30000;    % 蒙特卡罗仿真的累计次数
L_in_nano_sec = 2*z0/3e8;   % 距离，换算成纳秒
Time_resolution = 100e-12; %设置时隙（代码中的time bin、time channel、time resolution指的是同一个概念）的宽度
t = Time_resolution:Time_resolution:range_gate; %设置一个周期的离散时隙
time_channel_amount = length(t); % 时隙的总个数
T_jump = floor(dead_time/Time_resolution); % 死区时间的屏蔽的时隙个数，

% 生成高斯回波脉冲
Tau = P_w/sqrt(8*log(2)); % 参数Tau
Peak_signal_rate = N_pulse/(Tau*sqrt(2*pi)); % 高斯脉冲峰值光子速率
data_origin_waveform = fun_Gauss_waveform(Peak_signal_rate,t,Time_resolution,P_w,L_in_nano_sec); % 离散时隙时间轴上的不含噪声的高斯回波信号，（每个数据点表示：每个时隙内的接收到的平均光电子数）

% 回波加噪声，得到离散时隙时间轴上含噪的回波信号（每个数据点表示：每个时隙内的接收到的平均光电子数）
data_origin_waveform = data_origin_waveform + noise*Time_resolution; % 每个时隙内的噪声光电子数为noise*Time_resolution，将其添加至回波信号上

% 计算不受死区时间影响的、产生光子计数信号的、原始泊松概率Poisson_PDF
Poisson_PDF_total = 1 - exp(-data_origin_waveform);

% 蒙特卡罗仿真：距离门模式
[Sum_histogram,Sum_0] = fun_simulation_core_universal(Poisson_PDF_total,time_channel_amount,count,T_jump);

% 结果作图
figure(1)
plot(t*1e9,Sum_histogram,'r')
xlabel('Time ns')
ylabel('Photon counts')
title('MC photon count histogram（蒙特卡洛仿真得到的畸变的TCSPC直方图波形）')

figure(2)
plot(t*1e9,data_origin_waveform,'b')
xlabel('Time ns')
ylabel('每个时隙内接收到的平均光电子数')
title('Original waveform（原始接收到的真实光波形）')