FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n} text"
  end

  factory :answer do
    question
    body
    user
    best false
  end

  factory :invalid_answer, class: 'Answer' do
    question
    body nil
    user
    best false
  end
end
