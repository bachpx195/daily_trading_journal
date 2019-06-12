class PagesController < ApplicationController
  def show
    if valid_page?
      render template: "pages/#{params[:page]}"
    else
      render file: "public/404.html", status: :not_found
    end
  end

  private
  def valid_page?
    url = Rails.root + "app/views/pages/#{params[:page]}.html.erb"
    File.exist? Pathname.new(url)
  end
end
