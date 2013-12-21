#!/usr/bin/env luajit

--[[----------------------------------------------------------------------------

server_test.lua

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
assert( s:bind("tcp://127.0.0.1:20051") )

package.cpath = "../luce/Builds/Linux/build/?.so;"..package.cpath

local luce = require"luce"

components = { 
    luce = luce,
    print = print,
    all = {}
}

local mainWindow = luce:JUCEApplication():new()

components.mainWindow = mainWindow

local dw = luce:DocumentWindow():new("DocumentWindow")

components.dw = dw

local mc = luce:MainComponent():new()

components.mc = mc

local button = luce:TextButton():new("TheButton")
button:setButtonText( "a button")

components.button = button

-- example of a possible implementation of a remote button
components.remoteButton = {
    this = button,
    setButtonText = function(text)
        this:setButtonText(text)
    end,
    methods = {
        "setButtonText"
    }
}

button:buttonClicked(function(...)
    print("button clicked !!")
end)

mainWindow:initialise(function(...)
    mc:addAndMakeVisible( button )
    button:setBounds{ 200, 20, 200, 200 }
    
    mc.visible = true;

    mc:setBounds{ 100, 100, 700, 550 }
    dw:setContentOwned( mc, true );

    dw:setSize{ 800,600 }
    dw:setVisible(true)

    return dw
end)

local keep_going = true
mainWindow:systemRequestedQuit(function(...)
    keep_going = false
    mainWindow:shutdown()
    mainWindow:quit()
end)

local cur, min, max = 20, 10, 300

function createComponent(c)
    -- printf("creating something (%s)...", c)
    -- create...
    -- components[ c.name ] = ...
end

components.createComponent = createComponent

nb = 0
local p = zmq.poller(1)
p:add( s, zmq.POLLIN, function(socket)
    local chunk = socket:recv()
    if ( components.all[chunk] ) then
        local method = socket:recv()
        local args = socket:recv()
        local m = components.all[chunk][method]
        if ( m ) then
            local s = components.all[chunk]
            m(s, args)
        else
            print("*** method "..method.." not found")
        end
        return
    end
    local s, err = loadstring(chunk)
    setfenv( s, components )
    s()
end)

luce:start_manual( mainWindow, function(...)
    p:poll(1)
    return keep_going
end )
luce:shutdown()

p:remove(s)
s:setopt(zmq.LINGER, 0)
s:close()
c:term()

print("END")
