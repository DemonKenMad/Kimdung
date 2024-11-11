-- local texts = {}
module("localizable", package.seeall )

---============================================= how to use ==============================================
-- TextManager:getString("gameactivity_egg_kehuode")

-- local msg = TextManager:getString("common_function_openlevel")
-- msg = string.format(msg, msg)


-- toastMessage(TextManager:getString("common_not_buytimestoday"))
--------------------------------------------EquipmentManager------------------------------------------------

-- texts["modulename_function_txt_name"]   		= "以后的新功能这样使用中文"

modulename_function_txt_name 					= "以后的新功能这样使用中文"

-- =============================common tips=============================



common_act_error 								= "***Dữ liệu lỗi***"
common_data_error 								= "Dữ liệu bất thường"


common_data_error_tips 							= "Số liệu sai lệch"
common_no_server 								= "Không có phân khu cấp 2"
common_vip_level_buzu 							= "Không đủ cấp VIP"
common_todo_vip									= "VIP đạt [Lv{p1}] được mua"
common_vip_open									= "Cấp {v1} mở"
common_out_max_number							= "Vượt giới hạn mua"
common_level_buzu 								= "Không đủ cấp"
Common_good_buzu 			 					= "Bạn không đủ {p1}"
common_function_will_open 						= "Sắp mở, vui lòng chờ!"
common_team_level 								= "Cấp đội"

common_vip_not_tuhao1                           = "VIP15 trở lên mới được chat"
common_vip_tuhao_not_enough                     = "VIP{p1} chưa đạt"

common_function_openlevel                       = "Đội đạt cấp {p1} sẽ mở"
common_function_up_number                       = "Đội đạt cấp {p1} được ra trận {p2} tướng"
common_function_friend							= "Hảo Hữu mở khi đạt cấp {p1}"
common_function_number_out						= "Số người ra trận đã đầy"
common_team_level_notenough						= "Đội của bạn cần đạt cấp {p1}, vui lòng thử lại"

common_open_position				            = "Đội đạt cấp {p1} sẽ mở vị trí này"
common_tips 									= "Mẹo"
common_tips_zhuzhan								= "Đây là tướng trợ chiến, ra trận không thể trợ chiến, tiếp tục?"				
common_tips_zhuzhan_text1						= "Tướng này trợ chiến sẽ không sản sinh duyên phận, trợ chiến?"				
common_tips_zhuzhan_text2						= "Nhân vật cần phái đi tối thiểu 30 phút, xác nhận phái?"				
common_tips_team_text1							= "Đội cần phái đi tối thiểu 30 phút, xác nhận"

common_openlevel_text1 							= "Đội cấp {p1} mở"
commom_open 									="Đã mở"
commom_no_open 									="Chưa mở"
commom_no_open2 								="Tạm chưa mở"
common_tonguan									="Đã vượt"
common_open_level								="Cấp {p1} mở"
common_open_tips1								="Sắp mở, vui lòng chờ!"
common_nono                                     ="Chưa có"
common_no  										="Không"
common_free										="Miễn phí"
common_climb_openlevel 							= "Vô Lượng Sơn tầng {p1} mở"

common_get_score								="Nhận điểm"

common_no_yuanbao								= "Không đủ KNB"	
common_no_tongbi								= "Không đủ Đồng"

common_your_yuanbao								="Bạn không đủ KNB"
common_your_times								="Bạn đã dùng hết lượt"
common_not_buy_times							="Đã hết lượt mua"

common_team_unlock								="Đội cấp {p1} mở"
common_use_yuanbao_open							= "Tiêu {p1} KNB mở?"
common_unlock									= "Mở"
common_level_unlock								= "Cấp {p1} mở"
common_vip_unlock								="Cần đạt VIP{p1} để mở"
common_vip_tips									="Hãy nâng cấp VIP"

common_vip_change_layer_enough                  ="Bạn có gói quà VIP có thể mua"
common_vip_change_layer_not_enough              ="Không có quà VIP để mua"

common_please_check_one							= "Hãy chọn 1 cái"
common_dead										= "Đã tử trận không thể ra trận"

common_play_level_low							="Nhân vật này cấp quá thấp"
common_input_player_name						="Hãy nhập tên người chơi"
common_power_faction_low						="Không có quyền mời vào Bang"

common_faction_no_1								="(Bang Chủ)"
common_faction_no_2								="(Bang Phó)"
common_faction_no_3								="(Thành viên)"
			
common_no_power									="Không đủ quyền hạn"
common_fight_times								="Hôm nay đã hết lượt khiêu chiến"
common_wait										="Trống"
common_every_week								="Mỗi tuần"

common_all_hurt									="Tổng ST"
common_all_hurt2								="Tổng ST:"
common_all_body									="Toàn thể {p1}+{p2}%"
common_max_hurt									="ST tối đa:"
common_hurt   									="{p1} sát thương"

common_exp_add									="EXP+{p1}"
common_win_radio								="Tỉ lệ thắng {p1}%"

common_index_round								="Ải {p1}"
common_index_fight			  					="Trận {p1}"
common_index_ceng			  					="Tầng {p1}"
common_index_hui								="Hồi {p1}"
common_index_day								="Ngày {p1}"
common_index_chapter							="Chương {p1}"
common_index_chong								="Tầng {p1}"
											
common_left_hp									="HP còn"
common_hp_add									="HP +{p1}"

common_sys_notice								= "H.Thống"
common_unlock_suc								= "Mở thành công"
common_no_tiaozhancishu							= "Không đủ lượt khiêu chiến"
common_no_fight_times							= "Không đủ lượt khiêu chiến"
common_buy_suc									= "Mua thành công"
common_relogin									= "Đăng nhập lại"
common_wrong									= "Xảy ra lỗi"
common_net_wrong								= "Kết nối mạng thất bại"
common_net_desc									= "Kết nối server thất bại, kiểm tra kết nối mạng và thử lại"

common_net_reset_connnet						="Mạng bất thường, hãy kết nối lại..."
common_net_reset 								="Kết nối lại"

common_time_1									="{p1} giờ {p2} phút"
common_time_2									="{p1} phút"
common_time_3									="{p1} ngày {p2} giờ {p3} phút"
common_time_4									="{p1}.{p2} {p3} giờ {p4} phút "
common_time_5									="{p1} ngày {p2} giờ {p3} phút {p4} giây"
common_time_6									="{p1}.{p2} {p3}:{p4}"
common_time_7_ex									="{p1} ngày {p2} giờ {p3} phút {p4} giây"
common_time_8_ex								="{p1}.{p2}"

common_time_longlong							="Hiệu lực vĩnh viễn"
common_activity_time1							="Thời gian：{p1}"
common_activity_time2							="Còn：{p1}"
common_time_9 = "{p1} phút {p2} giây"

common_pay_tips_1								="Bạn không đủ KNB mua vật phẩm, vào nạp?"
common_pay_tips_2								="Nhắc trừ phí"
common_pay_tips_3								="Bạn đã làm mới thủ công 【{p1}】 lần, lần làm mới thủ công này cần 【 {p2} 】{p3}, làm mới?"

common_CE										="Chiến lực: {p1}"
common_ce2										="{p1} chiến lực"
common_ce_text									="Chiến lực:"

common_faction_CE								="Chiến lực Bang:{p1}"
commonTxt_level									= "d{p1}"
common_LV 										="Cấp {p1}"
common_times   									="{p1} lần"
common_ceng										="Tầng {p1}"
common_rank 									="Hạng {p1}"
common_zan 										="{p1} like"
common_chong 									="Tầng {p1}"
common_not_rank									="Chưa lọt BXH"
common_not_fight								="Chưa khiêu chiến"
common_not_know									="Chưa xác định"

common_count									="Nhận：{p1}"

common_tomax_times								="Đã đạt {p1} lần"
common_total_times								="Tối đa tích lũy {p1} lần"
common_pay_times								="Nạp theo mốc này tích lũy tối đa {p1} lần"
common_buy_times 								="(Còn được mua {p1} lần)"
common_reset_times 								="(Được cài lại {p1} lần)"


common_login_fail								="Đăng nhập thất bại"

common_person  									="Ra trận：{p1}/{p2}"
common_equip_max 								="C.hóa T.Bị tối đa： cấp {p1}"
common_player_max	 							="Cấp tướng tối đa：{p1}"
common_need_player_level						="Cấp anh hùng cần：{p1}"


commont_team_one								="Ra trận tối thiểu 1 tướng"

common_coin 									="Đồng"
common_gold										="KNB"
common_zhenqi									="Chân Khí"
common_hunpo									="Hồn"
common_level 									="EXP"
common_jinglu									="Tinh Lộ"
common_res 										="Tài nguyên"

common_not_record								="Chưa có log"
common_not_more_record							="Đã hết"

common_week_befor								="{p1} tuần trước"
common_day_befor								="{p1} ngày trước"
common_hour_befor								="{p1} giờ trước"
common_min_befor								="{p1} phút trước"
common_justnow									="Vừa mới"

common_get 										="Đã nhận"
common_get_box									="Bạn đã nhận rương này"
common_get_gold									="Đã nhận {p1} KNB"
common_get_award								="Đã nhận thưởng"
common_not_vip									="Chưa đạt cấp VIP tương ứng"


common_round_normal								="(Thường)"
common_round_high								="(Tông Sư)"
common_max_level								="Cấp tối đa"

common_not_contidion							="Không đủ điều kiện"
common_sweep									="Quét"
common_not_same_hero							="Chỉ cho 1 tướng ra trận"
common_prop_not_enough						    = "Không đủ vật phẩm"
common_power 									= "Chiến lực:"
-- =============================logic\activity --

activityLayer_text								 = {"Quần Hào Phổ","Vô Lượng Sơn","Nhạn Môn Quan","Ma Kha Nhai","Phục Ma Lục","Mỏ Thần Nông"}

-- =============================logic\arena
arenafightreport_rank 							= "Quần Hào Phổ"
arenafightreport_rank_no_change  				= "Hạng không đổi"
arenafightreport_rank_up  						= "Nâng lên hạng {p1}"

arenafightreport_rank_text1  					= "Hạng cao nhất:"
arenafightreport_rank_text2  					= "Trận chủ động:"
arenafightreport_rank_text3  					= "Chiến tích chủ động:"
arenafightreport_rank_text4  					= "Liên thắng chủ động tối đa:"
arenafightreport_rank_text5  					= "Số trận thủ:"
arenafightreport_rank_text6  					= "Chiến tích bị động:"
arenafightreport_rank_text7 					= "Liên thắng bị động tối đa:"
arenafightreport_win							= "Thắng"
arenafightreport_lose							= "Thua"
arenafightreport_win_lose						="{p1} thắng {p2} thua"
arenafightreport_text 							= "{p1} thắng {p2} thua"

arenaplaylistlayer_list							= "Hạng {p1}"
arenaresultlayer_text1 							= "Thành tích tốt nhất của bạn hiện là hạng {p1}.\nĐã tăng lên {p2} hạng."
arenarewardlayer_list							= "Hạng {p1}-{p2}"
-- =============================logic\army
-- =============================logic\assistFight
assistAgreeLayer_add							= "{p1} thêm {p2}%"
assistAgreeLayer_text1							= "Sau khi ăn ý, tướng trợ chiến sẽ cung cấp cho toàn bộ tướng ra trận {p1} của bản thân theo tỉ lệ nhất định"
assistAgreeLayer_text2							= "Ăn ý +{p1}"
assistAgreeLayer_all							= "Toàn t.tính"
assistAgreeLayer_no_pro							= "Vật phẩm ăn ý không đủ	"
assistAgreeLayer_top_level						= "Ăn ý đã đạt cấp tối đa"
assistAgreeLayer_open							= "Hãy mở khóa trước"
assistAgreeLayer_up_all							= "Ra trận toàn bộ tướng {p1}+{p2}"
assistAgreeLayer_open = "Hãy mở khóa trước"
Assist_Somebody_Assist_You = "{p1} trợ chiến bạn {p2}"
assistFightLayer_friend 						= "Đội hình này không thể dùng hảo hữu trợ chiến"
assistFightLayer_vip_unlock = "{v1} mở"
assistFightLayer_clibmLevel = "Vô Lượng Sơn tầng {p1}"
Assist_No_Assist_hero = "Chưa có hảo hữu trợ chiến"
Assist_UI_Assist = "Trợ chiến Hảo Hữu {p1} lần"
AssistFight_tips = "Đổi đội hình hợp lý, khắc chế địch để tăng phần thắng."
AssistFight_tips1 = "Ăn ý tăng:"
AssistFight_tips2 = "Lv40 mở tính năng ăn ý, tăng thêm thuộc tính cho tướng trợ chiến"

-- =============================logic\bag
bagPieceDetailsLayer_text1						= "Tổng tiêu {p1} đồng ghép võ công, tiếp tục?"						
bagPieceDetailsLayer_no_coin = "Không đủ Đồng để ghép võ công"
bagPieceDetailsLayer_text1 = "Tổng tiêu {p1} Đồng ghép võ công, tiếp tục?"
bagPropDetailsLayer_number = "{p1}"
bagPropDetailsLayer_exchange = "Được đổi {p1}"
BagManager_goods_use_level = "Đại hiệp, đạt cấp {p1} mới được dùng"
BagManager_no_enough_box = "Không đủ rương [{p1}]"
BagManager_no_enough_key = "Không đủ [{p1}], có thể tới shop mua"
-- =============================logic\BaseLayer.lua
-- =============================logic\BaseScene.lua
-- =============================logic\battle
-- =============================logic\bloodFight
bossFightMainLayer_Quanli						="{v1}开启全力一击功能。\n\n是否前往充值？"
bossFightMainLayer_QuanLiText					="Toàn Lực Nhất Kích có thể tạo gấp đôi sát thương, cần dùng 2 lần thách đấu, xác nhận?"
bloodFightArmyLayer_join						="Tướng Lv10 trở lên được tham gia Huyết Chiến"
bloodRewardBuy_next_box							="Hãy chọn 1 rương bất kỳ dưới đây"
bloodRewardBuy_get_box_tips  					="Chúc mừng đại hiệp nhận được 1 thưởng, tiêu KNB có thể mua 2 thưởng còn lại!"
bloodBattleMainLayer_please_fight				= "Hãy vượt qua {p1} trước"
bloodBattleMainLayer_up_vip				 		="Nâng VIP"
bloodBattleMainLayer_up_count			 		="Hôm nay đã hết lượt cổ vũ\n{v1} mỗi ngày được cổ vũ {p2} lần"
bloodBattleMainLayer_upto_vip			 		="Đạt {v1} mỗi ngày cổ vũ {p2} lần"
bloodBattleMainLayer_box_tips				 	="Vượt qua 4 ải phía trước được nhận rương"
bloodBattleMainLayer_no_times			 		="Hôm nay đã hết lượt cổ vũ"
bloodBattleMainLayer_reset		 				="Vượt ải càng nhiều, được quét càng nhiều, cài lại ngay?"
bloodBattleMainLayer_reset_tips			 		="Sau khi cài lại Nhạn Môn Quan, toàn bộ tiến độ và cổ vũ cộng thêm hiện tại sẽ xóa, hãy xác nhận"
bloodBattleMainLayer_up_success			 		="Cổ vũ thành công"
bloodyQuickPassLayer_fight_index				="Lần này đã quét {p1} ải"
bloodBattleMainLayer_ketiaozhan					="Thách đấu"
BloodFightManager_weikaiqi = "Chưa mở"
BloodFightManager_zhishaoshangzhenyiren = "Tối thiểu ra trận 1 tướng"
BloodFightManager_quanzhenwang = "Tướng ra trận đã tử vong toàn bộ, hãy bố trận lại"
-- =============================logic\bossfight
bossFightMainLayer_close						="Phục Ma Lục đã đóng!"
bossFightMainLayer_first						="Bạn đã đạt hạng 1"
bossFightMainLayer_hurt							="{p1} sát thương"
bossFightMainLayer_no_fight						="Hôm nay chưa thách đấu"


-- =============================logic\chat
chatBanned_no_speak								="Hãy chọn nút cấm chat"
chatMainLayer_input								="Nhập nội dung tại đây"
chatMainLayer_open_speak						="Đạt cấp {p1} được chat"
chatMainLayer_left_time							="Bạn còn {p1} lần chat miễn phí"
chatMainLayer_buy_horn							="Bạn không đủ “Còi”, tới shop mua?"
chatMainLayer_condition							="{v1} hoặc đội đạt cấp {p2} được chat"
chatMainLayer_no_time							="Hôm nay đã hết lượt chat miễn phí"
chatOperatePanel_no_permission					="Không có quyền mời vào Bang"
publicMessageCell_time_out						="Lời mời quá hạn"
-- =============================logic\climb
climb_name										= "Vô Lượng Sơn"
carbonDetailLayer_sweep_pro						="Lệnh Quét：{p1}"	
carbonDetailLayer_use							="Mỗi lần quét cần {p1}"
carbonDetailLayer_tips1							="Không đủ Lệnh Quét, dùng {p1} KNB quét?"
carbonMountain_cd								="Sau {p1} CD được thách đấu lại"
carbonMountainList_open                         ="Vô Lượng Sơn đạt tầng {p1} sẽ mở"
climbNorthLayer_reset							="Cài lại tiến độ Vô Lượng Sơn Bắc hiện tại?"
climbNorthLayer_onekey_tips						="Quét nhanh sẽ quét tới tầng cao nhất đạt được trong 1 lần, tự động chọn 9 KC đổi thuộc tính, quét?"

ClimbMountainListLayer_floor_desc             	= "Tầng {p1}"
Climb_isOnlySelfPowerTip 						= "Bạn đã mở ẩn buff đội\nXác nhận?"
-- =============================logic\common
openMore_key									="Số chìa："
openMore_box_number								="Số rương："
openMore_number_no_zero							="Số lượng phải khác {p1}"
replayLayer_buy_tili                            ="Mua thể lực" 
replayLayer_no_tili								="Không đủ thể lực"
replayLayer_buy_tili_tips						="Dùng {p1} KNB mua {p2} thể lực?"
replayLayer_today_left_times					="(Hôm nay còn {p1} lần mua)"

replayLayer_buy_climb                          ="Mua Đá Vô Lượng Sơn" 
replayLayer_no_climb							="Không đủ Đá Vô Lượng Sơn"
replayLayer_buy_climb_tips						="Dùng {p1} KNB bổ sung {p2} lượt thách đấu?"

replayLayer_buy_fight                           ="Mua Lệnh Thách Đấu" 
replayLayer_no_fight							="Không đủ Lệnh Thách Đấu"
replayLayer_buy_fight_tips						="Dùng {p1} KNB mua {p2} Lệnh Thách Đấu?"

replayLayer_buy_skill                           ="Hồi đầy điểm kỹ năng" 
replayLayer_no_skill							="Không đủ điểm kỹ năng"
replayLayer_buy_skill_tips						="Dùng {p1} KNB mua 10 điểm kỹ năng?"
tipsMessage_lefttime1							="Còn: {p1} giờ {p2} phút {p3} giây"						
tipsMessage_lefttime2							="Còn: {p1} ngày {p2} giờ {p3} phút {p4} giây"	
tipsMessage_lefttime3 = "Đếm ngược: {p1} ngày {p2} giờ {p3} phút {p4} giây"		

replayLayer_buy_Qi = "Mua Linh Khí"
replayLayer_no_Qi = "Không đủ Linh Khí"
replayLayer_buy_Qi_tips ="Dùng {p1} KNB bổ sung {p2} Linh Khí?"


-- =============================logic\default
-- =============================logic\employ
EmRoleArmyLayer_nothis_hero						="Không có tướng này"
EmRoleArmyLayer_once							="Mỗi trận đấu chỉ được ra trận 1 sát thủ"
EmSureLayer_text1								="Xác nhận thuê tướng của {p1}, cần trả "
EmSureLayer_text2								="Hôm nay không thể thuê tướng của {p1}"
EmTeamLayer_text1								="Chưa phái"
EmTeamSureLayer_text1							="Xác nhận thuê đội của {p1}, "
EmTeamSureLayer_text2							="Hôm nay không thể thuê thêm đội của {p1}"
ShowEmTeamLayer_team							="Đội của {p1}"
-- =============================logic\faction
applyLayer_exit_tips							="Thoát Bang chưa đủ 24 giờ "
applyLayer_text1								="Đã đạt lượng yêu cầu tối đa"
applyLayer_text2								="Hãy nhập ID Bang"

appointLayer_text1								="Đang nhượng"
appointLayer_text2								="Đang giải tán"
appointLayer_text3								="Đang luận tội"
appointLayer_text4								="Đã là Bang Phó"
appointLayer_text5								="Tối đa có 2 Bang Phó"
appointLayer_text6								="Đã là thành viên"

appointLayer_t_ren_tips							="Xác nhận loại {p1} khỏi Bang?"
appointLayer_out								="Khai trừ"
chapterListLayer_titleName						="Bang chương {p1}:{p2}"
ChapterListLayer_progress						="Tiến độ:{p1}/{p2}"
creatFaction_input								="Nhập tên Bang"
creatFaction_create_tips						="Dùng 500 KNB lập Bang\n\"{p1}\""
creatFaction_create 							="Lập Bang"
factionApply_open								="Lv28 trở lên được lập Bang"
factionApply_no_message							="Không có thông tin yêu cầu"

factionInfo_text1								="Bang Chủ đang nhượng chức"
factionInfo_text2								="Bang đang giải tán"
factionInfo_text3								="Bang Chủ đang bị luận tội"


factionInfo_exit_tips							="Xác nhận giải tán Bang, sau khi giải tán,\ntoàn bộ thành viên sẽ bị buộc giải tán"
factionInfo_exit								="Giải tán"
factionInfo_exit_stop							="Hủy"
factionInfo_exit_stop_tips						="Bang sẽ giải tán sau {p1}\n, dừng?"

factionInfo_exit_ok								="Xác nhận thoát Bang?\n(Cống hiến và kỹ năng Bang sẽ được bảo lưu)"
factionInfo_exit_fa								="Rời Bang"

factionInfo_xuanyan								="Tuyên ngôn"
factionInfo_gonggao								="Thông báo"
factionInfo_dingji								="Cấp Bang đã đạt tối đa"
factionInfo_jianyan								="Không đủ EXP"
factionInfo_exit_time							="Thoát Bang chưa quá 24 giờ"
factionInfo_edit_qizhi							="Sửa cờ Bang sắp mở"
factionInfo_play_online							="Online"

factionMembers_taihe_title						="Luận tội"
factionMembers_taihe							="Luận tối mất 24 giờ, sau khi thành công sẽ thành Bang Chủ, cần 500 KNB để luận tội?\n(Sau khi thất bại trả một nửa)"
factionMembers_taihe_conditidon					="Bang Chủ offline chưa đủ 7 ngày"
factionMembers_tanhe_level 						="Người phát động luận tội phải từ Lv30 trở lên"
factionMembers_taihe_stop						="Dừng luận tội?\n(Dừng sẽ mất 1/2 KNB)"
factionMembers_taihe_suc						="Bạn đã luận tội thành công"
factionMembers_taihe_timeout					="Thời gian luận tội đã quá hạn"
factionMembers_stop 							="Dừng luận tội"
factionMembers_tanhe_cause						="Không đủ lý do luận tội"

factionMembers_chanrang_tips					="Ngôi Bang Chủ sẽ nhượng lại sau {p1}\n, dừng?"
factionMembers_chanrang_suc						="Bạn đã nhượng thành công"
factionMembers_chanrang_timeout					="Thời gian nhượng quá hạn"
factionMembers_chanrang_stop					="Hủy"

factionHomeLayer_openlevel						="Bảo Các cần Bang đạt cấp {p1}"
factionRename_rename							="Đổi tên cần 1 {p1} (Còn：{p2})"
factionRename_rename_gold						="Đổi tên cần {p1} KNB"
factionRename_input								="Hãy nhập tên Bang"

houshanBoss_kill_tips							="Vượt ải： EXP Bang +{p1}     Phồn vinh Bang +{p2}"
houshanBoss_lefttimes							="Hôm nay còn："
houshanRank_rank								="Chưa lọt XH"
houshanLayer_chapter							="Chương {p1}  {p2}"
houshanLayer_times								="Lượt đấu："
houshanReward_hurt								="Tích lũy ra đòn:{p1}/{p2}"
rankingList_text								={"Cấp Bang","C.lực Bang"}
zhongyi_add1									="Phồn vinh Bang +{p1}"
zhongyi_add2									="EXP Bang +{p1}"
zhongyi_add3									="C.hiến cá nhân +{p1}"
zhongyi_text1									="Tế bái thành công"
zhongyi_text2									="Bang hôm nay đã tế bái hết {p1} lần"

jishitang_open									="Bang đạt cấp {p1} mở"
jishitang_txt_need							    ="Nhấp hình ảnh gửi yêu cầu mới"
jishitang_txt_need_reward						="Hôm nay hết lượt công bố"
jishitang_need_reward						    ="Công bố yêu cầu thành công"
jishitang_give_reward						    ="Đóng góp thành công"
jishitang_give_none						        ="Đã đạt yêu cầu"
jishitang_give_confirm						    ="Xác nhận tặng {p1} {p2} cho {p3}"
jishitang_have_item						        ="Có vật phẩm yêu cầu chưa nhận"
jishitang_noItem						        ="Không đủ vật phẩm đóng góp"
jishitang_achieve						        ="Hiệp nghĩa nhận từ đóng góp đạt {p1} được nhận"
jishitang_unOpen						        ="Tế Thế Đường chưa mở"

factionJiShiTang_ShouZeng						=[[<p style="text-align:left margin:5px"><font color="#000000" fontSize="20">[{p1}]   {p2} tặng bạn </font><font color="{p3}" fontSize="20"> {p4} </font>
	 												<font color="#000000" fontSize="20">x{p5}</font></p>]]

-- =============================logic\factionMall
-- =============================logic\factionPractice
practiceChooseLayer_check_hero					="Hãy chọn tướng"
practiceInResult_level							="Cấp {p1}"
practiceInResult_attr							="Thuộc tính {p1}"
practiceResult_level  							="Cấp tu luyện"
practiceStudyLayer_open_suc						="Mở thành công"
practiceStudyLayer_yanjiu_suc					="Nghiên cứu thành công"
PracticeInherit_cost							= "Kế thừa cần {p1} KNB"
PracticeInherit_desc1							= "Chọn tướng kế thừa"
PracticeInherit_desc2							= "Chọn tướng nhận kế thừa"
PracticeInherit_desc3							= "Không có kỹ năng để kế thừa"

-- =============================logic\fight
fight_FightUiLayer_auto_open 					= "VIP{p1} hoặc đội cấp {p2} sẽ mở"

-- =============================logic\friends
friendInfoLayer_faction							="Bang:{p1}"
friendInfoLayer_add_friend						="Hãy kết hảo hữu trước!"
friendInfoLayer_dele_friend						="Xóa hảo hữu này?"
-- =============================logic\gameactivity
goldEggItem_hammer_type							={"Búa Bạc", "Búa Vàng"}
goldEggItem_no_hammer							="Không đủ {p1}"
goldEggMain_egg_type							={"Trứng Bạc", "Trứng Vàng","Trứng Màu"}
goldEggMain_number								="(Hiện có {p1})"
goldEggMain_number0								="Được đập {p1} lần"
goldEggMain_number1								="Mỗi {p1} điểm được đập 1 lần"
goldEggMain_time1								="Tích điểm còn："
goldEggMain_time2								="Đóng sau："
goldEggMain_can_hammer							="Không đủ lượt đập trứng"
goldEggMain_brush_tdj							="Tiêu {p1} KNB làm mới thưởng đặc biệt?"
goldEggRecord_history							="Không có thêm log đập trứng"
goldEggRecord_player_history					={"Kỷ lực cá nhân", "Kỷ lục"}
goldEggRole_zhuanhuan							="Tướng này tự động đổi thành {p1} thẻ hồn cùng loại"
activity_comm_pay								="Nạp liên tục {p1} ngày"
activity_moneyshop_desc							={"Hồng Bảo", "Ngân Bảo", "Kim Bảo"}
activity_moneyshop_buy_tips						="Dùng {p1} KNB mua {p2}?\n\n(Trong sự kiện chỉ được mua 1 loại xu)"
activity_moneyshop_buy_suc						="Mua {p1} thành công"
activity_online_award							="Hãy nhận thưởng online phía trước đã"
exchangeCell_times_over							="Đã hết lượt đổi"
exchangeCell_not_enough							="Không đủ {p1}"
exchangeCell_count								="Lượt đổi còn：{p1}"
exchangeCell_exchange_tips						="Dùng [{p1}] đổi [{p2}] ?"
rewardItemcommmon_wan							="{p1} vạn"
activity_min_score								="Điểm lọt top"
activity_score_label 							= " Điểm Vào TOP"
activity_rank_reward1							="Thưởng hạng {p1}-{p2} tích điểm"
activity_rank_reward2							="Thưởng hạng {p1} tích điểm"
activity_user_reward							="Hạng {p1}:{p2}"
goldEggMain_get 								="{p1} đã nhận "

activity_recharge_text							="Hiện nạp "
activity_recharge_min_score						="Nạp tối thiểu giai đoạn h.tại"
activity_recharge_rank_reward1					="Thưởng hạng {p1}-{p2} nạp"
activity_recharge_rank_reward2					="Thưởng hạng {p1} nạp"
activity_fanli_des								={[1] = "Tiêu",[2] = "Nạp"}
activity_fanli_need								="Quay thưởng lần sau cần {p1}:"
activity_fanli_yuanbao							="{p1} KNB"

