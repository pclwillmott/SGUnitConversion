// -----------------------------------------------------------------------------
// SGUnitSpeed.swift
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
//     19/09/2024  Paul Willmott - SGUnitSpeed.swift created
// -----------------------------------------------------------------------------

import Foundation
import AppKit

public enum SGUnitSpeed : UInt8, CaseIterable, Sendable {
  
  // MARK: Enumeration
  
  case centimetersPerSecond = 0
  case metersPerSecond = 1
  case kilometersPerHour = 2
  case inchesPerSecond = 3
  case feetPerSecond = 4
  case milesPerHour = 5

  // MARK: Public Properties
  
  public var title : String {
    
    return SGUnitSpeed.titles[self]!
  }

  public var symbol : String {
    
    return SGUnitSpeed.symbols[self]!
  }

  // MARK: Private Class Properties

  private static var map : String {
    
    var map = "<map>\n"

    for item in SGUnitSpeed.allCases {
      map += "<relation><property>\(item.rawValue)</property><value>\(item.title)</value></relation>\n"
    }

    map += "</map>\n"
    
    return map
    
  }
  
  // MARK: Private Class Properties
  
  private static let titles : [SGUnitSpeed:String] = [
    .centimetersPerSecond : String(localized: "Centimeters/Second"),
    .metersPerSecond : String(localized: "Meters/Second"),
    .kilometersPerHour : String(localized: "Kilometers/Hour"),
    .inchesPerSecond : String(localized: "Inches/Second"),
    .feetPerSecond : String(localized: "Feet/Second"),
    .milesPerHour : String(localized: "Miles/Hour"),
  ]

  private static let symbols : [SGUnitSpeed:String] = [
    .centimetersPerSecond : String(localized: "cm/s", comment: "Used for the abbreviation of centimeters per second"),
    .metersPerSecond      : String(localized: "m/s", comment: "Used for the abbreviation of meters per second"),
    .kilometersPerHour    : String(localized: "km/h", comment: "Used for the abbreviation of kilometers per hour"),
    .inchesPerSecond      : String(localized: "ips", comment: "Used for the abbreviation of inches per second"),
    .feetPerSecond        : String(localized: "ft/s", comment: "Used for the abbreviation of feet (length) per second"),
    .milesPerHour         : String(localized: "mph", comment: "Used for the abbreviation of miles per hour"),
  ]


  // MARK: Public Class Properties
  
  public static let mapPlaceholder = "%%UNIT_SPEED%%"

  // MARK: Public Class Methods
  
  // The factor to be applied to a speed in units to get a speed in cm/s.
  // This factor does not take into account the layout scale.
  public static func toCMS(units: SGUnitSpeed) -> Double {
    
    let secondsPerHour : Double = 60.0 * 60.0
    let km2cm : Double = 1000.0 * 100.0
    
    switch units {
    case .centimetersPerSecond:
      return 1.0
    case .metersPerSecond:
      return 100.0
    case .kilometersPerHour:
      return km2cm / secondsPerHour
    case .inchesPerSecond:
      return 2.54
    case .feetPerSecond:
      return 12.0 * 2.54
    case .milesPerHour:
      return (1.609344 * km2cm) / secondsPerHour
    }
        
  }
  
  // The factor to be applied to a speed in cm/s to get a speed in units.
  // This factor does not take into account the layout scale.
  public static func fromCMS(units: SGUnitSpeed) -> Double {
    return 1.0 / toCMS(units: units)
  }
  
  public static func convert(fromValue:Double, fromUnits:SGUnitSpeed, toUnits:SGUnitSpeed) -> Double {
    return fromValue * toCMS(units: fromUnits) * fromCMS(units: toUnits)
  }

  @MainActor public static func populate(comboBox: NSComboBox) {
    comboBox.removeAllItems()
    for item in SGUnitSpeed.allCases {
      comboBox.addItem(withObjectValue: item.title)
    }
  }
  
  public static func insertMap(cdi:String) -> String {
    return cdi.replacingOccurrences(of: mapPlaceholder, with: map)
  }

}

