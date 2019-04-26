-module(rss_queue).
-compile(export_all).
-export([
    init/1,
    start/0,
    server/1,
    add_item/2,
    add_feed/2,
    get_all/1,
    add_item_to_q/3,
    add_item_to_q/2,
    test/1
]).
-define(TIMEOUT,10000).

-define(TRACE(Format, Data),
    io:format("[TRACE] ~p ~p:  " ++ Format, [?MODULE, self()] ++ Data)).

-define(INFO(Format, Data),
    error_logger:info_msg("~p ~p:  " ++ Format, [?MODULE, self()] ++ Data)).

init([])->
  start().

%% @doc Функция должна возвращать PID созданного процесса
start()->
  Q = [],
  spawn(?MODULE,server,[Q]).

%% @doc реализован цикл сервера процесса очереди RSS   
server(Q)->
  receive

%% @doc регистрация новых элементов в очереди
    {add_item,RSSItem} ->
      NewQ = add_item_to_q(RSSItem,Q) 
      ,server(NewQ);

%% @doc Другой процесс может отправить это сообщение очереди RSS,
%% чтобы получить все содержимое очереди.
    {get_all,ReqPid} ->
      ReqPid ! {self(),Q}
    ,?INFO("Sent rss items to ~p~n",[ReqPid]) 
      ,server(Q);
    _Msg -> io:format("Unknown msg~p~n",[_Msg])  
  end.

%% @doc упрощает процедуру отправки элемента в очередь
add_item(QPid,Item)->
  QPid ! {add_item,Item}
  ,ok.

%% @doc Эта функция должна извлекать все элементы из документа ленты, 
%% и отправлять все элементы по порядку в очередь
add_feed(QPid,RSS2Feed) when is_pid(QPid) ->
 Items=rss_parse:get_feed_items(RSS2Feed)
 ,[add_item(QPid,Item) || Item <- Items] 
,?INFO("Added N=~p items from the feed to ~p ~n",[length(Items),QPid]) 
 , ok.

%% @doc упрощает процедуру получения списка элементов ленты от процесса
get_all(QPid) when is_pid(QPid)->
  QPid!{get_all,self()}
  ,receive
    {QPid,Q} -> Q ;
    _Msg -> {error,unknown_msg,_Msg}
   after 
    ?TIMEOUT -> {error,timeout}
  end.

%% @doc добавление нового элемента в очередь
add_item_to_q(NewItem,L1,[])->
    ?INFO("New item ~p ~n",[self()]),
  L1++[NewItem];
%% @doc обновление элемента
add_item_to_q(NewItem,L1,L=[OldItem|Rest])->
  case rss_parse:compare_feed_items(OldItem,NewItem) of
    same -> 
      L1++L ;
    updated ->
        ?INFO("Updated item ~p ~n",[self()]),
      L1++Rest++[NewItem] ;
    different -> 
      add_item_to_q(NewItem,L1++[OldItem],Rest)
  end.
  
add_item_to_q(NewItem,Q)->
  add_item_to_q(NewItem,[],Q).

%% @doc функция тестирования лабы
test(RSSFile) ->
	{XML, _} = xmerl_scan:file(RSSFile),
	add_feed(self(), XML).