activity_fanli_Recode							=[[<p style="text-align:left margin:5px"><font color="#000000" fontSize="20">[{p1}]   nhận </font><font color="{p2}" fontSize="20"> {p3} </font>
	 												<font color="#000000" fontSize="20">x{p4}!</font></p>]]

activity_discount_holdnum						="Hiện có: {p1}"

activity_langhuan_tip1							="Vượt giới hạn lựa chọn"
activity_langhuan_tip2							="Rương vòng quay không đủ 8 vật phẩm, hãy điền lại"

activity_recharge_rank_tips1					="Tích nạp:"
activity_recharge_rank_tips2					="Tích tiêu:"
activity_recharge_rank_tips3					="Hạng:"
-- =============================logic\hermit
eatRoleIcon_tips1								="Tướng này đã mặc trang bị, hệ thống tự động gỡ trang bị để quy ẩn"
eatRoleIcon_tips2								="Tướng này đã mặc trang bị, hệ thống sẽ tự động gỡ trang bị để trùng sinh"
roleFireLayer_tips1								="Hãy đặt tướng/hồn cần quy ẩn"
roleFireLayer_tips2								="Lần quy ẩn này chứa tướng hoặc hồn bậc cao, sẽ nhận："
roleFireLayer_tips3								="Lần quy ẩn này nhận："
roleFireLayer_tips4								="Mỗi lần chỉ được quy ẩn 6 tướng"
roleFireLayer_not_delete						="Không có hồn để xóa"
roleReBirthLayer_getplayer						="Chọn tướng trùng sinh"
roleReBirthLayer_award1							="Lần trùng sinh này có tướng bậc cao, sẽ nhận "
roleReBirthLayer_award2							="Lần trùng sinh này nhận："
roleReBirthLayer_count							="Mỗi lần trùng sinh 1 tướng"
roleReBirthLayer_not							="Không có tướng để trùng sinh"
-- =============================logic\home
menuLayer_monthcard								="Thẻ Hào Hiệp"
menuLayer_monthcard_addattr						="Bạn là hội viên Thẻ Hào Hiệp, trong thời hạn có hiệu lực nhân vật nhận thêm：\nT.tính cơ bản =  500 + cấp đội*20"
menuLayer_chat1									="[Giang Hồ]"
menuLayer_chat2									="[Bang]"
menuLayer_chat3									="[Hảo Hữu]"
menuLayer_nextopen								="Cấp {p1} mở:{p2}"
-- =============================logic\illustration
IllEquDetaLayer_growup							="Trưởng thành {p1}:"
IllEquDetaLayer_base							="{p1} cơ bản:"
IllOutputLayer_Desc								={"Ải", "Quần Hào Phổ", "Vô Lượng Sơn", "Ma Kha Nhai", "Hộ Giá", "Long Môn Tiêu Cục", "Shop", "Chiêu mộ" ,"Rương Vàng", "Rương Bạc", "", "", ""}
IllOutputLayer_base								="(Thường)"
IllOutputLayer_big								="(Tông Sư)"
IllOutputLayer_tianshu							="(Du ngoạn)"
IllOutputLayer_zhenfa							="(Xung Trận)"
IllRoleDetaLayer_unlock							="{p1} mở khóa"
IllustrationUpStar_tips1 = "Tổng số sao đạt {p1}"
IllustrationUpStar_tips2 = "Toàn tướng ra trận {p1}+{p2}"
-- =============================logic\item
-- =============================logic\leaderboard
leaderboard_not_times							="Không đủ lượt like!"
leaderboard_update								="Cập nhật BXH"
-- =============================logic\login
createPlayer_check_player						="Hãy chọn nhân vật"
createPlayer_input_player						="Hãy nhập tên"
createPlayer_not_player							="Nhân vật không tồn tại"
createPlayer_create_fail						="Tạo nhân vật thất bại"
createPlayer_create_fail1						="Tên phải gồm 6-15 ký tự "

createPlayer_namelist = 
{
	[1] = "Cửu Kiếm Truyền Nhân",
	[2] = "Tín đồ Minh Giáo",
	[3] = "Môn hạ Nga My",
	[4] = "Hiệp Nghĩa Đồng Đạo",
}

createPlayer_desc = 
{
	[1] = "Cửu Kiếm Tuyệt Học không gì phá nổi",
	[2] = "Di Hoa Tiếp Mộc",
	[3] = "Đoạt Nhân Tâm Phách dễ như trở bàn tay",
	[4] = "Công Thủ Hội Tụ",
}

loginLayer_no_obb								="File obb không tồn tại, hãy tải lại"
loginLayer_input_account						="Nhập tài khoản"
loginNoticePage_check_server					="Chọn server"
loginNoticePage_please_login					="Hãy đăng nhập tài khoản"
loginNoticePage_login_fail						="Đăng nhập thất bại"
loginNoticePage_getserver_fail					="Nhận danh sách server thất bại, thử lại?"
serverChoice_stop								="{p1}(Bảo trì)"
serverChoice_serverstop							="Máy chủ đang bảo trì"
updateLaye_check_resource						="Đang kiểm tra tài nguyên mới nhất"
updateLaye_loading_lua							="{p1}/{p2} đang tải file local (Không tốn lưu lượng)"
updateLaye_loading_lua_over						="Tải file local xong, chuẩn bị vào game"
updateLaye_update_tips							="Đang cập nhật, đã tải {p1}%  ({p2}KB/{p3}KB)"
updateLaye_update_fail							="Cập nhật tài nguyên thất bại"
updateLaye_update_desc							="Phát hiện tài nguyên mới, tổng {p1}\n\nCập nhật ngay?"
updateLaye_update_lala							="Cập nhật tài nguyên rồi"
updateLaye_update_ok							="Cập nhật"
updateLaye_resource_version						="Phiên bản:{p1}"
updateLaye_check_resource_update				="Kiểm tra cập nhật tài nguyên"
updateLaye_check_resource_update_fail			="Tải tài nguyên thất bại, kiểm tra lại mạng"
updateLaye_update_fail_check_net				="Cập nhật thất bại, hãy kiểm tra mạng và thử lại"
updateLaye_reset								="Thử lại"

updatelayerNew_check_new_resource				="Phát hiện nội dung mới, tổng {p1}"
updatelayerNew_unZip_resource					="Tải xong giải nén tài nguyên"
updatelayerNew_curr_version						="Phiên bản h.tại:{p1}"

createPlayer_firstname = {"Tuyết Sơn","Phi Hồ","Thất Đạo","Song Kiếm","Giang Hồ","Tay Chân","Kiếm Khách","Đao Lang","Tình Kiếm",}
createPlayer_secondName ={"Đới Thần","Cam Đạo","Y Vị","Hà Tiểu","Dương Đại","Quách Thái","Lý Tứ","Đào Đại"}
-- =============================logic\main
fightLoadingLayer_loading						="Đang tải tài nguyên···  {p1}%"
fightLoadingLayer_loadingTips = "{p1}"
fightLoadingLayer_loading_over = "Tái nhập hoàn thành, đang ở tiến vào"
mainPlayerLayer_max_level						="Cấp tối đa"
ReNameLayer_input								="Nhập tên đội"
mainPlayerLayer_tuhao_xuanyan                   ="Tuyên ngôn VIP"
-- =============================logic\mall
buyCoinLayer_crit								="Bạo kích x{p1}"
randomStoreShopLayer_buy_number					="Lượng mua tối thiểu là 1 "

xiakezhuanhuan_role_not_enough                  ="Chọn tướng chuyển đổi"
xiakezhuanhuan_select_role                      ="Chọn tướng hoán công"
xiakezhuanhuan_change_role                      ="Xác nhận hoán công tướng?"
xiakezhuanhuan_xiulianzhong                     ="Tướng này đang trong tu luyện Bang"
xiakezhuanhuan_fail                             ="Hoán công thất bại"
xiakezhuanhuan_success                          ="Hoán công thành công"
xiakezhuanhuan_same_quality                     ="Chỉ hoán công tướng cùng phẩm chất"
-- =============================logic\message
-- =============================logic\mining
chooseMinLayer_trace							="Cực ít"
chooseMinLayer_little							="Ít"
chooseMinLayer_free								="Lượt miễn phí:{p1}"
LootEmBattleLayer_fight_time					="Chiến đấu sau"
LootEmBattleLayer_tips1							="Còn người hộ khoáng chưa bị đánh bại, thoát?"
LootEmBattleLayer_tips2							="Còn người khai thác chưa đánh bại, thoát?"
LootEmBattleLayer_not_reset						="Khi đầy máu không thể cài lại"
MiningFightReLayer_baoshidengji					={"Cấp 1","Cấp 2"}
MiningFightReLayer_dajie						="Cướp lần {p1}"
MiningLayer_benzhoubeiguyong					="Tuần này được thuê："
MiningLayer_text1								="Tuần này được thuê："
MiningLayer_text2								="Hiện có {p1} Khoáng Lệnh"

-- =============================logic\mission
missionAuto_cost								="(Dự kiến cần：{p1}"
missionAuto_times								="Thách đấu {p1} lần)"
missionAuto_tomorrow							="Đại hiệp, hãy quay lại vào ngày mai."
missionAuto_vip									="Chưa đủ cấp VIP"
missionAuto_vip_reset							="{v1} được cài lại lượt thách đấu"
missionAuto_reset 								="Dùng {p1} KNB cài lại lượt thách đấu ải này?"
missionAuto_reset_over							="\n\n(Hôm nay hết lượt cài lại)"
missionAuto_reset_times							="\n\n(Hôm nay còn {p1} lượt cài lại)"
missionDetail_xiaohao							="Mỗi lần quét cần {p1}"
missionDetail_today_free						="H.nay miễn phí：{p1}"
missionDetail_sweep								="{v1} mở quét nhiều lần nhanh.\n\nĐến nạp?"
missionDetail_upvip								="Nâng lên {v1} mỗi ngày được mua {p2} lần thách đấu.\n\nĐến nạp?"
missionDetail_upvip_over						="Hôm nay đã hết lượt mua!\n\nNâng lên {v1} mỗi ngày được mua {p2} lần thách đấu.\n\nĐến nạp?"
missionDetail_all_over							="Hết lượt thách đấu, hôm nay đã hết lượt cài lại"
missionDetail_reset								="Lần cài lại này cần {p1} Lệnh Cài Lại, cài lại?"
missionDetail_reset_text						="\n\n(Hiện có Lệnh Cài Lại：{p1}, hôm nay được cài lại {p2} lần"
missionDetail_sweep_times						="Lượt miễn phí còn lại và tổng Lệnh Quét không đủ, dùng {p1} KNB quét?"
missionDetail_fight								="Thách đấu"
missionLayer_please								="Hãy vượt ải trước\"{p1}{p2}-{p3}\"!"
missionLayer_start								="Cần toàn bộ 3 sao"
StarBoxPanel_stars								= "{p1} sao được nhận"
-- =============================logic\notify
notifyInfoLayer_fight_text1						="{p1} trong Quần Hào Phổ thách đấu bạn, bạn dễ dàng đánh bại hắn"
notifyInfoLayer_fight_text2						="{p1} trong Quần Hào Phổ đánh bại bạn, bạn rớt xuống hạng {p2}"
notifyInfoLayer_start_text1						="{p1} trong Kho Báu Giang Hồ định cướp Tinh Vị của bạn, bạn đã đánh bại hắn thành công"
notifyInfoLayer_start_text2						="{p1} trong Kho Báu Giang Hồ đã cướp Tinh Vị của bạn, nhận thưởng chiếm lĩnh：{p2} mảnh"
-- =============================logic\p.txt
-- =============================logic\pay
vipQQLayer_title1								="Kênh riêng"
vipQQLayer_content1								="Tại đây có CSKH hot girl tận tâm hỗ trợ~"
vipQQLayer_title2								="Quyền ưu tiên"
vipQQLayer_content2								="Bạn luôn là người đầu tiên nắm thông tin sự kiện~"
vipQQLayer_title3								="Phúc lợi"
vipQQLayer_content3								="Còn được nhận quà riêng và phúc lợi giá trị"
vipQQLayer_title4								="Vĩnh viễn"
vipQQLayer_content4								="Hưởng thụ trọn đời~"
vipQQLayer_input_qq								="Nhập tài khoản QQ"
vipQQLayer_copy_suc								="Chép thành công"
vipQQLayer_please_input							="Nhập mã mời QQ"
vipQQLayer_submit								="Đại hiệp, đã gửi số QQ thành công"
MonthCardLayer_tianshu 							= "Duy trì {p1} ngày"
MonthCardLayer_shuangyueka 						= "Kích hoạt thẻ tháng đôi mỗi ngày được nhận thưởng"
Pay_multiple_txt	 							= "{p1} tệ thêm"

-- =============================logic\home logic\fight logic\mission
getRewardWordDifficulty0						="{p1}-{p2} Thường nhận:"
getRewardWordDifficulty1						="{p1}-{p2} Tông Sư nhận:"
crossLevelstar1									="Vượt ải nhận"
crossLevelstar2									="2 sao nhận"
crossLevelstar3									="3 sao nhận"

-- =============================logic\playerback
playerbackMain_not_task							="Không có nhiệm vụ để nhận"
playerbackReward_code							="Hãy nhập mã mời của hảo hữu"
playerbackReward_code_null						="Mã mời không được trống"
-- =============================logic\qiyu
EscortingLayer_today_over						="Hôm nay đã nhận hết thưởng"
EscortTranLayer_yabiao_times_over				="Lượt áp tiêu hôm nay đã hết"
EscortTranLayer_vip								="{v1} mở tăng tốc"
InFriendAccLayer_invite							="Bạn đã được mời"
InFriendAccLayer_input_invite_code				="Hãy nhập mã mời"
InFriendAccLayer_char							="Mã mời chứa ký tự không hợp lệ"
InFriendAccLayer_already						="Đã từng được mời"
InFriendAccLayer_not							="Đại hiệp vẫn chưa chấp nhận lời mời"
InFriendLayerNew_desc							="Dưới cấp {p1} có thể nhận lời mời của người khác, nhận lời mời thành công được nhận thưởng hậu hĩnh!"
InFriendSendLayer_desc1							= "Võ hiệp Kim Dung tái xuất giang hồ. Game chiến đấu màn hình ngang hoàn toàn mới với các hệ thống dễ thao tác, 4 nhân vật chính, hàng trăm tướng cho bạn thoải mái lựa chọn. Các tuyệt chiêu và bí kíp võ công nổi tiếng biến hóa khôn lường, mau tới tham gia nào! Ta ở server "
InFriendSendLayer_desc2 						= ", trong mã mời nhập mã và nhấp nhận quà mới cùng xác thực tài khoản của ta"
InFriendSendLayer_desc3 						= ", sẽ nhận quà hấp dẫn!"
InFriendSendLayer_share							="Đại hiệp đã chép thành công, mau tới wechat chia sẻ thôi!"
monthCardBuy_buy_suc							="Mua thẻ tháng thành công"
monthCartGet_already							="Hôm nay đã nhận KNB rồi"
-- =============================logic\role
dogfoodIcon_chuangong							="Tướng này đã mặc trang bị, hãy gỡ trang bị trước khi truyền công"
equipOutLayer_chapter							="Chưa mở ải"
equipOutLayer_qunhao							="Quần Hào Phổ chưa mở"
mainSkillList_max								="Đã đạt tối đa"
mainSkillList_wuxue								="Võ công tầng {p1} sẽ mở"
mainSkillList_player							="Nhân vật Lv{p1} được dùng"
RoleTransferLayer_resetDesc						="Chưa chọn nguyên liệu truyền công, không cần cài lại!"
RoleTransferLayer_tishi							="Trong số thẻ đang nuốt có tướng hoặc hồn Tông Sư trở lên, nếu tiếp tục truyền công sẽ chuyển hóa thành EXP.\nTiếp tục?"
RoleTransferLayer_max_level 					= "Cấp đã đạt tối đa"
RoleTransferLayer_add_level						= "Cấp +{p1}"
role_train_names = {"Đới Mạch","Xung Mạch","Nhậm Mạch","Đốc Mạch","Duy Mạch","Khiêu Mạch"}
-- =============================logic\rolebook
roleBook_enchant_kulian							="Khổ luyện thành công"
roleBook_enchant_max_level						="Đã đạt tối đa"
roleBook_enchant_tips1							="Trong bí kíp đang nuốt có bí kíp cấp A, nếu tiếp tục sẽ nuốt sẽ chuyển hóa thành EXP.\nTiếp tục?"
roleBook_enchant_not_check						="Bạn chưa chọn nguyên liệu ghép"
roleBook_enchant_open							="Cần cù nhanh mở khi đạt {v1}"
roleBook_enchant_max_qinxue						="Đã đạt cấp cao nhất"
roleBook_enchant_yijian							="Dùng {p1} KNB cần cù nhanh"
roleBook_enchant_yijian_tips					="Cần cù nhanh"
roleBook_enchant_hecheng						="Không đủ sách để ghép"
roleBook_enchant_out_level						="Đã đạt cấp tối đa"
roleBook_hecheng_not_hecheng					="Cuốn sách này không thể ghép tiếp"
roleBook_hecheng_not_cailiao					="Không đủ nguyên liệu để ghép"
roleBook_equip_book								="Có {p1} cuốn"
roleBook_equip_level_notenough					="Nhân vật không đủ cấp để học"
-- =============================logic\role_new
MeridianLayer_text1								="Kinh mạch đã đạt cấp tối đa ở thời điểm hiện tại"
qimenduntupo_text1								="Kỳ Môn Tầng {p1}"
qimenduntupo_text2								="Toàn bộ tướng"
qimenduntupo_no_open							="Chưa mở"
roleInfoLayer_max								="Võ công hiện đã đạt tầng cao nhất"
roleInfoLayer_py_max							="Đạt Cấp Cao Nhất"
roleInfoLayer_py_vip							="VIP{p1} mở học nhanh"
roleInfoLayer_py_yijian							="Lần học nhanh này tổng cộng cần {p1} Đồng để ghép võ công, tiếp tục?"
roleInfoLayer_py_not							="Không đủ đồng để ghép võ công"
roleInfoLayer_py_condition						="Học toàn bộ 6 bí kíp võ công này mới được nâng bậc"
roleInfoLayer_py_unlock							="Tầng {p1} mở"
roleInfoLayer_py_wuxue							="Võ công tầng {p1}"
roleInfoLayer_py_goto							="Đến Ma Kha Nhai nhận thêm nhiều hồn nhân vật"
roleQualityUp_notenough							="Không đủ đạo cụ nâng phẩm"
roleQualityUp_useOmnipotentSoul					="Nhân vật không đủ hồn, dùng {p1} nâng phẩm"
roleQualityUp_tupo1								="Đột phá Kỳ Môn tầng {p1}"
roleQualityUp_tupo2								="Nhân vật đột phá lên {p1} sao"
roleQualityUp_tupo3								="Tướng đột phá lên {p1} sao"
roleQualityUp_jihuo								="{p1} sao kích hoạt"
roleStartupPre_needlevel						="Cấp y.cầu:{p1}"
roleStartupPre_xiahun							="Không đủ hồn"
roleStartupPre_player							="Cấp tướng chưa đạt"
roleStartupPre_pro								="Không đủ đạo cụ đột phá"
roleStartupPre_useOmnipotentSoul				="Nhân vật không đủ hồn, dùng {p1} đột phá?"
roleGradeUp_useOmnipotentSoul				="Nhân vật không đủ hồn, dùng {p1} nâng phẩm"
roleGradeUp_useFushebaoxue	= "Nhân vật không đủ Anh Hùng Huyết, dùng Xà Huyết X{p1} nâng phẩm"
roleGradeUp_useAll ="Nhân vật không đủ hồn, Anh Hùng Huyết, dùng {p1}、Xà Huyết X{p2} nâng phẩm?"
roleStartupPre_omnipotentSoulNum				="Có {p1} {p2}"
roleGradeUpFusheNunber = "Hiện có {p1} Xà Huyết"
roleGradeUpXiahunNunber = 	"Hiện có {p1} Hồn Vạn Năng"
roleStartupPre_msg								=
{
"1. Dùng hiệp nghĩa đổi tại Shop Hồn Tửu Quán",
"2. Mua trong Shop",
"3. Tại Quần Hào Phổ dùng điểm để đổi",
"4. Nhận trong Ải Tông Sư",
"5. Nhận hồn từ Nhạn Môn Quan, Ma Kha Nhai"
}
roleStartupPre_msg_0							=
{
"1. Nhận từ sự kiện",
"",
"",
"",
""
}
roleStartupPre_desc								= {"HP tăng", "Võ lực tăng", "Thủ tăng", "Nội lực tăng", "Thân pháp tăng"}
trainLayer_trainNames							={"Đới Mạch","Xung Mạch","Nhậm Mạch","Đốc Mạch","Khiêu Mạch","Duy Mạch"}
trainLayer_not									="Kinh mạch này chưa đủ cấp"
trainLayer_chengzhang							="{p1} tăng"
not_enough_jinglu								= "Không đủ Tinh Lộ"
-- =============================logic\SceneType.lua
-- =============================logic\setting
changetProLayer_have							="(Có：{p1})"
exchangeLayer_code								="Hãy nhập giftcode"
ChangeProfessionLayer_zhuanhuandanbuzu  		= "Không đủ Đan Chuyển Đổi"
ChangeProfessionLayer_zhuanhuantishi			="Chuyển đổi nhân vật?"

settingManager_text_vip                         ="Hiện cấp VIP"
settingManager_text_not_show_vip                ="Ẩn VIP"
settingManager_text_show_vip                    ="Hiện VIP"
settingManager_change_fail                      ="Sửa thất bại"

-- =============================logic\sevendays
sevendays_activity_over							="Kết thúc sau:"
sevendays_getaward_over							="Nhận thưởng còn:"
sevendays_tomorrow_login						="Đại hiệp hãy nhớ quay lại vào ngày mai"
sevendays_vip_less								="VIP chưa đạt yêu cầu"
sevendays_buy_tips								="Dùng {p1} KNB mua {p2} {p3}?"
sevendays_task_radio							="Chưa hoàn thành ({p1}/{p2})"
sevendays_over 									="Đã hoàn thành"
sevendays_buy									="Chỉ {p1} người đầu được mua (Còn {p2})"
-- =============================logic\shop
getRoleLayer_free								="Nhận miễn phí"
getRoleLayer_time_free							="{p1} sau miễn phí"
getRoleLayer_time								="Lượt mua còn：{p1}"
getRoleLayer_txt1								="Uống rượu"
getRoleLayer_txt2								="Không đủ lượt mua"
qiyuanLayer_free								="{p1}:{p2} sau miễn phí"
qiyuanLayer_free_times							="Miễn phí ({p1}/{p2})"
qiyuanLayer_buy									="Dùng {p1} KNB mua {p2} {p3} hồn?"
qiyuanLayer_check								="Chọn tướng cầu nguyện trước"
qiyuanLayer_qiyuan								="Hiện có hồn chưa mua, xác nhận cầu nguyện?"
qiyuanLayer_check_free							="Chọn tướng, được nhận miễn phí hồn tướng này"
youfangLayer_no_data = "Du Thương không có gì để bán"
-- =============================logic\smithy
smithy_attr_unknow 				= "Chưa rõ"
smithy_EquipmentRefining_toBuy = "Bạn không đủ [Đá Tinh Luyện], mở giao diện shop để mua?"
smithy_EquipmentRefining_jlsbuzu = "Không đủ Đá Tinh Luyện"
smithy_EquipmentRefining_jl1 	= "Tinh luyện nhanh sẽ tự động tinh luyện {p1} lần, tối đa mất {p2} KNB, tinh luyện đầy sẽ tự động dừng, xác nhận?"
smithy_EquipmentRefining_jl2 	= "Tinh luyện nhanh sẽ tự động tinh luyện {p1} lần, tinh luyện đầy sẽ tự động dừng, xác nhận?"
smithy_EquipmentRefining_max 	= "Toàn bộ thuộc tính đã tối đa"
smithy_EquipmentRefining_own 	= "(Có {p1})"
smithy_EquipmentRefining_vip 	= "{v1} được dùng"
smithy_EquipmentRefining_max	="(Đã tinh luyện tối đa)"
smithy_EquipmentRefining_level	="(Cần cường hóa T.Bị cấp {p1})"
smithy_EquipmentRefining_pro	="Không đủ vật phẩm"
smithy_EquipmentRefining_maxlevel = "Bạn đã đột phá lên cấp cao nhất"
smithy_EquipmentRefining_qianghua	="Cường hóa T.Bị đạt Lv{p1} được đột phá tiếp"
smithy_EquipmentStarUp_base1	="Võ lực cơ bản："
smithy_EquipmentStarUp_add1		="Võ lực tăng："
smithy_EquipmentStarUp_base2	="Thủ cơ bản："
smithy_EquipmentStarUp_add2		="Thủ tăng："
smithy_EquipmentStarUp_base3	="Nội lực cơ bản："
smithy_EquipmentStarUp_add3		="Nội lực tăng："
smithy_EquipmentStarUp_base4	="HP cơ bản："
smithy_EquipmentStarUp_add4		="HP tăng："
smithy_EquipmentStarUp_base5	="Thân pháp cơ bản："
smithy_EquipmentStarUp_add5		="Thân pháp tăng："
smithy_EquipmentStarUp_check	="Hãy chọn nguyên liệu"
smithy_EquipmentStarUp_max		="Một lần nuốt tối đa 5 món"
smithy_EquipmentStarUp_suc		="Tỉ lệ thành công đạt [100%], không cần chọn trang bị mới"
smithy_EquipmentStarUp_start	="Cấp sao hiện đã đạt tối đa"
smithy_EquipmentStarUp_start1   ="Mở khi trang bị đạt cấp 100"
smithy_EquipmentStarUp_radio	="Nâng sao thất bại, tỉ lệ bồi thường thành công [{p1}%]"
smithy_EquipmentStarUp_fail		="Nâng sao"
smithy_EquipmentStarUp_text1	="Bạn chọn trang bị đã khảm ngọc, xác nhận nuốt trang bị này?"
smithy_EquipmentStarUp_text2	="Bạn chọn trang bị đã nâng sao, xác nhận nuốt trang bị này?"
smithy_EquipmentStarUp_text3	="Bạn chọn trang bị đã cường hóa, xác nhận nuốt trang bị này?"
smithy_EquipmentStarUp_text4	="Bạn chọn trang bị hiếm, xác nhận nuốt trang bị này?"
smithy_EquipmentStarUp_text5    ="Hãy nâng trang bị lên cấp {p1}"
smithy_EquipmentStarUp_text6    ="T.tính cơ bản tăng：{p1}%"
smithy_EquipmentStarUp_text7    ="{p1} trang bị {p2} sao： thuộc tính cơ bản T.Bị +{p3}% ({p4}/{p5})"
smithy_EquipmentStarUp_text8    ="Đại hiệp, sau khi thêm nhanh hệ thống sẽ tự động nâng sao, tiếp tục?"

smithy_EquipPractice_store_tips	="Bạn không đủ [Đá Tẩy], mở giao diện shop để mua?"
smithy_EquipPractice_not_store	="Không đủ Đá Tẩy"
smithy_EquipPractice_all		="Toàn bộ thuộc tính đã khóa"
smithy_EquipPractice_ok_tips	="Khóa thuộc tính cần {p1} KNB, xác nhận tẩy?"
smithy_EquipPractice_tips1		="Tẩy sẽ thay đổi ngẫu nhiên thuộc tính kèm của trang bị, tẩy?"

smithy_EquipSell_max_equip		="Tối đa được chọn 15 trang bị!"
smithy_EquipSell_not_check		="Bạn chưa chọn trang bị!"
smithy_EquipSell_sell			="Lần bán này nhận："
smithy_EquipIcon_open			="Đội đạt cấp {p1} mở trang bị"
smithy_EquipGem_not_gem			="Không có ngọc khảm"
smithy_EquipGem_xiangqian		="Trang bị này không thể khảm ngọc {p1}"

smithyGemBuild_check_store		="Chọn ngọc bạn cần ghép"
smithyGemBuild_not_store		="Không đủ ngọc"
smithyGemBuild_not_coin			="Không đủ đồng"
smithyGemBuild_not_change		="Đang tự động ghép, không thể nhấp đổi mục tiêu"
smithyGemBuild_not_find			="Không tìm thấy dữ liệu ngọc này"
smithyGemBuild_max				="Ngọc này đã đạt cấp tối đa"
smithyGemBuild_not_in_bag		="Túi đồ không có ngọc này"
smithy_gem_not_six				="Không có ngọc dưới Lv9 để ghép"
smithyIntensify_max				="Đã đạt cấp tối đa, không thể cường hóa tiếp"
smithyIntensify_level			="Cấp c.hóa tối đa：{p1}"
smithyIntensify_not				="Không đủ {p1}"
smithyRecast_tips				="{p1} tiêu hao khi đúc lại trải qua {p2} cường hóa, xác nhận dùng để đúc lại (Đúc lại sẽ trả một phần nguyên liệu)"
smithyRecast_uplevel			="/Nâng cấp"
smithyRecast_upstart			="/Nâng sao"
smithyRecast_upjinglian			="/Tinh luyện"
smithyRecast_uprecast			="/Đúc lại"
smithyRecast_special			="Trang bị đặc biệt không thể dùng để đúc lại"
smithyIntensify_onekey			="Cường hóa nhanh toàn bộ trang bị tướng này?"
-- =============================logic\task
-- =============================logic\test
-- =============================logic\weekrace
weekrace_timeFont = {
    {
        "Cược còn:",
        "Đang đấu Tứ Kết:",
        "Bán kết bắt đầu sau:",
    },
    {
        "Cược còn:",
        "Đang đấu Bán Kết:",
        "Chung kết bắt đầu sau:",
    },
    {
        "Cược còn:",
        "Đang đấu Chung Kết:",
    }
}

