local setmetatable = setmetatable
local print,ipairs  = print,ipairs

local awful     = require("awful")
local beautiful = require("beautiful")
local drop      = require("scratchdrop")
local pretty = require("pretty")
--local alttab       = require( "radical.impl.alttab"        )

local module = {}
module.globalkeys = {}
module.clientbuttons = {}
module.clientkeys = {}
-- common
module.modkey     = "Mod4"
module.altkey     = "Mod1"
module.terminal   = "urxvtc" or "xterm"
module.editor     = os.getenv("EDITOR") or "nano" or "vi"
module.editor_cmd = module.terminal .. " -e " .. module.editor

-- user defined
module.launcher =  function () return "dmenu_run  -m " .. mouse.screen - 1 .. "-i -b -nb '" .. beautiful.bg_normal .. "' -sb '" .. beautiful.bg_focus .. "'" end
--module.launcher = function() require("menubar").show(mouse.screen) end
module.browser    = "google-chrome-unstable"
module.browser2   = "firefox"
module.gui_editor = "geany"
module.graphics   = "gimp"
module.filemanager = "nemo --no-desktop"

local function init()
	-- {{{ Key bindings
	awful.key.ignore_modifiers =  { "Lock", "Mod2", "Mod5" }
	module.globalkeys = awful.util.table.join(
		-- Take a screenshot
		-- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
--TODO: copy it from cinnamon
		awful.key({ module.altkey }, "p", function() os.execute("screenshot") end),
--TODO: remove below test function
		awful.key({ module.modkey }, "g", function() 
			--[[
			local grabber = awful.keygrabber.run(function(mod, key, event)
				local mod1 = require("pretty.debug").tostringR(mod)
				--ISO_Left_Tab
				
				print(mod1, key, event)
		   end)
		   ---]]
		   local radical = require("radical")
		       local pref_menu = radical.box()
				--pref_menu:add_item{text="Exclusive"}
				--pref_menu:add_widget(radical.widgets.separator())
				--pref_menu:add_item{text="12 clients"}
				--pref_menu.margins.left = 100
				--pref_menu.margins.right = 100
				--pref_menu.margins.top = 100
				--pref_menu.margins.bottom = 100
				--local item = pref_menu:add_item{text="All Screens"}
				--item.margins.left = 30
				local typeMenu = radical.widgets.piechart()
				data = {}
				data["a"] = 1
				data["b"] = 2
				data["c"] = 3
				typeMenu:set_data(data)
				pref_menu:add_widget(typeMenu,{height = 100 , width = 100})
				pref_menu.visible = true
			--print(require("pretty.debug").status("test",2))
		end),
		-- Tag browsing
		awful.key({ module.modkey }, "Left",   awful.tag.viewprev       ),
		awful.key({ module.modkey }, "Right",  awful.tag.viewnext       ),
		
	--TODO: functionality to do multiple history changes
		awful.key({ module.modkey }, "Caps_Lock", function() pretty.tag.sync_toggle() end ),
		-- Non-empty tag browsing
	--    awful.key({ module.altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
	--    awful.key({ module.altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

		-- Default client focus
		--awful.key({ module.altkey }, "k",
			--function ()
				--awful.client.focus.byidx( 1)
				--if client.focus then client.focus:raise() end
			--end),
		--awful.key({ module.altkey }, "j",
			--function ()
				--awful.client.focus.byidx(-1)
				--if client.focus then client.focus:raise() end
			--end),

		-- By direction client focus
		awful.key({ module.modkey }, "j",
			function()
				awful.client.focus.bydirection("down")
				if client.focus then client.focus:raise() end
			end),
		awful.key({ module.modkey }, "k",
			function()
				awful.client.focus.bydirection("up")
				if client.focus then client.focus:raise() end
			end),
		awful.key({ module.modkey }, "h",
			function()
				awful.client.focus.bydirection("left")
				if client.focus then client.focus:raise() end
			end),
		awful.key({ module.modkey }, "l",
			function()
				awful.client.focus.bydirection("right")
				if client.focus then client.focus:raise() end
			end),

		-- Show Menu
		awful.key({ module.modkey }, "w",
			function ()
				local menu = require("pretty.menus.application").build_menu()
				require("pretty.menus").popup(menu) 
			end),
	--TODO: mywibox keys
		-- Show/Hide Wibox
	--    awful.key({ module.modkey }, "b", function ()
	--        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
	--    end),

		---- On the fly useless gaps change
		--awful.key({ module.altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end),
		--awful.key({ module.altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end),

	--TODO: change shortcat for rename
		-- Rename tag
	--    awful.key({ module.altkey, "Shift"   }, "r", function () lain.util.rename_tag(mypromptbox) end),

		-- Layout manipulation
		awful.key({ module.modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
		awful.key({ module.modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
		awful.key({ module.modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
		awful.key({ module.modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
		awful.key({ module.modkey,           }, "u", awful.client.urgent.jumpto),
		awful.key({ module.altkey,           }, "Tab", function ()
		local menu = require("pretty.menus.client").switch.next(1)
		menu:add_key_hook({}, "Alt_L"      , "release", function ()
			menu:hide()
			end)
		menu:add_key_hook({}, "Tab"      , "press", function () 
		--ISO_Left_Tab
			menu.visible = true
			--require("pretty.menus").popup(menu) 
		end)
		menu.visible = true
		end),
		awful.key({ module.altkey,           }, "Caps_Lock", function ()
		local menu = require("pretty.menus").layout(1)
		menu:add_key_hook({}, "Alt_L"      , "release", function ()
			menu:hide()
			end)
		menu:add_key_hook({}, "Caps_Lock"      , "press", function () 
			menu.visible = true
			--require("pretty.menus").popup(menu)
		end)
		menu.visible = true
		end),
		--TODO: functionality to do multiple history changes
		awful.key({ module.modkey }, "Tab", function ()
		local menu = require("pretty.menus").tag.switch.next(1)
		---[[
		menu:add_key_hook({}, module.modkey      , "release", function ()
			menu:hide()
			end)
		menu:add_key_hook({}, "Tab"      , "press", function () 
			menu.visible = true
			--require("pretty.menus").popup(menu)
		end)
		---]]
		menu.visible = true
		end),
		---[[
		awful.key({ module.altkey }, "Shift_L", function ()
		local menu = require("pretty.menus").language(1)
		menu:add_key_hook({}, module.altkey      , "release", function ()
			menu:hide()
			end)
		menu:add_key_hook({}, "Shift_L"      , "press", function () 
			menu.visible = true
			--require("pretty.menus").popup(menu)
		end)
		menu.visible = true
		end),
		---]]
--		awful.key({ module.altkey }, "Tab", function () alttab.altTab({auto_release=true}) end),
	--TODO: change shortcat for rename
	--    awful.key({ module.altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
	--    awful.key({ module.altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
		awful.key({ module.modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
		awful.key({ module.modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
		awful.key({ module.modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
		awful.key({ module.modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
	--    awful.key({ module.modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
		awful.key({ module.modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
		awful.key({ module.modkey, "Control" }, "n",      awful.client.restore),
		awful.key({ module.modkey,           }, "q", function () pretty.layout.floating_toggle() end ),
		awful.key({ module.modkey,           }, "space", function () pretty.tag.max_toggle("toggle") end),

		-- Standard program
		awful.key({ module.modkey,           }, "Return", function () awful.util.spawn(module.terminal) end),
		awful.key({ module.modkey, "Control" }, "r",      awesome.restart),
		awful.key({ module.altkey, "Control"   }, "BackSpace", awesome.quit),

		-- Dropdown module.terminal
		awful.key({ module.modkey,	          }, "z",      function () drop(module.terminal) end),

		---- Widgets popups
		--awful.key({ module.altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
		--awful.key({ module.altkey,           }, "h",      function () fshomeupd.show(7) end),
		--awful.key({ module.altkey,           }, "w",      function () yawn.show(7) end),

	--TODO: change shortcat for rename
		---- ALSA volume control
		--awful.key({ module.altkey }, "Up",
			--function ()
				--os.execute(string.format("amixer -c %s set %s %s+", volume.card, volume.channel, volume.step))
				--volume.update()
			--end),
		--awful.key({ module.altkey }, "Down",
			--function ()
				--os.execute(string.format("amixer -c %s set %s %s-", volume.card, volume.channel, volume.step))
				--volume.update()
			--end),
		--awful.key({ module.altkey }, "m",
			--function ()
				--os.execute(string.format("amixer -c %s set %s toggle", volume.card, volume.channel))
				----os.execute(string.format("amixer set %s toggle", volume.channel))
				--volume.update()
			--end),
		--awful.key({ module.altkey, "Control" }, "m",
			--function ()
				--os.execute(string.format("amixer -c %s set %s 100", volume.card, volume.channel))
				--volume.update()
			--end),

		---- MPD control
		--awful.key({ module.altkey, "Control" }, "Up",
			--function ()
				--awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
				--mpdwidget.update()
			--end),
		--awful.key({ module.altkey, "Control" }, "Down",
			--function ()
				--awful.util.spawn_with_shell("mpc stop || ncmpc stop || pms stop")
				--mpdwidget.update()
			--end),
		--awful.key({ module.altkey, "Control" }, "Left",
			--function ()
				--awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
				--mpdwidget.update()
			--end),
		--awful.key({ module.altkey, "Control" }, "Right",
			--function ()
				--awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
				--mpdwidget.update()
			--end),

		-- Copy to clipboard
		awful.key({ module.modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

		---- User programs
		--awful.key({ module.modkey }, "q", function () awful.util.spawn(module.browser) end),
		awful.key({ module.modkey }, "Escape", function () awful.util.spawn(module.launcher()) end),
		awful.key({ module.modkey, "Shift" }, "Escape", function () awful.util.spawn("qmenu_hud") end),
		--awful.key({ module.modkey }, "i", function () awful.util.spawn(module.browser2) end),
		--awful.key({ module.modkey }, "s", function () awful.util.spawn(module.gui_editor) end),
		--awful.key({ module.modkey }, "g", function () awful.util.spawn(module.graphics) end),
		awful.key({ module.modkey }, "e", function () awful.util.spawn( module.filemanager) end),

		-- Prompt
--TODO: fix
--[[		awful.key({ module.modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
		awful.key({ module.modkey }, "x",
				  function ()
					  awful.prompt.run({ prompt = "Run Lua code: " },
					  mypromptbox[mouse.screen].widget,
					  awful.util.eval, nil,
					  awful.util.getdir("cache") .. "/history_eval")
				  end),
---]]
		awful.key({ module.modkey,           }, "`", function () pretty.tag.viewall_toggle() end),

		awful.key({ module.modkey, "Shift" }, "o", function () pretty.screen.move_all_clients() end),
		awful.key({ module.modkey, "Shift" }, "`", function () pretty.tag.viewall_screens_toggle() end),
		awful.key({ module.modkey, }, "[",  function () pretty.screen.toggle(-1) end),
		awful.key({ module.modkey, }, "]",  function () pretty.screen.toggle(1) end)
	)

	module.clientkeys = awful.util.table.join(
	--    awful.key({ module.altkey, "Shift"   }, "m",      lain.util.magnify_client                         ),
		awful.key({ module.modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
		awful.key({ module.modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
		awful.key({ module.altkey,           }, "F4",      function (c) c:kill()                         end),
		awful.key({ module.modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
		awful.key({ module.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
		awful.key({ module.modkey,           }, "o",      awful.client.movetoscreen                        ),
		awful.key({ module.modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
		awful.key({ module.modkey,           }, "n",
			function (c)
				-- The client currently has the input focus, so it cannot be
				-- minimized, since minimized clients can't have the focus.
				c.minimized = true
			end),
		awful.key({ module.modkey,           }, "m", function (c) pretty.client.maximize(c, "toggle") end)
	)

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it works on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, 9 do
		module.globalkeys = awful.util.table.join(module.globalkeys,
			-- View tag only.
			awful.key({ module.modkey }, "#" .. i + 9,
					  function ()
							local screen = mouse.screen
							local tag = awful.tag.gettags(screen)[i]
							if tag then
							   awful.tag.viewonly(tag)
							end
					  end),
			-- Toggle tag.
			awful.key({ module.modkey, "Control" }, "#" .. i + 9,
					  function ()
						  local screen = mouse.screen
						  local tag = awful.tag.gettags(screen)[i]
						  if tag then
							 awful.tag.viewtoggle(tag)
						  end
					  end),
			-- Move client to tag.
			awful.key({ module.modkey, "Shift" }, "#" .. i + 9,
					  function ()
						  if client.focus then
							  local tag = awful.tag.gettags(client.focus.screen)[i]
							  if tag then
								  awful.client.movetotag(tag)
							  end
						 end
					  end),
			-- Toggle tag.
			awful.key({ module.modkey, "Control", "Shift" }, "#" .. i + 9,
					  function ()
						  if client.focus then
							  local tag = awful.tag.gettags(client.focus.screen)[i]
							  if tag then
								  awful.client.toggletag(tag)
							  end
						  end
					  end))
	end

	module.clientbuttons = awful.util.table.join(
		awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
		awful.button({ module.modkey }, 1, awful.mouse.client.move),
		awful.button({ module.modkey }, 3, awful.mouse.client.resize))

	-- }}}
end
init()
return setmetatable(module, { __call = function(_, ...) return new(...) end })
