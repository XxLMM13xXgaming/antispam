/*=======================================*\
|==========================================|
	Anti-Spam Protection
	By: MexicanRaindeer
	Copyright © 2015-2016 MexicanRaindeer
|==========================================|
\*=======================================*/

-- Check for updates --
local version = "1.0.0"

AddCSLuaFile("ras_config.lua")
include("ras_config.lua")

http.Fetch( "https://gist.githubusercontent.com/Kyrpt0/0393ae3aef12db36ba7a/raw/MASVersion",
	function( body )
		if body == version then
			PrintMessage( HUD_PRINTTALK, "[RAS]You're Up-to-date!" )
		else
			PrintMessage( HUD_PRINTTALK, "[RAS]You're not Up-to-date, please download the newest version at https://www.scriptfodder.com" )
		end
	end,
	
	function( error )
		PrintMessage( HUD_PRINTTALK, "[RAS]Failed to check if you're Up-to-date!" )
	end
)

-- If DATA directory doesn't exist, make it --
if !file.Exists( "ras_data", "DATA" ) then
	file.CreateDir( "ras_data", "DATA" )
end

util.AddNetworkString("AntiSpamOpenAdminGUI")

function AntiSpamOpenAdminGUICMD(ply, text)
	local text = string.lower(text)
	if(string.sub(text, 0, 100)== "/antispam" or string.sub(text, 0, 100)== "!antispam") then
		net.Start("AntiSpamOpenAdminGUI")
		net.Send( ply )	
		return ''
	end
end 
hook.Add("PlayerSay", "AntiSpamOpenAdminGUICMD", AntiSpamOpenAdminGUICMD)


-- Protection Variables --
AntiSpam = {}
AntiSpam.Chat = {}
AntiSpam.Prop = {}
AntiSpam.Sent = {}
AntiSpam.Effect = {}
AntiSpam.Ragdoll = {}
AntiSpam.Vehicle = {}
AntiSpam.Npc = {}
AntiSpam.Settings = {}

-- Includes --
include("von.lua")
include("table.lua")

-- Config File Defaults --
// These will be the default values when changed in the file.



-- Serialization & De-Serialization of the config file --
function SettingsSave() //This method takes the table and converts it into a string before saving it to a file. This needs to be ran every time you change a value in SETTINGS.
	local SettingString = von.serialize(AntiSpam.Settings)
    file.Write("ras_data/antispam.txt", SettingString) //The file will be in the data/ folder. Use lower case filenames!
    print("ANTI-SPAM SETTINGS HAVE BEEN SAVED!")
end

function SettingsLoad() //This method opens the file if it exists and converts the string stored into a table. This needs running when the addon initialises.
    if file.Exists("ras_data/antispam.txt", "DATA") then //Im hoping this bit is self explanatory. DATA means the data folder.
      local ReadFile = file.Read("ras_data/antispam.txt", "DATA") //Read file from DATA folder. Returns a string.
      AntiSpam.Settings = von.deserialize(ReadFile) //Overwrite the settings table with values from file.
      Msg("AntiSpam SETTINGS LOADED")
    end
end

function CheckBooleanFunc( input )
	if(input == "on") then // so if the command is !antispam chat on
	   return true
	elseif(input == "off") then
	   return false
	end
end

function CheckNumberFunc( input )
	if ( type(tonumber(input)) == "number" ) then
		if ( tonumber(input) >= 0 ) then
			return tonumber(input)
		elseif ( tonumber(input) < 0 ) then
			return '1'
		end
	end
end

