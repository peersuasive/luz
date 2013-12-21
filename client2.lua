#!/usr/bin/env luajit

--[[----------------------------------------------------------------------------

client2.lua

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

s:send( "button2" )
s:send( "setButtonText" )
s:send( "update again" )

s:close()
c:term()
