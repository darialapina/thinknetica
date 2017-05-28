FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n} text"
  end

  factory :answer do
    question
    body
    user
    is_best false
  end

  factory :invalid_answer, class: 'Answer' do
    question
    body nil
    user
    is_best false
  end
end
