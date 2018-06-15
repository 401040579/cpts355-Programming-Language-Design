(*
Name: Ran Tao
SID: 11488080
HW: HW4.sml
Data:3/31/2017
*)

(*************************************************************************************************************************************************************)
(* 1. exists *)
(* Answer: Because ''a is a type variable that can only be substituted by types that support equality testing, we need the type can support equality testing *)
fun exists (n, list) =   	(* function exists *)
  if null list then false	(* check null list *)
 else 						
    if hd(list) = n then true	(* if head of list == n *)
    else exists(n, tl(list))		(* rest *)
;

(*
exists (1, []);
exists (1, [1,2,3]);
exists ([1], [[1]]);
exists ([1],[[3],[5]]);
exists ("c",["b","c","z"]);
PAUSE
*)
(*************************************************************************************************************************************************************)
(* 2. listUnion *)
fun removeDup(list) = 
  if null list then []
  else
    if exists(hd(list), removeDup(tl(list))) then removeDup(tl(list))
    else hd(list)::removeDup(tl(list))
;

fun listUnion(list1, list2) = removeDup(list1@list2)
;

(*
fun listUnion(list1, list2) = 
	if null(list1@list2) then []
	else
		if exists(hd(list1@list2), listUnion(list1, list2)) then listUnion(list1, list2)
		else hd(list1@list2)::listUnion(list1, list2)
;
*)

(*
listUnion ([1], [1]);
listUnion ([1,1,3], [1,2]);
listUnion ([[2,3],[1,2]], [[1],[2,3]]);
PAUSE
*)
(*************************************************************************************************************************************************************)
(* 3. listIntersect *)
fun listIntersect [] []  = []
  | listIntersect x [] = []
  | listIntersect [] x = []
  | listIntersect (x::rest) y = if exists (x,rest) then listIntersect rest y
    else if exists (x,y) then x::listIntersect rest y 
    else listIntersect rest y
;

(*
listIntersect [1] [1];
listIntersect [1,2,3] [1,2];
listIntersect [[2,3], [1,2]] [[1],[2,3]];
PAUSE
*)
(*************************************************************************************************************************************************************)
(* 4. pairNleft and pairNright *)
(* rev from sild *)
fun reverse(list) = 
  let 
  fun rev ([], l2) = l2
    | rev (l1, l2) = rev(tl(l1), hd(l1)::l2)
  in
  rev(list, [])
  end
;

fun pairNright n1 list = 
  let
  fun f (n, n2, [], l2, l3) = reverse(l3)::l2
  |   f (n, n2, l, l2, l3) = 
    if n2 = 0 then f(n, n, l, reverse(l3)::l2, [])
    else f (n, n2 - 1, tl(l), l2, hd(l)::l3)
  in
  reverse(f(n1, n1, list, [], []))
  end
;

(* it does pairNleft but need to rev it *)
fun leftpairN(n1, list) = 
  let
  fun f (n, n2, [], l2, l3) = l3::l2
  |   f (n, n2, l, l2, l3) = 
    if n2 = 0 then f(n, n, l, l3::l2, [])
    else f (n, n2 - 1, tl(l), l2, hd(l)::l3)
  in
  reverse(f(n1, n1, list, [], []))
  end
;

fun pairNleft n1 list = reverse(leftpairN(n1, reverse(list)))
;

(*
pairNleft 2 [1, 2, 3, 4, 5];
pairNright 2 [1, 2, 3, 4, 5];
pairNleft 3 [1, 2, 3, 4, 5];
pairNright 3 [1, 2, 3, 4, 5];
PAUSE
*)
(*************************************************************************************************************************************************************)
(* 5. filter and reverse *)
fun filter fnc list = 
  let
  fun accum (f, [], l2) = l2
    | accum (f, l, l2) = 
    if f(hd(l)) then accum(f, tl(l), hd(l)::l2)
    else accum(f, tl(l), l2)
  in
  accum (fnc, reverse(list), [])
  end
;

(*
filter (fn (x) => (x = 1)) [1,2,3];
filter (fn (x) => (x <= 3)) [1,2,3,4];
filter (fn (x) => (x > 3)) [1,2,3,4];
PAUSE
*)
(*************************************************************************************************************************************************************)
(* 6. Merge Sort *)
fun merge([], ys) = ys
  | merge(xs, []) = xs
  | merge(x::xs, y::ys) =
    if x < y then x::merge(xs, y::ys)
    else y::merge(x::xs, ys)
;

