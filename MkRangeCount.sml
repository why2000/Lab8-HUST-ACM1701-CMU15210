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

  (* space: n^(3/2) *)
  (* 写推导过程 *)
  (* time: lgn *)
  fun makeCountTable (S : point seq) : countTable =
    case Seq.length S
      of 0 => empty()
       | _ =>
          let
            (* W: nlgn, S: lg^2n *)
            val sorted = Seq.sort (fn ((x1, _), (x2, _)) => Key.compare (x1, x2)) S
            (* S: 1, W: n *)
            val withkeys = Seq.map (fn (x,y) => (x, (x, y))) S
            val keyTable = (OrdTable.collect withkeys)
            val keys = Set.toSeq (OrdTable.domain keyTable)
            (* S： lg^2n, W: nlgn *)
            val seqwithkeys = Seq.sort (fn ((x1, _),(x2,_)) => Key.compare (x1, x2)) (Seq.tabulate (fn i => let val (x, s) = (Seq.nth keys i, valOf(OrdTable.find keyTable (Seq.nth keys i))) in (x, s) end) (OrdTable.size keyTable))
            fun generateOne (m) = 
              let
                val (x, s) = Seq.nth seqwithkeys m
              in
                Seq.tabulate (fn i => (#1 (Seq.nth seqwithkeys i), s)) (m+1)
              end
            (* 推flatten的work *)
            val xtableraw = Seq.flatten (Seq.tabulate (fn n => generateOne n) (OrdTable.size keyTable))
            val xtable = OrdTable.collect xtableraw
            val redundent = OrdTable.map (fn t => Seq.map (fn (x,y) => (y, (x,y))) (Seq.flatten t)) xtable
          in
            OrdTable.map (fn t => OrdTable.collect t) redundent
          end

  (* Right of (leftbound) - Right of (rightbound) *)
  fun count (T : countTable)
                   ((xLeft, yHi) : point, (xRght, yLo) : point) : int  =
    case OrdTable.size T
      of 0 => 0
       | _ => (Seq.reduce (fn (a,b) => a+b) 0 (Seq.map (fn x => Seq.length x) (OrdTable.range (getRange (getOpt(OrdTable.find T xLeft, (#2 (getOpt(next T xLeft, (xLeft, OrdTable.empty())))))) (yLo, yHi))))) - (Seq.reduce (fn (a,b) => a+b) 0 (Seq.map (fn x => Seq.length x) (OrdTable.range (getRange (#2 (getOpt(next T xRght, (xRght, OrdTable.empty())))) (yLo, yHi)))))


end