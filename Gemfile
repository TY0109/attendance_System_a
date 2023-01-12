source 'https://rubygems.org'

gem 'rails', '6.1.6'
gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'bootstrap-sass'
gem 'bcrypt'
gem 'faker'
gem 'rails-i18n'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'roo'
gem 'ransack'

# fly.ioデプロイ時に追加
gem 'mini_racer'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :production do
  gem 'pg' , '~> 1.1'

end


# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]