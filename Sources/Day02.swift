//
//  Day02.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 02.12.2024.
//

import Algorithms

struct Day02: AdventDay {
  var data: String

  func parseInput() -> [[Int]] {
    return data
      .split(separator: "\n")
      .map {
        $0.split(separator: " ").compactMap { Int($0) }
      }
  }

  func isRowSafe(_ row: [Int]) -> Bool {
    guard row.count >= 2 else { return true }

    let firstDiff = row[1] - row[0]
    guard firstDiff != 0 else { return false }
    let isIncreasing = firstDiff > 0

    for i in 0 ..< (row.count - 1) {
      let diff = row[i + 1] - row[i]

      guard diff != 0,
            isIncreasing ? diff > 0 : diff < 0,
            (1 ... 3).contains(abs(diff))
      else { return false }
    }

    return true
  }

  func part1() -> Int {
    let data = parseInput()
    let validRows = data.filter { isRowSafe($0) }.count

    return validRows
  }

  func isRowSafeWithDampener(_ row: [Int]) -> Bool {
    if isRowSafe(row) {
      return true
    }

    for index in 0 ... row.count - 1 {
      var modifiedRow = row
      modifiedRow.remove(at: index)

      if isRowSafe(modifiedRow) {
        return true
      }
    }
    return false
  }

  func part2() -> Int {
    let data = parseInput()

    let validRows = data.filter { isRowSafeWithDampener($0) }.count

    return validRows
  }
}
