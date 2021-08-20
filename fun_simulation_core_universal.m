function [Sum_histogram,Sum_0]=fun_simulation_core_universal(Poisson_PDF_total,time_channel_amount,count,T_jump)
%光子计数仿真核心，单触发和多触发通用，返回光子计数分布


%***容错设计，如果累计次数count和时隙总个数time_channel_amount的乘积过大，会造成内存溢出电脑卡死
if (time_channel_amount*count>300000000)
    volume = time_channel_amount*count
    error('【注意】：仿真矩阵元素大于3e8！尝试增大时隙宽度或者减少累计次数');
end

% 建立空矩阵，用于存储每个周期累计得到的光子计数时间戳
Sum = zeros(count,time_channel_amount);

%蒙特卡罗仿真核心
for count1 = 1:count
    j = 1;
    pre_random = rand([1,time_channel_amount]); % 为了加速仿真减少随机数生成函数的调用次数，预先生成time_channel_amount个0-1之间的随机数

    while j <= time_channel_amount;
        if (pre_random(j) >= Poisson_PDF_total(j) )
            j = j + 1; % 如果随机数大于等于了时隙j产生光子计数时间戳的概率，则不做动作，进行下一个时隙
        else
            % 如果随机数小于了时隙j产生光子计数时间戳的概率，则认为这个时隙产生了光子计数，将此时隙的计数值+1，并且受到死区时间影响，需要跳跃T_jump个时隙。
            Sum(count1,j) = 1;
            j = j + T_jump;
        end
    end
end

% 将count次累计得到的光子计数时间戳矩阵按照列的方向求和，得到TCSPC直方图数据Sum_histogram
Sum_histogram = sum(Sum);

%*********容错设计，如果累计次数只有1次，直接返回Sum矩阵的第一行，不需要求和了
Sum_0 = Sum(1,:);
if count == 1    
    Sum_histogram = Sum_0;
end