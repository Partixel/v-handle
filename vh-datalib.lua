VH_DataLib = { }

VH_DataLib.DataLocation = "vh"
-- The directory the file is located in

file.CreateDir( VH_DataLib.DataLocation ) -- Make sure the directories exist

Registry = debug.getregistry( )

VH_DataLib.DataTable = { }

if SERVER then
	
	util.AddNetworkString( "VH_DataLib-UpdateData" )
	
	util.AddNetworkString( "VH_DataLib-FinishInitial" )
	
	hook.Add( "PlayerAuthed", "VH-DataLib-Initial", function( Plr )
		
		for a, b in pairs( VH_DataLib.DataTable ) do
			
			if type( b ) == "table" then
				
				for c, d in pairs( b ) do
					
					net.Start( "VH_DataLib-UpdateData" )
						
						net.WriteTable( { a } )
						
						net.WriteType( c )
						
						net.WriteString( von.serialize( { d } ) )
						
					net.Send( Plr )
					
				end
				
			else
				
				net.Start( "VH_DataLib-UpdateData" )
					
					net.WriteTable( { } )
					
					net.WriteType( a )
					
					net.WriteString( von.serialize( { b } ) )
					
				net.Send( Plr )
				
			end
			
		end
		
		net.Start( "VH_DataLib-FinishInitial" )
		
		net.Send( Plr )
		
	end )
	
	function VH_DataLib.toString( )
		
		return von.serialize( VH_DataLib.DataTable )
		
	end

	function VH_DataLib.fromString( String )
		
		VH_DataLib.DataTable = von.deserialize( String )
		
	end
	
	function VH_DataLib.loadData( )
		
		local Data = file.Read( VH_DataLib.DataLocation .. "/vh-datalib.txt" )
		
		if Data and Data != "" then
		
			VH_DataLib.fromString( Data )
			
		end
		
	end
	
	function VH_DataLib.saveData( )
		
		file.Write( VH_DataLib.DataLocation .. "/vh-datalib.txt", VH_DataLib.toString( ) )
		
	end
	
	function VH_DataLib.replicateData( Path, Key, Plr )
		
		Path = type( Path ) == "table" and Path or { Path }
		
		local Data = VH_DataLib.getData( Path, Key )
		
		if type( Data ) == "table" then
			
			table.insert( Path, Key )
			
			for a, b in pairs( Data ) do
				
				net.Start( "VH_DataLib-UpdateData" )
					
					net.WriteTable( Path )
					
					net.WriteType( a )
					
					net.WriteString( von.serialize( { b } ) )
					
				if Plr then
					
					net.SendOmit( Plr )
					
				else
					
					net.Broadcast( )
					
				end
				
			end
			
		else
			
			net.Start( "VH_DataLib-UpdateData" )
				
				net.WriteTable( Path )
				
				net.WriteType( Key )
				
				net.WriteString( von.serialize( { Data } ) )
				
			if Plr then
				
				net.SendOmit( Plr )
				
			else
				
				net.Broadcast( )
				
			end
			
		end
		
	end
	
	VH_DataLib.loadData( )
	
	VH_DataLib.FinishInitial = true
	
	hook.Run( "VH_DataLib-FinishInitial" )
	
else
	
	function VH_DataLib.saveData( )
		
	end
	
	net.Receive( "VH_DataLib-FinishInitial", function ( Len, Plr )
		
		VH_DataLib.FinishInitial = true
		
		hook.Run( "VH_DataLib-FinishInitial" )
		
	end)
	
	net.Receive("VH_DataLib-UpdateData", function( Len, Plr )
		
		local Path = net.ReadTable( )
		
		local Key = net.ReadType( net.ReadUInt( 8 ) )
		
		Value = von.deserialize( net.ReadString( ) )[ 1 ]
		
		VH_DataLib.setData( Path, Key, Value )
		
		hook.Run( "VH_DataLib-UpdateData", Path, Key, Value )
		
	end )
	
end

function VH_DataLib.PlayerFromSID( String )
	
	for a, b in ipairs( player.GetHumans( ) ) do
		
		if b:SteamID( ) == String then
			
			return b
			
		end
		
	end
	
end

function TInsert( Table, Key, Value )

	local NextNum = #Table + 1
	
	local Moved = { }
	
	local InsertPos = nil
	
	if Value == nil then
		
		InsertPos = NextNum
		
		table.insert( Moved, InsertPos )
		
	else
		
		InsertPos = Key or NextNum
		
		for i = NextNum, InsertPos, -1 do
			
			table.insert( Moved, i )
			
			Table[ i ] = Table[ i - 1 ]
			
		end
		
	end
	
	Table[ InsertPos ] = Value or Key
	
	return Moved
	
end

function TRemove( Table, Key )
	
	local NextNum = #Table
	
	local Pos = Key or NextNum
	
	if not ( 1 <= Pos and Pos <= NextNum ) then return end
	
	local Moved = { }
	
	for a = Pos, NextNum do
		
		table.insert( Moved, a )
		
		Table[ a ] = Table[ a + 1 ] or nil
		
	end
	
	return Moved
	
end

function VH_DataLib.insertDataNoSave( Path, Key, Value )
	
	Path = type( Path ) == "table" and Path or { Path }
	
	return TInsert( VH_DataLib.getRealData( Path ), Key, Value )
	
end

function VH_DataLib.insertData( Path, Key, Value )
	
	local Args = VH_DataLib.insertDataNoSave( Path, Key, Value )
	
	VH_DataLib.saveData( )
	
	return Args
	
end

function VH_DataLib.removeAtDataNoSave( Path, Key )
	
	Path = type( Path ) == "table" and Path or { Path }
	
	return TRemove( VH_DataLib.getRealData( Path ), Key )
	
end

function VH_DataLib.removeData( Path, Key )
	
	local Args = VH_DataLib.removeDataNoSave( Path, Key )
	
	VH_DataLib.saveData( )
	
	return Args
	
end

function VH_DataLib.setDataNoSave( Path, Key, Value )
	
	Path = type( Path ) == "table" and Path or { Path }
	VH_DataLib.getRealData( Path )[ Key ] = Value
	
end

function VH_DataLib.setData( Path, Key, Value )
	
	VH_DataLib.setDataNoSave( Path, Key, Value )
	
	VH_DataLib.saveData( )
	
end

function VH_DataLib.getRealData( Path, Key )
	
	Path = type( Path ) == "table" and Path or { Path }
	
	local LastData = VH_DataLib.DataTable
	
	for a, b in ipairs( Path ) do
		
		if type( LastData ) ~= "table" then break end
		
		if LastData[ b ] == nil then LastData[ b ] = { } end
		
		LastData = LastData[ b ]
		
	end
	
	if Key then
		
		LastData = LastData[ Key ]
		
	end
	
	return LastData
	
end

function VH_DataLib.getData( Path, Key )
	
	local LastData = VH_DataLib.getRealData( Path, Key )
	
	if type( LastData ) == "table" then LastData = table.Copy( LastData ) end
	
	return LastData
	
end

function Registry.Player:setPlayerData( Key, Value )
	
	VH_DataLib.setData( self:SteamID( ), Key, Value )
	
end

function Registry.Player:getPlayerData( Key, Value )
	
	return VH_DataLib.getData( self:SteamID( ), Key, Value )
	
end