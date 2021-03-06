require 'rails_helper'

describe IssuesController do 
  
  before do
    @user_1 = User.create(
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
      name: "repository", 
      description: "Description of repository", 
      access: "public", 
      license: "none", 
      user_id: @user_1.id,
    )
    @issue = Issue.create(
      title: "Refactor tests",
      description: "Please do this",
      label: "Enhancement",
      user_create_id: @user_1.id,
      user_assign_id: @user_1.id,
      repository_id: @repository.id
    )
  end

  describe 'GET index' do
    it 'returns http status ok' do
        get :index
        expect(response).to have_http_status(:ok)
    end
    it 'render json with all issues' do
      get :index
      issues = JSON.parse(response.body)
      expect(issues.size).to eq 1
    end
  end

  describe 'GET show' do
    it 'returns http status ok' do
      get :show, params: { id: @issue }
      expect(response).to have_http_status(:ok)
    end
    it 'render the correct @issue' do
      get :show, params: { id: @issue }
      expected_issue = JSON.parse(response.body)
      expect(expected_issue["id"]).to eq(@issue.id)
    end
    it 'returns http status not found' do
      get :show, params: { id: 'xxx' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST create" do
    it "returns http status created" do
      post :create, params: {
        title: "Refactor tests",
        description: "Please do this",
        label: "Enhancement",
        user_create_id: @user_1.id,
        user_assign_id: @user_1.id,
        repository_id: @repository.id
      }
      expect(response.status).to eq(201)
      expect(response).to have_http_status(:created)
    end
    it "returns the created @issue" do
      post :create, params: {
        title: "Refactor tests",
        description: "Please do this",
        label: "Enhancement",
        user_create_id: @user_1.id,
        user_assign_id: @user_1.id,
        repository_id: @repository.id
      }
      expected_issue = JSON.parse(response.body)
      expect(expected_issue).to have_key("id")
      expect(expected_issue["title"]).to eq("Refactor tests")
    end
  end

  describe "PATCH update" do
    it "returns http status ok" do
      patch :update, params: { 
        id: @issue, 
        attributes: {
          title: "Refactor tests updated", 
          description: "Don't forget!"
          }
        }
      expect(response).to have_http_status(:ok)
    end
    it "returns the updated @issue" do
      patch :update, params: { 
        id: @issue, 
        attributes: {
          title: "Refactor tests updated",
          description: "Don't forget!"
          }
        }
      expected_issue = JSON.parse(response.body)
      expect(expected_issue["title"]).to eq("Refactor tests updated")
      expect(expected_issue["description"]).to eq("Don't forget!")
    end
  end

  describe "DELETE destroy" do
    it "returns http status no content" do
      delete :destroy, params: { id: @issue }
      expect(response).to have_http_status(:no_content)
    end
    it "returns empty body" do
      delete :destroy, params: { id: @issue }
      expect(response.body).to eq(" ")
    end
    it "decrement by 1 the total of issues" do
      expect do
        delete :destroy, params: { id: @issue }
      end.to change { Issue.count }.by(-1)
    end
    it "actually deletes the @issue" do
      delete :destroy, params: { id: @issue }
      deleted_issue = Issue.where(
        id: @issue.id
      )
      expect(deleted_issue.size).to eq(0)
    end
  end

end