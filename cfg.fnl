(pcall require "luarocks.loader")
(local gears (require "gears"))
(local awful (require "awful"))
(require "awful.autofocus")
(local wibox (require "wibox"))
(local beautiful (require "beautiful"))
(local naughty (require "naughty"))
(local menubar (require "menubar"))
(local hotkeys_popup (require "awful.hotkeys_popup"))
(require "awful.hotkeys_popup.keys")

(local batteryarc_widget (require "awesome-wm-widgets.batteryarc-widget.batteryarc"))
(local brightness_widget (require "awesome-wm-widgets.brightness-widget.brightness"))
(local volume_widget (require "awesome-wm-widgets.volume-widget.volume"))

(when awesome.startup_errors
  (naughty.notify {:preset naughty.config.presets.critical
                  :title "Oops, there were errors during startup!"
                  :text awesome.startup_errors}))

(do
  (local in_error = false)
  (awesome.connect_signal "debug::erorr" (fn [err]
                                           (if in_error
                                               (local in_error true)
                                               (naughty.notify {:preset naughty.config.presets.critical
                                                                :title "Oops, an error happened!"
                                                                :text (tostring err)}))
                                               (local in_error false)
                                           )))
(beautiful.init "/home/pg/.config/awesome/theme.lua")
(set terminal "alacritty")
(set editor (or (os.getenv "EDITOR") "emacsclient -c"))
(set editor_cmd editor)
(set modkey "Mod4")
(set awful.layout.layouts
     [awful.layout.suit.floating,
    awful.layout.suit.tile,
    ;; awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    ;; awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    ;; awful.layout.suit.fair.horizontal,
    ;; awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    ;; awful.layout.suit.corner.nw,
    ;; awful.layout.suit.corner.ne,
    ;; awful.layout.suit.corner.sw,
    ;; awful.layout.suit.corner.se,
    ])

(set myawesomemenu [
                    ["hotkeys" #(hotkeys_popup.show_help nil (awful.screen.focused))]
                     ["manual" (.. terminal "-e man awesome")]
                     ["edit config" (.. editor_cmd .. " " .. awesome.conffile)]
                     ["restart" awesome.restart]
                     ["quit" #((awesome.quit))]
                    ])
(set mymainmenu (awful.menu {:items [["awesome" myawesomemenu beatuiful.awesome_icon]
                                     ["open terminal" terminal]]}))

(set mylauncher (awful.widget.launcher {:image beautiful.awesome_icon
                                        :menu mymainmenu}))
(set menubar.utils.terminal terminal)
(set mytextclock (wibox.widget.textclock "%Y-%m-%d (%a) %H:%M"))
(local taglist_buttons (gears.table.join
                        (awful.button [] 1 #(($1.view_only)))
                        (awful.button [modkey] 1 #((if client.focus (client.focus:move_to_tag $1))) )
                        (awful.button [] 3 awful.tag.viewtoggle)
                        (awful.button [modkey] 3 #((if client.focus (client.focus:toggle_tag $1))))
                        (awful.button [] 4 $((awful.tag.viewnext $1.screen)))
                        (awful.button [] 5 $((awful.tag.viewprev $1.screen)))))
(local tasklist_buttons (gears.table.join
                         (awful.button [] 1 #(((if (= $1 clicent.focus)
                                                   (set c.minimized true)
                                                   (c:emit_signal "request::activate"
                                                                  "tasklist"
                                                                  {:raise true})))))
                         (awful.button [] 3 #((awful.menu.client_list {:theme {:width 250}})))
                         (awful.button [] 4 #((awful.client.focus.byidx 1)))
                         (awful.button [] 5 #((awful.client.focus.byidx -1)))))
(fn set_wallpaper [s]
  ((if beautiful.wallpaper
       (if (= (type beautiful.wallpaper) "function") (set wallpaper (beautiful.wallpaper s)))
       (gears.wallpaper.maximized beautiful.wallpaper s true))))

(set my_systray (wibox.widget.systray))
(my_systray:set_base_size 24)
(set beautiful.systray_icon_spacing 2)
(screen.connect_signal "property::geometry" set_wallpaper)
(awful.screen.connect_for_each_screen (fn [s]
                                        (set_wallpaper s)
                                        (local l awful.layout.suit)
                                        (local names [ "COM" "WEB" "EDT" "BRV" "TRM" "OTH" "MUS" "DSC" "TMS" ])
                                        (local layouts [ l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile ])
                                        (awful.tag names s layouts)
                                        (set s.mypromptbox (awful.widget.prompt))
                                        (set s.mylayoutbox (awful.widget.layoutbox s))
                                        (s.mylayoutbox:buttons (gears.table.join
                                                                (awful.button [] 1 #(awful.layout.inc(1)))
                                                                (awful.button [] 3 #(awful.layout.inc(-1)))
                                                                (awful.button [] 4 #(awful.layout.inc(1)))
                                                                (awful.button [] 5 #(awful.layout.inc(-1)))
                                                                ))
                                        ()
                                        ))
