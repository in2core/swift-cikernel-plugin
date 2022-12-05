//
//  FalseColorFilter.swift
//  Swift-CIKernel-Tests
//
//  Created by Michal Tomlein on 05/03/2020.
//  Copyright © 2020 IN2CORE. All rights reserved.
//

import CoreImage

@objc public final class FalseColorFilter: CIFilter {

    @objc public var inputImage: CIImage?
    @objc public var inputColorBlack = CIVector(x: 0.3, y: 0.0, z: 0.3, w: 1.0)
    @objc public var inputColorMid = CIVector(x: 0.8, y: 0.4, z: 0.2, w: 1.0)
    @objc public var inputColorWhite = CIVector(x: 1.0, y: 0.0, z: 0.0, w: 1.0)
    @objc public var inputBlack: Double = 0.0
    @objc public var inputLowMid: Double = 0.0
    @objc public var inputHighMid: Double = 0.0
    @objc public var inputWhite: Double = 0.0

    @objc public var isAvailable: Bool {
        Self.kernels != nil
    }

    private struct Kernels {
        let cdl: CIKernel

        init?() {
            guard let cdl = try? CIKernel(functionName: "cdl", fromMetalLibraryData: FalseColorFilterData) else { return nil }
            self.cdl = cdl
        }
    }

    private static let kernels = Kernels()

    public override var outputImage: CIImage? {
        guard let kernels = Self.kernels else { return inputImage }
        return inputImage.flatMap { (image: CIImage) -> CIImage? in
            kernels.cdl.apply(extent: image.extent, roiCallback: { $1 }, arguments: [image, inputColorBlack, inputColorMid, inputColorWhite, inputBlack, inputLowMid, inputHighMid, inputWhite])
        } ?? inputImage
    }

}
