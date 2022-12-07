(var curdir (array))
(var dirs @{})

(defn dirstring [dir] (string/join dir "/"))

(defn cd [dir]
  (case dir
    ".." (array/pop curdir)
    "/" (array/clear curdir)
    (array/push curdir dir)))

(defn add-file [dir size]
  (def key (dirstring dir))
  (var cursize (get dirs key))
  (if (= cursize nil) (set cursize 0))
  (def newsize (+ cursize size))
  (set (dirs key) newsize)
  (if (> (length dir) 0) (add-file (array/slice dir 0 -2) size)))

(defn process-command [input]
  (def cmd (get input 1))
  (if (= cmd "cd") (cd (get input 2))))

(defn process-file-entry [input]
  (def size (get input 0))
  (def name (get input 1))
  (if-not (= size "dir") (add-file (array/slice curdir) (scan-number size))))

(with [file (file/open "input")]
  (loop [line :iterate (file/read file :line)]
    (def line (string/trim line))
    (def parts (string/split " " line))
    (if (= (get parts 0) "$") (process-command parts) (process-file-entry parts))))

(var sum 0)
(def rootsize (get dirs ""))
(def free-space (- 70000000 rootsize))
(def space-to-free (- 30000000 free-space))
(var smallest-dir-to-free rootsize)

(each key (keys dirs)
  (def val (get dirs key))
  (if (< val 100000) (set sum (+ sum val))
  (if (and (> val space-to-free) (< val smallest-dir-to-free)) (set smallest-dir-to-free val))))

(print sum)
(print smallest-dir-to-free)