//: Playground - noun: a place where people can play

import Cocoa

let numerals = [0.1, 0.101, 0.10101, 0.1010101, 1/1000.0/10000.0/100.0]

let formatter = NumberFormatter()
formatter.minimumFractionDigits = 9
formatter.minimumIntegerDigits = 1
numerals.forEach { (value) in
  print(formatter.string(for: value))
}
