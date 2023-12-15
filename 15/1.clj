(ns aoc)
(require '[clojure.string :as str])

(defn hashalgo
	([chars] (hashalgo chars 0))
	([chars sum] (if (empty? chars)
		sum
		(hashalgo (rest chars) (-> chars first int (+ sum) (* 17) (mod 256)))
	))
)

(def input (slurp "input.txt"))
(as-> input i
	(str/replace i #"\n" "")
	(str/split i #",")
	(map char-array i)
	(map hashalgo i)
	(reduce + i)
	(println i)
)
