-module(mobius).
-export([
    is_prime/1,
    is_prime/2,

    prime_factors/1,
    prime_factors/3,

    is_square_multiple/1,

    find_square_multiples/2,
    find_square_multiples/5
]).

% Проверяем число на простоту
is_prime(N) when N < 2 -> false;
is_prime(N) -> is_prime(N, 2).

is_prime(N, M) when M * M > N -> true;
is_prime(N, M) -> 
    if
        N rem M == 0 ->
            false;
        true ->
            is_prime(N, M + 1)
    end.

% Ищем простых сомножителей
prime_factors(N) -> prime_factors(N, 2, []).

prime_factors(N, M, ListMn) ->
    case is_prime(N) of 
        true -> lists:reverse([N | ListMn]);
        false ->
            case (is_prime(M)) and (N rem M == 0) of
                true -> prime_factors(N div M, M, [M | ListMn]);
                false -> prime_factors(N, M + 1, ListMn)
            end
    end.

% Проверяем, что число делится на квадрат простого числа
is_square_multiple(N) ->
    case is_prime(N) of
        true -> false;
        false ->
            case (erlang:length(prime_factors(N)) == 
                sets:size(sets:from_list(prime_factors(N)))) of
                true -> false;
                false -> true
            end
    end.

% Поиск минимального числа последовательности
find_square_multiples(Count, MaxN) -> find_square_multiples(Count, MaxN + 1, 2, [], []).

find_square_multiples(Count, MaxN, _, _, MaxListN) when erlang:length(MaxListN) == Count ->
    case lists:last(MaxListN) =< MaxN of
        true -> lists:last(MaxListN);
        false -> fail
    end;

find_square_multiples(Count, MaxN, Curr, CurrListN, MaxListN) ->
    case is_square_multiple(Curr) of
        true ->
            find_square_multiples(Count, MaxN, Curr + 1, [Curr | CurrListN], MaxListN);
        false ->
            if
                erlang:length(CurrListN) > erlang:length(MaxListN) ->
                    find_square_multiples(Count, MaxN, Curr + 1, [], CurrListN);
                true ->
                    find_square_multiples(Count, MaxN, Curr + 1, [], MaxListN)
            end
    end.