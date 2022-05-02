-module('prj5_sol').
-export([is_all_greater_than/2, 

	 start_pred_server/1, stop_pred_server/1,
         pred_client/2, pred_server/1,

	 start_update_pred_server/1, stop_update_pred_server/1,
         update_pred_client/2, update_pred_server/1,
	 update_pred_server_update/2
]).


% is_all_greater_than(List, N): return true iff all numbers in List are > N.
%
% Example Log (note that the Erlang line # prompt is indicated as N>):
% N> prj5_sol:is_all_greater_than([], 5).
% true
% N> prj5_sol:is_all_greater_than([7, 6], 5).
% true
% N> prj5_sol:is_all_greater_than([7, 5], 5).
% false
%
is_all_greater_than([], _) -> true;
is_all_greater_than([X|Xs], N) -> (X > N) and is_all_greater_than(Xs, N).

%%%%%%%%%%%%%%%%%%%%%%%%%%% Predicate Server %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pred_server(Pred): invoked with a predicate Pred.  It will receive
% messages from a client containing an argument Val for Pred.  It will
% return a true or false message to the client depending on whether or
% not Pred(Val) is true or false.  It will stop when it receives a
% 'stop' message from a client.
pred_server(Pred) -> receive                  % receive a message
    { ClientPid, Data } ->   % msg contains function Fn
      Result = Pred(Data),   % run arbitrary function on Data
      %io:format("Result is ~w\n", [Result]),
      ClientPid !  { self(), Result }, % send Result to client
      pred_server(Pred);   % loop back
    stop ->                % got stop message
      true                 % terminate server
   end.
% pred_client(ServerPid, List): given the PID ServerPid of a predicate
% server and a list List of predicate arguments, it will return true iff
% the predicate server returns true for all arguments in List.

pred_client(ServerPid, [N|Ns]) ->   
    ServerPid ! { self(), N } ,
  receive
    { _, Result } -> Result and pred_client(ServerPid, Ns)   % return Result 
  end;
pred_client(ServerPid, []) ->
    ServerPid ! true.

start_pred_server(Pred) ->
    spawn(prj5_sol, pred_server, [Pred]).
stop_pred_server(ServerPid) ->
    ServerPid ! stop.

% Example Log:
% N> PID=prj5_sol:start_pred_server(fun (N) -> N > 5 end).
% <0.129.0>
% 22> prj5_sol:pred_client(PID, [6, 7, 8]).
% true
% N> prj5_sol:pred_client(PID, [6, 7, 5]).
% false
% N> prj5_sol:stop_pred_server(PID).
% stop
%
% N> PID1=prj5_sol:start_pred_server(fun (N) -> N < 5 end).
% <0.139.0>
% N> prj5_sol:pred_client(PID1, [1, 2, 4]).
% true
% N> prj5_sol:pred_client(PID1, [5, 2, 3]).
% false
% N> prj5_sol:stop_pred_server(PID1).
% stop
% 

%%%%%%%%%%%%%%%%%%%%%%%% Update Predicate Server %%%%%%%%%%%%%%%%%%%%%%%%

%% This server is similar to the earlier server except that it will
%% support additional functionality: hot replacement of the predicate
%% while it is running.  You will be able to reuse code from the
%% earlier server, but may need to change the format of your messages.

% update_pred_server(Pred): invoked with a predicate Pred.  It will
% receive messages from a client containing an argument Val for Pred.
% It will return a true or false message to the client depending on
% whether or not Pred(Val) is true or false.  It will also accept an
% update message providing a new predicate to replace the Pred it is
% currently using. It will stop when it receives a 'stop' message from
% a client.
update_pred_server(Pred) ->  receive  
    { ClientPid, Data } ->   % msg contains function Fn
      Result = Pred(Data),   % run arbitrary function on Data
      %io:format("Result is ~w\n", [Result]),
      ClientPid !  { self(), Result }, % send Result to client
      update_pred_server(Pred);   % loop back
    {ClientPid, Predicate, true} ->
            ClientPid ! {self(), ok},
            update_pred_server(Predicate);
    stop ->                % got stop message
      true                 % terminate server
   end.

% update_pred_client(ServerPid, List): given the PID ServerPid of a predicate
% server and a list List of predicate arguments, it will return true iff
% the predicate server returns true for all arguments in List.
update_pred_client(ServerPid, [N|Ns]) ->    
    ServerPid ! { self(), N } ,
  receive
    { _, Result } -> Result and pred_client(ServerPid, Ns)   % return Result 
  end;
update_pred_client(ServerPid, []) ->
    ServerPid ! true.
% will update update_pred_server having PID ServerPid with NewPred.
% returns 'ok' if the update is accepted.
update_pred_server_update(ServerPid, NewPred) -> 
    ServerPid ! {self(), NewPred, true},
    receive
        {_, Result} -> Result
    end.

start_update_pred_server(Pred) ->
    spawn(prj5_sol, update_pred_server, [Pred]).
stop_update_pred_server(ServerPid) ->
    ServerPid ! stop.

% Example Log:
% N> PID3=prj5_sol:start_update_pred_server(fun (N) -> N < 5 end).
% <0.154.0>
% N> prj5_sol:update_pred_client(PID3, [1, 2, 3]).
% true
% N> prj5_sol:update_pred_client(PID3, [1, 5, 3]).
% false
% N> prj5_sol:update_pred_server_update(PID3, fun (N) -> N > 5 end).
% ok
% N> prj5_sol:update_pred_client(PID3, [16, 6, 8]).
% true
% N> prj5_sol:update_pred_client(PID3, [16, 6, 5]).
% false
% N> prj5_sol:stop_update_pred_server(PID3).
% stop



