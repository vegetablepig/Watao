#import "WTPotteryin.h"
#include <stdlib.h>

@implementation WTPotteryin

//@synthesize vertex = _vertices;
@synthesize initRadius;
@synthesize backupHeight;
@synthesize backupRadius;

-(id)WTPotteryIH:(float)initHeight IR:(float)iR MINH:(float)minHeight MINR:(float)minRadius MAXH:(float)maxHeight MAXR:(float)maxRadius TH:(float)thickness{
    _scale = 1;
    _thickness = thickness;
    _height = initHeight;
    _vertexCount = WT_NUM_LEVEL*WT_NUM_VERTEX*2;
    _indexCount = ((WT_NUM_LEVEL-1)*WT_NUM_VERTEX*2+WT_NUM_VERTEX)*3*2;
    _vertices = (Vertex *)malloc(sizeof(Vertex)*_vertexCount);
    _indices = (GLushort *)malloc(sizeof(GLushort)*_indexCount);
    initRadius = iR;
    for (int i = 0; i < WT_NUM_LEVEL; i++) {
        _radius[i] = iR+0.12f*1-0.05;//(WT_NUM_LEVEL - i)/WT_NUM_LEVEL+0.001;
    }
    //initial the basic data of the pottery
    _boundingBox.minHeight = minHeight;
    _boundingBox.minRadius = minRadius;
    _boundingBox.maxHeight = maxHeight;
    _boundingBox.maxRadius = maxRadius;
    _boundingBox.height = initHeight;
    _boundingBox.maxRadiusNow = _radius[0];
    //initial the bounding box
    WTPotteryin *me = [self init];
    return me;
}

-(id)initFromPottery: (WTPotteryin *)p{
    if (self = [super init]) {
        _scale = 1;
        _thickness = [p getThickness];
        _height = [p getHeight];
        _vertexCount = WT_NUM_LEVEL*WT_NUM_VERTEX*2;
        _indexCount = ((WT_NUM_LEVEL-1)*WT_NUM_VERTEX*2+WT_NUM_VERTEX)*3*2;
        _vertices = (Vertex *)malloc(sizeof(Vertex)*_vertexCount);
        _indices = (GLushort *)malloc(sizeof(GLushort)*_indexCount);
        for (int i = 0; i < WT_NUM_LEVEL; i++) {
            _radius[i] = p.getRadius[i];
            _initRandSet[i] = p.getInitRandSet[i];
        }
        [self updateVertex:0]; //don't want init randSet again
        [self initIndex];
        [self initBackupRadius];
    }
    return self;
}

-(void)initBackupRadius{
    backupRadius = (float *)malloc(sizeof(float)*WT_NUM_LEVEL);
}

-(void)freeBackupRadius{
    free(backupRadius);
}

-(void)scale :(float)s{
    _scale = s;
    [self updateVertex:0];
}

-(float) getMaxRadius
{
    return _boundingBox.maxRadiusNow;
}

/**
 * initial with position and normal of the vertex
 **/

