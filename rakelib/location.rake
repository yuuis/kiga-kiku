namespace :location do
  desc 'specify office and home for all users'
  task :specify do
    require_relative '../batch/specify_locations_for_all_users'
    SpecifyLocationsForAllUsers.new.call
  end
end
