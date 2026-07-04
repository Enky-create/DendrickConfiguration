{ self, inputs, ... }: {
  flake.nixosModules.kitty = { config, pkgs, inputs, ... }: {
    environment.systemPackages = [ pkgs.kitty ];
    # Системный конфиг-фолбэк: kitty подхватит его, если у пользователя
    # нет своего ~/.config/kitty/kitty.conf.
    environment.etc."xdg/kitty/kitty.conf".text = ''
      # ===== Прозрачность =====
      # 0.0 — полностью прозрачный, 1.0 — непрозрачный.
      background_opacity 0.85
      background_blur 30
      # Позволяет менять прозрачность на лету (Ctrl+Shift+A потом m/l).
      dynamic_background_opacity yes

      # ===== Цвета: нейтральный тёмный, без синего/фиолетового оттенка =====
      # Тёплый почти-чёрный фон (не #1e1e2e / tokyonight и подобные — там синева).
      background            #181818
      foreground            #e6e2d3

      cursor                #e6e2d3
      cursor_text_color     #181818

      selection_background  #3a3a3a
      selection_foreground  #e6e2d3

      url_color             #d8a657

      # ANSI-палитра в стиле gruvbox (тёплые тона: коричневый/оранжевый/зелёный,
      # никакого синего/фиолетового доминирования)
      color0  #282828
      color8  #928374
      color1  #cc241d
      color9  #fb4934
      color2  #98971a
      color10 #b8bb26
      color3  #d79921
      color11 #fabd2f
      color4  #458588
      color12 #83a598
      color5  #b16286
      color13 #d3869b
      color6  #689d6a
      color14 #8ec07c
      color7  #a89984
      color15 #ebdbb2

      # ===== Внешний вид окна =====
      window_padding_width 10
      hide_window_decorations yes
      confirm_os_window_close 0

      # Рамку/бордер рисует niri, свои у kitty отключаем
      draw_minimal_borders yes
      window_border_width 0

      # ===== Табы (на случай нескольких вкладок в одном окне) =====
      tab_bar_edge bottom
      tab_bar_style powerline
      tab_powerline_style slanted
      active_tab_background   #d8a657
      active_tab_foreground   #181818
      inactive_tab_background #282828
      inactive_tab_foreground #a89984

      # ===== Шрифт =====
      font_family      JetBrainsMono Nerd Font
      bold_font        auto
      italic_font      auto
      bold_italic_font auto
      font_size 12.0

      # ===== Курсор =====
      cursor_shape beam
      cursor_blink_interval 0

      # ===== Прочее =====
      enable_audio_bell no
      scrollback_lines 10000
      shell_integration enabled
    '';
  };
}
