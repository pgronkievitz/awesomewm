-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal(
    "request::display_error",
    function(message, startup)
        naughty.notification {
            urgency = "critical",
            title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
            message = message
        }
    end
)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/pg/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "emacsclient -c"
editor_cmd = editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    {"manual", terminal .. " -e man awesome"},
    {"edit config", editor_cmd .. " " .. awesome.conffile},
    {"restart", awesome.restart},
    {
        "quit",
        function()
            awesome.quit()
        end
    }
}

mymainmenu =
    awful.menu(
    {
        items = {
            {"awesome", myawesomemenu, beautiful.awesome_icon},
            {"open terminal", terminal}
        }
    }
)

mylauncher =
    awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = mymainmenu
    }
)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal(
    "request::default_layouts",
    function()
        awful.layout.append_default_layouts(
            {
                awful.layout.suit.floating,
                awful.layout.suit.tile,
                awful.layout.suit.tile.left,
                -- awful.layout.suit.tile.bottom,
                awful.layout.suit.tile.top,
                -- awful.layout.suit.fair,
                -- awful.layout.suit.fair.horizontal,
                -- awful.layout.suit.spiral,
                awful.layout.suit.spiral.dwindle,
                awful.layout.suit.max,
                awful.layout.suit.max.fullscreen,
                awful.layout.suit.magnifier
                -- awful.layout.suit.corner.nw
            }
        )
    end
)
-- }}}

-- {{{ Wallpaper
screen.connect_signal( -- TODO: fix wallpaper
    "request::wallpaper",
    function(s)
        awful.wallpaper {
            screen = s,
            bg = "#ffffff",
            widget = {
                {
                    image = beautiful.wallpaper,
                    resize = true,
                    downscale = true,
                    widget = wibox.widget.imagebox
                },
                valign = "center",
                halign = "center",
                tiled = false,
                widget = wibox.container.tile
            }
        }
    end
)
-- }}}

-- {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget.textclock("%Y-%m-%d (%a) %H:%M")
local cw =
    calendar_widget(
    {
        placement = "top_right",
        start_sunday = false
    }
)
mytextclock:connect_signal(
    "button::press",
    function(_, _, _, button)
        if button == 1 then
            cw.toggle()
        end
    end
)

my_systray = wibox.widget.systray()
my_systray:set_base_size(24)
beautiful.systray_icon_spacing = 2

screen.connect_signal(
    "request::desktop_decoration",
    function(s)
        -- Each screen has its own tag table.
        local l = awful.layout.suit
        local names = {"📮", "🌍", "📝", "🦁", "💻", "❓", "📎", "🐕", "👷🏻"}
        local layouts = {l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.max}
        awful.tag(names, s, layouts)

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()

        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox =
            awful.widget.layoutbox {
            screen = s,
            buttons = {
                awful.button(
                    {},
                    1,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    3,
                    function()
                        awful.layout.inc(-1)
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.layout.inc(-1)
                    end
                )
            }
        }

        -- Create a taglist widget
        s.mytaglist =
            awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = {
                awful.button(
                    {},
                    1,
                    function(t)
                        t:view_only()
                    end
                ),
                awful.button(
                    {modkey},
                    1,
                    function(t)
                        if client.focus then
                            client.focus:move_to_tag(t)
                        end
                    end
                ),
                awful.button({}, 3, awful.tag.viewtoggle),
                awful.button(
                    {modkey},
                    3,
                    function(t)
                        if client.focus then
                            client.focus:toggle_tag(t)
                        end
                    end
                ),
                awful.button(
                    {},
                    4,
                    function(t)
                        awful.tag.viewnext(t.screen)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function(t)
                        awful.tag.viewprev(t.screen)
                    end
                )
            }
        }

        -- Create a tasklist widget
        s.mytasklist =
            awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = {
                awful.button(
                    {},
                    1,
                    function(c)
                        c:activate {context = "tasklist", action = "toggle_minimization"}
                    end
                ),
                awful.button(
                    {},
                    3,
                    function()
                        awful.menu.client_list {theme = {width = 250}}
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.client.focus.byidx(1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.client.focus.byidx(-1)
                    end
                )
            }
        }

        -- Create the wibox
        s.mywibox =
            awful.wibar {
            position = "top",
            screen = s,
            widget = {
                layout = wibox.layout.align.horizontal,
                {
                    -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    s.mytaglist,
                    s.mylayoutbox,
                    s.mypromptbox
                },
                s.mytasklist, -- Middle widget
                {
                    -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    {
                        my_systray,
                        layout = wibox.container.margin,
                        margins = 4
                    },
                    batteryarc_widget(
                        {
                            font = beautiful.font,
                            bg_color = beautiful.bg_color,
                            low_level_color = beautiful.bg_urgent,
                            medium_level_color = "#ffd700",
                            show_notification_mode = "on_click",
                            warning_msg_position = "top_right"
                        }
                    ),
                    brightness_widget(
                        {
                            font = beautiful.font,
                            timeout = 60
                        }
                    ),
                    volume_widget(
                        {
                            widget_type = "arc",
                            device = "default"
                        }
                    ),
                    mytextclock
                }
            }
        }
    end
)

