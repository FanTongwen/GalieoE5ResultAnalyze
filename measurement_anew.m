%{
 * @Author              : Fantongwen
 * @Date                : 2022-01-08 21:38:29
 * @LastEditTime        : 2022-01-11 16:39:31
 * @LastEditors         : Fantongwen
 * @Description         : 基于增长积分时间 码误差不见小的问题 判断积分多普勒如何
 * @FilePath            : \Galieo_trackf:\study\g1\M10\GalieoE5ResultAnalyze\measurement_anew.m
 * @Copyright (c) 2021
%}
%% 
workspace = strrep("G:\20210428\result20220108_bpsk_M10msL5ms\","\","\\"); %比较文件
file_type = "sivd_7_E5_%d_measurement.txt";
f_ns = {1, 3};
f_name = cellfun(@(x) workspace+sprintf(file_type, x), f_ns, 'Uniformoutput', 0);
f_data = cellfun(@(x) readFile(x), f_name, 'Uniformoutput', 0);
n_data = cellfun(@(x) x{1, 5}, f_data, 'Uniformoutput', 0);
accum = @(y) arrayfun(@(x) sum(y(1000:x)), 1000:length(y), 'Uniformoutput', 1);
acc_result = cellfun(@(x) accum(x), n_data, 'Uniformoutput', 0);
acc_dd = acc_result{1} - acc_result{2};
%% load and calc datas
clear
acc_result_bpsk_1msN35dB = loadAccresult("G:\20210428\fixresult20220109_bpsk_M10msL1msN35dB\", 4);
acc_result_bpsk_20msN35dB = loadAccresult("G:\20210428\fixresult20220109_bpsk_M10msL20msN35dB\", 4);
acc_result_bpsk_30msN35dB = loadAccresult("G:\20210428\fixresult20220109_bpsk_M10msL30msN35dB\", 4);
acc_result_bpsk_1msN40dB = loadAccresult("G:\20210428\fixresult20220109_bpsk_M10msL1msN40dB\", 4);
acc_result_bpsk_20msN40dB = loadAccresult("G:\20210428\fixresult20220109_bpsk_M10msL20msN40dB\", 4);
acc_result_bpsk_1msN32dB = loadAccresult("G:\20210428\fixresult20220109_bpsk_M10msL1msN32dB\", 4);
acc_result_bpsk_20msN32dB = loadAccresult("G:\20210428\fixresult20220109_bpsk_M10msL20msN32dB\", 4);
acc_result_bpsk_5ms = loadAccresult("G:\20210428\fixresult20220109_bpsk_M10msL5ms\", 4);
acc_result_bpsk_20msN30dB = loadAccresult("G:\20210428\result20220110_bpsk_M10msL20msN32dB_testcn0\", 4);
acc_result_bpsk_1msN30dB = loadAccresult("G:\20210428\result20220111_bpsk_M10msL1msN30dB\", 4);

acc_result_scaid = arrayfun(@(x) loadAccresult8("G:\20210428\fixresult20220109_scaid_M10msL5ms\", x), ...
    4:6, 'Uniformoutput', 1);
acc_result_dbsk = arrayfun(@(x) loadAccresult8("G:\20210428\fixresult20220109_dbsk_M10msL5ms\", x), ...
    4:6, 'Uniformoutput', 1);
%% verify the bpsk's subcarrier precision
stairs(acc_result_bpsk{1} - acc_result_bpsk{2});
%% the length of integration and difference of diffrent cn0
bias = -1.831596e5;
stairs(acc_result_bpsk_1msN35dB{1} + acc_result_scaid{2} - bias);
hold on
stairs(acc_result_bpsk_20msN35dB{1} + acc_result_scaid{2} - bias);
stairs(acc_result_bpsk_30msN35dB{1} + acc_result_scaid{2} - bias);
stairs(acc_result_bpsk_1msN32dB{1} + acc_result_scaid{2} - bias);
stairs(acc_result_bpsk_20msN32dB{1} + acc_result_scaid{2} - bias);
stairs(acc_result_bpsk_5ms{1} + acc_result_scaid{2} - bias);
stairs(acc_result_dbsk{3} + acc_result_scaid{2} - bias);
stairs(acc_result_scaid{3} + acc_result_scaid{2} - bias);

stairs(acc_result_bpsk_20msN30dB{1} + acc_result_scaid{2} - bias);
stairs(acc_result_bpsk_1msN30dB{1} + acc_result_scaid{2} - bias);
legend("1ms 35dB", "20ms 35dB", "30ms 35dB", "1ms 32dB", "20ms 32dB", "5ms bpsk noiseless", "dbsk noiseless", "scaid noiseless", "20ms bpsk 30dB")
%% plot 2
bias = -1.831596e5;
hold on
stairs(acc_result_bpsk_5ms{1} + acc_result_scaid{2} - bias);
stairs(acc_result_bpsk_20msN30dB{1} + acc_result_scaid{2} - bias);
stairs(acc_result_bpsk_1msN30dB{1} + acc_result_scaid{2} - bias);
legend("5ms bpsk noiseless","20ms bpsk 30dB","1ms bpsk 30dB")
%%
stairs(acc_result_bpsk{1} + acc_result_dbsk{2});
%%
stairs(acc_resultbpsk{1} - acc_result)
%% 
figure(1)
hold on
stairs(acc_result{1});
stairs(acc_result{2});
stairs(acc_result{1} + acc_result{2});
%% ------------1月 1.使用相位差作为对比指标下的实验结果------------
%% --1.1 load the data
clear
acc_result_bpsk_10msN30dB = ...
    loadAccresult("G:\20210428\result20220111_bpsk_M10msL10msN30dB\", 4); %1:e5a 2:e5b
acc_result_scaidL5ms = arrayfun(@(x) ...
    loadAccresult8("G:\20210428\fixresult20220109_scaid_M10msL5ms\", x), ...
    4:6, 'Uniformoutput', 1); %以无噪声环境下的副载波作为基准 reference
acc_result_dbsk_L10msN30dB = arrayfun(@(x) ...
    loadAccresult8("G:\20210428\result20220111_dbsk_M10msL10msN30dB\", x), ...
    4:6, 'Uniformoutput', 1); %相干积分时间10ms 载噪比30dB dbt方法的结果 1:carrier 2:subcarrier 3:code
acc_result_scaid_L10msN30dB = arrayfun(@(x) ...
    loadAccresult8("G:\20210428\result20220111_scaid_M10msL10msN30dB\", x), ...
    4:6, 'Uniformoutput', 1); %相干积分时间10ms 载噪比30dB scaid方法的结果
%% --1.2 plot the figure
bias = -1.831596e5 - 0.5;
figure(1)
hold on
time_stamps = 0.01:0.01:120;
stairs(time_stamps, acc_result_bpsk_10msN30dB{1} + acc_result_scaidL5ms{2} - bias);
stairs(time_stamps, acc_result_dbsk_L10msN30dB{3} + acc_result_scaidL5ms{2} - bias);
stairs(time_stamps, -acc_result_dbsk_L10msN30dB{2} + acc_result_scaidL5ms{2}+566.6);
stairs(time_stamps, acc_result_scaid_L10msN30dB{3} + acc_result_scaidL5ms{2} - bias);
stairs(time_stamps, acc_result_scaidL5ms{3} + acc_result_scaidL5ms{2} - bias);
legend("bpsk-code 30dB", "dbsk-code 30dB", ...
    "dbsk-sc 30dB", "scaid-code 30dB", ...
    "T_{coh}=5ms scaid-code noiseless");
xlabel("time (s)");ylabel("phase error (m)");
%% --1.4 验证无滤波器的结果
acc_result_scaid_L10ms_noSALL = arrayfun(@(x) ...
    loadAccresult8("G:\20210428\result20220117_scaid_M10msL10ms\", x), ...
    4:6, 'Uniformoutput', 1); %相干积分时间10ms 载噪比30dB scaid方法的结果

acc_result_dbskL5ms = arrayfun(@(x) ...
    loadAccresult8("G:\20210428\fixresult20220109_dbsk_M10msL5ms\", x), ...
    4:6, 'Uniformoutput', 1); %以无噪声环境下的副载波作为基准 reference

acc_result_dbskL10ms = arrayfun(@(x) ...
    loadAccresult8("G:\20210428\result20220117_dbt_M10msL10ms\", x), ...
    4:6, 'Uniformoutput', 1); %以无噪声环境下的副载波作为基准 reference

acc_result_scaidL5ms = arrayfun(@(x) ...
    loadAccresult8("G:\20210428\fixresult20220109_scaid_M10msL5ms\", x), ...
    4:6, 'Uniformoutput', 1); %以无噪声环境下的副载波作为基准 reference
bias = -1.831596e5 - 0.5;
figure(1)
hold on
time_stamps = 0.01:0.01:120;
% stairs(time_stamps, acc_result_scaid_L10ms_noSALL{2} - acc_result_scaidL5ms{2});
% stairs(time_stamps, acc_result_dbskL5ms{2} - acc_result_scaidL5ms{2});
% stairs(time_stamps, acc_result_dbskL5ms{2} - acc_result_scaid_L10ms_noSALL{2});
sc_error =  acc_result_dbskL10ms{1} - acc_result_dbskL10ms{2};
sc_error = sc_error - 0.0724*(0.01:0.01:120);
stairs(time_stamps, sc_error);
%% --1.3 generalization at different CN0
%% ----1.3.1 use the function
clear
CN0s = {30, 32, 34, 36, 38, 40, 42, 44, 46, 48};
error4s = cellfun(@(x) LoadPlotAccdata(x), CN0s, "Uniformoutput", 0);
%% 
stds = cellfun(@(x) std(x(:,end-6000:end),0,2), error4s, "Uniformoutput", 0);
stdsmat = cell2mat(stds);
hold on
arrayfun(@(x) plot(30:2:48, stdsmat(x,:), "*-"), 1:4);
legend("BPSK code error","DBT code error", "DBT sc error", "SCAID code error")
xlabel("CN0 (dB)");ylabel("std (m)");
%% ----1.3.2 plot at CN0
figure(1)
hold on
time_stamps = 0.01:0.01:120;
CN0s = {30, 32, 34, 36, 38, 40, 42, 44, 46, 48};
CN0s_str = cellfun(@(x) sprintf("CN0: %d dB", x), CN0s);
for i = 1:4
    figure(i)
    hold on
    cellfun(@(x) stairs(time_stamps, x(i, :)), error4s);
    xlabel("time (s)");ylabel("phase error (m)");
    legend(CN0s_str);
end
%% ----1.3.3 function definition
function result4 = LoadPlotAccdata(CN0)
% ----1.3.1 load the data
CN0s = [30, 32, 34, 36, 38, 40, 42, 44, 46, 48];
bpskstr = "G:\\20210428\\result20220111_bpsk_M10msL10msN%ddB\\";
dbskstr = "G:\\20210428\\result20220111_dbsk_M10msL10msN%ddB\\";
scaidstr = "G:\\20210428\\result20220111_scaid_M10msL10msN%ddB\\";
result_bpsk = ...
    loadAccresult(sprintf(bpskstr, CN0), 4); %1:e5a 2:e5b
acc_result_scaidL5ms = arrayfun(@(x) ...
    loadAccresult8("G:\20210428\fixresult20220109_scaid_M10msL5ms\", x), ...
    4:6, 'Uniformoutput', 1); %以无噪声环境下的副载波作为基准 reference
result_dbsk = arrayfun(@(x) ...
    loadAccresult8(sprintf(dbskstr, CN0), x), ...
    4:6, 'Uniformoutput', 1); %相干积分时间10ms 载噪比30dB dbt方法的结果 1:carrier 2:subcarrier 3:code
result_scaid = arrayfun(@(x) ...
    loadAccresult8(sprintf(scaidstr, CN0), x), ...
    4:6, 'Uniformoutput', 1); %相干积分时间10ms 载噪比30dB scaid方法的结果
% ----1.3.2 plot the figure
bias = -1.831596e5 - 0.5;
figure(find(CN0s==CN0))
time_stamps = 0.01:0.01:120;
hold on
bpsk_code_error = result_bpsk{1} + acc_result_scaidL5ms{2} - bias;
dbsk_code_error = result_dbsk{3} + acc_result_scaidL5ms{2} - bias;
dbsk_sc_error = -result_dbsk{2} + acc_result_scaidL5ms{2};
dbsk_sc_error = dbsk_sc_error - mean(dbsk_sc_error(end-1000:end));
scaid_code_error = result_scaid{3} + acc_result_scaidL5ms{2} - bias;

stairs(time_stamps, bpsk_code_error);
stairs(time_stamps, dbsk_code_error);
stairs(time_stamps, dbsk_sc_error);
stairs(time_stamps, scaid_code_error);
stairs(time_stamps, acc_result_scaidL5ms{3} + acc_result_scaidL5ms{2} - bias);
legends = ["bpsk-code %ddB", ...
    "dbsk-code %ddB", ...
    "dbsk-sc %ddB", ...
    "scaid-code %ddB", ...
    "T_{coh}=5ms scaid-code noiseless"];
legends1 = arrayfun(@(x) sprintf(x, CN0), legends, "Uniformoutput", 0);
legend(legends1);
xlabel("time (s)");ylabel("phase error (m)");
hold off
result4 = [bpsk_code_error; dbsk_code_error; dbsk_sc_error; scaid_code_error];
end
%% ------------1月 1.使用相位差作为对比指标下的实验结果------------
%% 
function data = readFile(file_name)
    data_type = "%f %f %f %f %f";
    file_handle = fopen(file_name);
    data = textscan(file_handle, data_type, 'Delimiter', ',');
    fclose(file_handle);
end

function data = readFile8(file_name)
    data_type = "%f %f %f %f %f %f %f %f %f";
    file_handle = fopen(file_name);
    data = textscan(file_handle, data_type, 'Delimiter', ',');
    fclose(file_handle);
end

function acc_result = loadAccresult(file_name, n)
    workspace1 = strrep(file_name, "\","\\");
    file_type = "sivd_7_E5_%d_measurement.txt";
    f_ns = {1, 3};
    f_name = cellfun(@(x) workspace1+sprintf(file_type, x), f_ns, 'Uniformoutput', 0);
    f_data = cellfun(@(x) readFile(x), f_name, 'Uniformoutput', 0);
    n_data = cellfun(@(x) x{1, n}, f_data, 'Uniformoutput', 0);
    accum = @(y) arrayfun(@(x) sum(y(1:x)), 1:length(y), 'Uniformoutput', 1);
    acc_result = cellfun(@(x) accum(x), n_data, 'Uniformoutput', 0);
end

function acc_result = loadAccresult8(file_name, n)
    workspace1 = strrep(file_name, "\","\\");
    file_type = "sivd_7_E5_measurement.txt";
    f_name = workspace1+file_type;
    f_data = cellfun(@(x) readFile8(x), f_name, 'Uniformoutput', 0);
    n_data = cellfun(@(x) x{1, n}, f_data, 'Uniformoutput', 0);
    accum = @(y) arrayfun(@(x) sum(y(1:x)), 1:length(y), 'Uniformoutput', 1);
    acc_result = cellfun(@(x) accum(x), n_data, 'Uniformoutput', 0);
end

function acc_result = loadAccresult8_sn(file_name, n, svid)
    workspace1 = strrep(file_name, "\","\\");
    file_type = sprintf("sivd_%d_E5_measurement.txt", svid);
    f_name = workspace1+file_type;
    f_data = cellfun(@(x) readFile8(x), f_name, 'Uniformoutput', 0);
    n_data = cellfun(@(x) x{1, n}, f_data, 'Uniformoutput', 0);
    accum = @(y) arrayfun(@(x) sum(y(1:x)), 1:length(y), 'Uniformoutput', 1);
    acc_result = cellfun(@(x) accum(x), n_data, 'Uniformoutput', 0);
end