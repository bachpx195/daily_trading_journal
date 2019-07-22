class Api::V1::TagsController < ApplicationController
  def show
    @tags = Tag.all
  end
end
