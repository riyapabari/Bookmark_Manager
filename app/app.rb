
ENV['RACK_ENV'] ||= "development"
require 'sinatra/base'
require_relative 'data_mapper_setup'


class BookmarkManager < Sinatra::Base
  
  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    erb(:index)
  end

  get '/users/sign_up' do
    erb(:'users/sign_up')
  end

  post '/users' do
    user = User.create(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    session[:user_id] = user.id
    redirect('/links') #personalised links later
  end

  get '/links' do
    @user = User.first(id: session[:user_id])
  	@links = Link.all
  	erb(:'links/index')
  end

  get '/links/new' do
  	erb(:'links/new')
  end
  
  post '/links' do
  	link = Link.new(url: params[:url], title: params[:title])
    params[:tags].gsub(' ', '').split(',').each {|tag| link.tags << Tag.first_or_create(name: tag) }
  	link.save
  	redirect('/links')
  end

  get '/tags/:tag' do
    tag = Tag.first(name: params[:tag])
    @links = tag ? tag.links : []
    erb(:'links/index')
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  run! if app_file == $0
end
