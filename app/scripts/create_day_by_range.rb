require 'date'

json_arr = []
first_date = Date.parse('2020-11-01')
last_date = Date.parse('2020-11-30')

while first_date <= last_date
  puts first_date
  json_arr << first_date.strftime("%Y-%m-%d")
  first_date = first_date + 1
end