-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings(
    {
        awful.button(
            {},
            3,
            function()
                mymainmenu:toggle()
            end
        ),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    }
)
-- }}}

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings(
    {
        awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "show help", group = "awesome"}),
        awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
        awful.key({modkey, "Control"}, "q", awesome.quit, {description = "quit awesome", group = "awesome"}),
        awful.key(
            {modkey},
            "x",
            function()
                awful.prompt.run {
                    prompt = "Run Lua code: ",
                    textbox = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            {description = "lua execute prompt", group = "awesome"}
        ),
        awful.key(
            {modkey},
            "Return",
            function()
                awful.spawn(terminal)
            end,
            {description = "open a terminal", group = "launcher"}
        ),
        awful.key(
            {modkey},
            "e",
            function()
                awful.spawn(editor)
            end,
            {description = "open emacs", group = "launcher"}
        ),
        awful.key(
            {modkey, "Shift"},
            "n",
            function()
                awful.spawn('emacsclient -e "(call-interactively \'org-capture)" -c')
            end,
            {description = "capture task", group = "launcher"}
        ),
        awful.key(
            {modkey, "Control"},
            "n",
            function()
                awful.spawn('emacsclient -e "(call-interactively \'org-roam-capture)" -c')
            end,
            {description = "capture note", group = "launcher"}
        ),
        awful.key(
            {modkey},
            "w",
            function()
                awful.spawn("librewolf")
            end,
            {description = "open librewolf", group = "launcher"}
        ),
        awful.key(
            {modkey},
            "Escape",
            function()
                awful.spawn("dbus-launch betterlockscreen -l")
            end,
            {description = "lock screen", group = "launcher"}
        ),
        awful.key(
            {},
            "Print",
            function()
                awful.spawn("flameshot gui")
            end,
            {description = "take a screenshot", group = "launcher"}
        ),
        awful.key(
            {modkey},
            "z",
            function()
                awful.screen.focused().mypromptbox:run()
            end,
            {description = "run prompt", group = "launcher"}
        ),
        awful.key(
            {modkey},
            "space",
            function()
                menubar.show()
            end,
            {description = "show the menubar", group = "launcher"}
        )
    }
)

