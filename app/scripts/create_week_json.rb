require 'date'

json_arr = []
first_date = Date.parse('2017-01-02')
last_date = Date.parse('2030-01-02')

while first_date <= last_date
  puts first_date
  json_arr << {"start_date": first_date.to_s, "end_date": (first_date + 6).to_s}
  first_date = first_date + 7
end

