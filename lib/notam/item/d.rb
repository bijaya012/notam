# frozen_string_literal: true

module NOTAM

  # The D item contains timesheets to further narrow when exactly the NOTAM
  # is effective.
  class D < Item

    # Activity schedules
    #
    # @return [Array<NOTAM::Schedule>]
    attr_reader :schedules

    # @see NOTAM::Item#parse
    def parse
      base_date = AIXM.date(data[:effective_at])
      @schedules = cleanup(text).split(',').map do |string|
        Schedule.parse(string, base_date: base_date)
      end
      self
    end

    # Whether the D item is active at the given time.
    #
    # @param at [Time]
    # @return [Boolean]
    def active?(at:)
      schedules.any? { _1.active?(at: at, xy: data[:center_point]) }
    end

    # Calculate the relevant, consolidated schedules for five days.
    #
    # The beginning of the five day window is either today (if +effective_at+
    # is in the past) or +effective_at+ (otherwise).
    #
    # @return [Array<NOTAM::Schedule>]
    def five_day_schedules
      schedules.map do |schedule|
        schedule
          .slice(AIXM.date(five_day_base), AIXM.date(five_day_base + 4 * 86_400))
          .resolve(on: AIXM.date(five_day_base), xy: data[:center_point])
      end.map { _1 unless _1.empty? }.compact
    end

    # @see NOTAM::Item#merge
    def merge
      super(:schedules, :five_day_schedules)
    end

    private

    # @return [Time]
    def five_day_base
      @five_day_base ||= [data[:effective_at], Time.now.utc.round].max
    end

    # @params string [String] string to clean up
    # @return [String]
    def cleanup(string)
      string
        .gsub(/\s+/, ' ')           # collapse whitespaces to single space
        .gsub(/ ?([-,]) ?/, '\1')   # remove spaces around dashes and commas
        .sub(/\AD\) /, '')          # remove item identifier
        .strip
    end

  end
end