-(void)initVertex{
    float vertexMinusOne = WT_NUM_VERTEX-1;
    //in order to make a complete loop of the wrist of the pottery
    int randWidth = 10;
    //    int startRange = 1;
    float basicScale = 0.8;
    float randADelta = 0.01;
    float scaleRev = 1/(1.0f-basicScale);
    float randomDeltaR,lastRandA, lastRandB;
    int lastRandS;
    //    float lastRandomDeltaR = 0.3f*(WT_NUM_LEVEL)/WT_NUM_LEVEL+0.1;
    int randS = 0;
    float randA = ((float)rand() / RAND_MAX)/scaleRev + basicScale + randADelta;
    float randB = ((float)rand() / RAND_MAX)/scaleRev + basicScale;
    for(int i = 0; i < WT_NUM_LEVEL; i++){
        //        float randomDeltaR = ((float)rand() / RAND_MAX) - 0.3f;
        //        randomDeltaR = 0.003f*(WT_NUM_LEVEL - i)/WT_NUM_LEVEL+0.001;
        randomDeltaR = 0.0f;
        int p = i%randWidth;
        if (p==0) {
            //            lastRandomDeltaR = randomDeltaR;
            lastRandS = randS;
            lastRandA = randA;
            lastRandB = randB;
            randS = 0;
            //randA = ((float)rand() / RAND_MAX)/scaleRev + basicScale + randADelta;
            //randB = ((float)rand() / RAND_MAX)/scaleRev + basicScale;//**//随机参数待修改
        }
        float k = (sin(GLKMathDegreesToRadians((p/(float)randWidth*180.0f - 90.0f))) + 1.0f)/2.0f;
        float rs = randS*k + lastRandS*(1-k);
        float ra = lastRandA;//randA*k + lastRandA*(1-k);
        float rb = lastRandB;//randB*k + lastRandB*(1-k);
        _initRandSet[i] = GLKVector4Make(randomDeltaR, rs, ra, rb);
        //build a totally random elipse and save it to initRandSet
        for(int j = 0; j < WT_NUM_VERTEX; j++){
            int s = j+rs;
            //int rand1 = 0;
            //if (rand1>=WT_NUM_VERTEX /2 ) rand1 = WT_NUM_VERTEX - rand1;
            //if (rand1>=WT_NUM_VERTEX /4 ) rand1 = WT_NUM_VERTEX/2 - rand1;
            float r = (_radius[i]+randomDeltaR)*_scale;
            //NSLog(@"i: %d, j: %d, r: %f",i,j,r );
            //if (i == 15)NSLog(@"rand: %d", rand1);
            float y = (_height*i/WT_NUM_LEVEL)*_scale;
            float x = r*ra*cos(2.0*s*M_PI/vertexMinusOne);//**
            float z = r*rb*sin(2.0*s*M_PI/vertexMinusOne);
            _vertices[i*WT_NUM_VERTEX+j].coord=GLKVector4Make(x, y, z, 1.0f);
            //NSLog();
            _vertices[i*WT_NUM_VERTEX+j].textureCoords = GLKVector2Make((float)j*1.0f/(float)vertexMinusOne, i*1.0f/(float)WT_NUM_LEVEL);
            //put raw position data into GPU and let it calculate for me then
            float innerRadius = (_radius[i]-_thickness+randomDeltaR);
            x = innerRadius*ra*cos(2.0*s*M_PI/vertexMinusOne);
            z = innerRadius*rb*sin(2.0*s*M_PI/vertexMinusOne);
            _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX+i*WT_NUM_VERTEX+j].coord=GLKVector4Make(x, y, z, 1.0f);
            //fix it!
            _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX+i*WT_NUM_VERTEX+j].textureCoords = GLKVector2Make((float)j*1.0f/(float)vertexMinusOne, i*1.0f/(float)WT_NUM_LEVEL);
            //NSLog();
            //FIXME put right normal value into shader
        }
    }
    [self calNormalY];
}


