///  Indexable
///  ["a": [["foo":"bar"]]]
///  Indexer list
///  ["a", 0, "foo"]
///
///  "a"
///  [["foo":"bar"]]
///  [0, "foo"]
///
///  0
///  ["foo":"bar"]
///  ["foo"]
///
///  "foo"
///  "bar"
///  []
///
///  ret bar
extension PathIndexable {
    /// Access via comma separated list of indexers, for example
    /// ["key", 0, "path", "here"
    public subscript(path indexers: PathIndexer...) -> Self? {
        get {
            return self[path: indexers]
        }
        set {
            self[path: indexers] = newValue
        }
    }

    /// Sometimes we prefer (or require) arrays of indexers
    /// those are accepted here
    public subscript(path indexers: [PathIndexer]) -> Self? {
        get {
            /// if there's a next item, then the corresponding index
            /// for that item needs to access it.
            ///
            /// once nil is found, keep returning nil, indexers don't matter at that point
            return indexers.reduce(self) { nextIndexable, nextIndexer in
                return nextIndexable.flatMap(nextIndexer.get)
            }
        }
        set {
            guard let currentIndexer = indexers.first else { return }
            var indexersRemaining = indexers
            indexersRemaining.removeFirst()

            if indexersRemaining.isEmpty {
                currentIndexer.set(newValue, to: &self)
            } else {
                var next = self[path: currentIndexer] ?? currentIndexer.makeEmptyStructureForIndexing() as Self
                next[path: indexersRemaining] = newValue
                self[path: currentIndexer] = next
            }
        }
    }
}

extension PathIndexable {
    /// access an item via a keypath, for example
    /// 
    /// "key.path.0.foo"
    public subscript(keyPath: String) -> Self? {
        get {
            let comps = keyPath.keyPathComponents()
            return self[path: comps]
        }
        set {
            let comps = keyPath.keyPathComponents()
            self[path: comps] = newValue
        }
    }

    /// Access an item via an index
    public subscript(index: Int) -> Self? {
        get {
            return self[path: index]
        }
        set {
            self[path: index] = newValue
        }
    }
}

extension String {
    internal func keyPathComponents() -> [String] {
        return characters
            .split(separator: ".")
            .map(String.init)
    }
}
