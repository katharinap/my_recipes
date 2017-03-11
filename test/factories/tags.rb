FactoryGirl.define do
  factory :tag, class: ActsAsTaggableOn::Tag do
    name 'mytag'
  end
end
