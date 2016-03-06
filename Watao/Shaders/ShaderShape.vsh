//
//  Shader.vsh
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;
varying vec2 texCoordOut;
varying vec4 specularOut;
varying vec3 texCoordCub;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float height;
uniform float radius[50];
uniform vec3 eyePosition;
uniform vec4 specularColor;
uniform vec4 ambientColor;
uniform vec4 diffuseColor;
uniform vec4 specularColor1;
uniform vec4 ambientColor1;
uniform vec4 diffuseColor1;
uniform vec4 specularColorm;
uniform vec4 ambientColorm;
uniform vec4 diffuseColorm;
uniform int flag;

attribute vec2 texCoordIn;

void main()
{
    if(flag == 1)
    {
    vec3 lightPosition = vec3(-20.0,10.0,20.0);//vec3(1.0, -1.0, 5.0);
    float shininess = 50.0;
    //FIXME use build in parameter
    vec3 ECPosition = (modelViewProjectionMatrix*position).xyz;
    vec3 L = normalize(lightPosition - ECPosition);
    vec3 V = normalize(vec3(eyePosition.xy,4.0) - ECPosition);
    vec3 N = normalize(normalMatrix * normal);
    vec3 H = normalize((V + L));
    vec4 diffuse = diffuseColor * max(dot(N , L) , 0.0)*diffuseColorm;
    vec4 specular = specularColor * pow(max(dot(N , H) , 0.0) , shininess)*specularColorm;
        texCoordCub = reflect(V, N);
    vec3 lightPosition1 = vec3(20.0,5.0,-9.0);//vec3(1.0, -1.0, 5.0);
    //float shininess = 50.0;
    //FIXME use build in parameter
    vec3 ECPosition1 = (modelViewProjectionMatrix*position).xyz;
    vec3 L1 = normalize(lightPosition1 - ECPosition1);
    vec3 V1 = normalize(vec3(eyePosition.xy,4.0) - ECPosition1);
    vec3 N1 = normalize(normalMatrix * normal);
    vec3 H1 = normalize(V1 + L1);
    vec4 diffuse1 = diffuseColor1 * max(dot(N1 , L1) , 0.0)*diffuseColorm;
    vec4 specular1 = specularColor1 * pow(max(dot(N1 , H1) , 0.0) , shininess)*specularColorm;

    specularOut = specular+specular1;
//    colorVarying = diffuse + specular + amibientColor;
    colorVarying = (diffuse + ambientColor*ambientColorm+diffuse1+ambientColor1*ambientColorm);
//    colorVarying = diffuse;
    //calculate the right position
    gl_Position = modelViewProjectionMatrix*position;
    texCoordOut = texCoordIn;
    }
    else
    {
        vec3 lightPosition = vec3(1.0, -1.0, 5.0);
        float shininess = 50.0;
        //FIXME use build in parameter
        vec3 ECPosition = (modelViewProjectionMatrix*position).xyz;
        vec3 L = normalize(lightPosition - ECPosition);
        vec3 V = normalize(vec3(eyePosition.xy,4.0) - ECPosition);
        vec3 N = normalize(normalMatrix * normal);
        vec3 H = normalize((V + L));
        vec4 diffuse = diffuseColor * max(dot(N , L) , 0.0);
        vec4 specular = specularColor * pow(max(dot(N , H) , 0.0) , shininess);
        texCoordCub = reflect(V, N);
        specularOut = specular;
        //    colorVarying = diffuse + specular + amibientColor;
        colorVarying = (diffuse + ambientColor);
        //    colorVarying = diffuse;
        //calculate the right position
        gl_Position = modelViewProjectionMatrix*position;
        texCoordOut = texCoordIn;
    }
}
