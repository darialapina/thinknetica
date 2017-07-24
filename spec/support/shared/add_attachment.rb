shared_examples_for "Attachable" do
  background do
    sign_in(user)
    visit_path
  end

  scenario 'User adds file', js: true do
    within ".#{container_class}" do
      fill_the_form
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add file'
      all('input[type="file"]').last.set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end