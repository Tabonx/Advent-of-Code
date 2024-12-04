//
//  Day04.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 04.12.2024.
//

import Testing

@testable import AdventOfCode

struct Day04Tests {
  let testData = """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  @Test func testPart1() async throws {
    let challenge = Day04(data: testData)
    #expect(Int(challenge.part1()) == 18)
  }

  @Test func testPart2() async throws {
    let challenge = Day04(data: testData)
    #expect(Int(challenge.part2()) == 9)
  }
}
