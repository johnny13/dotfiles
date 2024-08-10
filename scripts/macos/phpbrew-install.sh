#!/usr/bin/env bash

xcode-select --install

# You should install brew https://brew.sh/index_fr
brew install automake autoconf curl pcre bison re2c mhash libtool icu4c gettext jpeg openssl libxml2 mcrypt gd gmp libevent zlib libzip bzip2 imagemagick pkg-config oniguruma
brew link --force icu4c
brew link --force openssl
brew link --force libxml2

curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
sudo mv phpbrew /usr/local/bin/phpbrew

phpbrew init
echo "[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc" >> ~/.profile

# See also https://github.com/phpbrew/phpbrew#variants
# add +zts if needed
# add +fpm if needed
phpbrew --debug install php-8.1.16 +gd +default +sqlite +mysql +bz2=/usr/local/Cellar/bzip2/1.0.8/ +zlib=/usr/local/Cellar/zlib/1.3/ -- --with-gd=shared
# use php 8.1.16 as default php binary
phpbrew switch 8.1.16

#
# Note: php.ini path
# ~/.phpbrew/php/php-8.1.16/etc/php.ini
#

# ICONV Extension
brew install libiconv
phpbrew extension install iconv -- --with-iconv=/usr/local/opt/libiconv

# See also https://github.com/phpbrew/phpbrew/wiki/Extension-Installer
phpbrew ext install xdebug stable
phpbrew ext install soap stable
phpbrew ext install gmp stable

phpbrew ext install gd stable -- --with-zlib-dir=/usr/local/Cellar/zlib/1.3/
phpbrew ext install exif stable
phpbrew --debug ext install imagick stable  -- --with-imagick=/usr/local/Cellar/imagemagick/7.1.1-23/
# intl specifications
export LDFLAGS="-L/usr/local/opt/icu4c/lib" 
export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"
phpbrew ext install intl stable