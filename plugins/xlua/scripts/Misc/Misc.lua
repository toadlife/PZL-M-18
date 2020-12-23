----------------------------------------------------------------------------------------------------------
-- Copyright Todor Radonov 2020
-- Licnsed under Creative Commons CC BY-NC 4.0
-- https://creativecommons.org/licenses/by-nc/4.0/
----------------------------------------------------------------------------------------------------------

function tension_handle_handler()

end

audio_vol_com1 = find_dataref("sim/cockpit2/radios/actuators/audio_volume_com1")
audio_vol_nav1 = find_dataref("sim/cockpit2/radios/actuators/audio_volume_nav1")

function audio_vol_handler()
	audio_vol_com1 = audio_vol
	audio_vol_nav1 = audio_vol
end

draw_fires = find_dataref("sim/graphics/settings/draw_forestfires")
static_heat = find_dataref("sim/cockpit/switches/static_heat_on")

audio_com1 = find_dataref("sim/cockpit2/radios/actuators/audio_selection_com1")
audio_nav1 = find_dataref("sim/cockpit2/radios/actuators/audio_selection_nav1")

tension_handle = create_dataref("custom/dromader/misc/tension_handle","number", tension_handle_handler)

audio_sw = create_dataref("custom/dromader/misc/audio_sw","number")
audio_vol = create_dataref("custom/dromader/misc/audio_vol","number", audio_vol_handler)

compass_lock_knob = create_dataref("custom/dromader/compass/compass_lock_knob","number")
compass_heading_dromader = create_dataref("custom/dromader/compass/compass_heading","number")
compass_g_side_dromader = create_dataref("custom/dromader/compass/compass_g_side","number")
compass_g_nrml_dromader= create_dataref("custom/dromader/compass/compass_g_nrml","number")

compass_heading = find_dataref("sim/cockpit2/gauges/indicators/compass_heading_deg_mag")
compass_g_side = find_dataref("sim/flightmodel/forces/g_side")
compass_g_nrml = find_dataref("sim/flightmodel/forces/g_nrml")

function cmd_audiosw_up(phase, duration)
	if phase == 0 then
		audio_sw = math.min(2, audio_sw + 1)
		if audio_sw == 1 then
			audio_com1 = 0
			audio_nav1 = 0		
		elseif audio_sw == 2 then
			audio_com1 = 0
			audio_nav1 = 1
		end
	end
end

function cmd_audiosw_dn(phase, duration)
	if phase == 0 then
		audio_sw = math.max(0, audio_sw - 1)
		if audio_sw == 0 then
			audio_com1 = 1
			audio_nav1 = 0
		elseif audio_sw == 1 then
			audio_com1 = 0
			audio_nav1 = 0		
		end
	end
end


cmdcsutomaudioswup = create_command("custom/dromader/misc/audio_sw_up","Audio switch up",cmd_audiosw_up)
cmdcsutomaudioswdwn = create_command("custom/dromader/misc/audio_sw_dwn","Audio switch down",cmd_audiosw_dn)

function cmd_compasslock(phase, duration)
	if phase == 0 then
		compass_lock_knob = 1
	end
end

function cmd_compassunlock(phase, duration)
	if phase == 0 then
		compass_lock_knob = 0
	end
end

function cmd_compasslock_tog(phase, duration)
	if phase == 0 then
		if compass_lock_knob == 0 then
			compass_lock_knob = 1
		else
			compass_lock_knob = 0
		end
	end
end

cmdcsutomcompasslock = create_command("custom/dromader/compass/compass_lock","Compass lock",cmd_compasslock)
cmdcsutomcompassunlock = create_command("custom/dromader/compass/compass_unlock","Compass unlock",cmd_compassunlock)
cmdcsutomcompasslocktog = create_command("custom/dromader/compass/compass_lock_tog","Compass lock toggle",cmd_compasslock_tog)

local fires_temp = draw_fires

function aircraft_load()
	draw_fires = 1

end

function flight_start()
	tension_handle = 0.5
	static_heat = 0
	audio_com1 = 1
	audio_nav1 = 0
	audio_sw = 0
	audio_vol = 0.8
	audio_vol_com1 = audio_vol
	audio_vol_nav1 = audio_vol
	compass_lock_knob = 0
end

function aircraft_unload()
	draw_fires = fires_temp
end

function after_physics()
	if compass_lock_knob == 1 then
		compass_g_side_dromader = 0
		compass_g_nrml_dromader = 0
	else
		compass_g_side_dromader = compass_g_side
		compass_g_nrml_dromader = compass_g_nrml
		compass_heading_dromader = compass_heading
	end
end