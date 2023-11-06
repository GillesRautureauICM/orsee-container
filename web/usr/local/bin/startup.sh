SETTINGS_TEMPLATE=/var/www/html$ROOT_DIRECTORY/install/settings-dist.php
SETTINGS_DESTINATION=/var/local/settings.php
SETTINGS_ORIGINAL_LOCATION=/var/www/html$ROOT_DIRECTORY/config/settings.php
MAIL_SETTINGS=/etc/ssmtp/ssmtp.conf

if [ -f "$MAIL_SETTINGS" ]; then
    #We already have a mail conf
    echo "Found custom $MAIL_SETTINGS"
else
    #Set SMTP here
    if [ -n "$SMTP_SERVER_AND_PORT" ]; then
        echo "mailhub=$SMTP_SERVER_AND_PORT" > $MAIL_SETTINGS
    else
        #A hopefully sane default
        echo "mailhub=host.docker.internal:25" > $MAIL_SETTINGS
    fi
fi

if [ -f "$SETTINGS_ORIGINAL_LOCATION" ]; then
    #We already have a settings file
    echo "Found custom $SETTINGS_ORIGINAL_LOCATION"
    exit 0
fi

#Copy from template
cat $SETTINGS_TEMPLATE > $SETTINGS_DESTINATION

#Always set these
sed -i "s/^\$settings__root_to_server=\".*/\$settings__root_to_server=\"\/var\/www\/html\";/" $SETTINGS_DESTINATION
sed -i "s/^\$settings__server_url=\".*/\$settings__server_url=\"localhost:8080\";/" $SETTINGS_DESTINATION

#Set remaining options...
if [ -n "$ROOT_DIRECTORY" ]; then
    echo "Got ROOT_DIRECTORY=$ROOT_DIRECTORY"
    if [ $ROOT_DIRECTORY = '/' ]; then ROOT_DIRECTORY="";fi
    sed -i "s#^\$settings__root_directory=\".*#\$settings__root_directory=\"$ROOT_DIRECTORY\";#" $SETTINGS_DESTINATION
fi

if [ -n "$SERVER_URL" ]; then
    echo "Got SERVER_URL=$SERVER_URL"
    sed -i "s/^\$settings__server_url=\".*/\$settings__server_url=\"$SERVER_URL\";/" $SETTINGS_DESTINATION
fi

if [ -n "$SERVER_PROTOCOL" ]; then
    echo "Got SERVER_PROTOCOL=$SERVER_PROTOCOL"
    sed -i "s#^\$settings__server_protocol=\".*#\$settings__server_protocol=\"$SERVER_PROTOCOL\";#" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_HOST" ]; then
    echo "Got MYSQL_HOST=$MYSQL_HOST"
    sed -i "s/^\$site__database_host=\".*/\$site__database_host=\"$MYSQL_HOST\";/" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_DATABASE" ]; then
    echo "Got MYSQL_DATABASE=$MYSQL_DATABASE"
    sed -i "s/^\$site__database_database=\".*/\$site__database_database=\"$MYSQL_DATABASE\";/" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_USER" ]; then
    echo "Got MYSQL_USER=$MYSQL_USER"
    sed -i "s/^\$site__database_admin_username=\".*/\$site__database_admin_username=\"$MYSQL_USER\";/" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_PASSWORD" ]; then
    sed -i "s/^\$site__database_admin_password=\".*/\$site__database_admin_password=\"$MYSQL_PASSWORD\";/" $SETTINGS_DESTINATION
fi

if [ -n "$MYSQL_TABLE_PREFIX" ]; then
    echo "Got MYSQL_TABLE_PREFIX=$MYSQL_TABLE_PREFIX"
    sed -i "s/^\$site__database_table_prefix=\".*/\$site__database_table_prefix=\"$MYSQL_TABLE_PREFIX\";/" $SETTINGS_DESTINATION
fi

if [ -n "$TIMEZONE" ]; then
    echo "Got TIMEZONE=$TIMEZONE"
    sed -i "s#^date_default_timezone_set.*#date_default_timezone_set\('$TIMEZONE'\);#" $SETTINGS_DESTINATION
fi

#Start cron service
if service --status-all | grep -q "cron";then
    /usr/sbin/service cron start
fi

