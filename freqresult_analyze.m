%{
 * @Author              : Fantongwen
 * @Date                : 2021-11-27 21:23:03
 * @LastEditTime        : 2021-11-27 21:29:29
 * @LastEditors         : Fantongwen
 * @Description         : 对frreqresult文件进行分析
 * @FilePath            : \GalieoE5ResultAnalyze\fre qresult_analyze.m
 * @Copyright (c) 2021
%}


workspace = "G:\20210428\result20211127_test1\";
file_type = "sivd_%d_E5_1_freqresult.txt";
file_ns = {7};
file_names = cellfun(@(x) workspace+sprintf(file_type, x), file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);











function data = readFile(file_name)
    data_type = "%f %f %f %f %f %f %f %f %f %f %f";
    file_handle = fopen(file_name);
    data = textscan(file_handle, data_type, 'Delimiter', ',');
    fclose(file_handle);
end