command_not_found_handler() {
  local pkgs cmd="$1"

  if which pkgfile &> /dev/null; then
    pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
    if [[ -n "$pkgs" ]]; then
      printf '%s may be found in the following packages:\n' "$cmd"
      printf '  %s\n' $pkgs[@]
      echo -n "\nInstall it now? "
      # TODO get choice if more than one package provides it
      while true; do
          read yn
          case $yn in
              [Yy]* ) sudo pacman -S "$(echo "$pkgs" | cut -d' ' -f1)"; break;;
              [Nn]* ) ; break;;
              * ) echo "Please answer yes or no.";;
          esac
      done
      return 0
    fi
  fi

  printf 'zsh: command not found: %s\n' "$cmd" 1>&2
  return 127
}
