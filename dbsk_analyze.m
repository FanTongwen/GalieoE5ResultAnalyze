%{
 * @Author              : Fantongwen
 * @Date                : 2021-12-04 11:31:59
 * @LastEditTime        : 2021-12-04 11:36:23
 * @LastEditors         : Fantongwen
 * @Description         : 
 * @FilePath            : \GalieoE5ResultAnalyze\dbsk_analyze.m
 * @Copyright (c) 2021
%}

workspace = "G:\20210428\result20220117_dbt_M10msL10ms\";
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
    '%u %u %u %u %u %u %u %u'...
    '%f %f'];
file_handle = fopen(file_name);
data = textscan(file_handle, data_type, 'Delimiter', ',');
fclose(file_handle);
end