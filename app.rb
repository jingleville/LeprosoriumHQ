#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter: 'sqlite3', database: 'leprosorium.sqlite3'}

class Author < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	has_many :comments, dependent: :destroy

	validates :name, presence: true
end

class Post < ActiveRecord::Base
	has_many :comments, dependent: :destroy
	belongs_to :author

	validates :content, presence: true
end

class Comment < ActiveRecord::Base
	belongs_to :author

	validates :content, presence: true
end

get '/' do
	@posts = Post.order 'created_at DESC'
	@authors = Author.all
	erb :index
end

post '/' do 
	@posts = Post.order 'created_at DESC'
	erb :index
end

get '/author/:id' do
	@authors = Author.all
	@comments = Comment.all

	@author = Author.find(params[:id])
	@posts = @author.posts
	@author = @author.name
	erb :author
end

post '/author/:id' do
	@authors = Author.all
	@comments = Comment.all

	@author = Author.find(params[:id])
	@posts = @author.posts
	@author = @author.name
	
	@post = Post.find params[:post_id]

	comment = @post.comments.new

	comment.author_id = Author.where name:(params[:author]).id
	comment.post_id = params[:post_id]
	comment.content = params[:content]
	

	erb :author
end 

get '/new' do
	erb :new
end

post '/new' do 
	Author.create name: params[:author] if not Author.where(name: params[:author]).exists?

	@author = Author.find_by name: params[:author]

	@post = @author.posts.new
	@post.content = params[:content]
	@post.author_id = @author.id
	@post.save

	@posts = Post.order 'created_at DESC'

	redirect '/'
end

get '/authors' do
	@authors = Author.order "created_at DESC"
	erb :authors
end

post '/authors' do 
	erb :author
end





# '/'
# posts

# '/new'
# create new post

# '/authors'
# authors, click on author return /author with all posts by author

#when create comment check if author exists, if not add new author