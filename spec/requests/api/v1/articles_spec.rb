require 'swagger_helper'

RSpec.describe "Api::V1::Articles", type: :request do
  let(:user) { FactoryBot.create(:user) }
  before do
    user.update(confirmed_at: Time.now)
    sign_in user
    @auth_headers = user.create_new_auth_token
  end
  path "/api/v1/articles" do
    get 'article index' do
      tags 'article'
      consumes 'application/json'
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string

      response '200', 'article index' do
        before do
          FactoryBot.create_list(:article, 10)
        end
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["articles"]).to be_present
          expect(data["total_articles"]).to eq(10)
        end
      end

      response '401', 'unarticleized' do
        before do
          FactoryBot.create_list(:article, 10)
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

    post 'article create' do
      before do
        user.update(admin: true)
      end

      tags 'article'
      consumes 'application/json'
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string
      parameter name: :article, in: :body, schema: {
        type: :object,
        properties: {
          title: {type: :string},
          description: {type: :text},
          content: {type: :text},
          article_url: {type: :string},
          published_at: {type: :datetime},

        },
        required: %w[title description content article_url published_at]
      }

      response '201', 'article index' do
        let(:article) { { title: 'Test article', description: 'Test Description', content: 'Test Content', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["article"]).to be_present
          expect(data["article"]["title"]).to eq('Test article')
          expect(data["article"]["description"]).to eq('Test Description')
          expect(data["article"]["content"]).to eq('Test Content')
          expect(data["article"]["url"]).to eq('test@article.com')
        end
      end


      response '401', 'unarticleized' do
        let(:article) { { title: 'Test article', description: 'Test Description', content: 'Test Content', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { "dhsdhskjdhksd" }
        let(:'client') { "jsdhjskdhkjsdhks" }
        let(:'uid') { "dsdhskd" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(data["errors"][0]).to eq "You need to sign in or sign up before continuing."
        end
      end

      response '422', "invalid request title can't be blank" do
        let(:article) { { title: '', description: 'Test Description', content: 'Test Content', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to be_present
          expect(data["message"]["title"]).to be_present
          expect(data["message"]["title"]).to eq(["can't be blank"])
        end
      end

      response '422', "invalid request description can't be blank" do
        let(:article) { { title: 'Test Article', description: '', content: 'Test Content', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to be_present
          expect(data["message"]["description"]).to be_present
          expect(data["message"]["description"]).to eq(["can't be blank"])
        end
      end

      response '422', "invalid request content can't be blank" do
        let(:article) { { title: 'Test Article', description: 'Test Description', content: '', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to be_present
          expect(data["message"]["content"]).to be_present
          expect(data["message"]["content"]).to eq(["can't be blank"])
        end
      end

      response '422', "invalid request article_url can't be blank" do
        let(:article) { { title: 'Test Article', description: 'Test Description', content: 'Test Content', article_url: '', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to be_present
          expect(data["message"]["article_url"]).to be_present
          expect(data["message"]["article_url"]).to eq(["can't be blank"])
        end
      end

      response '422', "invalid request published_at can't be blank" do
        let(:article) { { title: 'Test Article', description: 'Test Description', content: 'Test Content', article_url: 'test@article.com', published_at: '' } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to be_present
          expect(data["message"]["published_at"]).to be_present
          expect(data["message"]["published_at"]).to eq(["can't be blank"])
        end
      end
    end
  end

  path "/api/v1//articles/{id}" do
    before do
        user.update(admin: true)
    end
    put 'article update' do
      tags 'article'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string
      parameter name: :article, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string}
        },
        required: %w[name]
      }

      response '201', 'article update' do
        before do
          FactoryBot.create(:article)
        end
        let(:id) {Article.first.id}
        let(:article) { { title: 'Test article', description: 'Test Description', content: 'Test Content', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["article"]).to be_present
          expect(data["article"]["title"]).to eq('Test article')
          expect(data["article"]["description"]).to eq('Test Description')
          expect(data["article"]["content"]).to eq('Test Content')
          expect(data["article"]["url"]).to eq('test@article.com')
        end
      end

      response '401', 'unarticleized' do
        before do
          FactoryBot.create(:article)
        end
        let(:id) {Article.first.id}
        let(:article) { { name: "Updated name" } }
        let(:'access-token') { "dhsdhskjdhksd" }
        let(:'client') { "jsdhjskdhkjsdhks" }
        let(:'uid') { "dsdhskd" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["errors"]).to be_present
          expect(data["errors"][0]).to eq "You need to sign in or sign up before continuing."
        end
      end

      response '422', "invalid request title can't be blank" do
        before do
          FactoryBot.create(:article)
        end
        let(:id) {Article.first.id}
        let(:article) { { title: '', description: 'Test Description', content: 'Test Content', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["messaage"]).to be_present
          expect(data["messaage"]["title"]).to be_present
          expect(data["messaage"]["title"]).to eq(["can't be blank"])
        end
      end

      response '422', "invalid request description can't be blank" do
        before do
          FactoryBot.create(:article)
        end
        let(:id) {Article.first.id}
        let(:article) { { title: 'Test Article', description: '', content: 'Test Content', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["messaage"]).to be_present
          expect(data["messaage"]["description"]).to be_present
          expect(data["messaage"]["description"]).to eq(["can't be blank"])
        end
      end

      response '422', "invalid request content can't be blank" do
        before do
          FactoryBot.create(:article)
        end
        let(:id) {Article.first.id}
        let(:article) { { title: 'Test Article', description: 'Test Description', content: '', article_url: 'test@article.com', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["messaage"]).to be_present
          expect(data["messaage"]["content"]).to be_present
          expect(data["messaage"]["content"]).to eq(["can't be blank"])
        end
      end

      response '422', "invalid request article_url can't be blank" do
         before do
          FactoryBot.create(:article)
        end
        let(:id) {Article.first.id}
        let(:article) { { title: 'Test Article', description: 'Test Description', content: 'Test Content', article_url: '', published_at: Time.now } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["messaage"]).to be_present
          expect(data["messaage"]["article_url"]).to be_present
          expect(data["messaage"]["article_url"]).to eq(["can't be blank"])
        end
      end

      response '422', "invalid request published_at can't be blank" do
         before do
          FactoryBot.create(:article)
        end
        let(:id) {Article.first.id}
        let(:article) { { title: 'Test Article', description: 'Test Description', content: 'Test Content', article_url: 'test@article.com', published_at: '' } }
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["messaage"]).to be_present
          expect(data["messaage"]["published_at"]).to be_present
          expect(data["messaage"]["published_at"]).to eq(["can't be blank"])
        end
      end
    end


    delete 'article destroy' do
      before do
        user.update(admin: true)
      end
      tags 'article'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: 'access-token', :in => :header, :type => :string
      parameter name: 'client', :in => :header, :type => :string
      parameter name: 'uid', :in => :header, :type => :string

      response '200', 'article destroy' do
        let(:article) { FactoryBot.create(:article) }
        let(:id) {article.id}
        let(:'access-token') { @auth_headers["access-token"] }
        let(:'client') { @auth_headers["client"] }
        let(:'uid') { @auth_headers["uid"] }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["article"]).to be_present
          expect(data["article"]["id"]).to eq(article.id)
        end
      end
    end
  end
end
