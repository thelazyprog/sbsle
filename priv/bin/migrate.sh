#!/bin/sh

export MYSQL_PWD=$SBSLE_DB_PASS

cd `dirname $0`

function print () {
  if [ "$(uname)" == 'Darwin' ]; then
    echo `gdate "+%H:%M:%S.%3N"` [$1] $2 
  else
    echo `date "+%H:%M:%S.%3N"` [$1] $2 
  fi
}

result=$(mysql -u $SBSLE_DB_USER $SBSLE_DB_NAME -e "SELECT 1 FROM schema_migrations LIMIT 1;" 2>&1)
if [ "`echo $result | grep ERROR`" ]; then
    mysql -u $SBSLE_DB_USER $SBSLE_DB_NAME -e "CREATE TABLE schema_migrations (version bigint(20) NOT NULL PRIMARY KEY, inserted_at datetime);"
    current_version=0
else
    result=$(mysql -u $SBSLE_DB_USER $SBSLE_DB_NAME -e "SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;" 2>&1)
    column=(`echo "$result"`)
    current_version=${column[1]}
    if [ -z "$current_version" ]; then
      current_version=0
    fi
fi

echo ""

count=0
for file in `find ../repo/migrations -maxdepth 1 -name '*.sql' | sort`; do
    version=$(echo $file | cut -d '/' -f 4 | cut -d '_' -f 1)
    if [ $version -gt $current_version ]; then
        print info "== Running $file forward"
        echo ""
        mysql -u $SBSLE_DB_USER $SBSLE_DB_NAME < $file
        if [ $? -ne 0 ]; then
            exit 1
        fi
        mysql -u $SBSLE_DB_USER $SBSLE_DB_NAME -e "INSERT INTO schema_migrations values ($version, now());"
        if [ $? -ne 0 ]; then
            exit 1
        fi
        print info "== Migrated"
        echo ""
        let ++count
    fi
done

if [ $count -eq 0 ]; then
  print info "Migrations already up"
  echo ""
fi

cd - > /dev/null

export MYSQL_PWD=
