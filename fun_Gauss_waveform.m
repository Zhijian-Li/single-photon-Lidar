function data_oringe_waveform = fun_Gauss_waveform(Peak_signal_rate,t,Time_resolution,P_w,L)
% 高斯激光波形的仿真，返回时隙内的平均光电子数data_oringe_waveform
% 20210820

%这里的L是纳秒（已经折算过来的双程飞行时间）
A = Peak_signal_rate*Time_resolution;         % 时隙内平均光子数峰值    %A = N/(Tau*sqrt(2*pi));
Tau = P_w/sqrt(8*log(2));                     % 高斯脉冲的参数tau
d = L;  % 这里的d取得是双程飞行时间
data_oringe_waveform = A*exp( (-1/(2*Tau*Tau)) * (t - d).^2); % 经典的高斯脉冲信号波形

end