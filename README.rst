===
luz
===
--------------------------------------------
``Luce`` remote component basic demonstrator
--------------------------------------------

Purpose
=======

    A quick demonstrator on ``Luce`` abitily to create and manipulate
    applications dynamically.

    This is just a tiny overview of one of ``gadokai``'s features, a smart-data
    oriented architecture.

Requirements
============

* `lua 5.1 <http://www.lua.org/download.html>`_ / `luajit 2.0.X <http://luajit.org/download.html>`_ (untested with 5.2)

* `Luce <https://github.com/peersuasive/luce>`_

* `ømq <http://zeromq.org/intro:get-the-software>`_

* `lua-zmq <https://github.com/Neopallium/lua-zmq.git>`_


Usage
=====

    Have ``Luce`` at ``../luce`` or in Lua cpath, then

    .. code:: sh
    
        ./server_test.lua &
        ./client.lua
        ./client.lua
        ./client2.lua

.. vim:syntax=rst:filetype=rst:spelllang=en
