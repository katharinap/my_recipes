# frozen_string_literal: true
namespace :postgres do
  desc 'kill running postgres connections'
  task kill_postgres_connections: :environment do
    db_name = "#{File.basename(Rails.root)}_#{Rails.env}"
    sh = <<EOF
ps xa \
  | grep postgres: \
  | grep #{db_name} \
  | grep -v grep \
  | awk '{print $1}' \
  | xargs kill
EOF
    puts `#{sh}`
  end
end
