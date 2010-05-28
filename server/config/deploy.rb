set :application, "casocial"
set :repository,  "https://urandom.de/svn/#{application}/server/trunk/"
set :use_sudo, false
set :user, 'hild'
set :scm_username, 'hild'
set :scm_auth_cache, true
set :local_scm_command, '/usr/bin/svn'
set :scm_command, '/usr/bin/svn'
set :deploy_to, "/srv/#{application}/"
set :domain, "casocial.urandom.de"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end