functor MkBSTOrderedTable (structure Tree : BSTREE
                           structure Seq : SEQUENCE) : ORD_TABLE =
struct

  structure Table = MkBSTTable(structure Tree = Tree
                               structure Seq = Seq)

  (* Include all the functionalities of the standard Table *)
  open Table

  (* This is defined after "open" so it doesn't get overwritten *)
  structure Key = Tree.Key
  type key = Key.t

  (* Remember, type 'a table = 'a Tree.bst *)

  (* Remove this line before submitting! *)
  exception NYI

  fun first (T : 'a table) : (key * 'a) option =
    case Tree.expose T
      of NONE => NONE
       | SOME {key=k, value=v, left=l, right=r} =>
        if Tree.size l = 0 then SOME (k, v) else first l

  fun last (T : 'a table) : (key * 'a) option =
    case Tree.expose T
      of NONE => NONE
       | SOME {key=k, value=v, left=l, right=r} =>
        if Tree.size r = 0 then SOME (k, v) else last r
		      
  fun previous (T : 'a table) (k : key) : (key * 'a) option = last (#1 (Tree.splitAt (T, k)))
    (* disabled because the type NODE is not loaded *)
    (* let
      fun chk (EMPTY, _, _) = NONE
        | chk (NODE {data=d, left=l, right=r, ...}, SOME p, stats) =
          case Key.compare (k, #key d)
            of EQUAL => if l = EMPTY then NONE else SOME (#key (#data l), #value (#data l))
             | LESS => if stats = GREATER then SOME p else chk (l, SOME (#key d, #value d), LESS)
             | GREATER => if stats = LESS then SOME (#key d, #value d) else chk (r, SOME (#key d, #value d), GREATER)
    in 
      chk (T, NONE, EQUAL)
    end *)

  
  fun next (T : 'a table) (k : key) : (key * 'a) option = first (#3 (Tree.splitAt (T, k)))

  fun join (L : 'a table, R : 'a table) : 'a table = Tree.join(L, R)

  fun split (T : 'a table, k : key) : 'a table * 'a option * 'a table = Tree.splitAt (T, k)

  fun getRange (T : 'a table) (low : key, high : key) : 'a table = 
    case (Table.find T low, Table.find T high)
      of (NONE, NONE) => #1 (split (#3 (split (T, low)), high))
       | (SOME lv, NONE) => #1 (split (join (Tree.singleton(low, lv), #3 (split (T, low))), high))
       | (NONE, SOME hv) => join (#1 (split (#3 (split (T, low)), high)), Tree.singleton (high, hv))
       | (SOME lv, SOME hv) => join (#1 (split (join (Tree.singleton (low, lv), #3 (split (T, low))), high)), Tree.singleton(high, hv))
						       

end
