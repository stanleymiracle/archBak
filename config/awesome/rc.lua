-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "Sublime_text"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey, alt
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
Alt = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
  names  = { " eins ", " zwei ", " drei " },
  layout = { layouts[1], layouts[3], layouts[2]
}}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

local string = {format = string.format}
local os = {date = os.date, time = os.time}


local calendar = nil
local offset = 0
local cal = {}

local tooltip
local state = {}
local current_day_format = '<span color="#ff0000">%s</span>'

function displayMonth(month,year,weekStart)
  local t,wkSt=os.time{year=year, month=month+1, day=0},weekStart or 1
  local d=os.date("*t",t)
  local mthDays,stDay=d.day,(d.wday-d.day-wkSt+1)%7

  local lines = "    "

  for x=0,6 do
    lines = lines .. os.date("%a ",os.time{year=2006,month=1,day=x+wkSt})
  end

  lines = lines .. "\n" .. os.date(" %V",os.time{year=year,month=month,day=1})

  local writeLine = 1
  while writeLine < (stDay + 1) do
    lines = lines .. "    "
    writeLine = writeLine + 1
  end

        for d=1,mthDays do
                local x = d
                local t = os.time{year=year,month=month,day=d}
                if writeLine == 8 then
                        writeLine = 1
                        lines = lines .. "\n" .. os.date(" %V",t)
                end
                if os.date("%Y-%m-%d") == os.date("%Y-%m-%d", t) then
                        x = string.format(current_day_format, d)
                end
                if d < 10 then
                        x = " " .. x
                end
                lines = lines .. "  " .. x
                writeLine = writeLine + 1
        end
        if stDay + mthDays < 36 then
                lines = lines .. "\n"
        end
        if stDay + mthDays < 29 then
                lines = lines .. "\n"
        end
        local header = os.date("%B %Y\n",os.time{year=year,month=month,day=1})

  return header .. "\n" .. lines
end


function cal.register(mywidget, custom_current_day_format)
  if custom_current_day_format then current_day_format = custom_current_day_format end

  if not tooltip then
    tooltip = awful.tooltip({})
                function tooltip:update()
                        local month, year = os.date('%m'), os.date('%Y')
                        state = {month, year}
                        tooltip:set_markup(string.format('<span font_desc="monospace">%s</span>', displayMonth(month, year, 2)))
                end
                tooltip:update()
  end
  tooltip:add_to_object(mywidget)

  mywidget:connect_signal("mouse::enter",tooltip.update)

  mywidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function()
    switchMonth(1)
  end),
  awful.button({ }, 3, function()
    switchMonth(-1)
  end),
  awful.button({ }, 4, function()
    switchMonth(1)
  end),
  awful.button({ }, 5, function()
    switchMonth(-1)
  end),
  awful.button({ 'Shift' }, 1, function()
    switchMonth(12)
  end),
  awful.button({ 'Shift' }, 3, function()
    switchMonth(-12)
  end),
  awful.button({ 'Shift' }, 4, function()
    switchMonth(12)
  end),
  awful.button({ 'Shift' }, 5, function()
    switchMonth(-12)
  end)))
end

function switchMonth(delta)
  state[1] = state[1] + (delta or 1)
  local text = string.format('<span font_desc="monospace">%s</span>', displayMonth(state[1], state[2], 2))
  tooltip:set_markup(text)
end

cal.register(mytextclock)

-- Create a battery widget
batterywidget = wibox.widget.textbox()    
batterywidget:set_text(" | Battery | ")    
batterywidgettimer = timer({ timeout = 5 })    
batterywidgettimer:connect_signal("timeout",    
  function()    
    fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))    
    batterywidget:set_text(" |" .. fh:read("*l") .. " | ")    
    fh:close()    
  end    
)    
batterywidgettimer:start()

-- Create battery notification
battery_timer = timer({timeout = 2})
battery_timer:connect_signal("timeout", function()  batteryNotice("BAT1") end)
battery_timer:start()
function batteryNotice(adapter)
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
    if fcur and fcap and fsta then
        local cur = fcur:read()
        local cap = fcap:read()
        local sta = fsta:read()
        local battery = math.floor(cur * 100 / cap)
        if sta:match("Discharging") and tonumber(battery) <= 10 then
               naughty.notify({ preset = naughty.config.presets.critical,
                                title = "Battery Low!",
                                text = " ".. battery .. "% left!",
                                fg="#ff0000",
                                bg="#deb887",
                                timeout = 1, })
    end
    else
    end
    fcur:close()
    fcap:close()
    fsta:close()
end

-- Create a volume widget
volume = wibox.widget.textbox()
vicious.register(volume, vicious.widgets.volume,
'<span> |♩$1</span> ', 0.1, "Master")
-- Create a volume notification


