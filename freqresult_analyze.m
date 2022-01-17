%{
 * @Author              : Fantongwen
 * @Date                : 2021-11-27 21:23:03
 * @LastEditTime        : 2021-11-27 21:29:29
 * @LastEditors         : Fantongwen
 * @Description         : 对frreqresult文件进行分析
 * @FilePath            : \GalieoE5ResultAnalyze\fre qresult_analyze.m
 * @Copyright (c) 2021
%}


workspace = "G:\20210428\result202112013_1hz_bsk_nocarrieraid\";
file_type = "sivd_%d_E5_3_freqresult.txt";
file_ns = {7};
file_names = cellfun(@(x) workspace+sprintf(file_type, x), file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);


%% 固定载波相位观测文件 对不同的积分时间下的环路跟踪性能进行测试
%--config--%
clear
workspace_ref = "G:\20210428\result202112011_1hz_qinghua_nocarrieraid\"; %参考载波测量值文件
workspace = "G:\\20210428\\result20220106_0404bpsk%dms35dB\\"; %比较文件
file_type = "sivd_7_E5_3_freqresult.txt";
file_type_ref = "sivd_7_E5_measurement.txt";
file_ns = {5, 10, 20};
%----run----%
% 读取被比较文件测量值数据
file_names = cellfun(@(x) sprintf(workspace,x)+file_type, file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);


%%





function data = readFile(file_name)
    data_type = "%f %f %f %f %f %f %f %f %f";
    file_handle = fopen(file_name);
    data = textscan(file_handle, data_type, 'Delimiter', ',');
    fclose(file_handle);
end