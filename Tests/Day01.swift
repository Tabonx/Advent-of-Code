//
//  Day01.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 01.12.2024.
//

import Testing

@testable import AdventOfCode

struct Day01Tests {
  let testData = """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  @Test func testPart1() async throws {
    let challenge = Day01(data: testData)
    #expect(Int(challenge.part1()) == 11)
  }

  @Test func testPart2() async throws {
    let challenge = Day01(data: testData)
    #expect(Int(challenge.part2()) == 31)
  }
}
