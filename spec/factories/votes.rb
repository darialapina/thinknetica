FactoryGirl.define do
  factory :vote do
    user
    # votable_id 1
    # votable_type "Answer"
    value 1
  end

  factory :invalid_vote, class: 'Vote' do
		user
    value 2
  end
end
