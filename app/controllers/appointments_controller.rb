class AppointmentsController < ApplicationController
  before_filter :load_startups

  def index

  end

  def table
    render :index, layout: false
  end

  def load_startups
    startups = Doodle.new(ENV['DATA_URL']).read
    startups = startups.each_slice(startups.length/2).to_a
    @startups = startups[0].zip(startups[1]).flatten
  end
end
