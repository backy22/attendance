class StaticPagesController < ApplicationController
  def top
    if current_user
      redirect_to current_user
    end
  end
end
