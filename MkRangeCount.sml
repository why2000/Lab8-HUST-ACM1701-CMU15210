functor MkRangeCount(structure OrdTable : ORD_TABLE) : RANGE_COUNT =
struct
  structure OrdTable = OrdTable
  open OrdTable

  (* Ordered table type: *)
  type 'a table = 'a table
  type 'a seq = 'a Seq.seq
  type point = Key.t * Key.t

  (* Use this to compare x- or y-values. *)
  val compareKey : (Key.t * Key.t) -> order = Key.compare

  (* Define this yourself *)
  (* x -> (y -> x) *)
  type countTable = point seq table table

  (* Remove this line before submitting! *)
  exception NYI

  fun makeCountTable (S : point seq) : countTable =
    case Seq.length S
      of 0 => empty()
       | _ =>
          let
            val sorted = Seq.sort (fn ((x1, _), (x2, _)) => Key.compare (x1, x2)) S
            val withkeys = Seq.map (fn (x,y) => (x, (x, y))) S
            val keyTable = (OrdTable.collect withkeys)
            val keys = Set.toSeq (OrdTable.domain keyTable)
            val seqwithkeys = Seq.sort (fn ((x1, _),(x2,_)) => Key.compare (x1, x2)) (Seq.tabulate (fn i => let val (x, s) = (Seq.nth keys i, valOf(OrdTable.find keyTable (Seq.nth keys i))) in (x, s) end) (OrdTable.size keyTable))
            fun generateOne (m) = 
              let
                val (x, s) = Seq.nth seqwithkeys m
                (* val ptr = print("time "^(Int.toString (m+1))^", key "^(Key.toString x)^":"^(Int.toString (Seq.length (#2 s)))^"\n") *)
              in
                Seq.tabulate (fn i => (#1 (Seq.nth seqwithkeys i), s)) (m+1)
              end
            (* val ptt = print("length:"^(Int.toString (Seq.length sorted))^"\n") *)
            val xtableraw = Seq.flatten (Seq.tabulate (fn n => generateOne n) (OrdTable.size keyTable))
            val xtable = OrdTable.collect xtableraw
            val redundent = OrdTable.map (fn t => Seq.map (fn (x,y) => (y, (x,y))) (Seq.flatten t)) xtable
            val res = OrdTable.map (fn t => OrdTable.collect t) redundent

            (* val pt = print("length:"^(Int.toString (Seq.length (Seq.flatten (OrdTable.range (Seq.nth (OrdTable.range res) 3)))))^"\n") *)

            (* val pppppt = print ((OrdTable.toString (fn vs => "<"^String.concatWith "|" (Seq.toList (Seq.map (fn (x,y) => String.concatWith "," [(Key.toString x), (Key.toString y)]) vs))^">")) (valOf(OrdTable.find res (#1 (Seq.nth sorted 1))))) *)

            (* val ran = (getRange (getOpt(OrdTable.find res (#1 (Seq.nth sorted 1)), (#2 (getOpt(next res (#1 (Seq.nth sorted 1)), ((#1 (Seq.nth sorted 1)), OrdTable.empty())))))) ((#2 (Seq.nth sorted 7)), (#2 (Seq.nth sorted 2)))) *)
            
            (* val ppppspt = print ((OrdTable.toString (fn vs => "<"^String.concatWith "|" (Seq.toList (Seq.map (fn (x,y) => String.concatWith "," [(Key.toString x), (Key.toString y)]) vs))^">")) ran) *)


            (* val pppt = print("\ntestkey:"^Key.toString (#1 (Seq.nth sorted 1))^","^Key.toString(#2 (Seq.nth sorted 2))^","^Key.toString(#2 (Seq.nth sorted 7))^", result:"^Int.toString(size (getRange (getOpt(OrdTable.find res (#1 (Seq.nth sorted 1)), (#2 (getOpt(next res (#1 (Seq.nth sorted 1)), ((#1 (Seq.nth sorted 1)), OrdTable.empty())))))) ((#2 (Seq.nth sorted 7)), (#2 (Seq.nth sorted 2)))))^"\n") *)
          in
            res
          end

  (* Right of (leftbound) - Right of (rightbound) *)
  fun count (T : countTable)
                   ((xLeft, yHi) : point, (xRght, yLo) : point) : int  =
    case OrdTable.size T
      of 0 => 0
       | _ => (Seq.length (Seq.flatten (OrdTable.range (getRange (getOpt(OrdTable.find T xLeft, (#2 (getOpt(next T xLeft, (xLeft, OrdTable.empty())))))) (yLo, yHi))))) - (Seq.length (Seq.flatten (OrdTable.range (getRange (#2 (getOpt(next T xRght, (xRght, OrdTable.empty())))) (yLo, yHi)))))


end