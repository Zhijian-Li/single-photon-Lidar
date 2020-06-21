% Single-photon Lidar Monte Carlo simulation
% copyright Zhijian Li,  Nov 11, 2019
% I can be reached at: lee-charlie@outlook.com

clc
clear

% Lidar working parameters
N_pulse = 1; % 单脉冲光子数
P_w = 10e-9;           % 脉宽
noise = 10e6; %噪声速率
range_gate = 100e-9; %距离门宽度。这里的距离门必须大于死区时间！
dead_time = 45e-9; %死区时间长度
z0 = 10;   % 待测目标距离，米

% 辅助参数
count = 10000;    % 蒙特卡罗仿真次数
L_in_nano_sec = 2*z0/3e8;   % 距离，换算成ns
Time_resolution = 100e-12; %设置时隙（bin）的宽度
t = Time_resolution:Time_resolution:range_gate; %设置一个周期的离散时隙
T_jump = floor(dead_time/Time_resolution); % 死区时间的作用区间
time_channel_amount = length(t);

% 生成高斯回波脉冲
Tau = P_w/sqrt(8*log(2));
Peak_signal_rate = N_pulse/(Tau*sqrt(2*pi)); % 高斯脉冲峰值光子速率
data_origin_waveform = fun_Gauss_waveform(Peak_signal_rate,t,Time_resolution,P_w,L_in_nano_sec);
% 回波加噪声
data_origin_waveform = data_origin_waveform + noise*Time_resolution;
% 计算不含死区时间的原始 Poisson_PDF
Poisson_PDF_total = 1 - exp(-data_origin_waveform);
% 蒙特卡罗仿真：距离门模式
[Sum_histogram_rangegate,Sum_0]=fun_simulation_core_universal(Poisson_PDF_total,count,T_jump);

figure(1)
plot(t*1e9,Sum_histogram_rangegate,'r')
xlabel('Time ns')
ylabel('Photon counts')
title('MC photon count histogram')

figure(2)
plot(t*1e9,data_origin_waveform,'b')
xlabel('Time ns')
ylabel('a.u.')
title('Original waveform')