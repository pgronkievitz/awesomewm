---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local t = {}

t.gap_single_client  = false

t.font          = "VictorMono Nerd Font 12"
t.font_color_light = "#ffffff"
t.font_color = "#000000"

t.bg_normal     = "#f5f5f5"
t.bg_focus      = "#a4d3ee"
t.bg_urgent     = "#cd6889"
t.bg_minimize   = "#00fa9a"
t.bg_systray    = t.bg_normal

t.fg_normal     = t.font_color
t.fg_focus      = t.font_color
t.fg_urgent     = t.font_color
t.fg_minimize   = t.font_color

t.useless_gap   = dpi(3)
t.border_width  = dpi(1)
t.border_normal = "#eed5d2"
t.border_focus  = "#00bfff"
t.border_marked = "#ffd700"

-- taglist
t.taglist_bg_focus = t.bg_focus
t.taglist_bg_urgent = t.bg_urgent
t.taglist_bg_occupied = "#335EA8"
t.taglist_bg_empty = t.bg_normal
t.taglist_bg_volatile = "#dcdcdc"

t.taglist_fg_focus = t.font_color
t.taglist_fg_urgent = t.font_color
t.taglist_fg_occupied = t.font_color_light
t.taglist_fg_empty = t.font_color
t.taglist_fg_volatile = t.font_color

-- tasklist
t.tasklist_bg_focus = t.bg_focus
t.tasklist_fg_focus = t.fg_focus

t.tasklist_bg_urgent = t.bg_urgent
t.tasklist_fg_urgent = t.fg_urgent

-- titlebar
t.titlebar_bg_normal = t.bg_normal
t.titlebar_fg_normal = t.fg_normal

t.titlebar_bg_focus = t.bg_focus
t.titlebar_fg_focus = t.fg_focus

-- tooltip
t.tooltip_font = t.font
t.tooltip_opacity = 0.8

t.tooltip_bg_color = t.bg_focus
t.tooltip_fg_color = t.fg_focus

t.tooltip_border_width = dpi(1)
t.tooltip_border_color = t.border_focus

-- mouse_finder
-- t.mouse_finder_color = ""
-- t.mouse_finder_timeout = 100
-- t.mouse_finder_animate_timeout = ""
-- t.mouse_finder_radius = ""
-- t.mouse_finder_factor = ""

-- prompt
t.prompt_bg = t.bg_normal
t.prompt_fg = t.fg_normal
t.prompt_bg_cursor = "#00bfff"
t.prompt_fg_cursor = t.bg_normal
t.prompt_font = t.font

-- hotkeys
t.hotkeys_bg = t.bg_normal
t.hotkeys_fg = t.fg_normal
t.hotkeys_border_width = dpi(1)
t.hotkeys_border_color = t.border_normal
-- t.hotkeys_shape = ""
t.hotkeys_opacity = 0.9
t.hotkeys_modifiers_fg = t.fg_focus
t.hotkeys_label_bg = t.bg_minimize
t.hotkeys_label_fg = t.fg_minimize
t.hotkeys_group_margin = 2
t.hotkeys_font = t.font
t.hotkeys_description_font = t.font

-- Generate taglist squares:
local taglist_square_size = dpi(4)
t.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, t.fg_normal
)
t.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, t.fg_normal
)

-- Variables set for theming notifications:
t.notification_font = t.font
t.notification_bg = t.bg_normal
t.notification_fg = t.fg_normal
t.notification_width = dpi(400)
t.notification_height = dpi(100)
t.notification_margin = dpi(2)
t.notification_border_color = t.bg_normal
t.notification_border_width = dpi(1)
-- t.notification_shape = ""
t.notification_opacity = 0.95

-- Variables set for theming the menu:
t.menu_bg_normal = t.bg_normal
t.menu_bg_focus = t.bg_focus

t.menu_fg_normal = t.fg_normal
t.menu_fg_focus = t.fg_focus

t.menu_border_color = t.bg_systray
t.menu_border_width = dpi(1)

t.menu_submenu_icon = themes_path.."default/submenu.png"
t.menu_height = dpi(15)
t.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--t.bg_widget = "#cc0000"

-- Define the image to load
t.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
t.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

t.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
t.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

t.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
t.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
t.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
t.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

t.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
t.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
t.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
t.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

t.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
t.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
t.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
t.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

t.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
t.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
t.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
t.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

t.wallpaper = "/home/pg/Pictures/Wallpapers/winter.jpg"

-- You can use your own layout icons like this:
t.layout_fairh = themes_path.."default/layouts/fairhw.png"
t.layout_fairv = themes_path.."default/layouts/fairvw.png"
t.layout_floating  = themes_path.."default/layouts/floatingw.png"
t.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
t.layout_max = themes_path.."default/layouts/maxw.png"
t.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
t.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
t.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
t.layout_tile = themes_path.."default/layouts/tilew.png"
t.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
t.layout_spiral  = themes_path.."default/layouts/spiralw.png"
t.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
t.layout_cornernw = themes_path.."default/layouts/cornernww.png"
t.layout_cornerne = themes_path.."default/layouts/cornernew.png"
t.layout_cornersw = themes_path.."default/layouts/cornersww.png"
t.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
t.awesome_icon = theme_assets.awesome_icon(
    t.menu_height, t.bg_focus, t.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
t.icon_theme = nil

return t

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
