//
//  Day11.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 11.12.2024.
//

import Testing

@testable import AdventOfCode

struct Day11Tests {
  let testData = """
  125 17
  """

  @Test func testPart1() async throws {
    let challenge = Day11(data: testData)
    #expect(Int(challenge.part1()) == 55312)
  }

  @Test func testPart2() async throws {
    let challenge = Day11(data: testData)
    #expect(Int(challenge.part2()) == 81)
  }
}
