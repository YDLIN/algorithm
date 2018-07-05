//
//  StackAndQueue.swift
//  算法与数据结构最优解
//
//  Created by Du on 2018/6/5.
//  Copyright © 2018年 TEST. All rights reserved.
//

import UIKit

/**************************************************获取栈中的最小元素*******************************************************/
protocol Stack {
    associatedtype Element
    var isEmpty: Bool { get }
    var size: Int { get }
    var peek: Element? { get }
    mutating func push(_ newElement: Element)
    mutating func pop() -> Element?
}

protocol getMin {
    associatedtype Element
    mutating func min() -> Element?
}

//整型栈结构
struct IntStack: Stack {
    typealias Element = Int
    
    private var stack = [Element]()
    
    var isEmpty: Bool {
        return stack.isEmpty
    }
    
    var size: Int {
        return stack.count
    }
    
    var peek: Int? {
        return stack.last
    }
    
    mutating func push(_ newElement: Int) {
        stack.append(newElement)
    }
    
    mutating func pop() -> Int? {
        return stack.popLast()
    }
}

//能获取最小值的栈结构
struct getMinStack: Stack, getMin {
    typealias Element = Int
    
    private var stackData = IntStack()
    private var stackMin = IntStack()
    
    var isEmpty: Bool {
        return stackData.isEmpty
    }
    
    var size: Int {
        return stackData.size
    }
    
    var peek: Int? {
        return stackData.peek
    }
    
    mutating func push(_ newElement: Int) {
        //stackData
        stackData.push(newElement)
        //stackMin
        if stackMin.isEmpty {
            stackMin.push(newElement)
        }else {
            //只有新元素比栈顶元素小，才push
            if let minObject = min() {
                if newElement <= minObject {
                    stackMin.push(newElement)
                }
            }
        }
    }
    
    mutating func pop() -> Int? {
        return stackData.pop()
    }
    
    func min() -> getMinStack.Element? {
        if !stackMin.isEmpty {
            return stackMin.peek
        }else {
            return nil
        }
    }
}

/**************************************************两个栈实现一个队列*******************************************************/
protocol Queue {
    associatedtype Element
    mutating func add(_ newElement: Element)
    mutating func poll() -> Element?
    mutating func peek() -> Element?
}

struct QueueFromStack: Queue {
    typealias Element = Int
    var stackPush = IntStack()
    var stackPop = IntStack()
    
    mutating func add(_ newElement: Int) {
        stackPush.push(newElement)
    }
    
    mutating func poll() -> Int? {
        if stackPush.isEmpty && stackPop.isEmpty {
            debugPrint("Queue is empty!")
            return nil
        }else if stackPop.isEmpty {
            while !stackPush.isEmpty {
                stackPop.push(stackPush.pop()!)
            }
        }
        return stackPop.pop()
    }
    
    mutating func peek() -> Int? {
        if stackPush.isEmpty && stackPop.isEmpty {
            debugPrint("Queue is empty!")
            return nil
        }else if stackPop.isEmpty {
            while !stackPush.isEmpty {
                stackPop.push(stackPush.pop()!)
            }
        }
        return stackPop.peek
    }
}

/**************************************************用递归逆序一个栈*******************************************************/
//移除栈底元素，并返回栈底元素
func getAndRemoveLastElement(stack: inout IntStack) -> Int {
    guard let result = stack.pop() else { return -1}
    if stack.isEmpty {
        return result
    }else {
        let last = getAndRemoveLastElement(stack: &stack)
        stack.push(result)//此时stack已经是移除栈底元素的stack
        return last
    }
}

// 逆序栈
func reverse(stack: inout IntStack) {
    if stack.isEmpty {
        //经过getAndRemoveLastElement(stack:)后，每次都会移除栈底元素，最终栈中元素会清空，就会来到这里
        return
    }
    /*
     多次返回栈底元素
     1->2->3
    */
    let i = getAndRemoveLastElement(stack: &stack)
    reverse(stack: &stack)
    /*
     此时stack已经为空，然后一次逆序push上一个栈返回的栈底元素
     push i = 3 -> [3]
     push i = 2 -> [3, 2]
     push i = 3 -> [3, 2, 1]
     */
    stack.push(i)
}

/**************************************************猫狗队列*******************************************************/
class Pet {
    private var type: String?
    init(type: String) {
        self.type = type
    }
    
    public func getType() -> String? {
        return type
    }
}

class Dog: Pet {
    init() {
        super.init(type: "Dog")
    }
}

class Cat: Pet {
    init() {
        super.init(type: "Cat")
    }
}

