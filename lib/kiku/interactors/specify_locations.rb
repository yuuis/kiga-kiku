# frozen_string_literal: true

require 'hanami/interactor'

class SpecifyLocations
  include Hanami::Interactor

  def call(user_id)
    user = UserRepository.new.find(user_id)
    locations = LocationRepository.new.find_all_by_user_id(user_id)

    return nil if user.nil? || locations.empty?

    office = specify_office(locations)
    home = specify_home(locations)

    store(user, office, home)
  end

  private

  def specify_office(locations)
    # TODO: 時間決め打ち。よくない
    office_locations = locations.select { |location| location.created_at.hour + 9 > 13 && location.created_at.hour + 9 < 18 }

    return nil if office_locations.empty?

    lat = office_locations.max_by { |location| office_locations.count(location.latitude) }.latitude
    lng = office_locations.max_by { |location| office_locations.count(location.longitude) }.longitude

    { lat: lat, lng: lng }
  end

  def specify_home(locations)
    # TODO: 時間決め打ち。よくない
    home_locations = locations.select { |location| location.created_at.hour + 9 > 0 && location.created_at.hour + 9 < 5 }

    return nil if home_locations.empty?

    lat = home_locations.max_by { |location| home_locations.count(location.latitude) }.latitude
    lng = home_locations.max_by { |location| home_locations.count(location.longitude) }.longitude

    { lat: lat, lng: lng }
  end

  def store(user, office, home)
    if office.nil?
      UserRepository.new.update(
        user.id,
        home_lat: home[:lat],
        home_lng: home[:lng]
      )
    elsif home.nil?
      UserRepository.new.update(
        user.id,
        office_lat: office[:lat],
        office_lng: office[:lng]
      )
    else
      UserRepository.new.update(
        user.id,
        home_lat: home[:lat],
        home_lng: home[:lng],
        office_lat: office[:lat],
        office_lng: office[:lng]
      )
    end
  end
end