-(void)initIndex{
    int k = WT_NUM_VERTEX*(WT_NUM_LEVEL-1)*6;
    int m = WT_NUM_LEVEL*WT_NUM_VERTEX;
    int d = WT_NUM_VERTEX*(WT_NUM_LEVEL-1);
    for(int i = 0; i < WT_NUM_LEVEL-1; i++){
        for(int j = 0; j < WT_NUM_VERTEX; j++){
            _indices[(i*WT_NUM_VERTEX+j)*6+0] = (GLushort)(i*WT_NUM_VERTEX+j);
            _indices[(i*WT_NUM_VERTEX+j)*6+1] = (GLushort)(i*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[(i*WT_NUM_VERTEX+j)*6+2] = (GLushort)((i+1)*WT_NUM_VERTEX+j);
            
            _indices[(i*WT_NUM_VERTEX+j)*6+3] = (GLushort)(i*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[(i*WT_NUM_VERTEX+j)*6+4] = (GLushort)((i+1)*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[(i*WT_NUM_VERTEX+j)*6+5] = (GLushort)((i+1)*WT_NUM_VERTEX+j);
            
            
            //initial the index of the outside triangles
            _indices[k+(i*WT_NUM_VERTEX+j)*6+0] = (GLushort)(m+i*WT_NUM_VERTEX+j);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+1] = (GLushort)(m+i*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+2] = (GLushort)(m+(i+1)*WT_NUM_VERTEX+j);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+3] = (GLushort)(m+i*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+4] = (GLushort)(m+(i+1)*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+5] = (GLushort)(m+(i+1)*WT_NUM_VERTEX+j);
            //initial the index of the inside triangles
            
        }
    }
    for (int i = 0; i < WT_NUM_VERTEX; i++){
        _indices[k*2+i*6 + 0] = (GLushort)(d+i);
        _indices[k*2+i*6 + 1] = (GLushort)(d+(i+1)%WT_NUM_VERTEX);
        _indices[k*2+i*6 + 2] = (GLushort)(m+d+i);
        _indices[k*2+i*6 + 3] = (GLushort)(d+(i+1)%WT_NUM_VERTEX);
        _indices[k*2+i*6 + 4] = (GLushort)(m+d+(i+1)%WT_NUM_VERTEX);
        _indices[k*2+i*6 + 5] = (GLushort)(m+d+i);
    }
    //initial the index of rim triangles
}

//-(void)initTexture{
//    for(int i = 0; i < WT_NUM_LEVEL; i++){
//        for(int j = 0; j < WT_NUM_VERTEX; j++){
//
//        }
//    }
//}

-(void)setFromTxt:(NSString *)txtName{
    NSStringEncoding encoding;
    NSString* content;
    NSString* path = [[NSBundle mainBundle] pathForResource:txtName ofType:@"txt"];
    if(path)
    {
        content = [NSString stringWithContentsOfFile:path  usedEncoding:&encoding  error:NULL];
        NSArray *lines =  [content componentsSeparatedByString:@"\n"];
        //        NSLog(@"%@",lines);
        //        NSLog(@"%d",lines.count);
        _height = [[lines objectAtIndex:0] floatValue];
        for (int i = 1; i < WT_NUM_LEVEL+1; i++) {
            _radius[i-1] = [[lines objectAtIndex:101-i*2] floatValue];
            //            NSLog(@"%f",[[lines objectAtIndex:i] floatValue]);
        }
    }
    //fixme bounding box not updated!!!
    _boundingBox.maxRadiusNow = [self findMaxRadiusNow];
    _boundingBox.height = _height;
    [self updateVertex:0];
    //    NSLog(@"path is %@",path);
    //    if (content)
    //    {
    //        NSLog(@" content of file is %@",content);
    //    }
    
}



-(id)init{
    if(self = [super init]){
        [self initVertex];
        [self initIndex];
        [self initBackupRadius];
        return self;
    }
    NSLog(@"initial failed!");
    return self;
}


-(GLfloat *)getRadius{
    return _radius;
}

-(int)getRadiusCount{
    return WT_NUM_LEVEL;
}

-(void)calRXYZ:(float *)r
              :(float *)x
              :(float *)y
              :(float *)z
              :(float *)ra
              :(float *)rb
              :(int)level
              :(bool)inner
              :(int)index{
    int vertexMinusOne = WT_NUM_VERTEX-1;
    float radius;
    if(!inner){
        radius = _radius[level]*_scale;
    }else{
        radius = (_radius[level]-_thickness)*_scale;
    }
    GLKVector4 temp = _initRandSet[level];
    *r = (radius + temp.x)*_scale;
    *y = _height*level/WT_NUM_LEVEL*_scale;
    *x = *r*temp.z*cos(2.0*(index+temp.y)*M_PI/vertexMinusOne);
    *z = *r*temp.w*sin(2.0*(index+temp.y)*M_PI/vertexMinusOne);
    *ra = *r*temp.z;
    *rb = *r*temp.w;
}

-(void)updateVertex:(int)touched{
    int vertexMinusOne = WT_NUM_VERTEX-1;
    //in order to make a complete loop of the wrist of the pottery
    for(int i = 0; i < WT_NUM_LEVEL; i++){
        //        float randomDeltaR = ((float)rand() / RAND_MAX) - 0.3f;
        for(int j = 0; j < WT_NUM_VERTEX; j++){
            float r,x,y,z,ra,rb;
            [self calRXYZ:&r :&x :&y :&z :&ra :&rb :i :false :j];
            _vertices[i*WT_NUM_VERTEX+j].coord=GLKVector4Make(x, y, z, 1.0f);
            //            if (j!=WT_NUM_VERTEX-1) {
            //                _vertices[i*WT_NUM_VERTEX+j].normal=GLKVector4Make(x/ra, (float)0.0f, z/rb, 1.0f);
            //            }else{
            //                _vertices[i*WT_NUM_VERTEX+j].normal=_vertices[i*WT_NUM_VERTEX].normal;
            //            }
            _vertices[i*WT_NUM_VERTEX+j].textureCoords = GLKVector2Make((float)j*1.0f/(float)vertexMinusOne, i*1.0f/(float)WT_NUM_LEVEL);
            //put raw position data into GPU and let it calculate for me then
            [self calRXYZ:&r :&x :&y :&z :&ra :&rb :i :true :j];
            _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX + i*WT_NUM_VERTEX+j].coord=GLKVector4Make(x, y, z, 1.0f);
            //            if (j!=WT_NUM_VERTEX-1) {
            //                _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX + i*WT_NUM_VERTEX+j].normal=GLKVector4Make(-x/ra, (float)0.0f, -z/rb, 1.0f);
            //            }else{
            //                _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX + i*WT_NUM_VERTEX+j].normal = _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX + i*WT_NUM_VERTEX].normal;
            //            }
            _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX+i*WT_NUM_VERTEX+j].textureCoords = GLKVector2Make((float)j*1.0f/(float)vertexMinusOne, i*1.0f/(float)WT_NUM_LEVEL);
            //FIXME put right normal value into shader
        }
    }
    [self calNormalY];
}