-- Focus related keybindings
awful.keyboard.append_global_keybindings(
    {
        awful.key(
            {modkey},
            "j",
            function()
                awful.client.focus.byidx(1)
            end,
            {description = "focus next by index", group = "client"}
        ),
        awful.key(
            {modkey},
            "k",
            function()
                awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
        ),
        awful.key(
            {modkey},
            ",",
            function()
                awful.screen.focus_relative(1)
            end,
            {description = "focus the next screen", group = "screen"}
        ),
        awful.key(
            {modkey},
            ".",
            function()
                awful.screen.focus_relative(-1)
            end,
            {description = "focus the previous screen", group = "screen"}
        ),
        awful.key(
            {modkey},
            "Tab",
            function()
                awful.layout.inc(1)
            end,
            {description = "select next", group = "layout"}
        ),
        awful.key(
            {modkey, "Shift"},
            "Tab",
            function()
                awful.layout.inc(-1)
            end,
            {description = "select previous", group = "layout"}
        ),
        -- IDASEN bindings
        awful.key(
            {modkey},
            "Prior",
            function()
                awful.spawn("idasen stand")
            end,
            {description = "enable standing position", group = "desk"}
        ),
        awful.key(
            {modkey},
            "Next",
            function()
                awful.spawn("idasen sit")
            end,
            {description = "enable sitting position", group = "desk"}
        )
    }
)

-- Layout related keybindings
awful.keyboard.append_global_keybindings(
    {
        awful.key(
            {modkey, "Shift"},
            "j",
            function()
                awful.client.swap.byidx(1)
            end,
            {description = "swap with next client by index", group = "client"}
        ),
        awful.key(
            {modkey, "Shift"},
            "k",
            function()
                awful.client.swap.byidx(-1)
            end,
            {description = "swap with previous client by index", group = "client"}
        ),
        awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
        awful.key(
            {modkey},
            "l",
            function()
                awful.tag.incmwfact(0.05)
            end,
            {description = "increase master width factor", group = "layout"}
        ),
        awful.key(
            {modkey},
            "h",
            function()
                awful.tag.incmwfact(-0.05)
            end,
            {description = "decrease master width factor", group = "layout"}
        ),
        awful.key(
            {modkey, "Shift"},
            "h",
            function()
                awful.tag.incnmaster(1, nil, true)
            end,
            {description = "increase the number of master clients", group = "layout"}
        ),
        awful.key(
            {modkey, "Shift"},
            "l",
            function()
                awful.tag.incnmaster(-1, nil, true)
            end,
            {description = "decrease the number of master clients", group = "layout"}
        ),
        awful.key(
            {modkey, "Control"},
            "h",
            function()
                awful.tag.incncol(1, nil, true)
            end,
            {description = "increase the number of columns", group = "layout"}
        ),
        awful.key(
            {modkey, "Control"},
            "l",
            function()
                awful.tag.incncol(-1, nil, true)
            end,
            {description = "decrease the number of columns", group = "layout"}
        )
    }
)

