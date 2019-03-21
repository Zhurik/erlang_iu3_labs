-module(world).
-export([hello/0]).
% Выводим строку
hello() -> io:format("Дарова!~n").
