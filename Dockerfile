# docker pull ubuntu
# docker build --tag emacs-devbox .
# docker run --mount type=bind,src=../projects,dst=/root/projects -it emacs-devbox

FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive

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
RUN apt install -y tmux

RUN mkdir -p ~/.life
RUN mkdir -p ~/projects
RUN cd ~/projects && \
    git clone https://github.com/emacs-mirror/emacs.git && \
    cd ~/projects/emacs && \
    git checkout emacs-30.1 && \
    sh ./autogen.sh && \
    sh ./configure --with-native-compilation --with-tree-sitter --with-x-toolkit=no --with-sqlite3=yes  --with-xpm=ifavailable --with-jpeg=ifavailable --with-png=ifavailable --with-gif=ifavailable --with-tiff=ifavailable CFLAGS="-O3 -Wno-implicit-function-declaration -fno-signed-zeros -funroll-loops -fomit-frame-pointer -fvisibility=hidden -mtune=native -march=native" && \
    make -j8 && \
    make install
RUN rm -rf ~/.emacs.d/
RUN git clone https://github.com/amirrajan/evil-code-editor.git ~/.emacs.d/
COPY ./.tmux.conf ~/.tmux.conf
ENV TERM=xterm-256color
RUN git clone https://github.com/nvm-sh/nvm.git