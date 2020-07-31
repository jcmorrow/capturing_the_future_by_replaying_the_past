type idx = int * int
val state : idx option ref = ref NONE

fun start_idx xs = (0, List.length xs)
fun next_idx (k, len) =
  if k + 1 = len then NONE
  else SOME (k + 1, len)
fun get xs (k, len) = List.nth (xs, k)

exception Empty

fun choose [] = raise Empty
  | choose xs = case !state of
                     NONE => let val i = start_idx xs in
                       state := SOME i;
                       get xs i
                    end
                   | SOME i => get xs i

fun withNondeterminism f =
let
  val v = [f ()] handle Empty => []
in
  case !state of
    NONE => v
  | SOME i => case next_idx i of
      NONE => v
    | SOME i' => (state := SOME i';
                  v @ withNondeterminism f)
end;
