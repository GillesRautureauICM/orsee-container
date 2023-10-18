# Container implementation for ORSEE - https://orsee.org

## Quickstart

    git clone https://github.com/matthewtolhurst/orsee-container.git
    cd orsee-container
    cp .env-example .env
    curl https://raw.githubusercontent.com/orsee/orsee/master/install/install.sql -o db/docker-entrypoint-initdb.d/install.sql
    docker-compose up -d

Wait a few seconds then navigate to http://localhost:8080/orsee/public/

## Configuration
You can configure your ORSEE either using environment variables via `.env`, or by inserting config files into the image build process. `.env-exmaple` is given as a guide.

Supported variables and their defaults:

    SERVER_URL=localhost:8080
    SERVER_PROTOCOL=http://
    MYSQL_USER=orsee_user
    MYSQL_DATABASE=orsee_db
    MYSQL_PASSWORD=orsee_pw
    MYSQL_HOST=localhost
    MYSQL_TABLE_PREFIX=or_
    TIMEZONE=Australia/Sydney
    SMTP_SERVER_AND_PORT=host.docker.internal:25

Required at build-time:

    ROOT_DIRECTORY=/orsee

Used only during database initialisation:  

    MYSQL_ROOT_PASSWORD=

Add any additional files you need to include in your image to `web/` - for example, style files to `web/var/www/html/orsee/style/mystyle`

If you include config files in the image, they will override environment variables.  
- `web/etc/ssmtp/ssmtp.conf`  
    Example file here: https://wiki.archlinux.org/title/SSMTP  
- `web/var/www/html/orsee/config/settings.php`  
    Example file is in the ORSEE distibution as settings-dist.php  

## Live environments

This should provide a relatively cromulent ORSEE distribution. If you plan on running this in production, I leave it to you on how to deal with:
- Database backups (Hint: `docker exec orsee-3.2.0-db bash -c 'mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE' > orseedump.sql`)
- Apache/PHP version updates (Hint: regularly rebuild your container image and redeploy)
- Cron (Hint: `docker exec orsee-container_web_1 bash -c "cd /var/www/html/orsee/admin && /usr/local/bin/php /var/www/html/orsee/admin/cron.php"`
