shared_examples_for "Commentable" do
  scenario 'Unauthenticated user tries to add comment' do
    visit question_path(question)

    within ".#{container_class}" do
      expect(page).not_to have_content 'Add a comment'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees add comment link' do
      within ".#{container_class}" do
        expect(page).to have_content 'Add a comment'
      end
    end

    scenario 'leaves a valid comment', js: true do
      within ".#{container_class}" do
        fill_in 'Comment', with: 'My comment'
        click_on 'Create'

        expect(page).to have_content 'My comment'
        expect(page).not_to have_content "Body can't be blank"
      end
    end

    scenario 'leaves an invalid comment', js: true do
      within ".#{container_class}" do
        fill_in 'Comment', with: nil
        click_on 'Create'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'mulitple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".#{container_class}" do
          fill_in 'Comment', with: 'My comment'
          click_on 'Create'

          expect(page).to have_content 'My comment'
          expect(page).not_to have_content "Body can't be blank"
        end
      end

      Capybara.using_session('guest') do
        within ".#{container_class}" do
          expect(page).to have_content 'My comment'
        end
      end
    end
  end
end