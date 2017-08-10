require 'rubygems'
require 'sinatra'
require 'mysql2'

## 本番環境とローカル環境でそれぞれの変数を設定。

helpers do
  def datetime(time)
    time.strftime("%Y年%m月%d日(日)%H:%M:%S")
  end
end

def where_am_i
    if settings.development?
      client = Mysql2::Client.new(host:"localhost", username:"root", database:"3ch_development")
    else
      client = Mysql2::Client.new(
      host:"us-cdbr-iron-east-05.cleardb.net",
      username:"b2452d9c721521",
      password:ENV['ENV_MYSQL_ENTER'],
      database:"heroku_cb96b0b97e89510"
      )
    end
end

client = where_am_i

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
  client = where_am_i
  results = client.query("SELECT * FROM threads ORDER BY last_post_at DESC")

  #スレッド一覧の取得
  @threads = []

  results.each do |result|
    @threads << result
  end
  # 全ての書き込みを取得する

  @all_responses = []

  @threads.each do |thread|
    thread_id = thread["id"]
    results = client.query("SELECT * FROM responses WHERE thread_id=#{thread_id}")
    @responses = []
    results.each do |result|
      @responses << result
    end
    @all_responses << @responses
  end

  @new_responses = []
  @count_from = []

  @all_responses.each do |res|
    if res.length > 10
      @new_responses << res[-9..-1]
      @count_from << res.length - 7
    else
      @new_responses << res
      @count_from << 2
    end
  end

  erb :board
end

##################スレ###########################

get '/threads/:id' do |id|

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
get '/new_thread' do
  erb :new
end

post '/post_thread' do
  results = client.query("SELECT * FROM threads")

  # 新しいスレッドを投稿

  if params[:text] == "" || params[:title] == ""
    erb "タイトルor本文が空っぽです。。。。。。。"
  else
    if params[:name] == ""
      # client.query("INSERT INTO THREADS (title, mail, text, board_id, created_at, updated_at) values ('#{params[:title]}', '#{params[:mail]}', '#{params[:text]}', 1, now(), now() )")
    else
      # client.query("INSERT INTO THREADS (title, name, mail, text, board_id, created_at, updated_at) values ('#{params[:title]}','#{params[:name]}', '#{params[:mail]}', '#{params[:text]}', 1, now(), now() )")
    end
    # redirect "/board"
  end

  'hello world'
end

#############レス#########################
get '/responses/new/:id' do |id|
  @id = id

  erb :res_new
end

post '/responses/post/:id' do |id|
  if params[:text] == ""
    erb "本文が空っぽです。。。。。。。"
  else
    #新しい書き込みを投稿
    client.query("UPDATE threads SET last_post_at=now() WHERE id='#{id}'") unless params[:mail] == "sage"

    if params[:name] == ""
      client.query("INSERT INTO RESPONSES (mail, text, thread_id, created_at, updated_at) values ('#{params[:mail]}', '#{params[:text]}', '#{id}', now(), now() )")
    else
      client.query("INSERT INTO RESPONSES (name, mail, text, thread_id, created_at, updated_at) values ('#{params[:name]}', '#{params[:mail]}', '#{params[:text]}', '#{id}', now(), now() )")
    end
    redirect "/threads/#{id}"
  end
end

## レス詳細ページ ##
get '/threads/:thread_id/:response_id' do

  #スレタイの取得
  results = client.query("SELECT * FROM threads WHERE id=#{params[:thread_id]} limit 1")
  @threads = []

  results.each do |result|
    @threads << result
  end

  #まずレス一覧を取得しておく
  results = client.query("SELECT * FROM responses WHERE thread_id=#{params[:thread_id]}")
  @responses = []
  results.each do |result|
    @responses << result
  end

  #要求されたレスがない場合
  if @responses.length <= params[:response_id].to_i - 2
    erb "そんなスレor書き込みないです。。。。。。。。"
  else
    # 必要なレスを取り出して、番号を付ける。

    if params[:response_id] == "1"
      @its_one = true
    else
      @res = @responses[params[:response_id].to_i - 2]
      @number = params[:response_id].to_i
    end

    erb :response
  end
end
