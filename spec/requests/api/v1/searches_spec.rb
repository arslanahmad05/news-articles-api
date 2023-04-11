require 'swagger_helper'

RSpec.describe "Api::V1::Searches", type: :request do
  path "/api/v1/searches?q={q}" do
    get 'article index' do
      tags 'article'
      consumes 'application/json'
      parameter name: 'q', :in => :path, :type => :string

      response '200', 'searches index' do
        let(:q) {'Imran Khan'}
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["articles"]).to be_present
        end
      end
    end
  end
end