-- Enable-Disable Features & Delays --
hook.Add( "PlayerSay", "ChangeAction", function( ply, text, public ) //An example of a chat command changing a setting.
    text = string.lower( text )
    text = string.Explode( " ", text )
	if ( text[1] == "!antispam" ) then
		if ply:IsUserGroup( "superadmin", "owner" ) then
			if ( text[2] == "on" ) then
				AntiSpam.Settings.AntiSpamming = true //Change das value.
				PrintMessage( HUD_PRINTTALK, "Raindeer Anti-Spam has been enabled by "..ply:Nick() )
				return ''
			elseif ( text[2] == "off" ) then
				AntiSpam.Settings.AntiSpamming = false //Change das value
				PrintMessage( HUD_PRINTTALK, "Raindeer Anti-Spam has been disabled by "..ply:Nick() )
				return ''
			elseif ( text[2] == "chat" ) then
				AntiSpam.Settings.Chat.Enabled = CheckBooleanFunc( text[3] )
				ply:ChatPrint( "Chat spam protection has been set to "..text[3].."!" )
				return ''
			elseif ( text[2] == "props" ) then
				AntiSpam.Settings.Prop.Enabled = CheckBooleanFunc( text[3] )
				ply:ChatPrint( "Prop spam protection has been set to "..text[3].."!" )
				return ''
			elseif ( text[2] == "sents" ) then
				AntiSpam.Settings.Sent.Enabled = CheckBooleanFunc( text[3] )
				ply:ChatPrint( "Scripted Ents spam protection has been set to "..text[3].."!" )
				return ''
			elseif ( text[2] == "effects" ) then
				AntiSpam.Settings.Effect.Enabled = CheckBooleanFunc( text[3] )
				ply:ChatPrint( "Effect spam protection has been set to "..text[3].."!" )
				return ''
			elseif ( text[2] == "ragdolls" ) then
				AntiSpam.Settings.Ragdoll.Enabled = CheckBooleanFunc( text[3] )
				ply:ChatPrint( "Ragdoll spam protection has been set to "..text[3].."!" )
				return ''
			elseif ( text[2] == "vehicles" ) then
				AntiSpam.Settings.Vehicle.Enabled = CheckBooleanFunc( text[3] )
				ply:ChatPrint( "Vehicle spam protection has been set to "..text[3].."!" )
				return ''
			elseif ( text[2] == "npc" ) then
				AntiSpam.Settings.Npc.Enabled = CheckBooleanFunc( text[3] )
				ply:ChatPrint( "NPC spam protection has been set to "..text[3].."!" )
				return ''
			elseif ( text[2] == "chatdelay" && tonumber(text[3]) ~= nil ) then 
				AntiSpam.Settings.Chat.Delay = CheckNumberFunc(text[3])
				ply:ChatPrint( "Chat spam delay is set to "..text[3].." seconds!" )
				return ''
			elseif ( text[2] == "propdelay" && tonumber(text[3]) ~= nil ) then
				AntiSpam.Settings.Prop.Delay = CheckNumberFunc(text[3])
				ply:ChatPrint( "Prop spam delay is set to "..text[3].." seconds!" )
				return ''
			elseif ( text[2] == "sentdelay" && tonumber(text[3]) ~= nil ) then
				AntiSpam.Settings.Sent.Delay = CheckNumberFunc(text[3])
				ply:ChatPrint( "Scripted Ent spam delay is set to "..text[3].." seconds!" )
				return ''
			elseif ( text[2] == "effectdelay" && tonumber(text[3]) ~= nil ) then
				AntiSpam.Settings.Effect.Delay = CheckNumberFunc(text[3])
				ply:ChatPrint( "Effect spam delay is set to "..text[3].." seconds!" )
				return ''
			elseif ( text[2] == "ragdolldelay" && tonumber(text[3]) ~= nil ) then
				AntiSpam.Settings.Ragdoll.Delay = CheckNumberFunc(text[3])
				ply:ChatPrint( "Ragdoll spam delay is set to "..text[3].." seconds!" )
				return ''
			elseif ( text[2] == "vehicledelay" && tonumber(text[3]) ~= nil ) then
				AntiSpam.Settings.Vehicle.Delay = CheckNumberFunc(text[3])
				ply:ChatPrint( "Vehicle spam delay is set to "..text[3].." seconds!" )
				return ''
			elseif ( text[2] == "npcdelay" && tonumber(text[3]) ~= nil ) then
				AntiSpam.Settings.Npc.Delay = CheckNumberFunc(text[3])
				ply:ChatPrint( "NPC spam delay is set to "..text[3].." seconds!" )
				return ''
			end
			SettingsSave()
		else
			ply:ChatPrint( "You do not have permission to do this!" )
		end
	end
end)

-- Anti-Spam Script Start --

local meta = FindMetaTable("Player")

function AntiSpam.Chat.ResetTimer( ply )
	ply:EnableChatting(true)
end

