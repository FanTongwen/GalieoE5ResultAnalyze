%{
 * @Author              : Fantongwen
 * @Date                : 2021-11-29 12:15:12
 * @LastEditTime        : 2021-11-30 20:14:01
 * @LastEditors         : Fantongwen
 * @Description         : 对dbsk信号进行分析
 * @FilePath            : \GalieoE5ResultAnalyze\dbsk_analyze_comb.m
 * @Copyright (c) 2021
%}


workspace = "G:\20210428\result20211129_comb_corre\";
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
function data = readFile(file_name)
data_type = ['%f %f %f %f %f %f %f %f %f %f'...
    '%u %u %u %u'...
    '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d'...
    '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d'];
file_handle = fopen(file_name);
data = textscan(file_handle, data_type, 'Delimiter', ',');
fclose(file_handle);
end