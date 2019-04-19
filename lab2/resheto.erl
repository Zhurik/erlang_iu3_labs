-module(resheto).

-export([generate/1, generate2/3]).
-export([resheto1/0, resheto2/2]).

%%
%% Use processes/0 to check if there is any process leak
%% 

resheto2(0, InvalidPid) ->
    receive 
        P -> resheto2(P, InvalidPid)
    end; 

% Начинаем отсюда
resheto2(P, NextPid) when is_pid(NextPid) ->
    receive 
        {done, From} ->
            NextPid ! {done, self()},
            receive
                LstOfRes -> 
                    From ! [P] ++ LstOfRes 
            end;
        N when N rem P == 0 -> 
            resheto2(P, NextPid);
        N when N rem P /= 0 -> 
            NextPid ! N,
            resheto2(P, NextPid)
    end;

resheto2(P, Invalid) ->
    receive 
        {done, From} ->
            From ! [P];
        N when N rem P == 0 -> 
            resheto2(P, Invalid);
        N when N rem P /= 0 -> 
            Pid = spawn(resheto, resheto2, [0, void]),
            Pid ! N,
            resheto2(P, Pid)
    end.
    
resheto1() ->
    spawn(resheto, resheto2, [0, void]).

generate(MaxN) ->
        Pid = resheto1(),
        generate2(Pid, 2, MaxN).

generate2(Pid, End, End) ->
        Pid ! {done, self()},
        receive
                Res -> Res
        end;

generate2(Pid, N, End) ->
        Pid ! N,
        generate2(Pid, N + 1, End).
