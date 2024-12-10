//
//  Day10.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 10.12.2024.
//

import Testing

@testable import AdventOfCode

struct Day10Tests {
  let testData = """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  @Test func testPart1() async throws {
    let challenge = Day10(data: testData)
    #expect(Int(challenge.part1()) == 36)
  }

  @Test func testPart2() async throws {
    let challenge = Day10(data: testData)
    #expect(Int(challenge.part2()) == 81)
  }
}
