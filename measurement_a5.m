%{
 * @Author              : Fantongwen
 * @Date                : 2021-11-26 22:25:45
 * @LastEditTime        : 2021-11-27 21:27:26
 * @LastEditors         : Fantongwen
 * @Description         : 对5列measurenment进行分析
 * @FilePath            : \GalieoE5ResultAnalyze\measurement_a5.m
 * @Copyright (c) 2021
%}

GALS = 0;
GPS = 1;
SYS = GPS;
% 工作区名称
% workspace = "F:\study\g1\M10\Galieo_track\data\";

% 文件名类型
if (SYS == GPS)
    workspace = "G:\20210428\result20211129_GPS\";
    file_type = "sivd_%d_GPS_measurement.txt";
    file_ns = {2,6,19};
end
if (SYS == GALS)
    workspace = "G:\20210428\result20211127_test1\";
    file_ns = {7};
    file_type = "sivd_%d_E5_3_measurement.txt";
end

file_names = cellfun(@(x) workspace+sprintf(file_type, x), file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);
file_datas_fix = cellfun(@(x) fixData(x{5}), file_datas, 'UniformOutput', false);
hold on
cellfun(@(x) plot(x-mean(x(50:end)), '-*'), file_datas_fix, 'UniformOutput', false);
datastds = cellfun(@(x) std(x(50:end)), file_datas_fix, 'UniformOutput', false); % std从50s后计算，剔除异常值
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
    data_type = "%f %f %f %f %f";
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