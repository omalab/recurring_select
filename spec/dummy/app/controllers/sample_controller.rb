require 'pp'
class SampleController < ApplicationController

  def index
  end

  def create_fake_model
    temp={}
    render :text => params["fake_model"]["current_custom_rule"].inspect
  end

end
