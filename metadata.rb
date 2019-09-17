#
# Copyright 2015-2017, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "application_ruby"
version "4.1.1"
description "A Chef cookbook for deploying application code."
long_description "# Application_Ruby Cookbook\n\n[![Build Status](https://img.shields.io/travis/poise/application_ruby.svg)](https://travis-ci.org/poise/application_ruby)\n[![Gem Version](https://img.shields.io/gem/v/poise-application-ruby.svg)](https://rubygems.org/gems/poise-application-ruby)\n[![Cookbook Version](https://img.shields.io/cookbook/v/application_ruby.svg)](https://supermarket.chef.io/cookbooks/application_ruby)\n[![Coverage](https://img.shields.io/codecov/c/github/poise/application_ruby.svg)](https://codecov.io/github/poise/application_ruby)\n[![Gemnasium](https://img.shields.io/gemnasium/poise/application_ruby.svg)](https://gemnasium.com/poise/application_ruby)\n[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)\n\nA [Chef](https://www.chef.io/) cookbook to deploy Ruby applications.\n\n## Quick Start\n\nTo deploy a Rails application from git:\n\n```ruby\napplication '/srv/myapp' do\n  git 'https://github.com/example/myapp.git'\n  bundle_install do\n    deployment true\n    without %w{development test}\n  end\n  rails do\n    database 'sqlite3:///db.sqlite3'\n    secret_token 'd78fe08df56c9'\n    migrate true\n  end\n  unicorn do\n    port 8000\n  end\nend\n```\n\n## Requirements\n\nChef 12.1 or newer is required.\n\n## Resources\n\n### `application_bundle_install`\n\nThe `application_bundle_install` resource installs gems using Bundler for a\ndeployment.\n\n```ruby\napplication '/srv/myapp' do\n  bundle_install do\n    deployment true\n    without %w{development test}\n  end\nend\n```\n\nAll actions and properties are the same as the [`bundle_install` resource](https://github.com/poise/poise-ruby#bundle_install).\n\n### `application_puma`\n\nThe `application_puma` resource creates a service for `puma`.\n\n```ruby\napplication '/srv/myapp' do\n  puma do\n    port 8000\n  end\nend\n```\n\n#### Actions\n\n* `:enable` – Create, enable and start the service. *(default)*\n* `:disable` – Stop, disable, and destroy the service.\n* `:start` – Start the service.\n* `:stop` – Stop the service.\n* `:restart` – Stop and then start the service.\n* `:reload` – Send the configured reload signal to the service.\n\n#### Properties\n\n* `path` – Base path for the application. *(name attribute)*\n* `port` – Port to listen on. *(default: 80)*\n* `service_name` – Name of the service to create. *(default: auto-detect)*\n* `user` – User to run the service as. *(default: application owner)*\n\n### `application_rackup`\n\nThe `application_rackup` resource creates a service for `rackup`.\n\n```ruby\napplication '/srv/myapp' do\n  rackup do\n    port 8000\n  end\nend\n```\n\n#### Actions\n\n* `:enable` – Create, enable and start the service. *(default)*\n* `:disable` – Stop, disable, and destroy the service.\n* `:start` – Start the service.\n* `:stop` – Stop the service.\n* `:restart` – Stop and then start the service.\n* `:reload` – Send the configured reload signal to the service.\n\n#### Properties\n\n* `path` – Base path for the application. *(name attribute)*\n* `port` – Port to listen on. *(default: 80)*\n* `service_name` – Name of the service to create. *(default: auto-detect)*\n# `user` – User to run the service as. *(default: application owner)*\n\n### `application_rails`\n\nThe `application_rails` resource\n\n```ruby\napplication '/srv/myapp' do\n  rails do\n    database 'sqlite3:///db.sqlite3'\n    secret_token 'd78fe08df56c9'\n    migrate true\n  end\nend\n```\n\n#### Actions\n\n* `:deploy` – Create config files and run required deployments steps. *(default)*\n\n#### Properties\n\n* `path` – Base path for the application. *(name attribute)*\n* `app_module` – Top-level application module. Only needed for the :initializer\n  style of secret token configuration. *(default: auto-detect)*\n* `database` – Database settings for Rails. See [the database section\n  below](#database-parameters) for more information. *(option collector)*\n* `migrate` – Run database migrations. *(default: false)*\n* `precompile_assets` – Run `rake assets:precompile`. *(default: auto-detect)()\n* `rails_env` – Rails environment name. *(default: node.chef_environment)*\n* `secret_token` – Secret token for Rails session verification et al.\n* `secrets_mode` – Secrets configuration mode. Set to `:yaml` to generate a\n  Rails 4.2 secrets.yml. Set to `:initializer` to update\n  `config/initializers/secret_token.rb`. *(default: auto-detect)*\n\n**NOTE:** At this time `secrets_mode :initializer` is not implemented.\n\n#### Database Parameters\n\nThe database parameters can be set in three ways: URL, hash, and block.\n\nIf you have a single URL for the parameters, you can pass it directly to\n`database`:\n\n```ruby\nrails do\n  database 'mysql2://myuser@dbhost/myapp'\nend\n```\n\nPassing a single URL will also set the `$DATABASE_URL` environment variable\nautomatically for compatibility with Heroku-based applications.\n\nAs with other option collector resources, you can pass individual settings as\neither a hash or block:\n\n```ruby\nrails do\n  database do\n    adapter 'mysql2'\n    username 'myuser'\n    host 'dbhost'\n    database 'myapp'\n  end\nend\n\nrails do\n  database({\n    adapter: 'mysql2',\n    username: 'myuser',\n    host: 'dbhost',\n    database: 'myapp',\n  })\nend\n```\n\n### `application_ruby`\n\nThe `application_ruby` resource installs a Ruby runtime for the deployment.\n\n```ruby\napplication '/srv/myapp' do\n  ruby '2.2'\nend\n```\n\nAll actions and properties are the same as the [`ruby_runtime` resource](https://github.com/poise/poise-ruby#ruby_runtime).\n\n### `application_ruby_gem`\n\nThe `application_ruby_gem` resource installs Ruby gems for the deployment.\n\n```ruby\napplication '/srv/myapp' do\n  ruby_gem 'rake'\nend\n```\n\nAll actions and properties are the same as the [`ruby_gem` resource](https://github.com/poise/poise-ruby#ruby_gem).\n\n### `application_ruby_execute`\n\nThe `application_ruby_execute` resource runs Ruby commands for the deployment.\n\n```ruby\napplication '/srv/myapp' do\n  ruby_execute 'rake'\nend\n```\n\nAll actions and properties are the same as the [`ruby_execute` resource](https://github.com/poise/poise-ruby#ruby_execute),\nexcept that the `cwd`, `environment`, `group`, and `user` properties default to\nthe application-level data if not specified.\n\n### `application_thin`\n\nThe `application_thin` resource creates a service for `thin`.\n\n```ruby\napplication '/srv/myapp' do\n  thin do\n    port 8000\n  end\nend\n```\n\n#### Actions\n\n* `:enable` – Create, enable and start the service. *(default)*\n* `:disable` – Stop, disable, and destroy the service.\n* `:start` – Start the service.\n* `:stop` – Stop the service.\n* `:restart` – Stop and then start the service.\n* `:reload` – Send the configured reload signal to the service.\n\n#### Properties\n\n* `path` – Base path for the application. *(name attribute)*\n* `config_path` – Path to a Thin configuration file.\n* `port` – Port to listen on. *(default: 80)*\n* `service_name` – Name of the service to create. *(default: auto-detect)*\n* `user` – User to run the service as. *(default: application owner)*\n\n### `application_unicorn`\n\nThe `application_unicorn` resource creates a service for `unicorn`.\n\n```ruby\napplication '/srv/myapp' do\n  unicorn do\n    port 8000\n  end\nend\n```\n\n#### Actions\n\n* `:enable` – Create, enable and start the service. *(default)*\n* `:disable` – Stop, disable, and destroy the service.\n* `:start` – Start the service.\n* `:stop` – Stop the service.\n* `:restart` – Stop and then start the service.\n* `:reload` – Send the configured reload signal to the service.\n\n#### Properties\n\n* `path` – Base path for the application. *(name attribute)*\n* `port` – Port to listen on. *(default: 80)*\n* `service_name` – Name of the service to create. *(default: auto-detect)*\n* `user` – User to run the service as. *(default: application owner)*\n\n## Sponsors\n\nDevelopment sponsored by [Chef Software](https://www.chef.io/), [Symonds & Son](http://symondsandson.com/), and [Orion](https://www.orionlabs.co/).\n\nThe Poise test server infrastructure is sponsored by [Rackspace](https://rackspace.com/).\n\n## License\n\nCopyright 2015-2017, Noah Kantrowitz\n\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\nhttp://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.\n"
maintainer "Noah Kantrowitz"
maintainer_email "noah@coderanger.net"
source_url "https://github.com/poise/application_ruby" if defined?(source_url)
issues_url "https://github.com/poise/application_ruby/issues" if defined?(issues_url)
license "Apache-2.0"
depends "poise", "~> 2.0"
depends "application", "~> 5.0"
depends "poise-ruby", "~> 2.1"
depends "poise-service", "~> 1.0"
chef_version ">= 12.1" if defined?(chef_version)
supports "aix"
supports "amazon"
supports "arch"
supports "centos"
supports "chefspec"
supports "debian"
supports "dragonfly4"
supports "fedora"
supports "freebsd"
supports "gentoo"
supports "ios_xr"
supports "mac_os_x"
supports "nexus"
supports "omnios"
supports "openbsd"
supports "opensuse"
supports "oracle"
supports "raspbian"
supports "redhat"
supports "slackware"
supports "smartos"
supports "solaris2"
supports "suse"
supports "ubuntu"
supports "windows"
