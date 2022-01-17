clear;
%% 码误差计算
freq_true = 10.23*4/58*2^31;
freq_real = floor(freq_true);
sample_rate = 58E6;
inital_phase = 0;
for i = 1:sample_rate
    inital_phase = mod(inital_phase + freq_real , 2^32);
end
phase_error = inital_phase - 2^32;
phase_error_meter = sample_rate * 0.5 / 2^(32) * 29.305225610948190 / 2;
%% 载波误差计算
clear;
freq_e5bcarrier = -564390.0 + 1.5*10.23e6;
freq_true = freq_e5bcarrier/(58E6)*(2^32);
freq_real = floor(freq_true);
0.5/2^32*58E6*0.248349369584307
%% 
freq_code = 10.23e6;
lambda_code = 29.305225610948190;
freq_IF = -0.56439e6;
freq_subcarrier = 1.5 * 10.23e6;
lambda_e5acarrier = 0.254828048790854;
delta_freq = 5.8 / 100;
freq_bias = 58E6 - 100 * delta_freq : delta_freq : 58E6 + 100 * delta_freq;
time_bias = 1 - 58E6 ./ freq_bias;
bias = (freq_code * lambda_code - (freq_IF - freq_subcarrier) * lambda_e5acarrier) * time_bias;