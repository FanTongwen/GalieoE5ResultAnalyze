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
    workspace = "G:\190301\ifdata\result20211126_3\";
    file_type = "sivd_%d_GPS_measurement.txt";
    file_ns = {7, 8, 11};
end
if (SYS == GALS)
    % workspace = "G:\20210428\result20211031\";
    % file_ns = {7};
    % file_type = "sivd_%d_E5_3_measurement.txt";
    workspace = "G:\20210428\result20211206_03scaid8_nocarrieraid\";
    file_ns = {7};
    file_type = "sivd_%d_E5_measurement.txt";
    
end

file_names = cellfun(@(x) workspace+sprintf(file_type, x), file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);
file_datas_fix = cellfun(@(x) fixData(x{6}), file_datas, 'UniformOutput', false);
hold on
cellfun(@(x) plot(x, '-*'), file_datas_fix, 'UniformOutput', false);
datastds = cellfun(@(x) std(x(100:end)), file_datas_fix, 'UniformOutput', false); % std从50s后计算，剔除异常值
if (SYS == GALS)
    file_labels = cellfun(@(x,y) sprintf("GALS%d std %f (m)", x, y), file_ns, datastds, 'UniformOutput', false);
end
if (SYS == GPS)
    file_labels = cellfun(@(x,y) sprintf("GPS%d std %f (m)", x, y), file_ns, datastds, 'UniformOutput', false);
end
legend(file_labels);
xlabel("time (s)");
ylabel("ccdd (m)")
% @brief 读文件名输出cell类型的数据
function data = readFile(file_name)
    data_type = "%f %f %f %f %f %f";
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

