function [Sum_picture,Sum_0]=fun_simulation_core_universal(Poisson_PDF_total,count,T_jump)
%光子计数仿真核心，单触发和多触发通用，返回光子计数分布

%获取时隙个数time_channel_amount
time_channel_amount = length(Poisson_PDF_total);

%***容错设计，如果累计次数count和时隙个数time_channel_amount的乘积过大，会造成内存溢出电脑卡死
if (time_channel_amount*count>300020000)
    volume = time_channel_amount*count
    error('【注意】：仿真矩阵元素大于3e8！尝试减少分辨率或者累计次数');
end

time_channel_amount = length(Poisson_PDF_total);
Sum = zeros(count,time_channel_amount);

%蒙特卡罗仿真核心
cmp_PDF = Poisson_PDF_total * 1e9;
for count1 = 1:count
    j = 1;
    pre_random = rand([1,time_channel_amount]);
    pre_random = pre_random*1e9;
    while j <= time_channel_amount;
        if (pre_random(j) >= cmp_PDF(j) )
            j = j + 1;
        else
            Sum(count1,j) = 1;
            j = j + T_jump;
        end
    end
end

%*********容错设计，如果累计次数只有1次，返回Sum_0
Sum_picture = sum(Sum);
Sum_0 = Sum(1,:);
if count == 1
    Sum_picture = Sum_0;
end