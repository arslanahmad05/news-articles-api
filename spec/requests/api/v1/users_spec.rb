require 'swagger_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:admin_user) { FactoryBot.create(:user) }
  before do
    admin_user.update(confirmed_at: Time.now, admin: true)
    admin_user.skip_password_validation = true
    sign_in admin_user
    @auth_headers = admin_user.create_new_auth_token
  end
  path "/api/v1/users" do
    get 'user index' do
      tags 'user'
      consumes 'application/json'
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string

      response '200', 'user index' do
        before do
          FactoryBot.create_list(:user, 10)
        end
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["users"]).to be_present
          expect(data["users"].count).to eq(11)
        end
      end

      response '401', 'unauthorized' do
        before do
          FactoryBot.create_list(:user, 10)
        end
        let(:'access-token') { "dhsdhskjdhksd" }
        let(:'client') { "jsdhjskdhkjsdhks" }
        let(:'uid') { "dsdhskd" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(data["errors"][0]).to eq "You need to sign in or sign up before continuing."
        end
      end
    end

    post 'user create' do
      tags 'user'
      consumes 'application/json'
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[email password password_confirmation]
      }
      response '201', 'user created' do

        let(:user) { { email: "user@user.com", password: 'test', password_confirmation: 'test' } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["user"]).to be_present
          expect(data["user"]["id"]).to be_present
          expect(data["user"]["email"]).to eq("user@user.com")
        end
      end

      response '401', 'unauthorized' do
        let(:user) { { email: "user@user.com", password: 'test', password_confirmation: 'test' } }
        let(:'access-token') { "dhsdhskjdhksd" }
        let(:'client') { "jsdhjskdhkjsdhks" }
        let(:'uid') { "dsdhskd" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(data["errors"][0]).to eq "You need to sign in or sign up before continuing."
        end
      end
    end
  end

  path "/api/v1/users/{id}" do
    get 'user Show' do
      tags 'user'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string

      response '200', 'user Show' do

        let(:user) { FactoryBot.create(:user) }
        let(:id) {user.id}
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["user"]).to be_present
          expect(data["user"]["id"]).to eq(user.id)

        end
      end

      response '401', 'unauthorized' do

        let(:user) { FactoryBot.create(:user) }
        let(:id) {user.id}
        let(:'access-token') { "dhsdhskjdhksd" }
        let(:'client') { "jsdhjskdhkjsdhks" }
        let(:'uid') { "dsdhskd" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(data["errors"][0]).to eq "You need to sign in or sign up before continuing."
        end
      end
    end

    put 'user update' do
      tags 'user'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[email password password_confirmation]
      }

      response '201', 'user update' do
        before do
          FactoryBot.create(:user)
        end
        let(:id) {User.first.id}
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }
        let(:user) { {email: "user_update@user.com"} }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["user"]).to be_present
          expect(data["user"]["id"]).to be_present
          expect(data["user"]["email"]).to eq("user_update@user.com")
        end
      end

      response '401', 'unauthorized' do

        before do
          FactoryBot.create(:user)
        end
        let(:id) {User.first.id}
        let(:user) { { email: "user@user.com", password: 'test', password_confirmation: 'test' } }
        let(:'access-token') { "dhsdhskjdhksd" }
        let(:'client') { "jsdhjskdhkjsdhks" }
        let(:'uid') { "dsdhskd" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(data["errors"][0]).to eq "You need to sign in or sign up before continuing."
        end
      end

      response '422', 'invalid request email can not be blank' do

        before do
          FactoryBot.create(:user)
        end
        let(:id) {User.first.id}
        let(:user) { { email: ''} }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["messaage"]).to be_present
          expect(data["messaage"]["email"]).to be_present
          expect(data["messaage"]["email"]).to eq(["can't be blank"])
        end
      end
    end
  end
end
