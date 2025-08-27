# docker pull ubuntu
# docker build --tag devbox .
# docker run -dit --name devbox devbox
# docker exec -it devbox bash

FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt-get install -y sudo
RUN apt update
RUN apt install -y git curl wget vim
RUN apt install -y autoconf texinfo
RUN apt install -y make gcc
RUN apt install -y zlib1g zlib1g-dev
RUN apt install -y libgccjit-13-dev
RUN apt install -y libtree-sitter-dev
RUN apt install -y gnutls-dev
RUN apt install -y libtree-sitter0 libtree-sitter-dev
RUN apt install -y pkg-config libgnutls28-dev
RUN apt install -y build-essential texinfo autoconf
RUN apt install -y libcunit1-ncurses-dev
RUN apt install -y ncurses-dev
RUN apt install -y silversearcher-ag ripgrep
RUN apt install -y *libsqlite*
RUN apt install -y zsh
RUN apt install -y tmux xclip
RUN apt install -y net-tools
RUN apt install -y clangd bear cmake
RUN apt install -y python-is-python3 python3-venv nodejs npm
RUN npm install -g pyright

# compile and install emacs
RUN mkdir -p ~/projects
RUN cd ~/projects && \
    git clone --depth 1 --branch emacs-30.1 https://github.com/emacs-mirror/emacs.git && \
    cd ~/projects/emacs && \
    sh ./autogen.sh && \
    sh ./configure --with-modules --with-native-compilation --with-tree-sitter --with-x-toolkit=no --with-sqlite3=yes --with-xpm=ifavailable --with-jpeg=ifavailable --with-png=ifavailable --with-gif=ifavailable --with-tiff=ifavailable CFLAGS="-O3 -Wno-implicit-function-declaration -fno-signed-zeros -funroll-loops -fomit-frame-pointer -fvisibility=hidden -mtune=native -march=native" && \
    make -j8 && \
    make install

# create dev user
RUN echo 'root:qwerty' | chpasswd
RUN useradd -m dev && echo 'dev:qwerty' | chpasswd
RUN usermod -aG sudo dev
RUN chsh -s $(which zsh) dev
USER dev

# set home to persisted volume
VOLUME /home/dev
WORKDIR /home/dev

# install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ./.fzf/install --all

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > ./rustup-init.sh
RUN sh ./rustup-init.sh -y

# create some default directories
RUN mkdir -p ./.life
RUN mkdir -p ./projects

# pull down a batteries included emacs config
RUN rm -rf ./.emacs.d/
RUN git clone https://github.com/amirrajan/evil-code-editor.git ./.emacs.d/
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# stage ohmyzsh customizations
COPY ./.oh-my-zsh ./.oh-my-zsh
COPY ./.zshrc ./.zshrc

# stage tmux customizations
COPY ./.tmux.conf ./.tmux.conf
ENV TERM=screen-256color
