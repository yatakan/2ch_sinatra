require 'sinatra'
require 'mysql2'

client = Mysql2::Client.new(host:"localhost", username:"root", database:"3ch_development")

get '/' do
  results = client.query("SELECT name FROM boards")

  @boards = []

  results.each do |result|
    @boards << result
  end

  erb :index
end

get '/board' do
  results = client.query("SELECT * FROM threads")

  #スレッド一覧の取得
  @threads = []

  results.each do |result|
    @threads << result
  end

  erb :board
end


get '/thread/:id' do |id|
  results = client.query("SELECT * FROM responses WHERE thread_id=#{id}")

  #スレッドに紐づく書き込み一覧の取得
  @responses = []

  results.each do |result|
    @responses << result
  end

  #スレタイの取得
  results = client.query("SELECT * FROM threads WHERE id=#{id} limit 1")

  @threads = []
  results.each do |result|
    @threads << result
  end

  erb :thread
end

get '/threads/new' do
  erb :new
end

post '/thread/post' do
  results = client.query("SELECT * FROM threads")

  #スレッド一覧の取得
  @threads = []

  results.each do |result|
    @threads << result
  end

  #新しいスレッドを投稿
  client.query("INSERT INTO THREADS (title, name, mail, text, board_id, created_at, updated_at) values ('#{params[:title]}','#{params[:name]}', '#{params[:mail]}', '#{params[:text
    ]}', 1, now(), now() )")
  erb :board
end

# get '/responses/new/:id' do |id|
#   @id = id
#   erb :res_new
# end

# post '/responses/post/:id' do |id|
#   #新しい書き込みを投稿
#   client.query("insert into responses (name, mail, text, thread_id, created_at, updated_at) values ('a', 'a', 'a', 1, now(), now())") 

#   results = client.query("SELECT * FROM threads")

#   #スレッド一覧の取得
#   @threads = []

#   results.each do |result|
#     @threads << result
#   end

#   erb :board
# end