awful.keyboard.append_global_keybindings(
    {
        awful.key {
            modifiers = {modkey},
            keygroup = "numrow",
            description = "only view tag",
            group = "tag",
            on_press = function(index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then
                    tag:view_only()
                end
            end
        },
        awful.key {
            modifiers = {modkey, "Control"},
            keygroup = "numrow",
            description = "toggle tag",
            group = "tag",
            on_press = function(index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end
        },
        awful.key {
            modifiers = {modkey, "Shift"},
            keygroup = "numrow",
            description = "move focused client to tag",
            group = "tag",
            on_press = function(index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end
        },
        awful.key {
            modifiers = {modkey, "Control", "Shift"},
            keygroup = "numrow",
            description = "toggle focused client on tag",
            group = "tag",
            on_press = function(index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end
        },
        awful.key {
            modifiers = {modkey},
            keygroup = "numpad",
            description = "select layout directly",
            group = "layout",
            on_press = function(index)
                local t = awful.screen.focused().selected_tag
                if t then
                    t.layout = t.layouts[index] or t.layout
                end
            end
        }
    }
)

client.connect_signal(
    "request::default_mousebindings",
    function()
        awful.mouse.append_client_mousebindings(
            {
                awful.button(
                    {},
                    1,
                    function(c)
                        c:activate {context = "mouse_click"}
                    end
                ),
                awful.button(
                    {modkey},
                    1,
                    function(c)
                        c:activate {context = "mouse_click", action = "mouse_move"}
                    end
                ),
                awful.button(
                    {modkey},
                    3,
                    function(c)
                        c:activate {context = "mouse_click", action = "mouse_resize"}
                    end
                )
            }
        )
    end
)
client.connect_signal(
    "request::default_keybindings",
    function()
        awful.keyboard.append_client_keybindings(
            {
                ---- music
                awful.key(
                    {},
                    "XF86AudioPlay",
                    function()
                        awful.spawn("playerctl play-pause")
                    end,
                    {description = "play/pause", group = "Music"}
                ),
                awful.key(
                    {modkey},
                    "XF86AudioLowerVolume",
                    function()
                        awful.spawn("playerctl previous")
                    end,
                    {description = "previous song", group = "Music"}
                ),
                awful.key(
                    {modkey},
                    "XF86AudioRaiseVolume",
                    function()
                        awful.spawn("playerctl next")
                    end,
                    {description = "next song", group = "Music"}
                ),
                ---- volume
                awful.key(
                    {},
                    "XF86AudioMute",
                    function()
                        awful.spawn("pamixer -t")
                    end,
                    {description = "toggle audio", group = "Audio"}
                ),
                awful.key(
                    {},
                    "XF86AudioLowerVolume",
                    function()
                        awful.spawn("pamixer -d 5")
                    end,
                    {description = "lower volume", group = "Audio"}
                ),
                awful.key(
                    {},
                    "XF86AudioRaiseVolume",
                    function()
                        awful.spawn("pamixer -i 5")
                    end,
                    {description = "increase volume", group = "Audio"}
                ),
                ---- brightness
                awful.key(
                    {},
                    "XF86MonBrightnessDown",
                    function()
                        brightness_widget:dec()
                    end,
                    {description = "lower brightness", group = "Monitor"}
                ),
                awful.key(
                    {},
                    "XF86MonBrightnessUp",
                    function()
                        brightness_widget:inc()
                    end,
                    {description = "raise brightness", group = "Monitor"}
                ),
                awful.key(
                    {},
                    "XF86KbdBrightnessDown",
                    function()
                        awful.spawn("asusctl -p")
                    end,
                    {description = "lower brightness", group = "Keyboard"}
                ),
                awful.key(
                    {},
                    "XF86KbdBrightnessUp",
                    function()
                        awful.spawn("asusctl -n")
                    end,
                    {description = "raise brightness", group = "Keyboard"}
                ),
                awful.key(
                    {},
                    "XF86Launch3",
                    function()
                        awful.spawn("asusctl led-mode -n")
                    end,
                    {description = "raise brightness", group = "Keyboard"}
                ),
                awful.key(
                    {},
                    "XF86Launch4",
                    function()
                        awful.spawn("asusctl profile -n")
                    end,
                    {description = "next mode", group = "System"}
                ),
                awful.key(
                    {},
                    "XF86Launch1",
                    function()
                        awful.spawn(editor)
                    end,
                    {description = "emacs", group = "Launcher"}
                ),
                awful.key(
                    {},
                    "XF86Calculator",
                    function()
                        awful.spawn(editor .. "-e (calc-keypad)")
                    end,
                    {description = "Run calculator", group = "launcher"}
                )
            }
        )
    end
)
client.connect_signal(
    "request::default_keybindings",
    function()
        awful.keyboard.append_client_keybindings(
            {
                awful.key(
                    {modkey},
                    "f",
                    function(c)
                        c.fullscreen = not c.fullscreen
                        c:raise()
                    end,
                    {description = "toggle fullscreen", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "q",
                    function(c)
                        c:kill()
                    end,
                    {description = "close", group = "client"}
                ),
                awful.key(
                    {modkey, "Control"},
                    "space",
                    awful.client.floating.toggle,
                    {description = "toggle floating", group = "client"}
                ),
                awful.key(
                    {modkey, "Control"},
                    "Return",
                    function(c)
                        c:swap(awful.client.getmaster())
                    end,
                    {description = "move to master", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "o",
                    function(c)
                        c:move_to_screen()
                    end,
                    {description = "move to screen", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "t",
                    function(c)
                        c.ontop = not c.ontop
                    end,
                    {description = "toggle keep on top", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "n",
                    function(c)
                        -- The client currently has the input focus, so it cannot be
                        -- minimized, since minimized clients can't have the focus.
                        c.minimized = true
                    end,
                    {description = "minimize", group = "client"}
                ),
                awful.key(
                    {modkey},
                    "m",
                    function(c)
                        c.maximized = not c.maximized
                        c:raise()
                    end,
                    {description = "(un)maximize", group = "client"}
                ),
                awful.key(
                    {modkey, "Control"},
                    "m",
                    function(c)
                        c.maximized_vertical = not c.maximized_vertical
                        c:raise()
                    end,
                    {description = "(un)maximize vertically", group = "client"}
                ),
                awful.key(
                    {modkey, "Shift"},
                    "m",
                    function(c)
                        c.maximized_horizontal = not c.maximized_horizontal
                        c:raise()
                    end,
                    {description = "(un)maximize horizontally", group = "client"}
                )
            }
        )
    end
) -- TODO: add my custom keybinds

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal(
    "request::rules",
    function()
        -- All clients will match this rule.
        ruled.client.append_rule {
            id = "global",
            rule = {},
            properties = {
                focus = awful.client.focus.filter,
                raise = true,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen
            }
        }

        -- Floating clients.
        ruled.client.append_rule {
            id = "floating",
            rule_any = {
                instance = {"copyq", "pinentry"},
                class = {
                    "Arandr",
                    "Blueman-manager",
                    "Gpick",
                    "Kruler",
                    "MessageWin", -- kalarm.
                    "Sxiv",
                    "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                    "Wpa_gui",
                    "veromix",
                    "xtightvncviewer",
                    "maketag",
                    "makebranch",
                    "ssh-askpass"
                },
                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name = {
                    "Event Tester", -- xev.
                    "pinentry"
                },
                role = {
                    "AlarmWindow", -- Thunderbird's calendar.
                    "ConfigManager", -- Thunderbird's about:config.
                    "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
            properties = {floating = true}
        }

        -- Add titlebars to normal clients and dialogs
        ruled.client.append_rule {
            id = "titlebars",
            rule_any = {type = {"normal", "dialog"}},
            properties = {titlebars_enabled = false}
        }
        ruled.client.append_rule {
            id = "communications_space",
            rule_any = {class = {"Thunderbird", "telegram-desktop"}},
            properties = {screen = 1, tag = "COM"}
        }
        ruled.client.append_rule {
            id = "librewolf_space",
            rule_any = {
                class = {"Librewolf"}
            },
            properties = {screen = 2, tag = "WEB"}
        }

        -- Set Firefox to always map on the tag named "2" on screen 1.
        -- ruled.client.append_rule {
        --     rule       = { class = "Firefox"     },
        --     properties = { screen = 1, tag = "2" }
        -- }
    end
)
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars",
    function(c)
        -- buttons for the titlebar
        local buttons = {
            awful.button(
                {},
                1,
                function()
                    c:activate {context = "titlebar", action = "mouse_move"}
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:activate {context = "titlebar", action = "mouse_resize"}
                end
            )
        }

        awful.titlebar(c).widget = {
            {
                -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                -- Middle
                {
                    -- Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal(
    "request::rules",
    function()
        -- All notifications will match this rule.
        ruled.notification.append_rule {
            rule = {},
            properties = {
                screen = awful.screen.preferred,
                implicit_timeout = 5
            }
        }
    end
)

naughty.connect_signal(
    "request::display",
    function(n)
        naughty.layout.box {notification = n}
    end
)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:activate {context = "mouse_enter", raise = false}
    end
)

--- autostart
awful.spawn.with_shell("~/.config/awesome/autorun.sh")
