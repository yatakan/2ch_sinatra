require 'Mechanize'

all_pages = ""

agent = Mechanize.new

for i in 1..261 do
  current_page = agent.get("https://hr.tech-camp.in/jobs/" + i)
  all_pages << current_page.page("html")
end

all_pages.each do |page|
  puts page.inner_text
end
