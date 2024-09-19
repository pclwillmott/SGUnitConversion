// -----------------------------------------------------------------------------
// SGUnitVoltage.swift
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
//     19/09/2024  Paul Willmott - SGUnitVoltage.swift created
// -----------------------------------------------------------------------------

import Foundation

public enum SGUnitVoltage : UInt8, CaseIterable, Sendable {
  
  // MARK: Enumeration
  
  case milliVolts = 0
  case volts      = 1

  // MARK: Public Properties
  
  public var title : String {
    return SGUnitVoltage.titles[self]!
  }

  public var symbol : String {
    return SGUnitVoltage.symbols[self]!
  }

  // MARK: Private Class Properties
  
  private static let titles : [SGUnitVoltage:String] = [
    .milliVolts : String(localized: "Millivolts"),
    .volts      : String(localized: "Volts"),
  ]

  private static let symbols : [SGUnitVoltage:String] = [
    .milliVolts : String(localized: "mV", comment: "Used for the abbreviation of millivolt"),
    .volts      : String(localized: "V", comment: "Used for the abbreviation of volt"),
  ]

  private static var map : String {
    
    var map = "<map>\n"

    for item in SGUnitVoltage.allCases {
      map += "<relation><property>\(item.rawValue)</property><value>\(item.title)</value></relation>\n"
    }

    map += "</map>\n"
    
    return map
    
  }
  // MARK: Public Class Properties
  
  public static let mapPlaceholder = "%%UNIT_VOLTAGE%%"

  // MARK: Public Class Methods
  
  // The factor to be applied to a voltage in units to get a voltage in volts.
  public static func toVolts(units: SGUnitVoltage) -> Double {
    
    switch units {
    case .milliVolts:
      return 1000.0
    case .volts:
      return 1.0
    }
    
  }
  
  // The factor to be applied to a voltage in volts to get a voltage in units.
  public static func fromVolts(units: SGUnitVoltage) -> Double {
    return 1.0 / toVolts(units: units)
  }
  
  public static func convert(fromValue:Double, fromUnits:SGUnitVoltage, toUnits:SGUnitVoltage) -> Double {
    return fromValue * toVolts(units: fromUnits) * fromVolts(units: toUnits)
  }

  public static func insertMap(cdi:String) -> String {
    return cdi.replacingOccurrences(of: mapPlaceholder, with: map)
  }

}
