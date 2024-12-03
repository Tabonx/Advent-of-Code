//
//  Day03.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 03.12.2024.
//

import Algorithms
import RegexBuilder

struct Day03: AdventDay {
  var data: String

  func parseInput() -> Int {
    let leftRef = Reference(Int.self)
    let rightRef = Reference(Int.self)

    let regex = Regex {
      "mul("

      TryCapture(as: leftRef) {
        OneOrMore(.digit)
      }
      transform: { match in
        Int(match)
      }

      ","

      TryCapture(as: rightRef) {
        OneOrMore(.digit)
      } transform: { match in
        Int(match)
      }

      ")"
    }

    let matches = data.matches(of: regex)

    var result = 0

    for match in matches {
      result += match[leftRef] * match[rightRef]
    }

    return result
  }

  func part1() -> Int {
    return parseInput()
  }

  func parseInput2() -> Int {
    let doRef = Reference(String?.self)

    let leftRef = Reference(Int.self)
    let rightRef = Reference(Int.self)

    let regex = Regex {
      Optionally {
        TryCapture(as: doRef) {
          ChoiceOf {
            "do()"
            "don't()"
          }
        } transform: { match in
          String(match)
        }
        Optionally {
          ZeroOrMore(.any, .reluctant)
        }
      }

      "mul("

      TryCapture(as: leftRef) {
        OneOrMore(.digit)
      } transform: { match in
        Int(match)
      }

      ","

      TryCapture(as: rightRef) {
        OneOrMore(.digit)
      } transform: { match in
        Int(match)
      }

      ")"
    }

    let matches = data.matches(of: regex)

    var result = 0

    var enabled = true

    for match in matches {
      let doMatch = match[doRef]
      if doMatch == "do()" {
        enabled = true
      } else if doMatch == "don't()" {
        enabled = false
      }

      if enabled {
        result += match[leftRef] * match[rightRef]
      }
    }

    return result
  }

  func part2() -> Int {
    return parseInput2()
  }
}
