module ApplicationHelper
  def format_date(date)
    date.strftime('%m-%d %a')
  end
end
