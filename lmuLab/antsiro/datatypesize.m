function TypeSize = datatypesize(DataType)
switch DataType,
    case {'uchar','unsigned char','schar','signed char','int8','integer*1','uint8','integer*1'},
        TypeSize = 1;
    case {'int16','integer*2','uint16','integer*2','short'},
        TypeSize = 2;
    case {'int32','integer*4','uint32','integer*4','single','real*4','float32','real*4','long'},
        TypeSize = 4;
    case {'int64','integer*8','uint64','integer*8','double','real*8','float64','real*8'},
        TypeSize = 8;
end

