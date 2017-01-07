#gcov='--enable-gcov'
configoptions="\
--with-mcrypt \
--enable-fastcgi \
--enable-bcmath \
--enable-calendar \
--enable-exif \
--enable-ftp \
--enable-mbstring \
--enable-pcntl \
--enable-soap \
--enable-sockets \
--enable-sqlite-utf8 \
--enable-wddx \
--enable-zip \
--disable-debug \
--with-mysql \
--with-zlib \
--with-gettext \
--with-pdo-mysql \
--with-curl \
--with-gd=yes \
--enable-gd-native-ttf  \
--with-jpeg-dir=shared,/usr \
--with-png-dir=/usr \
--with-openssl \
--with-libdir=lib/x86_64-linux-gnu \
--with-freetype-dir \
--with-xpm-dir \
--with-t1lib \
$gcov"