-- Create a network widget
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, function(widget, args)
    local interface = ""
    if args["{wlp0s20u2 carrier}"] == 1 then
        interface = "wlp0s20u2"
    elseif args["{enp2s0 carrier}"] == 1 then
        interface = "enp2s0"
    elseif args["{wlp1s0 carrier}"] == 1 then
        interface = "wlp1s0"
    else
        return "timeout"
    end
    return '<span>'..args["{"..interface.." down_kb}"]..'kbps'..'</span>' end, 1)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(netwidget)
    right_layout:add(volume)
    right_layout:add(batterywidget)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings


globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

	-- {{ Opens firefox }} --
	awful.key({ modkey,           }, "v", function() awful.util.spawn("firefox") end),

	-- {{ Opens google-chrome-stable -incognito }} --
	awful.key({ modkey,           }, "c", function() awful.util.spawn("google-chrome-unstable -incognito") end),

	-- {{ Opens thunar }} --
	awful.key({ modkey,           }, "z", function() awful.util.spawn("thunar") end),

	-- {{ Opens sublime_text }} --
	awful.key({ modkey,           }, "s", function() awful.util.spawn("subl") end),

  -- {{ Opens texmacs }} --
  awful.key({ modkey,           }, "t", function() awful.util.spawn("texmacs") end),

  -- {{ Opens emacs }} --
  awful.key({ modkey,           }, "e", function() awful.util.spawn("emacs") end),

  -- {{ Opens slock }} --
  awful.key({ modkey,           }, "l", function() awful.util.spawn("slock") end),

  -- {{ Opens xpdf }} --
  awful.key({ modkey,           }, "g", function() awful.util.spawn("xpdf") end),

  -- {{ Opens DrRacket }} --
  awful.key({ modkey,           }, "d", function() awful.util.spawn("drracket") end),


  -- {{ Start capturing screen }} --
  awful.key({ Alt,           }, "c", function() awful.util.spawn("import -window linuxfish capture.png") end),
    
	-- {{ Volume Control }} --
	awful.key({     }, "XF86AudioRaiseVolume", function() awful.util.spawn("sh /home/linuxfish/.config/awesome/sound.sh up", false) end),
	awful.key({     }, "XF86AudioLowerVolume", function() awful.util.spawn("sh /home/linuxfish/.config/awesome/sound.sh down", false) end),
	awful.key({     }, "XF86AudioMute", function() awful.util.spawn("sh /home/linuxfish/.config/awesome/sound.sh mute", false) end),
	
	-- {{ Backlight Control }} --
	awful.key({     }, "XF86MonBrightnessUp",   function () awful.util.spawn("xbacklight -inc 15") end),
  awful.key({     }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 15") end),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    
    -- Tag switching
    awful.key({ Alt,              }, "Tab", awful.tag.viewnext),
    awful.key({ Alt,    "Shift"   }, "Tab", awful.tag.viewprev),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Screen switching
    awful.key({ modkey, "Control"   }, "Left", 
        function()
            for i = 1, screen.count() do
                awful.tag.viewprev(i)
            end
    end ),

    awful.key({ modkey, "Control"   }, "Right", 
        function()
            for i = 1, screen.count() do
                awful.tag.viewnext(i)
            end
    end ),
    
    -- Float manipulation
	  awful.key({ modkey,  Alt      }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Up",    function () awful.client.moveresize(  0,   0,   0, -20) end),
    awful.key({ modkey,	 Alt      }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Down",  function () awful.client.moveresize(  0,   0,   0,  20) end),
    awful.key({ modkey,  Alt      }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.moveresize(  0,   0,  20,   0) end),
    awful.key({ modkey,  Alt      }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Left",  function () awful.client.moveresize(  0,   0, -20,   0) end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- Set Xterm as floating with a fixed position
 	  { rule = { class = "XTerm" }, 
 	    properties = { floating = true }, },---callback = function(c) c:geometry({x=0, y=19}) end},
 	  -- Set MPlayer as floating
    { rule = { class = "MPlayer" },
      properties = { floating = true, tag = tags[1][3], switchtotag = true } },
    -- Set MPv as floating
    { rule = { class = "Mpv" },
      properties = { floating = true, tag = tags[1][3], switchtotag = true } },
    -- Set THunar as floating
    { rule = { class = "Thunar" },
      properties = { floating = true } },
    -- Set TRansmission-qt as floating
    { rule = { class = "Transmission-qt" },
      properties = { floating = true } },
    -- Set EMacs as floating
    { rule = { class = "Emacs" },
      properties = { floating = true } },
    -- Set FIrefox to tags number 2 of screen 1 and switch to the tag.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2], switchtotag = true } },
    -- Set google-chrome-stable to tags number 2 of screen 1 and switch to the tag.
    { rule = { class = "Google-chrome-unstable" },
      properties = { tag = tags[1][2], switchtotag = true } },
    -- Set SUblime_text to tags number 3 of screen 1 and switch to the tag.
    { rule = { class = "Sublime" },
      properties = { tag = tags[1][3], switchtotag = true } },
    -- Set TExmacs to tags number 3 of screen 1 and switch to the tag.
    --{ rule = { class = "TExmacs" },
    --  properties = { floating = true, tag = tags[1][3], switchtotag = true } },
    
    
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