weekrace_race_no_start = "Chưa bắt đầu"

weekrace_recordTitleFont = {
	{
		"Tứ Kết 1",
		"Tứ Kết 2",
		"Tứ Kết 3",
		"Tứ Kết 4"
	},
	{
		"Bán Kết 1",
		"Bán Kết 2"
	},
	{
		"Chung Kết"
	}
}

weekrace_yazhu = "Cược tối thiểu {p1}"



-- =============================logic\zhengba
zhengba_ZhengbaLayer_huodongweikaiqi = "Chưa bắt đầu"
zhengba_ZhengbaLayer_shengfu = "{p1} thắng {p2} thua"
zhengba_ZhengbaLayer_jiliansheng = "{p1} liên thắng"
zhengba_ZhengbaLayer_no_jion = "Chưa tham gia"
zhengba_ZhengbaLayer_no_rank = "Chưa lọt BXH"
zhengba_ZhengbaLayer_no_prize = "Đã nhận"
zhengba_ZhengbaLayer_liansheng = "Tấn công đạt {p1} liên thắng"
zhengba_ZhengbaLayer_duizhan = "Đối chiến {p1} lần"
zhengba_ZhengbaLayer_jifen = "Điểm：{p1}"
zhengba_ZhengbasaiArmyVSLayer_tishi = "Sau khi thoát, trong 30s tiếp theo không thể đối chiến tiếp, thoát?"

-- =============================gamedata\ActivityManager.lua
-- =============================gamedata\ArenaManager.lua
-- =============================gamedata\AssistFightManager.lua
AssistFightManager_NoRole = "Hãy bố trận trước"
-- =============================gamedata\BagManager.lua
BagManager_goods_use_level  = "Đạt cấp {p1} mới được dùng"
BagManager_no_enough_box  	= "Không đủ rương [{p1}]"
BagManager_no_enough_key  	= "Không đủ [{p1}], đến shop mua"
BagManager_toast_text1 = "Không phải rương và chìa：{p1}"
BagManager_unlock_no_compound = "Không thể ghép khung ảnh đã mở khóa"
BagManager_buzu_no_compound = "Không đủ đạo cụ để ghép khung ảnh!"
BagManager_compound_success = "Ghép {p1} thành công"


-- =============================gamedata\BloodFightManager.lua
BloodFightManager_weikaiqi  			= "Chưa mở"
BloodFightManager_zhishaoshangzhenyiren  = "Ra trận tối thiểu 1 người"
BloodFightManager_quanzhenwang  		= "Đã tử vong toàn bộ, hãy bố trận lại"

-- =============================gamedata\BossFightManager.lua
BossFightManager_no_changlle_time = "Lượt thách đấu hôm nay đã hết"

-- =============================gamedata\CardRoleManager.lua
CardRoleManager_shifoguiyin = "Tướng này đang sử dụng, xác nhận quy ẩn?"
CardRoleManager_shiforebirth = "Tướng này đang sử dụng, trùng sinh?"

-- =============================gamedata\ChatManager.lua
ChatManager_level_limit = "Cấp {p1} được dùng chat"
ChatManager_no_tool 	= "Không có còi"
ChatManager_empty_msg 	= "Hãy nhập nội dung chat"
ChatManager_same_msg 	= "Trong thời gian ngắn không gửi thông tin trùng"
ChatManager_cd_msg 		= "Chat còn {p1} giây"
ChatManager_no_friend 	= "Đối phương không còn là hảo hữu"
ChatManager_forb_chat 	= "Cấm chat thành công"
ChatManager_jubao 		= "Báo lỗi thành công"
ChatManager_jubao_1 		= "{p1} do gửi nội dung không phù hợp bị khóa chat {p2} ngày"
ChatManager_jubao_2 		= "{p1} do gửi nội dung không phù hợp bị khóa chat {p2} giờ"
ChatManager_level_limit2 = "Cấp {p1} được chat liên server"


-- =============================gamedata\ClimbManager.lua
-- =============================gamedata\CommonManager.lua
CommonManager_good_num_desc = "{p1} {p2}"
CommonManager_good_duihuan = "Đổi {p1}"
CommonManager_change_name = "Đổi tên thành công"
CommonManager_other_user_login = "Tài khoản của bạn đã đăng nhập nơi khác! Đăng nhập lại?"
CommonManager_new_version_tips  = "Có phiên bản mới, hãy update!"
CommonManager_update_version1  = "Cập nhật tài nguyên rồi"
CommonManager_update_version2  = "Cập nhật"
CommonManager_vip_up = "Nâng VIP"
CommonManager_new_version_check  = "Kiểm tra cập nhật bất thường, hãy khởi động lại game kiểm tra!"
CommonManager_new_check  = "Kiểm tra cập nhật"
CommonManager_new_version  = "Kết nối lỗi, kiểm tra lại mạng?"

CommonManager_need_vip  = "{v1} được mua thể lực.\n\nĐến nạp?"
CommonManager_need_vip2 = "{v1} được mua Đá Vô Lượng Sơn.\n\nĐến nạp?"
CommonManager_need_vip3 = "{v1} được mua Lệnh Thách Đấu.\n\nĐến nạp?"
CommonManager_need_vip4 = "{v1} được dùng KNB mua điểm kỹ năng.\n\nĐến nạp?"

CommonManager_need_up_vip  = "Hôm nay đã hết lượt mua!\n\nNâng lên {v1} được mua {p2} lần.\n\nĐến nạp?"
CommonManager_need_up_vip2 = "Hôm nay đã hết lượt mua!\n\nNâng lên {v1} được dùng KNB mua {p2} lần.\n\nĐến nạp?";

CommonManager_out_time = "Đã hết lượt mua"
CommonManager_out_time_today = "Hôm nay đã hết lượt mua"
CommonManager_out_time_today2 = "Không đủ thể lực, hôm nay đã hết lượt mua"
CommonManager_out_time_today3 = "Không đủ Đá Vô Lượng Sơn, hôm nay đã hết lượt mua"
CommonManager_out_time_today4 = "Không đủ Lệnh Thách Đấu, hôm nay đã hết lượt mua"
CommonManager_out_time_today5 = "Không đủ điểm kỹ năng, hôm nay đã hết lượt mua"

CommonManager_tili_not_enough = "Không đủ thể lực"
CommonManager_wuliangshanshi_not_enough = "Không đủ Đá Vô Lượng Sơn"
CommonManager_challenge_not_enough = "Không đủ Lệnh Thách Đấu"
CommonManager_skillpoint_not_enough = "Không đủ điểm kỹ năng"

CommonManager_tili_zengjia = "Thể lực tăng {p1}"
CommonManager_wuliangshanshi_add = "Đá Vô Lượng Sơn tăng {p1}"
CommonManager_challenge_increase = "Lệnh Thách Đấu tăng {p1}"

CommonManager_relogin = "Bạn chỉ cần nhấp “Đăng nhập lại” là ổn rồi."
CommonManager_update = "Đã cập nhật tài nguyên,\n\nHiện tại：{p1};Mới nhất：{p2}" 
CommonManager_update_now = "Cập nhật ngay"

CommonManager_number = "{p1}"
CommonManager_choose_server = "Hãy chọn server"
CommonManager_skill_add = "Gia tăng"
CommonManager_skill_sub = "Giảm bớt"
CommonManager_buff_Tips = "Nhưng chồng lên"




-- =============================gamedata\EmployManager.lua
EmployManager_role_is_full  = "Đã đặt đủ nhân vật"



-- =============================gamedata\EquipmentManager.lua
EquipmentManager_equip_wufaxilian  = "Không thể tẩy trang bị cấp D"

-- =============================gamedata\ErrorCodeManager.lua
ErrorCodeManager_unknowen_error = "Lỗi chưa xác định {p1}"
-- =============================gamedata\FactionManager.lua

FactionManager_msgPostTemplate = {
	"Bang Chủ",
	"Bang Phó",
	"Thành viên"
}
FactionManager_msgDrinkTemplate = {
	"Bát Tửu",
	"Huyết Tửu",
	"Tuyên thệ"
}

FactionManager_msgRecordTemplate = {
	"Chào mừng {p1} vào Bang, hãy chào đón nồng nhiệt",
	"{p1} đã rời Bang",
	"Với sự nỗ lực của toàn bộ thành viên, Bang đã lên Lv{p1}!",
	"{p1} {p2} tế bái {p3}",
	"{p1} được nhượng làm Bang Chủ, 24h sau có hiệu lực,",
	"{p1} được bổ nhiệm làm Bang Phó",
	"{p1} bị giáng làm thành viên",
	"{p1} bị khai trừ khỏi Bang",
	"Bang Chủ đã hủy nhượng",
	"Chúc mừng {p1} trở thành Bang Chủ mới!",
	"Bang Chủ bị luận tội, đang tiến hành bỏ phiếu",
	"Luận tội thành công, chúc mừng {p1} Bang Chủ mới",
	"Bang Chủ {p1} đã online kịp thời, tránh được luận tội",
	"{p1} hủy luận tội",
	"-----",
	"-----",
	"Bang lần đầu vượt ải chương {p1}, sẽ lưu vĩnh viễn trong BXH",
	"Tốc độ vượt ải chương {p1} của Bang ở Hậu Sơn đã lên hạng {p2}",
	"{p1} đã đánh bại {p2}, Bang nhận {p3} EXP, {p4} Phồn Vinh",
	"{p1} tại Hậu Sơn đã mở chương {p2}",
	"{p1} tại Hậu Sơn đã cài lại chương {p2}",
	"Khu Tu Luyện {p1} mở",
	"Bang đổi tên thành “{p1}”",
	"Bang đã sửa cờ thành công",
	"{p1} đã nhận lì xì do {p2} phát trị giá {p3} KNB",
	"{p1} trong Bang đã phát lì xì tổng trị giá {p2}",
	"Bang sắp bắt đầu diễn võ, hãy chú ý!",
	"Bang đã bắt đầu diễn võ, khí thế thật oai phong!",
	"{p1} trong Bang đã phát lì xì sôi nổi tổng trị giá 1000"
}


FactionManager_create_fation  	="Chúc mừng bạn đã tạo Bang của riêng mình!"
FactionManager_join_fation  	="Chúc mừng bạn vào Bang!"
FactionManager_leave_fation 	= "Bạn bị loại khỏi Bang"
FactionManager_jiejiao_fation 	= "Kết giao thành công, tăng {p1} thể lực"
FactionManager_shanrang_fation 	= "Bạn đã nhượng chức Bang Chủ cho người khác, hãy chờ thêm 24 giờ"
FactionManager_shanrang_qx  	= "Bạn đã hủy nhượng"
FactionManager_rengming  		= "Bổ nhiệm thành công"
FactionManager_24_jiesan  		= "Bang sẽ giải tán sau 24h nữa"
FactionManager_zhongzhi_jiesan 	= "Đã dừng giải tán Bang"
FactionManager_modify 			= "Đã sửa nội dung"
FactionManager_open_practice 	= "Khu Tu Luyện {p1} mở"
FactionManager_open_practice2   = "Khu Tu Luyện {p1} mở, tới tu luyện nào"
FactionManager_uplevel_practice = "Khu Tu Luyện cấp {p1} nghiên cứu đến cấp {p2}"
FactionManager_uplevel_practice2 = "Khu Tu Luyện cấp {p1} nghiên cứu đến cấp {p2}, có thể thăng cấp rồi"
FactionManager_kill_boss        = "{p1} đã hoàn thành nhiệm vụ chương {p2} đánh bại {p3}, thưởng đã phát qua thư!"
FactionManager_modify_qizhi     = "Bang đổi tên thành “{p1}”, một cái tên thật hay"
FactionManager_modify_qizhi2     = "Bang đã sửa cờ thành công, mau tới xem thôi"
FactionManager_xx_join_fation      = "{p1} vào Bang thành công"
FactionManager_clear_msg      	= "Đã xóa thông tin yêu cầu"
FactionManager_invite_suc      = "Mời thành công"
FactionManager_invite_req      = "“{p1}” mời bạn vào {p2}, đồng ý?"
FactionManager_time      		= "{p1} giờ {p2} phút"
FactionManager_houshan_dengji      		= "Hậu Sơn cần Bang Lv{p1}"
FactionManager_jibai_1			= "[{p1}]"
FactionManager_jibai_2			= "{p1}{p2} cần {p3}{p4} tế bái {p5}, trung nghĩa +{p6}, Phồn vinh Bang +{p7}, EXP Bang +{p8}, cống hiến cá nhân +{p9}."

-- =============================gamedata\FactionPracticeManager.lua
-- =============================gamedata\FateManager.lua
-- =============================gamedata\FightManager.lua
-- =============================gamedata\FriendManager.lua
FriendManager_list_req_all = "Đã yêu cầu toàn bộ danh sách"
FriendManager_list_req_send = "Đã gửi yêu cầu"
FriendManager_list_empty = "Danh sách không có thông tin yêu cầu"
FriendManager_gift_all = "Đã tặng quà cho toàn bộ hảo hữu"
FriendManager_gift_get = "Đã nhận toàn bộ quà"
FriendManager_login_time_now = "Vừa mới đây"
FriendManager_login_time_min = "Đăng nhập gần đây：{p1} phút trước"
FriendManager_login_time_hour = "Đăng nhập gần đây：{p1} giờ trước"
FriendManager_login_time_day = "Đăng nhập gần đây：{p1} ngày trước"
FriendManager_login_time_week = "Đăng nhập gần đây：{p1} tuần trước"

FriendManager_login_time_min_ex = "{p1} phút trước"
FriendManager_login_time_hour_ex = "{p1} giờ trước"
FriendManager_login_time_day_ex = "{p1} ngày trước"
FriendManager_login_time_week_ex = "{p1} tuần trước"

-- =============================gamedata\.lua
GameActivitiesManager_no_acitivty = "Sự kiện chưa mở"
GameActivitiesManager_online_yiwan = "Đã nhận hết thưởng online hôm nay"
GameActivitiesManager_online_shijianweidao = "Chưa đến đếm ngược"
GameActivitiesManager_not_open_activity = "Sự kiện chưa mở"

GameActivitiesManager_yuanbao 			= "KNB"
GameActivitiesManager_day 				= " ngày"
GameActivitiesManager_leijichongzhi 	= "Tích nạp"
GameActivitiesManager_danbichongzhi 	= "Nạp Gói"
GameActivitiesManager_leijixiaofei 		= "Tích tiêu"
GameActivitiesManager_tianshu 			= "Số ngày đăng nhập"
GameActivitiesManager_denglu 			= "Đăng nhập "
GameActivitiesManager_dengji 			= "Cấp đạt "
GameActivitiesManager_dijitianleichong	= "Tích nạp ngày {p1}"
GameActivitiesManager_dijitian = "Ngày {p1}..."
GameActivitiesManager_direnyichong = "Ngày {p1} nạp mốc bất kỳ"
GameActivitiesManager_countineRechargeDay = "Tích nạp {p1} ngày"
GameActivitiesManager_countineRechargeMoney = "Tích nạp {p1} KNB"
GameActivitiesManager_VIPGiftText1 = "H.nay nhận"
GameActivitiesManager_VIPGiftText2 = "H.nay mua"
GameActivitiesManager_VIPGiftText3 = "Dùng {p1} KNB mua?"

-- =============================gamedata\GameResourceManager.lua

-- =============================gamedata\GetCardManager.lua
-- =============================gamedata\GoldEggManager.lua
GoldEggManager_no_eggacitivty = "Chưa mở Đập Trứng"
GoldEggManager_type = {"1 Trứng Bạc","2 Trứng Vàng","3 Trứng Màu"}

-- =============================gamedata\HoushanManager.lua
-- =============================gamedata\IllustrationManager.lua
IllustrationManager_tips = 
{

	[1] = "Chưa mở ải",
	[2] = "Quần Hào Phổ chưa mở",
	[3] = "Vô Lượng Sơn chưa mở",
	[4] = "Ma Kha Nhai chưa mở",
	[17] = "Hàng ngày chưa mở",
	[18] = "Nhạn Môn Quan chưa mở",
	[20] = "Cầu nguyện chưa mở"
}
IllustrationManager_not_open = "Cầu nguyện chưa mở"
IllustrationManager_not_open1 = "Lv{p1} mở Thư Các"

-- =============================gamedata\MainPlayer.lua
MainPlayer_money_desc 			= "{p1} vạn"
MainPlayer_tili_tixing 			= "Thể lực đã đầy, hãy sử dụng tránh lãng phí"
MainPlayer_tili_name 			= "Thể lực đấu PB"
MainPlayer_jinengdian_tixing 	= "Điểm kỹ năng đã đầy, mau nâng cấp thôi!"
MainPlayer_jinengdian_name 		= "Điểm kỹ năng"
MainPlayer_double_exp			= "EXP đa bội"
MainPlayer_no_double_exp		= "Không có EXP đa bội thêm"
MainPlayer_double_desx			= "Chúc mừng nhận EXP đa bội thêm!\nTrong thời gian x2\n EXP đội và tướng trong ải sẽ tăng {p1} lần"

-- =============================gamedata\MallManager.lua
MallManager_refresh_tool			= "Lần làm mới này cần {p1} Lệnh Làm Mới, xác nhận?\n\n(Hiện có Lệnh Làm Mới：{p2})"
MallManager_mall_open				= "{p1} mở"
MallManager_up_vip_tip = "Hôm nay đã hết lượt mua!\n\nNâng VIP để tăng lượt mua.\n\nĐến nạp?"
MallManager_vip_up = "Nâng VIP"
MallManager_out_time = "Đã hết lượt mua"
MallManager_out_time_tip = "Hôm nay đã hết lượt mua, không thể mua thêm vật phẩm này"
MallManager_refresh_tip = "Lần làm mới này cần {p1} Lệnh Làm Mới, xác nhận?"

-- =============================gamedata\MiningManager.lua
MiningManager_no_mine_user 		= "Tạm thời không có người khai mỏ"
MiningManager_no_fight_report	= "Không có chiến báo chi tiết"

-- =============================gamedata\MissionManager.lua
MissionManager_mission_typy1 = "Thường"
MissionManager_mission_typy2 = "Tông Sư"
MissionManager_reset_time 	 = "Đã cài lại lượt thách đấu"
MissionManager_layer_is_open = "Đã mở giao diện ải, hãy về giao diện"


-- =============================gamedata\MonthCardManager.lua
MonthCardManager_buy_suc 	= "Mua thẻ tháng thành công"

-- =============================gamedata\NiuBilityManager.lua
NiuBilityManager_dianzan 	= "Bạn đã like hắn rồi"

-- =============================gamedata\NorthClimbManager.lua
NorthClimbManager_choose_att_next_level = "Hãy chọn thuộc tính để vào ải sau"
NorthClimbManager_reward_title 			= "Vượt tầng này được nhận"



