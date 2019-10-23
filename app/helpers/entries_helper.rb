module EntriesHelper
  def entry_path(type = "entry", entry = nil, action = nil)
    send "#{format_sti(action, type, entry)}_path", entry
  end

  def format_sti(action, type, entry)
    handle = type.underscore.gsub '/', '_'
    action || entry ? "#{format_action(action)}#{handle}" : "#{handle.pluralize}"
  end

  def format_action(action)
    action ? "#{action}_" : ""
  end
end
