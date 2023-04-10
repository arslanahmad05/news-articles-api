class Api::V1::SearchesController < ApplicationController

  def index
    @articles = SearchArticlesService.new("/everything", {q: params[:q]}).call
  end
end
