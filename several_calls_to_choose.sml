type idx = int * int
fun start_idx xs = (0, List.length xs)
fun next_idx (k, len) =
  if k + 1 = len then NONE
  else SOME (k + 1, len)
fun get xs (k, len) = List.nth (xs, k)
val past : idx list ref = ref []
val future : idx list ref = ref []

(* auxiliary stack function *)
fun push stack x = (stack := x :: !stack)
fun pop stack = case !stack of
                     [] => NONE
                   | x :: xs => (stack := xs; SOME x)

fun next_path [] = []
  | next_path (i :: is) =
  case next_idx i of
       SOME i' => i' :: is
     | NONE => next_path is

exception Empty

fun choose [] = raise Empty
  | choose xs = case pop future of
                     NONE => (* no future: start an index; push it into the past *)
                      let val i = start_idx xs in
                        push past i;
                        get xs i
                      end
                   | SOME i => (push past i; get xs i)

fun withNondeterminism f =
let val v = [f ()] handle Empty => []
  val next_future = List.rev (next_path (!past))
in
  past := [];
  future := next_future;
  if !future = [] then v
  else v @ withNondeterminism f
end
