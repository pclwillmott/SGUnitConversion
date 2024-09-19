// -----------------------------------------------------------------------------
// SGUnitFrequency.swift
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
//     19/09/2024  Paul Willmott - SGUnitFrequency.swift created
// -----------------------------------------------------------------------------

import Foundation

public enum SGUnitFrequency : UInt8, CaseIterable, Sendable {
  
  // MARK: Enumeration
  
  case hertz     = 0
  case kiloHertz = 1
  case megaHertz = 2

  // MARK: Public Properties
  
  public var title : String {
    return SGUnitFrequency.titles[self]!
  }

  public var symbol : String {
    return SGUnitFrequency.symbols[self]!
  }

  // MARK: Private Class Properties
  
  private static let titles : [SGUnitFrequency:String] = [
    .hertz     : String(localized: "Hertz"),
    .kiloHertz : String(localized: "Kilohertz"),
    .megaHertz : String(localized: "Megahertz"),
  ]

  
  private static let symbols : [SGUnitFrequency:String] = [
    .hertz     : String(localized: "Hz", comment: "Used for the abbreviation of Hertz"),
    .kiloHertz : String(localized: "kHz", comment: "Used for the abbreviation of Kilohertz"),
    .megaHertz : String(localized: "MHz", comment: "Used for the abbreviation of Megahertz"),
  ]

  private static var map : String {
    
    var map = "<map>\n"

    for item in SGUnitFrequency.allCases {
      map += "<relation><property>\(item.rawValue)</property><value>\(item.title)</value></relation>\n"
    }

    map += "</map>\n"
    
    return map
    
  }
  // MARK: Public Class Properties
  
  public static let mapPlaceholder = "%%UNIT_FREQUENCY%%"

  // MARK: Public Class Methods
  
  // The factor to be applied to a frequency in units to get a frequency in Hertz.
  public static func toHz(units: SGUnitFrequency) -> Double {
    
    switch units {
    case .hertz:
      return 1.0
    case .kiloHertz:
      return 1000.0
    case .megaHertz:
      return 1000000.0
    }
    
  }
  
  // The factor to be applied to a frequency in Hertz to get a frequency in units.
  public static func fromHz(units: SGUnitFrequency) -> Double {
    return 1.0 / toHz(units: units)
  }
  
  public static func convert(fromValue:Double, fromUnits:SGUnitFrequency, toUnits:SGUnitFrequency) -> Double {
    return fromValue * toHz(units: fromUnits) * fromHz(units: toUnits)
  }

  public static func insertMap(cdi:String) -> String {
    return cdi.replacingOccurrences(of: mapPlaceholder, with: map)
  }

}
