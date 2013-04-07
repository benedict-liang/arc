(ns ring.middleware.filter-routes)

(defn- traverse-filters [req filters]
  (reduce
   (fn [acc m]
     (cond
      (not (nil? acc))
      acc
      (and (cond
            (= (type (m :url)) java.lang.String)
            (= (req :uri)  (m :url))
            (= (type (m :url)) java.util.regex.Pattern)
            (re-find (m :url) (req :uri)))
           (not ((m :check) req)))
      (m :else-action)
      :else
      nil))
   nil
   filters
   ))
(defn wrap-filter-routes [app filters]
  "middleware for adding filters to routes. filters is a vector of hashmaps containing :url :check and :else-action. :url is the obviously the url which is checked for.url can either be a string or a regex pattern. :check should be a function that returns a truthy/falsey value. :else-action is executed if :check is NOT satisfied.
 The function passed as :else-action is executed instead of (app req), so make sure you add an appropriate ring response."
  (fn [req]
    (let [action (traverse-filters req filters)]
      (if action
        (action req)
        (app req)))))
