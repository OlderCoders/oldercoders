json.content do
  json.array! results do |result|
    json.target result[:target]
    json.insertion result[:insertion]
    json.html result[:html].present? ? result[:html].squish.gsub(/>\s</, '><') : nil
  end
end