//fixme use precise way to calculate normal xyz
-(void)calNormalY{
    //cal the rest line
    for (int i = 0; i < WT_NUM_LEVEL; i++) {
        for(int j = 0; j < WT_NUM_VERTEX; j++){//j = 1?
            GLKVector4 pUp,pDown,pLeft,pRight;
            GLKVector4 p = _vertices[i*WT_NUM_VERTEX+j].coord;
            //specially consider the connecting point
            if (j == 0) {
                pLeft = _vertices[i*WT_NUM_VERTEX+(j+WT_NUM_VERTEX-2)%WT_NUM_VERTEX].coord;
                pRight = _vertices[i*WT_NUM_VERTEX+(j+WT_NUM_VERTEX+1)%WT_NUM_VERTEX].coord;
            }else if(j==WT_NUM_VERTEX-1){
                pLeft = _vertices[i*WT_NUM_VERTEX+(j+WT_NUM_VERTEX-1)%WT_NUM_VERTEX].coord;
                pRight = _vertices[i*WT_NUM_VERTEX+(j+WT_NUM_VERTEX+2)%WT_NUM_VERTEX].coord;
            }else{
                pLeft = _vertices[i*WT_NUM_VERTEX+(j+WT_NUM_VERTEX-1)%WT_NUM_VERTEX].coord;
                pRight = _vertices[i*WT_NUM_VERTEX+(j+WT_NUM_VERTEX+1)%WT_NUM_VERTEX].coord;
            }
            
            if (i==WT_NUM_LEVEL-1) {
                pUp = _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX+i*WT_NUM_VERTEX+j].coord;
            }else{
                pUp = _vertices[(i+1)*WT_NUM_VERTEX+j].coord;
            }
            pDown = _vertices[(i-1)*WT_NUM_VERTEX+j].coord;
            //            pLeft = _vertices[i*WT_NUM_VERTEX+(j+WT_NUM_VERTEX-1)%WT_NUM_VERTEX].coord;
            //            pRight = _vertices[i*WT_NUM_VERTEX+(j+WT_NUM_VERTEX+1)%WT_NUM_VERTEX].coord;
            //
            GLKVector4 vUp = GLKVector4Subtract(pUp, p);
            GLKVector4 vDown = GLKVector4Subtract(pDown, p);
            GLKVector4 vLeft = GLKVector4Subtract(pLeft, p);
            GLKVector4 vRight = GLKVector4Subtract(pRight, p);
            //
            GLKVector4 vUL = GLKVector4CrossProduct(vUp, vLeft);
            GLKVector4 vUR = GLKVector4CrossProduct(vRight, vUp);
            GLKVector4 vDR = GLKVector4CrossProduct(vDown, vRight);
            GLKVector4 vDL = GLKVector4CrossProduct(vLeft, vDown);
            
            _vertices[i*WT_NUM_VERTEX+j].normal = GLKVector4Normalize(GLKVector4DivideScalar(GLKVector4Add(GLKVector4Add(GLKVector4Add(vUL, vUR),vDL), vDR), -4.0f));
            //innner
            _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX + i*WT_NUM_VERTEX+j].normal = GLKVector4MultiplyScalar(_vertices[i*WT_NUM_VERTEX+j].normal,-1.0f);
        }
    }
}

