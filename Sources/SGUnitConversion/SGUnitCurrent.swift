// -----------------------------------------------------------------------------
// SGUnitCurrent.swift
//
// This Swift source file is part of the SGUnitConversion package 
// by Paul C. L. Willmott.
//
// Copyright © 2024 Paul C. L. Willmott. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the “Software”), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
// SOFTWARE.
// -----------------------------------------------------------------------------
//
// Revision History:
//
//     19/09/2024  Paul Willmott - SGUnitCurrent.swift created
// -----------------------------------------------------------------------------

import Foundation

public enum SGUnitCurrent : UInt8, CaseIterable, Sendable {
  
  // MARK: Enumeration
  
  case milliAmps = 0
  case amps      = 1

  // MARK: Public Properties
  
  public var title : String {
    return SGUnitCurrent.titles[self]!
  }

  public var symbol : String {
    return SGUnitCurrent.symbols[self]!
  }

  // MARK: Private Class Properties
  
  private static let titles : [SGUnitCurrent:String] = [
    .milliAmps : String(localized: "Milliampere"),
    .amps      : String(localized: "Ampere"),
  ]

  private static let symbols : [SGUnitCurrent:String] = [
    .milliAmps : String(localized: "mA", comment: "Used for the abbreviation of milliampere"),
    .amps : String(localized: "A", comment: "Used for the abbreviation of Ampere"),
  ]

  private static var map : String {
    
    var map = "<map>\n"

    for item in SGUnitCurrent.allCases {
      map += "<relation><property>\(item.rawValue)</property><value>\(item.title)</value></relation>\n"
    }

    map += "</map>\n"
    
    return map
    
  }
  // MARK: Public Class Properties
  
  public static let mapPlaceholder = "%%UNIT_CURRENT%%"

  // MARK: Public Class Methods
  
  // The factor to be applied to a current in units to get a current in amps.
  public static func toAmps(units: SGUnitCurrent) -> Double {
    
    switch units {
    case .milliAmps:
      return 1000.0
    case .amps:
      return 1.0
    }
    
  }
  
  // The factor to be applied to a current in amps to get a current in units.
  public static func fromAmps(units: SGUnitCurrent) -> Double {
    return 1.0 / toAmps(units: units)
  }
  
  public static func convert(fromValue:Double, fromUnits:SGUnitCurrent, toUnits:SGUnitCurrent) -> Double {
    return fromValue * toAmps(units: fromUnits) * fromAmps(units: toUnits)
  }

  public static func insertMap(cdi:String) -> String {
    return cdi.replacingOccurrences(of: mapPlaceholder, with: map)
  }

}
