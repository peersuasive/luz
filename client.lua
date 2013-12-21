#!/usr/bin/env luajit

--[[----------------------------------------------------------------------------

client.lua

    @author Christophe Berbizier (cberbizier@peersuasive.com)
    @license GPLv3
    @copyright 


(c) 2013, Peersuasive Technologies

------------------------------------------------------------------------------]]

--[[ REQUIREMENTS ]]------------------------------------------------------------

local zmq     = require "zmq"
require       "zmq.poller"

local c = zmq.init(1)
local s = c:socket(zmq.PAIR)
assert( s:connect("tcp://127.0.0.1:20051") )

local r = function(...)
    local args = {...}
    -- a possible alternative way of creating a component (unimplemented)
    --[[
    local button = {
        class = "TextButton",
        name  = "theNewTextButton",
        setName = "theNewTextButton",
        setButtonText = "The New Text Button",
        setBounds = { 20, 40, 200, 200 }
    }
    createComponent( button )
    --]]

    local b = all["button2"]
    if not b then
        local button2 = luce:TextButton():new()
        button2:setButtonText( "Button 2!")
        button2:setName("button2")
        button2:setBounds{ 10, 200, 150, 150 }
        all["button2"] = button2
        button2:buttonClicked(function(...)
            print("remote button clicked !!")
        end)

        mc:addAndMakeVisible( button2 )
    else
        b:setButtonText( args.newText or "updated !")
        b:buttonClicked(function(...)
            print("new remote button callback")
        end)
    end


    -- local b = mc:getChildComponent( "button2" )
    -- if ( b ) then
    --     b:setName("updated!")
    -- else
    --    b = luce:TextButton():new("newButton")
    --    ...
end

s:send( string.dump( r ) )

s:close()
c:term()
