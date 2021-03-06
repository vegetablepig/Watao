//
//  Shader.fsh
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

varying lowp vec4 colorVarying;
varying lowp vec4 specularOut;
varying lowp vec2 texCoordOut;
varying lowp vec3 texCoordCub;
uniform lowp sampler2D texture1;
//uniform lowp samplerCube textureCub;
uniform int fcube;
//this varible will be useful only when using multiple textures

void main()
{
    /*vec4 aa;
    if (fcube == 1)
    {
        aa = specularOut+colorVarying*texture2D(texture1, texCoordOut);
    }
    else 
    {
        aa = colorVarying*texture2D(texture1, texCoordOut)+specularOut;//+colorVarying*texture2D(texture, texCoordOut);
    }*/
    gl_FragColor = colorVarying*texture2D(texture1, texCoordOut)+specularOut;
}

