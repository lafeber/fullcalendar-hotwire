module EventsHelperTest
  def test_date_plus_time
    date = Date.new(2017, 1, 1)
    time = Time.new(2000, 1, 1, 12, 0, 0)
    assert_equal DateTime.new(2017, 1, 1, 12, 0, 0), date_plus_time(date, time)
  end
end