function AntiSpam.Chat.Chatting( ply, text )
	if AntiSpam.Settings.AntiSpamming then
		if !ply:CanChat() then
			ply:PrintMessage(HUD_PRINTCONSOLE, "Message \""..text.."\" was not sent.\n")
			ply:PrintMessage(HUD_PRINTTALK, "STOP SPAMMING THE SERVER!")
			return ""
		end
		ply:EnableChatting(false)
		timer.Simple(AntiSpam.Settings.Chat.Delay, function()
			AntiSpam.Chat.ResetTimer ( ply )
		end)
	end
end
// hook event when a player enters something into chat
hook.Add("PlayerSay", "AntiSpam.Chat.Chatting", AntiSpam.Chat.Chatting)

function AntiSpam.Prop.ResetTimer( ply )
	ply:EnablePropSpawning(true)
end

function AntiSpam.Prop.Spawning( ply, model, ent )
	if AntiSpam.Settings.AntiSpamming then
		if !ply:CanPropSpawn() then
			ply:PrintMessage( HUD_PRINTTALK, "STOP SPAMMING THE SERVER!" )
			return false
		end
		ply:EnablePropSpawning(false)
		timer.Simple(AntiSpam.Settings.Chat.Delay, function()
			AntiSpam.Prop.ResetTimer ( ply )
		end)
	end
end
// hook event when a player spawns a prop
hook.Add("PlayerSpawnProp", "AntiSpam.Prop.Spawning", AntiSpam.Prop.Spawning)

function AntiSpam.Sent.ResetTimer( ply )
	ply:EnableSentSpawning(true)
end

function AntiSpam.Sent.Spawning( ply, model, ent )
	if AntiSpam.Settings.AntiSpamming then
		if !ply:CanSentSpawn() then
			ply:PrintMessage( HUD_PRINTTALK, "STOP SPAMMING THE SERVER!" )
			return false
		end
		ply:EnableSentSpawning(false)
		timer.Simple(AntiSpam.Settings.Chat.Delay, function()
			AntiSpam.Sent.ResetTimer ( ply )
		end)
	end
end
// hook event when a player spawns a SENT
hook.Add("PlayerSpawnSENT", "AntiSpam.Sent.Spawning", AntiSpam.Sent.Spawning)

function AntiSpam.Effect.ResetTimer( ply )
	ply:EnableEffectSpawning(true)
end

function AntiSpam.Effect.Spawning( ply, model, ent )
	if AntiSpam.Settings.AntiSpamming then
		if !ply:CanEffectSpawn() then
			ply:PrintMessage( HUD_PRINTTALK, "STOP SPAMMING THE SERVER!" )
			return false
		end
		ply:EnableEffectSpawning(false)
		timer.Simple(AntiSpam.Settings.Chat.Delay, function()
			AntiSpam.Effect.ResetTimer ( ply )
		end)
	end
end
// hook event when a player spawns an effect
hook.Add("PlayerSpawnEffect", "AntiSpam.Effect.Spawning", AntiSpam.Effect.Spawning)

function AntiSpam.Ragdoll.ResetTimer( ply )
	ply:EnableRagdollSpawning(true)
end

function AntiSpam.Ragdoll.Spawning( ply, model, ent )
	if AntiSpam.Settings.AntiSpamming then
		if !ply:CanRagdollSpawn() then
			ply:PrintMessage( HUD_PRINTTALK, "STOP SPAMMING THE SERVER!" )
			return false
		end
		ply:EnableRagdollSpawning(false)
		timer.Simple(AntiSpam.Settings.Chat.Delay, function()
			AntiSpam.Ragdoll.ResetTimer ( ply )
		end)
	end
end
// hook event when a player spawns a ragdoll
hook.Add("PlayerSpawnRagdoll", "AntiSpam.Ragdoll.Spawning", AntiSpam.Ragdoll.Spawning)

function AntiSpam.Vehicle.ResetTimer( ply )
	ply:EnableVehicleSpawning(true)
end

function AntiSpam.Vehicle.Spawning( ply, model, ent )
	if AntiSpam.Settings.AntiSpamming then
		if !ply:CanVehicleSpawn() then
			ply:PrintMessage( HUD_PRINTTALK, "STOP SPAMMING THE SERVER!" )
			return false
		end
		ply:EnableVehicleSpawning(false)
		timer.Simple(AntiSpam.Settings.Chat.Delay, function()
			AntiSpam.Vehicle.ResetTimer ( ply )
		end)
	end
