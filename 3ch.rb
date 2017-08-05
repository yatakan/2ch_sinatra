require 'sinatra'
require 'mysql2'

client = Mysql2::Client.new(host:"localhost", username:"root", database:"3ch_development")

################ルーーーーーーーーーーーート#####################
get '/' do
  results = client.query("SELECT name FROM boards")

  @boards = []

  results.each do |result|
    @boards << result
  end

  erb :index
end

#####################板##############################
get '/board' do
  results = client.query("SELECT * FROM threads")

  #スレッド一覧の取得
  @threads = []

  results.each do |result|
    @threads << result
  end

  #全ての書き込みを取得する

  @all_responses = []

  @threads.each do |thread|
    thread_id = thread["id"]
    results = client.query("SELECT * FROM responses WHERE thread_id=#{thread_id}")
    @responses = []
    results.each do |result|
      @responses << result
    end
    @all_responses << @responses
    puts @all_responses
  end

  erb :board
end

##################スレ###########################

get '/thread/:id' do |id|

  #スレッド内の書き込みを取得する
  results = client.query("SELECT * FROM responses WHERE thread_id=#{id}")
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

##########スレ立て#####################
get '/threads/new' do
  erb :new
end

post '/thread/post' do
  results = client.query("SELECT * FROM threads")

  #新しいスレッドを投稿
  client.query("INSERT INTO THREADS (title, name, mail, text, board_id, created_at, updated_at) values ('#{params[:title]}','#{params[:name]}', '#{params[:mail]}', '#{params[:text]}', 1, now(), now() )")

  redirect "/board"
end

#############レス#########################
get '/responses/new/:id' do |id|
  @id = id
  puts @id
  erb :res_new
end

post '/responses/post/:id' do |id|
  #新しい書き込みを投稿
  client.query("INSERT INTO RESPONSES (name, mail, text, thread_id, created_at, updated_at) values ('#{params[:name]}', '#{params[:mail]}', '#{params[:text]}', '#{id}', now(), now() )")

  redirect "/thread/#{id}"
end
