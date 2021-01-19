#######################################################################
# Fish - Environment
#######################################################################

umask 027

set -l paths \
  $HOME/.local/bin \
  ~/.local/share/xbps/usr/bin

for path in $paths
  test -d $path && set -a fish_user_paths $path
end

for editor in kak nvim vim vi micro nano
  if type -q $editor
    set -x EDITOR $editor
    set -x VISUAL $editor
    break
  end
end

if command -q open
  set -x OPENER open
end

if command -qs gpgconf
  set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

set -x GOPATH ~/.local/share/go
set -x RUSTUP_HOME ~/.local/share/rustup
set -x CARGO_HOME ~/.local/share/cargo
set -x KERAS_HOME ~/.local/share/keras
set -x NPM_CONFIG_USERCONFIG ~/.config/npm/npmrc
set -x CCACHE_CONFIGPATH ~/.config/ccache/config
set -x CCACHE_DIR ~/.cache/ccache

set -x QT_AUTO_SCREEN_SCALE_FACTOR 1
set -x XCOMPOSEFILE ~/.config/gtk-3.0/Compose
set -x XMODIFIERS @im=ibus
set -x GTK_IM_MODULE ibus
set -x QT_IM_MODULE ibus

set -x PASSWORD_STORE_DIR ~/.local/share/password-store
set -x PARALLEL_HOME ~/.config/parallel
set -x LESSHISTFILE ~/.cache/less.history
set -x LESS -R

if test -f ~/.config/lf/icons
  set -x LF_ICONS (sed 's/#.*$//' ~/.config/lf/icons | xargs printf '%s :')
end

set -x FIRESTORM_USER_DIR ~/.local/share/firestorm
set -x FIRESTORM_X64_USER_DIR $FIRESTORM_USER_DIR
set -x NETHACKOPTIONS ~/.config/nethack/nethackrc
set -x SDL_AUDIODRIVER pulse

if test "$XDG_SESSION_DESKTOP" != gnome
  set -x MOZ_ENABLE_WAYLAND 1
else
  set -x WINIT_UNIX_BACKEND x11
end

if not string match -qr 'kde|gnome' "$XDG_SESSION_TYPE"
  set -x QT_QPA_PLATFORMTHEME qt5ct
end

if test "$XDG_SESSION_TYPE" != wayland
  set -x GDK_SCALE 2
  set -x GDK_DPI_SCALE -1
end

if status --is-login && set -q DISPLAY
  dbus-update-activation-environment --systemd --all
end
