# Project:
Erlang variable-length-quantity codec


# Description:
This erlang module implements functions to encode integer into VLQ and decode VLQ binaries into integer. Follows the definition of VLQ found at http://en.wikipedia.org/wiki/Variable-length_quantity


# Manual:
  - Encode an integer
    - vlq:encode(integer()) -> binary()
  - Decode VLQ binary stream:
    - vlq:decode(binary()) -> integer()
