class ApplicationController < ActionController::Base
  # Любой пользователь должен быть Зарегистрован/Djqnb
  before_action :authenticate_user!



end
