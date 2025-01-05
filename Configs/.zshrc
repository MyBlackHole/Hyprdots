# Oh-my-zsh installation path
ZSH=/usr/share/oh-my-zsh/

# Powerlevel10k theme path
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=(sudo zsh-autosuggestions zsh-syntax-highlighting git vi-mode tmux rust golang podman)
source $ZSH/oh-my-zsh.sh

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]]; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Detect AUR wrapper
if pacman -Qi yay &>/dev/null; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
   aurhelper="paru"
fi

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

# Helpful aliases
alias c='clear' # clear terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list available package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias vc='code' # gui code editor

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Display Pokemon
pokemon-colorscripts --no-title -r 1,3,6

export ALL_PROXY="http://127.0.0.1:1081"
export HTTP_PROXY=$ALL_PROXY
export HTTPS_PROXY=$ALL_PROXY
# export all_proxy=$ALL_PROXY
# export http_proxy=$ALL_PROXY
# export https_proxy=$ALL_PROXY

# fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

# # fiddler
# export HTTP_PROXY="http://127.0.0.1:8866"
# export HTTPS_PROXY="http://127.0.0.1:8866"
# export ALL_PROXY="socks5://127.0.0.1:8866"

# # yarn
# YARN_PATH=$HOME/.yarn
# YARN_CONFIG_PATH=$HOME/.config/yarn/global/node_modules
# if [ -d "$YARN_PATH" ]; then
#     export PATH=$YARN_PATH/bin::$YARN_CONFIG_PATH/.bin:$PATH
# fi

# deno
DENO_INSTALL=$HOME/.deno
if [ -d "$DENO_INSTALL" ]; then
    export PATH=$DENO_INSTALL/bin:$PATH
fi

# esp-idf
ESP_IDF_PATH=/opt/esp-idf
if [ -d "$ESP_IDF_PATH" ]; then
    source $ESP_IDF_PATH/export.sh
fi

# atuin
eval "$(atuin init zsh)"


# go
GO_PATH=$HOME/go
if [ -d "$GO_PATH" ]; then
    export PATH=$GO_PATH/bin:$PATH

    # # golang 
    # export GOPROXY="https://goproxy.io,direct"
fi

# Android sdk
ANDROID_SDK_PATH=/opt/android-sdk
if [ -d "$ANDROID_SDK_PATH" ]; then
    export PATH=$ANDROID_SDK_PATH/platform-tools:$ANDROID_SDK_PATH/tools/bin:$PATH
fi

# Android ndk
ANDROID_NDK_PATH=/opt/android-ndk
if [ -d "$ANDROID_NDK_PATH" ]; then
    export NDK_HOME=/opt/android-ndk
    export PATH=$ANDROID_NDK_PATH:$PATH
fi

# erg
ERG_PATH=$HOME/.erg
if [ -d "$ERG_PATH" ]; then
    export PATH=$ERG_PATH/bin:$PATH
fi

export LOCAL_PATH="$HOME/.local"
if [ -d "$LOCAL_PATH" ]; then
    export PATH=$LOCAL_PATH/bin:$PATH
fi

export VCPKG_ROOT=$HOME/.local/share/vcpkg
if [ -d "$VCPKG_ROOT" ]; then
    export PATH=$VCPKG_ROOT:$PATH
fi

# rust
RUST_HOME=$HOME/.cargo
if [ -d "$RUST_HOME" ]; then
    export PATH=$RUST_HOME/bin:$PATH
fi
