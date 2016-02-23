module JdbcUrl
  def self.from_database_url
    from_env_var('DATABASE_URL')
  end

  def self.from_env_var(var, default=nil)
    from(ENV[var] || default)
  end

  def self.from(db_url)
    db_protocol = db_url.split(':')[0]
    jdbc_protocol = case db_protocol
                    when 'postgres' then 'postgresql'
                    else db_protocol
                    end

    db_server = db_url.split('@')[1]
    db_host = db_server.split(':')[0]
    db_port = db_server.split(':')[1].split('/')[0]
    db_name = db_server.split(':')[1].split('/')[1].split('?')[0]

    db_creds = db_url.split('@')[0].gsub('postgres://', '')
    db_user = db_creds.split(':')[0]
    db_pass = db_creds.split(':')[1]

    db_params = []
    if db_url.include?("#{db_name}?")
      db_params << db_url.split("#{db_name}?")[1]
    end

    db_params << "user=#{db_user}"
    db_params << "password=#{db_pass}"
    db_params << "sslmode=require" if jdbc_protocol == 'postgresql'

    "jdbc:#{jdbc_protocol}://#{db_host}:#{db_port}/#{db_name}?#{db_params.join('&')}"
  end
end
