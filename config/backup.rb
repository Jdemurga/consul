# encoding: utf-8
# Backup v4.x Configuration
Model.new(:participa_getafe, 'Participa Getafe database backup') do


  Utilities.configure do
	pg_dump     '/usr/pgsql-9.5/bin/pg_dump'
	pg_dumpall     '/usr/pgsql-9.5/bin/pg_dumpall'
	sendmail	'/usr/sbin/sendmail'
  end

  RAILS_ENV = 'production'
  DB = YAML.load_file( "/var/webapps/consul/shared/config/database.yml" )

  database PostgreSQL do |db|
    # try to get RAILS_ENV variable,
    # if it is not set, use 'production'

    # To dump all databases,
    # set `db.name = :all` (or leave blank)
    db.name               = DB[RAILS_ENV]['database']
    db.username           = DB[RAILS_ENV]['username']
    db.password           = DB[RAILS_ENV]['password']
    db.host               = DB[RAILS_ENV]['host']
  end

  archive :ppto_uploads do |archive|
    archive.add '/var/webapps/consul/shared/public/uploads/budget/'
  end

  store_with Local do |local|
    local.path = '/mnt/remote_backups/'
    local.keep = 300
  end


  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_warning           = true
    mail.on_failure           = true
    mail.from                 = 'backup@participa.getafe.es'
    mail.to                   = ['ivan.magdaleno@aeioros.com', 'gema.gonzalez@ayto-getafe.org']

    mail.delivery_method      = :sendmail
  end

  compress_with Gzip
end
