require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  it do
     subject.user = FactoryGirl.build(:user)
     is_expected.to validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type)
  end

  it { should validate_inclusion_of(:votable_type).in_array(['Question', 'Answer']) }
  it { should validate_inclusion_of(:value).in_array([1,-1]) }
end