-(float)gaussianDelta:(float)delta Mean:(float)mean X:(float)x{
    
    return 1.0f / delta / (float) sqrt( 2 * M_PI ) * (float) exp( - ( x - mean ) * ( x - mean ) / 2 / delta / delta );
    
}


-(void)calRaRb:(int)level :(int)touchedLevel :(float)scale{
    float ra = _initRandSet[level].z;
    float rb = _initRandSet[level].w;
    float temp = (float)atan((ra-1.0)*2.0f/M_PI);
    ra = ra-(GLfloat)temp*0.005f*[self gaussianDelta:0.4f Mean:0.0f X:0.5f*(float)(level - touchedLevel)*_height*scale/(float)WT_NUM_LEVEL];
    temp = (float)atan((rb-1.0)*2.0f/M_PI);
    rb = rb-(GLfloat)temp*0.005f*[self gaussianDelta:0.4f Mean:0.0f X:0.5f*(float)(level - touchedLevel)*_height*scale/(float)WT_NUM_LEVEL];
    _initRandSet[level].z = ra;
    _initRandSet[level].w = rb;
}

-(void)fatter:(int)level :(float)scale{
    int touchedLevel = level;
    if(_radius[touchedLevel]<_boundingBox.maxRadius && [self couldOperate:WT_OPERATION_FATTER :level :scale]){
        for(int i = 0; i < WT_NUM_LEVEL; i++){
            _radius[i] = backupRadius[i];
            [self calRaRb:i :level :scale];
            //_height*scale*(float)i/(float)WT_NUM_LEVEL - y];
        }
        _boundingBox.maxRadiusNow = [self findMaxRadiusNow];
        [self updateVertex:level];
    }
}

-(void)taller:(int)level :(float)scale{
    if(_height < _boundingBox.maxHeight && [self couldOperate:WT_OPERATION_TALLER :level :scale*5]){
        for (int i = 0; i < WT_NUM_LEVEL; i ++){
            [self calRaRb:i :level :scale*5];
        }
        _height = backupHeight;
        _boundingBox.height = _height;
        [self updateVertex:level];
    }
}


-(void)shorter:(int)level :(float)scale{
    if(_height > _boundingBox.minHeight && [self couldOperate:WT_OPERATION_SHORTER :level :scale*5]){
        for (int i = 0; i < WT_NUM_LEVEL; i ++){
            [self calRaRb:i :level :scale*5];
        }
        _height = backupHeight;
        _boundingBox.height = _height;
        [self updateVertex:level];
    }
}


-(void)thinner:(int) level
              :(float)scale{
    int touchedLevel = level;
    if(_radius[touchedLevel]>_boundingBox.minRadius && [self couldOperate:WT_OPERATION_THINNER :level :scale]){
        //touching it and it could get smaller
        for (int i = 0; i < WT_NUM_LEVEL; i ++){
            _radius[i] = backupRadius[i];
            [self calRaRb:i :level :scale];
            
        }
        _boundingBox.maxRadiusNow = [self findMaxRadiusNow];//update bounding box
        [self updateVertex:level];
    }
}

