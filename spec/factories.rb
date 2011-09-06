Factory.define :user do |f|
  f.sequence(:email) { |n| "foo#{n}@boo.com" }
  f.password "secret"
end