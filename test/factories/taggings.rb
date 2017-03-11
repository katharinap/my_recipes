FactoryGirl.define do
  factory :tagging, class: ActsAsTaggableOn::Tagging do
    tag
    association :taggable, factory: :recipe
  end
end
