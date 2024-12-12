//
//  Day12.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 12.12.2024.
//

import Testing

@testable import AdventOfCode

struct Day12Tests {
  let testData = """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  @Test func testPart1() async throws {
    let challenge = Day12(data: testData)
    #expect(Int(challenge.part1()) == 1930)
  }

  @Test func testPart2() async throws {
    let challenge = Day12(data: testData)
    #expect(Int(challenge.part2()) == 1206)
  }
}
