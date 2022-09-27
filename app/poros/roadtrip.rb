# frozen_string_literal: true

class Roadtrip
  attr_reader :start_city, :end_city, :time, :hrs, :travel_time

  def initialize(data)
    if data[:route][:locations]
      origin = data[:route][:locations].first
      @start_city = "#{origin[:adminArea5]}, #{origin[:adminArea3]}"
      destination = data[:route][:locations].last
      @end_city = "#{destination[:adminArea5]}, #{destination[:adminArea3]}"
    end
    @time = data[:route][:time]
    @hrs = time.to_i / 3600
    mins = (time.to_i / 60) % 60
    @travel_time = "#{hrs} hours, #{mins} minutes" if time
  end
end
