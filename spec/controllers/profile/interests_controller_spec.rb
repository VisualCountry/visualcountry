require 'rails_helper'

describe Profile::InterestsController do
  let(:user) { create :user }

  before :each do
    sign_in user
  end

  describe 'GET "edit"' do
    it 'returns HTTP success' do
      get :edit
      expect(response).to be_success
    end
  end

  describe 'PATCH "update"' do
    let(:interests) { create_list :interest, 3 }

    before :each do
      interests
    end

    context 'with valid data' do
      it 'redirects to the profile_interests_path' do
        patch :update, {'profile'=>{'interest_ids'=>interests.map(&:id)}}
        expect(response).to redirect_to profile_interests_path
      end
    end
  end
end