fun split [] = ([],[])
  | split [a] = ([a],[])
  | split (a::b::cs) =
    let val (M,N) = split cs in
      (a::M, b::N)
    end
;

fun mergeSort []  = []
  | mergeSort [a] = [a]
  | mergeSort [a,b] = if a <= b then [a,b] else [b,a]
  | mergeSort L  =
    let val (M,N) = split L
    in
      merge (mergeSort M, mergeSort N)
    end
;

fun unitList [] = []
| unitList (x::rest) = ([x])::(unitList rest)
;

fun mergeSort2 [] = []
| mergeSort2 (list) = removeDup(mergeSort list)
;

(*
unitList [];
unitList [1,2,3,4];
unitList [1,1,2];

mergeSort [5,3,6,3,1,7,2,4,1];
mergeSort [5,3,6,7,3,2,2,4,1];
mergeSort [1];

mergeSort2 [5,3,6,3,1,7,2,4,1];
mergeSort2 [5,3,6,7,3,2,2,4,1];
mergeSort2 [1];
PAUSE
*)

(*************************************************************************************************************************************************************)
(* 7. eitherTree and eitherSearch *)
datatype either = ImAString of string | ImAnInt of int
;

datatype eitherTree = LEAF of either | INTERIOR of (either * eitherTree * eitherTree)
;

fun eitherSearch (LEAF(ImAnInt x)) y = (x=y)
  | eitherSearch(LEAF(ImAString x)) y = false
  | eitherSearch (INTERIOR (ImAString x,t1,t2)) y = false
  | eitherSearch (INTERIOR (ImAnInt x,t1,t2)) y = if x=y then true else (eitherSearch t1 y)
  orelse (eitherSearch t2 y)   
;

fun eitherTest () =
let
  val L1 = LEAF(ImAnInt 1)
  val L2 = LEAF(ImAnInt 2)
  val L3 = LEAF(ImAnInt 3)
  val L4 = LEAF(ImAnInt 4)
  val L5 = LEAF(ImAnInt 5)
  val L6 = LEAF(ImAString "a")
  val L7 = LEAF(ImAString "b")
  val L8 = LEAF(ImAString "c")
  val L9 = LEAF(ImAString "d")
  val L10 = LEAF(ImAString "e")
  val N1 = INTERIOR (ImAnInt 6, L1,L2)
  val N2 = INTERIOR (ImAnInt 7, N1, L3)
  val N3 = INTERIOR (ImAnInt 8, N2, L4)
  val N4 = INTERIOR (ImAnInt 9, N3, L5)
  val N5 = INTERIOR (ImAnInt 10, N4, L6)
  val N6 = INTERIOR (ImAString "f", N5, L7)
  val N7 = INTERIOR (ImAString "g", N6, L8)
  val N8 = INTERIOR (ImAString "h", N7, L9)
  val N9 = INTERIOR (ImAString "i", N8, L10)
    in
       ((eitherSearch N9 1)=true) 
       = 
       ((eitherSearch N9 16)=false)
       =
       ((eitherSearch N9 8)=true)       
    end
