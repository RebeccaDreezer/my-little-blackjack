Fabricator(:user) do
  name "rebecca"
  email "rebecca_#{Time.now.to_i}@rebecca.com"
  password "rebecca"
  password_confirmation "rebecca"
end
