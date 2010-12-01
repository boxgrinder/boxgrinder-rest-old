#!/bin/sh

SU_CMD=$(which su)

BOXGRINDER_REST_DEPLOYMENT="/opt/jboss-as/server/all/deploy/boxgrinder-rest-rails.yml"
if [ ! -e $BOXGRINDER_REST_DEPLOYMENT ]; then
    echo "Creating BoxGrinder REST deployment file..."
    echo -e '---\napplication:\n RAILS_ROOT: /opt/boxgrinder-rest\n RAILS_ENV: production\nweb:\n context: /\n' > $BOXGRINDER_REST_DEPLOYMENT
fi

BOXGRINDER_DB_USER=$(echo '\du' | $SU_CMD postgres -c psql | grep boxgrinder | cut -d' ' -f2)
if [ $BOXGRINDER_DB_USER. != 'boxgrinder.' ]; then
    echo "Creating BoxGrinder database user..."
    $SU_CMD postgres -c "/usr/bin/createuser -SDR boxgrinder"
    echo "ALTER USER boxgrinder WITH PASSWORD 'boxgrinder';" | $SU_CMD postgres -c /usr/bin/psql
fi

BOXGRINDER_DB_NAME=$(echo '\l' | $SU_CMD postgres -c psql | grep boxgrinder_production | cut -d' ' -f2)
if [ $BOXGRINDER_DB_NAME. != 'boxgrinder_production.' ]; then
    echo "Creating BoxGrinder database..."
    $SU_CMD postgres -c "/usr/bin/createdb boxgrinder_production -O boxgrinder"
    echo "GRANT ALL ON DATABASE boxgrinder_production TO boxgrinder" | $SU_CMD postgres -c /usr/bin/psql
fi

STEAMCANNON_SCHEMA=$(echo '\dt' | $SU_CMD postgres -c 'psql boxgrinder_production' | grep schema_migrations | cut -d' ' -f4)
if [ $STEAMCANNON_SCHEMA. != 'schema_migrations.' ]; then
    echo "Initializing and seeding BoxGrinder database schema..."
    cd /opt/boxgrinder
    export RAILS_ENV=production
    $SU_CMD jboss-as6 -c '/opt/jruby/bin/jruby -S rake db:setup'
fi
