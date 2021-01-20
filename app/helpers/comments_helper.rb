module CommentsHelper
  def count(num)
    "#{num} #{'comment'.pluralize(num)}"
  end
end
