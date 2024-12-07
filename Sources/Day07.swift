//
//  Day07.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 07.12.2024.
//

import Algorithms

struct Day07: AdventDay {
  var data: String

  enum Operation {
    case add
    case multiply
  }

  struct Equation {
    let testValue: Int
    let numbers: [Int]

    func canGetTarget(_ target: Int, values: [Int]) -> Bool {
      var values = values
      guard let nextValue = values.popLast() else { fatalError() }
      guard values.count > 0 else { return target == nextValue }

      if target % nextValue == 0 && canGetTarget(target / nextValue, values: values) {
        return true
      }
      if target > nextValue && canGetTarget(target - nextValue, values: values) {
        return true
      }

      return false
    }

    func canGetTargetWithConcat(_ target: Int, values: [Int]) -> Bool {
      var values = values
      guard let nextValue = values.popLast() else { fatalError() }
      guard values.count > 0 else { return target == nextValue }

      if target % nextValue == 0 && canGetTargetWithConcat(target / nextValue, values: values) {
        return true
      }
      if target > nextValue && canGetTargetWithConcat(target - nextValue, values: values) {
        return true
      }

      let stringTarget = String(target)
      let stringNext = String(nextValue)

      if stringTarget.hasSuffix(stringNext), canGetTargetWithConcat(stringTarget.removeSuffix(stringNext), values: values) {
        return true
      }

      return false
    }
  }

  func parseInput() -> [Equation] {
    let rows = data.split(separator: "\n")

    let rowsSplit = rows.map { $0.split(separator: ":") }

    return rowsSplit.map {
      Equation(testValue: Int($0[0])!, numbers: $0[1].split(separator: " ").map { Int($0)! })
    }
  }

  func part1() -> Int {
    let values = parseInput()

    return values.filter { $0.canGetTarget($0.testValue, values: $0.numbers) }.reduce(0) { $0 + $1.testValue }
  }

  func part2() -> Int {
    let values = parseInput()

    return values.filter { $0.canGetTargetWithConcat($0.testValue, values: $0.numbers) }.reduce(0) { $0 + $1.testValue }
  }
}

extension String {
  func removeSuffix(_ suffix: String) -> Int {
    Int(self[..<index(endIndex, offsetBy: -suffix.count)])!
  }
}
