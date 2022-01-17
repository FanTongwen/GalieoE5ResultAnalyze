%{
 * @Author              : Fantongwen
 * @Date                : 2021-11-27 21:23:03
 * @LastEditTime        : 2021-11-27 21:29:29
 * @LastEditors         : Fantongwen
 * @Description         : ��frreqresult�ļ����з���
 * @FilePath            : \GalieoE5ResultAnalyze\fre qresult_analyze.m
 * @Copyright (c) 2021
%}


workspace = "G:\20210428\result202112013_1hz_bsk_nocarrieraid\";
file_type = "sivd_%d_E5_3_freqresult.txt";
file_ns = {7};
file_names = cellfun(@(x) workspace+sprintf(file_type, x), file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);


%% �̶��ز���λ�۲��ļ� �Բ�ͬ�Ļ���ʱ���µĻ�·�������ܽ��в���
%--config--%
clear
workspace_ref = "G:\20210428\result202112011_1hz_qinghua_nocarrieraid\"; %�ο��ز�����ֵ�ļ�
workspace = "G:\\20210428\\result20220106_0404bpsk%dms35dB\\"; %�Ƚ��ļ�
file_type = "sivd_7_E5_3_freqresult.txt";
file_type_ref = "sivd_7_E5_measurement.txt";
file_ns = {5, 10, 20};
%----run----%
% ��ȡ���Ƚ��ļ�����ֵ����
file_names = cellfun(@(x) sprintf(workspace,x)+file_type, file_ns, 'UniformOutput', false);
file_datas = cellfun(@(x) readFile(x), file_names, 'UniformOutput', false);


%%





function data = readFile(file_name)
    data_type = "%f %f %f %f %f %f %f %f %f";
    file_handle = fopen(file_name);
    data = textscan(file_handle, data_type, 'Delimiter', ',');
    fclose(file_handle);
end