-(BOOL)couldOperate:(int)operation :(int)touchedLevel :(float)scale{
    //backup radius
    for (int i = 0; i < WT_NUM_LEVEL; i++) {
        backupRadius[i] = _radius[i];
    }
    backupHeight = _height;
    //operate on backup data
    switch (operation) {
        case WT_OPERATION_FATTER:
            for(int i = 0; i < WT_NUM_LEVEL; i++){
                float temp = (float)atan((_boundingBox.maxRadius-backupRadius[i])*2.0/M_PI);
                backupRadius[i] = backupRadius[i]+(GLfloat)temp*0.01f*[self gaussianDelta:0.2f Mean:0.0f X:(float)(i - touchedLevel)*backupHeight*scale/(float)WT_NUM_LEVEL];
            }
            break;
        case WT_OPERATION_THINNER:
            for (int i = 0; i < WT_NUM_LEVEL; i++){
                float temp = (float) atan((backupRadius[i]-_boundingBox.minRadius)*2.0f/M_PI);
                backupRadius[i] = backupRadius[i]-(GLfloat)temp*0.01f*[self gaussianDelta:0.2f Mean:0.0f X:(float)(i - touchedLevel)*backupHeight*scale/(float)WT_NUM_LEVEL];
            }
            break;
        case WT_OPERATION_TALLER:
            backupHeight+=0.005f;
            break;
        case WT_OPERATION_SHORTER:
            backupHeight-=0.005f;
            break;
        default:
            break;
    }
    //make a judgement
    /*int pTop = 0;
     int pDown = WT_NUM_LEVEL - 1;
     //find min poler point at both end
     for (int i = 0; i < WT_NUM_LEVEL - 1; i++) {
     if (backupRadius[i] < backupRadius[i+1]) {
     //from bottom
     pDown = i;
     break;
     }
     }
     for (int i = WT_NUM_LEVEL - 1; i > 0 ; i--) {
     if (backupRadius[i] < backupRadius[i-1]) {
     //from bottom
     pTop = i;
     break;
     }
     }
     NSMutableArray *minPoints = [[NSMutableArray alloc]init];
     NSMutableArray *minIndex = [[NSMutableArray alloc]init];
     NSMutableArray *maxPoints = [[NSMutableArray alloc]init];
     NSMutableArray *maxIndex = [[NSMutableArray alloc]init];
     bool findMaxPoint = true;
     [minPoints addObject:[NSNumber numberWithFloat:backupRadius[pDown]]];
     [minIndex addObject:[NSNumber numberWithInt:pDown]];
     for (int i = pDown; i < pTop; i++) {
     if (findMaxPoint) {
     //            float thres = (backupRadius[i]-[[minPoints lastObject] floatValue])/backupRadius[i];
     //            if (backupRadius[i] > backupRadius[i+1] && thres < 0.05) {
     if (backupRadius[i] > backupRadius[i+1]) {
     //find a large point
     [maxPoints addObject:[NSNumber numberWithFloat:backupRadius[i]]];
     [maxIndex addObject:[NSNumber numberWithInt:i]];
     findMaxPoint = !findMaxPoint;
     }
     }else{
     if(backupRadius[i]<backupRadius[i+1]){
     [minPoints addObject:[NSNumber numberWithFloat:backupRadius[i]]];
     [minIndex addObject:[NSNumber numberWithInt:i]];
     findMaxPoint = !findMaxPoint;
     }
     }
     }
     [minPoints addObject:[NSNumber numberWithFloat:backupRadius[pTop]]];
     [minIndex addObject:[NSNumber numberWithInt:pTop]];
     int count = 0;
     int maxBallIndex[10];
     for (int i = 0; i < maxPoints.count; i++) {
     float height = ([[maxIndex objectAtIndex:i] intValue] - [[minIndex objectAtIndex:i] intValue])*backupHeight*scale/(float)WT_NUM_LEVEL;
     float r = ([[maxPoints objectAtIndex:i] floatValue] - [[minPoints objectAtIndex:i] floatValue]);
     if (atanf(r/height)>GLKMathDegreesToRadians(1)) {
     maxBallIndex[count] = i;
     count++;
     }
     }
     if (count > 2) {
     //        NSLog(@"having more than two maxPoint");
     //        for (int i = 0; i < WT_NUM_LEVEL; i++) {
     //            NSLog(@"level %d: %f", i, backupRadius[i]);
     //        }
     //        NSLog(@"pDown: %d, pTop %d", pDown, pTop);
     //        for (NSNumber *n in maxPoints) {
     //            NSLog(@"maxPoint radius %f",[n floatValue]);
     //        }
     //        for (NSNumber *n in minPoints) {
     //            NSLog(@"minPoint radius %f",[n floatValue]);
     //        }
     //        NSLog(@"====");
     return false;
     }else if(count == 2){
     int ind0 = maxBallIndex[0];
     int ind1 = maxBallIndex[1];
     if ([maxPoints[ind0] floatValue]/[maxPoints[ind1] floatValue] < 1.4) {
     return false;
     }
     }else{
     for(int i = 0; i < maxPoints.count; i++){
     float height = ([[maxIndex objectAtIndex:i] intValue] - [[minIndex objectAtIndex:i] intValue])*backupHeight*scale/(float)WT_NUM_LEVEL;
     float rMax = [[maxPoints objectAtIndex:i] floatValue];
     float rMin = [[minPoints objectAtIndex:i] floatValue];
     if (rMax/rMin > 1.7) {
     return false;
     }else if(height/rMax < 0.6){
     //half of 3/5
     return false;
     }
     }
     
     }*/
    return true;
}

-(float) justifyY: (float)y
                 : (float)scale{
    if(y < 0){
        return 0;
    }else if(y > _height*scale){
        return _height*scale;
    }else{
        return y;
    }
}

