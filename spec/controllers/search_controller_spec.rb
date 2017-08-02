require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #search' do
    let!(:user) { create(:user, email: "test@test.com") }
    let!(:question) { create(:question, title: "test") }

    %w(All Answer Question User Comment).each do |attr|
      it "makes find request for #{attr}" do
        expect(Search).to receive(:find).with('test', attr)
        get :search, params: { query: 'test', for: attr}
      end
    end

    it 'assigns search results' do
      get :search, params: { query: 'test@test.com', for: 'Users'}
      expect(assigns(:results))
    end

    it 'renders search view' do
      get :search, params: { query: 'test@test.com', for: 'Users'}
      expect(response).to render_template :search
    end
  end
end
