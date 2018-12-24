class ErrorsController < ApplicationController
  def not_found
    render file: "/public/404", status: :not_found
  end
end
