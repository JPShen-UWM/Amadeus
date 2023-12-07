/////////////////////////////////////////////////////////////
// Created by: Synopsys Design Compiler(R)
// Version   : T-2022.03-SP3
// Date      : Thu Dec  7 14:22:43 2023
/////////////////////////////////////////////////////////////


module pe ( clk, rst, mode_in, change_mode, ifmap_packet, filter_packet, 
        op_stage_in, psum_in, psum_ack_in, conv_continue, psum_out, 
        psum_ack_out, conv_done, error, full );
  input [1:0] mode_in;
  input [37:0] ifmap_packet;
  input [37:0] filter_packet;
  input [1:0] op_stage_in;
  input [14:0] psum_in;
  output [14:0] psum_out;
  input clk, rst, change_mode, psum_ack_in, conv_continue;
  output psum_ack_out, conv_done, error, full;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85,
         N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96, N97, N98, N99,
         N100, N101, N102, N103, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N118, N119, N120, N121,
         N122, N123, N124, N125, N126, N127, N128, N129, N130, N131, N132,
         N133, N134, N135, N136, N137, N138, N139, N140, N141, N142, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, N168, N169, N170, N171, N172, N173, N174, N175, N176,
         N177, N178, N179, N180, N181, N182, N183, N184, N185, N186, N187,
         N188, N189, N190, N191, N192, N193, N194, N195, N196, N197, N198,
         N199, N200, N201, N202, N203, N204, N205, N206, N207, N208, N209,
         N210, N211, N212, N213, N214, N215, N216, N217, N218, N219, N220,
         N221, N222, N223, N224, N225, N226, N227, N228, N229, N230, N231,
         N232, N233, N234, N235, N236, N237, N238, N239, N240, N241, N242,
         N243, N244, N245, N246, N247, N248, N249, N250, N251, N252, N253,
         N254, N255, N256, N257, N258, N259, N260, N261, N262, N263, N264,
         N265, N266, N267, N268, N269, N270, N271, N272, N273, N274, N275,
         N276, N277, N278, N279, N280, N281, N282, N283, N284, N285, N286,
         N287, N288, N289, N290, N291, N292, N293, N294, N295, N296, N297,
         N298, N299, N300, N301, N302, N303, N304, N305, N306, N307, stall,
         conv_cnt_inc, N308, N309, N310, N311, N312, N313, N314, N315, N316,
         N317, N318, N319, N320, N321, N322, N323, N324, N325, N326, N327,
         N328, N329, N330, N331, N332, N333, N334, N335, N336, N337, N338,
         N339, N340, N341, N342, N343, N344, N345, N346, N347, N348, N349,
         N350, N351, N352, N353, N354, N355, N356, N357, N358, N359, N360,
         N361, N362, N363, N364, N365, N366, N367, N368, N369, N370, N371,
         N372, N373, N374, N375, N376, N377, N378, N379, N380, N381, N382,
         N383, N384, N385, N386, N387, N388, N389, N390, N391, N392, N393,
         N394, N395, N396, N397, N398, N399, N400, N401, N402, N403, N404,
         N405, N406, N407, N408, N409, N410, N411, N412, N413, N414, N415,
         N416, N417, N418, N419, N420, N421, N422, N423, N424, N425, N426,
         N427, N428, N429, N430, N431, N432, N433, N434, N435, N436, N437,
         N438, N439, N440, N441, N442, N443, N444, N445, conv_done_soon, N446,
         N447, N448, N449, N450, N451, N452, N453, N454, packet_in_valid, N455,
         N456, N457, N458, N459, N460, N461, N462, N463, N464, N465, N466,
         N467, N468, N469, N470, N471, N472, N473, N474, N475, N476, N477,
         N478, N479, N480, N481, N482, N483, N484, N485, N486, N487, N488,
         N489, N490, N491, N492, N493, N494, N495, N496, N497, N498, N499,
         N500, N501, N502, N503, N504, N505, N506, N507, N508, N509, N510,
         N511, N512, N513, N514, N515, N516, N517, N518, N519, N520, N521,
         N522, N523, N524, N525, N526, N527, N528, N529, N530, N531, N532,
         N533, N534, N535, N536, N537, N538, N539, N540, N541, N542, N543,
         N544, N545, N546, N547, N548, N549, N550, N551, N552, N553, N554,
         N555, N556, N557, N558, N559, N560, N561, N562, N563, N564, N565,
         N566, N567, N568, N569, N570, N571, N572, N573, N574, N575, N576,
         N577, N578, N579, N580, N581, N582, N583, N584, N585, N586, N587,
         N588, N589, N590, N591, N592, N593, N594, N595, N596, N597, N598,
         N599, N600, N601, N602, N603, N604, N605, N606, N607, N608, N609,
         N610, N611, N612, N613, N614, N615, N616, N617, N618, N619, N620,
         N621, N622, N623, N624, N625, N626, N627, N628, N629, N630, N631,
         N632, N633, N634, N635, N636, N637, N638, N639, N640, N641, N642,
         N643, N644, N645, N646, N647, N648, N649, N650, N651, N652, N653,
         N654, N655, N656, N657, N658, N659, N660, N661, N662, N663, N664,
         N665, N666, N667, N668, N669, N670, N671, N672, N673, N674, N675,
         N676, N677, N678, N679, N680, N681, N682, N683, N684, N685, N686,
         N687, N688, N689, N690, N691, N692, N693, N694, accum_stall,
         data_valid, N695, N696, N697, N698, N699, N700, N701, N702, N703,
         N704, N705, N706, N707, N708, N709, N710, N711, N712, N713, N714,
         N715, N716, N717, N718, N719, N720, N721, N722, N723, N724, N725,
         N726, N727, N728, N729, N730, N731, N732, N733, N734, N735, N736,
         N737, N738, N739, N740, N741, N742, N743, N744, N745, N746, N747,
         N748, N749, N750, N751, N752, N753, N754, N755, N756, N757, N758,
         N759, N760, N761, N762, N763, N764, N765, N766, N767, N768, N769,
         N770, N771, N772, N773, N774, N775, N776, N777, N778, N779, N780,
         N781, N782, N783, N784, data_valid_mult, data_valid_accum,
         data_valid_wb, N785, N786, N787, N788, N789, N790, N791, N792, N793,
         N794, N795, N796, N797, N798, N799, N800, N801, N802, N803, N804,
         N805, N806, N807, N808, N809, N810, N811, N812, N813, N814, N815,
         N816, N817, N818, N819, N820, N821, N822, N823, N824, N825, N826,
         N827, N828, N829, N830, N831, N832, N833, N834, N835, N836, N837,
         N838, N839, N840, N841, N842, N843, N844, N845, N846, N847, N848,
         N849, N850, N851, N852, N853, N854, N855, N856, N857, N858, N859,
         N860, N861, N862, N863, N864, N865, N866, N867, N868, N869, N870,
         N871, N872, N873, N874, N875, N876, N877, N878, N879, N880, N881,
         N882, N883, N884, N885, N886, N887, N888, N889, N890, N891, N892,
         N893, N894, N895, N896, N897, N898, N899, N900, N901, N902, N903,
         N904, N905, N906, N907, N908, N909, N910, N911, N912, N913, N914,
         N915, N916, N917, N918, N919, N920, N921, N922, N923, N924, N925,
         N926, N927, N928, N929, N930, N931, N932, N933, N934, N935, N936,
         N937, N938, N939, N940, N941, N942, N943, N944, N945, N946, N947,
         N948, N949, N950, N951, N952, N953, N954, N955, N956, N957, N958,
         N959, N960, N961, N962, N963, N964, N965, N966, N967, N968, N969,
         N970, N971, N972, N973, N974, N975, N976, N977, N978, N979, N980,
         N981, N982, N983, N984, N985, N986, N987, N988, N989, N990, N991,
         N992, N993, N994, N995, N996, N997, N998, N999, N1000, N1001, N1002,
         N1003, N1004, N1005, N1006, N1007, N1008, n_1_net__11_, n_1_net__10_,
         n_1_net__9_, n_1_net__8_, n_1_net__7_, n_1_net__6_, n_1_net__5_,
         n_1_net__4_, n_1_net__3_, n_1_net__2_, n_1_net__1_, n_1_net__0_,
         N1009, N1010, N1011, N1012, N1013, N1014, N1015, N1016, N1017, N1018,
         N1019, N1020, N1021, N1022, N1023, N1024, N1025, N1026, N1027, N1028,
         N1029, N1030, N1031, N1032, N1033, N1034, N1035, N1036, N1037, N1038,
         N1039, N1040, N1041, N1042, N1043, N1044, N1045, N1046, N1047, N1048,
         N1049, N1050, N1051, N1052, N1053, N1054, N1055, N1056, N1057, N1058,
         N1059, N1060, N1061, N1062, N1063, N1064, N1065, N1066, N1067, N1068,
         N1069, N1070, N1071, N1072, N1073, N1074, N1075, N1076, N1077, N1078,
         N1079, N1080, N1081, N1082, N1083, N1084, N1085, N1086, N1087, N1088,
         N1089, N1090, N1091, N1092, N1093, N1094, N1095, N1096, N1097, N1098,
         N1099, N1100, N1101, N1102, N1103, N1104, N1105, N1106, N1107, N1108,
         N1109, N1110, N1111, N1112, N1113, N1114, N1115, N1116, N1117, N1118,
         N1119, N1120, N1121, N1122, N1123, N1124, N1125, N1126, N1127, N1128,
         N1129, N1130, N1131, N1132, N1133, N1134, N1135, N1136, N1137, N1138,
         N1139, N1140, N1141, N1142, N1143, N1144, N1145, N1146, N1147, N1148,
         N1149, N1150, N1151, N1152, N1153, N1154, N1155, N1156, N1157, N1158,
         N1159, N1160, N1161, N1162, N1163, N1164, N1165, N1166, N1167, N1168,
         N1169, N1170, N1171, N1172, N1173, N1174, N1175, N1176, N1177, N1178,
         N1179, N1180, N1181, N1182, N1183, N1184, net275, net276, net277,
         net278, net279, net280, net281, net282, MULT_net709, MULT_net708,
         MULT_net707, MULT_net706, MULT_net705, MULT_net704, MULT_net703,
         MULT_net702, MAC_ADDER_N6, MAC_ADDER_N5, MAC_ADDER_N4, MAC_ADDER_N3,
         MAC_ADDER_N2, MAC_ADDER_N1, MAC_ADDER_neg_overflow,
         MAC_ADDER_pos_overflow, MAC_ADDER_N0, ACCUM_ADDER_N6, ACCUM_ADDER_N5,
         ACCUM_ADDER_N4, ACCUM_ADDER_N3, ACCUM_ADDER_N2, ACCUM_ADDER_N1,
         ACCUM_ADDER_neg_overflow, ACCUM_ADDER_pos_overflow, ACCUM_ADDER_N0;
  wire   [1:0] cur_mode;
  wire   [351:0] filter_ram;
  wire   [3:1] max_conv_cnt;
  wire   [1:0] filter_ptr;
  wire   [3:0] conv_cnt;
  wire   [7:0] weight_next;
  wire   [5:0] psum_idx;
  wire   [5:1] psum_idx_max;
  wire   [2:0] section_to_free;
  wire   [3:0] next_start_ptr;
  wire   [3:0] read_ptr;
  wire   [2:0] section_valid;
  wire   [2:0] section_valid_comb;
  wire   [2:0] section_write;
  wire   [95:0] ifmap_ram;
  wire   [3:0] start_ptr;
  wire   [7:0] ifdata_next;
  wire   [7:0] mult_inA;
  wire   [7:0] mult_inB;
  wire   [7:0] mult_out;
  wire   [7:0] mult_out_ff;
  wire   [11:0] adder_inB;
  wire   [11:0] adder_out;
  wire   [11:0] adder_out_ff;
  wire   [5:0] psum_idx_mult;
  wire   [5:0] psum_idx_accum;
  wire   [5:0] psum_idx_wb;
  wire   [1:0] filter_ptr_mult;
  wire   [1:0] filter_ptr_accum;
  wire   [1:0] filter_ptr_wb;
  wire   [3:0] conv_cnt_mult;
  wire   [3:0] conv_cnt_accum;
  wire   [3:0] conv_cnt_wb;
  wire   [47:0] psum_ram;
  wire   [47:0] psum_output_buffer;
  wire   [3:0] psum_post_free_comb;
  wire   [3:0] psum_ready;
  wire   [3:0] psum_ready_comb;
  wire   [11:0] accum_adder_out;
  wire   [12:0] MAC_ADDER_sum_temp;
  wire   [12:0] ACCUM_ADDER_sum_temp;

  \**SEQGEN**  cur_mode_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N143), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(cur_mode[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N141) );
  \**SEQGEN**  cur_mode_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N142), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(cur_mode[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N141) );
  \**SEQGEN**  filter_ram_reg_3__10__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N303), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[351]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__10__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N302), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[350]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__10__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N301), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[349]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__10__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N300), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[348]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__10__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N299), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[347]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__10__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N298), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[346]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__10__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N297), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[345]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__10__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N296), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[344]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__9__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N295), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[343]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__9__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N294), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[342]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__9__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N293), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[341]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__9__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N292), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[340]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__9__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N291), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[339]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__9__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N290), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[338]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__9__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N289), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[337]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__9__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N288), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[336]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__8__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N287), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[335]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__8__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N286), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[334]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__8__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N285), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[333]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__8__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N284), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[332]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__8__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N283), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[331]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__8__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N282), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[330]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__8__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N281), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[329]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__8__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N280), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[328]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__7__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N279), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[327]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__7__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N278), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[326]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__7__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N277), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[325]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__7__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N276), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[324]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__7__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N275), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[323]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__7__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N274), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[322]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__7__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N273), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[321]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__7__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N272), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[320]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__6__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N271), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[319]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__6__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N270), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[318]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__6__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N269), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[317]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__6__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N268), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[316]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__6__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N267), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[315]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__6__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N266), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[314]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__6__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N265), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[313]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__6__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N264), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[312]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__5__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N263), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[311]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__5__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N262), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[310]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__5__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N261), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[309]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__5__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N260), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[308]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__5__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N259), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[307]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__5__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N258), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[306]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__5__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N257), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[305]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__5__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N256), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[304]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__4__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N255), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[303]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__4__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N254), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[302]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__4__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N253), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[301]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__4__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N252), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[300]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__4__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N251), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[299]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__4__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N250), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[298]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__4__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N249), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[297]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__4__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N248), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[296]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__3__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N247), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[295]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__3__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N246), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[294]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__3__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N245), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[293]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__3__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N244), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[292]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__3__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N243), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[291]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__3__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N242), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[290]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__3__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N241), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[289]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__3__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N240), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[288]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__2__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N239), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[287]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__2__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N238), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[286]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__2__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N237), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[285]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__2__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N236), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[284]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__2__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N235), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[283]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__2__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N234), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[282]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__2__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N233), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[281]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__2__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N232), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[280]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__1__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N231), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[279]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__1__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N230), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[278]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__1__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N229), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[277]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__1__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N228), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[276]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__1__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N227), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[275]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__1__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N226), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[274]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__1__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N225), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[273]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__1__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N224), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[272]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__0__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N223), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[271]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__0__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N222), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[270]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__0__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N221), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[269]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__0__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N220), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[268]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__0__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N219), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[267]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__0__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N218), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[266]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__0__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N217), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[265]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_3__0__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N216), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[264]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N306) );
  \**SEQGEN**  filter_ram_reg_2__10__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N303), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[263]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__10__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N302), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[262]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__10__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N301), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[261]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__10__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N300), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[260]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__10__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N299), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[259]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__10__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N298), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[258]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__10__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N297), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[257]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__10__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N296), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[256]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__9__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N295), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[255]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__9__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N294), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[254]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__9__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N293), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[253]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__9__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N292), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[252]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__9__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N291), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[251]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__9__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N290), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[250]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__9__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N289), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[249]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__9__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N288), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[248]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__8__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N287), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[247]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__8__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N286), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[246]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__8__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N285), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[245]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__8__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N284), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[244]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__8__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N283), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[243]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__8__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N282), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[242]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__8__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N281), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[241]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__8__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N280), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[240]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__7__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N279), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[239]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__7__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N278), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[238]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__7__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N277), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[237]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__7__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N276), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[236]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__7__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N275), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[235]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__7__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N274), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[234]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__7__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N273), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[233]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__7__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N272), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[232]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__6__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N271), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[231]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__6__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N270), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[230]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__6__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N269), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[229]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__6__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N268), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[228]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__6__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N267), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[227]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__6__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N266), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[226]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__6__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N265), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[225]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__6__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N264), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[224]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__5__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N263), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[223]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__5__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N262), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[222]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__5__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N261), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[221]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__5__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N260), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[220]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__5__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N259), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[219]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__5__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N258), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[218]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__5__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N257), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[217]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__5__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N256), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[216]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__4__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N255), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[215]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__4__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N254), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[214]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__4__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N253), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[213]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__4__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N252), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[212]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__4__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N251), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[211]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__4__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N250), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[210]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__4__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N249), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[209]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__4__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N248), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[208]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__3__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N247), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[207]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__3__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N246), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[206]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__3__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N245), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[205]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__3__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N244), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[204]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__3__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N243), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[203]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__3__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N242), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[202]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__3__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N241), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[201]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__3__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N240), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[200]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__2__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N239), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[199]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__2__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N238), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[198]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__2__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N237), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[197]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__2__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N236), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[196]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__2__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N235), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[195]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__2__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N234), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[194]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__2__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N233), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[193]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__2__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N232), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[192]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__1__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N231), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[191]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__1__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N230), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[190]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__1__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N229), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[189]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__1__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N228), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[188]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__1__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N227), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[187]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__1__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N226), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[186]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__1__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N225), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[185]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__1__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N224), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[184]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__0__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N223), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[183]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__0__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N222), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[182]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__0__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N221), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[181]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__0__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N220), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[180]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__0__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N219), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[179]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__0__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N218), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[178]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__0__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N217), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[177]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_2__0__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N216), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[176]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N305) );
  \**SEQGEN**  filter_ram_reg_1__10__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N303), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[175]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__10__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N302), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[174]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__10__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N301), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[173]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__10__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N300), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[172]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__10__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N299), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[171]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__10__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N298), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[170]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__10__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N297), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[169]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__10__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N296), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[168]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__9__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N295), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[167]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__9__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N294), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[166]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__9__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N293), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[165]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__9__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N292), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[164]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__9__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N291), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[163]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__9__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N290), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[162]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__9__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N289), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[161]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__9__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N288), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[160]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__8__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N287), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[159]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__8__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N286), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[158]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__8__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N285), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[157]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__8__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N284), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[156]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__8__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N283), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[155]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__8__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N282), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[154]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__8__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N281), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[153]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__8__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N280), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[152]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__7__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N279), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[151]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__7__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N278), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[150]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__7__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N277), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[149]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__7__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N276), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[148]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__7__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N275), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[147]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__7__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N274), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[146]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__7__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N273), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[145]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__7__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N272), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[144]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__6__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N271), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[143]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__6__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N270), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[142]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__6__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N269), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[141]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__6__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N268), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[140]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__6__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N267), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[139]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__6__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N266), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[138]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__6__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N265), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[137]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__6__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N264), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[136]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__5__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N263), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[135]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__5__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N262), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[134]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__5__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N261), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[133]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__5__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N260), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[132]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__5__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N259), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[131]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__5__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N258), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[130]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__5__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N257), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[129]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__5__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N256), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[128]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__4__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N255), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[127]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__4__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N254), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[126]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__4__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N253), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[125]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__4__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N252), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[124]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__4__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N251), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[123]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__4__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N250), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[122]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__4__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N249), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[121]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__4__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N248), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[120]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__3__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N247), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[119]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__3__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N246), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[118]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__3__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N245), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[117]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__3__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N244), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[116]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__3__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N243), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[115]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__3__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N242), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[114]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__3__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N241), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[113]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__3__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N240), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[112]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__2__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N239), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[111]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__2__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N238), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[110]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__2__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N237), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[109]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__2__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N236), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[108]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__2__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N235), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[107]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__2__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N234), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[106]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__2__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N233), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[105]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__2__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N232), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[104]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__1__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N231), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[103]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__1__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N230), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[102]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__1__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N229), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[101]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__1__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N228), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[100]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__1__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N227), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[99]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__1__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N226), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[98]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__1__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N225), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[97]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__1__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N224), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[96]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__0__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N223), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[95]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__0__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N222), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[94]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__0__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N221), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[93]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__0__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N220), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[92]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__0__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N219), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[91]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__0__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N218), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[90]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__0__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N217), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[89]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_1__0__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N216), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[88]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N304) );
  \**SEQGEN**  filter_ram_reg_0__10__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N303), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[87]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__10__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N302), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[86]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__10__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N301), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[85]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__10__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N300), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[84]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__10__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N299), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[83]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__10__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N298), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[82]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__10__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N297), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[81]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__10__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N296), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[80]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__9__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N295), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[79]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__9__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N294), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[78]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__9__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N293), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[77]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__9__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N292), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[76]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__9__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N291), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[75]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__9__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N290), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[74]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__9__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N289), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[73]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__9__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N288), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[72]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__8__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N287), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[71]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__8__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N286), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[70]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__8__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N285), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[69]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__8__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N284), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[68]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__8__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N283), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[67]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__8__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N282), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[66]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__8__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N281), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[65]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__8__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N280), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[64]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__7__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N279), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[63]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__7__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N278), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[62]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__7__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N277), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[61]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__7__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N276), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[60]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__7__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N275), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[59]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__7__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N274), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[58]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__7__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N273), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[57]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__7__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N272), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[56]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__6__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N271), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[55]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__6__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N270), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[54]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__6__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N269), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[53]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__6__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N268), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[52]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__6__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N267), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[51]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__6__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N266), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[50]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__6__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N265), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[49]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__6__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N264), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[48]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__5__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N263), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[47]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__5__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N262), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[46]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__5__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N261), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[45]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__5__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N260), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[44]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__5__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N259), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[43]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__5__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N258), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[42]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__5__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N257), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[41]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__5__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N256), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[40]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__4__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N255), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[39]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__4__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N254), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[38]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__4__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N253), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[37]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__4__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N252), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[36]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__4__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N251), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[35]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__4__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N250), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[34]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__4__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N249), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[33]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__4__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N248), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[32]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__3__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N247), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__3__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N246), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__3__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N245), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__3__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N244), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__3__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N243), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__3__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N242), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__3__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N241), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__3__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N240), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__2__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N239), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__2__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N238), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__2__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N237), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__2__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N236), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__2__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N235), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__2__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N234), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__2__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N233), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__2__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N232), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__1__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N231), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__1__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N230), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__1__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N229), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__1__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N228), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__1__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N227), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__1__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N226), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__1__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N225), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__1__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N224), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__0__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N223), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__0__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N222), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__0__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N221), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__0__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N220), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__0__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N219), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__0__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N218), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__0__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N217), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  \**SEQGEN**  filter_ram_reg_0__0__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N216), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ram[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N215) );
  EQ_UNS_OP eq_113 ( .A(conv_cnt), .B({1'b0, max_conv_cnt, 1'b0}), .Z(N313) );
  \**SEQGEN**  conv_cnt_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N327), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(conv_cnt[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N323) );
  \**SEQGEN**  conv_cnt_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N326), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(conv_cnt[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N323) );
  \**SEQGEN**  conv_cnt_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N325), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(conv_cnt[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N323) );
  \**SEQGEN**  conv_cnt_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N324), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(conv_cnt[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N323) );
  \**SEQGEN**  filter_ptr_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N338), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        filter_ptr[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N336) );
  \**SEQGEN**  filter_ptr_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N337), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        filter_ptr[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N336) );
  EQ_UNS_OP eq_133 ( .A(psum_idx), .B({psum_idx_max, 1'b0}), .Z(N440) );
  EQ_UNS_OP eq_133_2 ( .A(conv_cnt), .B({1'b0, max_conv_cnt, 1'b0}), .Z(N441)
         );
  \**SEQGEN**  conv_done_soon_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        N447), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        conv_done_soon), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N446) );
  \**SEQGEN**  section_valid_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N466), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(section_valid[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  section_valid_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N465), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(section_valid[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  section_valid_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N464), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(section_valid[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_AND2 C1680 ( .A(N472), .B(N473), .Z(N475) );
  GTECH_AND2 C1681 ( .A(N475), .B(N474), .Z(N476) );
  GTECH_OR2 C1683 ( .A(N468), .B(N469), .Z(N477) );
  GTECH_OR2 C1684 ( .A(N477), .B(N474), .Z(N478) );
  GTECH_OR2 C1687 ( .A(N468), .B(N473), .Z(N480) );
  GTECH_OR2 C1688 ( .A(N480), .B(N470), .Z(N481) );
  GTECH_OR2 C1693 ( .A(N480), .B(N474), .Z(N483) );
  GTECH_OR2 C1696 ( .A(N472), .B(N469), .Z(N485) );
  GTECH_OR2 C1697 ( .A(N485), .B(N470), .Z(N486) );
  GTECH_OR2 C1702 ( .A(N485), .B(N474), .Z(N488) );
  GTECH_OR2 C1706 ( .A(N472), .B(N473), .Z(N490) );
  GTECH_OR2 C1707 ( .A(N490), .B(N470), .Z(N491) );
  GTECH_AND2 C1709 ( .A(N468), .B(N469), .Z(N493) );
  GTECH_AND2 C1710 ( .A(N493), .B(N470), .Z(N494) );
  \**SEQGEN**  ifmap_ram_reg_11__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N605), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[95]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_11__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N604), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[94]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_11__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N603), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[93]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_11__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N602), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[92]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_11__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N601), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[91]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_11__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N600), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[90]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_11__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N599), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[89]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_11__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N598), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[88]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_10__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N597), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[87]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_10__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N596), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[86]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_10__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N595), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[85]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_10__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N594), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[84]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_10__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N593), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[83]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_10__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N592), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[82]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_10__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N591), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[81]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_10__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N590), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(ifmap_ram[80]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_9__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N589), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[79]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_9__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N588), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[78]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_9__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N587), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[77]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_9__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N586), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[76]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_9__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N585), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[75]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_9__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N584), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[74]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_9__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N583), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[73]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_9__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N582), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[72]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_8__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N581), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[71]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_8__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N580), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[70]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_8__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N579), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[69]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_8__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N578), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[68]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_8__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N577), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[67]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_8__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N576), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[66]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_8__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N575), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[65]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_8__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N574), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[64]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N573) );
  \**SEQGEN**  ifmap_ram_reg_7__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N572), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[63]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_7__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N571), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[62]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_7__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N570), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[61]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_7__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N569), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[60]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_7__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N568), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[59]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_7__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N567), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[58]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_7__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N566), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[57]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_7__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N565), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[56]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_6__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N564), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[55]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_6__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N563), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[54]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_6__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N562), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[53]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_6__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N561), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[52]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_6__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N560), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[51]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_6__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N559), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[50]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_6__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N558), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[49]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_6__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N557), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[48]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_5__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N556), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[47]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_5__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N555), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[46]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_5__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N554), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[45]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_5__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N553), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[44]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_5__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N552), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[43]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_5__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N551), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[42]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_5__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N550), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[41]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_5__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N549), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[40]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_4__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N548), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[39]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_4__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N547), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[38]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_4__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N546), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[37]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_4__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N545), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[36]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_4__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N544), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[35]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_4__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N543), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[34]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_4__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N542), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[33]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_4__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N541), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[32]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N540) );
  \**SEQGEN**  ifmap_ram_reg_3__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N539), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_3__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N538), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_3__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N537), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_3__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N536), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_3__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N535), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_3__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N534), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_3__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N533), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_3__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N532), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_2__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N531), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_2__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N530), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_2__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N529), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_2__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N528), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_2__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N527), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_2__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N526), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_2__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N525), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_2__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N524), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_1__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N523), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_1__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N522), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_1__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N521), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_1__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N520), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_1__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N519), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_1__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N518), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_1__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N517), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_1__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N516), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_0__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N515), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_0__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N514), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_0__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N513), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_0__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N512), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_0__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N511), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_0__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N510), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_0__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N509), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  \**SEQGEN**  ifmap_ram_reg_0__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N508), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        ifmap_ram[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N507) );
  GT_UNS_OP gt_241 ( .A({N620, N619, N618, N617, N616}), .B({1'b1, 1'b0, 1'b1, 
        1'b1}), .Z(N621) );
  GT_UNS_OP gt_236 ( .A({N629, N628, N627, N626, N625}), .B({1'b1, 1'b0, 1'b1, 
        1'b1}), .Z(N630) );
  EQ_UNS_OP eq_249 ( .A(conv_cnt), .B({1'b0, max_conv_cnt, 1'b0}), .Z(N663) );
  \**SEQGEN**  start_ptr_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N672), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        start_ptr[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N668) );
  \**SEQGEN**  start_ptr_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N671), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        start_ptr[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N668) );
  \**SEQGEN**  start_ptr_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N670), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        start_ptr[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N668) );
  \**SEQGEN**  start_ptr_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N669), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        start_ptr[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N668) );
  GEQ_UNS_OP gte_263 ( .A({N680, N679, N678, N677, N676}), .B({1'b1, 1'b1, 
        1'b0, 1'b0}), .Z(N681) );
  \**SEQGEN**  mult_out_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N734), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        mult_out_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N710) );
  \**SEQGEN**  mult_out_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N733), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        mult_out_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N710) );
  \**SEQGEN**  mult_out_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N732), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        mult_out_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N710) );
  \**SEQGEN**  mult_out_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N731), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        mult_out_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N710) );
  \**SEQGEN**  mult_out_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N730), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        mult_out_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N710) );
  \**SEQGEN**  mult_out_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N729), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        mult_out_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N710) );
  \**SEQGEN**  mult_out_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N728), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        mult_out_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N710) );
  \**SEQGEN**  mult_out_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N727), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        mult_out_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N710) );
  \**SEQGEN**  mult_inA_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N718), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inA[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inA_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N717), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inA[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inA_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N716), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inA[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inA_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N715), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inA[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inA_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N714), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inA[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inA_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N713), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inA[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inA_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N712), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inA[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inA_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N711), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inA[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inB_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(N726), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inB[7]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inB_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(N725), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inB[6]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inB_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N724), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inB[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inB_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N723), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inB[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inB_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N722), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inB[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inB_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N721), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inB[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inB_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N720), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inB[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  mult_inB_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N719), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(mult_inB[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N710) );
  \**SEQGEN**  adder_out_ff_reg_11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N750), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(adder_out_ff[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N749), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(adder_out_ff[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N748), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N747), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N746), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N745), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N744), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N743), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N742), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N741), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N740), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  \**SEQGEN**  adder_out_ff_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N739), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        adder_out_ff[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N738) );
  EQ_UNS_OP eq_344 ( .A(conv_cnt), .B({1'b0, max_conv_cnt, 1'b0}), .Z(N752) );
  EQ_UNS_OP eq_345 ( .A(psum_idx), .B({psum_idx_max, 1'b0}), .Z(N758) );
  \**SEQGEN**  psum_idx_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(N778), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_idx[5]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N772) );
  \**SEQGEN**  psum_idx_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(N777), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_idx[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N772) );
  \**SEQGEN**  psum_idx_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(N776), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_idx[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N772) );
  \**SEQGEN**  psum_idx_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(N775), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_idx[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N772) );
  \**SEQGEN**  psum_idx_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(N774), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_idx[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N772) );
  \**SEQGEN**  psum_idx_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(N773), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_idx[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N772) );
  \**SEQGEN**  data_valid_wb_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        N824), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        data_valid_wb), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_mult_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N791), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_mult[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_mult_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N790), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_mult[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_mult_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N789), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_mult[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_mult_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N788), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_mult[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_mult_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N787), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_mult[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_mult_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N786), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_mult[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_accum_reg_5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N797), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_accum[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_accum_reg_4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N796), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_accum[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_accum_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N795), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_accum[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_accum_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N794), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_accum[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_accum_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N793), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_accum[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_accum_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N792), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_idx_accum[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_wb_reg_5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N803), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_idx_wb[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_wb_reg_4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N802), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_idx_wb[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_wb_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N801), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_idx_wb[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_wb_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N800), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_idx_wb[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_wb_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N799), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_idx_wb[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  psum_idx_wb_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N798), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_idx_wb[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  filter_ptr_mult_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N805), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ptr_mult[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  filter_ptr_mult_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N804), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ptr_mult[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  filter_ptr_accum_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N807), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ptr_accum[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  filter_ptr_accum_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N806), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ptr_accum[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  filter_ptr_wb_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N809), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ptr_wb[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  filter_ptr_wb_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N808), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(filter_ptr_wb[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_mult_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N813), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(conv_cnt_mult[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_mult_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N812), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(conv_cnt_mult[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_mult_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N811), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(conv_cnt_mult[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_mult_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N810), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(conv_cnt_mult[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_accum_reg_3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N817), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(conv_cnt_accum[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_accum_reg_2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N816), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(conv_cnt_accum[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_accum_reg_1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N815), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(conv_cnt_accum[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_accum_reg_0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N814), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(conv_cnt_accum[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_wb_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N821), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        conv_cnt_wb[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_wb_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N820), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        conv_cnt_wb[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_wb_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N819), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        conv_cnt_wb[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  conv_cnt_wb_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N818), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        conv_cnt_wb[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  data_valid_mult_reg ( .clear(1'b0), .preset(1'b0), .next_state(
        N822), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        data_valid_mult), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  \**SEQGEN**  data_valid_accum_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(N823), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(data_valid_accum), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N785) );
  EQ_UNS_OP eq_394 ( .A(conv_cnt_wb), .B({1'b0, max_conv_cnt, 1'b0}), .Z(N828)
         );
  \**SEQGEN**  psum_ram_reg_3__11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N892), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[47]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N891), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[46]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N890), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[45]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N889), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[44]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N888), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[43]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N887), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[42]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N886), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[41]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N885), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[40]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N884), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[39]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N883), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[38]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N882), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[37]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_3__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N881), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[36]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N880) );
  \**SEQGEN**  psum_ram_reg_2__11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N879), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[35]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N878), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[34]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N877), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[33]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N876), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[32]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N875), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[31]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N874), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[30]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N873), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[29]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N872), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[28]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N871), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[27]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N870), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[26]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N869), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[25]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_2__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N868), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[24]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N867) );
  \**SEQGEN**  psum_ram_reg_1__11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N866), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[23]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N865), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[22]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N864), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[21]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N863), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[20]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N862), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[19]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N861), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[18]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N860), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[17]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N859), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[16]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N858), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[15]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N857), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N856), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[13]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_1__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N855), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[12]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N854) );
  \**SEQGEN**  psum_ram_reg_0__11_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N853), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[11]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N841) );
  \**SEQGEN**  psum_ram_reg_0__10_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N852), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ram[10]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N841) );
  \**SEQGEN**  psum_ram_reg_0__9_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N851), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[9]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__8_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N850), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[8]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__7_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N849), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[7]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__6_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N848), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[6]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__5_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N847), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[5]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__4_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N846), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N845), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N844), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N843), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  \**SEQGEN**  psum_ram_reg_0__0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N842), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(psum_ram[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(
        N841) );
  EQ_UNS_OP eq_402 ( .A(conv_cnt_wb), .B({1'b0, max_conv_cnt, 1'b0}), .Z(N897)
         );
  \**SEQGEN**  psum_output_buffer_reg_3__11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N956), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[47]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N955), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[46]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N954), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[45]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N953), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[44]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N952), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[43]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N951), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[42]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N950), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[41]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N949), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[40]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N948), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[39]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N947), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[38]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N946), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[37]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_3__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N945), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[36]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N944) );
  \**SEQGEN**  psum_output_buffer_reg_2__11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N943), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[35]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N942), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[34]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N941), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[33]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N940), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[32]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N939), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[31]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N938), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[30]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N937), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[29]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N936), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[28]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N935), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[27]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N934), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[26]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N933), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[25]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_2__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N932), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[24]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N931) );
  \**SEQGEN**  psum_output_buffer_reg_1__11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N930), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[23]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N929), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[22]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N928), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[21]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N927), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[20]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N926), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[19]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N925), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[18]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N924), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[17]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N923), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[16]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N922), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[15]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N921), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[14]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N920), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_1__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N919), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N918) );
  \**SEQGEN**  psum_output_buffer_reg_0__11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N917), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N916), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N915), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N914), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N913), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N912), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N911), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N910), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N909), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N908), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N907), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  \**SEQGEN**  psum_output_buffer_reg_0__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N906), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_output_buffer[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N905) );
  EQ_UNS_OP eq_419 ( .A(conv_cnt_wb), .B({1'b0, max_conv_cnt, 1'b0}), .Z(N979)
         );
  \**SEQGEN**  psum_ready_reg_3_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N1008), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ready[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  psum_ready_reg_2_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N1007), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ready[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  psum_ready_reg_1_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N1006), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ready[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  psum_ready_reg_0_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N1005), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_ready[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  psum_out_reg_valid_ ( .clear(1'b0), .preset(1'b0), .next_state(
        N1028), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(
        psum_out[14]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N1027) );
  \**SEQGEN**  psum_out_reg_filter_idx__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1026), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[13]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_filter_idx__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1025), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[12]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__11_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1024), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[11]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__10_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1023), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[10]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__9_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1022), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[9]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__8_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1021), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[8]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__7_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1020), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[7]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__6_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1019), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[6]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__5_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1018), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[5]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__4_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1017), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[4]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__3_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1016), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[3]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__2_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1015), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[2]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__1_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1014), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[1]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  psum_out_reg_psum__0_ ( .clear(1'b0), .preset(1'b0), 
        .next_state(N1013), .clocked_on(clk), .data_in(1'b0), .enable(1'b0), 
        .Q(psum_out[0]), .synch_clear(1'b0), .synch_preset(1'b0), 
        .synch_toggle(1'b0), .synch_enable(N1012) );
  \**SEQGEN**  conv_done_reg ( .clear(1'b0), .preset(1'b0), .next_state(N1038), 
        .clocked_on(clk), .data_in(1'b0), .enable(1'b0), .Q(conv_done), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(N1037) );
  GTECH_OR2 C2708 ( .A(read_ptr[2]), .B(read_ptr[3]), .Z(N1042) );
  GTECH_OR2 C2709 ( .A(read_ptr[1]), .B(N1042), .Z(N1043) );
  GTECH_OR2 C2710 ( .A(read_ptr[0]), .B(N1043), .Z(N1044) );
  GTECH_NOT I_0 ( .A(N1044), .Z(N1045) );
  GTECH_NOT I_1 ( .A(read_ptr[2]), .Z(N1046) );
  GTECH_OR2 C2713 ( .A(N1046), .B(read_ptr[3]), .Z(N1047) );
  GTECH_OR2 C2714 ( .A(read_ptr[1]), .B(N1047), .Z(N1048) );
  GTECH_OR2 C2715 ( .A(read_ptr[0]), .B(N1048), .Z(N1049) );
  GTECH_NOT I_2 ( .A(N1049), .Z(N1050) );
  GTECH_NOT I_3 ( .A(read_ptr[3]), .Z(N1051) );
  GTECH_OR2 C2718 ( .A(read_ptr[2]), .B(N1051), .Z(N1052) );
  GTECH_OR2 C2719 ( .A(read_ptr[1]), .B(N1052), .Z(N1053) );
  GTECH_OR2 C2720 ( .A(read_ptr[0]), .B(N1053), .Z(N1054) );
  GTECH_NOT I_4 ( .A(N1054), .Z(N1055) );
  GTECH_AND2 C2722 ( .A(filter_ptr[0]), .B(filter_ptr[1]), .Z(N1056) );
  GTECH_OR2 C2723 ( .A(psum_idx_wb[4]), .B(psum_idx_wb[5]), .Z(N1057) );
  GTECH_OR2 C2724 ( .A(psum_idx_wb[3]), .B(N1057), .Z(N1058) );
  GTECH_OR2 C2725 ( .A(psum_idx_wb[2]), .B(N1058), .Z(N1059) );
  GTECH_OR2 C2726 ( .A(psum_idx_wb[1]), .B(N1059), .Z(N1060) );
  GTECH_OR2 C2727 ( .A(psum_idx_wb[0]), .B(N1060), .Z(N1061) );
  GTECH_NOT I_5 ( .A(N1061), .Z(N1062) );
  GTECH_OR2 C2729 ( .A(filter_ptr_wb[0]), .B(filter_ptr_wb[1]), .Z(N1063) );
  GTECH_NOT I_6 ( .A(N1063), .Z(N1064) );
  GTECH_OR2 C2731 ( .A(conv_cnt_wb[2]), .B(conv_cnt_wb[3]), .Z(N1065) );
  GTECH_OR2 C2732 ( .A(conv_cnt_wb[1]), .B(N1065), .Z(N1066) );
  GTECH_OR2 C2733 ( .A(conv_cnt_wb[0]), .B(N1066), .Z(N1067) );
  GTECH_NOT I_7 ( .A(N1067), .Z(N1068) );
  GTECH_OR2 C2735 ( .A(psum_ready[2]), .B(psum_ready[3]), .Z(N1069) );
  GTECH_OR2 C2736 ( .A(psum_ready[1]), .B(N1069), .Z(N1070) );
  GTECH_OR2 C2737 ( .A(psum_ready[0]), .B(N1070), .Z(N1071) );
  GTECH_NOT I_8 ( .A(N1071), .Z(N1072) );
  GTECH_AND2 C2739 ( .A(cur_mode[0]), .B(cur_mode[1]), .Z(N1073) );
  GTECH_OR2 C2740 ( .A(filter_packet[33]), .B(filter_packet[34]), .Z(N1074) );
  GTECH_OR2 C2741 ( .A(filter_packet[32]), .B(N1074), .Z(N1075) );
  GTECH_NOT I_9 ( .A(N1075), .Z(N1076) );
  GTECH_AND2 C2743 ( .A(cur_mode[0]), .B(cur_mode[1]), .Z(N1077) );
  GTECH_NOT I_10 ( .A(N1077), .Z(N1078) );
  GTECH_NOT I_11 ( .A(op_stage_in[1]), .Z(N1079) );
  GTECH_OR2 C2749 ( .A(op_stage_in[0]), .B(N1079), .Z(N1080) );
  GTECH_NOT I_12 ( .A(N1080), .Z(N1081) );
  GTECH_OR2 C2751 ( .A(cur_mode[0]), .B(cur_mode[1]), .Z(N1082) );
  GTECH_NOT I_13 ( .A(N1082), .Z(N1083) );
  GTECH_NOT I_14 ( .A(cur_mode[0]), .Z(N1084) );
  GTECH_OR2 C2754 ( .A(N1084), .B(cur_mode[1]), .Z(N1085) );
  GTECH_NOT I_15 ( .A(N1085), .Z(N1086) );
  GTECH_OR2 C2756 ( .A(ifmap_packet[35]), .B(ifmap_packet[36]), .Z(N1087) );
  GTECH_OR2 C2757 ( .A(ifmap_packet[34]), .B(N1087), .Z(N1088) );
  GTECH_OR2 C2758 ( .A(ifmap_packet[33]), .B(N1088), .Z(N1089) );
  GTECH_OR2 C2759 ( .A(ifmap_packet[32]), .B(N1089), .Z(N1090) );
  GTECH_NOT I_16 ( .A(N1090), .Z(N1091) );
  GTECH_NOT I_17 ( .A(cur_mode[1]), .Z(N1092) );
  GTECH_OR2 C2777 ( .A(cur_mode[0]), .B(N1092), .Z(N1093) );
  GTECH_NOT I_18 ( .A(N1093), .Z(N1094) );
  GTECH_NOT I_19 ( .A(op_stage_in[0]), .Z(N1095) );
  GTECH_OR2 C2780 ( .A(N1095), .B(op_stage_in[1]), .Z(N1096) );
  GTECH_NOT I_20 ( .A(N1096), .Z(N1097) );
  GTECH_AND2 C2785 ( .A(filter_ptr[0]), .B(filter_ptr[1]), .Z(N1098) );
  GTECH_AND2 C2786 ( .A(filter_ptr[0]), .B(filter_ptr[1]), .Z(N1099) );
  GTECH_OR2 C2787 ( .A(read_ptr[2]), .B(read_ptr[3]), .Z(N1100) );
  GTECH_OR2 C2788 ( .A(read_ptr[1]), .B(N1100), .Z(N1101) );
  GTECH_OR2 C2789 ( .A(read_ptr[0]), .B(N1101), .Z(N1102) );
  GTECH_NOT I_21 ( .A(N1102), .Z(N1103) );
  GTECH_OR2 C2792 ( .A(N1046), .B(read_ptr[3]), .Z(N1104) );
  GTECH_OR2 C2793 ( .A(read_ptr[1]), .B(N1104), .Z(N1105) );
  GTECH_OR2 C2794 ( .A(read_ptr[0]), .B(N1105), .Z(N1106) );
  GTECH_NOT I_22 ( .A(N1106), .Z(N1107) );
  GTECH_OR2 C2797 ( .A(read_ptr[2]), .B(N1051), .Z(N1108) );
  GTECH_OR2 C2798 ( .A(read_ptr[1]), .B(N1108), .Z(N1109) );
  GTECH_OR2 C2799 ( .A(read_ptr[0]), .B(N1109), .Z(N1110) );
  GTECH_NOT I_23 ( .A(N1110), .Z(N1111) );
  GTECH_OR2 C2801 ( .A(cur_mode[0]), .B(cur_mode[1]), .Z(N1112) );
  GTECH_NOT I_24 ( .A(N1112), .Z(N1113) );
  GTECH_OR2 C2804 ( .A(N1084), .B(cur_mode[1]), .Z(N1114) );
  GTECH_NOT I_25 ( .A(N1114), .Z(N1115) );
  GTECH_OR2 C2807 ( .A(cur_mode[0]), .B(N1092), .Z(N1116) );
  GTECH_NOT I_26 ( .A(N1116), .Z(N1117) );
  GTECH_NOT I_27 ( .A(next_start_ptr[2]), .Z(N1118) );
  GTECH_OR2 C2810 ( .A(N1118), .B(next_start_ptr[3]), .Z(N1119) );
  GTECH_OR2 C2811 ( .A(next_start_ptr[1]), .B(N1119), .Z(N1120) );
  GTECH_OR2 C2812 ( .A(next_start_ptr[0]), .B(N1120), .Z(N1121) );
  GTECH_NOT I_28 ( .A(N1121), .Z(N1122) );
  GTECH_OR2 C2815 ( .A(N1046), .B(read_ptr[3]), .Z(N1123) );
  GTECH_OR2 C2816 ( .A(read_ptr[1]), .B(N1123), .Z(N1124) );
  GTECH_OR2 C2817 ( .A(read_ptr[0]), .B(N1124), .Z(N1125) );
  GTECH_NOT I_29 ( .A(N1125), .Z(N1126) );
  GTECH_OR2 C2823 ( .A(cur_mode[0]), .B(cur_mode[1]), .Z(N1127) );
  GTECH_NOT I_30 ( .A(N1127), .Z(N1128) );
  GTECH_OR2 C2826 ( .A(N1084), .B(cur_mode[1]), .Z(N1129) );
  GTECH_NOT I_31 ( .A(N1129), .Z(N1130) );
  GTECH_OR2 C2828 ( .A(next_start_ptr[2]), .B(next_start_ptr[3]), .Z(N1131) );
  GTECH_OR2 C2829 ( .A(next_start_ptr[1]), .B(N1131), .Z(N1132) );
  GTECH_OR2 C2830 ( .A(next_start_ptr[0]), .B(N1132), .Z(N1133) );
  GTECH_NOT I_32 ( .A(N1133), .Z(N1134) );
  GTECH_OR2 C2832 ( .A(read_ptr[2]), .B(read_ptr[3]), .Z(N1135) );
  GTECH_OR2 C2833 ( .A(read_ptr[1]), .B(N1135), .Z(N1136) );
  GTECH_OR2 C2834 ( .A(read_ptr[0]), .B(N1136), .Z(N1137) );
  GTECH_NOT I_33 ( .A(N1137), .Z(N1138) );
  GTECH_NOT I_34 ( .A(next_start_ptr[3]), .Z(N1139) );
  GTECH_OR2 C2837 ( .A(next_start_ptr[2]), .B(N1139), .Z(N1140) );
  GTECH_OR2 C2838 ( .A(next_start_ptr[1]), .B(N1140), .Z(N1141) );
  GTECH_OR2 C2839 ( .A(next_start_ptr[0]), .B(N1141), .Z(N1142) );
  GTECH_NOT I_35 ( .A(N1142), .Z(N1143) );
  GTECH_OR2 C2842 ( .A(read_ptr[2]), .B(N1051), .Z(N1144) );
  GTECH_OR2 C2843 ( .A(read_ptr[1]), .B(N1144), .Z(N1145) );
  GTECH_OR2 C2844 ( .A(read_ptr[0]), .B(N1145), .Z(N1146) );
  GTECH_NOT I_36 ( .A(N1146), .Z(N1147) );
  GTECH_OR2 C2847 ( .A(cur_mode[0]), .B(N1092), .Z(N1148) );
  GTECH_NOT I_37 ( .A(N1148), .Z(N1149) );
  GTECH_OR2 C2849 ( .A(filter_ptr[0]), .B(filter_ptr[1]), .Z(N1150) );
  GTECH_NOT I_38 ( .A(N1150), .Z(N1151) );
  GTECH_OR2 C2851 ( .A(cur_mode[0]), .B(cur_mode[1]), .Z(N1152) );
  GTECH_NOT I_39 ( .A(N1152), .Z(N1153) );
  GTECH_OR2 C2854 ( .A(N1084), .B(cur_mode[1]), .Z(N1154) );
  GTECH_NOT I_40 ( .A(N1154), .Z(N1155) );
  ADD_UNS_OP add_263 ( .A(start_ptr), .B(conv_cnt), .Z({N680, N679, N678, N677, 
        N676}) );
  ADD_UNS_OP add_241 ( .A(start_ptr), .B(1'b1), .Z({N620, N619, N618, N617, 
        N616}) );
  ADD_UNS_OP add_263_2 ( .A(start_ptr), .B(conv_cnt), .Z({N686, N685, N684, 
        N683}) );
  ADD_UNS_OP add_263_3 ( .A(start_ptr), .B(conv_cnt), .Z({N694, N693, N692, 
        N691}) );
  SUB_UNS_OP sub_263 ( .A({N686, N685, N684, N683}), .B({1'b1, 1'b1, 1'b0, 
        1'b0}), .Z({N690, N689, N688, N687}) );
  ADD_UNS_OP add_236 ( .A(start_ptr), .B({1'b1, 1'b0, 1'b0}), .Z({N629, N628, 
        N627, N626, N625}) );
  ADD_UNS_OP add_242 ( .A(start_ptr), .B(1'b1), .Z({N660, N659, N658, N657})
         );
  ADD_UNS_OP add_241_S2 ( .A(start_ptr), .B(1'b1), .Z({N652, N651, N650, N649}) );
  SUB_UNS_OP sub_241_S2 ( .A({N652, N651, N650, N649}), .B({1'b1, 1'b1, 1'b0, 
        1'b0}), .Z({N656, N655, N654, N653}) );
  ADD_UNS_OP add_236_S2 ( .A(start_ptr), .B({1'b1, 1'b0, 1'b0}), .Z({N635, 
        N634, N633, N632}) );
  ADD_UNS_OP add_237 ( .A(start_ptr), .B({1'b1, 1'b0, 1'b0}), .Z({N643, N642, 
        N641, N640}) );
  SUB_UNS_OP sub_236_S2 ( .A({N635, N634, N633, N632}), .B({1'b1, 1'b1, 1'b0, 
        1'b0}), .Z({N639, N638, N637, N636}) );
  ADD_UNS_OP add_124 ( .A(filter_ptr), .B(1'b1), .Z({N335, N334}) );
  ADD_UNS_OP add_346 ( .A(psum_idx), .B(1'b1), .Z({N765, N764, N763, N762, 
        N761, N760}) );
  ADD_UNS_OP add_114 ( .A(conv_cnt), .B(1'b1), .Z({N318, N317, N316, N315}) );
  GTECH_AND2 C2872 ( .A(filter_packet[35]), .B(filter_packet[36]), .Z(N154) );
  GTECH_AND2 C2873 ( .A(N0), .B(filter_packet[36]), .Z(N153) );
  GTECH_NOT I_41 ( .A(filter_packet[35]), .Z(N0) );
  GTECH_AND2 C2874 ( .A(filter_packet[35]), .B(N1), .Z(N152) );
  GTECH_NOT I_42 ( .A(filter_packet[36]), .Z(N1) );
  GTECH_AND2 C2875 ( .A(N2), .B(N3), .Z(N151) );
  GTECH_NOT I_43 ( .A(filter_packet[35]), .Z(N2) );
  GTECH_NOT I_44 ( .A(filter_packet[36]), .Z(N3) );
  GTECH_AND2 C2876 ( .A(filter_ptr_wb[0]), .B(filter_ptr_wb[1]), .Z(N836) );
  GTECH_AND2 C2877 ( .A(N4), .B(filter_ptr_wb[1]), .Z(N835) );
  GTECH_NOT I_45 ( .A(filter_ptr_wb[0]), .Z(N4) );
  GTECH_AND2 C2878 ( .A(filter_ptr_wb[0]), .B(N5), .Z(N834) );
  GTECH_NOT I_46 ( .A(filter_ptr_wb[1]), .Z(N5) );
  GTECH_AND2 C2879 ( .A(N6), .B(N7), .Z(N833) );
  GTECH_NOT I_47 ( .A(filter_ptr_wb[0]), .Z(N6) );
  GTECH_NOT I_48 ( .A(filter_ptr_wb[1]), .Z(N7) );
  GTECH_AND2 C2880 ( .A(filter_ptr_wb[0]), .B(filter_ptr_wb[1]), .Z(N840) );
  GTECH_AND2 C2881 ( .A(N8), .B(filter_ptr_wb[1]), .Z(N839) );
  GTECH_NOT I_49 ( .A(filter_ptr_wb[0]), .Z(N8) );
  GTECH_AND2 C2882 ( .A(filter_ptr_wb[0]), .B(N9), .Z(N838) );
  GTECH_NOT I_50 ( .A(filter_ptr_wb[1]), .Z(N9) );
  GTECH_AND2 C2883 ( .A(N10), .B(N11), .Z(N837) );
  GTECH_NOT I_51 ( .A(filter_ptr_wb[0]), .Z(N10) );
  GTECH_NOT I_52 ( .A(filter_ptr_wb[1]), .Z(N11) );
  GTECH_AND2 C2884 ( .A(filter_ptr_wb[0]), .B(filter_ptr_wb[1]), .Z(N904) );
  GTECH_AND2 C2885 ( .A(N12), .B(filter_ptr_wb[1]), .Z(N903) );
  GTECH_NOT I_53 ( .A(filter_ptr_wb[0]), .Z(N12) );
  GTECH_AND2 C2886 ( .A(filter_ptr_wb[0]), .B(N13), .Z(N902) );
  GTECH_NOT I_54 ( .A(filter_ptr_wb[1]), .Z(N13) );
  GTECH_AND2 C2887 ( .A(N14), .B(N15), .Z(N901) );
  GTECH_NOT I_55 ( .A(filter_ptr_wb[0]), .Z(N14) );
  GTECH_NOT I_56 ( .A(filter_ptr_wb[1]), .Z(N15) );
  GTECH_AND2 C2888 ( .A(psum_in[12]), .B(psum_in[13]), .Z(N966) );
  GTECH_AND2 C2889 ( .A(N16), .B(psum_in[13]), .Z(N965) );
  GTECH_NOT I_57 ( .A(psum_in[12]), .Z(N16) );
  GTECH_AND2 C2890 ( .A(psum_in[12]), .B(N17), .Z(N964) );
  GTECH_NOT I_58 ( .A(psum_in[13]), .Z(N17) );
  GTECH_AND2 C2891 ( .A(N18), .B(N19), .Z(N963) );
  GTECH_NOT I_59 ( .A(psum_in[12]), .Z(N18) );
  GTECH_NOT I_60 ( .A(psum_in[13]), .Z(N19) );
  GTECH_AND2 C2892 ( .A(filter_ptr_wb[0]), .B(filter_ptr_wb[1]), .Z(N988) );
  GTECH_AND2 C2893 ( .A(N20), .B(filter_ptr_wb[1]), .Z(N987) );
  GTECH_NOT I_61 ( .A(filter_ptr_wb[0]), .Z(N20) );
  GTECH_AND2 C2894 ( .A(filter_ptr_wb[0]), .B(N21), .Z(N986) );
  GTECH_NOT I_62 ( .A(filter_ptr_wb[1]), .Z(N21) );
  GTECH_AND2 C2895 ( .A(N22), .B(N23), .Z(N985) );
  GTECH_NOT I_63 ( .A(filter_ptr_wb[0]), .Z(N22) );
  GTECH_NOT I_64 ( .A(filter_ptr_wb[1]), .Z(N23) );
  GTECH_AND4 C2896 ( .A(N24), .B(N25), .C(N26), .D(N27), .Z(N429) );
  GTECH_NOT I_65 ( .A(conv_cnt[3]), .Z(N24) );
  GTECH_NOT I_66 ( .A(conv_cnt[2]), .Z(N25) );
  GTECH_NOT I_67 ( .A(conv_cnt[0]), .Z(N26) );
  GTECH_NOT I_68 ( .A(conv_cnt[1]), .Z(N27) );
  GTECH_AND3 C2897 ( .A(conv_cnt[3]), .B(N28), .C(N29), .Z(N430) );
  GTECH_NOT I_69 ( .A(conv_cnt[0]), .Z(N28) );
  GTECH_NOT I_70 ( .A(conv_cnt[1]), .Z(N29) );
  GTECH_AND4 C2898 ( .A(N30), .B(N31), .C(conv_cnt[0]), .D(N32), .Z(N431) );
  GTECH_NOT I_71 ( .A(conv_cnt[3]), .Z(N30) );
  GTECH_NOT I_72 ( .A(conv_cnt[2]), .Z(N31) );
  GTECH_NOT I_73 ( .A(conv_cnt[1]), .Z(N32) );
  GTECH_AND4 C2899 ( .A(N33), .B(N34), .C(N35), .D(conv_cnt[1]), .Z(N433) );
  GTECH_NOT I_74 ( .A(conv_cnt[3]), .Z(N33) );
  GTECH_NOT I_75 ( .A(conv_cnt[2]), .Z(N34) );
  GTECH_NOT I_76 ( .A(conv_cnt[0]), .Z(N35) );
  GTECH_AND3 C2900 ( .A(N36), .B(conv_cnt[0]), .C(conv_cnt[1]), .Z(N435) );
  GTECH_NOT I_77 ( .A(conv_cnt[2]), .Z(N36) );
  GTECH_AND3 C2901 ( .A(conv_cnt[2]), .B(N37), .C(N38), .Z(N436) );
  GTECH_NOT I_78 ( .A(conv_cnt[0]), .Z(N37) );
  GTECH_NOT I_79 ( .A(conv_cnt[1]), .Z(N38) );
  GTECH_AND3 C2902 ( .A(conv_cnt[2]), .B(conv_cnt[0]), .C(N39), .Z(N437) );
  GTECH_NOT I_80 ( .A(conv_cnt[1]), .Z(N39) );
  GTECH_AND3 C2903 ( .A(conv_cnt[2]), .B(N40), .C(conv_cnt[1]), .Z(N438) );
  GTECH_NOT I_81 ( .A(conv_cnt[0]), .Z(N40) );
  GTECH_AND3 C2904 ( .A(conv_cnt[2]), .B(conv_cnt[0]), .C(conv_cnt[1]), .Z(
        N439) );
  GTECH_AND2 C2905 ( .A(conv_cnt[3]), .B(conv_cnt[0]), .Z(N432) );
  GTECH_AND2 C2906 ( .A(conv_cnt[3]), .B(conv_cnt[1]), .Z(N434) );
  GTECH_AND4 C2912 ( .A(N41), .B(N42), .C(N43), .D(N44), .Z(N695) );
  GTECH_NOT I_82 ( .A(read_ptr[3]), .Z(N41) );
  GTECH_NOT I_83 ( .A(read_ptr[2]), .Z(N42) );
  GTECH_NOT I_84 ( .A(read_ptr[0]), .Z(N43) );
  GTECH_NOT I_85 ( .A(read_ptr[1]), .Z(N44) );
  GTECH_AND3 C2913 ( .A(read_ptr[3]), .B(N45), .C(N46), .Z(N696) );
  GTECH_NOT I_86 ( .A(read_ptr[0]), .Z(N45) );
  GTECH_NOT I_87 ( .A(read_ptr[1]), .Z(N46) );
  GTECH_AND4 C2914 ( .A(N47), .B(N48), .C(read_ptr[0]), .D(N49), .Z(N697) );
  GTECH_NOT I_88 ( .A(read_ptr[3]), .Z(N47) );
  GTECH_NOT I_89 ( .A(read_ptr[2]), .Z(N48) );
  GTECH_NOT I_90 ( .A(read_ptr[1]), .Z(N49) );
  GTECH_AND4 C2915 ( .A(N50), .B(N51), .C(N52), .D(read_ptr[1]), .Z(N699) );
  GTECH_NOT I_91 ( .A(read_ptr[3]), .Z(N50) );
  GTECH_NOT I_92 ( .A(read_ptr[2]), .Z(N51) );
  GTECH_NOT I_93 ( .A(read_ptr[0]), .Z(N52) );
  GTECH_AND4 C2916 ( .A(N53), .B(N54), .C(read_ptr[0]), .D(read_ptr[1]), .Z(
        N701) );
  GTECH_NOT I_94 ( .A(read_ptr[3]), .Z(N53) );
  GTECH_NOT I_95 ( .A(read_ptr[2]), .Z(N54) );
  GTECH_AND3 C2917 ( .A(read_ptr[2]), .B(N55), .C(N56), .Z(N703) );
  GTECH_NOT I_96 ( .A(read_ptr[0]), .Z(N55) );
  GTECH_NOT I_97 ( .A(read_ptr[1]), .Z(N56) );
  GTECH_AND3 C2918 ( .A(read_ptr[2]), .B(read_ptr[0]), .C(N57), .Z(N704) );
  GTECH_NOT I_98 ( .A(read_ptr[1]), .Z(N57) );
  GTECH_AND3 C2919 ( .A(read_ptr[2]), .B(N58), .C(read_ptr[1]), .Z(N705) );
  GTECH_NOT I_99 ( .A(read_ptr[0]), .Z(N58) );
  GTECH_AND3 C2920 ( .A(read_ptr[2]), .B(read_ptr[0]), .C(read_ptr[1]), .Z(
        N706) );
  GTECH_AND3 C2921 ( .A(read_ptr[3]), .B(read_ptr[0]), .C(N59), .Z(N698) );
  GTECH_NOT I_100 ( .A(read_ptr[1]), .Z(N59) );
  GTECH_AND3 C2922 ( .A(read_ptr[3]), .B(N60), .C(read_ptr[1]), .Z(N700) );
  GTECH_NOT I_101 ( .A(read_ptr[0]), .Z(N60) );
  GTECH_AND3 C2923 ( .A(read_ptr[3]), .B(read_ptr[0]), .C(read_ptr[1]), .Z(
        N702) );
  SELECT_OP C2928 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b0), .CONTROL1(N61), 
        .CONTROL2(N145), .CONTROL3(N140), .Z(N141) );
  GTECH_BUF B_0 ( .A(rst), .Z(N61) );
  SELECT_OP C2929 ( .DATA1({1'b0, 1'b0}), .DATA2(mode_in), .CONTROL1(N61), 
        .CONTROL2(N145), .Z({N143, N142}) );
  SELECT_OP C2930 ( .DATA1({N154, N153, N152, N151}), .DATA2({1'b0, 1'b0, 1'b0, 
        1'b0}), .CONTROL1(N62), .CONTROL2(N150), .Z({N214, N213, N212, N211})
         );
  GTECH_BUF B_1 ( .A(N149), .Z(N62) );
  SELECT_OP C2931 ( .DATA1({1'b1, 1'b1, 1'b1, 1'b1}), .DATA2({N214, N213, N212, 
        N211}), .DATA3({1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N61), .CONTROL2(
        N307), .CONTROL3(N148), .Z({N306, N305, N304, N215}) );
  SELECT_OP C2932 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({N155, N156, 
        N157, N158, N159, N160, N161, N162, N163, N164, N165, N166, N167, N168, 
        N169, N170, N171, N172, N173, N174, N175, N176, N177, N178, N179, N180, 
        N181, N182, N183, N184, N185, N186, N187, N188, N189, N190, N191, N192, 
        N193, N194, N195, N196, N197, N198, N199, N200, N201, N202, N203, N204, 
        N205, N206, N207, N208, N209, N210, filter_packet[31:0]}), .CONTROL1(
        N61), .CONTROL2(N307), .Z({N303, N302, N301, N300, N299, N298, N297, 
        N296, N295, N294, N293, N292, N291, N290, N289, N288, N287, N286, N285, 
        N284, N283, N282, N281, N280, N279, N278, N277, N276, N275, N274, N273, 
        N272, N271, N270, N269, N268, N267, N266, N265, N264, N263, N262, N261, 
        N260, N259, N258, N257, N256, N255, N254, N253, N252, N251, N250, N249, 
        N248, N247, N246, N245, N244, N243, N242, N241, N240, N239, N238, N237, 
        N236, N235, N234, N233, N232, N231, N230, N229, N228, N227, N226, N225, 
        N224, N223, N222, N221, N220, N219, N218, N217, N216}) );
  SELECT_OP C2934 ( .DATA1({1'b1, 1'b0, 1'b1}), .DATA2({1'b1, 1'b0, 1'b1}), 
        .DATA3({1'b0, N1149, N1148}), .CONTROL1(N63), .CONTROL2(N64), 
        .CONTROL3(N65), .Z(max_conv_cnt) );
  GTECH_BUF B_2 ( .A(N1128), .Z(N63) );
  GTECH_BUF B_3 ( .A(N1130), .Z(N64) );
  GTECH_BUF B_4 ( .A(cur_mode[1]), .Z(N65) );
  SELECT_OP C2935 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({N318, N317, N316, 
        N315}), .CONTROL1(N66), .CONTROL2(N314), .Z({N322, N321, N320, N319})
         );
  GTECH_BUF B_5 ( .A(N313), .Z(N66) );
  SELECT_OP C2936 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(rst), .CONTROL1(N67), 
        .CONTROL2(N329), .CONTROL3(N311), .Z(N323) );
  GTECH_BUF B_6 ( .A(N308), .Z(N67) );
  SELECT_OP C2937 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({N322, N321, N320, 
        N319}), .DATA3({1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N67), .CONTROL2(
        N329), .CONTROL3(N311), .Z({N327, N326, N325, N324}) );
  SELECT_OP C2938 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(rst), .CONTROL1(N68), 
        .CONTROL2(N340), .CONTROL3(N332), .Z(N336) );
  GTECH_BUF B_7 ( .A(change_mode), .Z(N68) );
  SELECT_OP C2939 ( .DATA1({1'b0, 1'b0}), .DATA2({N335, N334}), .DATA3({1'b0, 
        1'b0}), .CONTROL1(N68), .CONTROL2(N340), .CONTROL3(N332), .Z({N338, 
        N337}) );
  SELECT_OP C2940 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b1), .DATA4(1'b0), 
        .CONTROL1(N61), .CONTROL2(N448), .CONTROL3(N451), .CONTROL4(N445), .Z(
        N446) );
  SELECT_OP C2941 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b1), .CONTROL1(N61), 
        .CONTROL2(N448), .CONTROL3(N451), .Z(N447) );
  SELECT_OP C2942 ( .DATA1(N1091), .DATA2(N1091), .DATA3(N1091), .DATA4(N1091), 
        .CONTROL1(N69), .CONTROL2(N70), .CONTROL3(N71), .CONTROL4(N72), .Z(
        N456) );
  GTECH_BUF B_8 ( .A(N1113), .Z(N69) );
  GTECH_BUF B_9 ( .A(N1115), .Z(N70) );
  GTECH_BUF B_10 ( .A(N1117), .Z(N71) );
  GTECH_BUF B_11 ( .A(N455), .Z(N72) );
  SELECT_OP C2943 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(N456), .CONTROL1(N73), 
        .CONTROL2(N458), .CONTROL3(N454), .Z(packet_in_valid) );
  GTECH_BUF B_12 ( .A(N1080), .Z(N73) );
  SELECT_OP C2944 ( .DATA1({N461, N460, N459}), .DATA2({1'b0, 1'b0, 1'b0}), 
        .CONTROL1(N74), .CONTROL2(N75), .Z(section_to_free) );
  GTECH_BUF B_13 ( .A(N1151), .Z(N74) );
  GTECH_BUF B_14 ( .A(N1150), .Z(N75) );
  SELECT_OP C2945 ( .DATA1({1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 1'b0, 1'b0}), 
        .DATA3(section_valid_comb), .CONTROL1(N61), .CONTROL2(N467), 
        .CONTROL3(N463), .Z({N466, N465, N464}) );
  SELECT_OP C2946 ( .DATA1({1'b0, 1'b0, 1'b1}), .DATA2({1'b0, 1'b1, 1'b0}), 
        .DATA3({1'b1, 1'b0, 1'b0}), .DATA4({1'b1, 1'b0, 1'b0}), .DATA5({1'b0, 
        1'b0, 1'b1}), .DATA6({1'b0, 1'b1, 1'b0}), .DATA7({1'b0, 1'b0, 1'b1}), 
        .DATA8({1'b0, 1'b0, 1'b0}), .CONTROL1(N76), .CONTROL2(N77), .CONTROL3(
        N78), .CONTROL4(N79), .CONTROL5(N80), .CONTROL6(N81), .CONTROL7(N82), 
        .CONTROL8(N83), .Z({N497, N496, N495}) );
  GTECH_BUF B_15 ( .A(N476), .Z(N76) );
  GTECH_BUF B_16 ( .A(N479), .Z(N77) );
  GTECH_BUF B_17 ( .A(N482), .Z(N78) );
  GTECH_BUF B_18 ( .A(N484), .Z(N79) );
  GTECH_BUF B_19 ( .A(N487), .Z(N80) );
  GTECH_BUF B_20 ( .A(N489), .Z(N81) );
  GTECH_BUF B_21 ( .A(N492), .Z(N82) );
  GTECH_BUF B_22 ( .A(N494), .Z(N83) );
  SELECT_OP C2947 ( .DATA1({1'b0, 1'b0, 1'b1}), .DATA2({1'b0, 1'b1, 1'b1}), 
        .DATA3({1'b1, 1'b1, 1'b0}), .DATA4({1'b1, 1'b1, 1'b1}), .DATA5({1'b1, 
        1'b0, 1'b1}), .DATA6({1'b1, 1'b1, 1'b1}), .DATA7({1'b1, 1'b1, 1'b1}), 
        .DATA8({N468, N469, N470}), .CONTROL1(N76), .CONTROL2(N77), .CONTROL3(
        N78), .CONTROL4(N79), .CONTROL5(N80), .CONTROL6(N81), .CONTROL7(N82), 
        .CONTROL8(N83), .Z({N500, N499, N498}) );
  SELECT_OP C2948 ( .DATA1(1'b0), .DATA2(1'b0), .DATA3(1'b0), .DATA4(1'b0), 
        .DATA5(1'b0), .DATA6(1'b0), .DATA7(1'b0), .DATA8(1'b1), .CONTROL1(N76), 
        .CONTROL2(N77), .CONTROL3(N78), .CONTROL4(N79), .CONTROL5(N80), 
        .CONTROL6(N81), .CONTROL7(N82), .CONTROL8(N83), .Z(N501) );
  SELECT_OP C2949 ( .DATA1(N501), .DATA2(1'b0), .CONTROL1(N84), .CONTROL2(N85), 
        .Z(error) );
  GTECH_BUF B_23 ( .A(packet_in_valid), .Z(N84) );
  GTECH_BUF B_24 ( .A(N471), .Z(N85) );
  SELECT_OP C2950 ( .DATA1({N497, N496, N495}), .DATA2({1'b0, 1'b0, 1'b0}), 
        .CONTROL1(N84), .CONTROL2(N85), .Z(section_write) );
  SELECT_OP C2951 ( .DATA1({N500, N499, N498}), .DATA2({N468, N469, N470}), 
        .CONTROL1(N84), .CONTROL2(N85), .Z(section_valid_comb) );
  SELECT_OP C2952 ( .DATA1({1'b1, 1'b1, 1'b1}), .DATA2({1'b1, 1'b1, 1'b1}), 
        .DATA3({1'b0, 1'b0, 1'b1}), .DATA4({1'b0, 1'b1, 1'b0}), .DATA5({1'b1, 
        1'b0, 1'b0}), .DATA6({1'b0, 1'b0, 1'b0}), .CONTROL1(N61), .CONTROL2(
        N606), .CONTROL3(N608), .CONTROL4(N611), .CONTROL5(N614), .CONTROL6(
        N506), .Z({N573, N540, N507}) );
  SELECT_OP C2953 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3(
        ifmap_packet[31:0]), .CONTROL1(N61), .CONTROL2(N606), .CONTROL3(N608), 
        .Z({N539, N538, N537, N536, N535, N534, N533, N532, N531, N530, N529, 
        N528, N527, N526, N525, N524, N523, N522, N521, N520, N519, N518, N517, 
        N516, N515, N514, N513, N512, N511, N510, N509, N508}) );
  SELECT_OP C2954 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3(
        ifmap_packet[31:0]), .CONTROL1(N61), .CONTROL2(N606), .CONTROL3(N611), 
        .Z({N572, N571, N570, N569, N568, N567, N566, N565, N564, N563, N562, 
        N561, N560, N559, N558, N557, N556, N555, N554, N553, N552, N551, N550, 
        N549, N548, N547, N546, N545, N544, N543, N542, N541}) );
  SELECT_OP C2955 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3(
        ifmap_packet[31:0]), .CONTROL1(N61), .CONTROL2(N606), .CONTROL3(N614), 
        .Z({N605, N604, N603, N602, N601, N600, N599, N598, N597, N596, N595, 
        N594, N593, N592, N591, N590, N589, N588, N587, N586, N585, N584, N583, 
        N582, N581, N580, N579, N578, N577, N576, N575, N574}) );
  SELECT_OP C2956 ( .DATA1({N639, N638, N637, N636}), .DATA2({N643, N642, N641, 
        N640}), .CONTROL1(N86), .CONTROL2(N631), .Z({N647, N646, N645, N644})
         );
  GTECH_BUF B_25 ( .A(N630), .Z(N86) );
  SELECT_OP C2957 ( .DATA1({N647, N646, N645, N644}), .DATA2({N656, N655, N654, 
        N653}), .DATA3({N660, N659, N658, N657}), .CONTROL1(N87), .CONTROL2(
        N662), .CONTROL3(N623), .Z(next_start_ptr) );
  GTECH_BUF B_26 ( .A(N615), .Z(N87) );
  SELECT_OP C2958 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b1), .DATA4(1'b0), 
        .CONTROL1(N61), .CONTROL2(N673), .CONTROL3(N675), .CONTROL4(N667), .Z(
        N668) );
  SELECT_OP C2959 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 1'b0, 1'b0, 
        1'b0}), .DATA3(next_start_ptr), .CONTROL1(N61), .CONTROL2(N673), 
        .CONTROL3(N675), .Z({N672, N671, N670, N669}) );
  SELECT_OP C2960 ( .DATA1({N690, N689, N688, N687}), .DATA2({N694, N693, N692, 
        N691}), .CONTROL1(N88), .CONTROL2(N682), .Z(read_ptr) );
  GTECH_BUF B_27 ( .A(N681), .Z(N88) );
  SELECT_OP C2961 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b0), .CONTROL1(N61), 
        .CONTROL2(N735), .CONTROL3(N709), .Z(N710) );
  SELECT_OP C2962 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA2(ifdata_next), .CONTROL1(N61), .CONTROL2(N735), .Z({N718, N717, 
        N716, N715, N714, N713, N712, N711}) );
  SELECT_OP C2963 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA2(weight_next), .CONTROL1(N61), .CONTROL2(N735), .Z({N726, N725, 
        N724, N723, N722, N721, N720, N719}) );
  SELECT_OP C2964 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .DATA2(mult_out), .CONTROL1(N61), .CONTROL2(N735), .Z({N734, N733, 
        N732, N731, N730, N729, N728, N727}) );
  SELECT_OP C2965 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b0), .CONTROL1(N61), 
        .CONTROL2(N751), .CONTROL3(N737), .Z(N738) );
  SELECT_OP C2966 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(adder_out), .CONTROL1(N61), 
        .CONTROL2(N751), .Z({N750, N749, N748, N747, N746, N745, N744, N743, 
        N742, N741, N740, N739}) );
  SELECT_OP C2968 ( .DATA1({1'b1, 1'b1, 1'b0, 1'b1, 1'b1}), .DATA2({1'b1, 1'b1, 
        1'b0, 1'b1, 1'b1}), .DATA3({1'b0, N1094, 1'b1, N1093, N1094}), 
        .CONTROL1(N89), .CONTROL2(N90), .CONTROL3(N65), .Z(psum_idx_max) );
  GTECH_BUF B_28 ( .A(N1083), .Z(N89) );
  GTECH_BUF B_29 ( .A(N1086), .Z(N90) );
  SELECT_OP C2969 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({N765, 
        N764, N763, N762, N761, N760}), .CONTROL1(N91), .CONTROL2(N759), .Z({
        N771, N770, N769, N768, N767, N766}) );
  GTECH_BUF B_30 ( .A(N758), .Z(N91) );
  SELECT_OP C2970 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b1), .DATA4(1'b0), 
        .CONTROL1(N61), .CONTROL2(N779), .CONTROL3(N781), .CONTROL4(N756), .Z(
        N772) );
  SELECT_OP C2971 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3({N771, N770, N769, N768, N767, 
        N766}), .CONTROL1(N61), .CONTROL2(N779), .CONTROL3(N781), .Z({N778, 
        N777, N776, N775, N774, N773}) );
  SELECT_OP C2972 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b0), .DATA4(1'b0), 
        .CONTROL1(N61), .CONTROL2(N825), .CONTROL3(N827), .CONTROL4(N784), .Z(
        N785) );
  SELECT_OP C2973 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(
        psum_idx), .CONTROL1(N61), .CONTROL2(N825), .Z({N791, N790, N789, N788, 
        N787, N786}) );
  SELECT_OP C2974 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(
        psum_idx_mult), .CONTROL1(N61), .CONTROL2(N825), .Z({N797, N796, N795, 
        N794, N793, N792}) );
  SELECT_OP C2975 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(
        psum_idx_accum), .CONTROL1(N61), .CONTROL2(N825), .Z({N803, N802, N801, 
        N800, N799, N798}) );
  SELECT_OP C2976 ( .DATA1({1'b0, 1'b0}), .DATA2(filter_ptr), .CONTROL1(N61), 
        .CONTROL2(N825), .Z({N805, N804}) );
  SELECT_OP C2977 ( .DATA1({1'b0, 1'b0}), .DATA2(filter_ptr_mult), .CONTROL1(
        N61), .CONTROL2(N825), .Z({N807, N806}) );
  SELECT_OP C2978 ( .DATA1({1'b0, 1'b0}), .DATA2(filter_ptr_accum), .CONTROL1(
        N61), .CONTROL2(N825), .Z({N809, N808}) );
  SELECT_OP C2979 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(conv_cnt), 
        .CONTROL1(N61), .CONTROL2(N825), .Z({N813, N812, N811, N810}) );
  SELECT_OP C2980 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(conv_cnt_mult), 
        .CONTROL1(N61), .CONTROL2(N825), .Z({N817, N816, N815, N814}) );
  SELECT_OP C2981 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(conv_cnt_accum), 
        .CONTROL1(N61), .CONTROL2(N825), .Z({N821, N820, N819, N818}) );
  SELECT_OP C2982 ( .DATA1(1'b0), .DATA2(data_valid), .CONTROL1(N61), 
        .CONTROL2(N825), .Z(N822) );
  SELECT_OP C2983 ( .DATA1(1'b0), .DATA2(data_valid_mult), .CONTROL1(N61), 
        .CONTROL2(N825), .Z(N823) );
  SELECT_OP C2984 ( .DATA1(1'b0), .DATA2(data_valid_accum), .CONTROL1(N61), 
        .CONTROL2(N825), .Z(N824) );
  SELECT_OP C2985 ( .DATA1({1'b1, 1'b1, 1'b1, 1'b1}), .DATA2({N836, N835, N834, 
        N833}), .DATA3({N840, N839, N838, N837}), .DATA4({1'b0, 1'b0, 1'b0, 
        1'b0}), .CONTROL1(N61), .CONTROL2(N893), .CONTROL3(N896), .CONTROL4(
        N832), .Z({N880, N867, N854, N841}) );
  SELECT_OP C2986 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3({adder_out_ff, 
        adder_out_ff, adder_out_ff, adder_out_ff}), .CONTROL1(N61), .CONTROL2(
        N893), .CONTROL3(N896), .Z({N892, N891, N890, N889, N888, N887, N886, 
        N885, N884, N883, N882, N881, N879, N878, N877, N876, N875, N874, N873, 
        N872, N871, N870, N869, N868, N866, N865, N864, N863, N862, N861, N860, 
        N859, N858, N857, N856, N855, N853, N852, N851, N850, N849, N848, N847, 
        N846, N845, N844, N843, N842}) );
  SELECT_OP C2987 ( .DATA1({1'b1, 1'b1, 1'b1, 1'b1}), .DATA2({N904, N903, N902, 
        N901}), .DATA3({1'b0, 1'b0, 1'b0, 1'b0}), .CONTROL1(N61), .CONTROL2(
        N957), .CONTROL3(N900), .Z({N944, N931, N918, N905}) );
  SELECT_OP C2988 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({adder_out_ff, adder_out_ff, 
        adder_out_ff, adder_out_ff}), .CONTROL1(N61), .CONTROL2(N957), .Z({
        N956, N955, N954, N953, N952, N951, N950, N949, N948, N947, N946, N945, 
        N943, N942, N941, N940, N939, N938, N937, N936, N935, N934, N933, N932, 
        N930, N929, N928, N927, N926, N925, N924, N923, N922, N921, N920, N919, 
        N917, N916, N915, N914, N913, N912, N911, N910, N909, N908, N907, N906}) );
  SELECT_OP C2989 ( .DATA1(1'b0), .DATA2(psum_ready[0]), .CONTROL1(N92), 
        .CONTROL2(N967), .Z(N968) );
  GTECH_BUF B_31 ( .A(N963), .Z(N92) );
  SELECT_OP C2990 ( .DATA1(1'b0), .DATA2(psum_ready[1]), .CONTROL1(N93), 
        .CONTROL2(N969), .Z(N970) );
  GTECH_BUF B_32 ( .A(N964), .Z(N93) );
  SELECT_OP C2991 ( .DATA1(1'b0), .DATA2(psum_ready[2]), .CONTROL1(N94), 
        .CONTROL2(N971), .Z(N972) );
  GTECH_BUF B_33 ( .A(N965), .Z(N94) );
  SELECT_OP C2992 ( .DATA1(1'b0), .DATA2(psum_ready[3]), .CONTROL1(N95), 
        .CONTROL2(N973), .Z(N974) );
  GTECH_BUF B_34 ( .A(N966), .Z(N95) );
  SELECT_OP C2993 ( .DATA1({N974, N972, N970, N968}), .DATA2(psum_ready), 
        .CONTROL1(N96), .CONTROL2(N962), .Z({N978, N977, N976, N975}) );
  GTECH_BUF B_35 ( .A(N961), .Z(N96) );
  SELECT_OP C2994 ( .DATA1(N961), .DATA2(1'b0), .CONTROL1(N97), .CONTROL2(N959), .Z(psum_ack_out) );
  GTECH_BUF B_36 ( .A(N958), .Z(N97) );
  SELECT_OP C2995 ( .DATA1({N978, N977, N976, N975}), .DATA2(psum_ready), 
        .CONTROL1(N97), .CONTROL2(N959), .Z(psum_post_free_comb) );
  SELECT_OP C2996 ( .DATA1(1'b1), .DATA2(psum_post_free_comb[0]), .CONTROL1(
        N98), .CONTROL2(N989), .Z(N990) );
  GTECH_BUF B_37 ( .A(N985), .Z(N98) );
  SELECT_OP C2997 ( .DATA1(1'b1), .DATA2(psum_post_free_comb[1]), .CONTROL1(
        N99), .CONTROL2(N991), .Z(N992) );
  GTECH_BUF B_38 ( .A(N986), .Z(N99) );
  SELECT_OP C2998 ( .DATA1(1'b1), .DATA2(psum_post_free_comb[2]), .CONTROL1(
        N100), .CONTROL2(N993), .Z(N994) );
  GTECH_BUF B_39 ( .A(N987), .Z(N100) );
  SELECT_OP C2999 ( .DATA1(1'b1), .DATA2(psum_post_free_comb[3]), .CONTROL1(
        N101), .CONTROL2(N995), .Z(N996) );
  GTECH_BUF B_40 ( .A(N988), .Z(N101) );
  SELECT_OP C3000 ( .DATA1(1'b1), .DATA2(1'b0), .DATA3(1'b0), .CONTROL1(N102), 
        .CONTROL2(N997), .CONTROL3(N103), .Z(N998) );
  GTECH_BUF B_41 ( .A(N982), .Z(N102) );
  GTECH_BUF B_42 ( .A(1'b0), .Z(N103) );
  SELECT_OP C3001 ( .DATA1(psum_post_free_comb), .DATA2({N996, N994, N992, 
        N990}), .DATA3(psum_post_free_comb), .CONTROL1(N102), .CONTROL2(N1003), 
        .CONTROL3(N984), .Z({N1002, N1001, N1000, N999}) );
  SELECT_OP C3002 ( .DATA1({N1002, N1001, N1000, N999}), .DATA2(
        psum_post_free_comb), .CONTROL1(N104), .CONTROL2(N980), .Z(
        psum_ready_comb) );
  GTECH_BUF B_43 ( .A(N979), .Z(N104) );
  SELECT_OP C3003 ( .DATA1(N998), .DATA2(1'b0), .CONTROL1(N104), .CONTROL2(
        N980), .Z(accum_stall) );
  SELECT_OP C3004 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0}), .DATA2(psum_ready_comb), 
        .CONTROL1(N61), .CONTROL2(N105), .Z({N1008, N1007, N1006, N1005}) );
  GTECH_BUF B_44 ( .A(N1004), .Z(N105) );
  SELECT_OP C3005 ( .DATA1({1'b1, 1'b1}), .DATA2({1'b1, 1'b1}), .DATA3({1'b1, 
        1'b0}), .DATA4({1'b0, 1'b0}), .CONTROL1(N61), .CONTROL2(N1029), 
        .CONTROL3(N1032), .CONTROL4(N1011), .Z({N1027, N1012}) );
  SELECT_OP C3006 ( .DATA1({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA2({psum_in[13:12], 
        accum_adder_out}), .CONTROL1(N61), .CONTROL2(N1029), .Z({N1026, N1025, 
        N1024, N1023, N1022, N1021, N1020, N1019, N1018, N1017, N1016, N1015, 
        N1014, N1013}) );
  SELECT_OP C3007 ( .DATA1(1'b0), .DATA2(1'b1), .DATA3(1'b0), .CONTROL1(N61), 
        .CONTROL2(N1029), .CONTROL3(N1032), .Z(N1028) );
  SELECT_OP C3008 ( .DATA1(1'b1), .DATA2(1'b1), .DATA3(1'b1), .DATA4(1'b0), 
        .CONTROL1(N61), .CONTROL2(N1039), .CONTROL3(N1041), .CONTROL4(N1036), 
        .Z(N1037) );
  SELECT_OP C3009 ( .DATA1(1'b1), .DATA2(1'b0), .DATA3(1'b1), .CONTROL1(N61), 
        .CONTROL2(N1039), .CONTROL3(N1041), .Z(N1038) );
  SELECT_OP C3010 ( .DATA1(N421), .DATA2(N413), .DATA3(N405), .DATA4(N397), 
        .DATA5(N389), .DATA6(N381), .DATA7(N373), .DATA8(N365), .DATA9(N357), 
        .DATA10(N349), .DATA11(N341), .CONTROL1(N106), .CONTROL2(N107), 
        .CONTROL3(N108), .CONTROL4(N109), .CONTROL5(N110), .CONTROL6(N111), 
        .CONTROL7(N112), .CONTROL8(N113), .CONTROL9(N114), .CONTROL10(N115), 
        .CONTROL11(N116), .Z(weight_next[7]) );
  GTECH_BUF B_45 ( .A(N429), .Z(N106) );
  GTECH_BUF B_46 ( .A(N431), .Z(N107) );
  GTECH_BUF B_47 ( .A(N433), .Z(N108) );
  GTECH_BUF B_48 ( .A(N435), .Z(N109) );
  GTECH_BUF B_49 ( .A(N436), .Z(N110) );
  GTECH_BUF B_50 ( .A(N437), .Z(N111) );
  GTECH_BUF B_51 ( .A(N438), .Z(N112) );
  GTECH_BUF B_52 ( .A(N439), .Z(N113) );
  GTECH_BUF B_53 ( .A(N430), .Z(N114) );
  GTECH_BUF B_54 ( .A(N432), .Z(N115) );
  GTECH_BUF B_55 ( .A(N434), .Z(N116) );
  SELECT_OP C3011 ( .DATA1(N422), .DATA2(N414), .DATA3(N406), .DATA4(N398), 
        .DATA5(N390), .DATA6(N382), .DATA7(N374), .DATA8(N366), .DATA9(N358), 
        .DATA10(N350), .DATA11(N342), .CONTROL1(N106), .CONTROL2(N107), 
        .CONTROL3(N108), .CONTROL4(N109), .CONTROL5(N110), .CONTROL6(N111), 
        .CONTROL7(N112), .CONTROL8(N113), .CONTROL9(N114), .CONTROL10(N115), 
        .CONTROL11(N116), .Z(weight_next[6]) );
  SELECT_OP C3012 ( .DATA1(N423), .DATA2(N415), .DATA3(N407), .DATA4(N399), 
        .DATA5(N391), .DATA6(N383), .DATA7(N375), .DATA8(N367), .DATA9(N359), 
        .DATA10(N351), .DATA11(N343), .CONTROL1(N106), .CONTROL2(N107), 
        .CONTROL3(N108), .CONTROL4(N109), .CONTROL5(N110), .CONTROL6(N111), 
        .CONTROL7(N112), .CONTROL8(N113), .CONTROL9(N114), .CONTROL10(N115), 
        .CONTROL11(N116), .Z(weight_next[5]) );
  SELECT_OP C3013 ( .DATA1(N424), .DATA2(N416), .DATA3(N408), .DATA4(N400), 
        .DATA5(N392), .DATA6(N384), .DATA7(N376), .DATA8(N368), .DATA9(N360), 
        .DATA10(N352), .DATA11(N344), .CONTROL1(N106), .CONTROL2(N107), 
        .CONTROL3(N108), .CONTROL4(N109), .CONTROL5(N110), .CONTROL6(N111), 
        .CONTROL7(N112), .CONTROL8(N113), .CONTROL9(N114), .CONTROL10(N115), 
        .CONTROL11(N116), .Z(weight_next[4]) );
  SELECT_OP C3014 ( .DATA1(N425), .DATA2(N417), .DATA3(N409), .DATA4(N401), 
        .DATA5(N393), .DATA6(N385), .DATA7(N377), .DATA8(N369), .DATA9(N361), 
        .DATA10(N353), .DATA11(N345), .CONTROL1(N106), .CONTROL2(N107), 
        .CONTROL3(N108), .CONTROL4(N109), .CONTROL5(N110), .CONTROL6(N111), 
        .CONTROL7(N112), .CONTROL8(N113), .CONTROL9(N114), .CONTROL10(N115), 
        .CONTROL11(N116), .Z(weight_next[3]) );
  SELECT_OP C3015 ( .DATA1(N426), .DATA2(N418), .DATA3(N410), .DATA4(N402), 
        .DATA5(N394), .DATA6(N386), .DATA7(N378), .DATA8(N370), .DATA9(N362), 
        .DATA10(N354), .DATA11(N346), .CONTROL1(N106), .CONTROL2(N107), 
        .CONTROL3(N108), .CONTROL4(N109), .CONTROL5(N110), .CONTROL6(N111), 
        .CONTROL7(N112), .CONTROL8(N113), .CONTROL9(N114), .CONTROL10(N115), 
        .CONTROL11(N116), .Z(weight_next[2]) );
  SELECT_OP C3016 ( .DATA1(N427), .DATA2(N419), .DATA3(N411), .DATA4(N403), 
        .DATA5(N395), .DATA6(N387), .DATA7(N379), .DATA8(N371), .DATA9(N363), 
        .DATA10(N355), .DATA11(N347), .CONTROL1(N106), .CONTROL2(N107), 
        .CONTROL3(N108), .CONTROL4(N109), .CONTROL5(N110), .CONTROL6(N111), 
        .CONTROL7(N112), .CONTROL8(N113), .CONTROL9(N114), .CONTROL10(N115), 
        .CONTROL11(N116), .Z(weight_next[1]) );
  SELECT_OP C3017 ( .DATA1(N428), .DATA2(N420), .DATA3(N412), .DATA4(N404), 
        .DATA5(N396), .DATA6(N388), .DATA7(N380), .DATA8(N372), .DATA9(N364), 
        .DATA10(N356), .DATA11(N348), .CONTROL1(N106), .CONTROL2(N107), 
        .CONTROL3(N108), .CONTROL4(N109), .CONTROL5(N110), .CONTROL6(N111), 
        .CONTROL7(N112), .CONTROL8(N113), .CONTROL9(N114), .CONTROL10(N115), 
        .CONTROL11(N116), .Z(weight_next[0]) );
  SELECT_OP C3018 ( .DATA1(ifmap_ram[7]), .DATA2(ifmap_ram[15]), .DATA3(
        ifmap_ram[23]), .DATA4(ifmap_ram[31]), .DATA5(ifmap_ram[39]), .DATA6(
        ifmap_ram[47]), .DATA7(ifmap_ram[55]), .DATA8(ifmap_ram[63]), .DATA9(
        ifmap_ram[71]), .DATA10(ifmap_ram[79]), .DATA11(ifmap_ram[87]), 
        .DATA12(ifmap_ram[95]), .CONTROL1(N117), .CONTROL2(N118), .CONTROL3(
        N119), .CONTROL4(N120), .CONTROL5(N121), .CONTROL6(N122), .CONTROL7(
        N123), .CONTROL8(N124), .CONTROL9(N125), .CONTROL10(N126), .CONTROL11(
        N127), .CONTROL12(N128), .Z(ifdata_next[7]) );
  GTECH_BUF B_56 ( .A(N695), .Z(N117) );
  GTECH_BUF B_57 ( .A(N697), .Z(N118) );
  GTECH_BUF B_58 ( .A(N699), .Z(N119) );
  GTECH_BUF B_59 ( .A(N701), .Z(N120) );
  GTECH_BUF B_60 ( .A(N703), .Z(N121) );
  GTECH_BUF B_61 ( .A(N704), .Z(N122) );
  GTECH_BUF B_62 ( .A(N705), .Z(N123) );
  GTECH_BUF B_63 ( .A(N706), .Z(N124) );
  GTECH_BUF B_64 ( .A(N696), .Z(N125) );
  GTECH_BUF B_65 ( .A(N698), .Z(N126) );
  GTECH_BUF B_66 ( .A(N700), .Z(N127) );
  GTECH_BUF B_67 ( .A(N702), .Z(N128) );
  SELECT_OP C3019 ( .DATA1(ifmap_ram[6]), .DATA2(ifmap_ram[14]), .DATA3(
        ifmap_ram[22]), .DATA4(ifmap_ram[30]), .DATA5(ifmap_ram[38]), .DATA6(
        ifmap_ram[46]), .DATA7(ifmap_ram[54]), .DATA8(ifmap_ram[62]), .DATA9(
        ifmap_ram[70]), .DATA10(ifmap_ram[78]), .DATA11(ifmap_ram[86]), 
        .DATA12(ifmap_ram[94]), .CONTROL1(N117), .CONTROL2(N118), .CONTROL3(
        N119), .CONTROL4(N120), .CONTROL5(N121), .CONTROL6(N122), .CONTROL7(
        N123), .CONTROL8(N124), .CONTROL9(N125), .CONTROL10(N126), .CONTROL11(
        N127), .CONTROL12(N128), .Z(ifdata_next[6]) );
  SELECT_OP C3020 ( .DATA1(ifmap_ram[5]), .DATA2(ifmap_ram[13]), .DATA3(
        ifmap_ram[21]), .DATA4(ifmap_ram[29]), .DATA5(ifmap_ram[37]), .DATA6(
        ifmap_ram[45]), .DATA7(ifmap_ram[53]), .DATA8(ifmap_ram[61]), .DATA9(
        ifmap_ram[69]), .DATA10(ifmap_ram[77]), .DATA11(ifmap_ram[85]), 
        .DATA12(ifmap_ram[93]), .CONTROL1(N117), .CONTROL2(N118), .CONTROL3(
        N119), .CONTROL4(N120), .CONTROL5(N121), .CONTROL6(N122), .CONTROL7(
        N123), .CONTROL8(N124), .CONTROL9(N125), .CONTROL10(N126), .CONTROL11(
        N127), .CONTROL12(N128), .Z(ifdata_next[5]) );
  SELECT_OP C3021 ( .DATA1(ifmap_ram[4]), .DATA2(ifmap_ram[12]), .DATA3(
        ifmap_ram[20]), .DATA4(ifmap_ram[28]), .DATA5(ifmap_ram[36]), .DATA6(
        ifmap_ram[44]), .DATA7(ifmap_ram[52]), .DATA8(ifmap_ram[60]), .DATA9(
        ifmap_ram[68]), .DATA10(ifmap_ram[76]), .DATA11(ifmap_ram[84]), 
        .DATA12(ifmap_ram[92]), .CONTROL1(N117), .CONTROL2(N118), .CONTROL3(
        N119), .CONTROL4(N120), .CONTROL5(N121), .CONTROL6(N122), .CONTROL7(
        N123), .CONTROL8(N124), .CONTROL9(N125), .CONTROL10(N126), .CONTROL11(
        N127), .CONTROL12(N128), .Z(ifdata_next[4]) );
  SELECT_OP C3022 ( .DATA1(ifmap_ram[3]), .DATA2(ifmap_ram[11]), .DATA3(
        ifmap_ram[19]), .DATA4(ifmap_ram[27]), .DATA5(ifmap_ram[35]), .DATA6(
        ifmap_ram[43]), .DATA7(ifmap_ram[51]), .DATA8(ifmap_ram[59]), .DATA9(
        ifmap_ram[67]), .DATA10(ifmap_ram[75]), .DATA11(ifmap_ram[83]), 
        .DATA12(ifmap_ram[91]), .CONTROL1(N117), .CONTROL2(N118), .CONTROL3(
        N119), .CONTROL4(N120), .CONTROL5(N121), .CONTROL6(N122), .CONTROL7(
        N123), .CONTROL8(N124), .CONTROL9(N125), .CONTROL10(N126), .CONTROL11(
        N127), .CONTROL12(N128), .Z(ifdata_next[3]) );
  SELECT_OP C3023 ( .DATA1(ifmap_ram[2]), .DATA2(ifmap_ram[10]), .DATA3(
        ifmap_ram[18]), .DATA4(ifmap_ram[26]), .DATA5(ifmap_ram[34]), .DATA6(
        ifmap_ram[42]), .DATA7(ifmap_ram[50]), .DATA8(ifmap_ram[58]), .DATA9(
        ifmap_ram[66]), .DATA10(ifmap_ram[74]), .DATA11(ifmap_ram[82]), 
        .DATA12(ifmap_ram[90]), .CONTROL1(N117), .CONTROL2(N118), .CONTROL3(
        N119), .CONTROL4(N120), .CONTROL5(N121), .CONTROL6(N122), .CONTROL7(
        N123), .CONTROL8(N124), .CONTROL9(N125), .CONTROL10(N126), .CONTROL11(
        N127), .CONTROL12(N128), .Z(ifdata_next[2]) );
  SELECT_OP C3024 ( .DATA1(ifmap_ram[1]), .DATA2(ifmap_ram[9]), .DATA3(
        ifmap_ram[17]), .DATA4(ifmap_ram[25]), .DATA5(ifmap_ram[33]), .DATA6(
        ifmap_ram[41]), .DATA7(ifmap_ram[49]), .DATA8(ifmap_ram[57]), .DATA9(
        ifmap_ram[65]), .DATA10(ifmap_ram[73]), .DATA11(ifmap_ram[81]), 
        .DATA12(ifmap_ram[89]), .CONTROL1(N117), .CONTROL2(N118), .CONTROL3(
        N119), .CONTROL4(N120), .CONTROL5(N121), .CONTROL6(N122), .CONTROL7(
        N123), .CONTROL8(N124), .CONTROL9(N125), .CONTROL10(N126), .CONTROL11(
        N127), .CONTROL12(N128), .Z(ifdata_next[1]) );
  SELECT_OP C3025 ( .DATA1(ifmap_ram[0]), .DATA2(ifmap_ram[8]), .DATA3(
        ifmap_ram[16]), .DATA4(ifmap_ram[24]), .DATA5(ifmap_ram[32]), .DATA6(
        ifmap_ram[40]), .DATA7(ifmap_ram[48]), .DATA8(ifmap_ram[56]), .DATA9(
        ifmap_ram[64]), .DATA10(ifmap_ram[72]), .DATA11(ifmap_ram[80]), 
        .DATA12(ifmap_ram[88]), .CONTROL1(N117), .CONTROL2(N118), .CONTROL3(
        N119), .CONTROL4(N120), .CONTROL5(N121), .CONTROL6(N122), .CONTROL7(
        N123), .CONTROL8(N124), .CONTROL9(N125), .CONTROL10(N126), .CONTROL11(
        N127), .CONTROL12(N128), .Z(ifdata_next[0]) );
  MUX_OP C3027 ( .D0({filter_ram[0], filter_ram[1], filter_ram[2], 
        filter_ram[3], filter_ram[4], filter_ram[5], filter_ram[6], 
        filter_ram[7], filter_ram[8], filter_ram[9], filter_ram[10], 
        filter_ram[11], filter_ram[12], filter_ram[13], filter_ram[14], 
        filter_ram[15], filter_ram[16], filter_ram[17], filter_ram[18], 
        filter_ram[19], filter_ram[20], filter_ram[21], filter_ram[22], 
        filter_ram[23], filter_ram[24], filter_ram[25], filter_ram[26], 
        filter_ram[27], filter_ram[28], filter_ram[29], filter_ram[30], 
        filter_ram[31], filter_ram[32], filter_ram[33], filter_ram[34], 
        filter_ram[35], filter_ram[36], filter_ram[37], filter_ram[38], 
        filter_ram[39], filter_ram[40], filter_ram[41], filter_ram[42], 
        filter_ram[43], filter_ram[44], filter_ram[45], filter_ram[46], 
        filter_ram[47], filter_ram[48], filter_ram[49], filter_ram[50], 
        filter_ram[51], filter_ram[52], filter_ram[53], filter_ram[54], 
        filter_ram[55]}), .D1({filter_ram[88], filter_ram[89], filter_ram[90], 
        filter_ram[91], filter_ram[92], filter_ram[93], filter_ram[94], 
        filter_ram[95], filter_ram[96], filter_ram[97], filter_ram[98], 
        filter_ram[99], filter_ram[100], filter_ram[101], filter_ram[102], 
        filter_ram[103], filter_ram[104], filter_ram[105], filter_ram[106], 
        filter_ram[107], filter_ram[108], filter_ram[109], filter_ram[110], 
        filter_ram[111], filter_ram[112], filter_ram[113], filter_ram[114], 
        filter_ram[115], filter_ram[116], filter_ram[117], filter_ram[118], 
        filter_ram[119], filter_ram[120], filter_ram[121], filter_ram[122], 
        filter_ram[123], filter_ram[124], filter_ram[125], filter_ram[126], 
        filter_ram[127], filter_ram[128], filter_ram[129], filter_ram[130], 
        filter_ram[131], filter_ram[132], filter_ram[133], filter_ram[134], 
        filter_ram[135], filter_ram[136], filter_ram[137], filter_ram[138], 
        filter_ram[139], filter_ram[140], filter_ram[141], filter_ram[142], 
        filter_ram[143]}), .D2({filter_ram[176], filter_ram[177], 
        filter_ram[178], filter_ram[179], filter_ram[180], filter_ram[181], 
        filter_ram[182], filter_ram[183], filter_ram[184], filter_ram[185], 
        filter_ram[186], filter_ram[187], filter_ram[188], filter_ram[189], 
        filter_ram[190], filter_ram[191], filter_ram[192], filter_ram[193], 
        filter_ram[194], filter_ram[195], filter_ram[196], filter_ram[197], 
        filter_ram[198], filter_ram[199], filter_ram[200], filter_ram[201], 
        filter_ram[202], filter_ram[203], filter_ram[204], filter_ram[205], 
        filter_ram[206], filter_ram[207], filter_ram[208], filter_ram[209], 
        filter_ram[210], filter_ram[211], filter_ram[212], filter_ram[213], 
        filter_ram[214], filter_ram[215], filter_ram[216], filter_ram[217], 
        filter_ram[218], filter_ram[219], filter_ram[220], filter_ram[221], 
        filter_ram[222], filter_ram[223], filter_ram[224], filter_ram[225], 
        filter_ram[226], filter_ram[227], filter_ram[228], filter_ram[229], 
        filter_ram[230], filter_ram[231]}), .D3({filter_ram[264], 
        filter_ram[265], filter_ram[266], filter_ram[267], filter_ram[268], 
        filter_ram[269], filter_ram[270], filter_ram[271], filter_ram[272], 
        filter_ram[273], filter_ram[274], filter_ram[275], filter_ram[276], 
        filter_ram[277], filter_ram[278], filter_ram[279], filter_ram[280], 
        filter_ram[281], filter_ram[282], filter_ram[283], filter_ram[284], 
        filter_ram[285], filter_ram[286], filter_ram[287], filter_ram[288], 
        filter_ram[289], filter_ram[290], filter_ram[291], filter_ram[292], 
        filter_ram[293], filter_ram[294], filter_ram[295], filter_ram[296], 
        filter_ram[297], filter_ram[298], filter_ram[299], filter_ram[300], 
        filter_ram[301], filter_ram[302], filter_ram[303], filter_ram[304], 
        filter_ram[305], filter_ram[306], filter_ram[307], filter_ram[308], 
        filter_ram[309], filter_ram[310], filter_ram[311], filter_ram[312], 
        filter_ram[313], filter_ram[314], filter_ram[315], filter_ram[316], 
        filter_ram[317], filter_ram[318], filter_ram[319]}), .S0(N129), .S1(
        N130), .Z({N210, N209, N208, N207, N206, N205, N204, N203, N202, N201, 
        N200, N199, N198, N197, N196, N195, N194, N193, N192, N191, N190, N189, 
        N188, N187, N186, N185, N184, N183, N182, N181, N180, N179, N178, N177, 
        N176, N175, N174, N173, N172, N171, N170, N169, N168, N167, N166, N165, 
        N164, N163, N162, N161, N160, N159, N158, N157, N156, N155}) );
  GTECH_BUF B_68 ( .A(filter_packet[35]), .Z(N129) );
  GTECH_BUF B_69 ( .A(filter_packet[36]), .Z(N130) );
  MUX_OP C3028 ( .D0({filter_ram[0], filter_ram[1], filter_ram[2], 
        filter_ram[3], filter_ram[4], filter_ram[5], filter_ram[6], 
        filter_ram[7], filter_ram[8], filter_ram[9], filter_ram[10], 
        filter_ram[11], filter_ram[12], filter_ram[13], filter_ram[14], 
        filter_ram[15], filter_ram[16], filter_ram[17], filter_ram[18], 
        filter_ram[19], filter_ram[20], filter_ram[21], filter_ram[22], 
        filter_ram[23], filter_ram[24], filter_ram[25], filter_ram[26], 
        filter_ram[27], filter_ram[28], filter_ram[29], filter_ram[30], 
        filter_ram[31], filter_ram[32], filter_ram[33], filter_ram[34], 
        filter_ram[35], filter_ram[36], filter_ram[37], filter_ram[38], 
        filter_ram[39], filter_ram[40], filter_ram[41], filter_ram[42], 
        filter_ram[43], filter_ram[44], filter_ram[45], filter_ram[46], 
        filter_ram[47], filter_ram[48], filter_ram[49], filter_ram[50], 
        filter_ram[51], filter_ram[52], filter_ram[53], filter_ram[54], 
        filter_ram[55], filter_ram[56], filter_ram[57], filter_ram[58], 
        filter_ram[59], filter_ram[60], filter_ram[61], filter_ram[62], 
        filter_ram[63], filter_ram[64], filter_ram[65], filter_ram[66], 
        filter_ram[67], filter_ram[68], filter_ram[69], filter_ram[70], 
        filter_ram[71], filter_ram[72], filter_ram[73], filter_ram[74], 
        filter_ram[75], filter_ram[76], filter_ram[77], filter_ram[78], 
        filter_ram[79], filter_ram[80], filter_ram[81], filter_ram[82], 
        filter_ram[83], filter_ram[84], filter_ram[85], filter_ram[86], 
        filter_ram[87]}), .D1({filter_ram[88], filter_ram[89], filter_ram[90], 
        filter_ram[91], filter_ram[92], filter_ram[93], filter_ram[94], 
        filter_ram[95], filter_ram[96], filter_ram[97], filter_ram[98], 
        filter_ram[99], filter_ram[100], filter_ram[101], filter_ram[102], 
        filter_ram[103], filter_ram[104], filter_ram[105], filter_ram[106], 
        filter_ram[107], filter_ram[108], filter_ram[109], filter_ram[110], 
        filter_ram[111], filter_ram[112], filter_ram[113], filter_ram[114], 
        filter_ram[115], filter_ram[116], filter_ram[117], filter_ram[118], 
        filter_ram[119], filter_ram[120], filter_ram[121], filter_ram[122], 
        filter_ram[123], filter_ram[124], filter_ram[125], filter_ram[126], 
        filter_ram[127], filter_ram[128], filter_ram[129], filter_ram[130], 
        filter_ram[131], filter_ram[132], filter_ram[133], filter_ram[134], 
        filter_ram[135], filter_ram[136], filter_ram[137], filter_ram[138], 
        filter_ram[139], filter_ram[140], filter_ram[141], filter_ram[142], 
        filter_ram[143], filter_ram[144], filter_ram[145], filter_ram[146], 
        filter_ram[147], filter_ram[148], filter_ram[149], filter_ram[150], 
        filter_ram[151], filter_ram[152], filter_ram[153], filter_ram[154], 
        filter_ram[155], filter_ram[156], filter_ram[157], filter_ram[158], 
        filter_ram[159], filter_ram[160], filter_ram[161], filter_ram[162], 
        filter_ram[163], filter_ram[164], filter_ram[165], filter_ram[166], 
        filter_ram[167], filter_ram[168], filter_ram[169], filter_ram[170], 
        filter_ram[171], filter_ram[172], filter_ram[173], filter_ram[174], 
        filter_ram[175]}), .D2({filter_ram[176], filter_ram[177], 
        filter_ram[178], filter_ram[179], filter_ram[180], filter_ram[181], 
        filter_ram[182], filter_ram[183], filter_ram[184], filter_ram[185], 
        filter_ram[186], filter_ram[187], filter_ram[188], filter_ram[189], 
        filter_ram[190], filter_ram[191], filter_ram[192], filter_ram[193], 
        filter_ram[194], filter_ram[195], filter_ram[196], filter_ram[197], 
        filter_ram[198], filter_ram[199], filter_ram[200], filter_ram[201], 
        filter_ram[202], filter_ram[203], filter_ram[204], filter_ram[205], 
        filter_ram[206], filter_ram[207], filter_ram[208], filter_ram[209], 
        filter_ram[210], filter_ram[211], filter_ram[212], filter_ram[213], 
        filter_ram[214], filter_ram[215], filter_ram[216], filter_ram[217], 
        filter_ram[218], filter_ram[219], filter_ram[220], filter_ram[221], 
        filter_ram[222], filter_ram[223], filter_ram[224], filter_ram[225], 
        filter_ram[226], filter_ram[227], filter_ram[228], filter_ram[229], 
        filter_ram[230], filter_ram[231], filter_ram[232], filter_ram[233], 
        filter_ram[234], filter_ram[235], filter_ram[236], filter_ram[237], 
        filter_ram[238], filter_ram[239], filter_ram[240], filter_ram[241], 
        filter_ram[242], filter_ram[243], filter_ram[244], filter_ram[245], 
        filter_ram[246], filter_ram[247], filter_ram[248], filter_ram[249], 
        filter_ram[250], filter_ram[251], filter_ram[252], filter_ram[253], 
        filter_ram[254], filter_ram[255], filter_ram[256], filter_ram[257], 
        filter_ram[258], filter_ram[259], filter_ram[260], filter_ram[261], 
        filter_ram[262], filter_ram[263]}), .D3({filter_ram[264], 
        filter_ram[265], filter_ram[266], filter_ram[267], filter_ram[268], 
        filter_ram[269], filter_ram[270], filter_ram[271], filter_ram[272], 
        filter_ram[273], filter_ram[274], filter_ram[275], filter_ram[276], 
        filter_ram[277], filter_ram[278], filter_ram[279], filter_ram[280], 
        filter_ram[281], filter_ram[282], filter_ram[283], filter_ram[284], 
        filter_ram[285], filter_ram[286], filter_ram[287], filter_ram[288], 
        filter_ram[289], filter_ram[290], filter_ram[291], filter_ram[292], 
        filter_ram[293], filter_ram[294], filter_ram[295], filter_ram[296], 
        filter_ram[297], filter_ram[298], filter_ram[299], filter_ram[300], 
        filter_ram[301], filter_ram[302], filter_ram[303], filter_ram[304], 
        filter_ram[305], filter_ram[306], filter_ram[307], filter_ram[308], 
        filter_ram[309], filter_ram[310], filter_ram[311], filter_ram[312], 
        filter_ram[313], filter_ram[314], filter_ram[315], filter_ram[316], 
        filter_ram[317], filter_ram[318], filter_ram[319], filter_ram[320], 
        filter_ram[321], filter_ram[322], filter_ram[323], filter_ram[324], 
        filter_ram[325], filter_ram[326], filter_ram[327], filter_ram[328], 
        filter_ram[329], filter_ram[330], filter_ram[331], filter_ram[332], 
        filter_ram[333], filter_ram[334], filter_ram[335], filter_ram[336], 
        filter_ram[337], filter_ram[338], filter_ram[339], filter_ram[340], 
        filter_ram[341], filter_ram[342], filter_ram[343], filter_ram[344], 
        filter_ram[345], filter_ram[346], filter_ram[347], filter_ram[348], 
        filter_ram[349], filter_ram[350], filter_ram[351]}), .S0(N131), .S1(
        N132), .Z({N428, N427, N426, N425, N424, N423, N422, N421, N420, N419, 
        N418, N417, N416, N415, N414, N413, N412, N411, N410, N409, N408, N407, 
        N406, N405, N404, N403, N402, N401, N400, N399, N398, N397, N396, N395, 
        N394, N393, N392, N391, N390, N389, N388, N387, N386, N385, N384, N383, 
        N382, N381, N380, N379, N378, N377, N376, N375, N374, N373, N372, N371, 
        N370, N369, N368, N367, N366, N365, N364, N363, N362, N361, N360, N359, 
        N358, N357, N356, N355, N354, N353, N352, N351, N350, N349, N348, N347, 
        N346, N345, N344, N343, N342, N341}) );
  GTECH_BUF B_70 ( .A(filter_ptr[0]), .Z(N131) );
  GTECH_BUF B_71 ( .A(filter_ptr[1]), .Z(N132) );
  MUX_OP C3029 ( .D0({psum_ram[0], psum_ram[1], psum_ram[2], psum_ram[3], 
        psum_ram[4], psum_ram[5], psum_ram[6], psum_ram[7], psum_ram[8], 
        psum_ram[9], psum_ram[10], psum_ram[11]}), .D1({psum_ram[12], 
        psum_ram[13], psum_ram[14], psum_ram[15], psum_ram[16], psum_ram[17], 
        psum_ram[18], psum_ram[19], psum_ram[20], psum_ram[21], psum_ram[22], 
        psum_ram[23]}), .D2({psum_ram[24], psum_ram[25], psum_ram[26], 
        psum_ram[27], psum_ram[28], psum_ram[29], psum_ram[30], psum_ram[31], 
        psum_ram[32], psum_ram[33], psum_ram[34], psum_ram[35]}), .D3({
        psum_ram[36], psum_ram[37], psum_ram[38], psum_ram[39], psum_ram[40], 
        psum_ram[41], psum_ram[42], psum_ram[43], psum_ram[44], psum_ram[45], 
        psum_ram[46], psum_ram[47]}), .S0(N133), .S1(N134), .Z({adder_inB[0], 
        adder_inB[1], adder_inB[2], adder_inB[3], adder_inB[4], adder_inB[5], 
        adder_inB[6], adder_inB[7], adder_inB[8], adder_inB[9], adder_inB[10], 
        adder_inB[11]}) );
  GTECH_BUF B_72 ( .A(filter_ptr_accum[0]), .Z(N133) );
  GTECH_BUF B_73 ( .A(filter_ptr_accum[1]), .Z(N134) );
  MUX_OP C3030 ( .D0(psum_ready[0]), .D1(psum_ready[1]), .D2(psum_ready[2]), 
        .D3(psum_ready[3]), .S0(N135), .S1(N136), .Z(N960) );
  GTECH_BUF B_74 ( .A(psum_in[12]), .Z(N135) );
  GTECH_BUF B_75 ( .A(psum_in[13]), .Z(N136) );
  MUX_OP C3031 ( .D0(psum_post_free_comb[0]), .D1(psum_post_free_comb[1]), 
        .D2(psum_post_free_comb[2]), .D3(psum_post_free_comb[3]), .S0(N137), 
        .S1(N138), .Z(N981) );
  GTECH_BUF B_76 ( .A(filter_ptr_wb[0]), .Z(N137) );
  GTECH_BUF B_77 ( .A(filter_ptr_wb[1]), .Z(N138) );
  MUX_OP C3032 ( .D0({psum_output_buffer[0], psum_output_buffer[1], 
        psum_output_buffer[2], psum_output_buffer[3], psum_output_buffer[4], 
        psum_output_buffer[5], psum_output_buffer[6], psum_output_buffer[7], 
        psum_output_buffer[8], psum_output_buffer[9], psum_output_buffer[10], 
        psum_output_buffer[11]}), .D1({psum_output_buffer[12], 
        psum_output_buffer[13], psum_output_buffer[14], psum_output_buffer[15], 
        psum_output_buffer[16], psum_output_buffer[17], psum_output_buffer[18], 
        psum_output_buffer[19], psum_output_buffer[20], psum_output_buffer[21], 
        psum_output_buffer[22], psum_output_buffer[23]}), .D2({
        psum_output_buffer[24], psum_output_buffer[25], psum_output_buffer[26], 
        psum_output_buffer[27], psum_output_buffer[28], psum_output_buffer[29], 
        psum_output_buffer[30], psum_output_buffer[31], psum_output_buffer[32], 
        psum_output_buffer[33], psum_output_buffer[34], psum_output_buffer[35]}), .D3({psum_output_buffer[36], psum_output_buffer[37], psum_output_buffer[38], 
        psum_output_buffer[39], psum_output_buffer[40], psum_output_buffer[41], 
        psum_output_buffer[42], psum_output_buffer[43], psum_output_buffer[44], 
        psum_output_buffer[45], psum_output_buffer[46], psum_output_buffer[47]}), .S0(N135), .S1(N136), .Z({n_1_net__0_, n_1_net__1_, n_1_net__2_, 
        n_1_net__3_, n_1_net__4_, n_1_net__5_, n_1_net__6_, n_1_net__7_, 
        n_1_net__8_, n_1_net__9_, n_1_net__10_, n_1_net__11_}) );
  GTECH_OR2 C3037 ( .A(change_mode), .B(rst), .Z(N139) );
  GTECH_NOT I_102 ( .A(N139), .Z(N140) );
  GTECH_NOT I_103 ( .A(rst), .Z(N144) );
  GTECH_AND2 C3040 ( .A(change_mode), .B(N144), .Z(N145) );
  GTECH_AND2 C3041 ( .A(N1097), .B(filter_packet[37]), .Z(N146) );
  GTECH_OR2 C3044 ( .A(N146), .B(rst), .Z(N147) );
  GTECH_NOT I_104 ( .A(N147), .Z(N148) );
  GTECH_OR2 C3046 ( .A(N1156), .B(N1157), .Z(N149) );
  GTECH_AND2 C3047 ( .A(N1073), .B(N1076), .Z(N1156) );
  GTECH_AND2 C3048 ( .A(N1078), .B(N1076), .Z(N1157) );
  GTECH_NOT I_105 ( .A(N149), .Z(N150) );
  GTECH_AND2 C3052 ( .A(N146), .B(N144), .Z(N307) );
  GTECH_AND2 C3057 ( .A(N1099), .B(N1158), .Z(conv_cnt_inc) );
  GTECH_NOT I_106 ( .A(stall), .Z(N1158) );
  GTECH_OR2 C3060 ( .A(change_mode), .B(conv_continue), .Z(N308) );
  GTECH_AND2 C3061 ( .A(N1081), .B(conv_cnt_inc), .Z(N309) );
  GTECH_OR2 C3064 ( .A(N309), .B(N308), .Z(N310) );
  GTECH_NOT I_107 ( .A(N310), .Z(N311) );
  GTECH_BUF B_78 ( .A(N329), .Z(N312) );
  GTECH_NOT I_108 ( .A(N313), .Z(N314) );
  GTECH_AND2 C3069 ( .A(N312), .B(N314), .Z(net276) );
  GTECH_NOT I_109 ( .A(N308), .Z(N328) );
  GTECH_AND2 C3071 ( .A(N309), .B(N328), .Z(N329) );
  GTECH_AND2 C3072 ( .A(N312), .B(N328), .Z(net275) );
  GTECH_AND2 C3074 ( .A(N1081), .B(N1158), .Z(N330) );
  GTECH_OR2 C3077 ( .A(N330), .B(change_mode), .Z(N331) );
  GTECH_NOT I_110 ( .A(N331), .Z(N332) );
  GTECH_BUF B_79 ( .A(N340), .Z(N333) );
  GTECH_NOT I_111 ( .A(change_mode), .Z(N339) );
  GTECH_AND2 C3081 ( .A(N330), .B(N339), .Z(N340) );
  GTECH_AND2 C3082 ( .A(N333), .B(N339), .Z(net277) );
  GTECH_AND2 C3083 ( .A(N1159), .B(conv_cnt_inc), .Z(N442) );
  GTECH_AND2 C3084 ( .A(N440), .B(N441), .Z(N1159) );
  GTECH_OR2 C3087 ( .A(conv_continue), .B(rst), .Z(N443) );
  GTECH_OR2 C3088 ( .A(N442), .B(N443), .Z(N444) );
  GTECH_NOT I_112 ( .A(N444), .Z(N445) );
  GTECH_AND2 C3091 ( .A(conv_continue), .B(N144), .Z(N448) );
  GTECH_NOT I_113 ( .A(conv_continue), .Z(N449) );
  GTECH_AND2 C3093 ( .A(N144), .B(N449), .Z(N450) );
  GTECH_AND2 C3094 ( .A(N442), .B(N450), .Z(N451) );
  GTECH_NOT I_114 ( .A(ifmap_packet[37]), .Z(N452) );
  GTECH_OR2 C3098 ( .A(N452), .B(N1080), .Z(N453) );
  GTECH_NOT I_115 ( .A(N453), .Z(N454) );
  GTECH_AND2 C3100 ( .A(cur_mode[1]), .B(cur_mode[0]), .Z(N455) );
  GTECH_NOT I_116 ( .A(N1080), .Z(N457) );
  GTECH_AND2 C3106 ( .A(N452), .B(N457), .Z(N458) );
  GTECH_AND2 C3109 ( .A(N1122), .B(N1126), .Z(N459) );
  GTECH_AND2 C3110 ( .A(N1143), .B(N1147), .Z(N460) );
  GTECH_AND2 C3111 ( .A(N1134), .B(N1138), .Z(N461) );
  GTECH_OR2 C3117 ( .A(conv_continue), .B(rst), .Z(N462) );
  GTECH_NOT I_117 ( .A(N462), .Z(N463) );
  GTECH_AND2 C3120 ( .A(conv_continue), .B(N144), .Z(N467) );
  GTECH_AND2 C3121 ( .A(N1160), .B(section_valid[0]), .Z(full) );
  GTECH_AND2 C3122 ( .A(section_valid[2]), .B(section_valid[1]), .Z(N1160) );
  GTECH_AND2 C3123 ( .A(section_valid[2]), .B(N1161), .Z(N468) );
  GTECH_NOT I_118 ( .A(section_to_free[2]), .Z(N1161) );
  GTECH_AND2 C3125 ( .A(section_valid[1]), .B(N1162), .Z(N469) );
  GTECH_NOT I_119 ( .A(section_to_free[1]), .Z(N1162) );
  GTECH_AND2 C3127 ( .A(section_valid[0]), .B(N1163), .Z(N470) );
  GTECH_NOT I_120 ( .A(section_to_free[0]), .Z(N1163) );
  GTECH_NOT I_121 ( .A(packet_in_valid), .Z(N471) );
  GTECH_NOT I_122 ( .A(N468), .Z(N472) );
  GTECH_NOT I_123 ( .A(N469), .Z(N473) );
  GTECH_NOT I_124 ( .A(N470), .Z(N474) );
  GTECH_NOT I_125 ( .A(N478), .Z(N479) );
  GTECH_NOT I_126 ( .A(N481), .Z(N482) );
  GTECH_NOT I_127 ( .A(N483), .Z(N484) );
  GTECH_NOT I_128 ( .A(N486), .Z(N487) );
  GTECH_NOT I_129 ( .A(N488), .Z(N489) );
  GTECH_NOT I_130 ( .A(N491), .Z(N492) );
  GTECH_OR2 C3153 ( .A(conv_continue), .B(rst), .Z(N502) );
  GTECH_OR2 C3154 ( .A(section_write[0]), .B(N502), .Z(N503) );
  GTECH_OR2 C3155 ( .A(section_write[1]), .B(N503), .Z(N504) );
  GTECH_OR2 C3156 ( .A(section_write[2]), .B(N504), .Z(N505) );
  GTECH_NOT I_131 ( .A(N505), .Z(N506) );
  GTECH_AND2 C3159 ( .A(conv_continue), .B(N144), .Z(N606) );
  GTECH_AND2 C3160 ( .A(N144), .B(N449), .Z(N607) );
  GTECH_AND2 C3161 ( .A(section_write[0]), .B(N607), .Z(N608) );
  GTECH_NOT I_132 ( .A(section_write[0]), .Z(N609) );
  GTECH_AND2 C3163 ( .A(N607), .B(N609), .Z(N610) );
  GTECH_AND2 C3164 ( .A(section_write[1]), .B(N610), .Z(N611) );
  GTECH_NOT I_133 ( .A(section_write[1]), .Z(N612) );
  GTECH_AND2 C3166 ( .A(N610), .B(N612), .Z(N613) );
  GTECH_AND2 C3167 ( .A(section_write[2]), .B(N613), .Z(N614) );
  GTECH_OR2 C3168 ( .A(N1153), .B(N1155), .Z(N615) );
  GTECH_OR2 C3171 ( .A(N621), .B(N615), .Z(N622) );
  GTECH_NOT I_134 ( .A(N622), .Z(N623) );
  GTECH_BUF B_80 ( .A(N615), .Z(N624) );
  GTECH_NOT I_135 ( .A(N630), .Z(N631) );
  GTECH_AND2 C3176 ( .A(N624), .B(N630), .Z(net278) );
  GTECH_AND2 C3177 ( .A(N624), .B(N631), .Z(net279) );
  GTECH_BUF B_81 ( .A(N662), .Z(N648) );
  GTECH_BUF B_82 ( .A(N623) );
  GTECH_NOT I_136 ( .A(N615), .Z(N661) );
  GTECH_AND2 C3181 ( .A(N621), .B(N661), .Z(N662) );
  GTECH_AND2 C3182 ( .A(N648), .B(N661), .Z(net280) );
  GTECH_AND2 C3183 ( .A(N1164), .B(N1056), .Z(N664) );
  GTECH_AND2 C3184 ( .A(N1158), .B(N663), .Z(N1164) );
  GTECH_OR2 C3188 ( .A(conv_continue), .B(rst), .Z(N665) );
  GTECH_OR2 C3189 ( .A(N664), .B(N665), .Z(N666) );
  GTECH_NOT I_137 ( .A(N666), .Z(N667) );
  GTECH_AND2 C3192 ( .A(conv_continue), .B(N144), .Z(N673) );
  GTECH_AND2 C3193 ( .A(N144), .B(N449), .Z(N674) );
  GTECH_AND2 C3194 ( .A(N664), .B(N674), .Z(N675) );
  GTECH_NOT I_138 ( .A(N681), .Z(N682) );
  GTECH_BUF B_83 ( .A(N681) );
  GTECH_BUF B_84 ( .A(N682) );
  GTECH_OR2 C3199 ( .A(N1173), .B(conv_done_soon), .Z(stall) );
  GTECH_OR2 C3200 ( .A(N1172), .B(accum_stall), .Z(N1173) );
  GTECH_OR2 C3201 ( .A(N1169), .B(N1171), .Z(N1172) );
  GTECH_OR2 C3202 ( .A(N1166), .B(N1168), .Z(N1169) );
  GTECH_AND2 C3203 ( .A(N1165), .B(N1103), .Z(N1166) );
  GTECH_NOT I_139 ( .A(section_valid[0]), .Z(N1165) );
  GTECH_AND2 C3205 ( .A(N1167), .B(N1107), .Z(N1168) );
  GTECH_NOT I_140 ( .A(section_valid[1]), .Z(N1167) );
  GTECH_AND2 C3207 ( .A(N1170), .B(N1111), .Z(N1171) );
  GTECH_NOT I_141 ( .A(section_valid[2]), .Z(N1170) );
  GTECH_NOT I_142 ( .A(N1178), .Z(data_valid) );
  GTECH_OR2 C3210 ( .A(N1176), .B(N1177), .Z(N1178) );
  GTECH_OR2 C3211 ( .A(N1174), .B(N1175), .Z(N1176) );
  GTECH_AND2 C3212 ( .A(N1165), .B(N1045), .Z(N1174) );
  GTECH_AND2 C3214 ( .A(N1167), .B(N1050), .Z(N1175) );
  GTECH_AND2 C3216 ( .A(N1170), .B(N1055), .Z(N1177) );
  GTECH_NOT I_143 ( .A(accum_stall), .Z(N707) );
  GTECH_OR2 C3221 ( .A(N707), .B(rst), .Z(N708) );
  GTECH_NOT I_144 ( .A(N708), .Z(N709) );
  GTECH_AND2 C3224 ( .A(N707), .B(N144), .Z(N735) );
  GTECH_OR2 C3228 ( .A(N707), .B(rst), .Z(N736) );
  GTECH_NOT I_145 ( .A(N736), .Z(N737) );
  GTECH_AND2 C3231 ( .A(N707), .B(N144), .Z(N751) );
  GTECH_AND2 C3236 ( .A(N707), .B(N1179), .Z(N753) );
  GTECH_AND2 C3238 ( .A(N752), .B(N1098), .Z(N1179) );
  GTECH_OR2 C3241 ( .A(conv_continue), .B(rst), .Z(N754) );
  GTECH_OR2 C3242 ( .A(N753), .B(N754), .Z(N755) );
  GTECH_NOT I_146 ( .A(N755), .Z(N756) );
  GTECH_BUF B_85 ( .A(N781), .Z(N757) );
  GTECH_NOT I_147 ( .A(N758), .Z(N759) );
  GTECH_AND2 C3247 ( .A(N757), .B(N759), .Z(net282) );
  GTECH_AND2 C3249 ( .A(conv_continue), .B(N144), .Z(N779) );
  GTECH_AND2 C3250 ( .A(N144), .B(N449), .Z(N780) );
  GTECH_AND2 C3251 ( .A(N753), .B(N780), .Z(N781) );
  GTECH_AND2 C3252 ( .A(N757), .B(N780), .Z(net281) );
  GTECH_OR2 C3257 ( .A(N707), .B(rst), .Z(N782) );
  GTECH_OR2 C3258 ( .A(stall), .B(N782), .Z(N783) );
  GTECH_NOT I_148 ( .A(N783), .Z(N784) );
  GTECH_AND2 C3261 ( .A(N707), .B(N144), .Z(N825) );
  GTECH_AND2 C3263 ( .A(N144), .B(accum_stall), .Z(N826) );
  GTECH_AND2 C3264 ( .A(stall), .B(N826), .Z(N827) );
  GTECH_AND2 C3265 ( .A(N828), .B(data_valid_wb), .Z(N829) );
  GTECH_OR2 C3269 ( .A(N829), .B(rst), .Z(N830) );
  GTECH_OR2 C3270 ( .A(data_valid_wb), .B(N830), .Z(N831) );
  GTECH_NOT I_149 ( .A(N831), .Z(N832) );
  GTECH_AND2 C3273 ( .A(N829), .B(N144), .Z(N893) );
  GTECH_NOT I_150 ( .A(N829), .Z(N894) );
  GTECH_AND2 C3275 ( .A(N144), .B(N894), .Z(N895) );
  GTECH_AND2 C3276 ( .A(data_valid_wb), .B(N895), .Z(N896) );
  GTECH_AND2 C3277 ( .A(N1180), .B(data_valid_wb), .Z(N898) );
  GTECH_AND2 C3278 ( .A(N707), .B(N897), .Z(N1180) );
  GTECH_OR2 C3281 ( .A(N898), .B(rst), .Z(N899) );
  GTECH_NOT I_151 ( .A(N899), .Z(N900) );
  GTECH_AND2 C3284 ( .A(N898), .B(N144), .Z(N957) );
  GTECH_OR2 C3285 ( .A(N1181), .B(psum_ack_in), .Z(N958) );
  GTECH_NOT I_152 ( .A(psum_out[14]), .Z(N1181) );
  GTECH_NOT I_153 ( .A(N958), .Z(N959) );
  GTECH_AND2 C3289 ( .A(psum_in[14]), .B(N960), .Z(N961) );
  GTECH_NOT I_154 ( .A(N961), .Z(N962) );
  GTECH_NOT I_155 ( .A(N963), .Z(N967) );
  GTECH_NOT I_156 ( .A(N964), .Z(N969) );
  GTECH_NOT I_157 ( .A(N965), .Z(N971) );
  GTECH_NOT I_158 ( .A(N966), .Z(N973) );
  GTECH_NOT I_159 ( .A(N979), .Z(N980) );
  GTECH_AND2 C3298 ( .A(N981), .B(data_valid_wb), .Z(N982) );
  GTECH_OR2 C3301 ( .A(data_valid_wb), .B(N982), .Z(N983) );
  GTECH_NOT I_160 ( .A(N983), .Z(N984) );
  GTECH_NOT I_161 ( .A(N985), .Z(N989) );
  GTECH_NOT I_162 ( .A(N986), .Z(N991) );
  GTECH_NOT I_163 ( .A(N987), .Z(N993) );
  GTECH_NOT I_164 ( .A(N988), .Z(N995) );
  GTECH_NOT I_165 ( .A(N982), .Z(N997) );
  GTECH_AND2 C3308 ( .A(data_valid_wb), .B(N997), .Z(N1003) );
  GTECH_NOT I_166 ( .A(rst), .Z(N1004) );
  GTECH_OR2 C3314 ( .A(psum_ack_out), .B(rst), .Z(N1009) );
  GTECH_OR2 C3315 ( .A(psum_ack_in), .B(N1009), .Z(N1010) );
  GTECH_NOT I_167 ( .A(N1010), .Z(N1011) );
  GTECH_AND2 C3318 ( .A(psum_ack_out), .B(N144), .Z(N1029) );
  GTECH_NOT I_168 ( .A(psum_ack_out), .Z(N1030) );
  GTECH_AND2 C3320 ( .A(N144), .B(N1030), .Z(N1031) );
  GTECH_AND2 C3321 ( .A(psum_ack_in), .B(N1031), .Z(N1032) );
  GTECH_AND2 C3322 ( .A(N1184), .B(conv_done_soon), .Z(N1033) );
  GTECH_AND2 C3323 ( .A(N1183), .B(N1072), .Z(N1184) );
  GTECH_AND2 C3324 ( .A(N1182), .B(N1068), .Z(N1183) );
  GTECH_AND2 C3325 ( .A(N1062), .B(N1064), .Z(N1182) );
  GTECH_OR2 C3327 ( .A(conv_continue), .B(rst), .Z(N1034) );
  GTECH_OR2 C3328 ( .A(N1033), .B(N1034), .Z(N1035) );
  GTECH_NOT I_169 ( .A(N1035), .Z(N1036) );
  GTECH_AND2 C3330 ( .A(conv_continue), .B(N144), .Z(N1039) );
  GTECH_AND2 C3331 ( .A(N144), .B(N449), .Z(N1040) );
  GTECH_AND2 C3332 ( .A(N1033), .B(N1040), .Z(N1041) );
  MULT_TC_OP MULT_mult_11 ( .A({1'b0, mult_inA}), .B(mult_inB), .Z({mult_out, 
        MULT_net702, MULT_net703, MULT_net704, MULT_net705, MULT_net706, 
        MULT_net707, MULT_net708, MULT_net709}) );
  GTECH_AND2 MAC_ADDER_C43 ( .A(MAC_ADDER_neg_overflow), .B(MAC_ADDER_N3), .Z(
        MAC_ADDER_N4) );
  GTECH_NOT MAC_ADDER_I_3 ( .A(MAC_ADDER_pos_overflow), .Z(MAC_ADDER_N3) );
  GTECH_NOT MAC_ADDER_I_2 ( .A(MAC_ADDER_N1), .Z(MAC_ADDER_N2) );
  GTECH_OR2 MAC_ADDER_C40 ( .A(MAC_ADDER_neg_overflow), .B(
        MAC_ADDER_pos_overflow), .Z(MAC_ADDER_N1) );
  GTECH_NOT MAC_ADDER_I_1 ( .A(MAC_ADDER_sum_temp[11]), .Z(MAC_ADDER_N6) );
  GTECH_AND2 MAC_ADDER_C36 ( .A(MAC_ADDER_N6), .B(MAC_ADDER_sum_temp[12]), .Z(
        MAC_ADDER_neg_overflow) );
  GTECH_NOT MAC_ADDER_I_0 ( .A(MAC_ADDER_sum_temp[12]), .Z(MAC_ADDER_N5) );
  GTECH_AND2 MAC_ADDER_C34 ( .A(MAC_ADDER_sum_temp[11]), .B(MAC_ADDER_N5), .Z(
        MAC_ADDER_pos_overflow) );
  GTECH_BUF MAC_ADDER_B_0 ( .A(MAC_ADDER_pos_overflow), .Z(MAC_ADDER_N0) );
  SELECT_OP MAC_ADDER_C31 ( .DATA1({1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b1}), .DATA2({1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3(
        MAC_ADDER_sum_temp[11:0]), .CONTROL1(MAC_ADDER_N0), .CONTROL2(
        MAC_ADDER_N4), .CONTROL3(MAC_ADDER_N2), .Z(adder_out) );
  ADD_TC_OP MAC_ADDER_add_13 ( .A({mult_out_ff[7], mult_out_ff[7], 
        mult_out_ff[7], mult_out_ff[7], mult_out_ff}), .B(adder_inB), .Z(
        MAC_ADDER_sum_temp) );
  GTECH_AND2 ACCUM_ADDER_C43 ( .A(ACCUM_ADDER_neg_overflow), .B(ACCUM_ADDER_N3), .Z(ACCUM_ADDER_N4) );
  GTECH_NOT ACCUM_ADDER_I_3 ( .A(ACCUM_ADDER_pos_overflow), .Z(ACCUM_ADDER_N3)
         );
  GTECH_NOT ACCUM_ADDER_I_2 ( .A(ACCUM_ADDER_N1), .Z(ACCUM_ADDER_N2) );
  GTECH_OR2 ACCUM_ADDER_C40 ( .A(ACCUM_ADDER_neg_overflow), .B(
        ACCUM_ADDER_pos_overflow), .Z(ACCUM_ADDER_N1) );
  GTECH_NOT ACCUM_ADDER_I_1 ( .A(ACCUM_ADDER_sum_temp[11]), .Z(ACCUM_ADDER_N6)
         );
  GTECH_AND2 ACCUM_ADDER_C36 ( .A(ACCUM_ADDER_N6), .B(ACCUM_ADDER_sum_temp[12]), .Z(ACCUM_ADDER_neg_overflow) );
  GTECH_NOT ACCUM_ADDER_I_0 ( .A(ACCUM_ADDER_sum_temp[12]), .Z(ACCUM_ADDER_N5)
         );
  GTECH_AND2 ACCUM_ADDER_C34 ( .A(ACCUM_ADDER_sum_temp[11]), .B(ACCUM_ADDER_N5), .Z(ACCUM_ADDER_pos_overflow) );
  GTECH_BUF ACCUM_ADDER_B_0 ( .A(ACCUM_ADDER_pos_overflow), .Z(ACCUM_ADDER_N0)
         );
  SELECT_OP ACCUM_ADDER_C31 ( .DATA1({1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1, 1'b1, 1'b1}), .DATA2({1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .DATA3(
        ACCUM_ADDER_sum_temp[11:0]), .CONTROL1(ACCUM_ADDER_N0), .CONTROL2(
        ACCUM_ADDER_N4), .CONTROL3(ACCUM_ADDER_N2), .Z(accum_adder_out) );
  ADD_TC_OP ACCUM_ADDER_add_13 ( .A(psum_in[11:0]), .B({n_1_net__11_, 
        n_1_net__10_, n_1_net__9_, n_1_net__8_, n_1_net__7_, n_1_net__6_, 
        n_1_net__5_, n_1_net__4_, n_1_net__3_, n_1_net__2_, n_1_net__1_, 
        n_1_net__0_}), .Z(ACCUM_ADDER_sum_temp) );
endmodule

