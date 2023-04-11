require 'swagger_helper'

RSpec.describe "Api::V1::Authors", type: :request do
  let(:user) { FactoryBot.create(:user) }
  before do
    user.update(confirmed_at: Time.now)
    sign_in user
    @auth_headers = user.create_new_auth_token
  end
  path "/api/v1/authors" do
    get 'author index' do
      tags 'Author'
      consumes 'application/json'
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string

      response '200', 'author index' do
        before do
          FactoryBot.create_list(:author, 10)
        end
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["authors"]).to be_present
          expect(data["total_authors"]).to eq(10)
        end
      end

      response '401', 'unauthorized' do
        before do
          FactoryBot.create_list(:author, 10)
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

    post 'author create' do
      before do
        user.update(admin: true)
      end

      tags 'author'
      consumes 'application/json'
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string}
        },
        required: %w[name]
      }

      response '201', 'author index' do
        let(:author) { { name: 'Test Author' } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["author"]).to be_present
          expect(data["author"]["name"]).to eq('Test Author')
        end
      end


      response '401', 'unauthorized' do
        let(:author) { { name: "Test Author" } }
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
        let(:author) { { name: "" } }
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

  path "/api/v1//authors/{id}" do
    before do
        user.update(admin: true)
    end
    put 'author update' do
      tags 'author'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string}
        },
        required: %w[name]
      }

      response '201', 'author update' do
        before do
          FactoryBot.create(:author)
        end
        let(:id) {Author.first.id}
        let(:author) { { name: "Updated name" } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["author"]).to be_present
          expect(data["author"]["name"]).to eq('Updated name')
        end
      end

      response '401', 'unauthorized' do
        before do
          FactoryBot.create(:author)
        end
        let(:id) {Author.first.id}
        let(:author) { { name: "Updated name" } }
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
          FactoryBot.create(:author)
        end
        let(:id) {Author.first.id}
        let(:author) { { name: "" } }
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


    delete 'author destroy' do
      before do
        user.update(admin: true)
      end
      tags 'author'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string

      response '200', 'author destroy' do
        let(:author) { FactoryBot.create(:author) }
        let(:id) {author.id}
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["author"]).to be_present
          expect(data["author"]["id"]).to eq(author.id)
        end
      end
    end
  end
end