end
// hook event when a player spawns a vehicle
hook.Add("PlayerSpawnVehicle", "AntiSpam.Vehicle.Spawning", AntiSpam.Vehicle.Spawning)

function AntiSpam.Npc.ResetTimer( ply )
	ply:EnableNpcSpawning(true)
end

function AntiSpam.Npc.Spawning( ply, model, ent )
	if AntiSpam.Settings.AntiSpamming then
		if !ply:CanNpcSpawn() then
			ply:PrintMessage( HUD_PRINTTALK, "STOP SPAMMING THE SERVER!" )
			return false
		end
		ply:EnableNpcSpawning(false)
		timer.Simple(AntiSpam.Settings.Chat.Delay, function()
			AntiSpam.Npc.ResetTimer ( ply )
		end)
	end
end
// hook event when a player spawns a(n) Npc
hook.Add("PlayerSpawnNpc", "AntiSpam.Npc.Spawning", AntiSpam.Npc.Spawning)

-- Meta Tables --

AntiSpam.Chat.Players = {}

function meta:CanChat()
	if !AntiSpam.Settings.Chat.Enabled then
		return true
	elseif table.HasValue(AntiSpam.Chat.Players, self:SteamID()) then
		return false
	else
		return true
	end
end

AntiSpam.Prop.Players = {}

function meta:CanPropSpawn()
	if !AntiSpam.Settings.Prop.Enabled then
		return true
	elseif table.HasValue(AntiSpam.Prop.Players, self:SteamID()) then
		return false
	else
		return true
	end
end

AntiSpam.Sent.Players = {}

function meta:CanSentSpawn()
	if !AntiSpam.Settings.Sent.Enabled then
		return true
	elseif table.HasValue(AntiSpam.Sent.Players, self:SteamID()) then
		return false
	else
		return true
	end
end

AntiSpam.Ragdoll.Players = {}

function meta:CanRagdollSpawn()
	if !AntiSpam.Settings.Ragdoll.Enabled then
		return true
	elseif table.HasValue(AntiSpam.Ragdoll.Players, self:SteamID()) then
		return false
	else
		return true
	end
end

AntiSpam.Vehicle.Players = {}

function meta:CanVehicleSpawn()
	if !AntiSpam.Settings.Vehicle.Enabled then
		return true
	elseif table.HasValue(AntiSpam.Vehicle.Players, self:SteamID()) then
		return false
	else
		return true
	end
end

AntiSpam.Npc.Players = {}

function meta:CanNpcSpawn()
	if !AntiSpam.Settings.Npc.Enabled then
		return true
	elseif table.HasValue(AntiSpam.Npc.Players, self:SteamID()) then
		return false
	else
		return true
	end
end

AntiSpam.Effect.Players = {}

function meta:CanEffectSpawn()
	if !AntiSpam.Settings.Effect.Enabled then
		return true
	elseif table.HasValue(AntiSpam.Effect.Players, self:SteamID()) then
		return false
	else
		return true
	end
end

function meta:EnableChatting(bool)
	if bool then
		table.remove(AntiSpam.Chat.Players, table.ValueToKey(AntiSpam.Chat.Players,self:SteamID()))
	else
		table.insert(AntiSpam.Chat.Players, self:SteamID())
	end
end

function meta:EnablePropSpawning(bool)
	if bool then
		table.remove(AntiSpam.Prop.Players, table.ValueToKey(AntiSpam.Prop.Players,self:SteamID()))
	else
		table.insert(AntiSpam.Prop.Players, self:SteamID())
	end
end

function meta:EnableSentSpawning(bool)
	if bool then
		table.remove(AntiSpam.Sent.Players, table.ValueToKey(AntiSpam.Sent.Players,self:SteamID()))
	else
		table.insert(AntiSpam.Sent.Players, self:SteamID())
	end
end

function meta:EnableRagdollSpawning(bool)
	if bool then
		table.remove(AntiSpam.Ragdoll.Players, table.ValueToKey(AntiSpam.Ragdoll.Players,self:SteamID()))
	else
		table.insert(AntiSpam.Ragdoll.Players, self:SteamID())
	end
