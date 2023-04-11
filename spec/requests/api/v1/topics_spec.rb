require 'swagger_helper'

RSpec.describe "Api::V1::Topics", type: :request do
  let(:user) { FactoryBot.create(:user) }
  before do
    user.update(confirmed_at: Time.now)
    sign_in user
    @auth_headers = user.create_new_auth_token
  end
  path "/api/v1/topics" do
    get 'topic index' do
      tags 'topic'
      consumes 'application/json'
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string

      response '200', 'topic index' do
        before do
          FactoryBot.create_list(:topic, 10)
        end
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["topics"]).to be_present
          expect(data["total_topics"]).to eq(10)
        end
      end

      response '401', 'unauthorized' do
        before do
          FactoryBot.create_list(:topic, 10)
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

    post 'topic create' do
      before do
        user.update(admin: true)
      end

      tags 'topic'
      consumes 'application/json'
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string
      parameter name: :topic, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string}
        },
        required: %w[name]
      }

      response '201', 'topic index' do
        let(:topic) { { name: 'Test topic' } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["topic"]).to be_present
          expect(data["topic"]["name"]).to eq('Test topic')
        end
      end


      response '401', 'unauthorized' do
        let(:topic) { { name: "Test topic" } }
        let(:'access-token') { "dhsdhskjdhksd" }
        let(:'client') { "jsdhjskdhkjsdhks" }
        let(:'uid') { "dsdhskd" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(data["errors"][0]).to eq "You need to sign in or sign up before continuing."
        end
      end

      response '422', "invalid request name can't be blank" do
        let(:topic) { { name: "" } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to be_present
          expect(data["message"]["name"]).to be_present
          expect(data["message"]["name"]).to eq(["can't be blank"])
        end
      end
    end
  end

  path "/api/v1//topics/{id}" do
    before do
        user.update(admin: true)
    end
    put 'topic update' do
      tags 'topic'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string
      parameter name: :topic, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string}
        },
        required: %w[name]
      }

      response '201', 'topic update' do
        before do
          FactoryBot.create(:topic)
        end
        let(:id) {Topic.first.id}
        let(:topic) { { name: "Updated name" } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["topic"]).to be_present
          expect(data["topic"]["name"]).to eq('Updated name')
        end
      end

      response '401', 'unauthorized' do
        before do
          FactoryBot.create(:topic)
        end
        let(:id) {Topic.first.id}
        let(:topic) { { name: "Updated name" } }
        let(:'access-token') { "dhsdhskjdhksd" }
        let(:'client') { "jsdhjskdhkjsdhks" }
        let(:'uid') { "dsdhskd" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(data["errors"][0]).to eq "You need to sign in or sign up before continuing."
        end
      end

      response '422', "invalid request name can't be blank" do
        before do
          FactoryBot.create(:topic)
        end
        let(:id) {Topic.first.id}
        let(:topic) { { name: "" } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["messaage"]).to be_present
          expect(data["messaage"]["name"]).to be_present
          expect(data["messaage"]["name"]).to eq(["can't be blank"])
        end
      end
    end


    delete 'topic destroy' do
      before do
        user.update(admin: true)
      end
      tags 'topic'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string

      response '200', 'topic destroy' do
        let(:topic) { FactoryBot.create(:topic) }
        let(:id) {topic.id}
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["topic"]).to be_present
          expect(data["topic"]["id"]).to eq(topic.id)
        end
      end
    end
  end
end
