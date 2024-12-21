#!/bin/bash

echo "makessh..."
/usr/bin/makessh.sh
echo "mailhog..."
/etc/init.d/php7.3-fpm stop
if [ -f /etc/php/7.3/apache2/php.ini ]; then
  cp -f /etc/php/7.3/apache2/php.ini /etc/php/7.3/apache2/php.ini.orig
  sed -e 's/;sendmail_path =/sendmail_path = '\''\/opt\/go\/bin\/mhsendmail --smtp-addr \"'${MAILHOGSERVER}'\:1025\"'\''/g' < /etc/php/7.3/apache2/php.ini.orig > /etc/php/7.3/apache2/php.ini
fi
if [ -f /etc/php/7.3/fpm/php.ini ]; then
cp -f /etc/php/7.3/fpm/php.ini /etc/php/7.3/fpm/php.ini.orig
  sed -e 's/;sendmail_path =/sendmail_path = '\''\/opt\/go\/bin\/mhsendmail --smtp-addr \"'${MAILHOGSERVER}'\:1025\"'\''/g' < /etc/php/7.3/fpm/php.ini.orig > /etc/php/7.3/fpm/php.ini
fi
if [ -f /etc/php/7.3/cli/php.ini ]; then
cp -f /etc/php/7.3/cli/php.ini /etc/php/7.3/cli/php.ini.orig
  sed -e 's/;sendmail_path =/sendmail_path = '\''\/opt\/go\/bin\/mhsendmail --smtp-addr \"'${MAILHOGSERVER}'\:1025\"'\''/g' < /etc/php/7.3/cli/php.ini.orig > /etc/php/7.3/cli/php.ini
fi
source /etc/bash.bashrc
echo "supervisord..."
/usr/bin/supervisord -n