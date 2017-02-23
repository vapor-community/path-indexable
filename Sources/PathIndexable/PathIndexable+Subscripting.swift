//
//  Genome
//
//  Created by Logan Wright
//  Copyright © 2016 lowriDevs. All rights reserved.
//
//  MIT
//

// MARK: Subscripts

extension PathIndexable {
    public subscript(path indexes: PathIndex...) -> Self? {
        get {
            return self[path: indexes]
        }
        set {
            self[path: indexes] = newValue
        }
    }

    public subscript(path indexes: [PathIndex]) -> Self? {
        get {
            let first: Optional<Self> = self
            return indexes.reduce(first) { next, index in
                /// if there's a next item, then the corresponding index
                /// for that item needs to access it. 
                ///
                /// once nil is found, keep returning nil, indexes don't matter
                ///
                ///
                ///
                return next.flatMap(index.get)
            }
        }
        set {
            var keys = indexes
            guard let first = keys.first else { return }
            keys.remove(at: 0)

            if keys.isEmpty {
                first.set(newValue, to: &self)
            } else {
                var next = self[path: first] ?? first.makeEmptyStructure() as Self
                next[path: keys] = newValue
                self[path: first] = next
            }
        }
    }
}

extension PathIndexable {
    public subscript(_ path: String) -> Self? {
        get {
            let comps = path.characters.split(separator: ".").map(String.init)
            return self[path: comps]
        }
        set {
            let comps = path.keyPathComponents()
            self[path: comps] = newValue
        }
    }

    public subscript(_ index: Int) -> Self? {
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
