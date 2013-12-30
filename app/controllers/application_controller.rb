class ApplicationController < ActionController::Base
  before_filter :authenticate_user! 
  protect_from_forgery
end

def my_text_area(form, method, options = {})
  form.text_area(method, options)
end
