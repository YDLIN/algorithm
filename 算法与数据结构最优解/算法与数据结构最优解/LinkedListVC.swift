//
//  LinkedListVC.swift
//  算法与数据结构最优解
//
//  Created by Du on 2018/6/5.
//  Copyright © 2018年 TEST. All rights reserved.
//


/*
 这是第二章链表的内容
 */
import UIKit

//节点
public class LinkedListNode<T> {
    var value: T
    
    weak var previous: LinkedListNode?
    
    var next: LinkedListNode?
    
    public init(value: T) {
        self.value = value
    }
}

//链表
public class LinkedList<T> {
    public typealias Node = LinkedListNode<T>
    // 是否为空
    public var isEmpty: Bool {
        return head == nil
    }
    
    // 节点数
    public var count: Int {
        
        guard var node = head else {
            return 0
        }
        
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }
        return count
    }
    
    // 首个节点
    private var head: Node?
    
    // 首个节点
    public var first: Node? {
        return head
    }
    
    // 最后的节点
    public var last: Node? {
        guard var node = head else {
            return nil
        }
        
        while let next = node.next {
            node = next
        }
        return node
    }
    
    // 通过index获取节点
    public func node(atIndex index: Int) -> Node? {
        if index == 0 {
            //head node
            return head!
        } else {
            var node = head!.next
            guard index < count else {
                return nil;
            }
            for _ in 1 ..< index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            return node!
        }
    }
    
    public func appendToTail(value: T) {
        let newNode = Node(value: value)
        if let lastNode = last {// 更新节点的正确顺序
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {// 链表为空
            head = newNode
        }
    }
    
    
    public func insertToHead(value: T) {
        let newHead = Node(value: value)
        if head == nil {// 链表为空
            head = newHead
        }else {
            newHead.next = head
            head?.previous = newHead
            head = newHead
        }
    }
    
    public func insert(_ node: Node, atIndex index: Int) {
        if index < 0 {
            print("invalid input index")
            return
        }
        let newNode = node
        if count == 0 {
            head = newNode
        }else {
            if index == 0 {
                newNode.next = head
                head?.previous = newNode
                head = newNode
            } else {
                if index > count {
                    print("out of range")
                    return
                }
                let prev = self.node(atIndex: index-1)
                let next = prev?.next
                newNode.previous = prev
                newNode.next = prev?.next
                prev?.next = newNode
                next?.previous = newNode
            }
        }
    }
    
    
    public func removeAll() {
        head = nil
    }
    
    
    public func removeLast() -> T? {
        guard !isEmpty else {
            return nil
        }
        return remove(node: last!)
    }
    
    public func remove(node: Node) -> T? {
        guard head != nil else {
            print("linked list is empty")
            return nil
        }
        let prev = node.previous
        let next = node.next
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev
        node.previous = nil
        node.next = nil
        return node.value
    }
    
    
    public func removeAt(_ index: Int) -> T? {
        guard head != nil else {
            return nil
        }
        let node = self.node(atIndex: index)
        guard node != nil else {
            return nil
        }
        return remove(node: node!)
    }
    
    public func printAllNodes(){
        guard head != nil else {
            return
        }
        var node = head
        for index in 0..<count {
            if node == nil {
                break
            }
            
            print("[\(index)]\(node!.value)")
            node = node!.next
        }
    }
}

class LinkedListVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let list = LinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        list.appendToTail(value: 3)
        list.appendToTail(value: 4)
        list.appendToTail(value: 5)
        list.appendToTail(value: 6)
        list.appendToTail(value: 7)
        
        
        let list2 = LinkedList<Int>()
        list2.appendToTail(value: 1)
        list2.appendToTail(value: 6)
        list2.appendToTail(value: 7)
        
        print(reverseNodeList(head: list2.first)?.value)
        
    }
    
    func printCommonPart(list1: LinkedList<Int>, list2: LinkedList<Int>) {
        var node_1 = list1.first
        var node_2 = list2.first
        while node_1 != nil && node_2 != nil {
            if (node_1?.value)! < (node_2?.value)! {
                node_1 = node_1?.next
            }else if (node_1?.value)! > (node_2?.value)! {
                node_2 = node_2?.next
            }else {// 两个节点的值相等，同时下移
                debugPrint((node_1?.value)!)
                node_1 = node_1?.next
                node_2 = node_2?.next
            }
        }
    }
    
    
    // 反转双向链表
    func reverseNodeList(head: LinkedListNode<Int>?) -> LinkedListNode<Int>? {
        if head == nil || head?.next == nil {
            return head
        }
        var headNode: LinkedListNode<Int>? = head
        var reverseHeadNode: LinkedListNode<Int>?
        var preNode: LinkedListNode<Int>?

        while headNode != nil {
            let tempNode = headNode?.next // 保留继续循环的节点
            if  tempNode == nil {
                reverseHeadNode = headNode // 最终返回的节点
            }

            headNode?.next = preNode // 将next变成previous
            preNode = headNode
            headNode = tempNode // headNode指向原来链表的下一个节点
        }

        return reverseHeadNode
    }
}
