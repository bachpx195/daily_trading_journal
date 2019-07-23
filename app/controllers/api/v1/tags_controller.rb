class Api::V1::TagsController < ApplicationController
  def show
    @tags = Tag.order(:lft)
  end
end
