//
//  Day09.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 09.12.2024.
//

import Testing

@testable import AdventOfCode

struct Day09Tests {
  let testData = """
  2333133121414131402
  """

  @Test func testPart1() async throws {
    let challenge = Day09(data: testData)
    #expect(Int(challenge.part1()) == 1928)
  }

  @Test func testPart2() async throws {
    let challenge = Day09(data: testData)
    #expect(Int(challenge.part2()) == 2858)
  }
}
