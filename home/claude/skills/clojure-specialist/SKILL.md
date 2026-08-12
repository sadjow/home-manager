---
name: clojure-specialist
description: |
  Clojure development specialist with deep knowledge of functional programming idioms, immutability patterns, and REPL-driven development. Use when: (1) Writing or reviewing Clojure/ClojureScript code, (2) Designing data-oriented architectures, (3) Writing tests with clojure.test or other testing libraries, (4) Working with namespaces, specs, or macros, (5) Refactoring imperative code to functional style, (6) Any Clojure project work including deps.edn, Leiningen, or tools.build configuration.
---

# Clojure Specialist

## Core Philosophy

**Data > Functions > Macros**: Prefer plain data structures. Use functions to transform data. Reserve macros for syntactic abstraction only.

**Immutability by default**: Never mutate. Use `atom`, `ref`, `agent` only when state is truly necessary.

**Small, composable functions**: Each function does one thing. Compose with `->`, `->>`, `comp`, `partial`.

**REPL-driven development**: Evaluate incrementally. Test in the REPL before committing.

## Code Style

### Naming

```clojure
;; predicates end with ?
(defn valid? [x] ...)
(defn empty-cart? [cart] ...)

;; side-effects end with !
(defn save-user! [user] ...)
(defn reset-cache! [] ...)

;; conversion functions use ->
(defn map->user [m] ...)
(defn user->json [user] ...)

;; kebab-case for everything
(def max-retry-count 3)
(defn calculate-total-price [items] ...)
```

### Function Design

```clojure
;; prefer arities over optional maps for 1-2 optional args
(defn fetch-user
  ([id] (fetch-user id {}))
  ([id opts] ...))

;; use maps for 3+ optional args
(defn query-users [{:keys [limit offset sort-by filter-fn]
                    :or {limit 100 offset 0}}]
  ...)

;; destructure in arg list, not let
(defn process-order [{:keys [items customer shipping]}]
  ...)

;; early return with when/when-not for guards
(defn process [data]
  (when (valid? data)
    (transform data)))
```

### Threading

```clojure
;; -> for object-first operations
(-> user
    (assoc :active true)
    (update :login-count inc))

;; ->> for collection-last operations
(->> items
     (filter active?)
     (map :price)
     (reduce +))

;; some-> for nil-safe threading
(some-> user :address :city str/upper-case)

;; cond-> for conditional steps
(cond-> base-query
  limit (assoc :limit limit)
  offset (assoc :offset offset))
```

### Collections

```clojure
;; prefer vectors for sequential data
(def items [1 2 3])

;; prefer maps for associative data
(def user {:id 1 :name "Alice"})

;; prefer sets for unique membership
(def allowed-roles #{:admin :user :guest})

;; use keywords as functions
(:name user)           ; not (get user :name)
(allowed-roles role)   ; set as predicate

;; use into for type conversion
(into [] (map inc) [1 2 3])
(into #{} (filter pos?) [-1 0 1 2])
```

## Testing

**Always write tests.** Use `clojure.test` unless project uses another library.

### Test Structure

```clojure
(ns myapp.core-test
  (:require [clojure.test :refer [deftest testing is are]]
            [myapp.core :as sut]))  ; sut = subject under test

(deftest calculate-total-test
  (testing "with valid items"
    (is (= 30 (sut/calculate-total [{:price 10} {:price 20}]))))

  (testing "with empty items"
    (is (zero? (sut/calculate-total []))))

  (testing "multiple cases"
    (are [items expected] (= expected (sut/calculate-total items))
      [{:price 5}]              5
      [{:price 5} {:price 5}]   10
      []                        0)))
```

### Test Patterns

```clojure
;; use fixtures for setup/teardown
(use-fixtures :each
  (fn [f]
    (with-redefs [db/conn (create-test-db)]
      (f))))

;; prefer real implementations over mocks
;; create test doubles as plain functions
(defn fake-email-sender []
  (let [sent (atom [])]
    {:send! (fn [msg] (swap! sent conj msg))
     :sent @sent}))

;; test pure functions extensively
;; isolate side-effects to thin boundaries

;; use spec for generative testing when applicable
(require '[clojure.spec.test.alpha :as stest])
(stest/check `my-function)
```

### What to Test

- All public functions
- Edge cases: empty collections, nil, zero, negative numbers
- Error conditions with `thrown?`
- State transitions for stateful components

```clojure
(deftest validates-input-test
  (testing "throws on invalid input"
    (is (thrown? ExceptionInfo (validate nil)))
    (is (thrown-with-msg? ExceptionInfo #"required"
          (validate {})))))
```

## Project Structure

```
project/
├── deps.edn              ; or project.clj
├── src/
│   └── myapp/
│       ├── core.clj      ; entry point
│       ├── domain.clj    ; business logic (pure)
│       └── db.clj        ; side-effects boundary
├── test/
│   └── myapp/
│       ├── core_test.clj
│       └── domain_test.clj
└── resources/
```

## Common Patterns

### Error Handling

```clojure
;; return data, not exceptions for expected errors
(defn parse-user [data]
  (if (valid? data)
    {:ok (transform data)}
    {:error :invalid-data}))

;; use ex-info for exceptional errors
(throw (ex-info "Database unavailable" {:type :db-error :retry? true}))

;; pattern match on results
(let [{:keys [ok error]} (parse-user data)]
  (if ok
    (save-user! ok)
    (log/warn "Parse failed" error)))
```

### State Management

```clojure
;; atoms for independent state
(def counter (atom 0))
(swap! counter inc)

;; component pattern for system state
(defn start-system [config]
  {:db (db/connect (:db config))
   :cache (cache/create)})

(defn stop-system [{:keys [db cache]}]
  (db/disconnect db)
  (cache/clear cache))
```

### Spec (when needed)

```clojure
(require '[clojure.spec.alpha :as s])

(s/def ::id pos-int?)
(s/def ::name (s/and string? seq))
(s/def ::user (s/keys :req-un [::id ::name]))

;; validate at boundaries
(defn create-user! [user-data]
  (if (s/valid? ::user user-data)
    (db/insert! user-data)
    (throw (ex-info "Invalid user" (s/explain-data ::user user-data)))))
```

## Avoid

```clojure
;; avoid def inside functions
(defn bad []
  (def x 1))  ; creates global!

;; avoid unnecessary let bindings
(let [x (foo)]
  x)  ; just call (foo)

;; avoid loop/recur when higher-order works
(loop [acc [] items items]  ; use reduce instead
  ...)

;; avoid doall unless truly needed
(doall (map side-effect! items))  ; use doseq or run!

;; avoid type hints unless performance-critical
^String name  ; premature optimization
```

## Running Tests

```bash
# deps.edn
clj -X:test

# Leiningen
lein test

# specific namespace
clj -X:test :nses '[myapp.core-test]'

# with test runner (Kaocha)
clj -M:test
```
