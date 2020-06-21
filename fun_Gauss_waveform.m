function data_oringe_waveform = fun_Gauss_waveform(Peak_signal_rate,t,Time_resolution,P_w,L)
%光子计数高斯波形仿真，返回泊松概率下时隙内探测概率分布Poisson_PDF_total，死区时间屏蔽时隙的个数T_jump和单脉冲回波总数N_pulse
%这里的L是纳秒（已经折算过来的双程飞行时间，与其他版本的"距离必须是米"不同）
A = Peak_signal_rate*Time_resolution;                       %时隙内光子数峰值    %A = N/(Tau*sqrt(2*pi));
Tau = P_w/sqrt(8*log(2));                                   %高斯脉冲的一个参数tau
d = L;  % d = 2*L/3e8; 
data_oringe_waveform = A*exp( (-1/(2*Tau*Tau)) * (t - d).^2);
% 
% %优化高斯波形数据，使其在数值分布上按照抛物线中轴严格对称
% [~,Mn0]=find(S==max(S));
% Mn = Mn0(1);
% bb = round(2*P_w/Time_resolution);
%  = S(Mn-bb+1:Mn);
end