class PetEnterQueue {
    private var pet: Pet?
    private var count: Int?
    init(pet: Pet, count: Int) {
        self.pet = pet
        self.count = count
    }
    
    public func getPet() -> Pet? {
        return self.pet
    }
    
    public func getCount() -> Int? {
        return self.count
    }
    
    public func getEnterPetType() -> String? {
        return self.pet?.getType()
    }
}

class DogCatQueue {
    private var dogQ: LinkedList<PetEnterQueue>!
    private var catQ: LinkedList<PetEnterQueue>!
    private var count = 0
    
    init() {
        dogQ = LinkedList<PetEnterQueue>()
        catQ = LinkedList<PetEnterQueue>()
    }
    
    public func add(pet: Pet) {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        if pet.getType() == "Dog" {
            dogQ.appendToTail(value: PetEnterQueue(pet: pet, count: timeStamp))
        }else if pet.getType() == "Cat" {
            catQ.appendToTail(value: PetEnterQueue(pet: pet, count: timeStamp))
        }else {
            fatalError("error， not dog or cat")
        }
    }
    
    public func pollAll() -> Pet? {
        if !dogQ.isEmpty && !catQ.isEmpty {
            let dog = dogQ.last?.value
            let cat = catQ.last?.value
            if (dog?.getCount())! < (cat?.getCount())! {
                return dogQ?.last?.value.getPet()
            }else {
                return catQ?.last?.value.getPet()
            }
        }else if !dogQ.isEmpty {
            return dogQ.last?.value.getPet()
        }else if !catQ.isEmpty {
            return catQ?.last?.value.getPet()
        }else {
            fatalError("error， queue is empty!")
        }
    }
    
    public func pollDog() -> Dog {
        if !isDogQueueEmpty() {
            return dogQ.first?.value.getPet() as! Dog
        }else {
            fatalError("Dog queue is empty!")
        }
    }

    public func pollCat() -> Cat {
        if !isCatQueueEmpty() {
            return catQ.first?.value.getPet() as! Cat
        }else {
            fatalError("Cat queue is empty!")
        }
    }
    
    public func isEmpty() -> Bool {
        return dogQ.isEmpty && catQ.isEmpty
    }
    
    public func isDogQueueEmpty() -> Bool {
        return dogQ.isEmpty
    }
    
    public func isCatQueueEmpty() -> Bool {
        return catQ.isEmpty
    }
}

/***********************************************用一个栈实现另一个栈的排序****************************************************/
func sortStackByStack(stack: IntStack) -> IntStack {
    var tempStack = stack
    //申请的辅助栈
    var helpStack = IntStack()
    while !tempStack.isEmpty {//如果原来栈的元素全都push到辅助栈上，则证明辅助栈从栈顶到栈底已经按小到大排好序了，则停止循环
        guard let cur = tempStack.pop() else { return tempStack }
        if helpStack.isEmpty {//辅助栈为空
            helpStack.push(cur)
        }else {//辅助栈不为空
            while helpStack.peek! <= cur {
                if let topElement = helpStack.pop() {
                    tempStack.push(topElement)
                }
            }
            helpStack.push(cur)
        }
    }
    //将辅助栈的元素逐一pop出来，push回到原来的栈上（原来栈已空），则原来栈就从栈顶到栈底就是按照从大到小的排序
    while !helpStack.isEmpty {
        if let element = helpStack.pop() {
            tempStack.push(element)
        }
    }
    return tempStack
}

/***********************************************用递归来解决汉诺塔问题****************************************************/
func hanoiProblem1(num: Int, left: String, mid: String, right: String) -> Int {
    if num < 1 {
        return 0
    }
    return process(num, left, mid, right, from: left, to: right)
}

func process(_ num: Int, _ left: String, _ mid: String, _ right: String, from: String, to: String) -> Int {
    if num == 1 {//一层
        if from == mid || to == mid {//中->左、中->右、左->中、右->中
            print("Move 1 from \(from) to \(to)")
            return 1
        }else {//左->右、右->左
            print("Move 1 from \(from) to \(mid)")
            print("Move 1 from \(mid) to \(to)")
            return 2
        }
    }
    
    //多层
    if from == mid || to == mid {//中->左、中->右、左->中、右->中
        let another = (from == left || to == left) ? right : left
        let part1 = process(num - 1, left, mid, right, from: from, to: another)
        let part2 = 1
        print("Move \(num) from \(from) to \(to)")
        let part3 = process(num - 1, left, mid, right, from: another, to: to)
        return part1 + part2 + part3
    }else {//左->右、右->左
        let part1 = process(num - 1, left, mid, right, from: from, to: to)
        let part2 = 1
        print("Move \(num) from \(from) to \(mid)")
        let part3 = process(num - 1, left, mid, right, from: to, to: from)
        let part4 = 1
        print("Move \(num) from \(mid) to \(to)")
        let part5 = process(num - 1, left, mid, right, from: from, to: to)
        return part1 + part2 + part3 + part4 + part5
    }
}

/***********************************************用栈来解决汉诺塔问题****************************************************/
//移动方式
public enum Action {
    case No  //初始状态
    case LToM//左->中
    case MToL//中->左
    case MToR//中->右
    case RToM//右->中
}
/*
 相邻不可逆原则：假设这一步是左->中，那么下一步就不可能是中->左，因为这样的话就不是移动次数最小的最优解
 小压大原则：一个动作的放生的前提条件是移出栈的栈顶元素不能大于移入栈的栈顶元素
 */
func hanoiProblem2(num: Int, left: String, mid: String, right: String) -> Int {
    //左栈
    var lS = IntStack()
    //中间栈
    var mS = IntStack()
    //右栈
    var rS = IntStack()
    //先往每个栈底放一个最大的整数
    lS.push(Int.max)
    mS.push(Int.max)
    rS.push(Int.max)
    
    for i in (1...num).reversed() {
        lS.push(i)
    }
    
    var record = [Action.No]
    var step = 0
    while rS.size != num + 1 {//当右边的栈等于(层数 + 1)就停止循环，表明所有的层都移到右边的栈里面去了
        /*
         1.第一个动作一定是：左->中
         2.根据”相邻不可逆“和”小压大“两个原则，所以第二个动作不肯是中->左和左->中
         3.那剩下的只有中->右，右->中两种移动方式，又根据”小压大“原则，这两种方式里面，只有一种是符合要求的
         综上，每一步只有一个方式符合，那么每走一步都根据两个原则来查看所有方式，只需执行符合要求的方式即可
         */
        step += fStackTotStack(record: &record, preNoAct: .MToL, nowAct: .LToM, fStack: &lS, tStack: &mS, from: left, to: mid)
        step += fStackTotStack(record: &record, preNoAct: .LToM, nowAct: .MToL, fStack: &mS, tStack: &lS, from: mid, to: left)
        step += fStackTotStack(record: &record, preNoAct: .RToM, nowAct: .MToR, fStack: &mS, tStack: &rS, from: mid, to: right)
        step += fStackTotStack(record: &record, preNoAct: .MToR, nowAct: .RToM, fStack: &rS, tStack: &mS, from: right, to: mid)
    }
    return step
}

func fStackTotStack(record: inout [Action], preNoAct: Action, nowAct: Action, fStack: inout IntStack, tStack: inout IntStack, from: String, to: String) -> Int {
    guard let fTop = fStack.peek else { return 0 }
    guard let tTop = tStack.peek else { return 0 }
    if record[0] != preNoAct && fTop < tTop {//相邻不可逆原则 && 小压大原则
        if let topElement = fStack.pop() {
            tStack.push(topElement)
        }
        guard let tTop2 = tStack.peek else { return 0 }
        print("Move \(tTop2) from \(from) to \(to)")
        record[0] = nowAct
        return 1
    }
    return 0
}

/***********************************************生成窗口最大值数组****************************************************/
//如果qmax队头的下标等于i(下标)-w(窗口长度)，说明当前qmax队头的下标已过期，弹出当前对头的下标即可。
//
//4 3 5 4 3 3 6 7

func getMaxWindow(array: Array<Int>, windowSize w: Int) -> Array<Int> {
    if array.isEmpty || w < 1 || array.count < w {
        return []
    }
    
    /*
     1.用来存放array的下标
     2.通过不断的更新，qmax里面存放的第一个下标所对应array中的元素就是当前窗口子数组的最大元素
     */
    var qmax = [Int]()
    //初始化一个长度为(array.count - w + 1)的数组
    var res = Array.init(repeating: 0, count: (array.count - w + 1))
    var index: Int = 0
    
    for i in (0..<array.count) {
        /*************qmax的放入规则***************/
        //qmax不为空
        while !qmax.isEmpty && array[qmax.last!] <= array[i] {
            qmax.removeLast()
        }
        
        //如果qmax为空，直接把下标添加进去
        //如果array[qmax.last!] > array[i]，直接把下标添加进去
        qmax.append(i)
        
        /*************qmax的弹出规则***************/
        //如果下标过期，则删除最前面过期的元素
        if let firstIndex = qmax.first {
            if firstIndex == (i - w) {
                qmax.removeFirst()
            }
        }
        
        /*
         这个条件是确保第一个窗口中的每个元素都已经遍历完
         这个例子中：第一个窗口对应的子数组是[4, 3, 5]，所以i要去到2的时候才知道5是子数组里面的最大值，这样才能把最大值取出，放入res数组中。之后每移动一步都会产生一个最大
         */
        if i >= w - 1 {
            if index <= res.count - 1 {//确保不越界
                if let fistIndex = qmax.first {
                    res[index] = array[fistIndex]
                }
                index += 1
            }
        }
    }
    return res
}

/***********************************************最大值减去最小值小于或等于num的子数组数量****************************************************/
func getNum(array: Array<Int>, num: Int) -> Int {
    if array.isEmpty || array.count == 0 {
        return 0
    }
    //首元素代表当前子数组中的最大值的下标
    var qmax = [Int]()
    //首元素代表当前子数组中的最小值的下标
    var qmin = [Int]()
    
    //表示数组的范围
    var i = 0
    var j = 0
    //满足条件的子数组数量
    var res = 0
    
    while i < array.count {
        while j < array.count {
            while !qmin.isEmpty && array[qmin.last!] >= array[j] {
                qmin.removeLast()
            }
            qmin.append(j)
            while !qmax.isEmpty && array[qmax.last!] <= array[j] {
                qmax.removeLast()
            }
            qmax.append(j)
            //不满足题目的要求，j就停止向右扩
            if array[qmax.first!] - array[qmin.first!] > num {
                break
            }
            //j向右扩
            j += 1
        }
        
        if let firstIndex = qmin.first {
            if firstIndex == i {
                qmin.removeFirst()
            }
        }
        
        if let firstIndex = qmax.first {
            if firstIndex == i {
                qmax.removeFirst()
            }
        }
        
        // 假设i = 0,j = 5时：[0..4], [0..3], [0..2], [0..1], [0..0], 一共(j - i)个符合条件的子数组
        //j向右扩停止后，所以array[i..j-1]->array[i..i]子数组都符合条件，所以res += j - i
        res += (j - i)
       
        i += 1
    }
    return res
}

/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/
class StackAndQueue: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let array = [3, 4, 5, 7]
        print(getNum(array: array, num: 2))
        /*
         符合要求的数组有：
         [3]
         [4]
         [5]
         [7]
         [3, 4]
         [4, 5]
         [5, 7]
         [3, 4, 5]
         */
    }
    
    func stack_min() {
        let testArray = [3, 4, 5, 7, 6, 9, 2, 10]
        var minStack = getMinStack()
        for num in testArray {
            minStack.push(num)
        }
        if !minStack.isEmpty {
            debugPrint(minStack.min()!)
        }
    }
    
    func stack_queue() {
        let testArray = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        var queue = QueueFromStack()
        
        for num in testArray {
            queue.add(num)
        }
        
        debugPrint(queue.peek()!)// 输出1
        debugPrint(queue.poll()!)// 输出1
        debugPrint(queue.peek()!)// 输出2
    }
    
    //递归逆序栈
    func stack_reverse() {
        let testArray = [1, 2, 3]
        var stack = IntStack()
        for num in testArray {
            stack.push(num)
        }
        reverse(stack: &stack)
        print(stack)//IntStack(stack: [3, 2, 1])
    }
    
    //用一个栈实现另一个栈的排序
    func stack_sortByStack() {
        var stack = IntStack()
        let testArray = [3, 4, 5, 7, 6, 9, 2, 10]
        for num in testArray {
            stack.push(num)
        }
        
        print(sortStackByStack(stack: stack))
    }
    
    //使用递归来解决汉诺塔问题
    func hanoiWithRecursion() {
        let num = hanoiProblem1(num: 2, left: "左", mid: "中", right: "右")
        print("It will move \(num) steps.")
    }
    
    //使用栈来解决汉诺塔问题
    func hanoiWithStack() {
        let step = hanoiProblem2(num: 3, left: "左", mid: "中", right: "右")
        print("It will move \(step) steps.")
    }
    
    //生成窗口最大值数组
    func getMaxValueFromSubWindow() {
        let array1 = [4, 3, 5, 4, 3, 3, 6, 7]
        print(getMaxWindow(array: array1, windowSize: 3))
        let array2 = [44, 31, 53, 14, 23, 93, 46, 27]
        print(getMaxWindow(array: array2, windowSize: 4))
    }
}