//have rim at bottom ,top and left ,right!
-(BOOL)withinBoundingBox:(float)y
                        :(float)scale
                        :(float)distance{
    float rimWidth = WT_TOUCH_RIM_WIDTH;
    float rimHeight = WT_TOUCH_RIM_HEIGHT;
    int touchedLevel = y*WT_NUM_LEVEL/_height*scale;
    if(y<=_height*scale + rimHeight && y>=-rimHeight && _radius[touchedLevel]+rimWidth>distance){
        //enlarge the radius with rim
        return true;
    }
    else{
        return false;
    }
}

-(float)findMaxRadiusNow{
    float max = _boundingBox.minRadius;
    for(int i = 0; i < WT_NUM_LEVEL; i++){
        if(_radius[i] > max){
            max = _radius[i];
        }
    }
    return max;
}


-(BoundingBox)getBoundingBox{
    return _boundingBox;
}

-(float)getThickness{
    return _thickness;
}

-(float)getHeight{
    return _height;
}

-(GLKVector4 *)getInitRandSet{
    return _initRandSet;
}


//save to format file and read from it
-(void)saveToFile: (NSString *)fileName{
    WTPotteryData *pData = [[WTPotteryData alloc]init:fileName];
    pData.thickness = [NSNumber numberWithFloat:_thickness];
    NSMutableArray *radius = [[NSMutableArray alloc] init];
    NSMutableArray *initRandSet = [[NSMutableArray alloc] init];
    for (int i = 0; i < WT_NUM_LEVEL; i++) {
        [radius addObject:[NSNumber numberWithFloat:_radius[i]]];
        [initRandSet addObject:[NSNumber numberWithFloat:_initRandSet[i].x]];
        [initRandSet addObject:[NSNumber numberWithFloat:_initRandSet[i].y]];
        [initRandSet addObject:[NSNumber numberWithFloat:_initRandSet[i].z]];
        [initRandSet addObject:[NSNumber numberWithFloat:_initRandSet[i].w]];
    }
    pData.radius = radius;
    pData.randSet = initRandSet;
    //parameters from bounding box
    pData.maxHeight = [NSNumber numberWithFloat:_boundingBox.maxHeight];
    pData.minHeight = [NSNumber numberWithFloat:_boundingBox.minHeight];
    pData.maxRadius = [NSNumber numberWithFloat:_boundingBox.maxRadius];
    pData.minRadius = [NSNumber numberWithFloat:_boundingBox.minRadius];
    pData.height = [NSNumber numberWithFloat:_height];
    pData.maxRadiusNow = [NSNumber numberWithFloat: _boundingBox.maxRadiusNow];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* docFile = [docDir stringByAppendingPathComponent: fileName];
    [NSKeyedArchiver archiveRootObject:pData toFile:docFile];
}

-(void)loadFromFile: (NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* docFile = [docDir stringByAppendingPathComponent: fileName];
    WTPotteryData *pData = [NSKeyedUnarchiver unarchiveObjectWithFile:docFile];
    _thickness = pData.thickness.floatValue;
    for (int i = 0; i < WT_NUM_LEVEL; i++) {
        _radius[i] = ((NSNumber *)[pData.radius objectAtIndex:i]).floatValue;
        float x = ((NSNumber *)[pData.randSet objectAtIndex:4*i+0]).floatValue;
        float y = ((NSNumber *)[pData.randSet objectAtIndex:4*i+1]).floatValue;
        float z = ((NSNumber *)[pData.randSet objectAtIndex:4*i+2]).floatValue;
        float w = ((NSNumber *)[pData.randSet objectAtIndex:4*i+3]).floatValue;
        _initRandSet[i] = GLKVector4Make(x, y, z, w);
    }
    _boundingBox.maxRadiusNow = pData.maxRadiusNow.floatValue;
    _boundingBox.height = pData.height.floatValue;
    _height = pData.height.floatValue;
    _boundingBox.maxHeight = pData.maxHeight.floatValue;
    _boundingBox.minHeight = pData.minHeight.floatValue;
    _boundingBox.maxRadius = pData.maxRadius.floatValue;
    _boundingBox.minRadius = pData.minRadius.floatValue;
    [self updateVertex:0];
}

-(void)dealloc{
    free(backupRadius);
}

@end