Ransack.configure do |c|
  # Change default search parameter key name.
  # Default key name is :q
  c.strip_whitespace = true
  c.ignore_unknown_conditions = false
end
