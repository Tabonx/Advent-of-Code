//
//  Day05.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 05.12.2024.
//

import Algorithms

struct Day05: AdventDay {
  var data: String

  struct OrderingRule {
    let left: Int
    let right: Int

    func validate(leading: Int, trailing: Int) -> Bool? {
      guard leading == left || leading == right else { return nil }
      guard trailing == left || trailing == right else { return nil }

      return leading == left && trailing == right
    }
  }

  func parseInput() -> (rules: [OrderingRule], pages: [[Int]]) {
    let input = data.split(separator: "\n\n")

    let rules = input[0].split(separator: "\n").map { $0.split(separator: "|") }.map { OrderingRule(left: Int($0[0])!, right: Int($0[1])!) }

    let pages = input[1].split(separator: "\n").map { $0.split(separator: ",").map { Int($0)! }}

    return (rules, pages)
  }

  func getValidRules(allRules: [OrderingRule], pages: [Int]) -> [OrderingRule] {
    let validRules = allRules.filter { rule in
      pages.contains(rule.left) && pages.contains(rule.right)
    }

    return validRules
  }

  func getResultForCorrectRows() -> Int {
    let (rules, pages) = parseInput()
    var result = 0

    pagesLoop: for page in pages {
      let validRules = getValidRules(allRules: rules, pages: page)

      let t = page.lazy.combinations(ofCount: 2)

      for value in t {
        for rule in validRules {
          if let result = rule.validate(leading: value[0], trailing: value[1]) {
            if result == false {
              continue pagesLoop
            }
          }
        }
      }

      let middleValue = page[page.count / 2]
      result += middleValue
    }

    return result
  }

  func part1() -> Int {
    return getResultForCorrectRows()
  }

  func getInvalidRows() -> [(row: [Int], rules: [OrderingRule])] {
    let (rules, pages) = parseInput()

    var invalidRows = [(row: [Int], rules: [OrderingRule])]()

    pagesLoop: for page in pages {
      let validRules = getValidRules(allRules: rules, pages: page)

      let t = page.lazy.combinations(ofCount: 2)

      for value in t {
        for rule in validRules {
          if let result = rule.validate(leading: value[0], trailing: value[1]) {
            if result == false {
              invalidRows.append((row: page, rules: validRules))
              continue pagesLoop
            }
          }
        }
      }
    }

    return invalidRows
  }

  func getInvalidRowsMiddleValues() -> Int {
    let invalidRows = getInvalidRows()
    var result = 0

    for pair in invalidRows {
      let sorted = pair.row.sorted { first, second in

        for rule in pair.rules {
          if let result = rule.validate(leading: first, trailing: second) {
            return result
          }
        }

        return false
      }

      let middleValue = sorted[sorted.count / 2]
      result += middleValue
    }

    return result
  }

  func part2() -> Int {
    return getInvalidRowsMiddleValues()
  }
}
