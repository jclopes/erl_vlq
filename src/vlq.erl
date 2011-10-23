-module(vlq).

-export([
    decode/1,
    encode/1
]).

% returns: the first number in the VLQ stream and the remainer of the VLQ
decode(Bin) ->
    {ResBin, T} = decode_acc(Bin, <<>>),
    {binary:decode_unsigned(ResBin), T}
.

decode_acc(<<0:1, Val:7, T/binary>>, Res) ->
    {<<0:1, Res/binary, Val:7>>, T}
;
decode_acc(<<1:1, Val:7, T/binary>>, Res) ->
    decode_acc(T, <<0:1, Res/binary, Val:7>>)
.

% returns: the VLQ binary represetation of an unsigned integer
encode(Int) ->
    Bin = binary:encode_unsigned(Int),
    encode_acc(Bin, <<>>)
.

encode_acc(<<>>, Acc) ->
    Acc
;
encode_acc(Bin, <<>>) ->
    Size = byte_size(Bin),
    <<P:1, Val:7>> = binary:part(Bin, {Size, -1}),
    H = binary:part(Bin, {0, Size - 1}),
    encode_acc(<<0:7, H/binary, P:1>>, <<0:1, Val:7>>)
;
encode_acc(<<0:8, H/binary>>, Acc) ->
    encode_acc(H, Acc)
;
encode_acc(Bin, Acc) ->
    Size = byte_size(Bin),
    <<P:1, Val:7>> = binary:part(Bin, {Size, -1}),
    H = binary:part(Bin, {0, Size - 1}),
    encode_acc(<<0:7, H/binary, P:1>>, <<1:1, Val:7, Acc/binary>>)
.
