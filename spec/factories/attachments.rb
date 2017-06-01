FactoryGirl.define do
  factory :attachment do
    # file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'brands', 'logos', 'logo_image.jpg'), 'image/jpg') }
    file Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/spec_helper.rb"))
  end
end
