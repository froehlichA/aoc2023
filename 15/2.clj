(ns aoc)
(require '[clojure.string :as str])

(defn hashalgo
	([chars] (hashalgo chars 0))
	([chars sum] (if (empty? chars)
		sum
		(hashalgo (rest chars) (-> chars first int (+ sum) (* 17) (mod 256)))
	))
)

(defn box
	[map line] (if (empty? (rest line))
		(let [name (first line) idx (hashalgo name)]
			(assoc map idx (dissoc (map idx) name))
		)
		(let [name (first line) idx (hashalgo name) focal (get line 1)]
			(assoc map idx (assoc (map idx) name (Integer/parseInt focal)))	
		)
	)
)

(defn valOfBox
	[boxnr mp] (->>
		mp
		seq
		(map #(get %1 1))
		(map-indexed vector)
		(map #(cons (+ (first %1) 1) (rest %1)))
		(map #(reduce * %1))
		(map #(* %1 (+ boxnr 1)))
	)
)

(defn valOfMap
	[mp] (->>
		mp
		seq
		(map #(valOfBox (get %1 0) (get %1 1)))
		(map #(reduce + %1))
		(reduce +)
	)
)

(def input (slurp "input.txt"))
(as-> input i
	(str/replace i #"\n" "")
	(str/split i #",")
	(map #(str/split %1 #"(=|-)") i)
	(reduce box {} i)
	(valOfMap i)
	(println i)
)
