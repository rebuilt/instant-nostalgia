class DateTools
  def self.date_range_populated?(params)
    params['start-date'].present? &&
      params['start-date']['start-date(1i)'].present? &&
      params['end-date'].present? &&
      params['end-date']['end-date(1i)'].present?
  end

  def self.date_populated?(params)
    params['day-selector'].present? && params['month-selector'].present?
  end

  def self.parse_date(info, prefix)
    year = info["#{prefix}-date(1i)"].to_i
    month = info["#{prefix}-date(2i)"].to_i
    day = info["#{prefix}-date(3i)"].to_i
    month = valid_month(prefix) if month == 0
    day, month, year = valid_day(day, month, year, prefix) if day == 0
    Date.new year, month, day
  end

  def self.valid_month(prefix)
    'start' == prefix ? 1 : 12
  end

  def self.valid_day(day, month, year, prefix)
    day = 1
    month, year = add_one_to_month(month, year) if prefix == 'end'

    [day, month, year]
  end

  def self.add_one_to_month(month, year)
    if month < 12
      month += 1
    else
      year += 1
      month = 1
    end
    [month, year]
  end
end
