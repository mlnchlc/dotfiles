-------------------------------
--  "dracula" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"
local wallpapers_path= require("gears.filesystem").get_xdg_data_home() .. "wallpapers/"
local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Main
local theme = {}
-- theme.wallpaper = require("gears.filesystem").get_random_file_from_dir(wallpapers_path, { "jpg", "png" }, true)
theme.wallpaper = themes_path .. "dracula/base_dracula.png"
-- }}}

-- {{{ Styles
theme.font      = "Jetbrains Mono Nerd Font Medium 9"

-- {{{ Colors
theme.fg_normal  = "#BFBFBF"
theme.fg_focus   = "#F8F8F2"
theme.fg_urgent  = "#F8F8F2"
theme.bg_normal  = "#282136"
theme.bg_focus   = "#6272A4"
theme.bg_urgent  = "#FF5555"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(1)
theme.border_width  = dpi(3)
theme.border_normal = "#282A36"
theme.border_focus  = "#6272a4"
theme.border_marked = "#FFB86C"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#6272a4"
theme.titlebar_bg_normal = "#282136"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#FFB86C"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#FF79C6"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = themes_path .. "dracula/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "dracula/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "dracula/awesome-icon.png"
theme.menu_submenu_icon      = themes_path .. "default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "dracula/layouts/tile.png"
theme.layout_tileleft   = themes_path .. "dracula/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "dracula/layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "dracula/layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "dracula/layouts/fairv.png"
theme.layout_fairh      = themes_path .. "dracula/layouts/fairh.png"
theme.layout_spiral     = themes_path .. "dracula/layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "dracula/layouts/dwindle.png"
theme.layout_max        = themes_path .. "dracula/layouts/max.png"
theme.layout_fullscreen = themes_path .. "dracula/layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "dracula/layouts/magnifier.png"
theme.layout_floating   = themes_path .. "dracula/layouts/floating.png"
theme.layout_cornernw   = themes_path .. "dracula/layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "dracula/layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "dracula/layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "dracula/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = themes_path .. "dracula/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "dracula/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = themes_path .. "dracula/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "dracula/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "dracula/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "dracula/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themes_path .. "dracula/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "dracula/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "dracula/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "dracula/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themes_path .. "dracula/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "dracula/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "dracula/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "dracula/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themes_path .. "dracula/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "dracula/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "dracula/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "dracula/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
