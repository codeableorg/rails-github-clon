require 'rails_helper'

describe BranchesController do
  
  before do
    @user = User.create(
      username: "diegotc86",
      name: "Diego Torres",
      birthday: "07/06/1986",
      email: "diegot86@gmail.com",
      bio: "Diego's bio here",
      company: "Diego's company",
      location: "LIMA - PERU",
      website: "www.diegotorres.dev"
    )
    @repository = Repository.create(
      name: 'repo1', 
      description: 'Description of repo1', 
      access: "public", 
      license: "none", 
      user_id: @user.id
    )
    @branch = Branch.create(
      name: '2',
      user_id: @user.id,
      repository_id: @repository.id
    )
  end

  describe 'GET index' do
    it 'returns http status ok' do
      get :index
      expect(response).to have_http_status(:ok)
    end
    it 'render json with all branches' do
      get :index
      branches = JSON.parse(response.body)
      expect(branches.size).to eq 1
    end
  end

  describe 'GET show' do
    it 'returns http status ok' do
      get :show, params: { id: @branch }
      expect(response).to have_http_status(:ok)
    end
    it 'render the correct branch' do
      get :show, params: { id: @branch }
      expected_branch = JSON.parse(response.body)
      expect(expected_branch["id"]).to eq(@branch.id)
    end
    it 'returns http status not found' do
      get :show, params: { id: 'xxx' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST create" do
    it "returns http status created" do
      post :create, params: { 
        name: "Nueva Rama",
        user_id: @user.id,
        repository_id: @repository.id  
      }
      expect(response.status).to eq(201)
      expect(response).to have_http_status(:created)
    end
    it "returns the created @branch" do
      post :create, params: { 
        name: "Rama_Feature1",
        user_id: @user.id ,
        repository_id: @repository.id 
      }
      expected_branch = JSON.parse(response.body)
      expect(expected_branch).to have_key("id")
      expect(expected_branch["name"]).to eq("Rama_Feature1")
    end
  end

  describe "PATCH update" do
    it "returns http status ok" do
      patch :update, params: {
        id: @branch.id,
        attributes: {
          name: "Feature1"
        }
      }
      expect(response).to have_http_status(:ok)
    end
    it "returns the updated @branch" do
      patch :update, params: {
        id: @branch.id,
        attributes: {
          name: "Feature2"
        }
      }
      expected_branch = JSON.parse(response.body)
      expect(expected_branch["name"]).to eq("Feature2")
    end
  end

  describe "DELETE destroy" do
    it "returns http status no content" do
      delete :destroy, params: { id: @branch }
      expect(response).to have_http_status(:no_content)
    end
    it "returns empty body" do
      delete :destroy, params: { id: @branch }
      expect(response.body).to eq(" ")
    end
    it "decrement by 1 the total of branches" do
      expect do
        delete :destroy, params: { id: @branch }
      end.to change { Branch.count }.by(-1)
    end
    it "actually delete the branches" do
      delete :destroy, params: { id: @branch }
      branches_deleted = Branch.where(
        id: @branch.id
      )
      expect(branches_deleted.size).to eq(0)
    end
  end

end