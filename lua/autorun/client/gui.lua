include("ras_config.lua")

net.Receive( "AntiSpamOpenAdminGUI", function()
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
	CategoryContentOne:SetValue( AntiSpam.Settings.AntiSpamming )
	function CategoryContentOne:OnChange( checked )
		AntiSpam.Settings.AntiSpamming = checked
	end
	CategoryList:AddItem( CategoryContentOne ) -- Add the above item to our list
end)