end

function meta:EnableVehicleSpawning(bool)
	if bool then
		table.remove(AntiSpam.Vehicle.Players, table.ValueToKey(AntiSpam.Vehicle.Players,self:SteamID()))
	else
		table.insert(AntiSpam.Vehicle.Players, self:SteamID())
	end
end

function meta:EnableNpcSpawning(bool)
	if bool then
		table.remove(AntiSpam.Npc.Players, table.ValueToKey(AntiSpam.Npc.Players,self:SteamID()))
	else
		table.insert(AntiSpam.Npc.Players, self:SteamID())
	end
end

function meta:EnableEffectSpawning(bool)
	if bool then
		table.remove(AntiSpam.Effect.Players, table.ValueToKey(AntiSpam.Effect.Players,self:SteamID()))
	else
		table.insert(AntiSpam.Effect.Players, self:SteamID())
	end
end

function OpenGUI( ply, text )
	text = string.lower( text )
	if ( text == "!ras" ) then
		if ply:IsUserGroup( "superadmin", "owner" ) then
			local Derma = vgui.Create( "DFrame" )
			Derma:Center()
			Derma:SetSize( 300, 600 )
			Derma:SetTitle( "Raindeer Anti-Spam" )
			Derma:SetVisible( true )
			Derma:SetDraggable( true )
			Derma:ShowCloseButton( true )
			Derma:MakePopup()

			local Collapsible = vgui.Create( "DCollapsibleCategory", Derma )
			Collapsible:SetPos( 25,50 )
			Collapsible:SetSize( 200, 50 ) -- Keep the second number at 50
			Collapsible:SetExpanded( 0 ) -- Expanded when popped up
			Collapsible:SetLabel( "Raindeer Anti-Spam" )
			 
			CategoryList = vgui.Create( "DPanelList" )
			CategoryList:SetAutoSize( true )
			CategoryList:SetSpacing( 5 )
			CategoryList:EnableHorizontal( false )
			CategoryList:EnableVerticalScrollbar( true )
			 
			Collapsible:SetContents( CategoryList ) -- Add our list above us as the contents of the collapsible category
			 
				local CategoryContentOne = vgui.Create( "DCheckBoxLabel" )
				CategoryContentOne:SetText( "God Mode" )
--				CategoryContentOne:SetValue( AntiSpam.Settings.AntiSpamming = true )
				function CategoryContentOne:OnChange( checked )
					AntiSpam.Settings.AntiSpamming = checked
				end
			CategoryList:AddItem( CategoryContentOne ) -- Add the above item to our list
		else
			ply:ChatPrint( "You do not have this permission!" )
		end
	end
end

/* -- GUI --	
local Derma = vgui.Create( "DFrame" )
Derma:Center()
Derma:SetSize( 300, 600 )
Derma:SetTitle( "Raindeer Anti-Spam" )
Derma:SetVisible( true )
Derma:SetDraggable( true )
Derma:ShowCloseButton( true )
Derma:MakePopup()

local Collapsible = vgui.Create( "DCollapsibleCategory", Derma )
Collapsible:SetPos( 25,50 )
Collapsible:SetSize( 200, 50 ) -- Keep the second number at 50
Collapsible:SetExpanded( 0 ) -- Expanded when popped up
Collapsible:SetLabel( "Raindeer Anti-Spam" )
 
CategoryList = vgui.Create( "DPanelList" )
CategoryList:SetAutoSize( true )
CategoryList:SetSpacing( 5 )
CategoryList:EnableHorizontal( false )
CategoryList:EnableVerticalScrollbar( true )
 
Collapsible:SetContents( CategoryList ) -- Add our list above us as the contents of the collapsible category
 
	local CategoryContentOne = vgui.Create( "DCheckBoxLabel" )
	CategoryContentOne:SetText( "God Mode" )
	CategoryContentOne:SetValue( AntiSpam.Settings.AntiSpamming = true	)
	function CategoryContentOne:OnChange( checked )
		AntiSpam.Settings.AntiSpamming = checked
	end
CategoryList:AddItem( CategoryContentOne ) -- Add the above item to our list
*/			
