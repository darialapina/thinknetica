FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n} text"
  end

  factory :answer do
    question
    body
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    user
  end
end
