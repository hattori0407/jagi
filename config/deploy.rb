lock '3.2.1'

set :application, 'jagi'
set :repo_url, 'https://github.com/Yinaura/jagi'
set :branch, 'deploy'
set :rbenv_ruby, '2.2.3'

set :deploy_to, '/var/www/app/jagi'
set :scm, :git

set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }
