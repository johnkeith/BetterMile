//: Playground - noun: a place where people can play

import UIKit

class Test: NSObject {
    let klass = type(of: self)
    
    func whoAmI() {
        print(klass)
    }
}

let inst = Test()
inst.whoAmI()
