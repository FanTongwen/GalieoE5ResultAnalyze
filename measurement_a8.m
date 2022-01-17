%{
 * @Author              : Fantongwen
 * @Date                : 2021-11-25 14:20:47
 * @LastEditTime        : 2021-11-25 15:09:22
 * @LastEditors         : Fantongwen
 * @Description         : 验证载波相位差分码差分是否能反应码环路的误差
 * @FilePath            : \GalieoE5ResultAnalyze\measurement_analyze.m
 * @Copyright (c) 2021
%}

% config
GALS = 0;
GPS = 1;
SYS = GALS;
% 工作区名称
% workspace = "F:\study\g1\M10\Galieo_track\data\";

% 文件名类型
if (SYS == GPS)
    workspace = "G:\20210428\result202112011_1hz_qinghua_nocarrieraid\";
    file_type = "sivd_%d_GPS_measurement.txt";
    file_ns = {7, 8, 11};
end
if (SYS == GALS)
    % workspace = "G:\20210428\result20211031\";
    % file_ns = {7};
    % file_type = "sivd_%d_E5_3_measurement.txt";
    workspace = "G:\20210428\result20211231_0404phasefix_nocarrieraid\";
    file_ns = {7};
    file_type = "sivd_%d_E5_measurement.txt";
    
end

file_names = cellfun(@(x) workspace+sprintf(file_type, x), file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);
file_datas_fix_sc = cellfun(@(x) fixData(x{7}), file_datas, 'UniformOutput', false);
file_datas_fix = cellfun(@(x) fixData(x{8}), file_datas, 'UniformOutput', false);
hold on
cellfun(@(x) plot(x, '-*'), file_datas_fix, 'UniformOutput', false);
hold on
cellfun(@(x) plot(x, '-*'), file_datas_fix_sc, 'UniformOutput', false);
datastds = cellfun(@(x) std(x(100:end)), file_datas_fix, 'UniformOutput', false); % std从50s后计算，剔除异常值
datastds_sc = cellfun(@(x) std(x(100:end)), file_datas_fix_sc, 'UniformOutput', false); % std从50s后计算，剔除异常值
if (SYS == GALS)
    file_labels = cellfun(@(x,y) sprintf("GALS%d std %f (m)", x, y), file_ns, datastds, 'UniformOutput', false);
    file_labels_sc = cellfun(@(x,y) sprintf("GALS%d sc std %f (m)", x, y), file_ns, datastds_sc, 'UniformOutput', false);
end

file_labels = {file_labels{1}, file_labels_sc{1}};
legend(file_labels);
xlabel("time (s)");
ylabel("ccdd (m)")
%% 固定载波相位观测文件 对不同的载噪比下的环路跟踪性能进行测试
%--config--%
clear
workspace_ref = "G:\20210428\result202112011_1hz_qinghua_nocarrieraid\"; %参考载波测量值文件
workspace = "G:\\20210428\\result20220102_0404dbsk_%2ddB10ms\\"; %比较文件
file_type = "sivd_7_E5_measurement.txt";
file_ns = {36, 38, 40, 42, 44, 46, 48};
%----run----%
% 读取被比较文件测量值数据
file_names = cellfun(@(x) sprintf(workspace,x)+file_type, file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);
file_datas_fix_sc = cellfun(@(x) fixData(x{5}), file_datas, 'UniformOutput', false);
file_datas_fix = cellfun(@(x) fixData(x{6}), file_datas, 'UniformOutput', false);
file_datas_fix_carrier = cellfun(@(x) fixData(x{4}), file_datas, 'UniformOutput', false);
% 读取参考文件测量值数据
file_names_ref = workspace_ref+file_type;
file_datas_ref = cellfun(@(x) readFile(x), file_names_ref, 'UniformOutput', false);
file_datas_fix_carrier_ref = cellfun(@(x) fixData(x{4}), file_datas_ref, 'UniformOutput', false);
% 作差
carrier_error = arrayfun(@(x) -x{1} + file_datas_fix_carrier_ref{1}, ...
    file_datas_fix_carrier, 'UniformOutput', false);
sc_error = arrayfun(@(x) -x{1} + file_datas_fix_carrier_ref{1}, ...
    file_datas_fix_sc, 'UniformOutput', false);
code_error = arrayfun(@(x) x{1} + file_datas_fix_carrier_ref{1}, ...
    file_datas_fix, 'UniformOutput', false);
% 标准差
calc_stds = @(y) cellfun(@(x) std(x(100:end)), y, 'UniformOutput', true);
carrier_stds = calc_stds(carrier_error); % std从50s后计算，剔除异常值
sc_stds = calc_stds(sc_error); % std从50s后计算，剔除异常值
code_stds = calc_stds(code_error); % std从50s后计算，剔除异常值
%% 绘制标准差
figure(1)
hold on
plot(cell2mat(file_ns), carrier_stds, "*-")
plot(cell2mat(file_ns), sc_stds, "*-")
plot(cell2mat(file_ns), code_stds, "*-")
ylabel("error (m)")
xlabel("CN0 (dB)")
legend("carrier","sub-carrier","range-code")
title("sub-carrier-aid-method")
hold off
%% 
% sum1 = 0;
% store_1 =zeros(length(file_datas_fix{1})-50+1,1);
% sum2 = 0;
% for i = 50:length(file_datas_fix{1})
%     sum1 = sum1 + file_datas_fix{1}(i);
%     store_1(i-49) = sum1;
% end
%%
% @brief 读文件名输出cell类型的数据
function data = readFile(file_name)
    data_type = "%f %f %f %f %f %f %f %f";
    file_handle = fopen(file_name);
    data = textscan(file_handle, data_type, 'Delimiter', ',');
    fclose(file_handle);
end
% @brief 修复长度大于光毫秒的数据
function data_fix = fixData(data)
light_speed = 299792.458;
data_fix = mod(data, light_speed);
data_fix(data_fix>light_speed/2) = data_fix(data_fix>light_speed/2)-light_speed;
data_fix(data_fix<-light_speed/2) = data_fix(data_fix<-light_speed/2)+light_speed;
end

