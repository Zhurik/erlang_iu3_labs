-module(hello).
-export([server/0]).

server() ->
    receive
        hello -> % Общее приветствие
            io:format("~nПривет мир!~n"),
            server();
        {hello, Name} -> % Персональное приветствие
            io:format("~nПривет, ~w!~n", [Name]),
            server()
    end.