-- =============================gamedata\NotifyManager.lua (还没有弄 放到后面 )
NotifyManager_getRole_strFormat =
	{
		[[<p style="text-align:left margin:5px">
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> hôm nay cùng </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> kết nghĩa kim lan!</font></p>]],

		[[<p style="text-align:left margin:5px">
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> chiêu mộ thành công </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26">, thật đáng chúc mừng!</font></p>]],

		[[<p style="text-align:left margin:5px">
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> đã chiêu mộ </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26">, mau tới xem nào!</font></p>]],
	}
NotifyManager_getRole_strFormatChat =
	{
		[[<p style="text-align:left margin:5px">
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26"> hôm nay cùng </font><font color="{p2}" fontSize="26">{p3}</font><font color="#000000" fontSize="26"> kết nghĩa kim lan!</font></p>]],

		[[<p style="text-align:left margin:5px">
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26"> chiêu mộ thành công </font><font color="{p2}" fontSize="26">{p3}</font><font color="#000000" fontSize="26">, thật đáng mừng!</font></p>]],

		[[<p style="text-align:left margin:5px">
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26"> đã chiêu mộ </font><font color="{p2}" fontSize="26">{p3}</font><font color="#000000" fontSize="26">, mau tới xem nào!</font></p>]],
	}

NotifyManager_getEquip_strFormat =
	{
		[[<p style="text-align:left margin:5px">
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> đã nhận </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> x{p4}, sắp tới ngày nhất thống giang hồ!</font></p>]],

		[[<p style="text-align:left margin:5px">
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> đã nhận </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> x{p4}, mau tới xem nào!</font></p>]],
	}

NotifyManager_getEquip_strFormatChat =
	{
		[[<p style="text-align:left margin:5px">
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26"> đã nhận </font><font color="{p2}" fontSize="26">{p3}</font><font color="#000000" fontSize="26"> x{p4}, sắp tới ngày nhất thống giang hồ!</font></p>]],

		[[<p style="text-align:left margin:5px">
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26"> đã nhận </font><font color="{p2}" fontSize="26">{p3}</font><font color="#000000" fontSize="26"> x{p4}, mau tới xem nào!</font></p>]],
	}

NotifyManager_arena_strFormat = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Quần Hào Luận Kiếm, thống soái Võ Lâm! Trạng Nguyên：</font>
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26">, Bảng Nhãn：</font><font color="#ff4ef5" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26">, Thám Hoa：</font><font color="#FF0000" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26">, ngày mai ai sẽ chiếm lấy ngôi đầu?</font></p>]]

NotifyManager_ArenaBalanceTrailer_strFormat = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Quần Hào Phổ sẽ tổng kết vào 21：00, ai sẽ trở thành bá chủ! Hồi hộp chờ đón khoảnh khắc tranh đoạt ngôi vị bá chủ Võ Lâm!</font></p>]]

NotifyManager_WorldBoss_strFormat = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Tẩu hỏa nhập ma, vạn người diệt trừ</font>
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> khiến Boss Phục Ma Lục chịu </font><font color="#ff4ef5" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> sát thương, </font><font color="#FF0000" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26">, </font><font color="#FF0000" fontSize="26">{p4}</font><font color="#ffffff" fontSize="26"> theo ngay sau, lần lượt tạo </font><font color="#FF0000" fontSize="26">{p5}</font><font color="#FFFFFF" fontSize="26">, </font><font color="#FF0000" fontSize="26">{p6}</font><font color="#FFFFFF" fontSize="26"> sát thương</font></p>]]

NotifyManager_WorldBoss_strFormatAdd1 = [[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1}</font>
                            <font color="#ffffff" fontSize="26">Trong Phục Ma Lục đại hiệp đánh bại </font>
                            <font color="#ff4ef5" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26">, nhưng giang hồ chưa sạch bóng Ma Đạo, </font>
                            <font color="#FF0000" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> sau khi tu luyện sẽ nhanh chóng quay lại.</font></p>]]

NotifyManager_Email_empty = "Hòm thư của ngài đã trống!"

NotifyManager_Email_candel = "Hiện không có thư để xóa"
NotifyManager_Email_bukeling = "Không có thư để nhận"
NotifyManager_Email_shanchuchenggong = "Xóa thư đã đọc thành công"
NotifyManager_LangHuan_tip1 = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> chúc phúc trong Phúc Địa nhận </font>
		{p2}!</font></p>]]

NotifyManager_ArenaChange_strFormatChat =[[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26"> Quần Hảo Phổ đã được viết lại </font>
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26">  trong Quần Hào Phổ đánh bại </font>
		<font color="#ff0000" fontSize="26">{p2}</font><font color="#000000" fontSize="26">, đạt hạng {p3}!</font></p>]]

NotifyManager_ArenaChange_strFormat =[[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26"> Quần Hảo Phổ đã được viết lại </font>
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26">  trong Quần Hào Phổ đánh bại </font>
		<font color="#feff8f" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26">, đạt hạng {p3}!</font></p>]]



NotifyManager_ClimbPass_strFormatChat =[[<p style="text-align:left margin:5px"><font color="#ff0000" fontSize="26">{p1}</font>
		<font color="#000000" fontSize="26"> tại Vô Lượng Sơn bất ngờ đánh bại địch mạnh ải </font><font color="#ff0000" fontSize="26"> {p2} </font>
		<font color="#000000" fontSize="26">, thật đáng ngưỡng mộ!</font></p>]]
NotifyManager_ClimbPass_strFormat =[[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1}</font>
		<font color="#ffffff" fontSize="26"> tại Vô Lượng Sơn bất ngờ đánh bại địch mạnh ải </font><font color="#feff8f" fontSize="26"> {p2} </font>
		<font color="#ffffff" fontSize="26">, thật đáng ngưỡng mộ!</font></p>]]


NotifyManager_HeroTop_strFormatChat =[[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26">Sấm chớp rền vang, mây ngũ sắc hiện, thì ra là hạng 1 Anh Hùng Bảng </font>
		<font color="#ff0000" fontSize="26"> {p1} </font>
		<font color="#000000" fontSize="26"> vừa online!</font></p>]]
NotifyManager_HeroTop_strFormat =[[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Sấm chớp rền vang, mây ngũ sắc hiện, thì ra là hạng 1 Anh Hùng Bảng </font>
		<font color="#feff8f" fontSize="26"> {p1} </font>
		<font color="#ffffff" fontSize="26"> vừa online!</font></p>]]

NotifyManager_ArenaTop_strFormatChat =[[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26">Xung quanh bỗng tĩnh lặng, một luồng bá khí ập đến, thì ra là hạng 1 Quần Hào Phổ </font>
		<font color="#ff0000" fontSize="26"> {p1} </font>
		<font color="#000000" fontSize="26"> vừa online!</font></p>]]
NotifyManager_ArenaTop_strFormat =[[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Xung quanh bỗng tĩnh lặng, một luồng bá khí ập đến, thì ra là hạng 1 Quần Hào Phổ </font>
		<font color="#feff8f" fontSize="26"> {p1} </font>
		<font color="#ffffff" fontSize="26"> vừa online!</font></p>]]

NotifyManager_vip_strFormatChat=[[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26">Một làn gió ấm áp ùa về, thì ra là 【Hoàng-VIP】 </font>
			<font color="#ff0000" fontSize="26"> {p1} </font>
			<font color="#000000" fontSize="26"> vừa online!</font></p>]]
			
NotifyManager_vip_strFormat =[[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Một làn gió ấm áp ùa về, thì ra là 【Hoàng-VIP】 </font>
			<font color="#feff8f" fontSize="26"> {p1} </font>
			<font color="#ffffff" fontSize="26"> vừa online!</font></p>]]
NotifyManager_GoldEgg_rewarddesc = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Chúc mừng </font>
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> trong Đập Trứng, đập {p2} đã nhận </font><font color="{p3}" fontSize="26">{p4}</font><font color="#ffffff" fontSize="26">x{p5}</font></p>]]

NotifyManager_GoldEgg_chatMsg = [[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26">Chúc mừng </font>
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26"> trong Đập Trứng, đập {p2} đã nhận </font><font color="{p3}" fontSize="26">{p4}</font><font color="#000000" fontSize="26">x{p5}</font></p>]]

NotifyManager_GoldEgg_eggDesc = {"Trứng Bạc","Trứng Vàng","Trứng Màu"}


NotifyManager_FationRank_strTemplete = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">
		{p1} lần đầu vượt Hậu Sơn chương {p2}, sẽ vĩnh viễn lưu danh trên BXH</font></p>]]
NotifyManager_FationRank_strTempleteChat = [[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26">
		{p1} lần đầu vượt Hậu Sơn chương {p2}, sẽ vĩnh viễn lưu danh trên BXH</font></p>]]

NotifyManager_FationRank_strTempleteChat2 = [[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26">
		Dưới dẫn dắt của {p1}, {p2} tiến độ vượt Hậu Sơn chương {p3} đã tăng lên hạng {p4}</font></p>]]

NotifyManager_FationRank_strTempleteChat3 = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">
		Hạng 1： Bang {p1} áp đảo quần hùng, trong Tranh Bá Bang lần này giành ngôi đầu!</font></p>]]
		
NotifyManager_FationRank_strTempleteChat4 = [[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> đột phá thành công tầng {p2}, nhận thưởng </font><font color="{p3}" fontSize="26">{p4}</font><font color="#ffffff" fontSize="26"> x{p5}!</font></p>]]

NotifyManager_FationRank_strTempleteChat5 = [[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> phá trận thành công, nhận thưởng </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> x{p4}!</font></p>]]

NotifyManager_Peak_strTempleteChat1 = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Server </font><font color="feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> chiếm Trận Nhãn cả tầng {p2} Đỉnh Luận Kiếm, mau tới xem nào!</font></p>]]

NotifyManager_Peak_strTempleteChat2 = [[<p style="text-align:left margin:5px"><font color="feff8f" fontSize="26">s{p1}.{p2}</font><font color="#ffffff" fontSize="26"> đã phá được sự đồng lòng của </font><font color="feff8f" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26">, mau tới xem nào! (Nhất thống giang hồ không còn xa!)</font></p>]]

NotifyManager_XunBao_strFormatChat = {
		[[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> trong Tầm Bảo đã nhận </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> x{p4}, mau tới xem nào!</font></p>]],
		[[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> trong Tầm Bảo đã nhận </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> x{p4}, sắp tới ngày nhất thống giang hồ!</font></p>]]
	}

NotifyManager_Xiakexing_strFormatChat = {
        [[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> trong Đoạt Bảo đã nhận </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> x{p4}, mau tới xem nào!</font></p>]],
        [[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> trong Đoạt Bảo đã nhận </font><font color="{p2}" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> x{p4}, sắp tới ngày nhất thống giang hồ!</font></p>]]
    }

NotifyManager_TianJiLun_strTempleteChat = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Chúc mừng server </font><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> </font><font color="#feff8f" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> phá được thiên cơ, trong Thiên Cơ Luân nhận </font><font color="{p3}" fontSize="26">{p4}</font><font color="#ffffff" fontSize="26"> x{p5}!</font></p>]]
NotifyManager_RedPacket_strTempleteChat1 = [[<p style="text-align:left margin:5px">Bang <font color="#ffffff" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> </font><font color="#feff8f" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> phát lì xì có tổng trị giá </font><font color="#ffffff" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> KNB</font></p>]]
NotifyManager_RedPacket_strTempleteChat2 = [[<p style="text-align:left margin:5px">Bang <font color="#ffffff" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> </font><font color="#feff8f" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> đã nhận </font><font color="#feff8f" fontSize="26">{p3}</font><font color="#ffffff" fontSize="26"> phát lì xì </font><font color="#ffffff" fontSize="26">{p4}</font><font color="#ffffff" fontSize="26"> KNB</font></p>]]
NotifyManager_nobody = "Vô danh"

NotifyManager_operationStrFormat1 =  ", thông qua ghép ngọc, "
NotifyManager_operationStrFormat2 =  ", thông qua gỡ ngọc, "
NotifyManager_operationStrFormat3 = ", thông qua nâng sao T.Bị, "
NotifyManager_operationStrFormat4 = ", thông qua bán T.Bị, "
NotifyManager_operationStrFormat5 = ", thông qua đúc lại T.Bị, "

NotifyManager_obtainGemNotify_strFormat = {
		[[<p style="text-align:left margin:5px">
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> đã nhận </font><font color="{p3}" fontSize="26">{p4}</font><font color="#ffffff" fontSize="26"> x{p5}, sắp tới ngày nhất thống giang hồ!</font></p>]],

		[[<p style="text-align:left margin:5px">
		<font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> đã nhận </font><font color="{p3}" fontSize="26">{p4}</font><font color="#ffffff" fontSize="26"> x{p5}, mau tới xem nào!</font></p>]],
	}
NotifyManager_obtainGemNotify_strFormatChat = {
		[[<p style="text-align:left margin:5px">
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26">{p2}</font><font color="#000000" fontSize="26"> đã nhận </font><font color="{p3}" fontSize="26">{p4}</font><font color="#000000" fontSize="26"> x{p5}, sắp tới ngày nhất thống giang hồ!</font></p>]],

		[[<p style="text-align:left margin:5px">
		<font color="#ff0000" fontSize="26">{p1}</font><font color="#000000" fontSize="26">{p2}</font><font color="#000000" fontSize="26"> đã nhận </font><font color="{p3}" fontSize="26">{p4}</font><font color="#000000" fontSize="26"> x{p5}, mau tới xem nào!</font></p>]],
	}

NotifyManager_11Reback_strTempleteChat1 = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Chúc mừng server </font><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> </font><font color="#feff8f" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> trong ưu đãi nhiều lần may mắn nhận Ngân Phiếu {p3} KNB x{p4}!</font></p>]]
NotifyManager_11Reback_strTempleteChat1_0 = [[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26">Chúc mừng server </font><font color="#0000ff" fontSize="26">{p1}</font><font color="#000000" fontSize="26"> </font><font color="#ff0000" fontSize="26">{p2}</font><font color="#000000" fontSize="26"> may mắn trong ưu đãi nhiều lần lần này nhận Ngân Phiếu {p3} KNB x{p4}!</font></p>]]
NotifyManager_11Reback_strTempleteChat2 = [[<p style="text-align:left margin:5px"><font color="#ffffff" fontSize="26">Chúc mừng </font><font color="#feff8f" fontSize="26">{p1}</font><font color="#ffffff" fontSize="26"> trong ưu đãi nhiều lần may mắn nhận Ngân Phiếu {p2} KNB x{p3}!</font></p>]]
-- =============================gamedata\OperationActivitiesManager.lua(弃用)
-- =============================gamedata\OtherPlayerManager.lua
OtherPlayerManager_not_find = "Không tìm thấy dữ liệu võ công {p1}"
-- =============================gamedata\PayManager.lua
PayManager_monthCard_desc = [[<p style= "text-align:left margin:5px" ><font color= "#000000" fontSize = "24" >
Chúc mừng ngài kích hoạt rồi {p1}
<br></br>
Nạp phí thành công đạt được {p2} nguyên bảo
<br></br><br></br>
<p style= "text-align:left margin:5px" ><font color= "#000000" fontSize = "24" > mỗi ngày đổ bộ có thể lĩnh </font><font color= "#FF0000" fontSize = "24" >{p3}</font><font color= "#000000" fontSize = "24" > nguyên bảo </font></p>
</font>
</p>]]
PayManager_monthCard_name1 = "Thẻ Tháng"
PayManager_monthCard_name2 = "Thẻ Hào Hiệp"
PayManager_not_open = "Tạm chưa mở nạp"

-- =============================gamedata\PlayBackManager.lua
PlayBackManager_zhaohui_suc = "Triệu hồi thành công"
PlayBackManager_yaoqing_suc = "Gửi mã mời thành công"
PlayBackManager_jibai_fail = "Chưa vào Bang để tế bái"


--wuqi add

NotifyManager_wulin_broadcast_attack =[[<p style="text-align:left margin:5px"><font color="#ff0000" fontSize="26">{p1}</font>
        <font color="#FFFFFF" fontSize="26"> tiến công đạt </font><font color="#ff0000" fontSize="26"> {p2} liên thắng </font>
        <font color="#FFFFFF" fontSize="26">,{p3}</font></p>]]

NotifyManager_wulin_broadcast_defend =[[<p style="text-align:left margin:5px"><font color="#ff0000" fontSize="26">{p1}</font>
        <font color="#FFFFFF" fontSize="26"> phòng thủ đạt </font><font color="#ff0000" fontSize="26"> liên thắng {p2} </font>
        <font color="#FFFFFF" fontSize="26">, không ai địch nổi!</font></p>]]

NotifyManager_wulin_broadcast_state = 
{
    [5] = "Đang trong trạng thái hung hãn",
    [6] = "Đã áp đảo Quần Hùng!",
    [7] = "Đã không ai địch nổi!",
    [8] = "Đã trở thành chúa tể!",
    [9] = "Chính là Thiên Thần hạ phàm!"
}

NotifyManager_guild_boss_formation = {[[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1} Bang </font><font color="#ffffff" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> hoàn thành Diễn Võ Bang giai đoạn {p3}, thời gian sử dụng {p4}, thực như hổ mọc thêm cánh!</font></p>]],
[[<p style="text-align:left margin:5px"><font color="#feff8f" fontSize="26">{p1} Bang </font><font color="#ffffff" fontSize="26">{p2}</font><font color="#ffffff" fontSize="26"> dẫn đầu,  hoàn thành Diễn Võ Bang giai đoạn {p3} đầu tiên, mất {p4}, thực như hổ mọc thêm cánh!</font></p>]]}


-- =============================gamedata\PlayerGuideManager.lua (无中文)
-- =============================gamedata\QiYuanManager.lua

-- =============================gamedata\QiyuManager.lua
QiyuManager_wuhuodong 				= "Chưa mở sự kiện Kỳ Ngộ"
QiyuManager_tilizengjia 			= "Dùng bữa thành công, thể lực tăng {p1}"
QiyuManager_hujia_tips 				= "Hộ Giá chưa hoàn thành, đừng nôn nóng?"
QiyuManager_hujia_tips2 			= "Hôm nay đã hết lượt thách đấu!"
QiyuManager_hujia_tips3				= "Hãy nhẫn nại chờ thêm"

-- =============================gamedata\RankManager.lua
-- =============================gamedata\RedPointManager.lua
-- =============================gamedata\RewardManager.lua
-- =============================gamedata\SettingManager.lua
SettingManager_send_suc 			= "Gửi thành công"
SettingManager_music_open 			= "Đã mở nhạc"
SettingManager_music_close 			= "Đã tắt nhạc"
SettingManager_effect_open 			= "Đã mở tiếng"
SettingManager_effect_close 		= "Đã tắt tiếng"
SettingManager_chat_open 			= "Đã mở thông báo chat"
SettingManager_chat_close 			= "Đã đóng thông báo chat"

-- =============================gamedata\SevenDaysManager.lua
-- =============================gamedata\SkillLevelData.lua
-- =============================gamedata\StrategyManager.lua
-- =============================gamedata\TaskManager.lua
TaskManager_com_task 				= "Hoàn thành: {p1}, được nhận thưởng"
TaskManager_ask_join_fation			= "Hãy mong chóng vào Bang để trải nghiệm thêm nhiều nội dung"


-- =============================gamedata\TriggerFunction.lua
-- =============================gamedata\VipRuleManager.lua

VipRuleManager_open_yjqhua 	= "{v1} mở cường hóa nhanh"
VipRuleManager_up_vip		= "Nâng VIP"
VipRuleManager_wuping_buzu 	= "Không đủ {p1}"
VipRuleManager_goumai_wp 	= "{v1} được mua {p2}.\n\nĐến nạp?"
VipRuleManager_tisheng_vip	= "Hôm nay đã hết lượt mua!\n\nNâng lên {v1} được mua {p2} lần.\n\nĐến nạp?"
VipRuleManager_useGold_vip	= "Hôm nay đã hết lượt {p1}!\n\nNâng lên {v2} được mua {p3} lần.\n\nĐến nạp?"
VipRuleManager_useGold_timeNone	= "Hôm nay đã hết lượt {p1}!"
VipRuleManager_goumaicishu_buzu = "Hôm nay đã hết lượt mua!"
VipRuleManager_goumaicishu_buzu2 = "Không đủ {p1}, hôm nay đã hết lượt mua!"

-- =============================gamedata\WeekRaceManager.lua
WeekRaceManager_huodong_weikaishi = "Sự kiện chưa bắt đầu"
WeekRaceManager_no_player 		= "Tranh Bá không thể tham dự"
WeekRaceManager_notify = {
		"Võ Lâm Đại Hội top 8 sắp bắt đầu, mau bố trận chuẩn bị, sự kiện cược cũng sẽ diễn ra đồng bộ!",
		"Võ Lâm Đại Hội bán kết sắp bắt đầu, mau bố trận chuẩn bị, sự kiện cược cũng sẽ diễn ra đồng bộ!",
		"Võ Lâm Đại Hội chung kết sắp bắt đầu, mau bố trận chuẩn bị, sự kiện cược cũng sẽ diễn ra đồng bộ!"
	}	

-- =============================gamedata\WulinManager.lua
-- =============================gamedata\ZhengbaManager.lua
ZhengbaManager_cd_time 			= "CD đối chiến còn：{p1} giây"
ZhengbaManager_insprie_time 	= "Bạn đã cổ vũ"
ZhengbaManager_get_all_box 		= "Bạn đã nhận toàn bộ rương"
ZhengbaManager_liansheng_ing 	= "Tấn công đạt {p1} liên thắng được nhận"
ZhengbaManager_liansheng_ed 	= "Đối chiến {p1} lần được nhận"
ZhengbaManager_jibai_xxx 		= "Bạn đã đánh bại {p1},"
ZhengbaManager_jifen_add 		= "Điểm +{p1}"
ZhengbaManager_tiaozhanshibai	= "Bạn thách đấu {p1} thất bại"
ZhengbaManager_xxx_jibai 		= "{p1} đã đánh bại bạn"
ZhengbaManager_xxx_tiaozhan 	= "{p1} thách đấu bạn và thất bại, "
ZhengbaManager_no_this_hero 	= "Không có tướng này"
ZhengbaManager_Yazhu    		= "Cược đúng {p1} lần được nhận"
KIngOfWarManager_shengli_ing 	= "Giành {p1} chiến thắng được nhận"
KIngOfWarManager_liansheng_ing	= "Đạt {p1} liên thắng được nhận"

ZhengbaManager_fight_desc		= 
{
	[5] = "{p1} tấn công đạt {p2} liên thắng, đã trở nên hung hãn!",
	[6] = "{p1} tấn công đạt {p2} liên thắng, đã áp đảo Quần Hùng!",
	[7] = "{p1} tấn công đạt {p2} liên thắng, đã không ai ngăn nổi!",
	[8] = "{p1} tấn công đạt {p2} liên thắng, đã trở thành Chúa Tể!",
	[9] = "{p1} tấn công đạt {p2} liên thắng, như Thiên Thần hạ phàm!"

}

ZhengbaManager_fight_desc2 = "{p1} phòng thủ đạt {p2} liên thắng, đã không ai địch nổi!"

-- =============================gamedata\base\CardEquipment.lua
-- =============================gamedata\base\CardRole.lua
CardRole_tip1 = "Vị trí này đã trang bị võ công, không thể lặp lại"
CardRole_tip2 = "Không tìm thấy cài đặt võ công tương ứng: [{p1}] , [{p2}]"
CardRole_tip3 = "Không thể trang bị, Martial table is nil or not found"
CardRole_tip4 = "id võ công không khớp với cài đặt"

-- =============================gamedata\base\EffectExtraData.lua
-- =============================gamedata\base\EnumGameObject.lua
GameEquipmentTypeStr = 
{
	"Vũ Khí",			--武器
	"Giáp",			--衣服
	"Nhẫn",			--戒指
	"Đai", 		--腰带
	"Hài",			--靴子
}

AttributeTypeStr =
{
	"HP",			-- 1
	"Võ Lực",			-- 2
	"Thủ",			-- 3
	"Nội Lực",			-- 4
	"T.Pháp",			-- 5
	"Công Băng",			-- 6
	"Công Hỏa",			-- 7
	"Công Độc",			-- 8
	"Kháng Băng",			-- 9
	"Kháng Hỏa",			-- 10
	"Kháng Độc",			-- 11
	"Bạo Kích",			-- 12
	"Kháng Bạo",			-- 13
	"Trúng",			-- 14
	"Né",			-- 15
	"Tỉ Lệ Bạo",		-- 16
	"Tỉ Lệ Trúng",		-- 17
	"HP",			-- 18
	"Võ Lực",			-- 19
	"Thủ",			-- 20
	"Nội Lực",			-- 21
	"T.Pháp",			-- 22
	"Công Băng",			-- 23
	"Công Hỏa",			-- 24
	"Công Độc",			-- 25
	"Kháng Băng",			-- 26
	"Kháng Hỏa",			-- 27
	"Kháng Độc",			-- 28
	"Tỉ Lệ K.Bạo",		-- 29
	"Tỉ Lệ Né",		-- 30
	"Trị Liệu thêm",		-- 31
	"ST Bạo tăng ",		-- 32
	"Miễn giảm ST Bạo",		-- 33
	"Vô thị giảm thương",
	-- "HP hiện tại",		---30
	-- "Tỉ Lệ Công",  ---31
}
TianMingAttributeTypeStr =
{
	[1] = "HP",			-- 1
	[2] = "Võ Lực",			-- 2
	[3] = "Thủ",			-- 3
	[4] = "Nội Lực",			-- 4
	[5] = "Thân Pháp",			-- 5
	[6] = "Công Băng",			-- 6
	[7] = "Công Hỏa",			-- 7
	[8] = "Công Độc",			-- 8
	[9] = "Kháng Băng",			-- 9
	[10] = "Kháng Hỏa",			-- 10
	[11] = "Kháng Độc",			-- 11
	[12] = "Bạo Kích",			-- 12
	[13] = "Kháng Bạo",			-- 13
	[14] = "Trúng",			-- 14
	[15] = "Né",			-- 15
	[16] = "Tỉ Lệ Bạo",		-- 16
	[17] = "Tỉ Lệ Trúng",		-- 17
	[18] = "HP",			-- 18
	[19] = "Võ Lực",			-- 19
	[20] = "Thủ",			-- 20
	[21] = "Nội Lực",			-- 21
	[22] = "Thân Pháp",			-- 22
	[23] = "Công Băng",			-- 23
	[24] = "Công Hỏa",			-- 24
	[25] = "Công Độc",			-- 25
	[26] = "Kháng Băng",			-- 26
	[27] = "Kháng Hỏa",			-- 27
	[28] = "Kháng Độc",			-- 28
	[29] = "Tỉ Lệ K.Bạo",		-- 29
	[30] = "Tỉ Lệ Né",		-- 30
	[31] = "Trị Liệu thêm",		-- 31
	[32] = "ST Bạo thêm",		-- 32
	[33] = "Miễn giảm ST Bạo",		-- 33
	[40] = "ST Công Thường",
	[41] = "ST Kỹ Năng",
	[42] = "ST Liên Tục",
	[44] = "S.thương",
	[45] = "Nhận Trị Liệu thêm",
	[51] = "Bỏ qua giảm ST",
	[105]= "Hồi HP hiệp",
	-- "HP hiện tại",		---30
	-- "Tỉ Lệ Công",  ---31
}
SkillTargetTypeStr = 
{		
	"1 địch",		
	"Toàn địch",		
	"Hàng ngang địch",		
	"Hàng dọc địch",	
	"Địch ngẫu nhiên",		
	"Địch ít HP nhất",		
	"Địch ít thủ nhất",		
	"Ngẫu nhiên đội",	
	"Đồng đội ít HP nhất",		
	"Toàn đội",		
	"Bản thân",		
	"Địch thủ cao nhất",		
	"Địch nội lực cao nhất",		
	"Địch nội lực thấp nhất",	
	"Địch võ lực cao nhất",		
	"Địch võ lực thấp nhất",		
	"Đồng đội võ lực cao nhất",		
	"Đồng đội võ lực thấp nhất",		
	"Đồng đội nội lực cao nhất",		
	"Đồng đội nội lực thấp nhất",	
	"Hàng ngang đội",		
	"Hàng dọc đội",		
	"Địch thân pháp cao nhất",		
	"Địch thân pháp thấp nhất",
  "Địch quân chữ thập hình", --25
  "Bên ta tùy cơ", --26
  "Triệu hoán mục tiêu", --27
  "Bên ta huyết lượng ít nhất", --28
  "Chính phía sau", --29
  "Huyết lượng thấp hơn chính mình", --30
  "Bên ta huyết tối cao" --31	
}

SkillTypeStr = 
{		
	"K.năng chủ động",		
	"Trị liệu chủ động",		
	"K.năng chủ động",		
	"T.tính bị động",	
	"Vòng sáng buff",		
	"Vòng sáng giảm t.tính",		
	"K.năng bị động",		
	"K.năng chủ động",		
	"K.năng bị động",		
	"K.năng bị động",		
	"Vòng sáng bị động",
  "Chủ động hiệu quả",
  "Triệu hoán kỹ năng", --13
  "Bị động kỹ năng", --14
  "Chủ động trị liệu", --15		
}
SkillDetail_fightBegin_skill = "Kĩ năng đầu trận"

SkillSexStr = 
{		
	"Khác giới",		
	"Đồng giới",			
}

SkillEffectStr =
{
"Hút giận",
"Giảm địch giận",
"Tăng mình giận",
"Hút huyết",
"Bắn ngược",
"Phản kích",
"Hóa giải",
"Phá trận",
"Sống lại",
"Tinh lọc",
"Đến chết",
"Siêu Miễn dịch",
"",
"",
"",
"",
"",
"",
"",
"Càn khôn",
"Bảy thương",
[22]= "Hút tinh đại pháp",
[23]= "Hút tinh đại pháp",
[24]= "Thương tổn tăng lên",
[25]= "Né tránh phóng thích kỹ năng",
[26]= "Một đòn trí mạng",
[27]= "Bắn ngược giảm ích trạng thái",
[28]= "Thanh trừ kỹ năng CD, hồi phục tức giận",
[29]= "Chữ thập phun xạ",
[30]= "Bị chữ thập phun xạ",
[31]= "Gia tăng đặc thù kỹ năng số lần",
[32]= "Hút huyết",
[33]= "Hấp thụ đối phương trước mặt huyết",
[34]= "Nhất định bạo kích",
[35]= "Hiệp bắt đầu trước sống lại",
[36]= "Né tránh",
[39]= "Huyết lượng hạn mức cao nhất",
[55]= "Đương tức giận vượt qua X điểm",
[56]= "Hóa giải",
[58]= "Hút huyết",
[64]= "Bỏ Qua Phòng Ngự",
[72]= "Hồi nguyên",
[85]= "Tinh lọc"
}

SkillBuffLastTypeStr =
{
[1] = "Hiệp",
[2] = "Thứ ( có hiệp khách ra tay khi có hiệu lực )",
[3] = "Thứ",
[4] = "Thứ ( tự thân ra tay khi có hiệu lực )",
[5] = "Thứ ( hữu phương hiệp khách ra tay khi có hiệu lực )",
[8] = "Thứ ( hữu phương hiệp khách ra tay khi có hiệu lực )",
[9] = "Thứ ( địch quân hiệp khách ra tay khi có hiệu lực )",
[11] = "Phóng ra chủ động kỹ hoặc thần kỹ",
}
SkillBuffHurtStr =
{
	"Trúng Độc",		
	"Thiêu Đốt",		
	"Sơ Hở",		
	"Suy Yếu",		
	"Nội Thương",		
	"Trì Hoãn",		
	"Mù Lòa",		
	"Thần Lực",		
	"Thủ",		
	"Hỗn Loạn",		
	"Tán Công",		
	"Điểm Huyệt",		
	"Choáng",		
	"Đóng Băng",		
	"Hôn Mê",		
	"Suy Sụp",		
	"Hồi Máu",	
	"",
	"",	
	"Thống Ẩm",		
	"Tiêu Dao Du",		
	"Dịch Cân",		
	"Bối Kiếm",		
	"Thiên Trì",		
	"Thưởng Thiện",		
	"Phạt Ác",
	"",
	-- "",
	-- "",
	-- "",
	-- "",
	[31]="Nghịch Hành Kinh Mạch",
	[33]="Kiên Cường Bất Khuất",		
	[34]="Kiên Cường Bất Khuất",
	[35]="Hàn Độc",
	[36]="Hàn Độc",	
	[37]="Sợ Hãi",


	[40]= "ST công thường",
	[41]= "ST kỹ năng",
	[42]= "ST Độc và Hỏa liên tục",
	[43]= "Tỉ lệ trạng thái xấu",
	[44]= "Tăng ST",
	[45]= "Trị Liệu thêm",
	[46]= "H.quả thuộc tính buff",
	[47]= "H.quả thuộc tính debuff",
	[48]= "Bỏ qua bắt buộc né",
	[49]= "Trảm Sát",

	[50]= "Đổ máu",
	[51]= "Hấp Tinh Đại Pháp",
	[52]= "Hấp Tinh Đại Pháp",
	[53]= "Tất Trúng",
	[54]= "Phản Kích K.Năng",
	[55]= "Trọng Thương",
	[56]= "Bất Tử",
	[57]= "Thuẫn",
	[58]= "Thuẫn",
	[59]= "Lan",
	[60]= "Tàn Tật giảm 5 thuộc tính",
	[61]= "Che Chở",
	[62]= "Tồi Tâm Chưởng",
	[63]= "Tồi Tâm Chưởng",
	[64]= "Càn Khôn Đại Na Di",
	[65]= "Phản K.Chế",
	[66]= "Giảm ST",
	[67]= "Cuồng Bạo",
	[68]= "Ngự Long Tại Thiên",
	[69]= "Kết Nối Linh Hồn",
	[70]= "Kết Nối Linh Hồn",
	[71]= "Phá Chiêu",
	[72]= "Hút Thủ",
	[73]= "Hút Thủ",
	[74]= "Thần Lực Đỉnh Thiên",
	[75]= "Miễn Dịch",
	[76]= "Nộ Khí thêm",
	[77]= "Nộ Khí tối thiểu",
	[78]= "Nộ Khí tối thiểu",
	[79]= "Nộ Khí tối thiểu",
	[80]= "Nộ Khí tối thiểu",
	[81]= "Toái Tinh",
	[82]= "Tử Hôn",
	[85]= "Thuẫn",
	[86]= "绣花点穴",
	[87]= "斩杀",
	
	[100]= "Tăng ST",
	[101]= "Sửa kỹ năng",
	[102]= "Sửa trị liệu",
	[103]= "Sửa ST dot",
	[104]= "Sửa công thường",
	[105]= "Tỉ lệ hồi mỗi hiệp",
	[106]= "Hồi cố định mỗi hiệp",
	[107]= "Bỏ qua Hút Nộ",
	[108]= "Bỏ qua Phản Đòn",
	[109]= "Bỏ qua Miễn Dịch",
	[111]= "Cuối cùng trị liệu lượng",
	[513]= "Đổ máu",
	[516]= "Hỗn loạn",
	[526]= "xxxx"
}

BeEffectExtraStr =
{
	"Trúng Độc",		
	"Thiêu Đốt",		
	"Sơ Hở",		
	"Suy Yếu",		
	"Nội Thương",		
	"Trì Hoãn",		
	"Mù Lòa",		
	"Thần Lực",		
	"Thủ",		
	"Hỗn Loạn",		
	"Tán Công",		
	"Điểm Huyệt",		
	"Choáng",		
	"Đóng Băng",		
	"Hôn Mê",		
	"Suy Sụp",		
	"Hồi Máu",	
	"",
	"",	
	"Thống Ẩm",		
	"Tiêu Dao Du",		
	"Dịch Cân",		
	"Bối Kiếm",		
	"Thiên Trì",		
	"Thưởng Thiện",		
	"Phạt Ác",
	"",
	-- "",
	-- "",
	-- "",
	-- "",
	[31]="Nghịch Hành Kinh Mạch",
	[33]="Kiên Cường Bất Khuất",		
	[34]="Kiên Cường Bất Khuất",
	[35]="Hàn Độc",
	[36]="Hàn Độc",	
	[37]="Sợ Hãi",


	[40]= "ST công thường",
	[41]= "ST kỹ năng",
	[42]= "ST Độc và Hỏa liên tục",
	[43]= "Tỉ lệ trạng thái xấu",
	[44]= "Giảm ST",
	[45]= "Lượng Trị Liệu",
	[46]= "H.quả thuộc tính buff",
	[47]= "H.quả thuộc tính debuff",
	[48]= "Bỏ qua bắt buộc né",
	[49]= "Trảm Sát",
	[50]= "Đổ máu",
	[513]= "Chảy Máu",
	[51]= "Hấp Tinh Đại Pháp",
	[52]= "Hấp Tinh Đại Pháp",
	[53]= "Tất Trúng",
	[54]= "Phản Kích K.Năng",
	[55]= "Trọng Thương",
	[56]= "Bất Tử",
	[57]= "Thuẫn",
	[58]= "Thuẫn",
	[59]= "Lan",
	[60]= "Tàn Tật giảm 5 thuộc tính",
	[61]= "Che Chở",
	[62]= "Tồi Tâm Chưởng",
	[63]= "Tồi Tâm Chưởng",
	[64]= "Càn Khôn Đại Na Di",
	[65]= "Phản K.Chế",
	[66]= "Giảm ST",
	[67]= "Cuồng Bạo",
	[68]= "Ngự Long Tại Thiên",
	[69]= "Ta tới luận tội ngươi",
	[70]= "Ngươi tới luận tội ta",
	[71]= "Phá Chiêu",	
	[72]= "Hút Thủ",
	[73]= "Hút Thủ",
	[74]= "Thần Lực Đỉnh Thiên",	
	[75]= "Miễn Dịch",		
	[76]= "Nộ Khí thêm",		
	[77]= "Nộ Khí tối thiểu",		
	[78]= "Nộ Khí tối thiểu",		
	[79]= "Nộ Khí tối thiểu",		
	[80]= "Nộ Khí tối thiểu",		
	[81]= "Toái Tinh",		
	[82]= "Tử Hôn",	
		
	[100]= "Giảm ST",
	[101]= "Sửa kỹ năng",
	[102]= "Sửa trị liệu",
	[103]= "Sửa ST dot",
	[104]= "Sửa công thường",
	[105]= "Tỉ lệ hồi mỗi hiệp",
	[106]= "Hồi cố định mỗi hiệp",
	[107]= "Bỏ qua Hút Nộ",
}

EnumItemOutPutType ={"Ải", "Quần Hào Phổ", "Vô Lượng Sơn", "Ma Kha Nhai", "Hộ Giá", "Long Môn Tiêu Cục", "Shop", "Tửu Quán" ,"Rương Vàng", "Rương Bạc", "Rương Đồng","Thưởng VIP","Quà VIP","Sự kiện","Ký danh","Thành Tựu","Hàng Ngày", "Nhạn Môn Quan", "Nhận từ sự kiện", "Cầu nguyện","Thư Các","Du ngoạn", "Xung Trận","Nâng phẩm","Ân Cừu Lục","Tịnh Tâm Trai"}

-- 武学的等级描述
EnumWuxueLevelType = {"1", "2" , "3", "4" , "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"}
-- 武学的等级描述
ChineseNumRank 	= { " chục" , " trăm", " ngàn" ," vạn", " chục",  " trăm", " ngàn", " trăm triệu"," chục" , " trăm", " ngàn" ," vạn"}
ChineseNumRank1 	= {" vạn", " trăm triệu"}
ChineseNum 		= {"0","1", "2" , "3", "4" , "5", "6", "7", "8", "9"}
--added by wuqi
--天书重数
EnumSkyBookLevelType = {"1", "2" , "3", "4" , "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21"}

EnumGemLevelType = {"1", "2" , "3", "4" , "5", "6", "7", "8", "9", "十", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"}
-- Võ công tầng 1：Sơ Nhập Giang Hồ, Võ công tầng 2：Rèn Luyện Thuần Thục, Võ công tầng 3：Có Chút Thành Tựu, Võ công tầng 4：Tích Lũy Công Danh, Võ công tầng 5：Khổ Luyện Thành Tài, Võ công tầng 6：Đỉnh Cao Vạn Trượng, Võ công tầng 7：Xuất Quỷ Nhập Thần, Võ công tầng 8：Trở Về Nguyên Trạng, Võ công tầng 9：Nhất Đại Tông Sư
EnumWuxueDescType   = {"Sơ Nhập Giang Hồ","Rèn Luyện Thuần Thục","Có Chút Thành Tựu","Tích Lũy Công Danh","Khổ Luyện Thành Tài","Đỉnh Cao Vạn Trượng","Xuất Quỷ Nhập Thần","Trở Về Nguyên Trạng","Khai Tông Lập Phái","Nhất Đại Tông Sư","Quy Ẩn Sơn Cốc","Ẩn Sĩ Giang Hồ","Huyền Thoại Giang Hồ","Đắc Đạo Thành Tiên","Công Lực Thâm Hậu","Siêu Phàm Nhập Thánh","Hóa Cảnh Võ Tôn","Vạn Pháp Quy Tông"}

-- 秘籍的等级描述
EnumBookDescType   = {"Thường","Cao","Chuyên","Tông","Thuyết"}

-- =============================gamedata\base\functions.lua
QUALITY_STR  = {"D", "C", "B", "A"}
Equip_Des 	 = {"Vũ khí", "Giáp", "Nhẫn", "Đai", "Hài"}
ResourceName = 
{
	[3]="Đồng",
	[4]="KNB",	
	[5]="Ngộ Đạo",
	[6]="EXP Đội",	
	[7]="EXP n.vật",
	[8]="Điểm Quần Hào Phổ",
	[9]="Điểm VIP",
	[10]="Hiệp Nghĩa",
	[11]="C.hiến cá nhân",
	[12]="Điểm sự kiện",
	[14]="Tinh Lộ",
	[15]="Bát Quái Tinh Nguyên",
	[21]="Hổ Lệnh",
	[22]="Long Lệnh",
	[24]="Điểm Đỉnh Luận Kiếm",
    [25]="Xu Thiên Tương",
    [26]="Xu Thiên Cực",
	[27]="Nạp tặng thẻ",
	[30] = "Xu Tuệ Tâm",
    [31] ="Xu Châu Tâm",
	[33] = "Uy Danh",
	[35] = "Điểm Anh Hùng Đại Hội",
    [38] = "Tinh Phách",
	[39] = "Linh Khí",
	[41]="Phong Vân Lệnh",
	[126]="thể lực",
	[127]="Cấp Đội",
}

ResourceNameTips = 
{
	[3]  ="Đồng dùng để cường hóa trang bị, luyện nhân vật",
	[4]  ="KNB dùng để chiêu mộ thẻ tướng và mua vật phẩm trong shop",	
	[5]  ="Chân Khí dùng để nâng kinh mạch nhân vật",
	[6]  ="EXP Đội",	
	[7]  ="EXP n.vật",
	[8]  ="Điểm Quần Hào Phổ dùng để mua vật phẩm trong Quần Hào Phổ",
	[9]  ="Điểm VIP",
	[10] ="Hiệp Nghĩa",
	[11] ="Nhận từ tính năng Bang, dùng để mua vật phẩm quý trong shop Bang.",
	[12] ="Nhận từ sự kiện tương ứng, dùng đổi các loại thưởng giá trị.",
	[14] ="Tinh Lộ dùng để đột phá kinh mạch.",
	[15] ="Vô Lượng Sơn Nam đạt thách đấu tương ứng sẽ nhận được, dùng để luyện Kỳ Môn.",
	[21] ="XXXXXXXXXXX",
	[22] ="XXXXXXXXXXX",
	[24] ="Điểm Đỉnh Luận Kiếm, nhận từ Đỉnh Luận Kiếm, dùng để tổng kết thưởng BXH",
    [25] ="Xu thông dụng ở Shop Đỉnh Cao, đổi vật phẩm thường tại Shop Đỉnh Cao",
    [26] ="Xu hiếm ở Shop Đỉnh Cao, đổi vật phẩm hiếm tại Shop Đỉnh Cao",
	[27] ="Nạp tặng thẻ, dùng tự động khi nạp, nhận thêm KNB và điểm VIP",
	[30] = "Xu tâm pháp, dùng luyện Tâm Pháp (Không bị cướp).",
    [31] = "Xu Châu Tâm là tài nguyên chính của tính năng Tâm Pháp",
	[33] = "Nhận Uy Danh từ Anh Hùng Đại Hội.",
	[35] = "Điểm Anh Hùng Đại Hội, điểm càng cao hạng càng cao",
    [38] = "Tách từ Thiên Mệnh, có thể mua vật phẩm trong shop Tinh Phách",
	[39] = "Linh Khí là tài nguyên chính trong Tế Lễ",
	[41] = "Phong Vân Lệnh nhận từ Phong Vân Lục",
	[126]="thể lực",
	[127]="Cấp Đội",
}
ResourceNameForGeneralHead =
{
	[3]="Đồng",
	[4]="KNB",	
	[5]="Ngộ Đạo",
	[13]="Hiệp Nghĩa",	
	[6]="EXP Đội",
	[7]="EXP n.vật",
	[8]="Điểm Quần Hào Phổ",
	[9]="Thể Lực",
	[10]="Lượt thách đấu",
	[11]="Đá Vô Lượng Sơn",
	[12]="Điểm kỹ năng",
	[20]="Bánh Bao",
	[21]="Hổ Lệnh",
	[22]="Long Lệnh",
	[24]="Lượt thách đấu Đỉnh Luận Kiếm",
    [25]="Xu Thiên Tương",
    [26]="Xu Thiên Cực",
    [33]="Uy Danh",
    [41]="Phong Vân Lệnh",
    [63]="Lượt thách đấu Vô Lượng Ác Mộng",
}

fun_wan_desc = "{p1} vạn"

-- =============================gamedata\base\GameAttributeData.lua
-- =============================gamedata\base\GameFragment.lua
-- =============================gamedata\base\GameItem.lua
-- =============================gamedata\base\GameObject.lua
-- =============================gamedata\base\RandomCommodity.lua
-- =============================gamedata\base\RandomStore.lua
RandomStore_Min_Later = "{p1} phút sau"
RandomStore_Sec_Later = "{p1} giây sau"
RandomStore_Refresh   = "Đang làm mới"
RandomStore_RefreshText   = "Lượt làm mới：{p1}"
RandomStore_RefreshText1   = "Làm mới shop"

-- =============================gamedata\base\RoleEffectExtraData.lua
-- =============================gamedata\base\RoleEquipment.lua
-- =============================gamedata\hold\MartialInstance.lua



--***********************角色培养**************************
No_Acquisition_Techniques										= "Không thể học bí kíp"

--***********************无量山北窟************************
BEIKU_OPEN_NOT_ENOUGH_LEVEL                                    = "Vô Lượng Sơn Nam vượt tầng {p1} mở"
BEIKU_ALL_PASS                                                 = "Đã vượt toàn bộ ải Bắc Quật, hãy cài lại"
BEIKU_GET_AND_PASS                                             = "Bạn có rương chưa nhận, hãy nhận rương"
BEIKU_CAN_NOT_RESET                                            = 'Đã hết lượt cài lại'
BEIKU_NPC_FORMATION_NOT_FOUND                                  = 'Không tìm thấy thông tin cài đặt NPC'
BEIKU_GAME_LEVEL_NOT_FOUND	                                    = 'Không tìm thấy thông tin cài đặt ải'
BEIKU_ALREAY_MAX_GAME_LEVEL	                                = 'Không có thêm cài đặt ải'
BEIKU_INVALIDATE_GAME_LEVEL_ID	                                = 'ID ải không hợp lệ'
BEIKU_CAN_NOT_CHOICE_ATTRIBUTE                                 = 'Không thể chọn thuộc tính này'
BEIKU_CHOICE_ATTRIBUTE_NOT_FOUND                               = 'Không thể chọn thuộc tính khả dụng'
BEIKU_CHOICE_ATTRIBUTE_CONF_NOT_FOUND                          = 'Không tìm thấy cài đặt lựa chọn thuộc tính'
BEIKU_ATTRIBUTE_ALREAY_CHOICED                                 = 'Đã chọn thuộc tính này rồi'
BEIKU_CHOICE_ATTRIBUTE_NOT_VALIDATE                            = 'Cài đặt thuộc tính này lỗi'
BEIKU_NOT_ENOUGH_TOKENS                                        = 'Không đủ Đá Vô Lượng Sơn'
BEIKU_HAVE_NOT_CHEST_CAN_OPEN                                  = 'Không có rương để mở'
BEIKU_CHEST_ALREAY_OPEN                                        = 'Đã mở rương này rồi'
BEIKU_CHEST_CONFIGURE_IS_NULL                                  = 'Cài đặt rương trống'
BEIKU_ATTRIBUTE_ALREAY_CHOICED_IS_SKIP                         = 'Bạn đã bỏ qua cổ vũ, không thể chọn lại'
BEIKU_CAN_NOT_SWEEP                                            = 'Địch quá mạnh, không thể quét'
BEIKU_HAS_NOT_PASS                                             = 'Thách đấu ải này thất bại, cần cài lại Vô Lượng Sơn Bắc'
BEIKU_GET_AND_SWEEP                                            = 'Có rương chưa nhận, nhận trước khi quét'    
BEIKU_CHOICE_ATTRIBUTE_AND_SWEEP                               = 'Có thuộc tính chưa chọn, chọn trước khi quét'   


--***********************经脉突破**************************
JINGMAI_SURMOUNT_SUCCESS                                       = "Đột phá thành công, trưởng thành thuộc tính tăng"
JINGMAI_SURMOUNT_FAIL                                          = "Đột phá thất bại"
JINGMAI_SURMOUNT_OPEN_NOT_ENOUGH_LEVEL                         = "Vượt Vô Lượng Sơn Nam tầng {p1} mở"

--***********************帮派**************************
No_Permissions                                                 = 'Chờ Bang Chủ/Bang Phó mở'
NoT_Enough_Prosperity                                          = 'Không đủ Phồn Vinh'
Everyday_Reset_One_time                                        = 'Mỗi ngày cài lại tối đa 1 lần'
Consume_Prosperity_Open                                        = 'Tiêu {p1} Phồn vinh Bang mở'
Consume_Prosperity_Reset                                       = 'Tiêu {p1} Phồn vinh Bang cài lại'
Zone_Reset_Suceess                                        		= 'Cài lại thành công'
Zone_Open_Suceess                                       		= 'Mở thành công'
Zone_time_out_two_minute                                 		= 'Đại hiệp, dừng tại giao diện thách đấu tối đa {p1} phút'
Zone_time_out_ten_second                                 		= 'Đại hiệp, dừng tối đa {p1} giây'
Zone_time_out_ten_minute                                 		= 'Đại hiệp, thách đấu tối đa {p1} phút'
Zone_somebody_attacking                                 		= 'Người chơi khác đang thách đấu'
Field_Finish_at_once                                      		= 'Tiêu {p1} KNB hoàn thành tu luyện ngay?'
Field_Open_Level                                        		= 'Khu Tu Luyện cần Bang đạt cấp {p1}'
Field_Open_XLC_Level                                        	= 'Phòng Tu La cần Bang cấp {p1}'
Field_Research_skill                                        	= 'Tiêu {p1} Phồn Vinh nghiên cứu Lv{p2}-{p3}?'
Field_Open_skill                                            	= 'Tiêu {p1} Phồn Vinh mở {p2}?'
Field_Research_skill_max_level                                	= 'Đạt cấp tối đa hiện tại, hãy nâng cấp Bang'
Field_Research_skill_max_level2                                = 'Đã đạt cấp tối đa'
Field_Study_skill_no_open                                      = 'Cần Bang Chủ/Bang Phó mở'
Field_Study_skill_max_level                                    = 'Đạt cấp tối đa hiện tại, hãy nâng cấp nghiên cứu'
Field_No_Permissions                                           = 'Bang Chủ/Bang Phó được nghiên cứu'
Guild_flag_modify                                              = 'Sửa cờ Bang thành công'
Guild_UI                                                       = 'Cần 1 lệnh đổi cờ Bang (Còn：{p1})'
Guild_Dedication_Not											= 'Không đủ cống hiến Bang'
Guild_Dedication_Tool_Not											= 'Không đủ {p1}'



--***********************Đúc lại T.Bị**************************
Recast_Unlock1                                                 = 'Ô 1 đạt Hỏng sẽ mở'
Recast_Unlock2                                                 = 'Ô 2 đạt Xước sẽ mở'
Recast_Unlock3                                                 = 'Ô 3 đạt Hoàn Mỹ mở'
Recast_Unlock4                                                 = 'Ô 4 đạt Đúc Thần mở'
Recast_Gems                                                    = 'Tạm chưa mở, vui lòng chờ'
Recast_Second_Prompt                                           = 'Đúc lại cần 1 {p1}, xác nhận?'
Recast_Material_shortage                                       = 'Hãy thu thập {p1}'
Recast_Used_tool                                           		= 'Đúc lại cần 1 {p1}, xác nhận?'

Recast_UnlockList =
{
	'Ô 1 đạt Hỏng sẽ mở',
	'Ô 2 đạt Xước sẽ mở',
	'Ô 3 đạt Hoàn Mỹ mở',
	'Ô 4 đạt Đúc Thần mở'
}



--***********************采矿**************************
Mining_Protect_Record1                                         = '{p1} thuê bạn làm hộ vệ, nhận {p2} phí thuê'
Mining_Protect_Record2                                         = 'Khi bạn làm hộ vệ cho {p1}, ngăn thành công {p2} cướp bóc. Nhận thêm {p3} phí thuê'
Mining_UI1                                                     = 'Tuần này được chọn：{p1}'
Mining_UI2                                                     = 'Mỗi tuần, mỗi hảo hữu hoặc thành viên Bang chỉ được chọn 1 lần'
Mining_UI3                                                     = 'Chiến đấu với {p1} {p2} lần, '
Mining_UI3_win                                                 = '{p1} tới cướp, chiến đấu với {p2} {p3} lần, {p4} cướp thành công'
Mining_UI3_lost                                                = '{p1} tới cướp, chiến đấu với {p2} {p3} lần, {p4} cướp thất bại'
Mining_UI4_win                                                 = '{p1} chiến đấu với {p2}, giành chiến thắng'
Mining_UI4_lost                                                = '{p1} chiến đấu với {p2}, chiến đấu thất bại'
Mining_Nobody                                                  = 'Chưa có người khai thác'
Mining_Reset                                                   = 'Tiêu 1 lần lệnh cướp cài lại trạng thái cướp?'
Mining_No_Chance                                               = 'Không đủ Lệnh Cướp'
Mining_No_Protector                                            = 'Chưa chọn người bảo vệ, xác nhận tự khai thác'
Mining_Rob_Success                                             = 'Cướp {p1} Đồng'
Mining_Dead                                                    = 'Không có tướng sinh tồn'
Mining_Increase_Frequency                                      = 'Lệnh Cướp +{p1}'
Mining_No_Lineup                                               = 'Không có người bố trí đội hình khai thác'
Mining_No_Rob_frequency                                        = 'Thiếu Lệnh Cướp'
Mining_Suffer_Rob                                              = 'Người này đang bị cướp'
Mining_Mining_Complete                                         = 'Người này đã hoàn thành đào quặng'
Mining_No_All_Beat                                             = 'Còn {p1} chưa đánh bại, tiếp tục thoát?'
Mining_Rob_Gemstone                                            = 'Cướp {p1} {p2} rương ngọc'
Mining_Rob_Acer                                                = 'Cướp {p1} KNB'
Mining_Rob_Refined_stone                                       = 'Cướp {p1} Đá Tinh Luyện'





--***********************奇门遁**************************
Gossip_Upgrade_success                                         = '{p1} truyền hoàn tất'
Gossip_Breach                                                  = 'Nhấp Bát Quái và đột phá lên tầng sau'
Gossip_Breach_success                                          = 'Đột phá thành công lên tầng {p1}'
Gossip_No_Prop                                                 = 'Không đủ Bát Quái Tinh Nguyên, hãy đến Vô Lượng Sơn Nam nhận'
Gossip_Level_insufficient                                      = 'Đội đạt cấp {p1} rồi thử lại'
Gossip_No_Upgrade_complete                                     = 'Truyền Kỳ Môn tầng này xong rồi thử lại'





--***********************助战**************************
Assist_Somebody_Assist_You                                     = '{p1} trợ chiến {p2}'
Assist_No_Assist_hero                                          = 'Chưa có tướng trợ chiến của hảo hữu'
Assist_Assist_success                                          = 'Trợ chiến {p1} thành công'
Assist_No_hero                                                 = 'Rất tiếc, không có tướng này'
Assist_Hero_No_time                                            = 'Rất tiếc, tướng này không đủ lượt'
Assist_Already_Assist_This_player                              = 'Rất tiếc, hôm nay đã trợ chiến người này'
Assist_This_player_Already_Assist_You                          = 'Rất tiếc, hôm nay đã được người này trợ chiến'
Assist_Their_Hero_No_time                                      = 'Rất tiếc, lượt trợ chiến của tướng này hôm nay đã tối đa'
Assist_Assist_success_they                                     = 'Trợ chiến thành công {p1} hảo hữu'
Assist_UI_Assist                                               = 'Trợ chiến hảo hữu {p1} lần'
Assist_Assist_gift                                             = 'Đã nhận toàn bộ quà'
Assist_NO_Assist_friend                                        = 'Không có hảo hữu trợ chiến'
Assist_No_Assist_time                                          = 'Trợ chiến hôm nay đã hết'
Assist_No_open                                                 = 'Đội đạt Lv27 mở'
                                    




--***********************佣兵**************************
Mercenary_Mercenary_back_limit                                  = 'Quá 30 phút tướng mới được về đội'
Mercenary_The_team_returned_to_limit                            = 'Quá 30 phút đội mới được về đội'
Mercenary_The_knight_is_empty                                   = 'Không có tướng sát thủ'
Mercenary_Team_is_empty                                         = 'Không có đội sát thủ'






--***********************雇佣**************************
Hire_The_same_Knight_battle                                     = 'Tướng cùng tên không thể ra trận đồng thời'
Hire_No_Knight_battle                                           = 'Ra trận tối thiểu 1 tướng'
Hire_Abnormal_information_Knight                                = 'Làm mới thông tin tướng, hãy chọn lại' 
Hire_The_knight_is_empty                                        = 'Không có đội hảo hữu'
Hire_Team_is_empty                                              = 'Không có đội Bang'



--***********************祈愿**************************
QIYUAN_NOT_FIND_TEMPLATE                                               = 'Không tìm thấy module'
QIYUAN_NOT_FIND_REWARD                                                 = 'Chưa tìm thấy thưởng'
QIYUAN_REWARD_ALREADY_GET                                              = 'Đã nhận thưởng' 
QIYUAN_NOT_ENOUGH_DAY                                                  = 'Cầu nguyện chưa đủ 15 ngày'
QIYUAN_NOT_ENOUGH_COUNT                                                = 'Cầu nguyện đã tối đa'
QIYUAN_WAIT_FIVE_MINUTE                                                = 'Vui lòng chờ 5 phút' 
QIYUAN_NOT_FIND_INVOCATORY_GOODS                                       = 'Không có Đá Cầu Nguyện'
QIYUAN_NOT_INVOCATORY_REWARD_OR_RESET                                  = '3 ô thẻ không có thưởng hoặc đã cài lại thưởng'



QIYUAN_NOTFIND_TEMPLATE                                               = 'Không tìm thấy module'
QIYUAN_NOTFIND_REWARD                                                 = 'Chưa tìm thấy thưởng'
QIYUAN_REWARDALREADY_GET                                              = 'Đã nhận thưởng' 
QIYUAN_NOTENOUGH_DAY                                                  = 'Cầu nguyện chưa đủ {p1} ngày'
QIYUAN_NOTENOUGH_COUNT                                                = 'Cầu nguyện đã tối đa'
QIYUAN_WAITFIVE_MINUTE                                              = 'Vui lòng chờ 5 phút' 
QIYUAN_NOTFIND_INVOCATORY_GOODS                                                  = 'Không có Đá Cầu Nguyện'
QIYUAN_NOTINVOCATORY_REWARD_OR_RESET                                                = '3 ô thẻ không có thưởng hoặc đã cài lại thưởng'

--***********************非法第3方**************************
illegal_Third_party                                             = 'Chiến đấu bất thường, hãy đăng nhập lại'


--国内新增
-----------------------------------------------------------------------------------------------------------------

smithy_gem_oneKeyBuild = "Xác nhận ghép toàn bộ ngọc cấp thấp lên Lv9?"
treasureMain_text1  = "Vòng trước chưa kết thúc"
treasureMain_text2	= "{p1}/{p2} lần"
treasureMain_text3	= "{p1} lần"
treasureMain_text4	= "Tầm Bảo miễn phí"
treasureMain_tiemout ="Sự kiện đã kết thúc"
smritiMain_text1 	= "Hãy đặt 2 trang bị vào"
smritiMain_tips 	= "Mẹo"
smritiMain_ok 		= "Xác nhận đổi trang bị?"
smritiMain_tips1 	= "Đã nhận toàn bộ thưởng"

--游历相关
youli_DoubleStrategyNo = "Tại giao diện Du ngoạn bố trí đội hình 2 trước"
youli_saodangling = "Lệnh Quét："
youli_xiaohao = "Mỗi lần quét cần"
youli_freeTimes = "Miễn phí："
youli_text1 = "{v1} mở quét nhiều lần nhanh.\n\nĐến nạp?"
youli_text2 = "Nâng VIP"
youli_text3 = "Thiếu Bánh Bao"
youli_text4 = "Hồi đầy Bánh Bao"
youli_text5 = "Không đủ Bánh Bao"
youli_text6 = "Dùng {p1} KNB mua 20 Bánh Bao?"
youli_text7 = "Hôm nay còn được mua {p1} lần"
youli_text8 = "Nâng lên {v1} mỗi ngày được mua {p2} lượt thách đấu.\n\nĐến nạp?"
youli_text9 = "Hôm nay đã hết lượt mua!\n\nNâng lên {v1} mỗi ngày được mua {p2} lượt thách đấu.\n\nĐến nạp?"
youli_text10 = "Lượt thách đấu đã hết"
youli_text11 = "Lượt thách đấu đã hết, hôm nay đã hết lượt cài lại"
youli_text12 = "Lần này cần {p1} Lệnh Cài Lại, xác nhận cài lại?\n\n(Lệnh Cài Lại：{p2}, hôm nay còn {p3} lần cài lại)"
youli_text13 = "Dùng {p1} KNB cài lại lượt thách đấu ải?\n\n(Hôm nay còn {p2} lượt cài lại)"
youli_text14 = "Lượt miễn phí và tổng Lệnh Quét không đủ, dùng {p1} KNB để quét?"
youli_text15 = "Không đủ lượt so tài"
youli_text16 = "Hồi đầy lượt so tài"
youli_text17 = "Không đủ lượt so tài"
youli_text18 = "Dùng {p1} KNB mua 5 lần so tài?"
youli_text19 = "Dùng {p1} KNB làm mới ngay?"
youli_otherplayer_text1 = "Làm mới thành công"
youli_openmission_text = "Chưa vượt ải"
youli_reward_tips1 = "Ải h.tại rớt:"
youli_reward_tips2 = "Thắng 1 trận rớt:"
youli_reward_tips3 = "Thắng 2 trận rớt:"
youli_reqiure_level = "Cần đạt Lv{p1}"
youli_not_open = "Sắp mở!"
youli_baozi = "Bánh Bao"

youli_drop_tips1 = "Chiến Tích"
youli_drop_tips2 = "Điểm So Tài"
youli_drop_tips3 = "Đồng"

youli_yueli_des = "Nhận từ Du ngoạn, dùng để luyện Thiên Thư."
youli_coin_des = "Đồng để cường hóa T.Bị, bồi dưỡng nhân vật"
youli_shalu_des = "Nhận từ so tài, hạng điểm So Tài càng cao thưởng hàng tuần càng lớn"

youli_shop_txt1 = "Không đủ"
youli_shop_txt2 = "Số trang còn："
shalurecord_txt1 = "Dùng {p1} KNB đánh trả?"
shalurecord_txt2 = "Top"
shalu_info_txt1 = "Chưa lọt"
shalu_nearby_txt1 = "Người lạ"
shalu_nearby_txt2 = "Thưởng tỉ thí đặt vào rương tổng kết, 24h mỗi chủ nhật tổng kết"
shalu_nearby_txt3 = "So tài với người lạ và thắng sẽ nhận thưởng trực tiếp"

time_day_txt = " ngày"
time_hour_txt = " giờ"
time_hour_txt0 = " giờ"
time_minute_txt = " phút"
time_minute_txt0 = " phút"
time_second_txt = " giây"


youli_home_xy = {x = 182, y = 257}
youli_playerHead_xy = {
	{x = -182, y = 494},
	{x = 194, y = 472},
	{x = 465, y = 381},
	{x = 610, y = 102},
	{x = -2, y = -112},
	{x = -263, y = 16},
}
youli_maibao_tips1 = "Dùng nặc danh chôn báu vật tại đây"
youli_maibao_tips2 = "Chôn báu vật tại đây"
youli_wabao_tips1 = "Rương của {p1}"
youli_wabao_tips2 = "Rương của kẻ bí ẩn"
youli_wobaoXiang_tips = "[{p1}] {p2} {p3} may mắn đào được kho báu {p4} chôn {p5}"
youli_shenmiren_tips = "Kẻ bí ẩn"
youli_fuwenben_tips = "#R-{p1}-{p2}x{p3}#"

youli_maibao_xianshi = "Giới hạn giờ:{p1}"

youli_wobao_cnt = "Không đủ lượt đào báu"

youli_wabao_NoTip1 = "Nơi này không có kho báu, hãy tìm chỗ khác"
youli_wabao_NoTip2 = "Trống không, chẳng có gì cả……"
youli_wabao_NoTip3 = "Kho báu sẽ xuất hiện, tìm tiếp đi."

youli_wabao_NoTip4 = "Có người đang đào rương này"
--聊天
chat_serverChat_closed = "Đã đóng chat liên server"

--vip
vip_employ_not_enough = "VIP{p1} phái vị trí số {p2}. \n\nĐến nạp?"
vip_qucik_saodang_not_enough = "VIP{p1} mở quét nhanh. \n\nĐến nạp?"
vip_yiJianQianXue_not_enough = "VIP{p1} mở cần cù nhanh. \n\nĐến nạp?"
vip_yiJianXiDe_not_enough = "VIP{p1} mở học nhanh. \n\nĐến nạp?"
vip_gamble_not_enough = "VIP{p1} mở Đá Thô nhanh. \n\nĐến nạp?"
vip_intensify_not_enough = "VIP{p1} mở cường hóa nhanh. \n\nĐến nạp?"
vip_factionMakeFriend_not_enough = "VIP{p1} mở {p2}. \n\nĐến nạp?"
vip_escortTran_not_enough = "VIP{p1} mở tăng tốc. \n\nĐến nạp?"
vip_trustOnekey_not_enough = "VIP{p1} hoăc đội cấp {p2} mở. \n\nĐến nạp?"
vip_yiJianChongXue_not_enough = "VIP{p1} mở xung huyệt nhanh. \n\nĐến nạp?"
vip_yiJianJingLian_not_enough = "VIP{p1} mở tinh luyện nhanh. \n\nĐến nạp?"
vip_vipShopping_not_enough = "VIP{p1} tăng thêm 1 lượt làm mới.\n\nĐến nạp?"



--Bang
faction_makeFriend_show = {"Ngỡ Là Tri Kỷ","Kết Nghĩa Kim Lan","Đồng Cam Cộng Khổ"}






-------------new
common_up_vip = "Nâng VIP"    --为了防止有相同错误 在加1条Key
common_vip_up = "Nâng VIP"
faction_no_battle_info = "Không có thông tin chiến đấu trận này"
faction_name = "Tên của ta là {p1}"
faction_no_levelup = "Bang chưa thăng hạng"
faction_no_rank = "Chưa lọt"
activity_recruit_type = {"Chiêu thường", "Chiêu cao cấp", "Quay 10 lần"}
activity_recruit_type2 = {"Thường", "Cao cấp", "Quay 10 lần"}
activity_employDesc = "{p1}{p2}{p3} lần  "
activity_employCondition = "{p1} {p2}{p3} lần({p4}/{p5})"
common_max_shalu = "Điểm So Tài:"
common_shalu = "{p1}Điểm So Tài"
ZhengbaManager_no_this_hero = "Không có tướng này"


-- =============================gamedata\FactionFightManager.lua
FactionFightManager_join_before = "Hãy vào Bang trước"
FactionFightManager_not_in_avtivity = "Sự kiện chưa đến giờ"
FactionFightManager_not_in_avtivity_1 = "Chưa đủ điều kiện tham dự Tranh Bá Bang"

FactionFightManager_edit_success = "Đổi thế trận thành công"



--***********************帮派战**************************
Guild_War_Output                                             = 'Thắng nhận: HP tặng 10%'
Guild_War_Force                                              = 'Thắng nhận: Võ Lực tăng 10%'
Guild_War_Internal                                           = 'Thắng nhận: Nội Lực tăng 0%'
Guild_War_No_Elite                                           = 'Tinh Anh này không trong đội'
Guild_War_War_star                                           = 'Tranh Bá Bang sắp bắt đầu, không thể báo danh'
Guild_War_No_Position                                        = 'Không đủ vị trí, hãy thử thế trận khác'
Guild_War_No_Videotape                                       = 'Không có thông tin xem lại'

GUILD_WAR_MSG = {
	Guild_War_Output,
	Guild_War_Force,
	Guild_War_Internal
}







------------new2
sbStone_fenjie_tip = "Tách Tinh Yếu lần này cần："

SkillDetail_reactive_skill = "K.năng bị động"
SkillDetail_nuqi			="{p1} nộ"
SkillDetail_not_nuqi			="Không hao nộ"
SkillDetail_jihuo			="{p1} sao kích hoạt"

playerbackMain_text1 = "Chào mừng đại hiệp tái xuất giang hồ! <br/>Nhằm giúp đại hiệp nhanh chóng thích ứng, chúng tôi đã chuẩn bị rất nhiều phúc lợi và quà đoàn tụ hậu hĩnh hỗ trợ đại hiệp bắt kịp tốc độ!<br/>Tại đây có thể mở nhiệm vụ trở về riêng, sau khi hoàn thành được nhận thưởng hậu hĩnh.<br/>Trong lúc này, đại hiệp tiến hành"
playerbackMain_text2 = " vượt ải sẽ tăng 1.5 lần EXP Đội；Số Xà Đản nhận từ vượt ải cũng tăng 1.5 lần, "
playerbackMain_text3 = "giúp đại hiệp nhanh chóng nâng cấp.<br/>Cuối cùng, hãy nhấp nút phía dưới nhận một phần quà đoàn tụ. Gói quà với nhiều phần thưởng hấp dẫn sẽ chờ giúp đại hiệp hành tẩu giang hồ dễ dàng hơn!"

MonthCardLayer_text1 = "Liên tục {p1} ngày"
MiningLayer_text1 	 = "Tuần này được thuê：" 
StarBoxPanel_stars	 = "{p1} sao nhận"
TreasureMain_tips1	 ="Xác nhận"
TreasureMain_tips2	 ="Tầm Bảo 30 lần cần {p1} KNB, xác nhận"

Tianshu_hecheng_text1 ="Không đủ mảnh ghép"
Tianshu_hecheng_text2 ="(Đã mở)"
Tianshu_hecheng_text3 ="(Chưa mở)"
Tianshu_hecheng_text4 ="Chưa vượt ải"
Tianshu_rongru_text1  ="Không đủ vàng!"
Tianshu_rongru_text2  ="Không đủ chiến tích!"
Tianshu_rongru_text3  ="Bạn chưa chọn tinh yếu!"
Tianshu_rongru_text4  ="Bán tinh yếu nhận："
--Tianshu_chongzhi_text1 = "1. Thiên Thư trở thành tầng 1\n2. Hoàn {p1} Chiến Tích\n3. Hoàn toàn bộ tinh yếu\n\nCài lại<<{p2}>>?"
Tianshu_chongzhi_tips1 = "  1. Thiên Thư trở thành tầng 1<br/>  2. Hoàn "
Tianshu_chongzhi_tips2 = " Chiến Tích<br/>"
Tianshu_chongzhi_tips3 = "  3. Hoàn toàn bộ tinh yếu<br/>"
Tianshu_chongzhi_tips4 = "Cài lại&lt;&lt;"
Tianshu_chongzhi_tips5 = "  4. Hoàn toàn bộ Phù Nâng Cấp<br/>"
Tianshu_chongzhi_tips6 = "N.liệu:"
Tianshu_chongzhi_tips7 = "Đã nghiên cứu tầng cao nhất"
Tianshu_chongzhi_tips8 = "  đã tu luyện đến cấp cao nhất"
Tianshu_chongzhi_tips9 = "Trang:"

Tianshu_fenjie_tips1 = "  1. Hoàn Chiến Tích"
Tianshu_fenjie_tips2 = "  4. Hoàn "
Tianshu_fenjie_tips3 = "  5. Hoàn "
Tianshu_fenjie_tips4 = "Tách &lt;&lt;"
Tianshu_fenjie_tips5 = " <br/>"
Tianshu_fenjie_tips6 = "  2. Hoàn toàn bộ tinh yếu<br/>"
Tianshu_fenjie_tips7 = "  3. Hoàn toàn bộ Phù Nâng Cấp<br/>"
Tianshu_fenjie_tips9 = "  6. Hoàn Ngọc, Mật Yếu khảm<br/>"
Tianshu_fenjie_text8 ="Gỡ Thiên Thư trước khi thao tác"

Tianshu_chongzhi_tips6 = "Sở cần tài liệu:"
Tianshu_chongzhi_tips7 = "Đã nghiên tập đến tối cao trọng"
Tianshu_chongzhi_tips8 = "Đã tu luyện đến cao cấp nhất"
Tianshu_chongzhi_tips9 = "Tàn trang:"
Tianshu_chongzhi_text2 = "Thỉnh ít nhất được khảm một viên tinh muốn"
Tianshu_chongzhi_text3 = "Thiên thư trọng trí phù số lượng không đủ"
Tianshu_chongzhi_text4 = "Nên tinh muốn khổng chưa mở ra"
Tianshu_chongzhi_text5 = "Nên thiên thư đã đạt lớn nhất trọng số"
Tianshu_chongzhi_text6 = "Dung nhập toàn bộ {p1} cái tinh muốn sau mới có thể thăng trọng"
Tianshu_chongzhi_text7 = "Thăng trọng sở cần đồng vàng không đủ"
Tianshu_chongzhi_text8 = "Dung nhập sở cần {p1} không đủ!"
Tianshu_tupo_text1 = "Thiên thư đột phá tài liệu không đủ"
Tianshu_jingyao_text1 = "Tạm vô rơi xuống"
Tianshu_exchange_text = "Điểm đánh lựa chọn đổi thành thiên thư"
Tianshu_exchange_ok = "Hay không xác nhận đổi thành thiên thư?"
Tianshu_MiYai_Tips1 = "{p1} giai"
Tianshu_MiYai_Tips2 = "Chưa lựa chọn được khảm số liệu"
Tianshu_MiYai_Tips3 = "Chưa lựa chọn bí muốn"
Tianshu_MiYai_Tips4 = "Thiên thư đột phá đến {p1} tinh sau mở ra bí muốn khổng"

RoleSkyBook_text1      ="Mau dùng Thiên Thư phù hợp nhất cho tướng!"
RoleXinFa_text1 = "Mau cho ngươi hiệp khách sử dụng nhất thích hợp tâm pháp đi!"

GambleMainLayer_text1  ="Không đủ {p1}"
GambleMainLayer_text2  ="{p1} cần {p2}{p3}, xác nhận"
GambleMainLayer_text3  ="Chọn lọc cần {p1}{p2}, xác nhận"
GambleMainLayer_OneKeyTxt  ="Lần này nhận {p1} Ngọc, Đá Thô nhanh {p2} lần"
GambleMainLayer_text4  ="Lượt {p1}：{p2}"
AdventureShop_text1    ="Lượng mua tối thiểu là 1"
HeadPicFrame_text1	   ="Đã mở"
HeadPicFrame_text2	   ="Chưa mở"
HeadPicFrame_text3	   ="Khung ảnh đã quá hạn"
HeadPicFrame_text4	   ="Còn lại：%02d:%02d"
HeadPicFrame_text5	   ="ID khung ảnh vô hiệu"
HeadPicFrame_text6 = "Đã quá hạn"
EquipOutTianshu_text1  ="Thư Các"

Tianshu_Main_Attr 		= "T.tính chính:"
Tianshu_Attr_Grow 		= "T.tính tăng:"

Tianshu_chong_text      = "Tầng {p1}"

Tianshu_gem_locked = "Thiên Thư đột phá lên 1 sao mở lỗ ngọc"
Tianshu_gem_not_ok = "Cấp Ngọc chưa đủ yêu cầu"

------------newadd------------------------------------------
monthCard_text1													="Đã nhận 100 KNB"
monthCard_text2													="Hôm nay đã nhận"
monthCard_text3													="Tiểu nhị làm việc chăm chỉ, nhận "
roleTrain_text1													="Đột phá lên {p1} mở"
roleTrain_text2													="Nâng lên cấp {p1}, {p2}"
roleTrain_text3													="Toàn bộ kinh mạch cấp tối đa mới được đột phá"
SkillDetail_reactive_skill 										= "K.năng bị động"
SkillDetail_nuqi												="{p1} nộ khí"
SkillDetail_not_nuqi											="Không hao nộ"
changetProfession_text1											={"Truyền Nhân Kiếm Ma","Giáo Chủ Thánh Giáo","Chưởng Môn Nga My","Bang Chủ Cái Bang"}
bloodHomeLayer_text1							="Huyết Chiến mở khi đạt Lv{p1}"   
roleFireLayer_tips5								="Chọn tướng quy ẩn"
playerbackMain_text1 							= "Chào mừng đại hiệp tái xuất giang hồ! <br/>Nhằm giúp đại hiệp nhanh chóng thích ứng, chúng tôi đã chuẩn bị rất nhiều phúc lợi và quà đoàn tụ hậu hĩnh hỗ trợ đại hiệp bắt kịp tốc độ!<br/>Tại đây có thể mở nhiệm vụ trở về riêng, sau khi hoàn thành được nhận thưởng hậu hĩnh.<br/>Trong lúc này, đại hiệp tiến hành"
playerbackMain_text2 							= " vượt ải sẽ được tăng 1.5 lần EXP EXP Đội; Số Xà Đản nhận từ vượt ải tăng 1.5 lần, "
playerbackMain_text3 							= "giúp đại hiệp nhanh chóng nâng cấp.<br/>Cuối cùng, hãy nhấp nút phía dưới nhận một phần quà đoàn tụ. Gói quà với nhiều phần thưởng hấp dẫn sẽ chờ giúp đại hiệp hành tẩu giang hồ dễ dàng hơn!"

multiFight_noRank = 'Chưa lọt'
multiFight_yzsyTime = 'Cược còn'
multiFight_fightTime = 'Chiến đấu còn'
multiFight_viewTime = 'Thời gian hiện kết quả'
multiFight_fightTime32 = {
	"Thời gian đấu trận 1",
	"Thời gian đấu trận 2",
	"Thời gian đấu trận 3",
}
multiFight_CutDownTime32 = {
	"Đấu trận 1 sau",
	"Đấu trận 2 sau",
	"Đấu trận 3 sau",
}
multiFight_recordTitleFont = {
	{
		"Vòng 16 trận 1",
		"Vòng 16 trận 2",
		"Vòng 16 trận 3"		
	},
	{
		"Tứ Kết 1",
		"Tứ Kết 2",
		"Tứ Kết 3"
	},
	{
		"Bán Kết 1",
		"Bán Kết 2",
		"Bán Kết 3"
	},
	{
		"Chung Kết 1",
		"Chung Kết 2",
		"Chung Kết 3",
	}
}

multiFight_result_timetxt = "Sắp mở"
multiFight_result_opentime = "Võ Lâm Đại Hội Liên Server kỳ sau mở vào {p1}.{p2}"
multiFight_atk_details = "{p1} thắng {p2} thua"
multiFight_atk_liansheng = "{p1} liên thắng"
multiFight_myRank = "Hạng:{p1}"
multiFight_highthonor = "Long Lệnh"
multiFight_lowhonor = "Hổ Lệnh"
multiFight_highthonor_des = "Xu Liên Server hiếm, đổi vật phẩm hiếm tại shop Liên Server"
multiFight_lowhonor_des = "Xu Liên Server, đổi vật phẩm tại shop Liên Server"
multiFight_score = "Điểm:"
multiFight_bet_sycee = "Không đủ KNB"
multiFight_bet_coin = "Không đủ Đồng"
roleEquipChangeLayer_txt = "Chọn tướng đổi trang bị"
roleEquipChangeLayer_txt1 = "Đổi thành công"


--VIP
VIP_UNDER_15 = "VIP{p1}"
VIP16 = "Hào-VIP"
VIP17 = "Tước-VIP"
VIP18 = "Hoàng-VIP"
VIP19 = "Đế-VIP"
VIP20 = "Vương-VIP"

factionMail_noSycee = "Không đủ KNB"
factionMail_noTips = "Hãy nhập tiêu đề"
factionMail_noContent = "Hãy nhập nội dung"
factionMail_sucess = "Gửi thành công"


roleInfoLayer_not_pro    = "Không có đạo cụ để dùng"
roleInfoLayer_tips_1     = "Thế thân này có phẩm chất caohown duyên phận mục tiêu, tiếp tục?"
roleInfoLayer_tips_2     ="Số duyên phận thế thần này kích hoạt cao hơn duyên phận mục tiêu, tiếp tục?"
common_time_7			 ="{p1} ngày {p2} giờ"
common_time_8			 ="{p1} giờ {p2} phút "
common_time_9			 ="{p1} phút {p2} giây"
getJingyao_rongru_text1  ="Tháo tinh yếu này?\nSẽ hoàn {p1} Chiến Tích"
Tianshu_Main_text1       ="Đã nghiên cứu tầng cao nhất"
TreasureMain_text5		 ="Không có thêm log tầm bảo"

SkyBookManager_text1	 ="Dùng Thiên Thư thất bại"
SkyBookManager_text2	 ="Gỡ Thiên Thư thất bại"
SkyBookManager_text3	 ="Khảm tinh yếu thất bại"
SkyBookManager_text4	 ="Đột phá Thiên Thư thất bại"
SkyBookManager_text5	 ="Tách tinh yếu thất bại"
SkyBookManager_text6	 ="Cài lại Thiên Thư thất bại"
SkyBookManager_text7	 ="Nâng Thiên Thư thất bại"
SkyBookManager_text8	 ="Tách Thiên Thư thất bại"
SkyBookManager_text9	 ="Tách Thiên Thư sẽ hoàn nguyên liệu lĩnh hội, nghiên cứu, chú giải Thiên Thư này, xác nhận tách?"
SkyBookManager_text10	 ="Sau khi tách sẽ mất Thiên Thư, tách?"

TreasureManager_text1	 ="Chưa mở Tầm Bảo"
functions_text1			 =" chục"
functions_bai			 =" trăm"
functions_ling			 ="0"



HeadPicFrameManager_jiesuo_success = "Mở khung ảnh:{p1}"
HeadPicFrameManager_wuxiao = "Khung ảnh vô hiệu"

LianTi_Quality_Name_1	= "Dịch Cân"
LianTi_Quality_Name_2	= "Túy Cốt"
LianTi_Quality_Name_3	= "Hoán Huyết"
LianTi_Quality_Name_4	= "Tẩy Tủy"
LianTi_Quality_Name_5   = "Uẩn Khí"
LianTi_Quality_Name_6   = "Bồi Nguyên"
LianTi_Quality_Name_7   = "Chú Thần"
LianTi_Quality_Name_8   = "Quy Chân"

RoleLianTiLayer_Point_tip_1 = "Dịch Cân vị trí 1 mở"
RoleLianTiLayer_Point_tip_2 = "Túy Cốt vị trí 2 mở"
RoleLianTiLayer_Point_tip_3 = "Hoán Huyết vị trí 3 mở"
RoleLianTiLayer_Point_tip_4 = "Tẩy Tủy vị trí 4 mở"
RoleLianTiLayer_Point_tip_5 = "Uẩn Khí vị trí 5 mở"
RoleLianTiLayer_Point_tip_6 = "Bồi Nguyên vị trí 6 mở"
RoleLianTiLayer_Point_tip_7 = "Chú Thần vị trí 7 mở"

ItemTipLayer_have_txt	= "Đã có:"

FightMainLayer_BuyQualification_txt1 = "Rất tiếc, server đã đủ người"
FightMainLayer_BuyQualification_txt2 = "Báo danh Võ Lâm Đại Hội Liên Server?"
FightMainLayer_BuyQualification_txt3 = "Báo danh Liên Server thành công"


ExtraReward_num = "Đạt {p1} điểm nhận thưởng thêm"

zadan_tipsReward = "Chọn 1 vật phẩm dưới đây："
zadan_tipsTools = "Có cơ hội nhận đạo cụ sau："
zadan_tipsRoles = "Có cơ hội nhận tướng sau："

CrossFightMapLayer_Win_Txt = "Thủ thành công {p1} đợt"
CrossFightBattle_Not_Apply_Time = "Chưa đến giờ báo danh"
CrossFightBattle_ApplyInterVal_Txt = "{p1} phút sau được đổi"
CrossFightBattle_HasApply = "Bạn đã báo danh thành này"
CrossFightBattle_Def_Success = "Chiến đấu thành công {p1} đợt"
CrossFightBattle_Atk_Success = "Chiến đấu thất bại {p1} đợt"
CrossFightBattle_MapRankDes = "XH thế lực {p1}:"
CrossFightBattle_MapRankDes = "XH thế lực {p1}:"
CrossFightBattle_FightEnd_Txt = "{p1} sau kết thúc trận đấu này"
CrossFightBattle_EnoughApplyTime = "Mỗi ngày được đổi khu vực 1 lần"
CrossFightBattle_opentime = "Bang Chiến Liên Server kỳ sau mở vào {p1}.{p2}"
CrossFightBattle_TimeShow = "{p1} giờ {p2} phút {p3} giây"
CrossFightBattle_ApplySuccess = "{p1} báo danh thành công"
CrossFightBattle_ApplyOutTime = "Không trong giờ báo danh"
CrossFightBattle_ChangeTxt = "Xác nhận đổi tới tỉ thí khu vực {p1}? (Mỗi ngày chỉ đổi 1 lần)"
CrossFightBattle_ShowTxt1 = "Bang lọt top Tranh Bá Bang tuần trước của server được vào Bang Chiến Liên SErver"
CrossFightBattle_ShowTxt2 = "Chưa mở"


CrossFightBattle_MapLayer_Txt = {
	"Báo danh còn:",
	"Chiến đấu còn:",
	"Kết thúc sau:",
	"Báo danh trận 2:",
	"Báo danh còn:",
	"Chiến đấu còn:",
	"Kết thúc sau:",
}




RoleQianXiuLayer_Tip = "Từ bỏ thuộc tính tĩnh tu nhanh?"
RoleQianXiuLayer_Tip1 = "Tổng thuộc tính Khổ Hành đạt mục tiêu sẽ mở Chính Niệm"
RoleQianXiuLayer_Tip2 = "Mở giai đoạn mới"
RoleInfoLayer_py_red = "Mở Thần Thoại"
RoleQianXiuLayer_TipOneKey = "Tĩnh tu nhanh sẽ tự động tĩnh tu 10 lần, xác nhận?"
RoleQianXiuLayer_Tip_lock1 = "Khóa thuộc tính sẽ tiêu thêm {p1} {p2}, xác nhận tĩnh tu"
RoleQianXiuLayer_Tip_lock2 = "Tĩnh tu nhanh tự động tĩnh tu 10 lần, lần này cần thêm {p1}"
KaojiaoLayer_TxtGood = "Hiện đã đạt tối đa"
KaojiaoLayer_TxtOneKeySuccess = "Nâng nhanh thành công"
RoleQianXiuLayer_TipAllBad = "Thay đổi hành vi sẽ khiến thuộc tính tướng giảm, xác nhận?"

KaojiaoManager_VipRule = "VIP{p1} mở {p2}.\n\nĐến nạp?"

SkillDetail_shayi			="{p1} Chiến Ý"
SkillDetail_shayi_0			="Không hao Chiến Ý"
Activity_jianghumoney_des = " đạt "
Activity_jianghumoney_vip_num = "VIP{p1}"
Activity_jianghumoney_vip_des = 
{
	[1] = " được mua Thông Bảo!",
	[2] = " được mua Tinh Bảo!",
	[3] = " được mua Cực Bảo!",
}
Activity_jianghumoney_Tips = 
{
	[1] = "Mỗi người chỉ được mua 1 loại\nXu cao cấp cho lợi ích lớn hơn\nDùng {p1} KNB mua Thông Bảo?",
	[2] = "Mỗi người chỉ được mua 1 loại\nXu cao cấp cho lợi ích lớn hơn\nDùng {p1} KNB mua Tinh Bảo?",
	[3] = "Mỗi người chỉ được mua 1 loại\nDùng {p1} KNB mua Cực Bảo?",
}
Activity_jianghumoney_ExpiryDate = "Hiệu lực vĩnh viễn"
Activity_jianghumoney_Content = "Xu Kim Khố chỉ dành cho người Lv1-{p1} mua, đạt cấp tương ứng được nhận thưởng. Mỗi người chỉ được mua 1 loại."
Activity_jianghumoney_Limit = "Dưới cấp {p1} được mua"
Activity_jianghumoney_Buy_Success = "Mua thành công"
Activity_jianghumoney_Name = "Kim Khố"

LongMenPoLayer_txt1 = "Xác nhận dùng Tuyền Ky Kính, quay ngẫu nhiên 1 Cơ Quan Vị?"
LongMenPoLayer_txt2 = "Tuyền Ky Kính tầng này đã hết lượt dùng"
LongMenPoLayer_txt3 = "Đại hiệp phá trận tầng {p1} thành công, nhận "
LongMenPoLayer_txt4 = "Tiêu {p1} KNB, làm mới thưởng cực phẩm?"
LongMenPoLayer_txt5 = "Tầng hiện tại không có Cơ Quan chưa mở"
LongMenPoLayer_txt6 = "Thoát giao diện sẽ cài lại tiến độ, xác nhận?"
LongMenPoLayer_txt7 = "Kích hoạt Cơ Quan Vị, thách đấu thất bại, dùng Côn Lôn Ngọc, tiếp tục thách đấu sau hồi sinh?"
LongMenPoLayer_txt8 = "Dùng Hi Hoàng Điệp, cài lại lượt dùng ải và Tuyền Ky Kính, Côn Lôn Ngọc tầng này?"
LongMenPoLayer_txt9 = "Nhấp bắt đầu phá trận"
LongMenPoLayer_txt10 = "Phá trận thất bại"
LongMenPoLayer_txt11 = "Hồi sinh thành cong"
LongMenPoLayer_txt12 = "Hồi sinh thành công, cài lại lượt dùng toàn bộ đạo cụ"
LongMenPoLayer_txt13 = "Dùng {p1} KNB mở Long Môn Phá?"
LongMenPoLayer_txt14 = "Đã mở Cơ Quan tầng này, không thể làm mới"
LongMenPoLayer_txt15 = "Phá trận thành công, nhận "



SevenDaysPowerManager_text1 = "H.thành ({p1}/{p2})"
SevenDaysPowerManager_text2 = "Chưa h.thành ({p1}/{p2})"
SevenDaysPowerManager_text3 = "Xác nhận nhận tướng này? (Sau khi chọn không thể chọn tướng khác)"

LunJianFeng_txt1 = "Mua lượt thách đấu"
LunJianFeng_txt2 = "Không đủ lượt thách đấu"
LunJianFeng_txt3 = "Dùng {p1} KNB mua 1 lượt thách đấu?"

CustomSkillCondition = 
{
	[1] = "HP tướng địch dưới ",
	[2] = "Kỹ năng không trong CD",
	[3] = "HP tướng ta dưới ",
}
CustomSkillConditionNone = "Không"
CustomSkillBaseNoPos = "Vị trí kỹ năng cơ bản đã đầy"
CustomSkillSpecialNoPos = "Vị trí kỹ năng đặc biệt đã đầy"
CustomSkillOpenLevel = "Lv{p1} mở"
CustomSkillConditionRed = "Nhấp vào đây chọn điều kiện"
CustomSkillOperateSure = "Hiện chưa cài tướng nào, tự động chiến đấu sẽ không phóng kỹ năng, xác nhận về?"

LunjianFeng_txt_rank1 = "Thêm thưởng cần thêm：{p1} điểm"
LunjianFeng_txt_rank2 = "Đạt {p1} điểm"

LunJianFeng_txt_battlelog_win1 = "Tại Đỉnh Luận Kiếm tầng {p1}, bạn đánh bại đối thủ, chiếm được Trận Nhãn"
LunJianFeng_txt_battlelog_win2 = "Tại Đỉnh Luận Kiếm tầng {p1}, bạn đã đánh bại địch mạnh, phòng thủ thành công"
LunJianFeng_txt_battlelog_lose1 = "Tại Đỉnh Luận Kiếm tầng {p1}, bạn đã để thua đối thủ, chiếm Trận Nhãn thất bại"
LunJianFeng_txt_battlelog_lose2 = "Tại Đỉnh Luận Kiếm tầng {p1}, bạn để thua đối thủ, phòng thủ thất bại"
LunJianFeng_txt_battlelog_zhenyan1 = "Trận Nhãn： không"
LunJianFeng_txt_battlelog_zhenyan2 = "Trận Nhãn： tầng {p1}"
LunJianFeng_txt_battlelog_server = "Server：{p1}"

LunJianFeng_txt_bpbuff_layer = "Tầng {p1}"
LunJianFeng_txt_bpbuff_layer0 = "Hạng {p1}"
LunJianFeng_txt_bpbuff_layer2 = "Thành viên tầng {p1}:"

LunJianFeng_txt_main_myinfo = "Trận Nhãn(Tầng {p1})"
LunJianFeng_txt_main_myinfo1 = "Trận Nhãn(Không)"
LunJianFeng_txt_main_score = "Điểm："
LunJianFeng_txt_main_scroll_info1 = " đã chiếm Trận Nhãn tầng {p1}"
LunJianFeng_txt_main_scroll_info2 = " đã chiếm toàn bộ Trận Nhãn tầng {p1}"
LunJianFeng_txt_main_scroll_des1 = " tăng thêm {p1}% thuộc tính cho bạn"
LunJianFeng_txt_main_scroll_des2 = "Sắp tới ngày nhất thống giang hồ!"
LunJianFeng_txt_main_zzcc = "Server chiếm："
LunJianFeng_txt_main_nopoint = "Trận Nhãn chưa chiếm"
LunJianFeng_txt_Close = "Đang tổng kết thưởng, 23:55-00:05 không thể chiếm, từ bỏ Trận Nhãn"
LunJianFeng_txt_open  = "Đỉnh Luận Kiếm mở vào 10：00-22：00 mỗi thứ 2"

LunJianFeng_txt_vs_tip = "Trận Nhãn hiện đang tranh đoạt, tiếp tục vào?"
LunJianFeng_txt_vs_tip1 = "Hiện đã có Trận Nhãn, xác nhận bỏ Trận Nhãn hiện tại và thách đấu Trận Nhãn này?"
LunJianFeng_txt_vs_tip2 = "Hiện đã có Trận Nhãn, xác nhận bỏ Trận Nhãn hiện tại và chiếm Trận Nhãn này?"
LunJianFeng_txt_info_counted = "Trong đó {p1} điểm đã tổng kết"
LunJianFeng_txt_info_tip = "Điểm/giờ"
LunJianFeng_txt_info_zzcc = "Trận 1 toàn bộ người tầng này nhận thêm {p1} điểm/giờ"
LunJianFeng_peak_score_des = "Điểm Đỉnh Luận Kiếm, nhận từ Đỉnh Luận Kiếm, dùng để tổng kết thưởng BXH"
LunJianFeng_peak_info_abandon = "Từ bỏ chiếm lĩnh nhận ngay sản sinh tích lũy, xác nhận bỏ?"
LunJianFeng_peak_error = 'Không đủ lượt thách đấu'
LunJianFeng_peak_score = 'Mỗi giờ nhận {p1} điểm'

LunJianFeng_peak_time = 'Còn:{p1}'
LunJianFeng_peak_rank = 'Tuần trước chưa có thứ hạng'
LunJianFeng_peak_hhhp1 = 'Toàn Bang buff'
LunJianFeng_peak_hhhp2 = 'toàn t.tính trong 7 ngày'
Xiling_txt_reward1 = "Hạng 1 qua ải này:"
replayLayer_buy_xiling ="Mua Ngạc Hồn Thạch" 
replayLayer_no_xiling ="Không đủ Ngạc Hồn Thạch"
replayLayer_buy_xiling_tips ="Dùng {p1} KNB bổ sung {p2} lượt thách đấu?"
Xiling_txt_enough1 = "Vượt Vô Lượng Sơn Bắc tầng {p1} mở"
Xiling_txt_enough2 = "Sau Võ Lâm Đại Hội Liên Server kỳ 1 mở"
Xiling_txt_season1 = "Lần mở tới:{p1} sau"
Xiling_txt_res_desc2 = "Xu thông dụng ở Shop Đỉnh Cao, đổi vật phẩm thường tại Shop Đỉnh Cao"
Xiling_txt_res_desc3 = "Xu hiếm ở Shop Đỉnh Cao, đổi vật phẩm hiếm tại Shop Đỉnh Cao"
Xiling_server_closed = "Vô Lượng Ác Mộng chưa mở"

ZhuanJi_txt1	= "Toàn bộ tướng ra trận"
ZhuanJi_txt2 	= "{p1} truyện ký kích hoạt {p2} để mở"

EquipGradeTitle = "Lỗ Phụ Ma {p1}"
EquipGradeTips = "Nâng sao T.Bị lên {p1} sao mở giới hạn bậc {p2}"
EquipGradeNone = "Không"
EquipGradeUpCount = "Bậc {p1}"
equip_star_not_enough = "Trang bị không đủ {p1} sao"
EquipGradeExp = "{p1} điểm Phụ Ma"
EquipToolsNot = "Không đủ Đá Phụ Ma"
EquipGradeSureTips = "Xác nhận nâng bậc?"

Jiayuan_daoju_not_enough = "Không đủ nguyên liệu"
Jiayuan_times_get = "(Đã nhận)"
Jiayuan_times_not_get = "(Chưa nhận)"
replayLayer_buy_jiayuan_zhuanpan = "Mua lượt quay"
replayLayer_no_jiayuan_zhuanpan = "Không đủ lượt quay"
replayLayer_buy_jiayuan_zhuanpan_tips ="Dùng {p1} KNB bổ sung {p2} lượt quay?"
replayLayer_buy_jiayuan_share = "Mua lượt chia sẻ"
replayLayer_no_jiayuan_share = "Không đủ lượt chia sẻ"
replayLayer_buy_jiayuan_share_tips ="Dùng {p1} KNB bổ sung {p2} lượt chia sẻ?"
replayLayer_buy_jiayuan_invite = "Mua lượt mời"
replayLayer_no_jiayuan_invite = "Không đủ lượt mời"
replayLayer_buy_jiayuan_invite_tips ="Dùng {p1} KNB bổ sung {p2} lượt mời?"
Jiayuan_fengshui_have = "Có：{p1}"
Jiayuan_achieve1 = "Gia Viên đạt cấp {p1}"
Jiayuan_achieve2 = "Toàn tướng ra trận {p1}+{p2}"
Jiayuan_up_all = "Toàn tướng ra trận {p1}+{p2}"
Jiayuan_share_fail = "Chia sẻ thất bại"
Jiayuan_share_desc1 = "Anh Hùng Mỹ Nhân, Cái Thế Thần Công, trải nghiệm cuộc sống giang hồ, võ hiệp kinh điển. Ta là "
Jiayuan_share_desc2 = " "
Jiayuan_share_desc3 = ", mã mời là #"
Jiayuan_share_desc4 = "#, sau khi sao chép, vào tạo nhân vật để nhận quà hấp dẫn!"
Jiayuan_level_up1 = "Toàn tướng ra trận {p1}+{p2}"
Jiayuan_level_up2 = "Toàn tướng ra trận {p1}+{p2}  đã kích hoạt"

Jiayuan_zan_max = "Đã đạt tối đa"
Jiayuan_zan_not_enough = "Tạm không đủ"
Jiayuan_zan_success = "Like thành công"

Jiayuan_share_fail = "Tải bản cài mới nhất mở chia sẻ nhanh"
Jiayuan_server_close = "Gia Viên đã đóng"
Jiayuan_level_max = "Gia Viên đã đạt cấp cao nhất"
Jiayuan_qq_not_enable = "QQ tạm không thể chia sẻ"
Jiayuan_home_event_fire = "Bạn đã dập lửa, sau khi toàn bộ lửa được dập sẽ phát thưởng qua thư"
Jiayuan_home_event_fire1 = "Dập lửa thành công, toàn bộ lửa bị dập sẽ phát thưởng qua thư"
Jiayuan_home_event_jiangwu = "Bạn đã luận võ với tướng này"
Jiayuan_home_event_jiangwu1 = "Luận võ thành công"
Jiayuan_home_event_water = "Tưới nước thành công"
Jiayuan_home_event_times = "Lượt tham dự sự kiện hôm nay đã hết"

Jiayuan_home_event_record_1 = "{p1} đã like Gia Viên của bạn"
Jiayuan_home_event_record_2 = "{p1} đã tưới cây cho Gia Viên của bạn"
Jiayuan_home_event_record_3 = "{p1} đã dập lửa cho Gia Viên của bạn"
Jiayuan_home_event_record_4 = "{p1} đã luận võ với tướng ghé thăm"
Jiayuan_home_name_1 = "Gia Viên"
Jiayuan_home_name_2 = "Gia Viên {p1}"

fumo_boss_jieduan = "Giai đoạn {p1}"
fumo_reward_time = "Mỗi ngày {p1} phát"
fumo_txt_shoushengzhe = "Thắng đầu giai đoạn {p1}："
fumo_reward_time = "Mỗi ngày {p1} phát"
fumo_myserver_rank = "Hạng {p1}"
fumo_myserver_no_rank = "Chưa lọt BXH"

TianJiLun_jiangli_txt = "Thưởng x"
TianJiLun_have_num_txt = "Có {p1}"
TianJiLun_free_num_txt = "Lượt miễn phí："
TianJiLun_score_txt = "Nhận điểm："
TianJiLun_coindes_txt = "Mua {p1} Đồng"
TianJiLun_tip_coinwasin = "Đã bỏ xu hãy kéo cần gạt"
TianJiLun_tip_suercoinin = "Hãy bỏ xu"
TianJiLun_tip_suerremain = "Tiêu {p1} mua {p2} Đồng?"

TianJiLun_msg_txt1 = "Chúc mừng đại hiệp nhận "
TianJiLun_msg_txt2 = "Đại hiệp may mắn nhận "
TianJiLun_msg_txt3 = "Đại hiệp nhận được ({p1}) KNB"
TianJiLun_msg_txt4 = "Chúc mừng đại hiệp, giành được ({p1}) KNB"

FightStrategyName_Attack = "Trận Công"
FightStrategyName_Defense = "Trận Thủ"
FightStrategyName_DOUBLE1 = "Trận Công Thủ 1"
FightStrategyName_DOUBLE2 = "Trận Công Thủ 2"

RedPacket_txt1 = "Chúc mừng phát tài, mau thử vận may nào!"
RedPacket_main_txt1 = "Hiện có ：{p1}"
RedPacket_main_txt2 = "Lượt mua h.nay：{p1} lần"
RedPacket_main_txt3 = "Không tìm thấy thông tin Bang"
RedPacket_main_txt4 = "Bang đang giải tán, không thể phát lì xì"
RedPacket_send_txt1 = "Bang không đủ {p1} người để phát lì xì"
RedPacket_he = " và "
RedPacket_daibi1 = "{p1} phiếu lì xì"
RedPacket_daibi2 = "Phiếu Lì Xì："
RedPacket_daibi3 = "Không đủ Phiếu Lì Xì"
RedPacket_daibi4 = "Trung Nghĩa: "
RedPacket_dengji = "Cần Bang đạt Lv2"
RedPacket_quanxian = "Bang Chủ và Bang Phó được phát lì xì sôi nổi"
RedPacket_over = "Phát quá lâu, lì xì đã quá hạn"
RedPacket_targetzhongyi = "Trung Nghĩa đạt {p1}"
RedPacket_buy_tittle = "Mua lì xì"
RedPacket_buy_msg = "Xác nhận tiêu {p1} mua 1 {p2}?"
RedPacket_buff_tittle = {"","Mở Rộng Tấm Lòng","Trượng Nghĩa Khinh Tài"}
RedPacket_buff_content = {
		"",
		"Do bạn Mở Rộng Tấm Lòng, nhận 1 giờ buff thuộc tính, trong thời gian duy trì：\nT.tính toàn tướng tăng 1%",
		"Do bạn Trượng Nghĩa Khinh Tài, nhận 1 giờ buff thuộc tính, trong thời gian duy trì：\nT.tính toàn tướng tăng 3%"
}
Faction_RedPacket = "Lì Xì Bang"
StrategyCard_tool_tips = " EXP +{p1}"
StrategyCard_tool_not_enough = "Không đủ nguyên liệu nâng cấp Trận Pháp"
StrategyCard_txt_star_jihuo = "{p1} sao kích hoạt"
StrategyCard_txt_yongyou = "(Có {p1})"
StrategyCard_yiweidanbuzu = "Không đủ Cửu Cung Đồ"
StrategyCard_yiwei_sure = "Xác nhận đổi vị trí?"
StrategyCard_tupo_not_enough = "Không đủ nguyên liệu đột phá"
StrategyCard_tupo_max = "Đã đột phá tới cấp cao nhất"
StrategyCard_shengxing_fail = "Nâng sao thất bại"
StrategyCard_free_yiwei = "Miễn phí"
StrategyCard_lock_tips = "Đại hiệp, khóa vị trí cần {p1} KNB, xác nhận?"
StrategyCard_activity_level = "({p1} sao kích hoạt)"
StrategyCard_chip_num = "Số mảnh:"
StrategyCard_level_limit = "Hiện đã cường hóa tối đa"
StrategyCard_empty = "Thách đấu ải Xung Trận nhận trang Trận Pháp"
StrategyCard_path = "Xung Trận"


CrossArray_PleasePassGuard = "Diệt Trận Vệ xung quanh trước"
CrossArray_PleaseOpenGuard = "Hãy xua tan mây mù xung quanh trước"
CrossArray_PleasePassBefore = "Hãy vượt qua ải phía trước"
CrossArray_PleaseCancelType = "Từ bỏ tiến độ hiện tại, bắt đầu lại"
CrossArray_PleaseResetInfo  = "Cài lại sẽ xóa tiến độ Xung Trận hiện tại, xác nhận?"
CrossArrayChooseDetail_Quick1 = "Vượt ải mới được quét"
CrossArray_tip_gofight = "Ra trận tối thiểu 1 tướng còn sống sót"
StrategyCard_tool_not_enough = "Không đủ Đá Ngũ Hành"
StrategyCard_all_locked = "Tất cả vị trí đều đã khóa"
StrategyCard_txt_need_tupo_star = "(Cần Trận Pháp đột phá lên {p1} sao)"
StrategyCard_txt_tupo_max = "(Đã c.hóa cấp tối đa)"

RechargeTicket_shuoming_today = "Toàn bộ phiếu tặng tại mục này sẽ hết hạn vào 23:59:59 hôm nay"
RechargeTicket_shuoming_tomorrow = "Toàn bộ phiếu tặng tại mục này sẽ hết hạn vào 23:59:59 hôm nay"
RechargeTicket_desc1 = "Nạp tặng thẻ, dùng tự động khi nạp, nhận thêm KNB và điểm VIP"

TrustOneKey_Nomore = "Đã vượt toàn bộ ải hiện tại"

Tianshu_Chongzhu_Quality_Name_1   = "Đọc qua"
Tianshu_Chongzhu_Quality_Name_2   = "Hiểu sơ"
Tianshu_Chongzhu_Quality_Name_3   = "Thuộc lòng"
Tianshu_Chongzhu_Quality_Name_4   = "Nghiên cứu"
Tianshu_Chongzhu_Quality_Name_5   = "Hiểu rõ"
Tianshu_Chongzhu_Quality_Name_6   = "Tinh thông"
Tianshu_Chongzhu_Unlock = "N.cứu Thiên Thư có 2 ô đạt đọc qua sẽ mở"
Tianshu_Extra_Name1 = "T.tính cơ bản"
Tianshu_Extra_Name2 = "HP"
Tianshu_Extra_Name3 = "Lỗ Ngọc +1"

VipScore_success = "Ký danh thành công, điểm VIP +{p1}"
ResouceDown_text = {"Tài nguyên giao diện mới ({p1}M)","Tài nguyên nhân vật ({p1}M)","Tài nguyên hiệu ứng kỹ năng ({p1}M)"}

chat_format_new = [[chatType:%d,uid:%d,level:%d,roleId:%d,timestamp:%d,name:%s,vipLevel:%d,headPicFrame:%d,icon:%d,guildId:%d,guildName:%s,competence:%d,serverId:%d,serverName:%s,titleType:%d,content:%s]]

-- chat_format_new_temp = [[chatType:{p1},uid:{p2},level:{p3},roleId:{p4},timestamp:{p5},name:{p6},vipLevel:{p7},headPicFrame:{p8},icon:{p9}]]
-- chat_format_new = [[{p1},guildId:{p2},guildName:{p3},competence:{p4},serverId:{p5},serverName:{p6},titleType:{p7},content:{p8}]]

menuLayer_txt_level_open = "Lv{p1} mở"



CollectRoleCell_times_over = "Bạn đã thu thập xong"
CollectRoleCell_Condition_Fail = "Chưa đủ điều kiện nhận"
CollectRoleCell_Text_1 = "Thu thập tướng dưới đây"
CollectRoleCell_Text_2 = "Tướng dưới đây nâng lên {p1} sao"

AdventureRandomEventTips = "Đã kích hoạt sự kiện Du ngoạn ngẫu nhiên, đến map Du ngoạn"

SevenDayRankManager_get_reward_fail = "Nhận thất bại"
SevenDayRankManager_txt_title1 = "So cấp độ"
SevenDayRankManager_txt_title2 = "So chiến lực"
SevenDayRankManager_txt_title3 = "So KNB"
SevenDaysRankLayer_txt_can_lingqu1 = "Đạt cấp {p1} được nhận"
SevenDaysRankLayer_txt_can_lingqu2 = "Chiến lực đạt {p1} được nhận"
SevenDaysRankLayer_txt_can_lingqu3 = "Tiêu {p1} KNB được nhận"
SevenDaysRankLayer_txt_rank1 = "Hạng {p1}~{p2}"
SevenDaysRankLayer_txt_rank2 = "Hạng {p1}"
SevenDaysRankLayer_txt_shuoming1 = "Cấp Đội tối thiểu giai đoạn h.tại：{p1}"
SevenDaysRankLayer_txt_shuoming2 = "Chiến lực tối thiểu giai đoạn h.tại：{p1}"
SevenDaysRankLayer_txt_shuoming3 = "Tiêu phí tối thiểu giai đoạn h.tại：{p1}"
SevenDaysRankLayer_txt_xiangxi1 = "Cấp Đội：{p1}"
SevenDaysRankLayer_txt_xiangxi2 = "Chiến lực：{p1}"
SevenDaysRankLayer_txt_xiangxi3 = "Tích tiêu：{p1}"
SevenDaysRankLayer_config_wrong = "Cài đặt thông tin lỗi"

Knight_Tips = 
{
	{
		"Dùng bản lĩnh thực sự, tiếp nhận thử thách chân thực.",
		"Ta sẽ dốc sức cố gắng, quyết không từ bỏ.",
		"Đánh bại bọn ta, ngươi sẽ rạng danh giang hồ.",
	},
	{
		"Dùng bản lĩnh thực sự, tiếp nhận thử thách chân thực.",
		"Ta sẽ dốc sức cố gắng, quyết không từ bỏ.",
		"Đánh bại bọn ta, ngươi sẽ rạng danh giang hồ.",
	}
}
Knight_Level 			= "Lv{p1}"
Knight_lost_tiops 		= "Chia sẻ cho hảo hữu trợ chiến?\n(Hỗ trợ chiến đấu thắng lợi sẽ phát thưởng qua thư)"
Knight_time_tips 		= "Thời gian thách đấu thử thách giang hồ đã qua"
Knight_fight_count 		= "Không đủ lượt thách đấu"
Knight_share_succeed 	= "Chia sẻ thành công"
Knight_share_tips 		= "Tiêu hao nộ của kỹ năng tướng bên ta tăng {p1} điểm"
Knight_share_tips1 		= "Thử thách ta gặp quá khó, hãy giúp ta một tay."
Knight_share_tips2 		= "Thông tin quá hạn"
Knight_Name = 
{
	"Sứ Giả Quang Minh",
	"Tiêu Dao Nhị Lão"
}

JapanIsland_txt_left_times = "Hôm nay khiêu chiến còn thừa số lần: {p1}"
JapanIsland_txt_left_times = "Thách đấu còn：{p1}"
JapanIsland_all = "Toàn"
JapanIsland_lev_range = "Cấp：{p1}-{p2}"
JapanIsland_txt_quit_team = "Thoát ải?"
JapanIsland_no_team_join  = "Bạn chưa có đội"
JapanIsland_txt_card_times = "Lượt quay còn：{p1}"
JapanIsland_can_invite_num = "Số hảo hữu mời:"
chatNoTeam = "Không có đội để chat"

JapanIslandrMyTeam       = "(Mời hảo hữu)Ta đang tổ đội thách đấu "
JapanIslandInviteJoin   = " , là bạn hãy tới chiến đấu cùng!"
JapanIslandrMyTeamFriend = "Ta đang tổ đội thách đấu "
JapanIslandInviteJoinFriend = " , mời các đại hiệp cùng ta tác chiến!"
JapanIsland_role_all_died = "Tướng ra trận đã tử vong toàn bộ"
JapanIsland_quit_fight_sure = "Thoát đội?\nThoát coi như thách đấu thất bại!"
JapanIsland_start_fight_sure = "Đội không đủ 3 người, xác nhận chiến đấu?"
JapanIsland_tuijian_zhanli = "C.lực đề xuất："
JapanIsland_tongguan = "Vượt ải"

JapanIsland_txt_quit_team2 = "Thoát đội?"
JapanIsland_can_invite_num2 = "Số thành viên mời:"
JapanIsland_txt_mem_quit = "{p1} đã rời đội"
JapanIsland_txt_mem_quit1 = "{p1} đã rời đội, đội đã giải tán"
JapanIsland_open = "Chưa mở tính năng đối diện"
JapanIsland_invite1 = "(Mời trợ chiến) Ta đang tổ đội thách đấu chương "
JapanIsland_invite2 = ", cần bạn hỗ trợ!(Hảo hữu trợ chiến không trừ lượt, cũng không được thưởng)"
JapanIsland_invite3 = "Trợ chiến người này sẽ không tiêu hao một nửa lượt chiến đấu, nhưng cũng không được thưởng, xác nhận?"
JapanIsland_tips1 	= "Đã thoát đội"
JapanIsland_tips4 = "Chúc mừng đại hiệp nhận 1 thưởng, tiêu KNB mua thưởng còn lại"

shop_xieYi_title1 		= "Không đủ Hiệp Nghĩa"
shop_xieYi_title2 		= "Mua Hiệp Nghĩa"
shop_xieYi_buy_succeed 		= "Mua Hiệp Nghĩa thành công"
shop_xieYi_tips 		= "Dùng {p1} KNB mua {p2}Hiệp Nghĩa?\n(Còn {p3} lần mua)"
shop_xieYi_buy 			= "Đã hết lượt mua"

youFang_shop_tips 		= "Nâng VIP{p1} nhận giá ưu đãi"


activity_limitShop = "Còn:"
activity_BuyBack = "Tiêu đủ {p1} KNB nhận {p2} KNB"
activity_TuanGou = "Lượng mua chung >{p1}"
activity_TuanGou1 = "Giá gốc:"
activity_TuanGouTips = "Đến mốc sau cần mua thêm {p1}"
activity_TuanGouDesTips = "Mua đủ {p1}"

BiaocheShengJi_tips1   = "Xác nhận"
BiaocheShengJi_tips2   = "Dùng Phồn Vinh nâng cấp lên {p1}, xác nhận?\n(Chỉ nâng 1 lần)"
BiaocheShengJi_tips3   = "Chỉ Bang Chủ được nâng cấp Tiêu"

Biaochemainlayer_Zhang		   		   = " trượng"
Biaochemainlayer_attack_null		   = "Hiện không có Tiêu để tấn công"

Biaochemainlayer_reset   = "Đang CD chỉnh đốn, tiêu {p1} KNB chỉnh đốn thế trận công?"
Biaochemainlayer_reset_success = "Chỉnh đốn thành công, tướng ra trận hồi toàn bộ HP"
Biaochemainlayer_reset_1 = "Thế trận công sau khi điều chỉnh"
Biaochemainlayer_reset_2 = "Chỉnh đốn thế trận công?"
Biaochemainlayer_reset_3 = "%02d:%02d:%02d sau được dùng"
Biaochemainlayer_pushmsg1 	= " khi phòng thủ hoàn thành {p1} liên thắng!"
Biaochemainlayer_pushmsg2 	= " khi tấn công hoàn thành {p1} liên thắng!"
BiaocheHistorylayer_jipo = "Đã phá："
BiaoCheBaoMing_txt 		 = "Thế trận hiện đã đầy"
BiaoCheBaoMing_txt0 	 = "Bang của bạn chưa tham dự giai đoạn báo danh"
BiaoCheBaoMing_txt1 	 = "Không có Bang để báo danh"
BiaoCheBaoNextTime_txt	 = "Tiêu Hành Thiên Hạ kỳ sau mở vào {p1}.{p2}"
BiaoCheBaoPartTime_txt	 = "00:%02d sau tổng kết"
BiaoCheBaoOpen_txt	 	 = "Đạt cấp {p1} mở Tiêu Hành Thiên Hạ"
BiaoCheBaoSignUp_txt	 = "Bạn chưa có Bang, không thể báo danh"
BiaoCheBaoAttackSuccess_txt	 = "Khi tấn công, bạn đã chiến thắng"
BiaoCheBaoAttackDefeated_txt = "Khi tấn công, bạn bị đối thủ đánh bại"

BiaoCheBaoMyInfo_txt1 = "Đang chiến đấu…"
BiaoCheBaoMyInfo_txt2 = "HP còn:"
BiaoCheBaoMyInfo_txt3 = "Bạn đã tử trận"
BiaoCheBaoMyInfo_txt4 = "Mau chỉnh đốn lại!"

Biaoche_type = {"Tiêu thường","Tiêu nhanh","Tiêu cấp tốc","Tiêu thần tốc"}

PubRecuitScoreTips1 = "Danh vọng {p1} mở khóa"
PubRecuitScoreTips2 = "Không đủ lượt mua"
PubRecuitScoreTips3 = "Không đủ danh vọng"
PubRecuitScoreTips4 = "Sự kiện đã kết thúc"
PubRecuitScoreTips5 = "Chiêu mộ Tửu Quán nhận danh vọng, mở tướng mới!"
PubRecuitScoreTips6 = "Không đủ KNB"
PubRecuitScoreTips7 = "Nhận danh vọng:{p1}"
PubRecuitScoreTips8= "Đại hiệp, tiêu {p1} KNB mua {p2}?"
Zhihuan_Zhenfa_desc         = "Nhấp chọn đổi Trận Pháp"
ZhenfaZhihuanLayer_text1    = "Hãy đặt 2 cuốn Trận Pháp"
ZhenfaZhihuanLayer_tips     = "Nhắc nhở"
ZhenfaZhihuanLayer_ok       = "Xác nhận đổi Trận Pháp?"
ZhenfaZhihuanLayer_fail     = "Đổi thất bại"
ZhenfaZhihuanLayer_success  = "Đổi thành công"
ZhenfaZhihuanLayer_quandui  = "Toàn đội"

Tianshu_tupo_special_consume = "Có {p1}{p2}"
Tianshu_tupo_special_sure = "Không đủ {p1}, dùng {p2}x{p3} đột phá?"

star_hero_invalid_time_tip = "Danh Nhân Đường chưa mở"
star_hero_goto_rank_tip1 = "Đại hiệp hiện đã xếp hạng 5!"
star_hero_goto_rank_tip2 = "Đại hiệp hiện chưa lọt top!"
OtherPlayerManager_equip_hide = "Người này đã ẩn thông tin liên quan"

KingWarScoreTime = "Đấu Điểm còn:"
KingWarBetTimeStr = "Đặt cược còn:"

KingWarInspireTips = "Đã cổ vũ {p1} lần"
KingWarLianLei = "{p1} Liên Lôi"
KingWarCreateTeam1 = "Dùng {p1} KNB lập đội\n\"{p2}\""
KingWarCreateTeam2 = "Lập đội"
KingWarInvite      = "Đội Lôi Đài của tôi {p1} mời bạn gia nhập, đồng ý?"
KingWarNumberTitle = "Kỳ {p1}"
KingWarOpenTime = "Lôi Đài Vương Giả Liên Server kỳ sau mở vào {p1}.{p2}"
KingWarSendRedPack = " đã phát {p1} lì xì liên server"
KingWarInspireAddAttr = "T.tính t.viên này +{p1}%"
KingWarInspireSycee = "Người này đã dùng {p1} KNB cổ vũ"
KingWarMyTeam 		= "Đội Lôi Đài "
KingWarInviteJoin 	= "  mời bạn gia nhập"
KingWarNoTeamJoin 	= " Bạn chưa có đội"
KingWarJoinTeamSuccess 	= "Vào đội thành công"
KingWarSignUpSuccess 	= "Báo danh thành công"
KingWarInviteJoinFalse 	= "Mời thất bại"
KingWarFightNoStart 	= "Trận đấu sau chưa bắt đầu"
KingWarFightScoreAdd 		= "Tổng điểm：{p1}"
KingWarBetsSuccess 		= "Cược thành công"
KingWarFightViewTime 		= "Hiện đấu Bá Chủ còn:"
KingWarLeaveMember = "Khai trừ thành viên?"
KingWarSignOutTeam = "Rời đội?"
KingWarCreatTeamInput								="Hãy nhập tên đội"
KingWarRandomTips = "Sau khi ghép ngẫu nhiên không thể lập đội và vào đội của hảo hữu, xác nhận?"
KingWarManager_jibai_xxx 		= "Đội của bạn đánh bại {p1},"
KingWarManager_tiaozhanshibai	= "Đội của bạn thách đấu {p1} thất bại"
KingWarManager_xxx_jibai 		= "{p1} đánh bại đội của bạn"
KingWarManager_xxx_tiaozhan 	= "{p1} thách đấu đội của bạn thất bại, "
KingWarMyTeamReport 	= "Chiến báo đội"
KingWarRedPackTips = "Từ Bá Chủ:"
KingWarFriendNum = "Số hảo hữu mời:"
KingWarInspireAddAttr1 = "T.tính +{p1}%"
KingWarInspireTips2 = "Sự kiện đã đóng"


KingWarFightEndTips = "Bang Chủ mỗi 1 lần nạp 6480 KNB, được phát lì xì cho toàn bộ người online trên cụm liên server. Mỗi 1 người nhận lì xì, Bá Chủ nhận 5 KNB"
player_invalide_name = "Rất tiếc, tên chứa từ ngữ nhạy cảm"
player_name_too_long = "Tên không được quá 5 ký tự"
player_name_include_symbol = "Tên không được chứa ký hiệu"

Open_Choice_Box_txt_yxq = "Đã khảm tối thiểu "
Open_Choice_Box_txt_level = "Lv{p1}"
Open_Choice_Box_txt_level1 = "Cấp："
Open_Choice_Box_txt_dqstar = "{p1} sao"
Open_Choice_Box_txt_weixiangqian = "Chưa khảm"
DailyMissionProgressTips								= "Hoàn thành {p1} nhiệm vụ được nhận"
WoodActivity_not_open = "Chưa mở Khinh Công Đoạt Bảo"
WoodActivityLayer_tips1   = "Xác nhận thao tác"
WoodActivityLayer_tips2   = "Khinh Công Đoạt Bảo 30 lần cần {p1} KNB, xác nhận"
WoodActivityLayer_tips3 = "Tối thiểu nhận {p1} rương dọc đường"
WoodActivityLayer_tips4 = "Đạt {p1} thước"
WoodActivityLayer_tips5  = "Lần này miễn phí"
WoodActivityLayer_tips6 = "Đạt {p1} thước được nhận"
WoodActivityLayer_tips7 = "Không có thêm log Đoạt Bảo"
WoodActivityLayer_tips8 = "{p1} thước"

Sky_book_cost_tips 			= "Không đủ {p1}, đến shop mua"
Sky_book_tips 				= "{p1} thuộc tính đạt {p2}"
Sky_book_open_2 			= "Thiên Thư này đã lĩnh hội {p1} lần("
Sky_book_sub_hurt 			= "Miễn giảm ST {p1}+{p2}"
Sky_book_open_next_rank 	= "Chúc mừng mỡ lĩnh hội [{p1}]"
Sky_book_use_count 			= "Thiên Thư này đã lĩnh hội {p1} lần("
Sky_book_tips_2 			= "Nhận trị liệu"
Sky_book_tips_3 			= "Sau khi thay, số thuộc tính tinh thông từ {p1} chuyển thành {p2} thuộc tính, thay?"
Sky_book_rank_des = 
{
    "Tiết Tử",
    "Tự Chương",
    "Sơ Lược",
    "Bản Luận",
    "Tinh Nghĩa"
}
Sky_book_attr_rank_des = 
{
    "Bình Thường",
    "Nghiên Cứu", 
    "Thấu Hiểu",
    "Thành Thục",
    "Tinh Thông"
}
Sky_book_tips_more      ="Số thuộc tính tinh thông lần lĩnh ngộ này cao hơn số thuộc tính tinh thông hiện có, tiếp tục?"
Sky_book_tips_all       ="Toàn bộ thuộc tính lần lĩnh ngộ này đã đạt tinh thông, tiếp tục lĩnh ngộ?"

activity_rank_wood1                           ="Các thưởng hạng {p1}-{p2}"
activity_rank_wood2                           ="Cách thưởng hạng {p1}"
activity_min_score_wood                       ="Cự lý tối thiểu giai đoạn h.tại"
activity_cur_score = "Điểm："
activity_cur_dis = "Cự ly："

WuLinEnemy_ClearCD = "Tiêu {p1} KNB cài lại CD thách đấu?"
WuLinEnemy_Not_Open = "Chưa mở"
WuLinEnemy_Open = "12：00-13：00 mỗi thứ 7, chủ nhật mở"
WuLinEnemy_boss_defeat = "Công địch đã bị công, hãy tiếp tục cố gắng!"
WuLinEnemy_my_hurt = "Sát thương"

ZheFa_TuiYan_Open = "Trận Pháp cường hóa đạt Lv{p1} mở"
ZheFa_TuiYan_Add_Exp = " EXP+{p1}"
ZheFa_TuiYan_Lv = "Lv{p1}"
ZheFa_TuiYan_tips2 = "{p1} vị trí đạt cấp {p2}("
ZheFa_TuiYan_tips3 = "C.hóa tối đa +{p1}"
ZheFa_TuiYan_tips1 = "C.hóa tối đa h.tại +{p1}"
ZheFa_TuiYan_tips4 = "Không đủ Tứ Tượng Sa Bàn"
ZheFa_TuiYan_tips5 = "Cấp diễn dịch đã tối đa"
ZheFa_TuiYan_tips6 = "Mở diễn dịch Trận Pháp"
ZheFa_ShenYan_tip1 = "N.cứu tối đa h.tại + {p1}"
ZheFa_ShenYan_tip2 = "Trận Pháp đột phá đạt {p1} sao"
ZheFa_ShenYan_tip3 = "N.cứu tối đa: {p1}"
ZheFa_ShenYan_tip5 = "Nghiên cứu đã đạt tối đa"
ZheFa_ShenYan_Open = "Trận Pháp đột phá lên 2 sao mở"
ZheFa_ShenYan_tip6 = "Cấp n.cứu vị trí đạt {p1} ({p2}/{p3})"
ZheFa_ShenYan_tip7 = "N.cứu Trận Pháp đã đạt tối đa"
ZheFa_ShenYan_tip8 = "Không đủ đạo cụ n.cứu Trận Pháp"

OneKeyToMaxLevel_Text1 = "Không đủ Xà Đản"
OneKeyToMaxLevel_Text2 = "Cấp nhân vật hiện đã đạt tối đa"



CrossZhengBa_Main_Layer_tip4 = "Số người ra trận hiện tại không phù hợp"
CrossZhengBa_Main_Layer_tip1 = "Người này đã bị đánh bại"
CrossZhengBa_Main_Layer_tip2 = "Không thể tấn công người đã đình chiến"
CrossZhengBa_Main_Layer_tip3 = "Không trong thời gian thách đấu"
CrossZhengBa_vs_Layer_tip = "Ngày kế tiếp sau khi đình chiến sẽ làm mới lại 1 đối thủ, xác nhận đình chiến đối thủ này?"
CrossZhengBa_vs_Layer_tip1 = "Lần đình chiến này sẽ giảm sao, số sao sau đình chiến -1, xác nhận đình chiến đối thủ này?"
CrossZhengBa_vs_Layer_tip2 = "Sau khi đình chiến {p1} lần"
CrossZhengBa_vs_Layer_tip3 = "Đình chiến thành công, ngày mai sẽ làm mới lại 1 đối thủ"
CrossZhengBa_vs_Layer_tip4 = "Bạn đang trong giai đoạn {p1}, được ra trận đồng thời {p2} tướng, thách đấu?"
CrossZhengBa_vs_Layer_tip5 = "Hôm nay tổng kết mùa giải, lần đình chiến này sẽ khiến bạn giảm 1 cấp thứ hạng, xác nhận đình chiến?"
CrossZhengBa_DW_Layer_tip1 = "Giải trước giai đoạn {p1}, thưởng đã phát qua thư"
CrossZhengBa_DW_Layer_tip2 = "Chúc mừng! Bạn từ {p1} thăng lên {p2}"
CrossZhengBa_DW_Layer_tip3 = "Rất tiếc, bạn từ {p1} giảm xuống {p2}"
CrossZhengBa_DW_Layer_tip4 = "Chúc mừng chiến đấu thắng lợi, số sao giai đoạn +1"
CrossZhengBa_DW_Layer_tip5 = "Rất tiếc, đình chiến đối thủ này, số sao giai đoạn -1"

Eudemon_not_open 			= "Sau khi đạt quý hiếm mở Thầy Huấn Luyện, tăng thuộc tính pet"
Eudemon_not_free 			= "{p1} đang ra trận, hãy rời trận trước khi phóng sinh"
Eudemon_attr1 				= "Tổng t.tính tướng ra trận {p1}%+ T.tính tướng thuần dưỡng {p2}%"
Eudemon_attr11 				= "Tổng t.tính tướng ra trận \n{p1}%+ T.tính tướng thuần dưỡng {p2}%"
Eudemon_attr2 				= "Tổng t.tính tướng ra trận {p1}%"
Eudemon_attr22 				= "Tổng t.tính tướng ra trận \n{p1}%"
Eudemon_add_attr 			= "Toàn đội"
Eudemon_add_pet				= "Pet"
Eudemon_maxLevel			= "Cấp lỗ đã đạt tối đa"
Eudemon_item				= "Không đủ nguyên liệu"
Eudemon_tips				= "Chọn Thầy Huấn Luyện, tổng thuộc tính thầy huấn luyện chuyển hóa thành thuộc tính pet theo tỉ lệ"
Eudemon_free				= "Phóng sinh pet lần này nhận"
Eudemon_attr3				= "T.tính Pet ="
Eudemon_tips_2				= "Nhấp chọn Pet ra trận"
Eudemon_tips_3				= "Nâng phẩm thành công"
Eudemon_tips_4				= "Đột phá thành công"
Eudemon_tips_5				= "Đã ra trận thầy huấn luyện pet, thuộc tính thầy huấn luyện vô hiệu"
Eudemon_tips_6				= "Tính năng đã tạm đóng"
Eudemon_tips_7				= "Chọn pet hoán công:"
Eudemon_tips_8				= "Xác nhận hoán công pet?"
Eudemon_tips_9				= "Chọn pet hoán công"
Eudemon_tips_10				= "Chọn pet phóng sinh"
Eudemon_tips_11				= "Rời trận thành công"
Eudemon_XunYu = 
{
"Chụp mồi",
"Xê dịch",
"Vọt mạnh",
"Cuộn lại",
}

EudemonHoleTypeList =
{
	"Hung Dữ",
	"Hiền Lành",
	"Dễ Gần",
	"Quấn Quýt",
	"Linh Tính",
	"Trung Thành"
}

YanwuRewardRank = "Bậc {p1}"
GuildBoss_main_bosshpzero 	= "HP boss hiện là 0"
GuildBoss_main_tzcold 		= "Đang CD thách đấu"
GuildBoss_main_helpattackcold 	= "Tấn công trợ chiến đang CD"
GuildBoss_main_zhuzhan 		= "Công trợ chiến"
GuildBoss_main_helpAttackLimit	= "Sau 10 phút bắt đầu diễn võ được dùng trợ chiến tấn công"
GuildBoss_zhaoji_tip 		= " sau được tấn công"
GuildBoss_BossType 			= {"Thủ Lĩnh","Cánh Trái","Cánh Phải","Trung Quân"}

GuildBoss_Dynamic_tip_1 = "Bang sắp bắt đầu Diễn Võ, hãy chú ý!"
GuildBoss_Dynamic_tip_2 = "Bang đã bắt đầu Diễn Võ Bang, khí thế sục sôi!"

GuildBoss_open_level_tip 	= "Bang Lv3 mở Diễn Võ Bang"
GuildBoss_open_cannt_tip1 	= "Bang hiện đang giải tán, không thể mở Diễn Võ"
GuildBoss_open_cannt_tip2 	= "Bang Chủ đang bị luận tội, không thể mở Diễn Võ"
GuildBoss_open_cannt_tip3 	= "Bang Chủ đang nhượng chức, không thể mở Diễn Võ"
GuildBoss_join_time_tip 	= "Vào Bang chưa đủ 24 giờ, không thể mở Diễn Võ"
GuildBoss_open_position_tip = "Bang Chủ được mở Diễn Võ"
GuildBoss_rank_shuaxin_tip  = "Làm mới thành công"
GuildBoss_rank_gongji_cishu_tip  = "Lượt của tôi"
GuildBoss_rank_tip1 		= "Sát thương"
GuildBoss_rank_tip2 		= " lượt"

Anti_Tip_NotAnti = "Bạn đang trong thời gian nghiện game, không thể nạp."
Anti_Tip_time3	= "Bạn đã online 3 giờ, nếu tiếp tục sẽ giảm 50% lợi ích trong game."
Anti_Tip_time5	= "Bạn đã online 5 giờ, lợi ích trong game bằng 0."
Anti_Tip_NoSdk	= "Hãy tới kho ứng dụng cập nhật bản cài mới để chuyển đến xác thực tên thật."

activity_time_tip="{p1}:{p2}—{p3}:{p4}"

--周年庆
Anniversary_Time =
{
	[41] = "00:00 ngày 9/2 đến 23:59 23/2 ",
	[42] = "00:00 ngày 9/2 đến 23:59 23/2 ",
	[43] = "00:00 ngày 9/2 đến 23:59 26/2 ",
	[45] = "00:00 ngày 9/2 đến 23:59 10/3 "
}
Anniversary_Name = 
{
	[41] = "N.vụ sôi nổi",
	[42] = "N.vụ vui vẻ",
	[43] = "N.vụ đổi",
	[44] = "Online giờ chẵn",
	[45] = "Ký danh ngày",
	[102] = "Món Quà Bất Ngờ",
}
Anniversary_details = 
{
	[41] = "Trong sự kiện tết hoàn thành nhiệm vụ chỉ định nhận Đào Phù đổi thưởng. Tiến độ nhiệm vụ và trạng thái nhận reset mỗi ngày",
	[42] = "Trong sự kiện tết hoàn thành nhiệm vụ chỉ định nhận Đào Phù đổi thưởng. Trong sự kiện chỉ được nhận 1 lần",
	[43] = "Trong sự kiện tết thu thập Đào Phù để đổi thưởng",
	[44] = "Trong sự kiện, 12：00 và 18：00 mỗi ngày online được nhận thưởng online giờ chẵn qua thư.",
	[45] = "Trong sự kiện, tích lũy đăng nhập liên tục đủ điều kiện được nhận thưởng",
	[102] = "Trong sự kiện, thách đấu hoặc quét Ải thường và Ải Tông Sư, có xác suất nhận thêm quà hậu hĩnh.",
}
XinFaSpecialbuteTypeStr = 
{
	[501]="Hệ số Võ-Nội lực k.năng chủ động",
	[502]="Võ lực k.năng chủ động",
	[503]="CD k.năng giảm",
	[504]="Nội lực k.năng chủ động",
	[505]="Võ lực, nội lực k.năng thần chủ động",
}

XinFaSpecialbuteTypeDisPlayeStr = 
{
	[32] ={"ST bạo tăng"},
	[33] ={"Miễn giảm ST bạo"},
	[501]={"K.năng chủ động","Hệ số Võ-Nội Lực"},
	[502]={"K.năng chủ động","Hệ số Võ Lực"},
	[503]={"CD k.năng","Giảm"},
	[504]={"K.năng chủ động","Hệ số Nội Lực"},
	[505]={"K.năng thần chủ động","Hệ số Võ-Nội Lực"},
}
RoleXinFa_text1        ="Mau dùng Tâm Pháp phù hợp nhất cho tướng!"
XinFa_sell 			= "Bán Tâm Pháp nhận： "
Xinfa_TuPo_star		= "Tâm Pháp đột phá lên {p1}({p2}/{p3})"
Xinfa_XiuLian_Lv	= "Tâm Pháp tu luyện đạt {p1}({p2}/{p3})"
Xinfa_tips_more     = "Tâm Pháp này đã có tiến độ luyện, xác nhận bán?"
Xinfa_tips_xiulian 	= "Tiêu {p1} cuốn {p2} tu luyện?"
Xinfa_cost_buzu		= "Không đủ Xu Châu Tâm"
XinfaZhihuanLayer_text1    = "Hãy đặt 2 cuốn Tâm Pháp"
XinFa_xiangzi 		= "Rương Mảnh Tâm Pháp-Ngẫu"
XuanGuan 			= "Huyền Quan"
XinFaXuanGuan		= "Huyền Quan {p1} Lv10 mở Huyền Quan {p2}"
XinFaXuanGuan1		= "Huyền Quan HP Lv1 mở"
XinFaTuPoLevel 		= "Cấp đột phá:"
XuanGuan 			= "Huyền Quan"
XinFaXuanGuan		= "Huyền Quan {p1} Lv10 mở Huyền Quan {p2}"
BaoShiZengFu 		= "Lỗ thêm: "
Same_Gem_Add 		= "Tương sinh tăng thêm: "
Diff_Gem_Add 		= "Tương phù tăng thêm: "
Extra_Gem_Add		= "Sau khi kích hoạt thuộc tính Huyền Quan và Ngọc thêm"
MaxGemLevel 		= "Tối đa khảm Ngọc Lv{p1}"
Gem 				= "Ngọc {p1}"
GemOverLevel 		= "Cấp Ngọc này quá cao không thể khảm"
CostNotFound 		= "Không tìm thấy module tiêu hao"
Extra_Gem_XianQian	= "Khảm"
Extra_Gem_XianQian2 = ", thuộc tính"
Same_Gem  			= "Tương sinh lỗ"
Diff_Gem  			= "Tương phù lỗ"
Xinfa_buzu 			= "Tham dự sự kiện nhận trang Tâm Pháp"

XinfaMingxin_extra_attribute1 = "T.tính chính Tâm Pháp tăng"
XinfaMingxin_extra_attribute2 = "Ngọc Tâm Pháp tăng"
XinfaMingxin_extra_attribute3 = "T.tính đặc biệt Tâm Pháp"

Xinfa_Chongzhu_Quality_Name_1   = "Mê Đồ"
Xinfa_Chongzhu_Quality_Name_2   = "Soi Sáng"
Xinfa_Chongzhu_Quality_Name_3   = "Giác Ngộ"
Xinfa_Chongzhu_Quality_Name_4   = "Quán Đỉnh"
Xinfa_Chongzhu_Quality_Name_5   = "Thiên Nhất"
Xinfa_Chongzhu_Quality_Name_6   = "Võ khúc"

Taozhuang_text1 = "2 món k.hoạt:"
Taozhuang_text2 = "3 món k.hoạt:"
Taozhuang_text3 = "4 món k.hoạt:"
Taozhuang_text4 = "5 món k.hoạt:"

EudemonHoleTypeList =
{
"Kiệt ngạo",
"Bình thản",
"Ôn lương",
"Tri tâm",
"Linh tính",
"Tử trung"
}
Suit = "Trang phục"
SuitName =
{
	"Bộ Ngạo Thiên",
	"Bộ Long Ngâm",
	"Bộ Bất Động",
	"Bộ 6 tháng",
	"Bộ 1 Năm"
}

Fight_effect_tips_1 = "Không có effect:{p1}"

OpenFaction_Tips = {[30311] = "Đã mở ra nhiều lần càn quét công năng" }
shortAttributeTypeStr = 
{
	[32] = "ST Bạo",
	[33] = "Kháng ST Bạo"
}

GoldenCard_tip4		= "Nhận còn:{p1}"
GoldenCard_tip5		= "{p1} KNB"
GoldenCard_richtip	= [[<p style="text-align:left margin:5px" ><font color="#000000" fontSize="20">Lần này được nhận </font>
		<font color="#000000" fontSize="20">{p1}!<br/>Mỗi ngày chỉ được nhận 1 lần thưởng, xác nhận nhận?</font></p>]]

Nainshou_NotOpen = "Chưa mở"
Nainshou_OpenTime = "{p1}.{p2} - {p3}.{p4} "
Nainshou_tips1 = "Niên Thú bị bạn đuổi tới địa bàn của #R-1-1-{p1}#, nếu đuổi được Niên Thú trước khi hết giờ, Niên Thú sẽ quay trở về!"
Nainshou_tips2 = "Niên Thú dừng tại địa bàn của #R-1-1-{p1}#, nếu đuổi được Niên Thú trước khi kết thúc, Niên Thú sẽ quay trở về!"
Nainshou_tips3 = "Niên Thú dừng tại địa bàn của #R-1-1-{p1}#, nếu đuổi được Niên Thú trước khi kết thúc,  sẽ nhận thêm thưởng"
Nainshou_tips4 = "Niên Thú năm #R-0-1- bị bạn đuổi đi rồi!#"
Nainshou_txt_name_1 = "Niên Thú {p1} xua tới"
Nainshou_txt_name_2 = "Niên Thú {p1} đuổi về"

VipShop_Cost_Name = "Điểm Shop VIP"
VipShop_Refresh  = "Không đủ lượt làm mới"
VipShop_Sure_tips = "Làm mới shop sẽ cài lại nội dung và chiết khấu vật phẩm trong mỗi ô, xác nhận?\n\n(H.nay còn：{p1} lần)"
VipShop_Sure_tips2 = "Dùng {p1} điểm VIP mua {p2} X {p3}?"

HERO_DUIHUAN_XQ 	= "Trong top {p1}"
HERO_BOX_TATIL 		= "Lượt thách đấu đạt {p1} được nhận thưởng"

HERO_RANK_UP	= "Tăng từ hạng {p1} lên {p2}"
HERO_RANK_DOWN	= "Giảm từ hạng {p1} xuống {p2}"
HERO_RANK_INVARIANT	= "Thứ hạng không đổi"
HERO_TIME 		= "Anh Hùng Đại Hội mở vào 10:00~22:00 mỗi ngày"
HERO_DUIHUAN 	= "Xác nhận đổi"
HERO_FACTION	= "Chưa có Bang"


YuanFen_tips1 = [[<p style="text-align:left margin:5px"><font color="#000000" fontSize="26"> kích duyên </font><font color="#ff0000" fontSize="26">{p1}</font>
        		<font color="#000000" fontSize="26">：</font><font color="#ff0000" fontSize="26"> {p2} </font><br></br></p>]]
YuanFen_tips2 = "Duyên"

DanFang_tips = "Đặt [{p1}x{p2}] để luyện, sau khi hoàn thành nhận [{p3}x{p4}], xác nhận thao tác"
DanFang_tips2 = "Không đủ lượt trợ giúp"
TianMing_NO 	="Không có Thiên Mệnh tương ứng, đến tế lễ nhận"
TianMing_ADD 	="Có Thiên Mệnh để khảm, nhấp lỗ khảm"
TianMing_XIANGQIANG = "Nhấp khảm Thiên Mệnh"
TianMing_SELE_XUANZHONG = "Chọn Thiên Mệnh cần khảm"
TianMing_tips1 	= "Thiên Mệnh đã chọn chứa phẩm chất tím trở lên, nuốt?"
TianMing_tips2 	= "Thiên Mệnh này đã đạt cấp tối đa"
TianMing_tips3 	= "Chọn Thiên Mệnh làm nguyên liệu"
TianMing_tips4 	= "Thiên Mệnh cần tách có phẩm chất tím trở lên, xác nhận tách?"
TianMing_tips5 	= "EXP nâng cấp"
TianMing_tips6 	= "Nâng cấp nhận thuộc tính"
TianMing_tips7 	= "Không thể khảm Thiên Mệnh cùng loại"
TianMing_tips8 	= "Nâng cấp nhanh sẽ khiến Thiên Mệnh đã chọn nuốt toàn bộ Thiên Mệnh lam trở xuống trong túi đồ, xác nhận?"
TianMing_tips9  = "Tăng"
TianMing_tips10  = "Miễn giảm"
TianMing_tips11  = "Bán Thiên Mệnh nhận： "
TianMing_tips12  = "Nâng cấp nhanh sẽ khiến Thiên Mệnh đã chọn nuốt toàn bộ Thiên Mệnh tím trở xuống trong túi đồ, xác nhận?"
TianMing_tips13  = "Chứa p.chất tím"

JiSiMainLayer_text3  ="Đàn Hương Lư cần {p1}{p2}, xác nhận"
JiSiMainLayer_OneKeyTxt  ="Lần này nhận {p1} Thiên Mệnh, tế nhanh {p2} lần"
JiSiMainLayer_text4  ="Lượt {p1}：{p2}"
JiSiMainLayer_openLv = "Cấp Đội đạt {p1} mở tế lễ"
JiSiMainLayer_text5  ="Lần tế nhanh này tự động dùng Đàn Hương Lư 20 lần, xác nhận?"
replayLayer_buy_Qi = "Mua sắm linh khí"
replayLayer_no_Qi = "Linh khí không đủ"
replayLayer_buy_Qi_tips = "Hay không tiêu phí {p1} nguyên bảo bổ sung {p2} linh khí?"
replayLayer_buy_HeroList = "Lượt mua"
replayLayer_no_HeroList = "Không đủ lượt"
replayLayer_buy_HeroList_tips ="Dùng {p1} KNB mua 1 lần?"
replayLayer_tips ="Lượt mua hôm nay đã tối đa"
replayLayer_tips2 = "Không đủ cấp"
replayLayer_tips3 = "Hãy vượt qua ải phía trước"
replayLayer_tips4 = "Có thể rớt:"

DanFang_tips = "Để vào [{p1}x{p2}] tiến hành luyện hóa, hoàn thành sau nhưng đạt được [{p3}x{p4}], hay không xác nhận thao tác"
DanFang_tips2 = "Trợ lực số lần không đủ"
-- phong vân lục
FengYunLu_tips = "Mua sắm đổi mới số lần"
FengYunLu_tips1 = "Ra tay số lần:"
FengYunLu_tips2 = "Chưa ra tay"
FengYunLu_tips3 = "Ra trận nhân số không đầy 5 người, đem không thể khiêu chiến, hay không rời khỏi?"
FengYunLu_tips4 = "Hay không tiêu phí {p1} nguyên bảo mua sắm {p2} thứ khiêu chiến số lần?"
FengYunLu_tips5 = "Đổi mới sau lấy phối trí hiệp khách đội hình sẽ thanh không, hay không quyết định đổi mới?"
FengYunLu_tips6 = "Xem xét càng nhiều"
FengYunLu_tips7 = "Đổi mới sau đã phối trí hiệp khách sẽ thanh không, hay không tiêu phí 50 nguyên bảo đổi mới?"
FengYunLu_Time= {
"Thứ ba 10: 00~22: 00",
"Thứ tư 10: 00~22: 00",
"Thứ năm 10: 00~22: 00",
}
RankHeroDetails_tips1 = "Thứ hạng:"
smithy_merge_gem = "(Ghép toàn bộ Ngọc cấp thấp lên Lv6)"
Treasure_history = "Đã hết nhật ký Tầm Bảo"
hecheng_success = "Ghép thành công"
CommonManager_need_vip5 = "VIP{p1} được mua {p2}.\n\nĐến nạp?"

RoleInfoLayer_sx_desc = {
	[1] = "Giới thiệu",
	[2] = "Cơ bản",
	[3] = "Mở rộng thuộc tính",
	[4] = "T.tính tu luyện",
}

RoleInfoLayer_sx_name = {
	[16] = "ST công thường tăng",
	[17] = "ST kỹ năng thêm",
	[18] = "S.thương liên tục thêm",
	[19] = "Miễn s.thương công thường",
	[20] = "Miễn ST kỹ năng",
	[21] = "Miễn giảm ST liên tục",
	[22] = "hiệp hồi HP",
	[23] = "Nhận buff trị liệu",
	[24] = "S.thương thêm",
	[25] = "Miễn s.thương",
	[26] = "S.thương bạo tăng",
	[27] = "Miễn ST bạo kích",
	[28] = "Giảm CD kỹ năng",
}

ServerChoiceTips = "Đăng nhập gần đây"

BaseDataManagerSkillTips1 = "+"
BaseDataManagerSkillTips2 = "-"
BaseDataManagerSkillTips3 = "Nhận"
BaseDataManagerSkillTips4 = "Cộng dồn"
BaseDataManagerSkillTips5 = "Hồi"
BaseDataManagerSkillTips6 = "lần (có tướng ra tay sẽ trừ máu)"

BaseDataManagerBattleTips = {
	[1] = "Đang chiến đấu, toàn tướng bên ta",
	[2] = "vượt ải",
	[3] = "Trong {p1} hiệp vượt ải",
	[4] = "Tối thiểu {p1} tướng ra trận còn sống sẽ vượt ải",
	[5] = "Tiêu hao nộ tướng bên ta tăng {p1} điểm sẽ vượt ải",
	[6] = "Toàn tướng bên ta còn trên {p1}% HP sẽ vượt ải",
	[7] = "Dùng kỹ năng trong chiến đấu không quá {p1} lần sẽ vượt ải",
}
BaseDataManagerGuildPracticeTips = {
	[1] = "Đội đạt cấp {p1} sẽ mở",
	[2] = "Bang đạt cấp {p1} sẽ mở"
}

SkillBuffLastTypeStr =
{
	[1] = "Hiệp",
	[2] = "lần(có tướng ra tay sẽ trừ máu)",
	[3] = "lần",
	[4] = "lần (tự thân ra tay sẽ có hiệu lực)",
	[5] = "lần (tướng đồng đội ra tay sẽ có hiệu lực)",
	[8] = "lần (tướng đồng đội ra tay sẽ có hiệu lực)",
	[9] = "lần (tướng địch ra tay sẽ có hiệu lực)",
	[11] = "Phóng kỹ năng chủ động hoặc kỹ năng thần",
}

RoleStarUpPreviewTips = "N.liệu:"


-- UI界面无法使用点的状况
ui_tr_1 = "Tướng trợ chiến h.nay"
ui_tr_2 = "Cống hiến h.nay:"
ui_tr_3 = "N.liệu"
ui_tr_4 = "Hãy chọn n.liệu"
PayTextTemplete = [[<p style="text-align:left margin:5px"><font color="#000000" fontSize = "24">Đăng nhập mỗi ngày nhận</font><font color="#FF0000" fontSize = "24">%s</font><font color="#000000" fontSize = "24">KNB</font></p>]]
smithyIntensify_not_Today = "Không đủ {p1}, hôm nay đã hết lượt mua"
ActionError = "Cài đặt sự kiện lỗi"
ActionScoreTips = "Điểm"
TianJiLunLayerTips = "Toàn rương"
LongMenPoLayerTips = "Lượt phá trận:"
GoldEggItemResultLayerTips = "Đã cài lại trạng thái nhận thưởng"
Fight_End_Tips = "Chiến đấu đã kết thúc"
ArmyNewLayer_Tips = "Lực"
Error_Time_Tips = "Thời gian sai"
BloodybattleOtherArmyVSLayer_Tips = "Cổ vũ đội tăng tỉ lệ thắng."
Fight_effect_tips_1 = "not effect:{p1}"
IllustrationTaoZhuangLayer_tips_1 = "Chưa xác định +?"
CrossFightMapLayer_tips_1 = "Thế lực mỗi phút:"
FactionRecordNew_tips_1 = "T.viên thắng nhận:"
TianshuMainLayer_tips_1 = "Sắp mở!! "
TianshuMainLayer_tips_3 = " Cần:"




UILayer_tips_1 = "Không đủ Đá Phụ Ma"
UILayer_tips_2 = "Mức nhận được"
UILayer_tips_3 = "Chưa nhận"
UILayer_tips_4 = "Buff thuộc tính toàn tướng 1%"
UILayer_tips_5 = "Đoạt Trung Nguyên"
UILayer_tips_6 = "Thế lực"
UILayer_tips_7 = "Lực đề xuất"
UILayer_tips_8 = "Lợi ích"
UILayer_tips_9 = "Sự kiện kết thúc, căn cứ vào XH tổng thành viên, buff toàn t.tính cho thành viên Bang khi tham dự Võ Lâm Đại Hội (Liên Server), Bang Phái Tranh Hùng (Liên Server), Lôi Đài Vương Giả"
FinghtError_tips = "Cuộc chiến mới nhầm rồi."
UILayer_tips_10 = "Lượt thách đấu đã hết, hôm nay đã hết lượt cài lại"
UILayer_tips_11 = "Nâng VIP"
UILayer_tips_19 = "Thế lực mỗi phút:"
UILayer_tips_12 = "Lượt thách đấu đã hết"
UILayer_tips_13 = "{v1} mở quét nhiều lần nhanh.\n\nĐến nạp?"
UILayer_tips_14 = "Lần này cần {p1} Lệnh Cài Lại, xác nhận cài lại?"
UILayer_tips_16 = "Dùng {p1} KNB cài lại lượt thách đấu ải?"
UILayer_tips_15 = "\n(Lệnh Cài Lại：{p1}, hôm nay còn {p2} lần cài lại)"
UILayer_tips_17 = "\n(Hôm nay còn {p1} lượt cài lại)"
UILayer_tips_18 = "Lượt miễn phí và tổng Lệnh Quét không đủ, dùng {p1} KNB để quét?"
UILayer_tips_20 = "ngày"
UILayer_tips_21 = "giờ"
UILayer_tips_22 = "phút"
UILayer_tips_23 = "giây"
UILayer_tips_24 = "Hoàn tài nguyên theo tỉ lệ nhất định"
UILayer_tips_25 = "6s sau đóng giao diện"
UILayer_tips_26 = "N.liệu"
UILayer_tips_27 = "T.tính cũ"
UILayer_tips_28 = "T.tính kế thừa"
UILayer_tips_29 = "Thuộc tính"
UILayer_tips_30 = "C.lực thủ lĩnh"
UILayer_tips_31 = "H.Quả Trận Vị"
UILayer_tips_32 = "Lượt khiêu chiến:"
UILayer_tips_33 = "Thời gian mở:"
UILayer_tips_34 = "Hạng："
UILayer_tips_35 = "Chưa lọt Top"
UILayer_tips_36 = "(24:00 mỗi ngày tổng kết thưởng và phát qua thư)"
UILayer_tips_37 = "(5 người ra trận để khiêu chiến)"
UILayer_tips_38 = "5 tướng trong đội cần"
UILayer_tips_39 = "xuất hiện trong cùng 1 đợt làm mới"
UILayer_tips_40 = "Hiệp khách đạt thành tích tốt nhất ải trước sẽ không xuất hiện lại"
UILayer_tips_41 = "Xem hiệp khách thành tích tốt nhất ải trước tại lịch sử đội hình"
UILayer_tips_42 = "Lượt m.phí："
UILayer_tips_43 = "Lượt ra tay:"
UILayer_tips_44 = "Thời gian:"
UILayer_tips_45 = "Ải đánh bại:"

DaTi_tip1 = "{p1} đề"
DaTi_tip2 = "Mở cửa hàng ngày từ 0:00 đến 21:00"
Dati_tip3 = "Mỗi lần hoạt động trong lúc chỉ có thể tiến hành một lần đáp đề, thỉnh cẩn thận đối đãi, điểm đánh xác định bắt đầu tính giờ."

sinleActivityInfo_BeginTime = "2019-01-30 00:00:00"
sinleActivityInfo_endTime = "2019-02-26 23:59:59"
UITips = "Đạt hạng nhận"
ActionError = "*** hoạt động thác ngộ ***"