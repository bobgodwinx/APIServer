//
//  DateExtension.swift
//  APIServer
//
//  Created by Bob Godwin Obi on 12/12/16.
//
//

import Foundation
import Node

private let formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter
}()

extension Date: NodeRepresentable {
    /**
     Turn the convertible into a node
     
     - throws: if convertible can not create a Node
     - returns: a node if possible
     */
    public func makeNode(context: Context) throws -> Node {
        let string = formatter.string(from:self)
        return Node(string)
    }
}

extension Date: NodeInitializable {
    
    public init(node: Node, in context: Context) throws {
        guard let date = node.string.flatMap(formatter.date) else {
            throw NodeError.unableToConvert(node: node, expected: "\(String.self)")
        }
        self = date
    }
}
