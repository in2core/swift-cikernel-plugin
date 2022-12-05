//
//  QREFalseColorFilter.metal
//  Swift-CIKernel-Tests
//
//  Created by Michal Tomlein on 05/03/2020.
//  Copyright © 2020 IN2CORE. All rights reserved.
//

#include <metal_stdlib>

#include <CoreImage/CoreImage.h>

extern "C" {
    namespace coreimage {
        float4 cdl(sampler image, float4 colorBlack, float4 colorMid, float4 colorWhite, float black, float lowMid, float highMid, float white) {
            float4 p = sample(image, samplerCoord(image));
            // Convert to BW
            float p1 = p.r * 0.3 + p.g * 0.59 + p.b * 0.11;

            p.r = p1;
            p.g = p1;
            p.b = p1;
            p.a = 1.0;

            float4 res;
            res = p1 < white ? p : colorWhite;
            res = p1 <= highMid ? colorMid : res;
            res = p1 < lowMid ? p : res;
            res = p1 <= black ? colorBlack : res;

            return res;
        }
    }
}
