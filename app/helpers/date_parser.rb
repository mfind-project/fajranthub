module DateParser
  def formatted_end_date(date)
    date.strftime("godziny: %H:%M, dnia: %Y-%m-%d")
  end
end
