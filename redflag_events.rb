class String
  COLORS = {
    :yellow => "\033[33m",
    :blue => "\033[34m"
  }
  def colorize(color)
    "#{COLORS[color]}#{self}\033[0m"
  end
end

event "an event that always happens".colorize(:blue) do
  true
end

event "an event that naver happens" do
  false
end

event "an event that compare the two number".colorize(:yellow) do
  2 > 1
end