;
(*
eitherTest ();
PAUSE
*)
(*************************************************************************************************************************************************************)
(* 8. treeToString *)
datatype 'a Tree = LEAF of 'a | NODE of ('a Tree) list
;

fun treeToString pred (LEAF(v)) = pred v
   | treeToString pred (NODE(v)) = "(" ^ String.concat(List.map (treeToString pred) v) ^ ")"
;

fun treeTest () =
let
val L1a = LEAF "a"
val L1b = LEAF "b"
val L1c = LEAF "c"
val L2a = NODE [L1a, L1b, L1c]
val L2b = NODE [L1b, L1c, L1a]
val L3 = NODE [L2a, L2b, L1a, L1b]
val L4 = NODE [L1c, L1b, L3]
val L5 = NODE [L4]
val iL1a = LEAF 1
val iL1b = LEAF 2
val iL1c = LEAF 3
val iL2a = NODE [iL1a, iL1b, iL1c]
val iL2b = NODE [iL1b, iL1c, iL1a]
val iL3 = NODE [iL2a, iL2b, iL1a, iL1b]
val iL4 = NODE [iL1c, iL1b, iL3]
val iL5 = NODE [iL4]
    in
       ((treeToString String.toString L5) = "((cb((abc)(bca)ab)))") 
       = 
       ((treeToString Int.toString iL5) = "((32((123)(231)12)))")   
    end
;

(*
treeToString String.toString L5;
treeToString Int.toString iL5;
PAUSE
*)
(*************************************************************************************************************************************************************)
(* Extra Credit *)
(* first list to store name, second list to store priority *)
(*

// **************************************************************************
// this is one has a bug. it keep throw away low pri data. so i use 
(string list * 'a list * string list * 'a list) detailed info on below
// **************************************************************************



abstype 'a PriorityQ = pQueue of string list * 'a list
with
   val nullQueue = pQueue([],[])

   fun front(pQueue(h::_, hl::_)) = (h,hl)

   fun remove(pQueue(_::t, _::tl)) = pQueue(t,tl)

   fun enter(pri, v, pQueue([],[])) = pQueue(v::[],pri::[])
    | enter(pri, v, pQueue(h::rest,hl::restl)) = if pri < hl then pQueue(v::h::rest, pri::hl::restl)
   else enter(pri,v,pQueue(rest,restl))

   fun contents(pQueue([],[])) = []
    | contents(pQueue(h::rest, hl::restl)) = h::contents(pQueue(rest,restl));
end
;
*)


(*
// **************************************************************************
why do i use (string list * 'a list * string list * 'a list)
first two is to store name of the value and Priority
last two is for function enter. when using tail recursive, the data of head 
of the first two list is keeping lost. so i use last two list to store the
lost data of first two.
// **************************************************************************
*)
abstype 'a PriorityQ = pQueue of string list * 'a list * string list * 'a list
with
  (*
nullQueue This value represent the null priority queue, which contains no entries.
  *)
   val nullQueue = pQueue([],[],[],[])
   (*
   exception emptyQueue This exception is 
   raised when front or remove is applied to an empty queue
   *)
   exception emptyQueue
    (*
    front(pQueue) This function returns the front value in pQueue,
    which is the value with the lowest priority. If more than one
    entry has the lowest priority, the oldest entry is chosen. If
    pQueue is empty, the emptyQueue exception is raised.
    *)
   fun front(pQueue(h::_,hl::_,_,_)) = (h,hl)
   (*
   remove(pQueue) This function removes the front value from pQueue, 
   which is the value with the lowest priority. If more than one entry 
   has the lowest priority, the oldest entry is removed. The updated 
   priority queue is returned. If pQueue is empty, the emptyQueue 
   exception is raised.
   *)
   fun remove(pQueue(_::t, _::tl,_,_)) = pQueue(t,tl,[],[])
   (*
   enter(pri,v,pQueue) This function adds an entry with value
   v and priority pri to pQueue. The updated priority queue is
   returned. As noted above, the entry is placed behind all 
   entries with a priority = pri and in front of all entries
   with a priority > pri.
   *)
   fun enter(pri, v, pQueue([],[],_,_)) = pQueue(v::[],pri::[],[],[])
    | enter(pri, v, pQueue(h::rest,hl::restl,a,b)) = if pri < hl then pQueue(a@v::h::rest, b@pri::hl::restl, [],[])
   else enter(pri,v,pQueue(rest,restl,h::a,hl::b))
  (*
   contents(pQueue) This function returns the contents of pQueue 
   in list form. Each member of the list is itself a list comprising 
   all queue members sharing the same priority. Sublists are ordered 
   by priority, with lowest priority first. Within a sublist, queue
    members are ordered by order of entry, with oldest first. The front
     of pQueue is the leftmost element of the first sublist, and the 
    rear of pQueue is the rightmost member of the last sublist.
   *)
   fun contents(pQueue([],[],_,_)) = []
    | contents(pQueue(h::rest, hl::restl,_,_)) = h::contents(pQueue(rest,restl,[],[]));
end
;


fun PriorityQTest () =
  let
    val new = nullQueue
    val new = enter(5,"e",new)
    val new = enter(4,"d",new)
    val new = enter(3,"c",new)
    val new = enter(1,"a",new)
    val lowest_pri = front(new)
    val new = enter(2,"b",new)
    val new = contents(new)
  in
       (lowest_pri=("a",1))  
  end
;

(* cited from book p329 *)
(*
abstype PriorityQ2 = Q of int list
with
  fun mk_PQueue() = Q(nil)
  and is_empty(Q(l)) = l = nil
  and add(x,Q(l)) =
      let fun insert(x,nil) = [x:int]
      | insert(x,y::l) = if x<y then x::y::l else y::insert(x,l)
      in Q(insert(x,l)) end
  and first (Q(nil)) = raise Empty | first (Q(x::l)) = x
  and rest (Q(nil)) = raise Empty | rest (Q(x::l)) = Q(l)
  and length (Q(nil)) = 0 | length (Q(x::l))= 1 + length (Q(l))
end;
*)

(*************************************************************************************************************************************************************)
(* test cases *)
(* 1. exists *)
fun myTest_exists (n, L, R) = if (exists (n,L)) = R then true else false;
val test1_exists = myTest_exists(1,[],false);
val test2_exists = myTest_exists(1,[1,2,3],true);
val test3_exists = myTest_exists([1],[[1]],true);
val test4_exists = myTest_exists([1],[[3],[5]],false);
val test5_exists = myTest_exists("c",["b","c","z"],true);

(* 2. listUnion *)
fun myTest_listUnion (n, L, R) = if (listUnion (n,L)) = R then true else false;
val test1_listUnion = myTest_listUnion([1], [1], [1]);
val test2_listUnion = myTest_listUnion([1,1,3], [1,2], [3,1,2]);
val test3_listUnion = myTest_listUnion([[2,3],[1,2]], [[1],[2,3]], [[1,2],[1],[2,3]]);

(* 3. listIntersect *)
fun myTest_listIntersect (n, L, R) = if (listIntersect n L) = R then true else false;
val test1_listIntersect = myTest_listIntersect([1], [1], [1]);  
val test2_listIntersect = myTest_listIntersect([1,2,3], [1,2], [1,2]);
val test3_listIntersect = myTest_listIntersect([[2,3],[1,2]], [[1],[2,3]], [[2,3]]);

(* 4. pairNleft and pairNright *)
fun myTest_pairNleft (n,L,R) = if (pairNleft n L) = R then true else false;
fun myTest_pairNright (n,L,R) = if (pairNright n L) = R then true else false;
val test1_pairNleft = myTest_pairNleft(2,[1,2,3,4,5],[[1],[2,3],[4,5]]);
val test2_pairNleft = myTest_pairNleft(3,[1,2,3,4,5],[[1, 2], [3, 4, 5]]);
val test3_pairNleft = myTest_pairNleft(4,[1,2,3,4,5],[[1], [2, 3, 4, 5]]);
val test4_pairNright = myTest_pairNright(2,[1,2,3,4,5],[[1,2],[3,4],[5]]);
val test5_pairNright = myTest_pairNright(3,[1,2,3,4,5],[[1, 2, 3], [4, 5]]);
val test6_pairNright = myTest_pairNright(4,[1,2,3,4,5],[[1, 2, 3, 4], [5]]);

(* 5. filter (and reverse) *)
fun myTest_filter (f,L,R) = if (filter f L) = R then true else false;
val test1_filter = myTest_filter((fn (x) => (x = 1)), [1,2,3],[1]);
val test2_filter = myTest_filter((fn (x) => (x <= 3)),[1,2,3,4],[1,2,3]);
val test3_filter = myTest_filter((fn (x) => (x > 3)),[1,2,3,4],[4]);

(* 6. Merge Sort *)
fun myTest_unitList (L,R) = if (unitList L) = R then true else false;
val test1_unitList = myTest_unitList([],[]);
val test2_unitList = myTest_unitList([1,2,3,4],[[1],[2],[3],[4]]);
val test3_unitList = myTest_unitList([1,1,2],[[1],[1],[2]]);

fun myTest_mergeSort (L,R) = if (mergeSort L) = R then true else false;
val test1_mergeSort = myTest_mergeSort([5,3,6,3,1,7,2,4,1],[1,1,2,3,3,4,5,6,7]);
val test2_mergeSort = myTest_mergeSort([5,3,6,7,3,2,2,4,1],[1,2,2,3,3,4,5,6,7]);
val test3_mergeSort = myTest_mergeSort([1],[1]);

fun myTest_mergeSort2 (L,R) = if (mergeSort2 L) = R then true else false;
val test1_mergeSort2 = myTest_mergeSort2([5,3,6,3,1,7,2,4,1],[1,2,3,4,5,6,7]);
val test2_mergeSort2 = myTest_mergeSort2([5,3,6,7,3,2,2,4,1],[1,2,3,4,5,6,7]);
val test3_mergeSort2 = myTest_mergeSort2([1],[1]);

(* 7. eitherTree and eitherSearch *)
val test_eitherTree = eitherTest ();

(* 8. treeToString *)
val test_treeToString = treeTest();

(* Extra Credit *)
(* more comment in code section *)
val test_PriorityQ = PriorityQTest ();