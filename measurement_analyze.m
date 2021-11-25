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
% 工作区名称
workspace = "F:\study\g1\M10\Galieo_track\data\";
% 文件名类型
% file_type = "GPS%d_measurement.txt";
file_type = "sivd_%d_GPS_measurement.txt";
file_ns = {7, 8, 11};

file_names = cellfun(@(x) workspace+sprintf(file_type, x), file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);
file_datas_fix = cellfun(@(x) fixData(x{5}), file_datas, 'UniformOutput', false);
hold on
cellfun(@(x) plot(x, '-*'), file_datas_fix, 'UniformOutput', false);
datastds = cellfun(@(x) std(x(50:end)), file_datas_fix, 'UniformOutput', false);
file_labels = cellfun(@(x,y) sprintf("GPS%d std %f", x, y), file_ns, datastds, 'UniformOutput', false);
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

