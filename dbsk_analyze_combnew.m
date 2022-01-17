%{
 * @Author              : Fantongwen
 * @Date                : 2021-12-01 11:38:48
 * @LastEditTime        : 2021-12-04 11:33:02
 * @LastEditors         : Fantongwen
 * @Description         : dbsk新添加了输出量 适应新的格式 验证组合相关的可行性
 * @FilePath            : \GalieoE5ResultAnalyze\dbsk_analyze_combnew.m
 * @Copyright (c) 2021
%}

workspace = "G:\20210428\result20211201_comb_corre\";
file_type = "sivd_%d_E5_dbsk.txt";
file_ns = {7};
file_names = cellfun(@(x) workspace+sprintf(file_type, x), file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);

E5a_carrierphase_last = -double(file_datas{1}{11})/(2^32);
E5a_codephase_last = mod(double(file_datas{1}{12}),2^31)./(2^31)/4;
e5a_diff = E5a_carrierphase_last + 1.555170088*E5a_codephase_last;

E5b_carrierphase_last = double(file_datas{1}{13})/(2^32);
E5b_codephase_last = mod(double(file_datas{1}{14}),2^31)./(2^31)/4;
e5b_diff = E5b_carrierphase_last - 1.444829912*E5b_codephase_last;

double_diff = (-E5a_carrierphase_last+E5b_carrierphase_last)/2-1.5*E5b_codephase_last;
%% t1 
E5a_carrierphase = -double(file_datas{1}{51})/2^32;
E5b_carrierphase = double(file_datas{1}{53})/2^32;
E5b_codephase = mod(double(file_datas{1}{52}),2^31)./4/2^32;
double_diff = (-E5a_carrierphase+E5b_carrierphase)/2-1.5*E5b_codephase;
plot(double_diff,"*");
%% 验证
last = double(file_datas{1}{11})/(2^32);
corre_num = double(file_datas{1}{61});
delta = double(file_datas{1}{56})/(2^32);
result = mod((2^31) + corre_num .* delta, 1.0);
result_ = double(file_datas{1}{51})/(2^32);
plot(result-result_)
%% 实现
% 中频-0.56439Mhz
% 采样率 58Mhz
fe5a = round((1.5*10.23e6+0.56439e6)/(58e6)*(2^32)); % 文章中的fa
fe5b = round((-1.5*10.23e6+0.56439e6)/(58e6)*(2^32)); % 文章中的fb
% fe5a = round((1.5*10.23e6)/(58e6)*(2^32));
% fe5b = round((-1.5*10.23e6)/(58e6)*(2^32));
phi_a_hat = 0;
phi_b_hat = 0;
PHI_a = 0;
PHI_b = 0;
phi_a = zeros(length(file_datas{1}{1})-1,1);
phi_b = zeros(length(file_datas{1}{1})-1,1);
a_phi_a_hat = zeros(length(file_datas{1}{1})-1,1);
a_phi_b_hat = zeros(length(file_datas{1}{1})-1,1);
a_PHI_a_t2_t1 = zeros(length(file_datas{1}{1})-1,1);
a_PHI_b_t2_t1 = zeros(length(file_datas{1}{1})-1,1);
for i = 2:length(file_datas{1}{1})
    % nco记录下一个码片的相关次数
    N = double(file_datas{1}{61}(i));
    % NCO中e5a的载波频率取绝对值 = abs(fe5a + e5a载波(115*10.23MHz)对应的多普勒)
    fcarrier_e5a = double(file_datas{1}{56}(i)); 
    % NCO中e5b的载波频率取绝对值 = abs(fe5b + e5b载波(118*10.23MHz)对应的多普勒)
    fcarrier_e5b = double(file_datas{1}{57}(i));
     
    pcarrier_e5a = -double(file_datas{1}{51}(i));
    pcarrier_e5b = double(file_datas{1}{53}(i));
    % 此时的码相位,由于是在1ms码片处理结束后的采样点，码相位的整数部分为0
    C_t2 = mod(double(file_datas{1}{52}(i)), 2^31)./2; % 范围是0~2^30
    % 对应文章中的∧φa 大于2pi的部分取模舍掉
    phi_a_hat = mod(phi_a_hat + N * fe5a, 2^32);
    % 对应文章中的^φb 大于2pi的部分取模舍掉
    phi_b_hat = mod(phi_b_hat + N * fe5b, 2^32);
    % 对应文章中的ΦE5a
    PHI_a_t2_t1 = N * (fe5a-fcarrier_e5a);
    % 对应文章中的ΦE5b
    PHI_b_t2_t1 = N * (fe5b+fcarrier_e5b);
    % 
    PHI_a = mod(PHI_a+PHI_a_t2_t1, 2^32);
    PHI_b = mod(PHI_b+PHI_b_t2_t1, 2^32);
    
%     phi_a_t2 = phi_a_hat - (PHI_a - PHI_b) / 2 - 1.5 * C_t2;
%     phi_b_t2 = phi_b_hat + (PHI_a - PHI_b) / 2 + 1.5 * C_t2;
    % 下面二式对应莫均公式
    phi_a_t2 = phi_a_hat - (PHI_a_t2_t1 - PHI_b_t2_t1) / 2 - 1.5 * C_t2;
    phi_b_t2 = phi_b_hat + (PHI_a_t2_t1 - PHI_b_t2_t1) / 2 + 1.5 * C_t2;

%     phi_a_t2 = pcarrier_e5a + 116.5 * C_t2;
%     phi_b_t2 = pcarrier_e5b + 116.5 * C_t2;
    
    phi_a_t2 = mod(phi_a_t2, 2^32);
    phi_b_t2 = mod(phi_b_t2, 2^32);
    phi_a(i-1) = phi_a_t2/(2^32)*2*pi;
    phi_b(i-1) = phi_b_t2/(2^32)*2*pi;
    a_phi_a_hat(i-1) = phi_a_hat;
    a_phi_b_hat(i-1) = phi_b_hat;
    a_PHI_a_t2_t1(i-1) = PHI_a_t2_t1;
    a_PHI_b_t2_t1(i-1) = PHI_b_t2_t1;
end
figure(1)
plot(phi_a, "*")
xlabel("samples")
ylabel("phase (rad)")
figure(2)
plot(phi_b, "*")
xlabel("samples")
ylabel("phase (rad)")
figure(3)
plot(phi_a-phi_b, "*")
xlabel("samples")
ylabel("phase (rad)")
%% debug
ca_pa_last = 2480323072;
cb_pa_last = 2842240187;
sc_pa_last = 2661281629;

ca_ps = 1178043580;
cb_ps = 1094588228;

co_num = 57999;
ca_pa = mod(ca_pa_last + co_num * ca_ps, 2^32);
cb_pa = mod(cb_pa_last + co_num * cb_ps, 2^32);

%% 
function data = readFile(file_name)
data_type = ['%f %f %f %f %f %f %f %f %f %f'...
    '%u %u %u %u'...
    '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d'...
    '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d'...
    '%u %u %u %u'...
    '%u %u %u %u %u %u %u'];
file_handle = fopen(file_name);
data = textscan(file_handle, data_type, 'Delimiter', ',');
fclose(file_handle);
end